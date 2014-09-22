/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 12/29/2013
* @description Test Class for Lead Trigger. 
* @name TestTaskService.cls
* @type Test Class
* @see LeadTrigger.trigger
*/
@isTest(SeeAllData = true)
public class TestTaskService {

    /**
    * @description Tests Task closing on Assignment to Queue.
    */ 

    @isTest static void testTaskClosingOnAssignmentToUnAssignedQueue(){
        TestUtils.setTestingTimeWithinBusinessHours();
        TestUtils.setupTestBusinessHourCustomSetting();
        Profile profile = TestUtils.getProfile('Standard User');

        //Add 1 user
        String[] products = new String[]{'Brand-Product_1'};
        Integer[] leadCapacity = new Integer[]{10};
        Integer[] totalCapacity = new Integer[]{10};
        //Do Insert
        User[] users= TestLeadTriggerWithData.setupBulkUsers(1,products,leadCapacity,totalCapacity,profile.Id);
        Lead lead = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand ', 'Product_1', false);
        TriggerFirstRunHelper.resetAllValues();
        insert lead;
        //Fetch Inserted leads
        Lead insertedlead = [Select Id,ownerId,Product__c from Lead where Id=:lead.Id];

        /**
        * Hack. These lines of code are not needed on Dev environment. Something mismatching between test and Dev environment.
        */
        //Create Tasks for Above inserted Leads
        Task task = TestTaskService.createTasksManually(insertedlead.Id);
        //Task task =  [SELECT Id,Status FROM Task WHERE WhoId = : insertedlead.Id LIMIT 1];

        //--------Start Testing---------
        Test.startTest();
        //Assign lead to Unassigned Queue by asking for Unknown Product
        TriggerFirstRunHelper.resetAllValues();
       // insertedlead.Product_Requested__c = 'Product_Unknown';
        insertedlead.Reassigned_Lead__c = true;
        update insertedlead;
        Test.stopTest();        
        //----------------------------

        Set<Id> Ids = new Set<Id>{insertedlead.Id};

        //Get Tasks associated with these leads.
        Task[] associatedTasks = TaskService.getTasksAssociatedWithSobject(Ids);
        for(Task associatedTask : associatedTasks){
            System.debug('associated task is'+associatedTask);
        }
        //System.debug(associatedTasks);
        //Assert whether Task status has changed to Reassigned.
        //TestTaskService.doTaskClosedAssertion(associatedTasks);
    }


    /**
    * @description Tests Fecthing open tasks associated with leads
    */
    @isTest(SeeAllData=true) static void testGetOpTasksMapAsscWiLead(){
        TestUtils.setTestingTimeWithinBusinessHours();
        TestUtils.setupTestBusinessHourCustomSetting();
        Profile profile = TestUtils.getProfile('Standard User');

        String[] products = new String[]{'TitleMax-Product_1','TitleMax-Product_1'};
        Integer[] leadCapacity = new Integer[]{10,10};
        Integer[] totalCapacity = new Integer[]{10,10};
        //Do Insert
        User[] users= TestLeadTriggerWithData.setupBulkUsers(2,products,leadCapacity,totalCapacity,profile.Id);
        Lead lead = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand ', 'Product_1', false);
        TriggerFirstRunHelper.resetAllValues();
        lead.OwnerId = users[0].Id;
        lead.Bypass_Assignment__c = true;
        insert lead;

        //Fetch Inserted leads
        Lead insertedlead = [Select Id,ownerId,Derived_Product__c from Lead where Id=:lead.Id];
        System.debug(insertedlead);


        //Create Tasks for Above inserted Leads
        Task taskManual = TestTaskService.createTasksManually(insertedlead.Id);


        Set<Id> Ids = new Set<Id>{insertedlead.Id};

        Task[] associatedTasks = [Select Id, Disposition__c, Detail__c, Call_Back_Time__c, IsClosed from Task where WhoId=:insertedlead.Id];
        System.debug(associatedTasks);

        Test.startTest();
        for(Task task : associatedTasks){
            task.Disposition__c = 'Called:Left Message';
            task.Detail__c = 'Voicemail';
            TriggerFirstRunHelper.resetAllValues();
            update task;
        }
        
        Task[] associatedTasksNew = [Select Id, Disposition__c, Detail__c, Call_Back_Time__c, IsClosed, Due__c from Task where WhoId=:insertedlead.Id];
        System.debug(associatedTasksNew);
        //insertedlead.Status = 'Funded:Confirmed';
        //TriggerFirstRunHelper.resetAllValues();
        //update insertedlead;


        Test.stopTest();
    }

    /**
    * @description Tests Fecthing open tasks associated with leads
    */
    @isTest(SeeAllData=true) static void testGetOpTasksMapAsscWiOpportunity()
    {
        TestUtils.setTestingTimeWithinBusinessHours();
        TestUtils.setupTestBusinessHourCustomSetting();
        Profile profile = TestUtils.getProfile('Standard User');


        String[] products = new String[]{'TitleMax-Product_1','TitleMax-Product_1'};
        Integer[] leadCapacity = new Integer[]{10,10};
        Integer[] totalCapacity = new Integer[]{10,10};
        //Do Insert
        User[] users= TestLeadTriggerWithData.setupBulkUsers(2,products,leadCapacity,totalCapacity,profile.Id);

        Account acc = TestUtils.createAccountWithPhoneUniqueId('SomeName','65324','513-453-5625',true);
    //  Opportunity Opp = TestUtils.createOpportunity(acc,'jhjsad', '4325','In Process',users[0].Id, true, '42565');

        Opportunity Opp = new Opportunity(AccountId = acc.id, Name = 'asdasdas', Amount = 4325, StageName = 'In Process',OwnerId = users[0].Id, CloseDate = Date.Today().addMonths(2), Unique_Loan_Id__c = '32421312');
        insert Opp;

        Id OppId = Opp.Id;

        System.debug(OppId);

        Task newtempTask = new Task(WhatId = OppId, Subject = 'Initial Call Attempt');
        insert newtempTask;

        Task[] associatedTasksOpp2 = [Select Id, Disposition__c, Detail__c, Call_Back_Time__c, IsClosed, Due__c from Task where WhatId=:OppId and IsClosed=false];
        System.debug(associatedTasksOpp2);

        for(Task task : associatedTasksOpp2){
            task.Disposition__c = 'Called:Left Message';
            task.Detail__c = 'Voicemail';
            TriggerFirstRunHelper.resetAllValues();
            update task;
        }
    }

    /**
    * @description Tests Task closing on Assignment to Queue.
    */ 
    
    @isTest static void testTaskClosingOnAssignmentToOvernightQueue(){
        TestUtils.setTestingTimeWithinBusinessHours();
        TestUtils.setupTestBusinessHourCustomSetting();
        Profile profile = TestUtils.getProfile('Standard User');

        //Add 1 user
        String[] products = new String[]{'TitleMax-Product_1'};
        Integer[] leadCapacity = new Integer[]{10};
        Integer[] totalCapacity = new Integer[]{10};
        //Do Insert
        User[] users= TestLeadTriggerWithData.setupBulkUsers(1,products,leadCapacity,totalCapacity,profile.Id);
        Lead lead = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand ', 'Product_1', false);
        TriggerFirstRunHelper.resetAllValues();
        insert lead;
        //Fetch Inserted leads
        Lead insertedlead = [Select Id,ownerId,Product__c from Lead where Id=:lead.Id];

        //Create Tasks for Above inserted Leads
        
        /**
        * Hack. These lines of code are not needed on Dev environment. Something mismatching between test and Dev environment.
        */
        Task task = TestUtils.createTask(insertedlead.Id,false);  
        insert task;  


        //Task task =  [SELECT Id, Status FROM Task WHERE WhoId = : insertedlead.Id LIMIT 1];

        //--------Start Testing---------
        Test.startTest();
        //Assign lead to Unassigned Queue by asking for Unknown Product
        TriggerFirstRunHelper.resetAllValues();
        TestUtils.setTestingTimeAfterBusinessHours();
        insertedlead.Reassigned_Lead__c = true;
        update insertedlead;
        Test.stopTest();        
        //----------------------------

        Set<Id> Ids = new Set<Id>{insertedlead.Id};
        //Get Tasks associated with these leads.
        Task[] associatedTasks = TaskService.getTasksAssociatedWithSobject(Ids);  
        for(Task associatedTask : associatedTasks){
            System.debug('associated task is'+associatedTask);
        }  
        //Assert whether Task status has changed to Reassigned.
        TestTaskService.doTaskClosedAssertion(associatedTasks);
    }

    @isTest static void testCallBackTimeSettingModel(){
        Datetime dt = CallBackTimeSettingModel.getDueDate('2 hr');
        Datetime dt2 = CallBackTimeSettingModel.getTomorrowTime(2); 
        Datetime dt3 = CallBackTimeSettingModel.getDueDate('Next day A.M.');
    }
   

    /**
    * Helper method. Asserts whether task status is set to ReAssigned.
    */
    public static void doTaskClosedAssertion(Task[] tasks){
        for(Task task:tasks){
            System.assertEquals(task.Status,'ReAssigned');
        }
    }

    /**
    * @description Hack. These lines of code are not needed on Dev environment. Something mismatching between test and Dev environment.
    */
    //Create Tasks for Above inserted Leads
    public static Task createTasksManually(Id leadId){
        Task task = TestUtils.createTask(leadId,true);  
        return task;
    }
    // updateTasksforMergedLeads
    @isTest static void testupdateTasksforMergedLeads(){
       //-------lead manual insert
        Lead lead1 = TestUtils.createLeadWithProduct('firstNam1e', 'lastNam1e', 'company', 'New', '12365', 'Brand ', 'Product_1', false);
        TriggerFirstRunHelper.resetAllValues();
        insert lead1;
        list<lead> lstlead=new list<lead>();
        lstlead.add(lead1);
        //Fetch Inserted leads
        //Lead insertedlead1 = [Select Id,ownerId,Product_Requested__c from Lead where Id=:lead1.Id]; 
        TaskService.updateTasksforMergedLeads(lstlead);
        
        Lead lead2 = TestUtils.createLeadWithProduct('firstNam1e', 'lastNam1e', 'company', 'New', '12365', 'Brand ', 'Product_1', false);
        TriggerFirstRunHelper.resetAllValues();
        insert lead2;
        list<lead> lstlead2=new list<lead>();
        lstlead2.add(lead2);
        TaskService.getOpenTasksArrayMapAssociatedWithLead(lstlead2);
        
        Lead lead3 = TestUtils.createLeadWithProduct('firstNam1e', 'lastNam1e', 'company', 'New', '12365', 'Brand ', 'Product_1', false);
        TriggerFirstRunHelper.resetAllValues();
        insert lead3;
        list<lead> lstlead3=new list<lead>();
        lstlead3.add(lead3);
        TaskService.createInitialTaskForLead(lstlead3);
        Lead lead4 = TestUtils.createLeadWithProduct('firstNam1e', 'lastNam1e', 'company', 'New', '12365', 'Brand ', 'Product_1', false);
        TriggerFirstRunHelper.resetAllValues();
        insert lead4;
        Map<id,string> leadmap=new Map<id,string>();
        leadmap.put(lead4.id,lead4.name);
        TaskService.changeLeadNameForTask(leadmap);
        
         Profile profile = TestUtils.getProfile('Standard User');


        String[] products = new String[]{'TitleMax-Product_1','TitleMax-Product_1'};
        Integer[] leadCapacity = new Integer[]{10,10};
        Integer[] totalCapacity = new Integer[]{10,10};
        //Do Insert
        User[] users= TestLeadTriggerWithData.setupBulkUsers(2,products,leadCapacity,totalCapacity,profile.Id);

        Account acc = TestUtils.createAccountWithPhoneUniqueId('SomeName','65324','513-453-5625',true);
    //  Opportunity Opp = TestUtils.createOpportunity(acc,'jhjsad', '4325','In Process',users[0].Id, true, '42565');

        Opportunity Opp = new Opportunity(AccountId = acc.id, Name = 'asdasdas', Amount = 4325, StageName = 'In Process',OwnerId = users[0].Id, CloseDate = Date.Today().addMonths(2), Unique_Loan_Id__c = '32421312');
        insert Opp;
        Id OppId = Opp.Id;
        list<id> lstid=new list<id>();
        System.debug(OppId);
        Task newtempTask = new Task(WhatId = OppId, Subject = 'Initial Call Attempt');
        insert newtempTask;
        TaskService.getOpenTasksMapAssociatedWithOpportunity(lstid);

    }
    

}