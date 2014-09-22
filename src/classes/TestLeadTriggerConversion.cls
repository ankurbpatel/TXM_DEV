/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 01/20/2013
* @description Test Class for Lead Trigger. 
* Tests the lead conversion part.
* @name TestLeadTriggerConversion.cls
* @type Test Class
* @see LeadTrigger.trigger
*/
@isTest
public with sharing class TestLeadTriggerConversion {
    @isTest static void TestNoMatch(){
        User[] users = TestLeadTriggerConversion.setUpUsers();
        Lead insertedLead = TestLeadTriggerConversion.setUpLead(users[0].Id, 'No', 'Match','3153155695');
        insertedLead.Status = 'Funded:Confirmed';

        //----------
        Test.startTest();
        System.runAs(users[0]){
            TriggerFirstRunHelper.firstRunConvertLeads = true;
            update insertedLead;
        }        
        Test.stopTest();  
        //----------
        Lead updatedLead = [Select Id, Status, IsConverted from Lead where Id=:insertedLead.Id];
        System.assert(updatedLead.IsConverted);
        System.debug(updatedLead);  
    }

    @isTest static void TestSingleMatch(){
        //Create Account.
        Account account1 = TestUtils.createAccountWithPhoneUniqueId('Perfect Match', '588156', '3153155695', true);
        User[] users = TestLeadTriggerConversion.setUpUsers();
        Lead insertedLead = TestLeadTriggerConversion.setUpLead(users[0].Id, 'Perfect', 'Match', '3153155695');
        insertedLead.Status = 'Funded:Confirmed';
        
        //----------
        Test.startTest();
        System.runAs(users[0]){
            TriggerFirstRunHelper.firstRunConvertLeads = true;
            update insertedLead;
        }
        Test.stopTest();  
        //------------
        Lead updatedLead = [Select Id, Status, IsConverted, ConvertedAccountId, ConvertedOpportunityId  from Lead where Id=:insertedLead.Id];
        System.assert(updatedLead.IsConverted);
        System.assertEquals(updatedLead.ConvertedAccountId,account1.Id);
        System.debug(updatedLead);  
    }

    @isTest static void TestDoubleMatch(){
        //Create 2 duplicate accounts.
        User[] users = TestLeadTriggerConversion.setUpUsers();
        Account account2 = TestUtils.createAccountWithPhoneUniqueId('Double Match', '54356', '3153155696', true);
        Account account3 = TestUtils.createAccountWithPhoneUniqueId('Double Matched', '34342', '3153155696', true);
 
        TriggerFirstRunHelper.firstRunAssignmentInsert = true;
        Lead insertedLead = TestLeadTriggerConversion.setUpLead(users[0].Id, 'Double', 'Matchedss', '3153155696');
        insertedLead.Status = 'Funded:Confirmed';
        //----------
        Test.startTest();
        System.runAs(users[0]){
            TriggerFirstRunHelper.firstRunConvertLeads = true;
            update insertedLead;
        }        
        Test.stopTest();  
        //----------
        Lead updatedLead = [Select Id, Status, IsConverted from Lead where Id=:insertedLead.Id];
        System.assertEquals(updatedLead.IsConverted,false);
        Ambiguous_Lead__c[] ambiguousLeads = [Select Id from Ambiguous_Lead__c where lead__c=:insertedLead.Id];
        for(Ambiguous_Lead__c ambiguousLead :ambiguousLeads){



        System.debug(ambiguousLead);
        Lead_Account_Ambiguous_Match__c[] leadAccountMaps = [Select Id,Account__c from Lead_Account_Ambiguous_Match__c where Ambiguous_Lead__c=:ambiguousLead.Id];
        System.debug(leadAccountMaps);
        System.assertEquals(leadAccountMaps.size(),2);     
        System.debug(updatedLead); 
        }

    }

    public static User[] setUpUsers(){
        TestUtils.setTestingTimeWithinBusinessHours();
        TestUtils.setupTestBusinessHourCustomSetting();
        Profile profile = TestUtils.getProfile('System Administrator');

        //Do Personalized Setup for this Test case
        String[] products = new String[]{'Brand-Product_1','Brand-Product_1'};
        Integer[] leadCapacity = new Integer[]{10,10};
        Integer[] totalCapacity = new Integer[]{10,10};

            //Create 2 users
        User[] users = TestLeadTriggerWithData.setupBulkUsers(2, products, leadCapacity, totalCapacity, profile.Id);
        return users;
        
    }   

    public static lead setUpLead(Id userId, String firstName, String lastName, String phone){
        Lead lead = TestUtils.createLeadWithProduct(firstName, lastName, 'company', 'New', '07601', 'Brand', 'Product_1', false);
        lead.Ownerid = userId;
        lead.Bypass_Assignment__c = true;
        lead.Phone = phone;
        insert lead;
        Lead insertedLead = [Select Id, Status from Lead where Id=:lead.Id];
        return insertedLead;
    } 
}