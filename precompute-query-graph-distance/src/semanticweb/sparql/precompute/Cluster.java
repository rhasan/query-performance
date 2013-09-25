package semanticweb.sparql.precompute;

import ged.AlgorithmConfig;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Scanner;
import java.util.concurrent.TimeUnit;

import com.google.common.base.Stopwatch;

import semanticweb.RDFGraphMatching;
import util.DBPediaUtils;

public class Cluster {
	public static String CENTER_FILE = "/Users/hrakebul/Documents/code/query-performance/clustering/center_cach_hungarian";
	public static String CLUSTER_FILE = "/Users/hrakebul/Documents/code/query-performance/clustering/cluster_cach_hungarian";
	
	
	private String validationPredictionFile = "validation_cluster_prediction.dat";
	private String testPredictionFile = "test_cluster_prediction.dat";
	
	private String trainingFeatureExtraFile = "/Users/hrakebul/Documents/code/query-performance/x_features_extra.txt";
	private String validationFeatureExtraFile = "/Users/hrakebul/Documents/code/query-performance/xval_features_extra.txt";
	private String testFeatureExtraFile = "/Users/hrakebul/Documents/code/query-performance/xtest_features_extra.txt";
	
	private List<Integer> center_idx = new ArrayList<Integer>();
	private List<Integer> idx = new ArrayList<Integer>();
	private List<Integer> validationIdx = new ArrayList<Integer>();
	private List<Integer> testIdx = new ArrayList<Integer>();
	
	private List<String> queries;
	private Properties prop;
	
	public Cluster() throws IOException {
		prop = new Properties();
		prop.load(new FileInputStream(SparqlDistance.CONFIG_FILE));
		loadQuries();
		loadCenters();
		loadClusters();
		
	}
	
	public void loadQuries() throws IOException {
		String queryFile = prop.getProperty("TrainingQuery");
		FileInputStream fis = new FileInputStream(queryFile);
		Scanner in = new Scanner(fis);
		queries = null;
		queries = new ArrayList<String>();
		
		while(in.hasNext()) {
			String line = in.nextLine();
			//System.out.println(line);
			queries.add(line);
		}	
		fis.close();
		
	}	
	
	public void loadCenters() throws IOException {
		Scanner in = new Scanner(new FileInputStream(CENTER_FILE));
		while(in.hasNext()) {
			int id = in.nextInt();
			center_idx.add(id);
		}
	}
	
	public void loadClusters() throws IOException {
		Scanner in = new Scanner(new FileInputStream(CLUSTER_FILE));
		while(in.hasNext()) {
			int id = in.nextInt();
			idx.add(id);
		}
	}
	
	public int predictCluster(String sparql) throws Exception{
		String q1 = DBPediaUtils.getQueryForDBpedia(sparql);
		
		double minCost = Double.POSITIVE_INFINITY;
		int minCi = -1;
		for(int i=0;i<center_idx.size();i++) {
			int ci = center_idx.get(i);
			String sparql2 = queries.get(ci);
			String q2 = DBPediaUtils.getQueryForDBpedia(sparql2);
			AlgorithmConfig algorithmConfig = AlgorithmConfig.createBipartiteHungarian();
			RDFGraphMatching matcher = new RDFGraphMatching();
			//System.out.println("q1: "+sparql1);
			//System.out.println("q2: "+sparql2);
			
			double cost = matcher.queryGraphDistance(q1, q2, algorithmConfig);
			if(minCost>cost) {
				minCost = cost;
				minCi = ci;
			}
		}
		return minCi;
	}
	
	public void processValidationQueries() throws Exception{
		Scanner in = new Scanner(new FileInputStream(prop.getProperty("ValidationQuery")));
		PrintStream ps = new PrintStream(validationPredictionFile);
		System.out.println("Predicting clusters for validation dataset");
		Stopwatch watch = new Stopwatch();
		watch.start();		
		while(in.hasNext()) {
			String line = in.nextLine();
			int c = predictCluster(line);
			validationIdx.add(c);
			//System.out.println(c);
			ps.println(c);
		}
		watch.stop();
		System.out.println("Elapsed time: "+watch.elapsed(TimeUnit.SECONDS)+" seconds");
		ps.close();
	}
	public void processTestQueries() throws Exception{
		Scanner in = new Scanner(new FileInputStream(prop.getProperty("TestQuery")));
		PrintStream ps = new PrintStream(testPredictionFile);
		System.out.println("Predicting clusters for test dataset");
		Stopwatch watch = new Stopwatch();
		watch.start();		
		while(in.hasNext()) {
			String line = in.nextLine();
			int c = predictCluster(line);
			testIdx.add(c);
			//System.out.println(c);
			ps.println(c);
		}
		watch.stop();
		System.out.println("Elapsed time: "+watch.elapsed(TimeUnit.SECONDS)+" seconds");
		ps.close();
	}

	private void writeFreatureVectors(Map<Integer,Integer> cenIndex,List<Integer> list, PrintStream ps){
		int dimentions = Integer.valueOf(prop.getProperty("K"));
		for(int c:list) {
			int[] ftr = new int[dimentions];
			//System.out.println(c);
			//System.out.println(cenIndex.get(c));
			ftr[cenIndex.get(c)] = 1;
			
			String outString = "";
			for(int j=0;j<ftr.length;j++){
				if(j!=0) {
					outString += ",";
				}
				outString += ftr[j];
			}
			
			ps.println(outString);
			//System.out.println(outString);
		}		
	}
	
	public void createFeaterfiles() throws IOException {
		System.out.println("Creating feature files for training, validation and test datasets");
		Stopwatch watch = new Stopwatch();
		watch.start();	
		
		PrintStream xFeaturePs = new PrintStream(trainingFeatureExtraFile);
		PrintStream xvalFeaturePs = new PrintStream(validationFeatureExtraFile);
		PrintStream xtestFeaturePs = new PrintStream(testFeatureExtraFile);
		
		
		
		Map<Integer,Integer> cenIndex = new HashMap<Integer, Integer>();
		int i=0;
		for(int c:center_idx){
			cenIndex.put(c, i);
			//System.out.println(c+" "+i);
			i++;
		}
		
		writeFreatureVectors(cenIndex, idx, xFeaturePs);
		writeFreatureVectors(cenIndex, validationIdx, xvalFeaturePs);
		writeFreatureVectors(cenIndex, testIdx, xtestFeaturePs);
		
		xFeaturePs.close();
		xvalFeaturePs.close();
		xtestFeaturePs.close();
		watch.stop();
		System.out.println("Elapsed time: "+watch.elapsed(TimeUnit.SECONDS)+" seconds");		
	}
	
	public static void main(String[] args) throws Exception {
		Cluster cl = new Cluster();
		cl.processValidationQueries();
		cl.processTestQueries();
		
		cl.createFeaterfiles();

	}

}
