/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 12/18/2013
* @description Before Trigger on Lead Object
* @name LeadTrigger.trigger
* @type Trigger
* @see LeadService.cls
*/
trigger LeadTrigger on Lead (before insert, before update, after update, after insert, before delete) {

    //Before Triggers.
    if(trigger.isBefore){
        if(trigger.isInsert){
             LeadService.leadAssignmentSetting(trigger.new);
             LeadService.stateLevelRestrictedLeads(trigger.new);
             LeadService.matchStoreForLead(trigger.new);
        }
        if(trigger.isUpdate){
           LeadService.leadAssignmentSetting(trigger.new,trigger.oldMap);
        }
        if(TriggerFirstRunHelper.firstRunTimeZone){
            //Initialize it to false after First Run.
            TriggerFirstRunHelper.firstRunTimeZone = false;
            //Get Time Zone.
            if(trigger.isInsert){
                LeadService.getTimeZone(trigger.new);
                LeadService.BusinessHoursforOvernightFlag(trigger.new);
            }
            if(trigger.isUpdate){
                LeadService.getUpdatedLeadsAndStampTimeZone(trigger.new,trigger.oldMap);
                LeadService.restrictOwnerChange(trigger.new, trigger.oldMap);
            }
            if(Trigger.isDelete){
               TaskService.updateTasksforMergedLeads(trigger.old);
            }   
                    
        }  
        
    }

    //After Triggers.
    if(trigger.isAfter){
            //-----------------------   
            if(Trigger.isInsert){
                

                //Assign Leads on Insert and Update
                /*
                if(TriggerFirstRunHelper.firstRunAssignmentInsert){
                    system.debug('Lead assignment Insert Run');
                    TriggerFirstRunHelper.firstRunAssignmentInsert = false;         
                    LeadService.assignLeads(trigger.new, trigger.isUpdate); 
                }   
                */    

                //Dedupe leads for all inserted leads.
                
                /*
                Set<Id> perfectMatchedLeadsOnInsert = new Set<Id>{};
                
                if(TriggerFirstRunHelper.firstRunDeDupe){
                    System.debug('Dedupe on Insert Run');
                    TriggerFirstRunHelper.firstRunDeDupe = false; 
                    perfectMatchedLeadsOnInsert = LeadService.deDupeLeads(trigger.new);
                }
                */
                
                //System.debug(perfectMatchedLeadsOnInsert);

                System.debug('Initial task creation run');
                TaskService.createInitialTaskForLead(trigger.new);
                TriggerFirstRunHelper.firstRunAssignmentUpdate = true;
            }
            //--------------------------
            if(Trigger.isUpdate){
                System.debug('Handling Owner change for lead'+trigger.new);
                System.debug('Old lead is'+trigger.oldMap);
                LeadService.handleOwnerChange(trigger.new, trigger.oldMap);

                //Dedupe leads for updated phone number records only
                Set<Id> perfectMatchedLeads = new Set<Id>{};
              /*  
              AP - DupeBlocker Scenarios
              if(TriggerFirstRunHelper.firstRunDeDupe){
                    System.debug('Dedupe on Update Run');
                    TriggerFirstRunHelper.firstRunDeDupe = false; 
                    perfectMatchedLeads = LeadService.deDupeLeads(trigger.new, trigger.oldMap);
                }*/


                //Assign Leads on Insert and Update
                if(TriggerFirstRunHelper.firstRunAssignmentUpdate){
                    system.debug('Lead assignment Update Run');
                    TriggerFirstRunHelper.firstRunAssignmentUpdate = false;         
                    LeadService.assignLeads(trigger.new, trigger.isUpdate, perfectMatchedLeads);
                      
                }               
                
                //Check for leads needing converison. Do lead to account matching and do Lead Conversion
                if(TriggerFirstRunHelper.firstRunConvertLeads){
                    TriggerFirstRunHelper.firstRunConvertLeads = false; 
                    LeadService.convertLeads(trigger.new, trigger.oldMap);
                } 
                 LeadService.taskUpdate(trigger.new, trigger.oldMap);  
            
            }
            //------------
    }

}