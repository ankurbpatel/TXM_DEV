/*
 Author: Hema
 Date: 05/09/2014
 Description: This is a test class for LeadMergeUtility cls.
*/
@isTest

public class TestUserDeactivatedLeads {
    public static testMethod void UserDeactivatedLeads(){
        
            Profile profile = TestUtils.getProfile('TMX_OSR');
            User user = TestUtils.createUser('OSR', 'alias', profile.Id, true);
            User user2 = new User(LastName = 'Manager', Alias = 'alias2' , Email = 'Manager@childfund.org', Username = 'ManagerforTest@test.com',
                                    ProfileId = profile.Id, IsActive = true, LanguageLocaleKey = 'en_US', TimeZoneSidKey = 'America/New_York',
                                    EmailEncodingKey = 'ISO-8859-1', LocaleSidKey = 'en_US');
            insert user2;
           
            Lead lead = TestUtils.createLead('firstname', 'lastName', 'company', 'In Process', '07601', false);
            lead.OwnerId = user.Id;
            insert lead;
            Account acc = TestUtils.createAccount('Test Acc', '565623',true);
            Opportunity opp = TestUtils.createOpportunity(acc, 'Name', 1000, 'In Process', user.Id,true,'555');
            Task task = TestUtils.createTask(lead.Id,true);
            task.OwnerId=user.Id;
            update task;
            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
            System.runAs ( thisUser ) {
            Test.startTest();
                user.ManagerId=user2.Id;
                user.isActive=false;
                update user;
            Test.stopTest();
            }
    }
}