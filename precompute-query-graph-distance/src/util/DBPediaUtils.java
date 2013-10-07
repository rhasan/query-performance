package util;

import java.nio.charset.Charset;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.client.utils.URLEncodedUtils;


public class DBPediaUtils {
	public static String PREFIX_STRING = "PREFIX b3s: <http://b3s.openlinksw.com/> " +
"PREFIX bif: <bif:> " +
"PREFIX category:    <http://dbpedia.org/resource/Category:> " +
"PREFIX dawgt:   <http://www.w3.org/2001/sw/DataAccess/tests/test-dawg#> " +
"PREFIX dbpedia: <http://dbpedia.org/resource/> " +
"PREFIX dbpedia-owl: <http://dbpedia.org/ontology/> " +
"PREFIX dbpprop: <http://dbpedia.org/property/> " +
"PREFIX dc:  <http://purl.org/dc/elements/1.1/> " +
"PREFIX dcterms: <http://purl.org/dc/terms/> " +
"PREFIX fn:  <http://www.w3.org/2005/xpath-functions/#> " +
"PREFIX foaf:    <http://xmlns.com/foaf/0.1/> " +
"PREFIX freebase:    <http://rdf.freebase.com/ns/> " +
"PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#> " +
"PREFIX geonames:    <http://www.geonames.org/ontology#> " +
"PREFIX go:  <http://purl.org/obo/owl/GO#> " +
"PREFIX gr:  <http://purl.org/goodrelations/v1#> " +
"PREFIX grs: <http://www.georss.org/georss/> " +
"PREFIX lgv: <http://linkedgeodata.org/ontology/> " +
"PREFIX lod: <http://lod.openlinksw.com/> " +
"PREFIX math:    <http://www.w3.org/2000/10/swap/math#> " +
"PREFIX mesh:    <http://purl.org/commons/record/mesh/> " +
"PREFIX mf:  <http://www.w3.org/2001/sw/DataAccess/tests/test-manifest#> " +
"PREFIX nci: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#> " +
"PREFIX obo: <http://www.geneontology.org/formats/oboInOwl#> " +
"PREFIX opencyc: <http://sw.opencyc.org/2008/06/10/concept/> " +
"PREFIX owl: <http://www.w3.org/2002/07/owl#> " +
"PREFIX product: <http://www.buy.com/rss/module/productV2/> " +
"PREFIX protseq: <http://purl.org/science/protein/bysequence/> " +
"PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> " +
"PREFIX rdfa:    <http://www.w3.org/ns/rdfa#> " +
"PREFIX rdfdf:   <http://www.openlinksw.com/virtrdf-data-formats#> " +
"PREFIX rdfs:    <http://www.w3.org/2000/01/rdf-schema#> " +
"PREFIX rev: <http://purl.org/stuff/rev#> " +
"PREFIX sc:  <http://purl.org/science/owl/sciencecommons/> " +
"PREFIX scovo:   <http://purl.org/NET/scovo#> " +
"PREFIX sd:  <http://www.w3.org/ns/sparql-service-description#> " +
"PREFIX sioc:    <http://rdfs.org/sioc/ns#> " +
"PREFIX skos:    <http://www.w3.org/2004/02/skos/core#> " +
"PREFIX sql: <sql:> " +
"PREFIX umbel-ac:    <http://umbel.org/umbel/ac/> " +
"PREFIX umbel-sc:    <http://umbel.org/umbel/sc/> " +
"PREFIX units:   <http://dbpedia.org/units/> " +
"PREFIX usc: <http://www.rdfabout.com/rdf/schema/uscensus/details/100pct/> " +
"PREFIX vcard:   <http://www.w3.org/2001/vcard-rdf/3.0#> " +
"PREFIX vcard2006:   <http://www.w3.org/2006/vcard/ns#> " +
"PREFIX virtcxml:    <http://www.openlinksw.com/schemas/virtcxml#> " +
"PREFIX virtrdf: <http://www.openlinksw.com/schemas/virtrdf#> " +
"PREFIX void:    <http://rdfs.org/ns/void#> " +
"PREFIX wdrs:    <http://www.w3.org/2007/05/powder-s#> " +
"PREFIX wikicompany: <http://dbpedia.openlinksw.com/wikicompany/> " +
"PREFIX xf:  <http://www.w3.org/2004/07/xpath-functions> " +
"PREFIX xml: <http://www.w3.org/XML/1998/namespace> " +
"PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> " +
"PREFIX xsl10:   <http://www.w3.org/XSL/Transform/1.0> " +
"PREFIX xsl1999: <http://www.w3.org/1999/XSL/Transform> " +
"PREFIX xslwd:   <http://www.w3.org/TR/WD-xsl> " +
"PREFIX yago:    <http://dbpedia.org/class/yago/> " +
"PREFIX yago-res:    <http://mpii.de/yago/resource/> " +
"PREFIX :     <http://example/> " +
"PREFIX rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> " +
"PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> ";
	
	public static String refineForDBPedia(String str) {
		return PREFIX_STRING.concat(str);
	}
	
	public static String getParam(String q, String param) {
		Charset utf8charset = Charset.forName("UTF-8");
		List<NameValuePair> params = URLEncodedUtils.parse(q,utf8charset);
		
		for(NameValuePair p:params) {
			
			//System.out.println(p.getName());
			//System.out.println(p.getValue());
			if(p.getName().endsWith(param)) return p.getValue();
			
		}
		return "";
		
	}
	
	public static String getQueryForDBpedia(String sparql){
		String q1 = DBPediaUtils.getParam(sparql, "query");
		return refineForDBPedia(q1);
	}
	
	public static void main(String[] args) {
		//q2:/sparql?timeout=0&debug=on&query=%0A%09%09%09%09%09%09SELECT+%2A+WHERE+%7B+%0A%09%09%09%09%09%09%09%7B+%3Chttp%3A%2F%2Fdbpedia.org%2Fresource%2FFox_Broadcasting_Company%3E+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23type%3E+%3Fname+%7D%0A++++++++%09%09%09%09%09UNION%0A++++++++%09%09%09%09%09%7B+%3Chttp%3A%2F%2Fdbpedia.org%2Fresource%2FFox_Broadcasting_Company%3E+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2Fsubject%3E+%3Fname+%7D+%0A++++++++%09%09%09%09%7D%0A++++++++%09%09%09+&default-graph-uri=http%3A%2F%2Fdbpedia.org&format=application%2Fsparql-results%2Bjson
		String q1= "/sparql?default-graph-uri=http%3A%2F%2Fdbpedia.org&output=json&query=PREFIX%20rdfs%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%20SELECT%20*%20WHERE%20%7B%20%3Fcity%20a%20%3Chttp%3A%2F%2Fdbpedia.org%2Fontology%2FPlace%3E%3B%20rdfs%3Alabel%20%27Boulaide%27%40en.%20%20%3Fairport%20a%20%3Chttp%3A%2F%2Fdbpedia.org%2Fontology%2FAirport%3E.%20%7B%3Fairport%20%3Chttp%3A%2F%2Fdbpedia.org%2Fontology%2Fcity%3E%20%3Fcity%7D%20UNION%20%7B%3Fairport%20%3Chttp%3A%2F%2Fdbpedia.org%2Fontology%2Flocation%3E%20%3Fcity%7D%20UNION%20%7B%3Fairport%20%3Chttp%3A%2F%2Fdbpedia.org%2Fproperty%2FcityServed%3E%20%3Fcity.%7D%20UNION%20%7B%3Fairport%20%3Chttp%3A%2F%2Fdbpedia.org%2Fontology%2Fcity%3E%20%3Fcity.%20%7D%7B%3Fairport%20%3Chttp%3A%2F%2Fdbpedia.org%2Fproperty%2Fiata%3E%20%3Fiata.%7D%20UNION%20%20%7B%3Fairport%20%3Chttp%3A%2F%2Fdbpedia.org%2Fontology%2FiataLocationIdentifier%3E%20%3Fiata.%20%7D%20OPTIONAL%20%7B%20%3Fairport%20foaf%3Ahomepage%20%3Fairport_home.%20%7D%20OPTIONAL%20%7B%20%3Fairport%20rdfs%3Alabel%20%3Fname.%20%7D%20OPTIONAL%20%7B%20%3Fairport%20%3Chttp%3A%2F%2Fdbpedia.org%2Fproperty%2Fnativename%3E%20%3Fairport_name.%7D%20FILTER%20%28%20%21bound%28%3Fname%29%20%7C%7C%20langMatches%28%20lang%28%3Fname%29%2C%20%27de%27%29%20%29%7D";
		String q2 = "/sparql?query=PREFIX++dc%3A+++%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Felements%2F1.1%2F%3E%0APREFIX++dbpedia2%3A+%3Chttp%3A%2F%2Fdbpedia.org%2Fproperty%2F%3E%0APREFIX++dbpedia-owl%3A+%3Chttp%3A%2F%2Fdbpedia.org%2Fontology%2F%3E%0APREFIX++geo%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F2003%2F01%2Fgeo%2Fwgs84_pos%23%3E%0APREFIX++foaf%3A+%3Chttp%3A%2F%2Fxmlns.com%2Ffoaf%2F0.1%2F%3E%0APREFIX++yago%3A+%3Chttp%3A%2F%2Fmpii.de%2Fyago%2Fresource%2F%3E%0APREFIX++georss%3A+%3Chttp%3A%2F%2Fwww.georss.org%2Fgeorss%2F%3E%0APREFIX++geonames%3A+%3Chttp%3A%2F%2Fwww.geonames.org%2Fontology%23%3E%0APREFIX++umbel-ac%3A+%3Chttp%3A%2F%2Fumbel.org%2Fumbel%2Fac%2F%3E%0APREFIX++units%3A+%3Chttp%3A%2F%2Fdbpedia.org%2Funits%2F%3E%0APREFIX++dcterms%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2F%3E%0APREFIX++gn%3A+++%3Chttp%3A%2F%2Fxldb.di.fc.ul.pt%2Fxldb%2Fpublications%2F2009%2F10%2Fgeo-net%23%3E%0APREFIX++rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0APREFIX++gnpt%3A+%3Chttp%3A%2F%2Fxldb.di.fc.ul.pt%2Fxldb%2Fpublications%2F2009%2F10%2Fgeo-net-pt%23%3E%0APREFIX++umbel-sc%3A+%3Chttp%3A%2F%2Fumbel.org%2Fumbel%2Fsc%2F%3E%0APREFIX++xsd%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0APREFIX++owl%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0APREFIX++dbpedia%3A+%3Chttp%3A%2F%2Fdbpedia.org%2F%3E%0APREFIX++gnpt02%3A+%3Chttp%3A%2F%2Fxldb.di.fc.ul.pt%2Fxldb%2Fpublications%2F2009%2F10%2Fgeo-net-pt-02%23%3E%0APREFIX++rdf%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0APREFIX++wikicompany%3A+%3Chttp%3A%2F%2Fdbpedia.openlinksw.com%2Fwikicompany%2F%3E%0APREFIX++skos%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2004%2F02%2Fskos%2Fcore%23%3E%0APREFIX++opencyc%3A+%3Chttp%3A%2F%2Fsw.opencyc.org%2F2008%2F06%2F10%2Fconcept%2F%3E%0A%0ASELECT++%3Fy+%3Fz%0AWHERE%0A++%7B+%3Chttp%3A%2F%2Fdbpedia.org%2Fresource%2FRose%3E+%3Fy+%3Fz+%7D%0A&default-graph-uri=http%3A%2F%2Fdbpedia.org";
		System.out.println(getParam(q2, "query"));
		
	}
}
