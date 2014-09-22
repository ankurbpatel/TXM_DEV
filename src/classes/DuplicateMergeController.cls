global with sharing class DuplicateMergeController {
    public Lead lead {get;set;}
    public Boolean checkSize{get;set;}
    public list<Lead_Lead_Matches_Found__c> leadMatches {get;set;}
    public DuplicateMergeController (ApexPages.StandardController stdController) {
        lead = (Lead)stdController.getRecord();
        checksize=false;
        if(lead.Id==null){
         checksize=true;
        }
    }
      
     public Lead_Lead_Matches_Found__c[] getMatches() {
        leadMatches= [Select Id, Name, Ambiguous_Lead_to_Lead__r.Lead__r.Name,Matched_Lead__c, Is_Merged__c, Merged_By__r.Name, Merged_Date_Time__c from Lead_Lead_Matches_Found__c where Ambiguous_Lead_to_Lead__r.Lead__c=:lead.id];
        return (list<Lead_Lead_Matches_Found__c>)leadMatches;
    }

    @RemoteAction
    global static Boolean doMerge(String[] foundLeadArray,String searchedLeadId) {
        Boolean returnVal;
        System.debug(searchedLeadId);
        System.debug(foundLeadArray);
        Lead[] foundLeads = new Lead[]{};
      
       
        if(foundLeadArray.size()>0){
            foundLeads = [Select Id from Lead where Id IN:foundLeadArray order by CREATEDDATE];
        }
        Lead searchedLead = [Select Id from Lead where Id=:searchedLeadId ];
        System.debug(foundLeads); 
        System.debug(searchedLead);

        //--------------Create Lead_Lead_Matched--------------------
       // System.debug('Select Id, Is_Merged__c from Lead_Lead_Matches_Found__c where Ambiguous_Lead_to_Lead__r.Lead__c='+searchedLeadId+' And Matched_Lead__c IN');
        System.debug(foundLeadArray);
        Lead_Lead_Matches_Found__c[] leadsMerged = [Select Id, Is_Merged__c,Merged_By__c, Merged_Date_Time__c from Lead_Lead_Matches_Found__c where Ambiguous_Lead_to_Lead__r.Lead__c=:searchedLeadId And Matched_Lead__c IN:foundLeadArray];
        Lead_Lead_Matches_Found__c[] updatedLeadsMerged = new Lead_Lead_Matches_Found__c[]{};
        for(Lead_Lead_Matches_Found__c leadMerged:leadsMerged){
                leadMerged.Is_Merged__c = true;
                leadMerged.Merged_By__c = UserInfo.getUserId();
                leadMerged.Merged_Date_Time__c = Datetime.now();
                updatedLeadsMerged.add(leadMerged);
        }
        System.debug(updatedLeadsMerged);
        //--------------------------------------------------
        try {
            //If problem arises for merging of more than 3 leads, please clean this up by iterating over foundleads and merging one by one. 
            merge searchedLead foundLeads;
            update updatedLeadsMerged;
            returnVal = true;
        }catch(DmlException e){
            System.debug(e.getMessage());
            returnVal = false;
        }   
        return returnVal;
     }
    
}