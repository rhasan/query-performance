/*
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

package com.hp.hpl.jena.assembler.assemblers;

import com.hp.hpl.jena.assembler.*;
import com.hp.hpl.jena.ontology.OntDocumentManager;
import com.hp.hpl.jena.rdf.model.*;
import com.hp.hpl.jena.util.*;

public class DocumentManagerAssembler extends AssemblerBase 
    {    
    @Override
    public Object open( Assembler a, Resource root, Mode irrelevant )
        { 
        checkType( root, JA.DocumentManager );
        OntDocumentManager result = createDocumentManager();
        result.setMetadataSearchPath( getPath( a, root ), false );
        result.configure( ResourceUtils.reachableClosure( root ), false );
        result.setFileManager( getFileManager( a, root ) );
        return result;
        }

    private String getPath( Assembler a, Resource root )
        {
        String s = getUniqueString( root, JA.policyPath );
        return s == null ? OntDocumentManager.DEFAULT_METADATA_PATH : s;
        }

    private FileManager getFileManager( Assembler a, Resource root )
        {
        Resource fm = getUniqueResource( root, JA.fileManager );
        return fm == null ? FileManager.get() : (FileManager) a.open( fm );
        }
    
    /**
        Tests may subclass and override to supply testable objects.
    */
    protected OntDocumentManager createDocumentManager()
        { return new OntDocumentManager( "" ); }
    }
