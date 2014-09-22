/**
* @author Juvoni Beckford
* @company Bluewolf
* @date 02/13/2014
* @description Test Class for AgentCenter controller. 
* @name TestAgentCenter.cls
* @type Test Class
* @see AgentCenter.cls
*/
@isTest
global class TestAgentCenter {
    
    @isTest static void testAcceptNextCasePositive() {
        user[] users = TestAgentCenter.setupBulkUsers();
        user user0 = users[0];
        user user1 = users[1];
        user user2 = users[2];

        Id overnightQueueId = QueueService.overnightQueueId;
        
        Lead lead = TestUtils.createLeadWithProduct('firstname','last', 'comp', 'New', '07601', 'Brand', 'Product_1', false);
        lead.OwnerId = overnightQueueId;
        lead.Bypass_Assignment__c = true;
        insert lead;

        Lead insertedLead = [Select Id, Derived_Product__c, ownerId from lead where Id=:lead.id];
        //system.debug(insertedLead);
        
        //-------------Start Testing
        Test.startTest();
        System.runAs(user0){
            AgentCenter.Results scenario1 = AgentCenter.acceptNextCase(user2.id);
            System.debug(scenario1);
        }
        Test.stopTest();
        //--------Stop Testing

    }
    @isTest static void testAcceptNextNegative() {
        Test.startTest();
        user[] users = TestAgentCenter.setupBulkUsers();
        user user0 = users[0];
        AgentCenter.Results scenario1 = AgentCenter.acceptNextCase(user0.id);
        System.assertEquals(false,scenario1.leadAssigned);
        System.assertEquals('There are no Leads Available for assignment at this time. Please try again later.',scenario1.errorMessage,scenario1.errorMessage); 
        Test.stopTest();
    }

    @isTest static void TestAcceptTenDayOldCasePositive(){
        Test.startTest();
        user[] users = TestAgentCenter.setupBulkUsers();
        user user1 = users[1];
        System.runAs(user1){

        Id recoveryQueueId = QueueService.recoveryQueueId;

        //Lead lead = TestUtils.createLead('firstname', 'lastName', 'company', 'Open', '07601', false);
        Lead lead = new Lead(FirstName='firstname',LastName='lastName',Company='company',Status='Open',PostalCode='07601',OwnerId=recoveryQueueId);

        //lead.ownerId= recoveryQueueId;
        insert lead;

            AgentCenter.Results case_1 = AgentCenter.acceptTenDayOldCase(user1.id);
        //  System.assertEquals('leadId', case_1.leadId);
            
        }
        //System.assertEquals(true, case_1.leadAssigned);

        Test.stopTest();
    }
    @isTest static void TestAcceptTenDayOldCaseNegative(){
        Test.startTest();
        user[] users = TestAgentCenter.setupBulkUsers();
        user user1 = users[1];

        Lead lead = TestUtils.createLead('firstname', 'lastName', 'company', 'Open', '07601', false);
        Id recoveryQueueId = QueueService.recoveryQueueId;
        lead.ownerId= recoveryQueueId;
        insert lead;

        AgentCenter.Results case_1 = AgentCenter.acceptTenDayOldCase(user1.id);
        System.assertEquals(false,case_1.leadAssigned);
        System.assertEquals('There are no Leads Available for assignment at this time. Please try again later.',case_1.errorMessage,case_1.errorMessage); 

        Test.stopTest();
    }
    @isTest static void testGetInitialAvailability(){
        Test.startTest();
        user[] users = TestAgentCenter.setupBulkUsers();
        user user0 = users[0];

        System.runAs(user0){
            AgentCenter.InitialAvailability init = AgentCenter.getInitialAvailability();    
            System.assert(init.found);
            System.assert(init.available); 
        }
        Test.stopTest();
    }

    @isTest static void testMakeUserBusy(){
        Test.startTest();
        Profile profile = TestUtils.getProfile('System Administrator');
        User user = TestUtils.createUser('lastName', 'alias', profile.Id, true);
        Datetime myDate = datetime.newInstance(2008, 12, 1, 12, 30, 2);

        Lead lead = TestUtils.createLead('firstname', 'lastName', 'company', 'Open', '07601', false);
        lead.OwnerId = user.Id;

        insert lead;
        Lead_Assignment_Setting__c las = TestUtils.createLeadAssignmentSetting(user,true,myDate,5,'Brand-Product_1',5,false);

        System.runAs(user){
            AgentCenter.makeUserBusy();
            //Lead_Assignment_Setting__c assignmentResult = [SELECT Id, Availability__c FROM Lead_Assignment_Setting__c WHERE Id = :las.Id LIMIT 1];
            //System.debug('@@@@Result of Query:'+assignmentResult);

            //System.assertEquals(false, assignmentResult.Availability__c);

        }   
        Test.stopTest();
    }

    public static User[] setupBulkUsers(){
        Profile profile = TestUtils.getProfile('System Administrator');
        //Do Personalized Setup for this Test case
        String[] products = new String[]{'Brand-Product_1','Brand-Product_3','TitleMax-Product_1'};
        Integer[] leadCapacity = new Integer[]{1,4,10};
        Integer[] totalCapacity = new Integer[]{1,2,10};
        Integer count = 3;

        Datetime myDate = datetime.newInstance(2008, 12, 1, 12, 30, 2);
        User[] users = new User[]{};
        Datetime changedDate;
        for (integer i = 0; i < count ; i++){
            changedDate = myDate.addHours(i);
            User user = TestUtils.createUser(i+'lastName', 'alias', profile.Id, true);
            Lead_Assignment_Setting__c las = TestUtils.createLeadAssignmentSetting(user,true,changedDate,leadCapacity[i],products[i],totalCapacity[i],true);    
            users.add(user);
        }
        return users;
    }   


    public static Lead setupReassign(Lead lead){
        //Pass GMT Datetime
        String stringDateGMT = '2013-10-05 03:03:20';
        TestLeadTrigger.currentTime = datetime.valueOf(stringDateGMT);
        lead.Reassigned_Lead__c = true;
        return lead;
    }

    
}