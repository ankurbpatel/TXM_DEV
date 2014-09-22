/*
 Author: Hema
 Date: 01/30/2014
 Description: This is a test class for LeadMergeUtility cls.
*/
@isTest

public class TestLeadMergeUtility {
    
    @isTest static void testNoMatch1(){
        
        TestLeadMergeUtility.setUpUsers();
    Lead lead1 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
    //Test.startTest();
        insert lead1;
    //Test.stopTest();
    list<Lead> leadlst=new list<Lead>();
    leadlst.add(lead1);
    
    Map<id,id> perfectmatchid=new Map<id,id>();
    perfectmatchid.put(lead1.id, lead1.Id);
    Map<id,Lead> leadPerMatchMap=new Map<id,Lead>();
    leadPerMatchMap.put(lead1.id, lead1);    
    Map<lead,list<lead>> ambiguousMatch=new Map<lead,list<lead>>();
    ambiguousMatch.put(lead1, leadlst);
    LeadMergeUtility obj=new LeadMergeUtility();
    LeadMergeUtility.mergeLeads(perfectmatchid, leadPerMatchMap, ambiguousMatch);
    }
    
    
@isTest static void testNoMatch(){
    //Do setup
    TestLeadMergeUtility.setUpUsers();
    Lead lead1 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
    
    Test.startTest();
        insert lead1;
    Test.stopTest();
    //--Assert--------
    LeadMergeUtility lmu=new LeadMergeUtility();
   
    
    
    }

@isTest static void testPerfectMatch(){
    //Do setup
    TestLeadMergeUtility.setUpUsers();
    Lead lead = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',true);
    Lead lead2 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
    
    Test.startTest();
        TriggerFirstRunHelper.firstRunDeDupe = true;
        insert lead2;
    Test.stopTest();
    //--Assert--------
   //system.assertEquals(lead.MasterRecordId, lead2.id); 
   Lead[] result = [SELECT Id, Name FROM Lead WHERE Id=:lead.Id];
   System.assertEquals(1, result.size());   
    }

@isTest static void testMatchWithDiffBrand(){
    //Do setup
    TestLeadMergeUtility.setUpUsers();
    Lead lead = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',true);
    Lead lead2 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand2', 'Product_1',false);
    
    Test.startTest();
        TriggerFirstRunHelper.firstRunDeDupe = true;
        insert lead2;
    Test.stopTest();
    //--Assert--------

    }


@isTest static void testAmbiguousMatch(){
    //Do setup
    TestLeadMergeUtility.setUpUsers();
    Lead lead1 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
    Lead lead2 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
    Lead lead3 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
    
    Lead[] leads = new Lead[]{lead1,lead2};
    insert leads;
    Test.startTest();
        TriggerFirstRunHelper.firstRunDeDupe = true;
        insert lead3;
    Test.stopTest();
    //--Assert--------

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

    public static Lead createLead(Boolean bypassAssignment, String phone, String brand, String product, Boolean isInsert){
        Lead lead = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', brand, product, false);
        lead.Bypass_Assignment__c = bypassAssignment;
        lead.Phone=phone;
        //lead.Product_Requested__c=product;
        if(isInsert){
            insert lead;
        }
        return lead;
    }

    public static void setUpUsers(){
        Profile profile = TestUtils.getProfile('Standard User');
        String[] products = new String[]{'Brand-Product_1'};
        Integer[] leadCapacity = new Integer[]{12};
        Integer[] totalCapacity = new Integer[]{12};
        User[] users= TestLeadToAccountMatcher.setupBulkUsers(1,products,leadCapacity,totalCapacity,profile.Id);
    }

}