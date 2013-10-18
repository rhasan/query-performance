package semanticweb.sparql.precompute;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

import weka.clusterers.SimpleKMeans;
import weka.core.Instance;
import weka.core.Instances;
import weka.core.converters.CSVLoader;
import weka.filters.Filter;
import weka.filters.unsupervised.attribute.RemoveType;
import weka.filters.unsupervised.attribute.StringToNominal;

public class KmeansClusterByTime {
	private Properties prop;
	
	public KmeansClusterByTime() throws FileNotFoundException, IOException {
		prop = new Properties();
		prop.load(new FileInputStream(SparqlDistance.CONFIG_FILE));
	}
	
	public void clusterTrainingExecutionTime() throws Exception {
		
		
		CSVLoader loader = new CSVLoader();
		
		loader.setFile(new File( prop.getProperty("TrainingQueryExecutionTimes")));
		
		Instances instances = loader.getDataSet();
		
		//hack because the training csv does not have a header and weka assumes the first row will have headers 
		Instance instance = new Instance(1);
		instance.setValue(0, Double.valueOf(instances.attribute(0).name()));
		instances.add(instance);

		System.out.println("Instances: "+ instances.numInstances());
		
		SimpleKMeans kmeans = new SimpleKMeans();
		kmeans.setSeed(10);
		kmeans.setPreserveInstancesOrder(true);
		kmeans.setNumClusters(10);
		kmeans.setMaxIterations(100);
		
		kmeans.buildClusterer(instances);
		
		// This array returns the cluster number (starting with 0) for each instance
		// The array has as many elements as the number of instances
		int[] assignments = kmeans.getAssignments();

		int i=0;
		for(int clusterNum : assignments) {
		    System.out.printf("Instance %d -> Cluster %d\n", i, clusterNum);
		    i++;
		}		
		
	}
	public static void main(String[] args) throws Exception {
		KmeansClusterByTime km = new KmeansClusterByTime();
		km.clusterTrainingExecutionTime();
	}
}
