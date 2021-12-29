
@IsTest
public with sharing class JSONParserTest {
    static String xmlString = '<catalog><books><book><title>Advanced Apex Programming</title><subTitle>for Salesforce.com and Force.com</subTitle><authors><author>Dan Appleman</author></authors><price>39.95</price></book><book><title>Design Patterns</title><authors><author>Erich Gamma</author><author>Richard Helm</author><author>Ralph Johnson</author><author>John Vlissides</author></authors><price>37.88</price></book></books></catalog>';

    //XML to Json conversion test
    @IsTest
    private static void XMLToJSonConversion_Test(){
        JSONParser parser = new JSONParser();
        String jsonString = parser.XMLToJSON(xmlString);
        String expectedOutput = '{"catalog":{"books":{"book":[{"price":"39.95","authors":{"author":"Dan Appleman"},"subTitle":"for Salesforce.com and Force.com","title":"Advanced Apex Programming"},{"price":"37.88","authors":{"author":["Erich Gamma","Richard Helm","Ralph Johnson","John Vlissides"]},"title":"Design Patterns"}]}}}';
        System.assertEquals(expectedOutput, jsonString);
    }

    //Json to XML converion test
    @IsTest
    private static void JsonToXMLConversion_Test(){
        String jsonString = '{"catalog":{"books":{"book":[{"price":"39.95","authors":{"author":"Dan Appleman"},"subTitle":"for Salesforce.com and Force.com","title":null},{"price":"37.88","authors":{"author":["Erich Gamma","Richard Helm","Ralph Johnson","John Vlissides"]},"title":"Design Patterns"}]}}}';
        JSONParser parser = new JSONParser();
        String convertedXmlString = parser.JSONToXML(jsonString);

        String expectedOutputWithDefaultOptions = '<catalog><books><book><price>39.95</price><authors><author>Dan Appleman</author></authors><subTitle>for Salesforce.com and Force.com</subTitle><title></title></book><book><price>37.88</price><authors><author>Erich Gamma</author><author>Richard Helm</author><author>Ralph Johnson</author><author>John Vlissides</author></authors><title>Design Patterns</title></book></books></catalog>';
        System.assertEquals(expectedOutputWithDefaultOptions, convertedXmlString);
    }

}