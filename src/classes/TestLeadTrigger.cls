/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 12/18/2013
* @description Test Class for Lead Trigger
* @name TestLeadTrigger.cls
* @type Test Class
* @see LeadTrigger.trigger
*/

/**
* @description Test Class for Lead Trigger
*/
@istest
public class TestLeadTrigger {
    public static Datetime currentTime = System.Datetime.now();

    public static Datetime getCurrentTime (){
        return currentTime;
    }

    static Lead insertSingleLeadAndSetup(){
        TestUtils.createSomeZipCodeRecords();
        Lead lead = TestUtils.createLead('firstname', 'lastName', 'company', 'Open', '10018', false);
        return lead;
    }

    static Lead[] insertBulkLeadsAndSetup(){
        TestUtils.createSomeZipCodeRecords();
        //Lead[] leads = TestUtils.createLeadsBulk('firstname', 'lastName', 'company', 'Open', '10018', false);
        
        Lead[] leads = new Lead[]{};
        for(Integer i=0 ; i<200 ; i++){
            Lead lead = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand', 'Product_Bulk', false);            
            leads.add(lead);
        }
        insert leads;
        return leads;
    }
    
    public static Lead setupReassign(Lead lead){
        //Pass GMT Datetime
        String stringDateGMT = '2013-10-05 03:03:20';
        TestLeadTrigger.currentTime = datetime.valueOf(stringDateGMT);
        lead.Reassigned_Lead__c = true;
        return lead;
    }
    
    /**
    * @description Tests a Single Record Insert.
    */
    public static testmethod void testgetTimeZoneInsert() {
        Lead lead = TestLeadTrigger.insertSingleLeadAndSetup();
        
        //-----------Start Testing
        Test.startTest();
        TriggerFirstRunHelper.firstRun = true;
        insert lead;
        Test.stopTest();
        //-----------Stop Testing

        //Assert Results
        Lead insertedLead = [Select Id,PostalCode, Time_zone__c from Lead where Id=:lead.Id];
        System.assertEquals(insertedLead.Time_zone__c,'EST');
    }
    /**
    * @description Tests a Single Record Update.
    */
    public static testmethod void testgetTimeZoneUpdate() {     
        Lead lead = TestLeadTrigger.insertSingleLeadAndSetup();
        insert lead;
        Lead insertedLead = [Select Id, PostalCode, Time_zone__c from Lead where Id=:lead.Id];
        insertedLead.PostalCode='95002';

        //-------------Start Testing
        Test.startTest();
        TriggerFirstRunHelper.firstRunTimeZone = true;
        update insertedLead;
        Test.stopTest();
        //-------------Stop Testing
        //Assert results
        Lead updatedLead = [Select Id, PostalCode, Time_zone__c from Lead where Id=:lead.Id];
        System.assertEquals(updatedLead.Time_zone__c,'PST');
    }

    /**
    * @description Tests Bulk Insert.
    */
    /*
    public static testmethod void testgetTimeZoneBulkOperation() {
        List<Lead> leads = TestLeadTrigger.insertBulkLeadsAndSetup();
        //Start Testing
        Test.startTest();
        TriggerFirstRunHelper.firstRunTimeZone = true;  
        insert leads;
        Test.stopTest();

        //Assert Results
        for (Lead insertedLead : [Select Id, PostalCode, Time_zone__c from Lead where Id IN :leads]){
            System.assertEquals(insertedLead.Time_zone__c,'EST');   
        }
    }
    */

    /**
    * @description Tests Assignment to overnight Queue on Insert Operation.
    */
    public static testmethod void testassignLeadsToOvernightQueueForInsert(){
        Lead lead = TestLeadTrigger.insertSingleLeadAndSetup();
        lead = TestLeadTrigger.setupReassign(lead);

        //-------------Start Testing
        Test.startTest();
        TriggerFirstRunHelper.firstRunTimeZone= true;
        insert lead;
        Test.stopTest();

        //Assert Results
        Lead insertedLead = [Select Id, OwnerId, Reassigned_Lead__c from Lead where Id=:lead.Id];
        Id overnightQueueId = QueueService.overnightQueueId;
        System.assertEquals(insertedLead.OwnerId,overnightQueueId);
        System.assert(insertedLead.Reassigned_Lead__c==false);
    }

    /**
    * @description Tests Assignment to overnight Queue on Insert Operation.
    */
    public static testmethod void testassignLeadsToOvernightQueueForUpdate(){
        Lead lead = TestLeadTrigger.insertSingleLeadAndSetup();
        TriggerFirstRunHelper.firstRunAssignmentInsert = true;  
        insert lead;
        Lead insertedLead = [Select Id, OwnerId, Reassigned_Lead__c from Lead where Id=:lead.Id];
        insertedLead = TestLeadTrigger.setupReassign(insertedLead);

        //-------------Start Testing
        Test.startTest();
        TriggerFirstRunHelper.firstRunTimeZone = true;
        TriggerFirstRunHelper.firstRunAssignmentUpdate = true;
        update insertedLead;
        Test.stopTest();

        //Assert Results
        Lead updatedLead = [Select Id, OwnerId, Reassigned_Lead__c from Lead where Id=:lead.Id];
        Id overnightQueueId = QueueService.overnightQueueId;
        System.assertEquals(updatedLead.OwnerId,overnightQueueId);
        System.assert(updatedLead.Reassigned_Lead__c==false);
    }


}