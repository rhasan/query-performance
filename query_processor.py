import util
import urlparse
import time
from feature_extractor import FeatureExtractor
import csv
from stopwatch import StopWatch
from SPARQLWrapper import SPARQLWrapper, JSON, SELECT

#DBPEDIA_ENDPOINT = "http://alphubel.unice.fr:8890/sparql"
DBPEDIA_ENDPOINT = "http://dbpedia-test.inria.fr/sparql"
#DBPEDIA_ENDPOINT = "http://dbpedia.org/sparql"
TOTAL_QUERY = 1000
#TOTAL_QUERY = 100
DBPEDIA_QUERY_LOG = "dbp-10000.log"

class QueryProcessor:
    
    def load_queries(self):

        data_split = int(TOTAL_QUERY*0.6)
        validation_split = int(TOTAL_QUERY*0.2)
        test_split = int(TOTAL_QUERY*0.2)
        print "data_split", data_split
        print "validation_split", validation_split
        print "test_split", test_split

        f = open(DBPEDIA_QUERY_LOG,'rb')
        fq = open("x_query.txt",'w')
        ft = open("y_time.txt",'w')
        ff = open("x_features.txt",'w')
        x_f_csv = csv.writer(ff)
        sparql = SPARQLWrapper(DBPEDIA_ENDPOINT)
        f_extractor = FeatureExtractor()
        sw1 = StopWatch()
        sw2 = StopWatch()
        print_log_split = int(TOTAL_QUERY/10)

        count =0 
        for line in f:
            if count%print_log_split==0:
                print count," queries processed in ",sw2.elapsed_seconds()," seconds"
        
            if(count>=TOTAL_QUERY):
                break

            if count == data_split:
                fq.close()
                ft.close()
                ff.close()
                fq = open("xval_query.txt",'w')
                ft = open("yval_time.txt",'w')
                ff = open("xval_features.txt",'w')
                x_f_csv = csv.writer(ff)
            elif count == (data_split+validation_split):
                fq.close()
                ft.close()
                ff.close()
                fq = open("xtest_query.txt",'w')
                ft = open("ytest_time.txt",'w')
                ff = open("xtest_features.txt",'w')
                x_f_csv = csv.writer(ff)


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
                    print "feature vector not found"
                    continue



                sparql.setQuery(sparql_query)
                sparql.setReturnFormat(JSON)

                sw1.reset()
                results = sparql.query().convert()
                elapsed = sw1.elapsed_milliseconds()

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
                count += 1
            except Exception as inst:
                print "Exception", inst

            
        
        f.close()
        fq.close()
        ft.close()
        ff.close()
        print count, "queries processed"

    

def main():
    print "hello"
    url = 'http://example.com/?q=abc&p=123'
    par = urlparse.parse_qs(urlparse.urlparse(url).query)

    print par['q'], par['p']
    


    qp = QueryProcessor()
    qp.load_queries()


if __name__ == "__main__":
    main()
