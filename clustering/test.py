import commands

def testHungarian():
    
    cmd = "/Users/hrakebul/Documents/code/query-performance/clustering/graph-edit-distance/scripts/qdistance-hungarian --file /Users/hrakebul/Documents/code/query-performance/clustering/graph-edit-distance/q1.sparql /Users/hrakebul/Documents/code/query-performance/clustering/graph-edit-distance/q2.sparql"
    (status,abs_query_str) = commands.getstatusoutput(cmd)
    #print abs_query_str
    if status != 0:
        print "ged error", (status,abs_query_str)
        return None
    print abs_query_str

