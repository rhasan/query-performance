import numpy as np
import glob
import gzip
import random

TOTAL_QUERIES = 40000
OUTPUT_FILE = "dbp-"+str(TOTAL_QUERIES)+"-random.log"

def queries_in_file(file_name):
    f = gzip.open(file_name, 'rb')

    q_list = list()
    count = 0
    for line in f:
        #print line
        # if count>10:
        #     break
        q_list.append(line)
        count += 1
    f.close()    
    random.shuffle(q_list)
    return q_list

def randon_queries():
    mypath = "/Users/hrakebul/Documents/code/sssw/dbpedia-3.8-logs"
    file_list = glob.glob(mypath+"/*.gz")
    total_files = len(file_list)
    queries_per_file = int((TOTAL_QUERIES/total_files)+0.5)

    print total_files
    print queries_per_file
        
    random.shuffle(file_list)

    all_queries = list()

    for file_name in file_list:
        print "Processing",file_name
        q_list = queries_in_file(file_name)
        #randomize
        all_queries.extend(q_list[0:queries_per_file])

    
    tot = len(all_queries)
    if tot != TOTAL_QUERIES:
        random.shuffle(file_list)
        more = abs(tot - TOTAL_QUERIES)
        #print more
        q_list = queries_in_file(file_list[0])
        all_queries.extend(q_list[0:more])
    
    random.shuffle(all_queries)
    
    
    fq = open(OUTPUT_FILE,'w')
    for x in all_queries:
        fq.write(x)
        #print x

    fq.close()

    print len(all_queries)


def main():
    randon_queries()
    
if __name__ == "__main__":
    main()
