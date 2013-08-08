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

package org.apache.jena.larq.examples;


import org.apache.jena.larq.IndexBuilderString;
import org.apache.jena.larq.IndexLARQ;
import org.apache.jena.atlas.lib.StrUtils;

import com.hp.hpl.jena.query.ARQ;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.sparql.util.Utils;
import com.hp.hpl.jena.util.FileManager;
import com.hp.hpl.jena.vocabulary.DC;

/** Example code to load a model from a file, index string literals on the DC title property, 
 * then execute a SPARQL query with a Lucene search in it.
 */

public class ExLucene3
{
    
    public static void main(String[] a) throws Exception
    {
        System.out.println("ARQ Example: "+Utils.classShortName(ExLucene3.class)) ;
        System.out.println("ARQ: "+ARQ.VERSION) ;
        System.out.println() ;
        
        Model model = ModelFactory.createDefaultModel() ;
        IndexLARQ index = buildTitleIndex(model,  "src/test/resources/LARQ/data-1.ttl") ;
        
        // Search for string 
        String searchString = "+document" ;
        
        // This time, find documents with a matching DC title. 
        String queryString = StrUtils.strjoin("\n", 
            "PREFIX pf:     <http://jena.hpl.hp.com/ARQ/property#>",
            "PREFIX xsd:    <http://www.w3.org/2001/XMLSchema#>" ,
            "PREFIX dc:     <http://purl.org/dc/elements/1.1/>",
            "PREFIX :       <http://example/>" ,
            "SELECT ?title {" ,
            "    ?title pf:textMatch '"+searchString+"'.",
            "}") ;
        
        // Two of three documents should match. 
        ExLucene1.performQuery(model, index, queryString) ;
        index.close() ;
    }
    
    static IndexLARQ buildTitleIndex(Model model, String datafile)
    {
        // ---- Read and index just the title strings.
        IndexBuilderString larqBuilder = new IndexBuilderString(DC.title) ;
        
        // Index statements as they are added to the model.
        model.register(larqBuilder) ;
        
        // To just build the index, create a model that does not store statements 
        // Model model2 = ModelFactory.createModelForGraph(new GraphSink()) ;
        
        FileManager.get().readModel(model, datafile) ;
        
        // ---- Alternatively build the index after the model has been created. 
        // larqBuilder.indexStatements(model.listStatements()) ;
        
        // ---- Finish indexing
        larqBuilder.closeWriter() ;
        model.unregister(larqBuilder) ;
        
        // ---- Create the access index  
        IndexLARQ index = larqBuilder.getIndex() ;
        return index ; 
    }

}
