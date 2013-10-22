package semanticweb.sparql.precompute;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import com.google.common.primitives.Ints;

import weka.classifiers.functions.LibSVM;
import weka.core.Attribute;
import weka.core.Instance;
import weka.core.Instances;
import weka.core.converters.CSVLoader;
import weka.filters.Filter;
import weka.filters.unsupervised.attribute.NumericToNominal;
import weka.filters.unsupervised.attribute.Remove;
import weka.filters.unsupervised.attribute.RemoveUseless;
import weka.filters.unsupervised.attribute.Standardize;

public class TimeClassClassifier {


	Instances instances;
	ClusteringConfiguration config;
	LibSVM svm;
	Map<String,Integer> attributeIndex;
	int[] removedAttributes;
	public TimeClassClassifier(String labelFilePath) throws Exception {
		
		svm = new LibSVM();
		config = new ClusteringConfiguration();
		attributeIndex = new HashMap<String, Integer>();
		
		CSVLoader algebraFeaturesCSVLoader = new CSVLoader();
		algebraFeaturesCSVLoader.setFile(new File(config.getTrainingAlgebraFeaturesFile()));
		Instances algebraInstances = algebraFeaturesCSVLoader.getDataSet(); 
		
		CSVLoader simVecFeaturesCSVLoader = new CSVLoader();
		simVecFeaturesCSVLoader.setFile(new File(config.getTrainingSimilarityVectorfeatureFile()));
		Instances simVecInstances = simVecFeaturesCSVLoader.getDataSet();
		
		CSVLoader labelCSVLoader = new CSVLoader();
		labelCSVLoader.setFile(new File(labelFilePath));
		Instances labelInstances = labelCSVLoader.getDataSet();
		
		//convert class labes to nominal
		NumericToNominal classNominalFilter = new NumericToNominal();		
		classNominalFilter.setInputFormat(labelInstances);
		classNominalFilter.setAttributeIndices("last");
		Instances filteredlabelInstances = Filter.useFilter(labelInstances, classNominalFilter);
		
		//merge algebra and simvec
		Instances mergedAlgSimVec = Instances.mergeInstances(algebraInstances, simVecInstances);
		//merge algebra and simvec and class labels
		Instances mergedAlgSimVecClass = Instances.mergeInstances(mergedAlgSimVec, filteredlabelInstances);
		mergedAlgSimVecClass.setClassIndex(mergedAlgSimVecClass.numAttributes()-1);
		
		
		//List<Attribute> atts = new ArrayList<Attribute>();
		//mergedAlgSimVecClass.attribute(0).
		for(int i=0;i < mergedAlgSimVecClass.numAttributes();i++) {
			attributeIndex.put(mergedAlgSimVecClass.attribute(i).name(), i);
		}
		
		
		//filter out useless
		RemoveUseless removeUselessFilter = new RemoveUseless();
		removeUselessFilter.setMaximumVariancePercentageAllowed(99.0);
		removeUselessFilter.setInputFormat(mergedAlgSimVecClass);
		Instances mergedUselessFilteredAlgSimVecClass = Filter.useFilter(mergedAlgSimVecClass, removeUselessFilter);
		
		

		
		//standardize
		Standardize stdFilter = new Standardize();
		stdFilter.setIgnoreClass(true);
		stdFilter.setInputFormat(mergedUselessFilteredAlgSimVecClass);
		instances = Filter.useFilter(mergedUselessFilteredAlgSimVecClass, stdFilter); 
		
		
		//record removed attributes/columns in a matrix
		Set<String> selectedAtt = new HashSet<String>();
		
		for(int i=0;i < instances.numAttributes();i++) {
			selectedAtt.add(instances.attribute(i).name());
		}
		
		List<Integer> deletedAttIndex = new ArrayList<Integer>();
		for(Entry<String, Integer> e:attributeIndex.entrySet()) {
			if(selectedAtt.contains(e.getKey())==false) {
				deletedAttIndex.add(e.getValue());
			}
		}

		removedAttributes = Ints.toArray(deletedAttIndex);
		
		//System.out.println(instances.numInstances());
		//System.out.println(instances);
		
		
		
		
		trainClassifier();
	}
	
	public void trainClassifier() throws Exception {
		
		double C = 45.0;
		double G = 1.0;
		double N = 0.01;
		
		
		svm.setCost(C);
		svm.setGamma(G);
		svm.setNu(N);
		svm.buildClassifier(instances);
		
		System.out.println(svm.classifyInstance(instances.lastInstance()));
		
	}
	
	public Instance refineUnseenInstance(Instance unseen) {


		return null;
	}
	
	public Instances refineUnseenDataSet(Instances unseenInstances) {
		//Remove rmFilter = new Remove();
		//rmFilter.setAttributeIndicesArray(removedAttributes);

		return null;
	}
	
	
	public static void main(String[] args) throws Exception {
		ClusteringConfiguration c = new ClusteringConfiguration();
		TimeClassClassifier tc = new TimeClassClassifier(c.getTrainingTimeClassXmeansFile());
	}

}
