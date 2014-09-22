@isTest
public class TestclosedTasksController{
    public static testmethod void My_Method(){
        Lead lead = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand ', 'Product_1', false);
        Lead lead2 = TestUtils.createLeadWithProduct('firstName', 'lastName', 'company', 'New', '07601', 'Brand ', 'Product_2', false);

        TriggerFirstRunHelper.resetAllValues();
        insert lead;
        insert lead2;
        
         ApexPages.StandardController stdLead2 = new ApexPages.StandardController(Lead);
        closedTasksController obj2=new closedTasksController(stdLead2); 
        List<lead>worklist2=[select id,(Select Subject__c, Due__c, Description,Owner.Name, ActivityType,LastModifiedBy.name, LastModifiedDate, createdDate ,Attempt__c From ActivityHistories ORDER BY CreatedDate DESC ) from Lead where id=:lead2.Id];
        obj2.getTaskList();
        
        ApexPages.currentPage().getParameters().put('id',lead.id);
        ApexPages.StandardController stdLead = new ApexPages.StandardController(Lead);
        closedTasksController obj=new closedTasksController(stdLead); 
        List<lead>worklist=[select id,(Select Subject__c, Due__c, Description,Owner.Name, ActivityType,LastModifiedBy.name, LastModifiedDate, createdDate ,Attempt__c From ActivityHistories ORDER BY CreatedDate DESC ) from Lead where id=:lead.Id];
        obj.getTaskList();
        
       
    }
}