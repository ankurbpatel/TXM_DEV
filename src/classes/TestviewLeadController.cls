@isTest (seeAllData=true)
public class TestviewLeadController{
@isTest static void my_method(){
Lead lead = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand ', 'Product_1', false);
TriggerFirstRunHelper.resetAllValues();
insert lead;
     task t = [select id,Disposition__c,Detail__c from task where whoid =:lead.id];
      t.Disposition__c = 'Contacted';
        t.Detail__c = 'Appointment Set';
    update t;
    lead lead1 = [select id from lead where IsConverted=true limit 1];
    system.debug('lead conversion value: '+lead.IsConverted);
ApexPages.StandardController controller=new ApexPages.StandardController(lead);
viewLeadController obj=new viewLeadController(controller);
obj.oppPage();
ApexPages.StandardController controller1=new ApexPages.StandardController(lead1);
viewLeadController obj1=new viewLeadController(controller1);
obj1.oppPage();
    apexpages.currentpage().getparameters().put('id',lead.id);
PageReference pageRef =new PageReference('/p/lead/ViewConvertedLead/d?id='+lead.id);

//System.assertEquals(pageRef,ApexPages.currentPage());
Test.setCurrentPage(pageRef);

}
}