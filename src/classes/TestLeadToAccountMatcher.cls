@isTest

public with sharing class TestLeadToAccountMatcher{

 @isTest static void testUniqueMatch(){

 // Seed the database with some leads, and make sure they can

    //-----------Setup
    TestLeadToAccountMatcher.setUpUsers();
    Account acc = TestLeadToAccountMatcher.createAccount('Some Name 3','34212381','888-444-9903');
    Lead lead = TestLeadToAccountMatcher.createLead(true, '888-444-9903');

    Lead insertedLead = [Select Id, Status from lead where Id=:lead.Id];
    insertedLead.Status='Appointment Set';
   
    //----Test--------
    Test.startTest();
    //update lead.
    TriggerFirstRunHelper.firstRunConvertLeads = true;
    update insertedLead;
    Test.stopTest();
    //----------------------

    //--Assert--------
    Lead updatedLead = [Select Id, Status,IsConverted, ConvertedDate, ConvertedOpportunityId, ConvertedAccountId, ConvertedContactId from lead where Id=:lead.Id];
    //System.assertEquals(updatedLead.IsConverted, true);
    //System.assertEquals(updatedLead.ConvertedAccountId,acc.Id);
   //System.assertEquals(true, true);
    System.debug(updatedLead);  
 }


 @isTest static void testNoMatch(){

 // Seed the database with some leads, and make sure they can

    //-----------Setup
    TestLeadToAccountMatcher.setUpUsers();
    Lead lead = TestLeadToAccountMatcher.createLead(true,'34212111');

    Lead insertedLead = [Select Id, Status from lead where Id=:lead.Id];
    insertedLead.Status='Appointment Set';
   
    //----Test--------
    Test.startTest();
    //update lead.
    TriggerFirstRunHelper.firstRunConvertLeads = true;
    update insertedLead;
    Test.stopTest();
    //----------------------

    //--Assert--------
    Lead updatedLead = [Select Id, Status,IsConverted from lead where Id=:lead.Id];
   System.assertEquals(updatedLead.IsConverted, true);
   //System.assertEquals(true, true);
    System.debug(updatedLead);  
 }


 @isTest static void testDoubleMatch(){

 // Seed the database with some leads, and make sure they can

    //-----------Setup
    TestLeadToAccountMatcher.setUpUsers();
    Lead lead = TestLeadToAccountMatcher.createLead(true, '888-444-9909');
    Account acc1 = TestLeadToAccountMatcher.createAccount('Some Name1','34212098','888-444-9909');
    Account acc2 = TestLeadToAccountMatcher.createAccount('Some Name2','34212319','888-444-9909');

    Lead insertedLead = [Select Id, Status from lead where Id=:lead.Id];
    insertedLead.Status='Appointment Set';
   
    //----Test--------
    Test.startTest();
    TriggerFirstRunHelper.firstRunConvertLeads = true;
    //update lead.
    update insertedLead;
    Test.stopTest();
    //----------------------

    //--Assert--------
    Lead updatedLead = [Select Id, Status,IsConverted from lead where Id=:lead.Id];
    System.assertEquals(updatedLead.IsConverted, false);
   //System.assertEquals(true, true);
    System.debug(updatedLead);  
 }


    public static User[] setupBulkUsers(Integer count,String[] products,Integer[] leadCapacity,Integer[] totalCapacity,Id profileId){
    TestUtils.setTestingTimeWithinBusinessHours();
    TestUtils.setupTestBusinessHourCustomSetting();
        Datetime myDate = datetime.newInstance(2008, 12, 1, 12, 30, 2);
        User[] users = new User[]{};
        Datetime changedDate;
        for (integer i = 0; i < count ; i++){
            changedDate = myDate.addHours(i);
            User user = TestUtils.createUser(i+'lastName', 'alias', profileId, true);
            Lead_Assignment_Setting__c las = TestUtils.createLeadAssignmentSetting(user,true,changedDate,leadCapacity[i],products[i],totalCapacity[i],true);   
            users.add(user);
        }
        return users;
    }

    public static Lead createLead(Boolean bypassAssignment, String phone){
        Lead lead = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand', 'Product_1', false);
        lead.Bypass_Assignment__c = bypassAssignment;
        lead.Phone=phone;
        insert lead;
        return lead;
    }

    public static  Account createAccount(String name, String recordId, String phone){
        Account acc = TestUtils.createAccount(name, recordId, false);
        acc.Phone=phone;
        insert acc;
       
        return acc;
    }

    public static void setUpUsers(){
        Profile profile = TestUtils.getProfile('Standard User');
        String[] products = new String[]{'Brand-Product_1'};
        Integer[] leadCapacity = new Integer[]{12};
        Integer[] totalCapacity = new Integer[]{12};
        User[] users= TestLeadToAccountMatcher.setupBulkUsers(1,products,leadCapacity,totalCapacity,profile.Id);
    }

}