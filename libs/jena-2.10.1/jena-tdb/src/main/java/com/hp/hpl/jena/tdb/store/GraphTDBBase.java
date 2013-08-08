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

package com.hp.hpl.jena.tdb.store;

import static com.hp.hpl.jena.sparql.core.Quad.isUnionGraph ;

import java.util.Iterator ;

import org.apache.jena.atlas.iterator.Iter ;
import org.apache.jena.atlas.lib.Tuple ;
import org.slf4j.Logger ;

import com.hp.hpl.jena.graph.BulkUpdateHandler ;
import com.hp.hpl.jena.graph.Capabilities ;
import com.hp.hpl.jena.graph.GraphEvents ;
import com.hp.hpl.jena.graph.Node ;
import com.hp.hpl.jena.graph.TransactionHandler ;
import com.hp.hpl.jena.graph.Triple ;
import com.hp.hpl.jena.graph.TripleMatch ;
import com.hp.hpl.jena.graph.impl.GraphBase ;
import com.hp.hpl.jena.sparql.core.Quad ;
import com.hp.hpl.jena.tdb.TDB ;
import com.hp.hpl.jena.tdb.TDBException ;
import com.hp.hpl.jena.tdb.graph.BulkUpdateHandlerTDB ;
import com.hp.hpl.jena.tdb.graph.TransactionHandlerTDB ;
import com.hp.hpl.jena.tdb.lib.NodeFmtLib ;
import com.hp.hpl.jena.tdb.nodetable.NodeTupleTable ;
import com.hp.hpl.jena.tdb.sys.SystemTDB ;
import com.hp.hpl.jena.util.iterator.ExtendedIterator ;
import com.hp.hpl.jena.util.iterator.WrappedIterator ;

/** General operations for TDB graphs (free-standing graph, default graph and named graphs) */
public abstract class GraphTDBBase extends GraphBase implements GraphTDB
{
    private final TransactionHandler transactionHandler = new TransactionHandlerTDB(this) ;
    private final BulkUpdateHandler bulkUpdateHandler = new BulkUpdateHandlerTDB(this) ;
    protected final DatasetGraphTDB dataset ;
    protected final Node graphNode ;

    public GraphTDBBase(DatasetGraphTDB dataset, Node graphName)
    { 
        super() ;
        this.dataset = dataset ; 
        this.graphNode = graphName ;
    }
    
    @Override
    public final Node getGraphNode()                            { return graphNode ; }
    
    @Override
    public final DatasetGraphTDB getDataset()                   { return dataset ; }

    // Intercept performAdd/preformDelete and bracket in start/finish markers   
    
    @Override
    public final void performAdd(Triple triple)
    { 
        // Should we do try{}finally{}?
        // Here, no, if there is an exeception, the database is bad. 
        startUpdate() ;
        _performAdd(triple) ;
        finishUpdate() ;
    }

    @Override
    public final void performDelete(Triple triple)
    {
        startUpdate() ;
        _performDelete(triple) ;
        finishUpdate() ;
    }
    
    @Override
    protected final ExtendedIterator<Triple> graphBaseFind(TripleMatch m)
    {
        // Explicitly named default graph
        if ( isDefaultGraph(graphNode) )
            // Default graph.
            return graphBaseFindDft(getDataset(), m) ;
        // Includes union graph
        return graphBaseFindNG(getDataset(), graphNode, m) ;
    }
    
    protected final void _performAdd( Triple t ) 
    {
        if ( isUnionGraph(graphNode) )
            throw new TDBException("Can't add a triple to the RDF merge of all named graphs") ;
        dataset.add(graphNode(), t.getSubject(), t.getPredicate(), t.getObject()) ;
    }
 
    protected final void _performDelete( Triple t ) 
    { 
        if ( isUnionGraph(graphNode) )
            throw new TDBException("Can't delete triple from the RDF merge of all named graphs") ;
        dataset.delete(graphNode(), t.getSubject(), t.getPredicate(), t.getObject()) ;
    }
    
    @Override
    public final void sync()        { dataset.sync(); }
    
    @Override
    final public void close()       { sync() ; }
    
    @Override
    // make submodels think about this.
    public abstract String toString() ;
    
    private Node graphNode() { return ( graphNode != null ) ? graphNode : Quad.defaultGraphNodeGenerated ; }

    protected static boolean isDefaultGraph(Node g)
    {
        return g == null || Quad.isDefaultGraph(g) ; 
    }
    
    protected void duplicate(Triple t)
    {
        if ( TDB.getContext().isTrue(SystemTDB.symLogDuplicates) && getLog().isInfoEnabled() )
        {
            String $ = NodeFmtLib.displayStr(t, this.getPrefixMapping()) ;
            getLog().info("Duplicate: ("+$+")") ;
        }
    }
    
    protected static ExtendedIterator<Triple> graphBaseFindDft(DatasetGraphTDB dataset, TripleMatch m)
    {
        Iterator<Quad> iterQuads = dataset.find(Quad.defaultGraphIRI, m.getMatchSubject(), m.getMatchPredicate(), m.getMatchObject()) ;
        if ( iterQuads == null )
            return com.hp.hpl.jena.util.iterator.NullIterator.instance() ;
        // Can't be duplicates - fixed graph node..
        Iterator<Triple> iterTriples = new ProjectQuadsToTriples(Quad.defaultGraphIRI , iterQuads) ;
        return WrappedIterator.createNoRemove(iterTriples) ;
    }
    
    protected static ExtendedIterator<Triple> graphBaseFindNG(DatasetGraphTDB dataset, Node graphNode, TripleMatch m)
    {
        Node gn = graphNode ;
        // Explicitly named union graph. 
        if ( isUnionGraph(gn) )
            gn = Node.ANY ;

        Iterator<Quad> iter = dataset.getQuadTable().find(gn, m.getMatchSubject(), m.getMatchPredicate(), m.getMatchObject()) ;
        if ( iter == null )
            return com.hp.hpl.jena.util.iterator.NullIterator.instance() ;
        
        Iterator<Triple> iterTriples = new ProjectQuadsToTriples((gn == Node.ANY ? null : gn) , iter) ;
        
        if ( gn == Node.ANY )
            iterTriples = Iter.distinct(iterTriples) ;
        return WrappedIterator.createNoRemove(iterTriples) ;
    }
    
    protected abstract Logger getLog() ;
    
    /** Iterator over something that, when counted, is the graph size. */
    protected abstract Iterator<?> countThis() ;

    public void startRead()             { dataset.startRead() ; }
    public void finishRead()            { dataset.finishRead() ; }

    public final void startUpdate()     { dataset.startUpdate() ; }
    public final void finishUpdate()    { dataset.finishUpdate() ; }

    @Override
    protected final int graphBaseSize()
    {
        Iterator<?> iter = countThis() ;
        return (int)Iter.count(iter) ;
    }
    
    // Convert from Iterator<Quad> to Iterator<Triple>
    static class ProjectQuadsToTriples implements Iterator<Triple>
    {
        private final Iterator<Quad> iter ;
        private final Node graphNode ;
        /** Project quads to triples - check the graphNode is as expected if not null */
        ProjectQuadsToTriples(Node graphNode, Iterator<Quad> iter) { this.graphNode = graphNode ; this.iter = iter ; }
        @Override
        public boolean hasNext() { return iter.hasNext() ; }
        
        @Override
        public Triple next()
        { 
            Quad q = iter.next();
            if ( graphNode != null && ! q.getGraph().equals(graphNode))
                throw new InternalError("ProjectQuadsToTriples: Quads from unexpected graph (expected="+graphNode+", got="+q.getGraph()+")") ;
            return q.asTriple() ;
        }
        @Override
        public void remove() { iter.remove(); }
    }
    
    @Deprecated
    @Override
    public BulkUpdateHandler getBulkUpdateHandler() { return bulkUpdateHandler ; }

    @Override
    public Capabilities getCapabilities()
    {
        if ( capabilities == null )
            capabilities = new Capabilities(){
                @Override
                public boolean sizeAccurate() { return true; }
                @Override
                public boolean addAllowed() { return true ; }
                @Override
                public boolean addAllowed( boolean every ) { return true; } 
                @Override
                public boolean deleteAllowed() { return true ; }
                @Override
                public boolean deleteAllowed( boolean every ) { return true; } 
                @Override
                public boolean canBeEmpty() { return true; }
                @Override
                public boolean iteratorRemoveAllowed() { return false; } /* ** */
                @Override
                public boolean findContractSafe() { return true; }
                @Override
                public boolean handlesLiteralTyping() { return false; } /* ** */
            } ; 
        
        return super.getCapabilities() ;
    }
    
    @Override
    public TransactionHandler getTransactionHandler()
    { return transactionHandler ; }

    @Override
    public void clear()
    {
        removeWorker(this, Node.ANY, Node.ANY, Node.ANY) ;
        getEventManager().notifyEvent(this, GraphEvents.removeAll ) ;   
    }
    
    @Override
    public void remove( Node s, Node p, Node o )
    {
        if ( getEventManager().listening() )
        {
            // Have to do it the hard way so that triple events happen.
            super.remove(s, p, o) ;
            return ;
        }
        
        removeWorker(this, s, p, o) ;
        // We know no one is listening ...
        //getEventManager().notifyEvent(this, GraphEvents.remove(s, p, o) ) ;
    }

    
    private static final int sliceSize = 1000 ;

    public static void removeWorker(GraphTDBBase g, Node s, Node p, Node o)
    {
        g.startUpdate() ;
        
        // Delete in batches.
        // That way, there is no active iterator when a delete 
        // from the indexes happens.
        
        NodeTupleTable t = g.getNodeTupleTable() ;
        Node gn = g.getGraphNode() ;
        
        @SuppressWarnings("unchecked")
        Tuple<NodeId>[] array = (Tuple<NodeId>[])new Tuple<?>[sliceSize] ;
        
        while (true)
        {
            // Convert/cache s,p,o?
            // The Node Cache will catch these so don't worry unduely. 
            Iterator<Tuple<NodeId>> iter = null ;
            if ( gn == null )
                iter = t.findAsNodeIds(s, p, o) ;
            else
                iter = t.findAsNodeIds(gn, s, p, o) ;
            
            if ( iter == null )
                // Finished?
                return ;
            
            // Get a slice
            int len = 0 ;
            for ( ; len < sliceSize ; len++ )
            {
                if ( !iter.hasNext() ) break ;
                array[len] = iter.next() ;
            }
            
            // Delete them.
            for ( int i = 0 ; i < len ; i++ )
            {
                t.getTupleTable().delete(array[i]) ;
                array[i] = null ;
            }
            // Finished?
            if ( len < sliceSize )
                break ;
        }
        
        g.finishUpdate() ;
    }

}
