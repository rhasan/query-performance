import numpy as np
import pylab as pl
import jellyfish

def initial_random_centers(X,K):
    randidx = np.random.permutation(range(np.size(X,0)))
    centers = X[randidx[0:K], :]
    return (centers,randidx[0:K])


def find_closest_centers(X,center_idxs,distance_matrix):
    K = np.size(center_idxs,0)
    m = np.size(X,0)
    idx = np.zeros(m,dtype=int)

    for i in xrange(m):
        min_d = np.inf
        min_j = -1
        for j in center_idxs:
            if j < 0:
                continue;

            d = distance_matrix[i,j]
            if(min_d > d):
                min_d = d
                min_j = j
        idx[i] = min_j
        if min_d == 0:
            idx[i] = i

    return idx

def compute_centers(X, idx, center_idxs,distance_matrix):
    K = np.size(center_idxs,0)
    moved_centers = np.zeros(K,dtype=int)
    i = 0
    for k in center_idxs:
        (x_indxs,) = np.where(idx[:]==k)
        #print "center:", k,"=",x_indxs
        #print "vals", X[x_indxs,:]
        
        min_cost = np.inf    
        min_c = -1
        for c_indx in x_indxs:
            cost = 0.0
            for y_indx in x_indxs:
                cost += distance_matrix[c_indx,y_indx]
                #print "c_indx:", c_indx, "y_indx:",y_indx
                #print "dist:", distance_matrix[c_indx,y_indx]
            #print "cost:", cost
            if min_cost > cost:
                min_cost = cost
                min_c = c_indx

        moved_centers[i] = min_c
        i += 1

        #print "min_cost:", min_cost
    return moved_centers

def k_mediods(X,initial_center_idxs,max_iters,distance_matrix):
    m = np.size(X,0)
    K = np.size(initial_center_idxs,0)
    center_idxs = initial_center_idxs
    previous_center_idxs = center_idxs
    idx = np.zeros(m,dtype=int)

    for i in xrange(max_iters):
        idx = find_closest_centers(X,center_idxs,distance_matrix)
        previous_center_idxs = center_idxs
        center_idxs = compute_centers(X,idx,center_idxs,distance_matrix)
        
        if (previous_center_idxs == center_idxs).all() == True:
            break;

    if (previous_center_idxs == center_idxs).all() == False:
        idx = find_closest_centers(X,center_idxs,distance_matrix)

    return (center_idxs,idx)

def model_cost(X, idx, center_idxs,distance_matrix):
    K = np.size(center_idxs,0)
    total_cost = 0.0;
    for k in center_idxs:
        (k_cluster_x_indxs,) = np.where(idx[:]==k)
        #print k_cluster_x_indxs
        cost = 0.0
        for x_indx in k_cluster_x_indxs:
            cost += distance_matrix[k,x_indx]
        total_cost += cost
    return total_cost
       
def initial_random_centers_cost_minimization(X,K,distance_matrix,random_shuffel_max_iters,kmediods_max_iters):
    min_cost = np.inf
    
    for i in xrange(random_shuffel_max_iters):
        (initial_centers,initial_center_idxs) = initial_random_centers(X,K)
        (center_idxs,idx) = k_mediods(X,initial_center_idxs,kmediods_max_iters,distance_matrix)
        total_cost = model_cost(X,idx,center_idxs,distance_matrix)
        if min_cost > total_cost:
            min_cost = total_cost
            min_center_idxs = center_idxs

    return (min_center_idxs,min_cost)


def elbow_method_choose_k_with_random_init_cost_minimization(X,max_K,distance_matrix,random_shuffel_max_iters,kmediods_max_iters):
    cost_array = np.zeros(max_K,dtype=float)
    for K in xrange(1,max_K+1):
        (init_center_idxs,cost) = initial_random_centers_cost_minimization(X,K,distance_matrix,random_shuffel_max_iters,kmediods_max_iters)
        (center_idxs,idx) = k_mediods(X,init_center_idxs,kmediods_max_iters,distance_matrix)
        total_cost = model_cost(X,idx,center_idxs,distance_matrix)
        cost_array[K-1] = total_cost

        #print_clusters(X,idx,center_idxs)
        print "cost:", total_cost, "K:",K

    K_vals = np.linspace(1,max_K,max_K)
    pl.plot(K_vals,cost_array)
    pl.plot(K_vals,cost_array,'rx',label='distortion')
    pl.show()
    




def compute_symmetric_distance(X,distance_function):
    m = np.size(X,0)
    dist = np.zeros((m,m),dtype=float)
    for i in xrange(m):
        for j in xrange(i+1,m):
            try:
                dist[i,j] = distance_function(X[i], X[j])
                dist[j,i] = dist[i,j]
                #print "distance between", X[i], "and ", X[j], ":",dist[i,j]
            except:
                dist[i,j] = np.inf
                dist[j,i] = np.inf

    return dist

def print_clusters(X,idx,center_idxs):

    for k in center_idxs:
        print "Cluster:", X[k]
        print X[idx[:] == k]

def testStringClustering():

    K = 20
    random_shuffel_max_iters = 100
    kmediods_max_iters = 100
    #X =  np.array(['ape', 'appel', 'apple', 'peach', 'puppy'])
    X = np.array(
        ['the', 'be', 'to', 'of', 'and', 'a', 'in', 'that', 'have',
         'I', 'it', 'for', 'not', 'on', 'with', 'he', 'as', 'you',
         'do', 'at', 'this', 'but', 'his', 'by', 'from', 'they', 'we',
         'say', 'her', 'she', 'or', 'an', 'will', 'my', 'one', 'all',
         'would', 'there', 'their', 'what', 'so', 'up', 'out', 'if',
         'about', 'who', 'get', 'which', 'go', 'me', 'when', 'make',
         'can', 'like', 'time', 'no', 'just', 'him', 'know', 'take',
         'people', 'into', 'year', 'your', 'good', 'some', 'could',
         'them', 'see', 'other', 'than', 'then', 'now', 'look',
         'only', 'come', 'its', 'over', 'think', 'also', 'back',
         'after', 'use', 'two', 'how', 'our', 'work', 'first', 'well',
         'way', 'even', 'new', 'want', 'because', 'any', 'these',
         'give', 'day', 'most', 'us'])
    distance_matrix = compute_symmetric_distance(X,distance_function=jellyfish.levenshtein_distance)

    (initial_centers,initial_center_idxs) = initial_random_centers(X,K)
    (center_idxs,idx) = k_mediods(X,initial_center_idxs,kmediods_max_iters,distance_matrix)
    print_clusters(X,idx,center_idxs)
    total_cost = model_cost(X,idx,center_idxs,distance_matrix)
    print "model cost: ", total_cost


    #elbow_method_choose_k_with_random_init_cost_minimization(X,K,distance_matrix,random_shuffel_max_iters,kmediods_max_iters)

    new_K = 10

    (min_center_idxs,min_cost) = initial_random_centers_cost_minimization(X,new_K,distance_matrix,random_shuffel_max_iters,kmediods_max_iters)
    print "min model cost: ", min_cost

    (center_idxs,idx) = k_mediods(X,min_center_idxs,kmediods_max_iters,distance_matrix)
    print_clusters(X,idx,center_idxs)
    total_cost = model_cost(X,idx,center_idxs,distance_matrix)
    print "model cost: ", total_cost

def main():
    testStringClustering()
if __name__ == "__main__":
    main()