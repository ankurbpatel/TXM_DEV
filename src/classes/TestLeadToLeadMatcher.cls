@isTest
public class TestLeadToLeadMatcher{
public static testmethod void My_Method(){
    list<Lead> leadlst=new list<Lead>();
        Lead lead1 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
    
    lead1.LEADSOURCE='TITLEBUCKS.COM';
    lead1.MobilePhone='1234566765';
    lead1.Alternate_Phone__c='1234566765';
    Lead lead2 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
    lead2.LEADSOURCE='LEADSOURCE.COM';
    lead2.MobilePhone='1234566765';
    lead2.Alternate_Phone__c='1234566765';
    lead2.Type_of_Loan__c='TitleBucks';
   // lead2.Brand_Requested__c='TitleBucks';
    
    Lead lead3 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
    lead3.LEADSOURCE='LEADSOURCE.COM';
    lead3.MobilePhone='1234566765';
    lead3.Alternate_Phone__c='1234566765';
    lead3.Type_of_Loan__c='sig';
    //lead3.Brand_Requested__c='Signature Loan';
    //titleMax
    Lead lead11 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
    lead11.LEADSOURCE='LEADSOURCE.COM';
    lead11.MobilePhone='1234566765';
    lead11.Alternate_Phone__c='1234566765';
    lead11.Type_of_Loan__c='Auto Equity';
    //lead11.Brand_Requested__c='titleMax';
    
    Lead lead4 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
    lead4.LEADSOURCE='tITLEmAX.BIZ';
    lead4.MobilePhone='1234566765';
    lead4.Alternate_Phone__c='1234566765';
    lead4.Type_of_Loan__c='First';
    //lead4.Brand_Requested__c='titleMax';
   // lead4.Product_Requested__c='title';
    
    Lead lead5 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
    lead5.LEADSOURCE='tITLEmAX.BIZ';
    lead5.MobilePhone='1234566765';
    lead5.Alternate_Phone__c='1234566765';
    lead5.Type_of_Loan__c='second';
  //  lead5.Product_Requested__c='title';
    
    Lead lead6 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
    lead6.LEADSOURCE='tITLEmAX.BIZ';
    lead6.MobilePhone='1234566765';
    lead6.Alternate_Phone__c='1234566765';
    lead6.Type_of_Loan__c='2nd';
    lead6.Leadsource='TitleLoansSOS.com';
  //  lead6.Product_Requested__c='Signature Loan';
    
    Lead lead10 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
    lead10.LEADSOURCE='tITLEmAX.BIZ';
    lead10.MobilePhone='1234566765';
    lead10.Alternate_Phone__c='1234566765';
    lead10.Type_of_Loan__c='Bad Credit';
    lead10.Leadsource='TitleLoansSOS.com';
    //lead10.Product_Requested__c='Signature Loan';
    
    Lead lead7 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
    lead7.MobilePhone='1234566765';
    lead7.Alternate_Phone__c='1234566765';
    lead7.Type_of_Loan__c='First';
    lead7.Leadsource='TitleBucks';
   // lead7.Product_Requested__c='Title';
    
    Lead lead8 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
    lead8.MobilePhone='1234566765';
    lead8.Alternate_Phone__c='1234566765';
    lead8.Type_of_Loan__c='Personal loan';
    lead8.Leadsource='InstaLoan.com';
   // lead8.Product_Requested__c='2nd Lien Loan';
    
    Lead lead9 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
    lead9.MobilePhone='1234566765';
    lead9.Alternate_Phone__c='1234566765';
    lead9.Type_of_Loan__c='Personal loan';
    lead9.Leadsource='TitleLoansSOS.com';
   // lead9.Product_Requested__c='Bad Credit';
    
        //Test.startTest();
        insert lead1;
    insert lead2;
    insert lead3;
    insert lead4;
    insert lead5;
    insert lead6;
    insert lead7;
    insert lead8;
    insert lead9;
    insert lead10;
    insert lead11;
        leadlst.add(lead1);
        leadlst.add(lead2);
        leadlst.add(lead3);
    leadlst.add(lead4);
    leadlst.add(lead5);
     leadlst.add(lead6);
    leadlst.add(lead7);
    leadlst.add(lead8);
    leadlst.add(lead9);
    leadlst.add(lead10);
    leadlst.add(lead11);
    LeadToLeadMatcher ltlm=new LeadToLeadMatcher(leadlst);
    ltlm.doMatching();
    ltlm.takeActionAfterMatching();
    
}
}