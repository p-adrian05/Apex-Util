public with sharing class JSONParser {

    private String rootElement;
    private Boolean serializeNulls = true;

    public String XMLToJSON(String xmlString){
        return System.JSON.serialize(XMLToUnTyped(xmlString));
    } 
    private  Map<String,Object> XMLToUnTyped(String xmlString){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        Dom.Document doc = new Dom.Document();
        doc.load(xmlString);
        Dom.XmlNode root = doc.getRootElement();
        fieldValueMap.put(root.getName(), (Map<String,Object>)parseNode(root));
        return fieldValueMap;
    }  
    private Object parseNode(Dom.XmlNode node){
        if (node.getChildElements().size() > 0) {
            return complexNodeToMap(node);
        } else {
            return node.getText();
        }
    }
    private Map<String,Object> complexNodeToMap(Dom.XmlNode node){
        Map<String,Object> cNodeMap = new Map<String,Object>();
        for(Dom.XmlNode cNode : node.getChildren()){
            if(cNodeMap.containsKey(cNode.getName())){            
                Object o = cNodeMap.get(cNode.getName());
                if (o instanceof List<Object>) {
                    ((List<Object>) o).add(parseNode(cNode));
                } else {
                    cNodeMap.put(cNode.getName(), new List<Object>{
                            o, parseNode(cNode)
                    });
                }
            } else {
                cNodeMap.put(cNode.getName(), parseNode(cNode));
            }
        }
        return cNodeMap;
    }

    public String JSONtoXML(String jsonString){
        Object deSerialized = JSON.deserializeUntyped(jsonString);
        return !String.isEmpty(rootElement) ? wrap(rootElement,serialize((Map<String,Object>)deSerialized)) : serialize((Map<String,Object>)deSerialized);
    }


    private String serialize(Map<String,Object> objectMap){
        String xmlString = '';
        for(String key:objectMap.keySet()){
            Object o = objectMap.get(key);
            if(o == null) {
                if(this.serializeNulls){
                    xmlString += wrap(key,null);
                }
            }
            else if (o instanceof List<Object>) {
                xmlString += serialize((List<Object>) o, key);
            }
            else if (o instanceof Map<String, Object>) {
                xmlString += wrap(key, serialize((Map<String, Object>) o));
            } else {
                xmlString += wrap(key, String.valueOf(o));
            }
        }
        return xmlString;
    }

    private String serialize(List<Object> objectList, String key){
        String xmlString = '';
        for(Object o:objectList){
            if (o instanceof String) {
                xmlString += wrap(key, String.valueOf(o));
            }
            else if (o instanceof List<Object>) {
                xmlString += wrap(key, serialize((List<Object>) o, key));
            }
            else {
                xmlString += wrap(key,serialize((Map<String,Object>) o));
            }
        }
        return xmlString;
    }

    private String wrap(String key, String value){
        return (String.isNotBlank(value) || serializeNulls) ? ('<' + key + '>' + (String.isBlank(value)?'':value) + '</' + key + '>') : value;
    }

}