import re
import commands
from os.path import expanduser
HOME = expanduser("~")

COUNT_FEATURES_FILE = 'count_feature_list.txt'
VALUE_FEATURE_FILE = 'value_feature_list.txt'
JENA_PARSER = HOME+"/Documents/code/query-performance/libs/apache-jena-2.10.1/bin/qparse"
DBP_PREFIX_FILE = "dbpedia_prefix.sparql"

class FeatureExtractor:
    def __init__(self):
        count_features_f = open(COUNT_FEATURES_FILE,'rb')
        value_features_f = open(VALUE_FEATURE_FILE,'rb')

        self.count_feature_list = list()
        for cf in count_features_f:
            count_feature = cf.rstrip('\n')
            if count_feature=="": continue
            #print "["+ count_feature+"]"
            self.count_feature_list.append(count_feature)

        self.value_feature_list = list()
        for vf in value_features_f:
            value_feature = vf.rstrip('\n')
            if value_feature=="": continue
            #print "["+ value_feature+"]"
            self.value_feature_list.append(value_feature)



        self.dbpedia_prefix = ""
        dbp_prefix_f = open(DBP_PREFIX_FILE,'rb')

        for pref in dbp_prefix_f:
            self.dbpedia_prefix += pref

        #self.dbpedia_prefix = self.dbpedia_prefix.replace('\n',' ').replace('\r','')
        dbp_prefix_f.close()
        count_features_f.close()
        value_features_f.close() 

    def get_dbp_sparql(self,query_str):
        q = self.dbpedia_prefix.replace('\n',' ').replace('\r','')+" "+query_str.replace('\n',' ').replace('\r','')
        #q = q.replace("'",'"') # to makesure a single string is passed in jena commandline parser
        return q

    def get_features(self,query_str):

        tmp_q_file = "tmp_q_file~"
        #print query_str
        #to add the dbpedia prefixes
        #dbp_query = self.get_dbp_sparql(query_str)
        #not adding the dbpedia prefixes
        dbp_query = query_str
        tq = open(tmp_q_file,'w')
        tq.write(dbp_query)
        tq.close()

        #cmd = JENA_PARSER + " --print=op '"+dbp_query+"'"
        cmd = JENA_PARSER + " --print=op --file="+tmp_q_file
        #print cmd
        (status,abs_query_str) = commands.getstatusoutput(cmd)
        #print abs_query_str
        if status != 0:
            #error = "jena query parsing error: "+str(status)+" "+abs_query_str + " query:"+dbp_query
            error = "jena query parsing error: "+str(status)
            #print "jena query parsing error:", (status,abs_query_str), "query:",dbp_query
            raise Exception(error)
            return None
        
        abs_query_str = abs_query_str.replace('\n',' ').replace('\r','')
        
        feature_vector = list()
        for count_feature in self.count_feature_list:
            f_count = self.get_feature_count(abs_query_str,count_feature)
            feature_vector.append(f_count)

        for value_feature in self.value_feature_list:
            f_val = self.get_feature_values(abs_query_str,value_feature)
            feature_vector.append(f_val)

        #print "feature count:", f_count
        
        #print "feature value:", f_val
        #print feature_vector

        return feature_vector

    def get_feature_values(self,abs_query_str,feature):
        expr = r''+feature+'\s_\s(\d+)\s'
        #print expr
        match = re.findall(expr, abs_query_str)
        # If-statement after search() tests if it succeeded
        if match:              
            #print 'found: ['+str(match.group(1))+']' ## 'found word:cat'
            #print match
            int_match = map(int, match)
            return sum(int_match)
        else:
            #print 'did not find'
            return 0

    def get_feature_count(self,abs_query_str,feature):
        expr = r''+feature+'\s'
        #print expr
        match = re.findall(expr, abs_query_str)
        # If-statement after search() tests if it succeeded
        if match:              
            #print 'found: ['+str(match.group(1))+']' ## 'found word:cat'
            #print match
            return len(match)

        else:
            #print 'did not find'
            return 0    


def main():

    str = '''
(slice _ 10
    (project (?avg)
      (extend ((?avg ?.0))
        (group (?x) ((?.0 (avg ?y)))
          (bgp
            (triple ?a :x ?x)
            (triple ?a :y ?y)
          ))))))
'''    
    #get_features(str)

    fe = FeatureExtractor()

    sparql =  '''
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 

SELECT * WHERE { {?city rdfs:label 'Xinpu'@en.} UNION { ?alias <http://dbpedia.org/property/redirect> ?city;  rdfs:label 'Xinpu'@en. } UNION { ?alias <http://dbpedia.org/property/disambiguates> ?city;  rdfs:label 'Xinpu'@en. } OPTIONAL { ?city <http://dbpedia.org/ontology/abstract> ?abstract} OPTIONAL { ?city geo:lat ?latitude; geo:long ?longitude}OPTIONAL { ?city foaf:depiction ?image } OPTIONAL { ?city rdfs:label ?name } OPTIONAL { ?city foaf:homepage ?home } OPTIONAL { ?city <http://dbpedia.org/ontology/populationTotal> ?population } OPTIONAL { ?city <http://dbpedia.org/ontology/thumbnail> ?thumbnail } FILTER (langMatches( lang(?abstract), 'en'))}
    '''
    print fe.get_features(sparql)

if __name__ == "__main__":
    main()
