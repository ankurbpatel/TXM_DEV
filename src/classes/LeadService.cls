/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 12/18/2013
* @description Service Class for Lead Trigger
* @name LeadService.cls
* @type Service Class
* @see LeadTrigger.trigger
*/
public with sharing class LeadService {
     /**
     * @description Method Accepts list of leads and timestamps each one of them based on values set in ZipCode__c object. 
     * @param leads List of leads.
     */
     public static void getTimeZone (Lead[] leads){
        //Initialize Lists for use later in the program.
        Lead[] changedLeads = new Lead[]{};
        LIST<String> zipCodeList = new LIST<String>{};

        //Temporary variable to Store first 3 digits of zip code.
        String zipShort;
        //Temporary variable to Store TimeZone value.
        String foundTimeZone;
        //Temporary variable to Store Existing TimeZone value.
        String existingTimeZone;        
        for(Lead lead :leads){
            if(String.isNotBlank(lead.PostalCode)){ 
                //zipShort=lead.PostalCode.substring(0,3);            
                zipShort=lead.PostalCode;
                zipCodeList.add(zipShort);
                changedLeads.add(lead);             
            }
        }
     
        /**
        * Map to hold Zip Code to TimeZone Mapping.
        */
        Map<String, String> timeZoneMap = new Map<String, String>();
        for (ZIP_code__c zipCode:[Select Time_zone__c,ZIP_code_value__c from ZIP_code__c where ZIP_code_value__c 
                                  IN :zipCodeList]){
            timeZoneMap.put(zipCode.ZIP_code_value__c,zipCode.Time_zone__c);    
        }

        //Iterate through leads, finding and assigning proper timeZone if timeZone is Found
        for(Lead changedlead : changedLeads){
                /**
                * If timeZoneMap contains the zipCode in question, we get the timeZone value and stamp it on lead record.
                */
                //zipShort=changedlead.PostalCode.substring(0,3);
                zipShort=changedlead.PostalCode;
                if(timeZoneMap.containsKey(zipShort)){
                    foundTimeZone=timeZoneMap.get(zipShort);
                    existingTimeZone=changedlead.Time_zone__c;
                    //System.Debug('TimeZone Map found');
                    /**
                    * Make update only if existing TimeZone is not equal to newly found timezone.
                    * This is in case there is an update or there is a newly inserted value.
                    */
                    if(existingTimeZone!=foundTimeZone){
                        changedlead.Time_zone__c=foundTimeZone;
                        //System.debug('Timezone updated');
                    }               
                }
        }
     }

   public static void BusinessHoursforOvernightFlag(Lead[] leads){
        Boolean duringBusinessHours;
        Datetime GMTDate;
        ESTOvernightLeadFlag__c EstSetting;
        CSTOvernightLeadFlag__c CstSetting;
        MSTOvernightLeadFlag__c MstSetting;
        PSTOvernightLeadFlag__c PstSetting;
        Datetime dt = DateTime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0));
        String dayOfWeek=dt.format('EEEE');
        String settingName;
            /**
            * If Called by Test class, instantiate different values
            */
            if(Test.isRunningTest()){
                GMTDate = TestLeadTrigger.getCurrentTime();
            }else{
                GMTDate = System.Datetime.now();
            }
        if(dayOfWeek=='Saturday'||dayOfWeek=='Sunday' ){
            settingName=dayOfWeek;
        }else {
            settingName='Weekdays';
        }
        Integer currentHour = Integer.valueof(GMTDate.format('H', 'CST'));
        Integer currentMinute = Integer.valueof(GMTDate.format('mm', 'CST'));
        Integer endHour;
        Integer startHour;
        Integer minuteDiff;
         
        for(lead l:leads){
            system.debug('Time zone is captured:'+ l.Time_zone__c);
            if(l.Time_zone__c!='' && l.Time_zone__c!=null){
                if(Test.isRunningTest()){
                endHour= 21;
                startHour=9;
                minuteDiff=10;
                }else{
                    if(l.Time_zone__c=='EST'){
                        EstSetting = ESTOvernightLeadFlag__c.getInstance(settingName);
                        endHour = Integer.valueof(EstSetting.EndHour__c);
                        startHour = Integer.valueof(EstSetting.Start_Hour__c);
                        minuteDiff = Integer.valueof(EstSetting.MinuteDifference__c); 
                    }
                    if(l.Time_zone__c=='CST'){
                        CstSetting = CSTOvernightLeadFlag__c.getInstance(settingName); 
                        endHour = Integer.valueof(CstSetting.EndHour__c);
                        startHour = Integer.valueof(CstSetting.Start_Hour__c);
                        minuteDiff = Integer.valueof(CstSetting.MinuteDifference__c); 
                    }
                    if(l.Time_zone__c=='MST'){
                        MstSetting = MSTOvernightLeadFlag__c.getInstance(settingName); 
                        endHour = Integer.valueof(MstSetting.EndHour__c);
                        startHour = Integer.valueof(MstSetting.Start_Hour__c);
                        minuteDiff = Integer.valueof(MstSetting.MinuteDifference__c); 
                    }
                    if(l.Time_zone__c=='PST'){
                        PstSetting = PSTOvernightLeadFlag__c.getInstance(settingName);
                        endHour = Integer.valueof(PstSetting.EndHour__c);
                        startHour = Integer.valueof(PstSetting.Start_Hour__c);
                        minuteDiff = Integer.valueof(PstSetting.MinuteDifference__c);  
                    }
                }
                Integer endTime = 60 - minuteDiff;
                Integer endHourMinusOne = endHour - 1;
                
                system.debug('Current hour is :'+currentHour);
                system.debug('End hour is :'+endHour);
                system.debug('Start hour is :'+startHour);
                system.debug('Setting Name is :'+settingName);
                              
                if(currentHour > endHourMinusOne){
                    l.Overnight_Lead__c=true;
                    system.debug('Entering 1st condition:'+currentHour +' '+endHourMinusOne);
                }else if((currentHour == endHourMinusOne)&&(currentMinute >= endTime)){
                    l.Overnight_Lead__c=true;
                     system.debug('Entering 2nd condition:'+currentHour +' '+endHourMinusOne +' '+endTime);
                }else if(currentHour < startHour){
                    l.Overnight_Lead__c= true;
                    system.debug('Entering 3rd condition:'+currentHour +' '+startHour);
                }
                system.debug('Overnight lead is:'+l.Overnight_Lead__c);
             }
         }  
         
     }

     /**
     * @description Method Accepts list of leads and timestamps each one of them based on values set in ZipCode__c object. 
     * @param leads List of leads.
     */
     public static void getUpdatedLeadsAndStampTimeZone (Lead[] leads,Map<Id, Lead> oldLeads){

        //Initialize Lists for use later in the program.
        Lead[] changedLeads = LeadService.findTimeZoneUpdatedLeads(leads,oldLeads);
        if(changedLeads.size()>0){
            LeadService.getTimeZone(changedLeads);
        }
    } 


    
    /**
     * @description Find convertable leads.
     * @param leads. List of leads.
     * @return List of leads that need to be converted to Account.
     */
    public static Lead[] findTimeZoneUpdatedLeads(Lead[] leads, Map<Id,Lead> oldLeads){
        Lead[] updatableLeads = new Lead[]{};
        for(Lead lead : leads){  
            Lead oldLead = oldLeads.get(lead.Id);
            if(oldLead.PostalCode != lead.PostalCode){
                updatableLeads.add(lead);
            }        
        }
        return updatableLeads;
     }    


     /**
     * @description Method to assign leads to Users based on Business Logic.
     * @param leads List of leads.
     * @param isUpdate Specifies whether this is update Operation.
     */
     public static void assignLeads (Lead[] leads, Boolean isUpdate, Set<Id> perfectMatchedLeads){
    
    /**
    *  Find assignable leads if it is an update operation.
    */
        Lead[] assignableLeads = new Lead[]{};
        if(isUpdate){
            System.debug('Leads are '+leads);
            System.debug('perfect matched Leads are '+perfectMatchedLeads);
            assignableLeads = LeadService.findunmatchedLeads(leads,perfectMatchedLeads);
            System.debug('Assignable leads are '+assignableLeads);
            assignableLeads = LeadService.findAssignableLeadsForUpdate(assignableLeads);
        }else{
            assignableLeads = LeadService.findAssignableLeadsForInsert(leads);
        }

     /**
     *  Step 2:
     *  If it is 10 min from Business close to start of business:
     *  Get overnight Queue from GenericService
     *  Assign the Leads to the Overnight Queue and stop execution
     */
        System.debug('Size of assignableLeads is '+assignableLeads.size()); 
        if(assignableLeads.size()>0){
            //System.debug('Lead Assignment run');
            if(LeadService.withinBusinessHours()){
                //Within Business Hours. Continue Execution.            
                //System.Debug('Within Business hours');
                //AssignLeadsHelper assignHelper = new AssignLeadsHelper();
                newAssignLeadsHelper assignHelper = new newAssignLeadsHelper();
                assignHelper.run(assignableLeads);      
            }else{
                //Not Within Business Hours. Assign to Overnight Queue and Stop.    
                LeadService.assignLeadsToOvernightQueue(assignableLeads);
                //Close Tasks associated with Lead
                //Perform this operation only on update operation
                if(isUpdate == true){
                    LeadService.closeAssociatedTasks(assignableLeads);      
                }
            }
        }//End of if assignableLeads are available.
        
     }

     /**
     * @description Method to do lead conversion. Run on after update.
     * @param leads List of leads.
     * @param isUpdate Specifies whether this is update Operation.
     */
     public static void convertLeads(Lead[] leads, Map<Id,Lead> oldLeads){
            Lead[] convertibleLeads = new Lead[]{};
            convertibleLeads = LeadService.findConvertibleLeads(leads, oldLeads);
            if(convertibleLeads.size()>0){
                //System.debug('Lead Conversion run');
                System.debug('Convertible leads are' + convertibleLeads);
                LeadToAccountMatcher leadMatchResult = new LeadToAccountMatcher(leads);
                leadMatchResult.doMatching();
                leadMatchResult.takeActionAfterMatching();
            }
     }

//---------------------------Insert Utility Functions-----------------

     /**
     * @description This is for insert operation.
     * @param leads List of leads.
     */
     public static Lead[] findLeadsForDedupe(Lead[] leads){
        Lead[] deDupableLeads = new Lead[]{};
        for(Lead lead : leads){
           // if(lead.Derived_Product__c!='-'){
                if((lead.Phone!=''&& lead.Phone!=null )||(lead.Alternate_Phone__c!='' && lead.Alternate_Phone__c!=null)||(lead.MobilePhone!='' && lead.MobilePhone!=null)){
                    deDupableLeads.add(lead);
                }
           // }
        }
        return deDupableLeads;
     }
     //TFS 48896
     public static void stateLevelRestrictedLeads(Lead[] leads){
         Lead[] stateLevelLeads= new Lead[]{};
         List<ZIP_code__c>zipList=[select id, ZIP_code_value__c, Restricted_Zip__c from ZIP_code__c where  Restricted_Zip__c=:true];
         Set<string>zipcode=new Set<string>();
       
         if(zipList.size()>0){
               for(ZIP_code__c z:zipList){
                  if(z.ZIP_code_value__c!=null){
                       zipcode.add(z.ZIP_code_value__c);
                  }
               }
           }
         system.debug('Number of zips restricted are '+zipcode.size());
        
         for(lead l:leads){
             system.debug('Postal code for this lead is  :'+l.PostalCode);
             if(l.PostalCode!=null && zipcode.contains(l.PostalCode)){
                 stateLevelLeads.add(l);
             }
         }
         if(stateLevelLeads.size()>0){ 
               try {
                   List<Lead_Assignment_Setting__c>las=[select id,SL_Last_Assigned_Time__c, State_Level_Lead_Owner__c, User__c from Lead_Assignment_Setting__c where State_Level_Lead_Owner__c=:true and user__c!=null ORDER by SL_Last_Assigned_Time__c];
                   if(las.size()>0){
                       system.debug('Lead Assignment Setting user is :'+las[0].user__c);
                       for(Lead ld : stateLevelLeads){
                              ld.Restricted_Zip__c=true;
                              ld.Bypass_Assignment__c=true;
                              ld.OwnerId=las[0].user__c;
                              updateSLAssignedTime(las[0]);
                       }
                    }
               } catch(DmlException e){}
         }
         
        
     }
      
      public static void matchStoreForLead(Lead[] leads){
        Map<integer,store__c> leadStoreMap=new map<integer,store__c>();
        Integer[] matchingStores= new Integer[]{};      
        Lead[] leadsWithStore = new Lead[]{};
        List<ZIP_code__c>zipList=new  List<ZIP_code__c>();
        Set<string>zipcode=new set<string> ();
        Set<String> storeWithAgentList=new set<String> ();
        List<lead>leadsAssignedToUser=new list<lead>();
        Set<Id>leadIdsAssignedToUser=new Set<Id>();
        Map<Id,Id> ownerMap = new Map<Id,Id>{};
        List<task>tasks=new list<task>();
        Functionality__c setting=Functionality__c.getInstance('Store Agent');
        Boolean StoreAgent;
          if(Test.isRunningTest()){
                StoreAgent=true;
          }
          else{StoreAgent=setting.enabled__c;} 
        for(Lead lead : leads){
            if(lead.store_id__c!=null && lead.store_id__c!=''){
                leadsWithStore.add(lead);
                matchingStores.add(integer.valueof(lead.store_id__c));
            }
        }
        if(matchingStores.size()>0){ 
           zipList=[select id, ZIP_code_value__c, Restricted_Zip__c from ZIP_code__c where  Store_Agent_Assignment__c=:true];
            if(zipList.size()>0){
               for(ZIP_code__c z:zipList){
                   if(z.ZIP_code_value__c!=null){
                       zipcode.add(z.ZIP_code_value__c);
                  }
               }
           }
           Store__c[] stores = [select id, Email_Address__c,user__c,user__r.isActive, Store_Email__c,Name, Store_Code__c,Store_Phone_Number__c,Store_Street__c,Store_City__c,Store_State__c,Store_Zip_Code__c from store__c where Store_Code__c in:matchingStores];
           if(stores.size()>0){
              for(store__c s:stores){
                  leadStoreMap.put(integer.valueof(s.store_Code__c),s);
                  system.debug('User of the store is Active? :'+s.user__r.isActive);
                  if(s.user__c!=null && s.user__r.isActive==true && zipcode.contains(s.Store_Zip_Code__c)){
                      storeWithAgentList.add(string.valueof(s.Store_Code__c));
                  }
              } 
           } 
        }
        if(leadsWithStore.size()>0){ 
       
            for(lead l:leadsWithStore){
               store__c leadStore=leadStoreMap.get(Integer.valueof(l.store_id__c));
               l.Store_Name__c=leadStore.id;
               l.Store_Email__c=leadStore.Email_Address__c;
               l.Address__c=leadStore.Store_Street__c + ' ' + leadStore.Store_City__c + ' ' + leadStore.Store_State__c + ' ' + leadStore.Store_Zip_Code__c;
               l.Store_chosen__c=true;
               if(storeWithAgentList.contains(string.valueof(leadStore.Store_Code__c)) && StoreAgent==true){
                  l.Bypass_Assignment__c=true;
                  l.Store_Agent_Assigned__c=true;
                  l.OwnerId=leadStore.user__c;
                  leadsAssignedToUser.add(l);
                  leadIdsAssignedToUser.add(l.id);
                  system.debug('The owner now is:'+l.OwnerId);
                  ownerMap.put(l.id,l.ownerId);
                  //TwilioCallout.doCalloutFromFuture(leadStore.Store_Phone_Number__c);                    
               }
            }
             
            /* if(leadIdsAssignedToUser.size()>0){
               //LeadService.reassignAssociatedTasks(leadsAssignedToUser, ownerMap);
              system.debug('Size of leads assigned to Store Agent is: '+leadIdsAssignedToUser.size());
              task[] taskList=[select id,OwnerId,whoId from task where whoId in:leadIdsAssignedToUser and isClosed=:false];                
               if(taskList.size()>0){
                   for(task t:taskList){
                       if(leadIdsAssignedToUser.contains(t.whoId)){                   
                           t.OwnerId=ownerMap.get(t.whoId);
                           tasks.add(t);
                           system.debug('Owner for parentLead is:'+ ownerMap.get(t.whoId));
                       }              
                   }
                   if(tasks.size()>0)                
                   update tasks;
               }
             }*/
             /*  if(leadsAssignedToUser.size()>0){
                // LeadService.reassignAssociatedTasks(leadsAssignedToUser, ownerMap);
                task[] taskList=[select id,OwnerId,whoId from task where whoId in:leadIdsAssignedToUser and isClosed=:false];
                for(task t:taskList){
                    t.OwnerId=ownerMap.get(t.whoId);
                }
                if(taskList.size()>0){
                    update taskList;
                }
              }*/
        }
     }

     /**
     * @description Method to match leads with existing leads in the system. Run on after insert.
     * @param leads List of leads.
     * @param isUpdate Specifies whether this is update Operation.
     */
     public static Set<Id> deDupeLeads(Lead[] leads){
        Lead[] deDupableLeads = findLeadsForDedupe(leads);
        Set<Id> returnPerfectMatch = new Set<Id>{};

        if(deDupableLeads.size()>0){   
            LeadToLeadMatcher leadMatchResult = new LeadToLeadMatcher(deDupableLeads);
            leadMatchResult.doMatching();
            //System.debug(leadMatchResult.perfectMatch);
            //System.debug(leadMatchResult.ambiguousMatch); 

            if(leadMatchResult.perfectMatch.size()>0){
                Map<Id,Id> perfectMatch = leadMatchResult.perfectMatch;
                returnPerfectMatch = perfectMatch.keySet();
            }    
            leadMatchResult.takeActionAfterMatching();
        }
        return returnPerfectMatch;
     }

    /**
     * @description Find assignable leads, if it is an insert operation. Manual bypass is also checked at this stage.
     * @param leads. List of leads
     * @return List of leads that have assignable lead flag set.
     */
     public static Lead[] findAssignableLeadsForInsert(Lead[] leads){
        Lead[] assignableLeads = new Lead[]{};
        for(Lead lead : leads){         
            if(lead.Bypass_Assignment__c == false){
                assignableLeads.add(lead);
            }       
        }
        return assignableLeads;
     }


//---------------------------Update Utility Functions-----------------
    /**
    * @description remove matched leads from list of assignable leads.
    */
    public static Lead[] findunmatchedLeads(Lead[] leads, Set<Id> perfectMatchedLeads){
        Lead[] unmatchedLeads = new Lead[]{};
        if(perfectMatchedLeads.size()>0){
            for (Lead lead : leads){
                if(!perfectMatchedLeads.contains(lead.Id)){
                    unmatchedLeads.add(lead);
                }
            }
        }else{
            unmatchedLeads = leads;
        }
        System.debug('Perfect matched leads are '+perfectMatchedLeads);
        System.debug('All assignable leads are'+leads);
        System.debug('Unmatched leads are'+unmatchedLeads);
        return unmatchedLeads;
    }
     /**
     * @description This is for update operation.
     * @param leads List of leads.
     * @param oldLeads. Map of old leads
     */
     public static Lead[] findLeadsForDedupe(Lead[] leads, Map<Id,Lead> oldLeads){
        Lead[] deDupableLeads = new Lead[]{};
        //Id webToLeadQueueId = QueueService.webToLeadQueueId;
        for(Lead lead : leads){
            Lead oldLead = oldLeads.get(lead.Id);
            System.debug('lead owner is'+lead.OwnerId);
           // System.debug('Web to lead queue id is'+webToLeadQueueId);
            System.debug('lead is'+lead);
            System.debug('old lead is'+oldLead);

                if((lead.Derived_Product__c == '-')||((oldLead.Phone!=lead.Phone)||(oldLead.Alternate_Phone__c!=lead.Alternate_Phone__c)||(oldLead.MobilePhone!=lead.MobilePhone))){
                    if((lead.Phone!='')||(lead.Alternate_Phone__c!='')||(lead.MobilePhone!='')){                       
                        Id uiLeadRecordTypeId = RecordTypeModel.getRecordTypeIdByName('UI Lead');
                        User u=[select id, Name from user where name=:'system' limit 1];
                        system.debug('Record type Id is :'+lead.RecordTypeId);
                        system.debug('Created by Id is :'+lead.createdbyID);
                       // if(lead.RecordTypeId!=uiLeadRecordTypeId){
                       if(lead.createdbyId==u.id){
                            System.debug('Not a Ui Lead');
                            deDupableLeads.add(lead);
                            //if((oldLead.Phone!=lead.Phone)||(oldLead.Alternate_Phone__c!=lead.Alternate_Phone__c)||(oldLead.MobilePhone!=lead.MobilePhone)){
                            //    deDupableLeads.add(lead);
                            //}
                        }else{
                            System.debug('Ui Lead');
                        }
                    }
                }
        }
        return deDupableLeads;
     }


     /**
     * @description Method to match leads with existing leads in the system. Run on after insert.
     * @param leads List of leads.
     * @param isUpdate Specifies whether this is update Operation.
     */
  
  
     public static Set<Id> deDupeLeads(Lead[] leads, Map<Id,Lead> oldLeads){
        Lead[] deDupableLeads = findLeadsForDedupe(leads, oldLeads);
        Set<Id> returnPerfectMatch = new Set<Id>{};

        if(deDupableLeads.size()>0){    
                
            LeadToLeadMatcher leadMatchResult = new LeadToLeadMatcher(deDupableLeads);
            leadMatchResult.doMatching();
            //System.debug(leadMatchResult.perfectMatch);
            //System.debug(leadMatchResult.ambiguousMatch);  
            if(leadMatchResult.perfectMatch.size()>0){
                Map<Id,Id> perfectMatch = leadMatchResult.perfectMatch;
                returnPerfectMatch = perfectMatch.keySet();
            }    
            //System.debug(returnPerfectMatch);           
            leadMatchResult.takeActionAfterMatching();
            
        }
        return returnPerfectMatch;
     }

     /**
     * @description Find assignable leads, if it is an update operation. This flag is also unset during this operation.
     * @param leads. List of leads
     * @return List of leads that have assignable lead flag set.
     */
     public static Lead[] findAssignableLeadsForUpdate(Lead[] leads){
        Lead[] assignableLeads = new Lead[]{};
        Lead[] updateLeads = new Lead[]{};
        
        for(Lead lead : leads){
            if(lead.Reassigned_Lead__c == true){
                //First Set this flag as false.
                //lead.Reassigned_Lead__c = false;
                //Reassignment will happen if and only if ByPass flag is set to off.
                //Also leads with Status of Funded:Confirmed and Appointment Set are marked for Conversion. 
                //Skip Assignment for these records
                if((lead.Status!='Funded:Confirmed')&&(lead.Status!='Appointment Set')){
                    if(lead.Bypass_Assignment__c == false){
                        assignableLeads.add(lead);
                      
                    }
                    if(lead.SA_Overnight__c==false && lead.SA_ValidforAssignment__c==true && lead.Bypass_Assignment__c == true){
                        assignableLeads.add(lead);
                    }
                }
            }
        }
        return assignableLeads;
     }




    /**
     * @description Find convertable leads.
     * @param leads. List of leads.
     * @return List of leads that need to be converted to Account.
     */
    public static Lead[] findConvertibleLeads(Lead[] leads, Map<Id,Lead> oldLeads){
        Lead[] convertibleLeads = new Lead[]{};
        for(Lead lead : leads){ 
            String OwnerId; 
            Lead oldLead = oldLeads.get(lead.Id);
            if(oldLead.Status != lead.Status){ 
                if((lead.Status=='Funded:Confirmed')||(lead.Status=='Appointment Set')){
                    OwnerId = lead.OwnerId;
                    //Check if lead owner is a user.
                    //if(OwnerId.startsWith('005')){
                        convertibleLeads.add(lead);
                   // }else{
                    //Lead owner is a queue.    
                   // }
                }
            }   
        
        }
        return convertibleLeads;
     } 

     /**
     * @decription Method returns whether current time is within office time. Office time is 8am-9pm CST.
     */ 
     public static Boolean withinBusinessHours(){
        Boolean duringBusinessHours;
        Datetime GMTDate;
        BusinessHours__c businessHours;
            /**
            * If Called by Test class, instantiate different values
            */
            if(Test.isRunningTest()){
                GMTDate = TestLeadTrigger.getCurrentTime();
            }else{
                GMTDate = System.Datetime.now();
            }
        
        Integer currentHour = Integer.valueof(GMTDate.format('H', 'CST'));
        Integer currentMinute = Integer.valueof(GMTDate.format('mm', 'CST'));

        //Get Business hours from Custom setting. 
        Integer endHour = BusinessHoursSettingModel.endHour;
        Integer startHour =  BusinessHoursSettingModel.startHour;
        Integer minuteDiff =  BusinessHoursSettingModel.minuteDiff;
    
        Integer endTime = 60 - minuteDiff;
        Integer endHourMinusOne = endHour - 1;
        if(currentHour > endHourMinusOne){
            duringBusinessHours=false;
        }else if((currentHour == endHourMinusOne)&&(currentMinute >= endTime)){
            duringBusinessHours=false;
        }else if(currentHour < startHour){
            duringBusinessHours = false;
        }else{
            duringBusinessHours = true;
        }
        system.debug('Is this within business hours : '+duringBusinessHours);
        return duringBusinessHours;
     }

     /**
     * @description Assigns list of leads to the overnight queue. The flag is also reset during this operation.
     * @param assignableLeads List of leads.
     */
     public static void assignLeadsToOvernightQueue(Lead[] assignableLeads){
        Lead[] updatableLeads = new Lead[]{};
        //Id overnightQueueId = QueueService.overnightQueueId;
        Id  overnightQueueId = [select Id,Name from Group where Name = 'Overnight Lead Queue' and Type = 'Queue'].Id;
        for(Lead lead : assignableLeads){ 
            system.debug('This lead is a overnight lead');
            system.debug('Restricted zip code: '+lead.Restricted_Zip__c);
            Lead updatableLead = new Lead(Id=lead.Id, OwnerId = overnightQueueId, Reassigned_Lead__c = false,Overnight_lead__c=true);
            updatableLeads.add(updatableLead);
        }           

        if(updatableLeads.size()>0){
            update updatableLeads;
        }
     }
   

     /**
     * @description Find Tasks associated with leads and close them.
     * @param leadsAssignedToQueue List of leads.(Contains leads that were assigned to a Queue.)
     */
     public static void closeAssociatedTasks(Lead[] leadsAssignedToQueue){
        Set<Id> LeadIds = LeadService.getIdsFromLeads(leadsAssignedToQueue);
        Task[] associatedTasks = TaskService.getTasksAssociatedWithSobject(LeadIds);
        TaskService.closeTasksByChangingStatus(associatedTasks,'ReAssigned');
     }

     /**
     * @description Assigns All tasks associated with lead to new Owner. If task does not exist, it creates a new one.
     * 
     */
     public static void reassignAssociatedTasks(Lead[] updatableLeads, Map<Id,Id> newOwner){
        //Map<Id, Task> associatedTasksMap = TaskService.getOpenTasksMapAssociatedWithLead(updatableLeads);
        //TaskService.reAssignTasks(associatedTasksMap,newOwner);
        Map<Id, Task[]> associatedTasksMap = TaskService.getOpenTasksArrayMapAssociatedWithLead(updatableLeads);
        TaskService.reAssignTasks(associatedTasksMap,newOwner);
     }

      public static void handleOwnerChange(Lead[] leads, Map<Id,Lead> oldLeads){
        Lead[] leadsAssignedToQueue = new Lead[]{};
        Lead[] leadsAssignedToUser = new Lead[]{};
        Map<Id,Id> ownerMap = new Map<Id,Id>{};
        List<lead>leadList=new list<lead>();
        for(Lead lead : leads){ 
            String ownerId; 
            String oldOwnerId;
            Lead oldLead = oldLeads.get(lead.Id);
            if(oldLead.OwnerId != lead.OwnerId && lead.IsConverted==false){
                leadList.add(lead);
            }
        }
        if(leadList.size()>0){
           // Id webToLeadQueueId = QueueService.webToLeadQueueId;
            Id  webToLeadQueueId = [select Id,Name from Group where Name = 'Web to Lead' and Type = 'Queue'].Id;
            for(Lead lead: leadList){ 
                String ownerId; 
                String oldOwnerId;
                Lead oldLead = oldLeads.get(lead.Id);
                if(oldLead.OwnerId != lead.OwnerId && lead.IsConverted==false){
                    ownerId = lead.OwnerId;
                    oldOwnerId = oldLead.OwnerId;
                    System.debug('Owner id is'+ownerId);
                    //Check if lead owner is a Queue.
                    if(ownerId==webToLeadQueueId){
                        System.debug('Lead Assigned to web to lead. Dont do anything');
                    }
                    else if(ownerId.startsWith('00G')){
                        leadsAssignedToQueue.add(lead);
                        System.debug('Lead owner is Queue for lead'+lead.Id+'. Delete tasks');
                    }else{
                        System.debug('Lead owner is User for lead'+lead.Id+'. Create Tasks and Reassign');
                        leadsAssignedToUser.add(lead);
                        ownerMap.put(lead.Id, ownerId);
                    }
                }   
            }
         }

        if(leadsAssignedToQueue.size()>0){
            LeadService.closeAssociatedTasks(leadsAssignedToQueue);
        }

        if(leadsAssignedToUser.size()>0){
            LeadService.reassignAssociatedTasks(leadsAssignedToUser, ownerMap);
        }

     } 

   
     /**
     * Returns Id for all the leads passed.
     */
     public static Set<Id> getIdsFromLeads(Lead[] leads){
        Set<Id> Ids = new Set<Id>();
        for(Lead lead:leads){
            Ids.add(lead.Id);
        }
        return Ids;
     }

    public static Map<Id, String> getLeadStatus(Lead[] leads){
        Map<Id, String> leadStatus = new Map<Id, String> {};
        for(Lead lead : leads){
            leadStatus.put(lead.Id, lead.Status);
        }
        return leadStatus;
     }
     
    public static void taskUpdate(List<lead>newleads, Map<Id,lead>oldleads){
      Set<id> setId=new Set<id>();
      Set<id> setIdForName=new Set<id>();
      Set<id> setIdForClosed = new Set<id>();
      Set<id> setIdForOverNight = new Set<id>();
      Set<id> setIdForPostalCode=new Set<id>();
      Set<id> setIdForStorePhone=new Set<id>();
      Boolean flagForQuery;
      flagForQuery=false;
      for(Lead lead : newleads){ 
            Lead oldLead = oldLeads.get(lead.Id);
            if(oldLead.time_zone__c != lead.time_zone__c){
               setId.add(lead.id);
               flagForQuery=true; 
            }
            if(oldLead.PostalCode!= lead.PostalCode ){
               setIdForPostalCode.add(lead.id);
               flagForQuery=true;  
            }
            if(oldLead.FirstName!=lead.FirstName||oldLead.LastName!=lead.LastName){ // for TFS 47672
               setIdForName.add(lead.id);
               flagForQuery=true; 
            }
            if(oldLead.Status!= lead.Status && lead.Status=='Closed'){
               setIdForClosed.add(lead.id);
               flagForQuery=true;  
            }
            if(oldLead.Overnight_Lead__c!= lead.Overnight_Lead__c && lead.Overnight_Lead__c==true){
               setIdForOverNight.add(lead.id);
               flagForQuery=true;  
            }
            if(oldLead.Store_phone__c!= lead.Store_phone__c){
               setIdForStorePhone.add(lead.id);
               flagForQuery=true;  
            }
       }
       if(flagForQuery==true){
           List<task>task=[select id, whoId, time_zone__c, Lead_Opportunity_Name__c,Status,Overnight_Lead__c from task where (whoId in:setId OR whoId in:setIdForName OR whoId in:setIdForClosed OR whoId in:setIdForOverNight OR whoId in:setIdForPostalCode OR whoId in:setIdForStorePhone) and IsClosed=:false];
           for(lead l:newleads){
               if(task.size()>0){
                   for(task t:task){
                       if(setId.contains(t.whoId)){
                          t.time_zone__c=l.time_zone__c;
                       }
                       if(setIdForPostalCode.contains(t.whoId)){
                           t.Lead_Postal_Code__c=l.PostalCode;
                       }
                       if(setIdForName.contains(t.whoId)){
                            t.Lead_Opportunity_Name__c=l.FirstName+' '+l.LastName;   
                       }
                       if(setIdForClosed.contains(t.whoId)){
                           t.Status='Completed'; 
                       }
                       if(setIdForOverNight.contains(t.whoId)){
                            t.Overnight_Lead__c=true;   
                       }
                       if(setIdForStorePhone.contains(t.whoId)){
                            t.Store_phone__c=l.Store_phone__c;  
                       }
                   }
                   update task;
               }
           }
        }
    }

    
    //TFS:48645- restrict OSR (except with specific permission set) from changing lead owner to queue 
     public static void restrictOwnerChange(Lead[] leads, Map<Id,Lead> oldLeads){
        List <lead> errorLead=new List<lead>();
        for(lead l:leads){
            String Owner;
            String oldOwner;
            lead oldLd=oldLeads.get(l.Id);
            owner=l.OwnerId;
            if(oldLd.OwnerId!=l.OwnerId && owner.startsWith('00G')){
                errorLead.add(l);
            }
        }
        if(errorLead.size()>0){ 
          //  List<user>uList=[select id from user where profile.name!='System Administrator'];
            List<PermissionSetAssignment> psa=[SELECT Id, Assignee.Name,Assignee.Profile.Name, PermissionSet.Name FROM PermissionSetAssignment where PermissionSet.Name='OSR_Team_Lead'];
            Set<string>assigneeId=new Set<string>();
            Set<String>uIdList=new Set<String>();
            String userId=UserInfo.getUserId();
            Boolean inValidUser=false;
            for(PermissionSetAssignment ps:psa){
                assigneeId.add(ps.assigneeId);
            }
            if(!assigneeId.contains(userId)){ 
                User u=[select Profile.Name from user where id=:userId limit 1];
                if(u.Profile.Name!='System Administrator'){   
                    inValidUser=true;
                 }
            }
             
            for(lead l:errorLead){
                String Owner;
                String oldOwner;
                lead oldLd=oldLeads.get(l.Id);
                owner=l.OwnerId;
                if(oldLd.OwnerId!=l.OwnerId && owner.startsWith('00G') && inValidUser==true){
                     l.addError('Insufficient privileges to assign the lead to a Queue');   
                } 
            }
         }
     }
     
   
    // @future
     public static void updateSLAssignedTime(Lead_Assignment_Setting__c las){
          //Lead_Assignment_Setting__c las=[select id,SL_Last_Assigned_Time__c, State_Level_Lead_Owner__c, User__c from Lead_Assignment_Setting__c where id=:lasId limit 1];
          las.SL_Last_Assigned_Time__c=system.now();
          update las; 
     }
     
     public static void leadAssignmentSetting(Lead[] leads, Map<Id,Lead> oldLeads){
    /* List<lead>LeadstoUpdate=new list<lead>();
     Map<id,id>lasMap=new Map<id,id>();
         
         for(Lead lead : leads){ 
            Lead oldLead = oldLeads.get(lead.Id);
            String OwnerId=lead.OwnerId;
            if(oldLead.OwnerId != lead.OwnerId){
               if( OwnerId.startsWith('005')){
                   LeadstoUpdate.add(lead);
                   system.debug('LEAD TO BE UPDATED IS : '+lead.FirstName);
               }
               else{
                  lead.Lead_Assignment_Owner__c=null;
               }
            }
         }
         if(LeadstoUpdate.size()>0){
             List<Lead_Assignment_Setting__c>las=[select id,name, user__c from Lead_Assignment_Setting__c where user__c!=null];
             for(Lead_Assignment_Setting__c ls:las){
                 lasMap.put(ls.user__c,ls.id);
             }
             system.debug('THE MAP CONSISTS : '+lasMap);
             for(lead l:LeadstoUpdate){
                 system.debug('LEAD ASSIGNMENT ID FOR THE OWNER IS : '+lasMap.get(l.OwnerId));
                 l.Lead_Assignment_Owner__c=lasMap.get(l.OwnerId);  
             }
         }*/
     }
     public static void leadAssignmentSetting(Lead[] leads){
    /* List<lead>LeadstoUpdate=new list<lead>();
     Set<id>lasUser=new Set<id>();
     Map<id,id>lasMap=new Map<id,id>();
         for(Lead lead : leads){ 
             if(lead.OwnerId!=null){
                 String OwnerId=lead.OwnerId;
                 system.debug('LEAD OWNER IS :'+lead.OwnerId);
                 if(OwnerId.startsWith('005')){
                    LeadstoUpdate.add(lead);
                    lasUser.add(lead.OwnerId);
                 }
              }
         }
         if(LeadstoUpdate.size()>0){
             List<Lead_Assignment_Setting__c>las=[select id,user__c,name, State_Level_Lead_Owner__c from Lead_Assignment_Setting__c where user__c!=null and user__c in:lasUser];
             if(las.size()>0){
                 for(Lead_Assignment_Setting__c ls:las){
                     lasMap.put(ls.user__c,ls.id);
                 }
                 for(lead l:LeadstoUpdate){
                     l.Lead_Assignment_Owner__c=lasMap.get(l.OwnerId);  
                 }
             }
         }*/
     }

}