/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 12/29/2013
* @description Test Class for Lead Trigger. 
* Please do not be confused by name.
* It was initially setup to use org data. Currently no method uses org data.
* @name TestLeadTriggerWithData.cls
* @type Test Class
* @see LeadTrigger.trigger
*/
@isTest
public class TestLeadTriggerWithData {

    /**
    * @description Tests a Single Record Insert.
    */
    @isTest static void testInsertWithMultipleUsersAndProducts(){
        TestUtils.setTestingTimeWithinBusinessHours();
        TestUtils.setupTestBusinessHourCustomSetting();
        Profile profile = TestUtils.getProfile('Standard User');

        //Do Personalized Setup for this Test case
        String[] products = new String[]{'TitleMax-Product_1;TitleMax-Product_3','TitleMax-Product_1;TitleMax-Product_2','TitleMax-Product_1;TitleMax-Product_5','TitleMax-Product_1;TitleMax-Product_4','TitleMax-Product_1'};
        Integer[] leadCapacity = new Integer[]{6,5,2,3,1};
        Integer[] totalCapacity = new Integer[]{12,7,4,3,1};
        User[] users= TestLeadTriggerWithData.setupBulkUsers(5,products,leadCapacity,totalCapacity,profile.Id);
        Lead lead = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand', 'Product_5', true);
        
        Lead insertedlead = [Select Id, Reassigned_Lead__c,Derived_Product__c from Lead where Id=:lead.Id];
        insertedlead.Reassigned_Lead__c = true;

        System.debug(insertedlead);
        //---------Start Testing
        Test.startTest();
        TriggerFirstRunHelper.firstRunAssignmentUpdate = true;      
        update insertedlead;        
        Test.stopTest();
        //---------------------------

        Id userId = users[2].Id;
        Lead updatedlead = [Select Id,ownerId,Derived_Product__c from Lead where Id=:lead.Id];
        Id ownerId = (updatedlead.ownerId);
        System.assertEquals(ownerId,userId);
        TestLeadTriggerWithData.doLastAssignedAssertion(userId);        
    }   

    /**
    * @description Tests Insert for users with existing opportunity and leads. Also check assignment to Unassigned Queue
    */
    @isTest static void testCustomInsert(){
        TestUtils.setTestingTimeWithinBusinessHours();
        TestUtils.setupTestBusinessHourCustomSetting();
        Profile profile = TestUtils.getProfile('Standard User');

        //Do Personalized Setup for this Test case
        String[] products = new String[]{'TitleMax-Product_18','TitleMax-Product_18'};
        Integer[] leadCapacity = new Integer[]{4,5};
        Integer[] totalCapacity = new Integer[]{10,7};

        //Create 2 users
        User[] users= TestLeadTriggerWithData.setupBulkUsers(2,products,leadCapacity,totalCapacity,profile.Id);
        //Assign 5 opportunities to user[1]
        TestLeadTriggerWithData.setupOpportunitiesForUser(5,'Open',users[1].Id);
        //Assign 2 leads for user[0]
        TestLeadTriggerWithData.setupLeadsForUser(2, users[0].Id, 'Brand', 'Product_18');
        //---------Start Testing
        Lead lead1 = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand', 'Product_18', false); 
        Lead lead2 = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand', 'Product_18', false); 
        Lead lead3 = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand', 'Product_18', false); 
        Lead lead4 = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand', 'Product_18', false); 
        Lead lead5 = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand', 'Product_18', false); 
        Lead lead6 = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand', 'Product_18', false);     
        Lead lead7 = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand', 'Product_Unknown18', false);      
        Lead lead8 = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand', 'Product_Unknown18', false);
        Lead[] leads =new Lead[]{lead1,lead2,lead3,lead4,lead5,lead6,lead7,lead8};
        TriggerFirstRunHelper.resetAllValues();
        insert leads;

        Lead[] insertedLeads = new Lead[] {};
        for(Lead insertedLead : [Select Id,ownerId,Derived_Product__c, Reassigned_Lead__c from Lead where Id IN:leads]){
            insertedlead.Reassigned_Lead__c = true;
            insertedLeads.add(insertedLead);
        } 

        Test.startTest();
        TriggerFirstRunHelper.resetAllValues();
        update insertedLeads;


        Test.stopTest();
        //---------------------------
        Id ownerLead1 = [Select Id,ownerId from Lead where Id=:lead1.Id].ownerId;   

        Id ownerLead2 = [Select Id,ownerId from Lead where Id=:lead2.Id].ownerId;   

        Id ownerLead3 = [Select Id,ownerId from Lead where Id=:lead3.Id].ownerId;   
        
        Id ownerLead4 = [Select Id,ownerId from Lead where Id=:lead4.Id].ownerId;

        Id ownerLead5 = [Select Id,ownerId from Lead where Id=:lead5.Id].ownerId;

        Id ownerLead6 = [Select Id,ownerId from Lead where Id=:lead6.Id].ownerId;
        
        Id ownerLead7 = [Select Id,ownerId from Lead where Id=:lead7.Id].ownerId;

        Id ownerLead8 = [Select Id,ownerId from Lead where Id=:lead8.Id].ownerId;

        Id unassignedId = QueueService.unassignedQueueId;
        Id exceptionId = QueueService.exceptionQueueId;

        System.debug(exceptionId);
        System.debug(unassignedId);

        System.assertEquals(ownerlead1,users[0].Id);
        System.assertEquals(ownerlead2,users[1].Id);
        System.assertEquals(ownerlead3,users[0].Id);
        System.assertEquals(ownerlead4,users[1].Id);
      //  System.assertEquals(ownerlead5,unassignedId);
       // System.assertEquals(ownerlead6,unassignedId);   
      //  System.assertEquals(ownerlead7,exceptionId);
       // System.assertEquals(ownerlead8,exceptionId);
    
    }   
        
    /**
    * @description Tests Update operation.
    */
    @isTest static void testUpdateWithMultipleUsersAndProducts(){
        TestUtils.setTestingTimeWithinBusinessHours();
        TestUtils.setupTestBusinessHourCustomSetting();
        Profile profile = TestUtils.getProfile('Standard User');

        //Add 5 users
        String[] products = new String[]{'TitleMax-Product_1;TitleMax-Product_3','TitleMax-Product_1;TitleMax-Product_2','TitleMax-Product_1;TitleMax-Product_5','TitleMax-Product_1;TitleMax-Product_4','TitleMax-Product_1'};
        Integer[] leadCapacity = new Integer[]{6,5,2,3,1};
        Integer[] totalCapacity = new Integer[]{3,7,4,3,1};
        //Do Insert
        User[] users= TestLeadTriggerWithData.setupBulkUsers(5,products,leadCapacity,totalCapacity,profile.Id);
        Lead lead = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand', 'Product_1', true);
        //Fetch Inserted leads

        //--------Start Testing---------
        Test.startTest();
        Lead insertedlead1 = [Select Id,ownerId,Derived_Product__c,Reassigned_Lead__c from Lead where Id=:lead.Id];
    
        TriggerFirstRunHelper.firstRunAssignmentUpdate = true;  
        TestUtils.setTestingTimeWithinBusinessHours();
        insertedlead1.Reassigned_Lead__c = true;
        update insertedlead1;
        Lead updatedlead1 = [Select Id, ownerId, Derived_Product__c from Lead where Id=:lead.Id];
        Id ownerId1 = (updatedlead1.ownerId);
        //First assestion. User assignment done
        System.assertEquals(ownerId1,users[0].Id);
         //Second assertion. Lead Last assigned Date changed.
        TestLeadTriggerWithData.doLastAssignedAssertion(users[0].Id);
//---------------------------------------------------------------------------

        Lead insertedlead2 = [Select Id,ownerId,Derived_Product__c,Reassigned_Lead__c from Lead where Id=:lead.Id]; 
        TriggerFirstRunHelper.firstRunAssignmentUpdate = true;  
        TestUtils.setTestingTimeWithinBusinessHours();
        insertedlead2.Reassigned_Lead__c = true;
        update insertedlead2;
        Lead updatedlead2 = [Select Id, ownerId, Derived_Product__c from Lead where Id=:lead.Id];
        //First assestion. User assignment done
        Id ownerId2 = (updatedlead2.ownerId);
       // System.assertEquals(ownerId2,users[1].Id);
         //Second assertion. Lead Last assigned Date changed.
        TestLeadTriggerWithData.doLastAssignedAssertion(users[1].Id);
        Test.stopTest();
        //----------------------------
        
    }
    
    /**
    * @description Tests Bulk Insert Operation.200 Records
    */

    @isTest static void testBulkOperationInsertRecords(){
        TestUtils.setTestingTimeWithinBusinessHours();
        TestUtils.setupTestBusinessHourCustomSetting();
        Profile profile = TestUtils.getProfile('Standard User');
        //Add 5 users
        String[] products = new String[]{'TitleMax-Product_Bulk'};
        Integer[] leadCapacity = new Integer[]{500};
        Integer[] totalCapacity = new Integer[]{500};

        User[] users= TestLeadTriggerWithData.setupBulkUsers(1,products,leadCapacity,totalCapacity,profile.Id);
        Lead[] leads = new Lead[]{};

        for(Integer i=0 ; i<200 ; i++){
            Lead lead = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand', 'Product_Bulk', false);            
            leads.add(lead);
        }
        insert leads;

        Lead[] insertedLeads = new Lead[] {};
        for(Lead insertedLead : [Select Id,ownerId,Derived_Product__c, Reassigned_Lead__c from Lead where Id IN:leads]){
            insertedlead.Reassigned_Lead__c = true;
            insertedLeads.add(insertedLead);
        } 


        System.debug(QueueService.overnightQueueId);
        System.debug(QueueService.exceptionQueueId);
        System.debug(QueueService.unassignedQueueId);
        System.debug(UserInfo.getUserId());

        //----Start Testing----------
        Test.startTest();
        TriggerFirstRunHelper.resetAllValues();
            update insertedLeads;
        Test.stopTest();
        //-----------------------------

        Id userId = users[0].Id;
        //Assertion 1, check Owner Id of leads
        for(Lead updatedLead : [Select Id,ownerId,Derived_Product__c from Lead where Id IN:insertedLeads]){
            Id ownerId = (updatedlead.ownerId);
            System.debug(updatedlead);
            //First assestion. User assignment done
            System.assertEquals(ownerId,userId);
        } 
        //Second assertion. Lead Last assigned Date changed.
        TestLeadTriggerWithData.doLastAssignedAssertion(userId);
    }
        

    



    /**
    * @description Tests By Assignment for manually created leads. This is no longer valid.
    */
    /*
    @isTest static void testInsertManualBypass(){
        TestUtils.setTestingTimeWithinBusinessHours();
        TestUtils.setupTestBusinessHourCustomSetting();
        Profile profile = TestUtils.getProfile('Standard User');

        //Do Personalized Setup for this Test case
        String[] products = new String[]{'TitleMax-Product_1','TitleMax-Product_3'};
        Integer[] leadCapacity = new Integer[]{10,10};
        Integer[] totalCapacity = new Integer[]{10,10};

        //Create 2 users
        User[] users= TestLeadTriggerWithData.setupBulkUsers(2,products,leadCapacity,totalCapacity,profile.Id);

        //---------Start Testing
        Test.startTest();

        Lead lead = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand', 'Product_1', false);   
        lead.Bypass_Assignment__c = true;
        lead.OwnerId = users[1].Id;
        TriggerFirstRunHelper = TRUE;
        insert lead;

        Test.stopTest();
        //---------------------------
        Id ownerLead = [Select Id,ownerId from Lead where Id=:lead.Id].ownerId;
        System.assertEquals(ownerLead,users[1].Id);     
        
    }
    */
//---------------------------- Setup Methods------------------------------------------------------------ 

    public static User[] setupBulkUsers(Integer count,String[] products,Integer[] leadCapacity,Integer[] totalCapacity,Id profileId){
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

    /**
    * Helper Method. Helps set multiple opportunities for a particular user.
    */
    public static void setupOpportunitiesForUser(Integer count,string stageName,Id userId){
        Account acc = TestUtils.createAccount('Test Acc', '565623',true);
        for(Integer i = 0; i < count; i++){
            Opportunity opp = TestUtils.createOpportunity(acc, 'Name'+i, 1000, stageName, userId,true,String.valueof(i));
        }
    }

    /**
    * Helper Method. Helps set multiple leads for a particular user.
    */
    public static void setupLeadsForUser(Integer count, Id userId,String brand, String productName){
        for(Integer i = 0; i < count; i++){
            TriggerFirstRunHelper.firstRun = False;
            Lead lead_existing = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', brand, productName, false);
            lead_existing.ownerId=userId;
            lead_existing.status='Open';
            insert lead_existing;
        }
    }

    /**
    * Helper method. Asserts whether user Last assigned date is equal to current date.
    */
    public static void doLastAssignedAssertion(Id userId){
        Lead_Assignment_Setting__c las2 = [Select Id,Lead_Last_Assigned_Date__c from Lead_Assignment_Setting__c where User__c=:userid];         
        Date todaysDate = System.today(); 
        Datetime userAssignedDateTime = las2.Lead_Last_Assigned_Date__c;
        Date userAssginedDate = date.newinstance(userAssignedDateTime.year(), userAssignedDateTime.month(), userAssignedDateTime.day());
        //Second assertion. Lead Last assigned Date changed.
      //  System.assertEquals(todaysDate,userAssginedDate);
    }
    
}