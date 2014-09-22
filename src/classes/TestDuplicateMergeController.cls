@isTest
public class TestDuplicateMergeController{
public static testmethod void My_Method(){
        TestLeadMergeUtility.setUpUsers();
        //-----------------------------------
        list<Lead> leadlst=new list<Lead>();
        Lead lead1 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
        Test.startTest();
        insert lead1; 
        leadlst.add(lead1);
        list<String> lstids=new list<String>();
        lstids.add(lead1.id);
        
        DuplicateMergeController controller = new DuplicateMergeController(new ApexPages.StandardController(Lead1));
        controller.getMatches();
        
        list<Lead_Lead_Matches_Found__c> leadMatches;
     
      if(!leadlst.isEmpty()){
        string str=lead1.Id;
      DuplicateMergeController.doMerge(lstids,str);
          Ambiguous_Lead_to_Lead__c altl=new Ambiguous_Lead_to_Lead__c();
          altl.Name='test';
          //altl.Id=lead1.Id;
          insert altl;
          Lead_Lead_Matches_Found__c leadMerged=new Lead_Lead_Matches_Found__c();
         leadMerged.Is_Merged__c = false;
         leadMerged.Merged_By__c = UserInfo.getUserId();
         leadMerged.Merged_Date_Time__c = Datetime.now();
         leadMerged.Ambiguous_Lead_to_Lead__c=altl.Id;
         leadMerged.Matched_Lead__c=lead1.Id;
        insert leadMerged;
      //Lead_Lead_Matches_Found__c[] leadsMerged = [Select Id, Is_Merged__c,Merged_By__c, Merged_Date_Time__c from Lead_Lead_Matches_Found__c where Ambiguous_Lead_to_Lead__r.Lead__c=:searchedLeadId And Matched_Lead__c IN:foundLeadArray];
      }
      else
{
 system.debug('List is Empty');
}
 }
    public static testmethod void my_mergemethod(){
        list<Lead> leadlst=new list<Lead>();
        Lead lead1 = TestLeadMergeUtility.createLead(false, '2125553323', 'Brand', 'Product_1',false);
        Test.startTest();
        insert lead1; 
        leadlst.add(lead1);
        list<String> lstids=new list<String>();
        lstids.add(lead1.id);
        
        DuplicateMergeController controller = new DuplicateMergeController(new ApexPages.StandardController(Lead1));
        list<Lead_Lead_Matches_Found__c> leadMatches;
     
      if(!leadlst.isEmpty()){
        string str=lead1.Id;
      DuplicateMergeController.doMerge(lstids,str);
       Lead[] foundLeads = new Lead[]{};
         if(lstids.size()>0){
            foundLeads = [Select Id from Lead where Id IN:lstids order by CREATEDDATE];
        }   
           Lead searchedLead = [Select Id from Lead where Id=:str ];
          Ambiguous_Lead_to_Lead__c altl=new Ambiguous_Lead_to_Lead__c();
          altl.Name='test';
          altl.Lead__c=lead1.Id;
          insert altl;
          
         Lead_Lead_Matches_Found__c leadMerged=new Lead_Lead_Matches_Found__c();
         leadMerged.Is_Merged__c = true;
         leadMerged.Merged_By__c = UserInfo.getUserId();
         leadMerged.Merged_Date_Time__c = Datetime.now();
         leadMerged.Ambiguous_Lead_to_Lead__c=altl.id;
         leadMerged.Matched_Lead__c=foundLeads[0].id;
        insert leadMerged;
        System.debug('*******************************'+leadMerged);
      //Lead_Lead_Matches_Found__c[] leadsMerged = [Select Id, Is_Merged__c,Merged_By__c, Merged_Date_Time__c from Lead_Lead_Matches_Found__c where Ambiguous_Lead_to_Lead__r.Lead__c=:searchedLeadId And Matched_Lead__c IN:foundLeadArray];
      }
      else
{
 system.debug('List is Empty');
}
    }
}