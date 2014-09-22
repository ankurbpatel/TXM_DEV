/**
* @author Erashad Kurawle.
* @company Bluewolf
* @date 01/17/2014.
* @description Utility class for Conversion of leads and deferring Lead conversion on ambiguos match. Exception Handling is missing. Message passing back to screen on ambiguous match needs to be brain stormed.
* @name LeadConvertHelper.cls
* @type Utility Class
*/
public with sharing class LeadConvertUtility {
    
    /**
    * @description Default value of Status on Lead conversion if a value is not found.
    */
    public static final String convertStatusDefault = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1].MasterLabel ;

    /**
    * @description Static method that converts leads into Person Account.
    * @param perfectMatch Map containing lead to account matches. Key is lead Id. Value is Account Id.
    * @param ambiguousMatch Map containing lead to account matches. Key is lead Id. Value is list of Account Id's
    * @param doNotCreateOpportunity boolean value defining whether Opportunity should be created while conversion.
    */
    public static void convertLeads(Map<Id,Id> perfectMatch, Map<Id,List<Id>> ambiguousMatch, lead[] leads, Boolean doNotCreateOpportunity){

        Map<Id, String> leadStatusMap = LeadService.getLeadStatus(leads);
        Map<Id, Integer> BadCountMap = new Map<Id, Integer>();

        Database.LeadConvert[] leadsToConvert = new database.LeadConvert[]{};
        Lead[] ambiguousLeads = new Lead[]{};
        Map<Id,Id> accountContactMap = new Map<Id,Id>{};
        if(perfectMatch.size()>0){
            for(Contact contact:[Select Id,Account.Id from Contact where Account.Id IN:perfectMatch.values()]){
                accountContactMap.put(contact.Account.Id,contact.Id);
            }
        }
        //System.debug(accountContactMap);
        Id systemOwnerId=[select id from User where LastName=:'system'].Id;
        for(Lead lead : leads){
            BadCountMap.put(lead.Id, Integer.valueof(lead.Lead_Bad_Phone_Count__c));
            Id leadId = lead.Id;
            String OwnerId=lead.OwnerId;
        //  System.debug('lead getting converted'+lead.id);

            if(ambiguousMatch.containsKey(leadId)){
                //if lead has ambiguous match   
                ambiguousLeads.add(lead);
            }else{
                //Else lead has 0 or 1 matches
                
                //Create a new Database.LeadConvert
                Database.LeadConvert lc = new database.LeadConvert();   
                String convertStatus ;
                if(leadStatusMap.containsKey(lead.Id)){
                    convertStatus = leadStatusMap.get(lead.Id);
                }else{
                    convertStatus = LeadConvertUtility.convertStatusDefault;
                }

                System.debug('Converted Status is'+convertStatus);
                
                //Set Lead Id.
                lc.setLeadId(leadId);
                //Set Lead Converted status
                lc.setConvertedStatus(convertStatus);
                //Set do not create opportunity value.
                lc.setDoNotCreateOpportunity(doNotCreateOpportunity);
                //Set account id if match is found.
                if(perfectMatch.containsKey(leadId)){
                    //If Lead has perfect match on account.
                    Id accountId = perfectMatch.get(leadId);
                    Id contactId = accountContactMap.get(accountId);
                    lc.setAccountId(accountId);
                    lc.setContactId(contactId);
                }
                if((!OwnerId.startsWith('005')|| OwnerId==null || OwnerID=='')&& 
                    lead.Status=='Funded:Confirmed'
                 ){
                   lc.setOwnerId(systemOwnerId);
                   }
                leadsToConvert.add(lc); 
            }                   
        }
        if(leadsToConvert.size()>0){
            Map<Id,Id> leadOpportunitySuccess = new Map<Id,Id>{};
            Map<Id,Database.Error[]> leadsFailed = new Map<Id,Database.Error[]>{};
            //System.debug(leadsToConvert);
            Database.LeadConvertResult[] leadConvertResults = Database.convertLead(leadsToConvert);
            //Integer length = Integer.valueOf(leadConvertResults.length);
            

            for (Integer j = 0; j < leadConvertResults.size(); j++) {
                if(leadConvertResults[j].isSuccess()){
                    Id opportunityId = leadConvertResults[j].getOpportunityId();
                    Id leadId = leadConvertResults[j].getLeadId();
                    leadOpportunitySuccess.put(leadId, opportunityId);
                }else{
                    Id leadId = leadConvertResults[j].getLeadId();
                    Database.Error[] errors = leadConvertResults[j].getErrors();
                    leadsFailed.put(leadId,errors);
                }
            }

            
            if(leadOpportunitySuccess.size()>0){

                //----------Change Shoretel lookup--------------
                Shoretel__c[] shoretelRecordsToUpdate = new Shoretel__c[]{};
                Shoretel__c[] shoretelRecords = [Select Id,Lead__c,Opportunity__c from Shoretel__c where Lead__c IN:leadOpportunitySuccess.keySet()];
                for(Shoretel__c shoretelRecord : shoretelRecords){
                    Id shoretelId = shoretelRecord.Id;
                    Id leadId = shoretelRecord.Lead__c;
                    if(leadOpportunitySuccess.containsKey(leadId)){
                        Id opportunityIdTemp = leadOpportunitySuccess.get(leadId);
                        Shoretel__c shoretelRecordNew = new Shoretel__c(Id=shoretelId, Lead__c=leadId, Opportunity__c = opportunityIdTemp);
                        shoretelRecordsToUpdate.add(shoretelRecordNew);
                    }
                }
                if(shoretelRecordsToUpdate.size()>0){
                    update shoretelRecordsToUpdate;
                }
                //----------Close All Open Tasks-----------------------------------
                List<Id> oppIds = new List<Id>{};
                OppIds = leadOpportunitySuccess.values();
                Task[] associatedTasks = TaskService.getOpenTasksMapAssociatedWithOpportunity(oppIds);
                //associatedTasks.remove(0);
                if(associatedTasks.size()>0){
                    TaskService.closeTasksByChangingStatus(associatedTasks, 'Converted');
                }
                //-----------Update Count and Status on Opportunity----------------
                Map<Id, Integer> taskCountsOpportunity = TaskService.getCountOfTasksAssociatedWithOpportunity(oppIds);
                //Map<Id, String> leadStatusMap = LeadService.getLeadStatus(leadOpportunitySuccess.keySet());

                Opportunity[] opportunitiesToUpdate = new Opportunity[]{};
                for(Id leadId : leadOpportunitySuccess.keySet()){
                    Id oppId = leadOpportunitySuccess.get(leadId);
                    //Initialize count to 0.
                    Integer count = 0;
                    if(taskCountsOpportunity.containsKey(oppId)){
                        count = taskCountsOpportunity.get(oppId);
                    }
                    String leadStatus = leadStatusMap.get(leadId);
                    Integer LeadBadCount=BadCountMap.get(leadId);
                    Opportunity opp = new Opportunity(Id=oppId, StageName = leadStatus , Total_Contact_Attempts__c = count, Loan_Bad_Phone_Count__c=LeadBadCount);
                    opportunitiesToUpdate.add(opp);
                }
                if(opportunitiesToUpdate.size()>0){
                    update opportunitiesToUpdate;
                }
                //System.debug('Associated Tasks are '+associatedTasks);
                //System.debug('leadStatusMap is '+leadStatusMap);
                //System.debug('taskCountsOpportunity is '+taskCountsOpportunity);
            }

            //System.debug(leadOpportunitySuccess);
            //System.debug(leadsFailed);
        }
        if(ambiguousLeads.size()>0){
            LeadConvertUtility.setAsideLeadAmbiguousMatches(ambiguousMatch,ambiguousLeads,doNotCreateOpportunity);
        }
    }
    /**
    * @description Sets Aside Ambiguous Leads for manual intervention and correction
    * @param ambiguousMatch Map containing lead to account matches. Key is lead Id. Value is list of Account Id's
    * @param ambiguousLeads List of leads that have ambiguous account matches.
    * @param doNotCreateOpportunity boolean value defining whether Opportunity should be created while conversion.
    */
    public static void setAsideLeadAmbiguousMatches(Map<Id,List<Id>> ambiguousMatch,lead[] ambiguousLeads, Boolean doNotCreateOpportunity){
        
        String exceptionMessage = '';
        /**
        * @description Set of existing ambiguous lead matches
        */
        Set<Id> existingAmbiguousMatches = new Set<Id>();
        for(Ambiguous_Lead__c existingAmbiguousLead : [Select Id,Lead__c from Ambiguous_Lead__c where Lead__c IN :ambiguousLeads AND Converted__c=false]){
            existingAmbiguousMatches.add(existingAmbiguousLead.Lead__c);
        }

        Id leadId;
        Ambiguous_Lead__c[] ambiguousLeadsToAdd = new Ambiguous_Lead__c[]{};

        //for (Lead lead : ambiguousLeads){
        for (Lead lead : [Select Id,Name from Lead where Id IN:ambiguousLeads]){    
            exceptionMessage += lead.Name +' cannot be converted into Account. Multiple Account matches found. It has been set aside for manual conversion';
            leadId = lead.Id;
            // If the lead is already added to Ambiguous lead object, do not add it again.
            if(!existingAmbiguousMatches.contains(leadId)){
                Ambiguous_Lead__c ambiguousLead = new Ambiguous_Lead__c(Lead__c = leadId, Do_Not_Create_Opportunity__c = doNotCreateOpportunity, Name = lead.Name);
                ambiguousLeadsToAdd.add(ambiguousLead); 
            }
        }
        //System.debug(ambiguousLeadsToAdd);
            
        if(ambiguousLeadsToAdd.size()>0){
            insert(ambiguousLeadsToAdd);
            
            Lead_Account_Ambiguous_Match__c[] leadAccountAmbiguousMatches = new Lead_Account_Ambiguous_Match__c[]{};
            Id addedLeadId;
            Id ambiguousLeadsPrimaryId;
            List<Id> accountList = new List<Id> {};
            for(Ambiguous_Lead__c ambiguousLeadAdded : ambiguousLeadsToAdd){
                addedLeadId = ambiguousLeadAdded.Lead__c;
                ambiguousLeadsPrimaryId = ambiguousLeadAdded.Id;
                if(ambiguousMatch.containsKey(addedLeadId)){
                    accountList = ambiguousMatch.get(addedLeadId);
                    for(Id accountId : accountList){
                        Lead_Account_Ambiguous_Match__c leadAccountAmbiguousMatch = new Lead_Account_Ambiguous_Match__c(Ambiguous_Lead__c = ambiguousLeadsPrimaryId, Account__c = accountId);
                        leadAccountAmbiguousMatches.add(leadAccountAmbiguousMatch);
                    }
                }
            }

            if(leadAccountAmbiguousMatches.size()>0){
                insert leadAccountAmbiguousMatches;
            }
        }
    }

}