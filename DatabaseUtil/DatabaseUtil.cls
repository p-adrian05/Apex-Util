public with sharing class DatabaseUtil {
    
    public static List<SObject> querySObjectsByIds(List<Id> recordIds){
        List<SObject> sObjects = new List<SObject>();
        Set<String> types = new Set<String>();
        for(Integer i=0, j=recordIds.size(); i < j; i++){
            types.add(recordIds.get(i).getSobjectType().getDescribe().getName());
        }
        for(String type : types){
            sObjects.addAll(querySObjectsByIds(recordIds, type,getFieldsForSObject(type)));
        }
        return sObjects;
    }
    public static List<SObject> querySObjectsByIds(List<Id> recordIds, String sObjectTypeName, List<String> fields){
        return Database.query('SELECT '+convertFieldsToString(fields)+ ' FROM '+ sObjectTypeName+' WHERE Id IN : recordIds');
    }

    private static String convertFieldsToString(List<String> fields){
        String stringFields = '';
        for(Integer i=0, j=fields.size(); i < j; i++){
            stringFields += fields.get(i)+ ',';
        }
        stringFields = stringFields.substring(0,stringFields.lastIndexOf(','));
        return stringFields;
    }

    public static List<SObject> querySObjectsByIds(List<Id> recordIds, String sObjectTypeName){
       return querySObjectsByIds(recordIds,sObjectTypeName, getFieldsForSObject(sObjectTypeName));
    }

    private static List<String> getFieldsForSObject(String objectType){
        List<String> fields = new List<String>();

        SObjectType type = Schema.getGlobalDescribe().get(objectType);
        Map<String,Schema.SObjectField> sObjectFields = type.getDescribe().fields.getMap();

        for(String fieldName: sObjectFields.keySet()){
           fields.add(String.valueOf(sObjectFields.get(fieldName)));
        }

        return fields;
    }

    public static FieldDefinition queryFieldDefinitionByDurableId(String durableId){
        return [SELECT FIELDS(STANDARD)
                    FROM FieldDefinition
                    WHERE DurableId = :durableId];
    }

    public static User queryCurrentUserWithFields(List<String> fields){
        Id currentUserId = UserInfo.getUserId();
        return Database.query('SELECT '+ convertFieldsToString(fields) + ' FROM User WHERE Id = : currentUserId');
    }

    public static String queryCurrentUserFieldValue(String field){
        User user = queryCurrentUserWithFields(new List<String>{field});
        return String.valueOf(user.get(field));
    }

}