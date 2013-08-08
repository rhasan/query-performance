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

package com.hp.hpl.jena.tdb;

import org.apache.jena.atlas.lib.FileOps ;

public class ConfigTest
{
    // Place under target - it wil not be included in Apache source-release.
    private static final String testingDir = "target/tdb-testing" ;
    private static final String testingDirDB = "target/tdb-testing/DB" ;
    // See also "testing/Assembler/*.ttl" that uses the temp area for testing   
    
    static boolean initialized = false ; 
    
    private static void init()
    {
        if ( ! initialized )
        {
            FileOps.ensureDir("target") ;
            FileOps.ensureDir(testingDir) ;
            FileOps.ensureDir(testingDirDB) ;
        }
    }
    
    private static int count = 0 ;
    
    /** Get a empty directory name that has not been used before in this JVM */ 
    public static final String getTestingDirUnique()
    {
        init() ;
    	String dn = testingDir+"/D-"+(++count) ;
    	FileOps.ensureDir(dn) ;
    	FileOps.clearDirectory(dn) ;
    	return dn ; 
    }
    
    public static final String getTestingDir()
    {
        init() ;
        return testingDir ;
    }
    
    public static final String getTestingDirDB()
    {
        init() ;
        return testingDirDB ;
    }
    
    public static final void deleteTestingDirDB()
    {
        if ( ! FileOps.exists(testingDirDB) )
            return ;
        FileOps.clearDirectory(testingDirDB) ;
        FileOps.deleteSilent(testingDirDB) ;
    }

    public static final void deleteTestingDir()
    {
        if ( ! FileOps.exists(testingDir) )
            return ;
        deleteTestingDirDB() ;
        FileOps.clearDirectory(testingDir) ;
        FileOps.deleteSilent(testingDir) ;
    }
}
