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
			if(p.getName().contains(param)) return p.getValue();
		}
		return "";
		
	}
	
	public static String getQueryForDBpedia(String sparql){
		String q1 = DBPediaUtils.getParam(sparql, "query");
		return refineForDBPedia(q1);
	}
}
