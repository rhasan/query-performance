package semanticweb.sparql.precompute;

import java.io.IOException;
import java.util.HashMap;



import weka.classifiers.Evaluation;
import weka.classifiers.lazy.IBk;
import weka.core.DistanceFunction;
import weka.core.EuclideanDistance;
import weka.core.Instances;
import weka.core.SelectedTag;
import weka.core.Tag;
import weka.core.neighboursearch.KDTree;
import weka.core.neighboursearch.NearestNeighbourSearch;

public class QueryExecutionTimePredictorKNN {
	public static String CONFIG_FILE = System.getProperty("user.home")+"/Documents/code/query-performance/config-knn-6000.prop";
	ProjectConfiguration config;
	Instances trainingInstances;
	Instances validationInstances;
	Instances testInstances;
	AttributeFilterMeta trainingFeaturesMeta;
	IBk knnModel;
	int K4KNN = 5;
	
	public QueryExecutionTimePredictorKNN() throws IOException {
		config = new ProjectConfiguration(CONFIG_FILE);
	}
	
	public void loadData() throws Exception {
		loadTrainingData();
		loadValidationtData();
		loadTestData();
		WekaUtils.saveInstances(trainingInstances, config.getTrainingARFFFile());
		WekaUtils.saveInstances(validationInstances, config.getValidationARFFFile());
		WekaUtils.saveInstances(testInstances, config.getTestARFFFile());
	}
	
	public void loadTrainingData() throws Exception {
		Instances trainingAlgebraFeatureInstances = WekaUtils.loadCSV(config.getTrainingAlgebraFeaturesFile());
		Instances trainingSimVecFeatureInstances = WekaUtils.loadCSV(config.getTrainingSimilarityVectorfeatureFile());
		Instances trainingExecutionTimeInstances = WekaUtils.loadCSV(config.getTrainingQueryExecutionTimesFile());
		
		trainingFeaturesMeta = WekaUtils.refineInstances(trainingAlgebraFeatureInstances, trainingSimVecFeatureInstances);
		
		Instances features = trainingFeaturesMeta.getInstances();
		trainingInstances = WekaUtils.addNumericLablesForRegression(features, trainingFeaturesMeta, trainingExecutionTimeInstances); 
		//regressionTrainingDatasets = new HashMap<Integer, Instances>();
	}	
	
	public void loadValidationtData() throws Exception {
		Instances validationAlgebraFeatureInstances = WekaUtils.loadCSV(config.getValidationAlgebraFeaturesFile());
		Instances validationSimVecFeatureInstances = WekaUtils.loadCSV(config.getValidationSimilarityVectorFeatureFile());
		Instances validationtExecutionTimeInstances = WekaUtils.loadCSV(config.getValidationQueryExecutionTimesFile());
		
		Instances features = WekaUtils.refineInstances(validationAlgebraFeatureInstances, validationSimVecFeatureInstances,trainingFeaturesMeta);
		//WekaUtils.refineInstances(algebraInstances, simVecInstances, meta)
		
		//Instances features = featuresMeta.getInstances();
		validationInstances = WekaUtils.addNumericLablesForRegression(features, trainingFeaturesMeta, validationtExecutionTimeInstances); 
		
	}
	
	public void loadTestData() throws Exception {
		Instances testAlgebraFeatureInstances = WekaUtils.loadCSV(config.getTestAlgebraFeaturesFile());
		Instances testSimVecFeatureInstances = WekaUtils.loadCSV(config.getTestSimilarityVectorFeatureFile());
		Instances testExecutionTimeInstances = WekaUtils.loadCSV(config.getTestQueryExecutionTimesFile());
		
		Instances features = WekaUtils.refineInstances(testAlgebraFeatureInstances, testSimVecFeatureInstances,trainingFeaturesMeta);
		//WekaUtils.refineInstances(algebraInstances, simVecInstances, meta)
		
		//Instances features = featuresMeta.getInstances();
		testInstances = WekaUtils.addNumericLablesForRegression(features, trainingFeaturesMeta, testExecutionTimeInstances); 
		
	}
	
	
	
	public void trainKNNRegression() throws Exception {
		knnModel = new IBk();
		knnModel.setKNN(K4KNN);
		SelectedTag inverseDistance = new SelectedTag(IBk.WEIGHT_INVERSE, IBk.TAGS_WEIGHTING);
		
		
		knnModel.setDistanceWeighting(inverseDistance);
		
		NearestNeighbourSearch kdTree = new KDTree();
		DistanceFunction df = new EuclideanDistance();
        //df.setDontNormalize(true);
        //tree.setDistanceFunction(df); 
		
		kdTree.setDistanceFunction(df);
		
		
		knnModel.setNearestNeighbourSearchAlgorithm(kdTree);
		knnModel.buildClassifier(trainingInstances);
		
		Evaluation eval = new Evaluation(trainingInstances);
		double[] y = eval.evaluateModel(knnModel, trainingInstances);
		GeneralUtils.saveExecutionTimePredictions(y, config.getTrainingQueryExecutionTimesPredictedFile());
		
		System.out.println(eval.toSummaryString("\nTraining Results\n======\n", false));
		//System.out.println(eval.toMatrixString());		
		
		
		
	}
	
	public void testModel() throws Exception {
		Evaluation eval = new Evaluation(trainingInstances);
		double[] y = eval.evaluateModel(knnModel, testInstances);
		GeneralUtils.saveExecutionTimePredictions(y, config.getTestQueryExecutionTimesPredictedFile());
		System.out.println(eval.toSummaryString("\nTest Results\n======\n", false));
		
	}
	
	public static void main(String[] args) throws Exception {
		QueryExecutionTimePredictorKNN predictor = new QueryExecutionTimePredictorKNN();
		predictor.loadData();
		predictor.trainKNNRegression();
		predictor.testModel();
	}
}
