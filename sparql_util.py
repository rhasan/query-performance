import urlparse

class SarqlUtil:
    """docstring for SarqlUtil"""
    def __init__(self,dpb_prefix_file=None):
        if(dpb_prefix_file!=None):
            self.dbpedia_prefix = ""
            dbp_prefix_f = open(dpb_prefix_file,'rb')

            for pref in dbp_prefix_f:
                self.dbpedia_prefix += pref

            #self.dbpedia_prefix = s  
            dbp_prefix_f.close()          
    
    def url_to_sparql(self,query_log):

        try:
            par = urlparse.parse_qs(urlparse.urlparse(query_log).query)
            #print par
            sparql_query = par['query'][0]

            return sparql_query
        except Exception as inst:
            raise Exception("Invalid SPARQL query log",inst);

    def dbp_log_to_sparql(self,line):
        try:
            row = line.split()
            query_log = row[6][1:-1]
            #print query_log
            par = urlparse.parse_qs(urlparse.urlparse(query_log).query)
            #util.url_decode(row[6])
            sparql_query = par['query'][0]
            return sparql_query
        except Exception as inst:
            raise Exception("Invalid SPARQL query log");

    def get_dbp_sparql(self,query_str):
        q = self.dbpedia_prefix.replace('\n',' ').replace('\r','')+" "+query_str.replace('\n',' ').replace('\r','')
        #q = q.replace("'",'"') # to makesure a single string is passed in jena commandline parser
        return q            