@IsTest
public with sharing class DatabaseUtilTest {

    private final static String ACCOUNT_NAME_DEFAULT = 'Test Account name';
    private final static String OPP_NAME_DEFAULT = 'Test Opoortunity name';
   
    @testSetup 
    public static void setup() {
        List<SObject> sobjects = new List<SObject>();
          for(Integer i = 1; i<=3; i++){
            Account account = new Account();
            account.Name = ACCOUNT_NAME_DEFAULT +i;
            sobjects.add(account);
          }
        Opportunity opp = new Opportunity();
        opp.CloseDate = Date.newInstance(2021, 11, 30);
        opp.Name = OPP_NAME_DEFAULT;
        opp.StageName = 'test';

        sobjects.add(opp);
        insert sobjects;
    }

    @IsTest
    public static void testQuerySObjectsByIdsWithListOfIdShouldReturnQueriedSObjects(){
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name LIKE :ACCOUNT_NAME_DEFAULT];
        List<Opportunity> opps = [SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE Name LIKE :OPP_NAME_DEFAULT];
        List<Id> ids = new List<Id>();
        ids.addAll(filterIds(accounts));
        ids.addAll(filterIds(opps));

        List<SObject> sObjects = DatabaseUtil.querySObjectsByIds(ids);

        List<Id> resultIds = filterIds(sObjects);
        System.assertEquals(accounts.size()+opps.size(), sObjects.size());

        for(SObject sObj : sObjects){
            String type = String.valueOf(sObj.getSObjectType());
            switch on type {
                when 'Account' {
                    System.assert(resultIds.contains(sObj.Id));
                }
                when 'Opportunity' {
                    System.assert(resultIds.contains(sObj.Id));
                }
            }
        }
    }
    @IsTest
    public static void testQuerySObjectsByIdsWithListOfIdAndTypeShouldReturnQueriedSObjects(){
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name LIKE :ACCOUNT_NAME_DEFAULT];
        List<Id> ids = filterIds(accounts);
    
        List<SObject> sObjects = DatabaseUtil.querySObjectsByIds(ids,'Account');

        System.assertEquals(accounts.size(), sObjects.size());

        for(SObject sObj : sObjects){
            System.assert(accounts.contains((Account)sObj));
        }
    }
    @IsTest
    public static void testQuerySObjectsByIdsWithWrongFieldShouldThrowException(){
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name LIKE :ACCOUNT_NAME_DEFAULT];
        List<Id> ids = filterIds(accounts);
    
        try{
            DatabaseUtil.querySObjectsByIds(ids,'Account',new List<String>{'Name','wrong'});
        }catch(System.QueryException e){
            System.assert(e.getMessage().contains('No such column \'wrong\''));
        }
    }

    private static List<Id> filterIds(List<SObject> sObjects){
        List<Id> ids = new List<Id>();
        for(SObject sObj : sObjects){
            ids.add(sObj.Id);
        }
        return ids;

    }
    
    
}