package semanticweb.sparql.precompute;

public class StatUtils {

	public static double rSquared(double[] y, double[] f) {
		double ySum = 0.0;
		for(double yi:y) {
			ySum += yi;
		}
		double yMean = ySum/y.length;
		
		
		double sst = 0.0;
		double ssr = 0.0;
		
		for(int i=0;i<y.length;i++) {
			sst += (y[i]-yMean)*(y[i]-yMean);
			ssr += (y[i]-f[i])*(y[i]-f[i]);
		}
		
		return 1.0-ssr/sst;
	}
}
