import scipy.io
import NDFS
import construct_W
from sparse_learning import feature_ranking
import unsupervised_evaluation
import numpy as np
from scipy.io import arff
#from cStringIO import StringIO

#f = StringIO('tr11.arff')
#data, meta = arff.loadarff(open('tr11.arff', 'r'))
#mn = po
#
def main():
    # load data
#    mat = scipy.io.loadmat('TOX-171.mat')
    mat= scipy.io.loadmat('tr11.mat')
    X = mat['X']    # data
    X = X.astype(float)
    print(X.shape)
    print()
    y = mat['Y']    # label
    y = y[:, 0]
    
    # number of clusters, it is usually set as the number of classes in the ground truth
    num_cluster = len( np.unique(y)) 

    # construct affinity matrix
    kwargs = {"metric": "euclidean", "neighborMode": "knn", "weightMode": "heatKernel", "k": 5, 't': 1}
    W = construct_W.construct_W(X, **kwargs)

    # obtain the feature weight matrix
    Weight = NDFS.ndfs(X, W=W, n_clusters=num_cluster)

    # sort the feature scores in an ascending order according to the feature scores
    idx = feature_ranking(Weight)

    # perform evaluation on clustering task
    if X.shape[1] < 300 :
        # number of selected features 
        fea = [50, 80, 110, 140, 170, 200]
    else:
        # number of selected features
        fea = [50, 100, 150, 200, 250, 300]
        
    for num_fea in fea:          
    
        # obtain the dataset on the selected features
        selected_features = X[:, idx[0:num_fea]]
    
        # perform kmeans clustering based on the selected features and repeats 20 times
        nmi_total = 0
        acc_total = 0
        for i in range(0, 20):
            nmi, acc = unsupervised_evaluation.evaluation(X_selected=selected_features, n_clusters=num_cluster, y=y)
            nmi_total += nmi
            acc_total += acc
    
        # output the average NMI and average ACC
        print('Number of Selected feature: ', num_fea)
        print ('NMI:', float(nmi_total)/20)
        print ('ACC:', float(acc_total)/20)
        print()

if __name__ == '__main__':
    main()
