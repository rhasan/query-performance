/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.jena.larq.assembler;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;

import org.apache.jena.larq.ARQLuceneException;
import org.apache.jena.larq.IndexBuilderModel;
import org.apache.jena.larq.IndexBuilderString;
import org.apache.jena.larq.IndexLARQ;
import org.apache.jena.larq.IndexWriterFactory;
import org.apache.jena.larq.LARQ;
import org.apache.lucene.index.CorruptIndexException;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.store.LockObtainFailedException;
import org.apache.lucene.store.RAMDirectory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.hp.hpl.jena.assembler.Assembler;
import com.hp.hpl.jena.assembler.Mode;
import com.hp.hpl.jena.assembler.assemblers.AssemblerBase;
import com.hp.hpl.jena.assembler.exceptions.AssemblerException;
import com.hp.hpl.jena.query.Dataset;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.rdf.model.StmtIterator;
import com.hp.hpl.jena.sparql.util.graph.GraphUtils;

public class AssemblerLARQ extends AssemblerBase implements Assembler
{
    /** Vocabulary
     *     ja:textIndex ....
     */

    private static final Logger log = LoggerFactory.getLogger(AssemblerLARQ.class);
    
    static { LARQ.init(); }
    
    @Override
    public Object open(Assembler a, Resource root, Mode mode)
    {
        LARQ.init();

        if ( ! GraphUtils.exactlyOneProperty(root, LARQAssemblerVocab.pIndex) )
            throw new AssemblerException(root, "Required: exactly one index property" ) ;

        try
        {
            String indexPath = GraphUtils.getAsStringValue(root, LARQAssemblerVocab.pIndex) ;
            return make(null, indexPath) ;
        } catch (Exception ex)
        {
            throw new ARQLuceneException("Failed to assemble Lucene index", ex) ;
        }
    }
    
    public static IndexLARQ make (Dataset dataset, String indexPath) throws CorruptIndexException, IOException 
    {
        Directory directory;
        if ( indexPath != null ) 
        {
            File path = new File(indexPath) ;
            if ( !path.exists() ) 
            {
                log.debug("Directory {} does not exist, building Lucene index...") ;
                path.mkdirs() ;
                build ( dataset, path ) ;
            }
            directory = FSDirectory.open(path);
        } else {
            directory = new RAMDirectory();
        }
        IndexReader indexReader = null;
        IndexLARQ indexLARQ = null;
        if ( dataset != null ) 
        {
            try 
            {
                IndexWriter indexWriter = IndexWriterFactory.create(directory);
                IndexBuilderModel larqBuilder = new IndexBuilderString(indexWriter) ; 
                dataset.getDefaultModel().register(larqBuilder);
                for ( Iterator<String> iter = dataset.listNames() ; iter.hasNext() ; ) {
                    String g = iter.next() ;
                    dataset.getNamedModel(g).register(larqBuilder) ;
                }
                indexLARQ = new IndexLARQ(indexWriter) ;
            } catch (LockObtainFailedException e) {
                log.warn("Someone else has a lock on the Lucene index, falling back to read-only mode.");
            }
        } 
        
        if ( indexLARQ == null ) 
        {
            indexReader = IndexReader.open(directory) ; // read-only
            indexLARQ = new IndexLARQ(indexReader) ;
        }

        LARQ.setDefaultIndex(indexLARQ) ;
        return indexLARQ ;
    }

    private static void build (Dataset dataset, File path)
    {
        Directory directory = null ;
        IndexWriter indexWriter = null ;
        IndexBuilderModel larqBuilder = null ;
        try {
            directory = FSDirectory.open(path) ;
            indexWriter = IndexWriterFactory.create(directory);
            larqBuilder = new IndexBuilderString(indexWriter) ;
            larqBuilder.setAvoidDuplicates(false) ;
            index(larqBuilder, dataset.getDefaultModel()) ;
            for ( Iterator<String> iter = dataset.listNames() ; iter.hasNext() ; )
            {
                String g = iter.next() ;
                index(larqBuilder, dataset.getNamedModel(g)) ;
            }
        } catch (Exception e) {
            log.warn("Exception building the index: {}", e.getMessage()) ;
        } finally {
            if ( larqBuilder != null) larqBuilder.closeWriter() ;
            if ( directory != null ) try { directory.close() ; } catch (IOException e) { log.warn("Problems closing the Lucene directory.") ; }
        }
    }

    private static void index(IndexBuilderModel larqBuilder, Model model)
    {
        StmtIterator sIter = model.listStatements() ;
        larqBuilder.indexStatements(sIter) ;
    }

}
