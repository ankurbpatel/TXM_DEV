/*
 Author: Hema
 Date: 01/30/2014
 Description: This class is for for megring new leads with other matching leading already existing in the system.
*/
 
public with sharing class LeadMergeUtility{ 
  
    public static void mergeLeads( Map<id,id> perfectMatchId,Map<id,Lead>leadPerMatchMap, Map<lead,List<lead>> ambiguousMatch){
       
     /*  if(perfectMatchId.size()>0){
           for (Id newLead:perfectMatchId.keySet()){
                Id matchedLeadId = perfectMatchId.get(newLead);
                try{
                    lead[] matchingLead=[select id from lead where id=:matchedLeadId];
                    if(matchingLead.size()>0){
                         Lead matchingLead0 = matchingLead[0]; 
                         merge matchingLead0 newLead;  
                    }
                   
                }catch(DmlException e) {
                    System.debug('The following exception has occurred: ' + e.getMessage());
                }
           }*/
       
       
        if(perfectMatchId.size()>0){
          for (Id newLeadId:perfectMatchId.keySet()){
         Id matchedLeadId = perfectMatchId.get(newLeadId);
                try{
                    lead[] matchingLeadList=[select id from lead where id=:matchedLeadId];
                    if(matchingLeadList.size()>0){
                         Lead matchingLead = matchingLeadList[0];
                         Lead newLead=leadPerMatchMap.get(newLeadId);
                         datetime myDateTime = datetime.now();
                         string mydtstring = mydatetime.format();
                         Note leadNote=new note(
                             ParentId=matchedLeadId , 
                             Title=newLead.FirstName+' '+newLead.LastName,
                             Body='LEAD NAME : '+newLead.FirstName+' '+newLead.LastName+ ', '+'PHONE : '+newLead.MobilePhone+', '+'BRAND : '+newLead.Brand__c+', '+'PRODUCT:  '+newLead.Product__c+'MERGED DATE :  '+mydtstring 
                         );
                         insert leadNote; 
                         if(newLead.LastName<>NULL) matchingLead.lastname =newLead.LastName;
                         if(newLead.FirstName<>NULL) matchingLead.FirstName =newLead.FirstName;
                         if(newLead.MobilePhone<>NULL) matchingLead.MobilePhone =newLead.MobilePhone;
                         if(newLead.Email<>NULL) matchingLead.Email =newLead.Email;
                         if(newLead.Email<>NULL) matchingLead.PostalCode =newLead.PostalCode ;
                         if(newLead.Vehicle_Year__c<>NULL) matchingLead.Vehicle_Year__c=newLead.Vehicle_Year__c;
                         if(newLead.Vehicle_Make__c<>NULL) matchingLead.Vehicle_Make__c =newLead.Vehicle_Make__c;
                         if(newLead.Vehicle_Model__c<>NULL) matchingLead.Vehicle_Model__c =newLead.Vehicle_Model__c;
                         if(newLead.Vehicle_Mileage__c<>NULL) matchingLead.Vehicle_Mileage__c =newLead.Vehicle_Mileage__c;
                         if(newLead.Estimate__c<>NULL) matchingLead.Estimate__c =newLead.Estimate__c;
                         if(newLead.Car_Title_Satus__c<>NULL) matchingLead.Car_Title_Satus__c =newLead.Car_Title_Satus__c; 
                         merge matchingLead newLeadId; 
                    }
                }
                catch(DmlException e) {
                    System.debug('The following exception has occurred: ' + e.getMessage());
                }
           }
        } 
                         
       
       if(ambiguousMatch.size()>0){
           List<Lead_Lead_Matches_Found__c> matchList=new list<Lead_Lead_Matches_Found__c>();
           List<Ambiguous_Lead_to_Lead__c> newLead= new List<Ambiguous_Lead_to_Lead__c> ();
           map<id,list<lead>>matchMap=new map<id,list<Lead>>();
           list<Lead_Lead_Matches_Found__c> toInsert= new list <Lead_Lead_Matches_Found__c>();
           
           for(lead masterLead:ambiguousMatch.keyset()){
              Ambiguous_Lead_to_Lead__c aLead=new Ambiguous_Lead_to_Lead__c(Name=masterLead.name, Lead__c=masterLead.id);
              newLead.add(aLead);
           }
           if(newLead.size()>0)
              insert newLead;
          
          
           for(lead masterLead:ambiguousMatch.keyset()){
              Ambiguous_Lead_to_Lead__c amb=[select id from Ambiguous_Lead_to_Lead__c where lead__c=:masterLead.id];
              matchMap.put(amb.id,ambiguousMatch.get(masterLead));
           }
          
           for(id ambId:matchMap.keyset()){
               for (lead matchLead:matchMap.get(ambId)){
                  Lead_Lead_Matches_Found__c insertMatch=new Lead_Lead_Matches_Found__c(Name=matchLead.Name, Matched_Lead__c=matchLead.Id, Ambiguous_Lead_to_Lead__c=ambId);
                  toInsert.add(insertMatch);
               }
           }
           if(toInsert.size()>0)
             insert toInsert;
      }
   }
}