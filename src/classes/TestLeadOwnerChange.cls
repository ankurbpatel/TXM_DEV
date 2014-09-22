@isTest
private class TestLeadOwnerChange {
	
@isTest static void testTaskClosingOnAssignmentToUnAssignedQueue(){
	/*
        TestUtils.setTestingTimeWithinBusinessHours();
        TestUtils.setupTestBusinessHourCustomSetting();
        Profile profile = TestUtils.getProfile('Standard User');

        //Add 1 user
        String[] products = new String[]{'Brand-Product_1','Brand-Product_1'};
        Integer[] leadCapacity = new Integer[]{10,10};
        Integer[] totalCapacity = new Integer[]{10,10};
        //Do Insert
        User[] users= TestLeadTriggerWithData.setupBulkUsers(2,products,leadCapacity,totalCapacity,profile.Id);
         //--------Start Testing---------
        Test.startTest();       
        Lead lead = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand ', 'Product_1', false);
        TriggerFirstRunHelper.resetAllValues();
        insert lead;
        //Fetch Inserted leads
        Lead insertedlead = [Select Id,ownerId,Derived_Product__c,Reassigned_Lead__c,Product_Requested__c from Lead where Id=:lead.Id];
        Task[] task1 =  [SELECT Id,Status,Subject,ownerId FROM Task WHERE WhoId = : insertedlead.Id LIMIT 1];
        
        insertedlead.Reassigned_Lead__c = true;
        TriggerFirstRunHelper.resetAllValues();
        update insertedlead;
        Task[] task2 =  [SELECT Id,Status,Subject,ownerId FROM Task WHERE WhoId = : insertedlead.Id LIMIT 1];
        
        TriggerFirstRunHelper.resetAllValues();
        insertedlead.Product_Requested__c = 'Product_Unknown';
        insertedlead.Reassigned_Lead__c = true;
        update insertedlead;
        Task[] task3 =  [SELECT Id,Status,Subject,ownerId FROM Task WHERE WhoId = : insertedlead.Id LIMIT 1];
       

        System.debug(task1);
        System.debug(task2);
        System.debug(task3);
        System.debug(users);
        Test.stopTest();        
        //TestTaskService.doTaskClosedAssertion(task3);
    */

    }
	
	
}