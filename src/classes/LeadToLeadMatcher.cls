/**
* @author Erashad Kurawle
* @company Bluewolf
* @modified Dheeraj
* @date 01/25/2014
  @modified by Hema 01/30/2014
* @description Extends Abstract class MatchHelper Class. Performs LeadToLeadMatching.
* @name MatchHelperClass.cls
* @type Abstract Class
* @see LeadService.cls
*/
public class LeadToLeadMatcher extends MatchHelperClass{

    /**
    * @description Temporary list of leads for matching purpose
    */
    Lead[] leadsInQuestion;
    Map<lead,list<lead>> ap2= new Map<lead,list<lead>>();
    Map<id,lead>leadMap=new Map<id,lead>();
    Map<Id,String> winningLeadIds=new Map<Id,String>{};

    /**
    * @description Constructor Method
    */
    public LeadToLeadMatcher(Lead[] leads) {
        this.leads = leads;
    }

    /**
    * @description Overriden Method to do actual matching. 
    */ 
    public override void doMatching(){
        System.debug('Inside do Matching');
        System.debug(this.leads);
        // Step 1)Iterate through leads gathering all phone number
         set<string> phoneSet=new set<string>();
         list<lead> leadList=new list <lead>();
         Map<lead,set<string>> phoneMap= new Map<lead,set<string>>();
         Map<Id,Id> pp= new Map<Id,Id>();
         Map<Id,list<Id>> ap= new Map<Id,list<Id>>();
         this.perfectMatch=new map<id,id>();
         this.ambiguousMatch =new map<id,List<id>>();
         List<id> leadId=new List<id>();
         
       //End of this step you have a set of Phone numbers.
        for(Lead l: this.leads){
            if(l.IsConverted==false) {
                if(l.MobilePhone!='' && l.MobilePhone!=null)
                    phoneSet.add(l.MobilePhone);
                if(l.Phone!='' && l.Phone!=null) 
                    phoneSet.add(l.Phone);
                if(l.Alternate_Phone__c!='' && l.Alternate_Phone__c!=null)     
                    phoneSet.add(l.Alternate_Phone__c);
                phoneMap.put(l,phoneSet);
                leadId.add(l.id);
            }
        }
        system.debug('Phone Map is: '+phoneMap);

        try {
          leadList = [select Id, Name, MobilePhone, Phone, IsConverted, Alternate_Phone__c, Derived_Product__c,OwnerId from lead where (MobilePhone in:phoneSet OR Phone in:phoneSet OR Alternate_Phone__c in:phoneSet)  and CreatedDate=last_n_days:10]; 
          //leadList=[select id from lead];
          system.debug('Size of leadList is '+ leadList.size());
       
        }
        catch(QueryException e){
             Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
             String[] toAddresses = new String[] {'tina.wilburn@titlemax.biz', 'Devona.Holivay@titlemax.biz'};
             //String[] toAddresses = new String[] {'hema.sadasivan@titlemax.biz'};
             mail.setToAddresses(toAddresses);
             //mail.setReplyTo('developer@acme.com');
             mail.setSenderDisplayName(' Apex error message');
             mail.setSubject('LEAD FAILED TO LOCATE/MERGE MATCHING LEAD : ' + UserInfo.getOrganizationName());
             String emailMessage = e.getMessage()+'\n\n '+leadId.size()+' LEAD(s) DID NOT UNDERGO THE MERGE PROCESS DUE TO QUERY EXCEPTION IN LEADTOLEADMATCHER CLASS, PLEASE DO THE MERGE MANUALLY, IF APPLICABLE.  LEAD ID(s)- '+ leadId;
             mail.setPlainTextBody(emailMessage);
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
         } 
         
        System.debug(leadList);
           //  Lead[] leadMatched = [Select Id,Derived_Product__c from lead where Id IN:phoneMap.keySet()];
           //  System.debug(leadMatched);
        if(leadList.size()>0){
           Set<Id> dupedIds = new Set<Id>{};
           for (lead l:phoneMap.keySet()){
                list<Id> matchLead = new list<Id>();
                List<lead> matchLead2=new list<lead>();

                for(Lead l2:leadList){
                    if(l2.IsConverted==false &&                                            
                      ((l2.MobilePhone!=null && l2.MobilePhone!='' && phoneMap.get(l).contains(l2.MobilePhone))||
                       (l2.Phone!=null && l2.Phone!='' && phoneMap.get(l).contains(l2.Phone))||
                       (l2.Alternate_Phone__c!=null && l2.Alternate_Phone__c!='' && phoneMap.get(l).contains(l2.Alternate_Phone__c)))
                      )
                     {
                     
                       
                       /*String brandRequested;
                       //calculate brand requested using leadsource..
                       ////if lead source is empty, then brand requested is 'LoanSource' !!!!
                       //Otherwise remove .com from end
                       if(l.LeadSource==null){
                            brandRequested = 'LoanSource';
                        }else{
                           brandRequested = String.valueOf(l.LeadSource);
                           System.debug( 'LeadSource is :'+l.LeadSource);
                           if(brandRequested.contains('.com')){
                              brandRequested = brandRequested.substring(0,brandRequested.length()-4);
                              system.debug('Inside Brandrequested checking');
                            }
                        }*/


                      /* String requestedProduct; 
                                               
                      //Calculate requestedProduct using type_of_loan...
                      /* If Type_of_Loan__c contains TITLE  OR 
                      Type_of_Loan__c contains Auto Equity  AND  Brand__c contains Title
                      Then – Requested_Product__c = Title*/
                     /*  if(brandRequested == 'TitleBucks'){
                            requestedProduct = 'Title';
                            system.debug('Requested product is :'+requestedProduct );
                       }else if(l.Type_of_Loan__c!=null){
                             if(l.Type_of_Loan__c.contains('Title')||(l.Type_of_Loan__c.contains('Auto Equity')&& brandRequested.contains('Title')))
                             {
                                 requestedProduct='Title';
                                 system.debug(' Title Requested product is :'+requestedProduct );
                             }
                             else if(l.Type_of_Loan__c.contains('Pers'))
                             {
                                 requestedProduct='Personal Loan'; 
                                 system.debug('Pers Requested product is :'+requestedProduct );    
                             }
                             else if(l.Type_of_Loan__c.contains('Sig'))
                             {
                                 requestedProduct='Signature Loan'; 
                                 system.debug('Sign Requested product is :'+requestedProduct );    
                             }
                             
                              /*If Type_of_Loan__c contains FIRST OR
                                Type_of_Loan__c contains 1ST OR
                                If Type_of_Loan__c contains Auto Equity  AND Brand__c contains InstaLoan
                                Then – Requested_Product__c = 1st Lien Loan*/
                             
                           /*  else if (l.Type_of_Loan__c.contains('First')||l.Type_of_Loan__c.contains('1st')||
                                     (l.Type_of_Loan__c.contains('Auto Equity')&&(brandRequested.contains('InstaLoan'))))
                             {
                                 requestedProduct='1st Lien Loan';
                                 system.debug('1st Lien Requested product is :'+requestedProduct );
                             }
                             
                             /*If Type_of_Loan__c contains SECOND OR
                              Type_of_Loan__c contains 2ND,Then – Requested_Product__c = 2nd Lien Loan*/
                              
                           /*  else if(l.Type_of_Loan__c.contains('Second')||l.Type_of_Loan__c.contains('2nd'))
                             {
                                 requestedProduct='2nd Lien Loan';
                                 system.debug('2nd Lien Requested product is :'+requestedProduct );
                             }
                             else if(l.Type_of_Loan__c.contains('Bad Credit'))
                             {
                                 requestedProduct='Bad Credit';
                                 system.debug('Bad credit Requested product is :'+requestedProduct );
                             }
                             else{ system.debug('Requested product not defined');}  
                        }else{
                            system.debug('Type of loan is :'+l.Type_of_Loan__c);
                            requestedProduct = 'Title';
                        }*/

                      

                       String derivedProductTemp;
                       derivedProductTemp = l.Brand__c+'-'+l.Product__c; /*  brandRequested+'-'+requestedProduct*/
                       //This is where you calculate the Derived Product
                  //     System.debug('Brand requested is'+brandRequested);
                     //  System.debug('Product requested is'+requestedProduct);
                       System.debug('Derived Product temp is'+derivedProductTemp);
                        
                       System.debug('Derived Product is '+l.Derived_Product__c);
                       System.debug('Derived Product l2 is '+l2.Derived_Product__c);
                       if(derivedProductTemp == l2.Derived_Product__c){
                        System.debug(l);
                        System.debug(l2);
                           if(l2.Id!=l.Id){
                               System.debug('Dedupe found');
                               matchLead.add(l2.id);
                               matchLead2.add(l2);
                               dupedIds.add(l.Id);
                               String Name=l.FirstName+' '+l.LastName;
                               winningLeadIds.put(l2.Id,Name);
                           }  
                       } 
                                            
                     }
                   }
                   if(matchLead.size() == 1){
                       system.debug('Match lead size is one');
                       pp.put(l.id, matchLead[0]);
                       leadMap.put(l.id,l);
                   }
                   if(matchLead.size() > 1){
                      system.debug('Match lead size is more than one');
                      ap.put(l.id, matchLead);
                      ap2.put(l, matchLead2);    
                   }
              }
              //Close all tasks associated with this new lead....
              if(dupedIds.size()>0){
                  Task[] associatedTasks = TaskService.getTasksAssociatedWithSobject(dupedIds);
                  System.debug(associatedTasks);
                  if(associatedTasks.size()>0){
                    System.debug('Closing tasks');
                    TaskService.closeTasksByChangingStatus(associatedTasks, 'Reassigned');  
                  }                              
              }
                          
              this.perfectMatch = pp;
              this.ambiguousMatch = ap;
          }
    }
    public override void takeActionAfterMatching(){
        if (this.perfectMatch.size()>0 || this.ap2.size()>0)
         LeadMergeUtility.mergeLeads(this.perfectMatch,this.leadMap,this.ap2);
       if (this.perfectMatch.size()>0)
          TaskService.changeLeadNameForTask(winningLeadIds);
    }
}