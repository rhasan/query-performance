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

package com.hp.hpl.jena.tdb.base.file;

import java.io.File;
import java.io.IOException ;

import org.apache.jena.atlas.lib.Lib ;

import com.hp.hpl.jena.tdb.sys.Names;

/** 
 *  Wrapper for a file system directory; can create filenames in that directory.
 *  Enforces some simple consistency policies and provides a
 *  "typed string" for a filename to reduce errors.
 */   
 
public class Location
{
    static String pathSeparator = File.separator ;  // Or just "/"
    
    private String pathname ;
    private MetaFile metafile = null ; 
    private boolean isMem = false ;
    private boolean isMemUnique = false ;
    
    static int memoryCount = 0 ; 
    
    /** Return a fresh memory location : always unique, never .equals to another location. */  
    static public Location mem() { return mem(null) ; }
    
    /** Return a memory location with a name */  
    static public Location mem(String name)
    { 
        Location loc = new Location();
        memInit(loc, name) ;
        return loc ;
    }
    
    private Location()
    { }
    
    private static void memInit(Location location, String name)
    {
        location.pathname = Names.memName ;
        if ( name != null )
        {
            name = name.replace('\\', '/') ;
            location.pathname = location.pathname+'/'+name ;
        }
        else
            location.isMemUnique = true ;
        if ( ! location.pathname.endsWith(pathSeparator) )
            location.pathname = location.pathname+'/' ;
        location.isMem = true ;
        location.metafile = new MetaFile(Names.memName, Names.memName) ;
    }
    
    public Location(String rootname)
    { 
        super() ;
        if ( rootname.equals(Names.memName) )
        {
            memInit(this, null) ;
            return ;
        }
        
        File file = new File(rootname) ;
        
        if ( ! file.exists() )
        {
            file.mkdir() ;
            //throw new FileException("Not found: "+file.getAbsolutePath()) ;
        }
        else if ( ! file.isDirectory() )
            throw new FileException("Not a directory: "+file.getAbsolutePath()) ;

        // MS Windows:
        // getCanonicalPath is only good enough for existing files.
        // It leaves the case as it finds it (upper, lower) and lower cases
        // not-existing segments.  But later creation of a segment with uppercase
        // changes the exact string returned. 
        
        try { pathname = file.getCanonicalPath() ; }
        catch (IOException ex) { throw new FileException("Failed to get canoncial path: "+file.getAbsolutePath(), ex) ; } 
        
        if ( ! pathname.endsWith(File.separator) && !pathname.endsWith(pathSeparator) )
            pathname = pathname + pathSeparator ;
        
        // Metafilename for a directory.
        String metafileName = getPath(Names.directoryMetafile, Names.extMeta) ;
        
        metafile = new MetaFile("Location: "+rootname, metafileName) ;
    }        

    public String getDirectoryPath()    { return pathname ; }
    public MetaFile getMetaFile()       { return metafile ; }
    public boolean isMem()              { return isMem ; } 
    public boolean isMemUnique()        { return isMemUnique ; }
    
    public Location getSubLocation(String dirname)
    {
        String newName = pathname+dirname ;
        File file = new File(newName) ;
        if ( file.exists() && ! file.isDirectory() )
            throw new FileException("Existing file: "+file.getAbsolutePath()) ;
        if ( ! file.exists() )
            file.mkdir() ;
        
        return new Location(newName) ;
    }

    public String getSubDirectory(String dirname)
    {
        return getSubLocation(dirname).getDirectoryPath() ;
    }

    /** Return an absolute filename where relative names are resolved from the location */ 
    public String absolute(String filename, String extension)
    { 
        return (extension == null) ? absolute(filename) : absolute(filename+"."+extension) ;
    }
    
    /** Return an absolute filename where relative names are resolved from the location */ 
    public String absolute(String filename)
    {
        File f = new File(filename) ;
        // Location relative.
        if ( ! f.isAbsolute() )
            filename = pathname+filename ;
        return filename ;
    }
 
    /** Does the location exist (and it a directory, and is accessible) */
    public boolean exists()
    { 
        File f = new File(getDirectoryPath()) ;
        return f.exists() && f.isDirectory() && f.canRead() ;
    }
    
    public boolean exists(String filename) { return exists(filename, null) ; }
    
    public boolean exists(String filename, String ext)
    {
        String fn = getPath(filename, ext) ;
        File f = new File(fn) ;
        return f.exists() ;
    }

    /** Return the name of the file relative to this location */ 
    public String getPath(String filename)
    {
        return getPath(filename, null) ;
    }
    
    /** Return the name of the file, and extension, relative to this location */ 
    public String getPath(String filename, String ext)
    {
        check(filename, ext) ;
        if ( ext == null )
            return pathname+filename ;
        return pathname+filename+"."+ext ;
    }

    private void check(String filename, String ext)
    {
        if ( filename == null )
            throw new FileException("Location: null filename") ;
        if ( filename.contains("/") || filename.contains("\\") )
            throw new FileException("Illegal file component name: "+filename) ;
        if ( filename.contains(".") && ext != null )
            throw new FileException("Filename has an extension: "+filename) ;
        if ( ext != null )
        {
            if ( ext.contains(".") )
                throw new FileException("Extension has an extension: "+filename) ;
        }
    }
    
    @Override
    public int hashCode()
    {
        final int prime = 31 ;
        int result = isMem ? 1 : 2 ;
        result = prime * result + ((pathname == null) ? 0 : pathname.hashCode()) ;
        return result ;
    }

    @Override
    public boolean equals(Object obj)
    {
        if (this == obj) return true ;
        if (obj == null) return false ;
        if (getClass() != obj.getClass()) return false ;
        
        Location other = (Location)obj ;
        if ( isMem && ! other.isMem ) return false ; 
        if ( ! isMem && other.isMem ) return false ; 

        return Lib.equal(pathname, other.pathname) ;
    }

    @Override
    public String toString() { return "location:"+pathname ; }
}
