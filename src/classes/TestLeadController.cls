@isTest
public class TestLeadController {
    @isTest public static void TestLeadController() {
        //Insert Leads
        TestUtils.createSomeZipCodeRecords();
        
        Lead lead = TestUtils.createLeadWithPhone('Name', 'lastName', 'company', 'Open', '07601','1112223333', true);

        LeadController controller = new LeadController(new ApexPages.StandardController(Lead));
        Lead controllerLead = controller.lead;
        controllerLead.Phone = '5559991111';
        controller.doSave();
        controller.updateFirstContact();
        /*
            List<String> fields = new List<String>();
            fields.add('Phone');
            fields.add('Alternate_Phone__c');
            fields.add('MobilePhone');
            fields.add('Display_Phone__c');
            fields.add('First_Contact_Attempt__c');
            fields.add('First_Contact_Made__c');
            addFields(fields);  */
            
        Lead updatedlead =[Select Id,Phone from Lead where Id=:lead.Id];
        System.assertEquals(updatedlead.Phone,'5559991111');

        updatedlead.First_Contact_Made__c = true;
        updatedlead.First_Contact_Attempt__c = Datetime.now();
//        firstContactMade = true;
        update updatedlead;
        System.assertEquals(updatedlead.First_Contact_Made__c, true);
    }
    
}