import util
import urlparse
import time
from feature_extractor import FeatureExtractor
import csv

from SPARQLWrapper import SPARQLWrapper, JSON, SELECT

DBPEDIA_ENDPOINT = "http://dbpedia-test.inria.fr/sparql"
#DBPEDIA_ENDPOINT = "http://dbpedia.org/sparql";
TOTAL_QUERY = 100

DBPEDIA_QUERY_LOG = "dbp-200.log"

class QueryProcessor:
    
    def load_queries(self):
        f = open(DBPEDIA_QUERY_LOG,'rb')
        fq = open("x_query.txt",'w')
        ft = open("y_time.txt",'w')
        ff = open("x_features.txt",'w')
        x_f_csv = csv.writer(ff)
        sparql = SPARQLWrapper(DBPEDIA_ENDPOINT)
        f_extractor = FeatureExtractor()

        count =0 
        for line in f:
            if(count>=TOTAL_QUERY):
                break

            try:
                row = line.split()
                query_log = row[6][1:-1]
                #print query_log
                par = urlparse.parse_qs(urlparse.urlparse(query_log).query)
                #util.url_decode(row[6])
                sparql_query = par['query'][0]

                
                

                if sparql._parseQueryType(sparql_query) != SELECT:
                    continue
                feature_vector = f_extractor.get_features(sparql_query)

                if feature_vector == None:
                    continue



                sparql.setQuery(sparql_query)
                sparql.setReturnFormat(JSON)

                start = time.time()
                results = sparql.query().convert()
                elapsed = (time.time() - start)

                result_rows = len(results["results"]["bindings"])

                # if result_rows == 0:
                #     continue

                # print "QUERY =", sparql_query
                # print "feature vector:",feature_vector
                # print elapsed, "seconds"                
                # print results
                # print "rows", result_rows
                # print "-----------------------"

                fq.write(query_log+'\n')
                ft.write(str(elapsed)+'\n')
                x_f_csv.writerow(feature_vector)
            except Exception as inst:
                print "Exception", inst

            count += 1
        
        f.close()
        fq.close()
        ft.close()
        ff.close()
    

def main():
    print "hello"
    url = 'http://example.com/?q=abc&p=123'
    par = urlparse.parse_qs(urlparse.urlparse(url).query)

    print par['q'], par['p']
    


    qp = QueryProcessor()
    qp.load_queries()


if __name__ == "__main__":
    main()