@isTest
public class TestCalculateCapacityController {
    
    @isTest public static void TestAccountController() {
        Profile profile = TestUtils.getProfile('System Administrator');
        User user = TestUtils.createUser('lastName', 'alias', profile.Id, true);
        Datetime myDate = datetime.newInstance(2008, 12, 1, 12, 30, 2);
        Lead_Assignment_Setting__c las = TestUtils.createLeadAssignmentSetting(user,true,myDate,5,'Brand-Product_1',5,true);
        Lead_Assignment_Setting__c las2=new Lead_Assignment_Setting__c(); 
       
         ApexPages.currentPage().getParameters().put('id',las.id);
         ApexPages.StandardController stdLas = new ApexPages.StandardController(las);
         CalculateCapacityController ccController = new CalculateCapacityController (stdLas);
         
         ApexPages.currentPage().getParameters().put('id',las2.id);
         ApexPages.StandardController stdLas2 = new ApexPages.StandardController(las2);
         CalculateCapacityController ccController2 = new CalculateCapacityController (stdLas2);
         
         Lead lead = TestUtils.createLead('firstname', 'lastName', 'company', 'New', '07601', false);
         lead.OwnerId = user.Id;
         insert lead;
         Account acc = TestUtils.createAccount('Test Acc', '565623',true);
         Opportunity opp = TestUtils.createOpportunity(acc, 'Name', 1000, 'In Process', user.Id,true,'555');
         
         Test.startTest();
             ccController.calculate();
             ccController2.calculate();
             las.CalculateCapacity_for_Assignment__c=true;
             update las;
         Test.stopTest();
    }
}