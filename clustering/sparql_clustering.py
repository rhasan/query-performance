import sys
import os.path
sys.path.append(
    os.path.abspath(os.path.join(os.path.dirname(__file__), os.path.pardir)))

import urlparse
import ConfigParser
import commands
import numpy as np
import pylab as pl
from feature_extractor import FeatureExtractor
from sparql_util import SarqlUtil

import k_mediods

CONFIG_FILE = '/Users/hrakebul/Documents/code/query-performance/config.prop'
class ClusterSparql:
    """Cluster sparql"""
    def __init__(self,config_file=CONFIG_FILE):

        self.X = None
        self.config = ConfigParser.RawConfigParser()
        self.config.read(config_file)
        
        self.total_query = self.config.getint('DBpedia','TotalQuery')
        self.query_file = self.config.get('DBpedia','QueryFile')
        self.dbp_prefix_file = self.config.get('DBpedia','Namespaces')
        #self.f_extractor = FeatureExtractor()
        self.sp_util = SarqlUtil(self.dbp_prefix_file)
        self.queries = list()
        self.distance_hungarian_script = self.config.get('QueryClustering','DistanceHungarian')
        self.K = self.config.getint('QueryClustering','K')
        self.random_shuffel_max_iters = self.config.getint('QueryClustering','RandomShuffelMaxIters')
        self.kmediods_max_iters = self.config.getint('QueryClustering','KmediodsMaxIters')

        self.cluster_cach_file = self.config.get('QueryClustering','ClusterCach')
        self.center_cach_file = self.config.get('QueryClustering','CenterCach')


        self.training_query_file = self.config.get('Query','TrainingQuery')
        self.training_algebra_feature_file = self.config.get('Query','TrainingAlgebraFeatures')
        self.training_execution_times_file = self.config.get('Query','TrainingQueryExecutionTimes')
        self.validation_query_file = self.config.get('Query','ValidationQuery')
        self.test_query_file = self.config.get('Query','TestQuery')
        
        self.center_idxs = None
        self.idx = None
        
        


        #print self.total_query
        #print self.query_file, type(self.query_file)

    def load_queries_dbp_log(self):
        
        f = open(self.query_file,'rb')
        count = 0

        for line in f:
            #print line
            if count >= self.total_query:
                break
            try:
                sparql_query = self.sp_util.dbp_log_to_sparql(line)
                #sparql_query = self.sp_util.get_dbp_sparql(sparql_query)
                #print sparql_query
                count += 1
                self.queries.append(sparql_query)
            except:
                pass
        self.X = np.array(self.queries).transpose()

    def load_training_queries(self,limit=None):
        if limit == None:
            limit = int(self.total_query*0.6)
        
        f = open(self.training_query_file,'rb')
        count = 0

        for line in f:
            #print line
            if count >= limit:
                break
            try:
                sparql_query = self.sp_util.url_to_sparql(line)
                #print sparql_query
                count += 1
                self.queries.append(sparql_query)
            except:
                pass
        self.X = np.array(self.queries).transpose()

    def distance_hungarian(self,q1,q2):
        
        tmp_q1_file = "tmp_q1_file~"
        #print query_str
        dbp_query1 = self.sp_util.get_dbp_sparql(q1)
        tq1 = open(tmp_q1_file,'w')
        tq1.write(dbp_query1)
        tq1.close()

        tmp_q2_file = "tmp_q2_file~"
        #print query_str
        dbp_query2 = self.sp_util.get_dbp_sparql(q2)
        tq2 = open(tmp_q2_file,'w')
        tq2.write(dbp_query2)
        tq2.close()        

        cmd = self.distance_hungarian_script+" --file"+" "+ tmp_q1_file +" "+tmp_q2_file
        (status,abs_query_str) = commands.getstatusoutput(cmd)
        #print abs_query_str
        if status != 0:
            #print "ged error", (status,abs_query_str)
            raise Exception("GED error status: "+str(status)+" "+abs_query_str)
        #print abs_query_str
        return float(abs_query_str)

    def compute_distance_matrix_real_time(self,distance_function=distance_hungarian):
        self.distance_matrix = k_mediods.compute_symmetric_distance(self.X ,distance_function)
        
        distance_filename = self.distance_cach_filename(distance_function)
        np.save(distance_filename,self.distance_matrix)

    def compute_distance_matrix_from_cach(self,distance_function=distance_hungarian):

        distance_filename = self.distance_cach_filename(distance_function)
        self.distance_matrix = np.load(distance_filename+'.npy')

    def distance_cach_filename(self, distance_function):
        file_name = "distance_matrix"
        
        file_name = self.distance_function_name(distance_function) + "_hungarian"
        file_name = file_name + "_cach"
        return file_name

    def distance_function_name(self, distance_function):
        '''
        MODIFY THIS WHEN NEW distance_function is added
        '''
        
        if distance_function == self.distance_hungarian:
            return "_hungarian"
        return ""
    
    def save_clusters(self,distance_function):
        df_name = self.distance_function_name(distance_function)
        
        #np.save(self.cluster_cach_file+df_name,self.idx)
        #np.save(self.center_cach_file+df_name,self.center_idxs)
        np.savetxt(self.cluster_cach_file+df_name, self.idx, fmt='%d')
        np.savetxt(self.center_cach_file+df_name,self.center_idxs, fmt='%d')
    
    def predict_cluster(self,Xi, distance_function, url_to_sparql = False):
        if url_to_sparql == True:
            Xi = self.sp_util.url_to_sparql(Xi)

        #if self.idx == None:
        #    self.idx = np.load(elf.cluster_cach_file+'.npy')
        if self.center_idxs == None:
            self.center_idxs = np.load(self.center_cach_file+df_name+'.npy')
        
        min_dist = np.inf
        min_k = -1
        
        for k in self.center_idxs:
            
            k_Xi = self.X[k]
            #print k_Xi
            d = distance_function(Xi, k_Xi)
            if min_dist > d:
                min_dist = d
                min_k = k

        #print "original:", Xi
        #print "prediction:",self.X[min_k]

        return min_k


    def cluster_queries(self,distance_function):
    
        (min_center_idxs,min_cost) = k_mediods.initial_random_centers_cost_minimization(self.X ,self.K,self.distance_matrix,self.random_shuffel_max_iters,self.kmediods_max_iters)
        print "min model cost: ", min_cost

        
        (self.center_idxs,self.idx) = k_mediods.k_mediods(self.X,min_center_idxs,self.kmediods_max_iters,self.distance_matrix)
        
        #k_mediods.print_clusters(self.X, self.idx, self.center_idxs)
        
        total_cost = k_mediods.model_cost(self.X, self.idx, self.center_idxs, self.distance_matrix)
        print "model cost: ", total_cost

        self.save_clusters(distance_function)

    def load_distaince_hungarian_matrix(self):
        '''
        Must be called after loading training queries
        '''
        m = np.size(self.X,0)
        self.distance_matrix = np.zeros((m,m),dtype=float)
        f = open('/Users/hrakebul/Documents/code/query-performance/precompute-query-graph-distance/training_distance_hungarian_matrix.dat')
        for line in f:
            row = line.split()
            i = int(row[0])
            j = int(row[1])
            d = float(row[2])
            #print i,j,d
            self.distance_matrix[i,j] = d
            self.distance_matrix[j,i] = d



def predict_validation_dataset(cs,distance_function):
    total_val_queries = int(cs.total_query * 0.2)
    offset = 5
    f = open(cs.validation_query_file,'rb')
    count = 0

    res = list()

    for line in f:
        #print line
        try:
            pk = cs.predict_cluster(line,distance_function,True)
            #print sparql_query
            count += 1
        except:
            pk = -1
        if pk == -1:
            pk = total_val_queries + offset
        res.append(pk)

    res_np = np.array(res)
    np.save('validation_predicted_clusters',res_np)

    print count, "validation queries successfully predicted"


def predict_test_dataset(cs,distance_function):
    total_test_queries = int(cs.total_query * 0.2)
    offset = 5
    f = open(cs.test_query_file,'rb')
    count = 0

    res = list()

    for line in f:
        #print line
        try:
            pk = cs.predict_cluster(line,distance_function,True)
            #print sparql_query
            count += 1
        except:
            pk = -1
        if pk == -1:
            pk = total_test_queries + offset
        res.append(pk)

    res_np = np.array(res)
    np.save('test_predicted_clusters',res_np)

    print count, "test queries successfully predicted"



def test_distance_hungarian(cs):
    q1 = '''SELECT DISTINCT  ?subject ?property
        WHERE
        { ?subject ?property <http://dbpedia.org/resource/Rounding_the_Mark> }'''
    

    q2 = '''
    SELECT ?abstract WHERE { <http://dbpedia.org/resource/Carnation_vein_mottle_virus> <http://dbpedia.org/ontology/abstract> ?abstract. FILTER langMatches(lang(?abstract), 'en') }
    '''

    print q1
    print q2
    d = cs.distance_hungarian(q1,q2)
    print d


def main():
    print "start"
    cs = ClusterSparql()
    cs.load_training_queries()
    cs.load_distaince_hungarian_matrix()

    #cs.compute_distance_matrix_real_time(cs.distance_hungarian)
    #cs.compute_distance_matrix_from_cach(cs.distance_hungarian)
    cs.cluster_queries(cs.distance_hungarian)

    #predict_validation_dataset(cs,cs.distance_hungarian)
    #predict_test_dataset(cs,cs.distance_hungarian)
    #cs.predict_cluster('/sparql?query=SELECT++%3Fx%0AWHERE%0A++%7B+%3Fx+%3Fp+%3Chttp%3A%2F%2Fdbpedia.org%2Fresource%2FTouro_University_Nevada%3E+%7D%0A',cs.distance_hungarian,True)

    #cs.predict_cluster('/sparql?default-graph-uri=http%3A%2F%2Fdbpedia.org&output=json&query=PREFIX%20rdfs%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%20SELECT%20*%20WHERE%20%7B%20%7B%3Fcity%20rdfs%3Alabel%20%27Ploskoye%27%40en.%7D%20UNION%20%7B%20%3Falias%20%3Chttp%3A%2F%2Fdbpedia.org%2Fproperty%2Fredirect%3E%20%3Fcity%3B%20%20rdfs%3Alabel%20%27Ploskoye%27%40en.%20%7D%20UNION%20%7B%20%3Falias%20%3Chttp%3A%2F%2Fdbpedia.org%2Fproperty%2Fdisambiguates%3E%20%3Fcity%3B%20%20rdfs%3Alabel%20%27Ploskoye%27%40en.%20%7D%20OPTIONAL%20%7B%20%3Fcity%20%3Chttp%3A%2F%2Fdbpedia.org%2Fontology%2Fabstract%3E%20%3Fabstract%7D%20OPTIONAL%20%7B%20%3Fcity%20geo%3Alat%20%3Flatitude%3B%20geo%3Along%20%3Flongitude%7DOPTIONAL%20%7B%20%3Fcity%20foaf%3Adepiction%20%3Fimage%20%7D%20OPTIONAL%20%7B%20%3Fcity%20rdfs%3Alabel%20%3Fname%20%7D%20OPTIONAL%20%7B%20%3Fcity%20foaf%3Ahomepage%20%3Fhome%20%7D%20OPTIONAL%20%7B%20%3Fcity%20%3Chttp%3A%2F%2Fdbpedia.org%2Fontology%2FpopulationTotal%3E%20%3Fpopulation%20%7D%20OPTIONAL%20%7B%20%3Fcity%20%3Chttp%3A%2F%2Fdbpedia.org%2Fontology%2Fthumbnail%3E%20%3Fthumbnail%20%7D%20FILTER%20%28langMatches%28%20lang%28%3Fabstract%29%2C%20%27en%27%29%29%7D',cs.distance_hungarian,True)




if __name__ == "__main__":
    main()