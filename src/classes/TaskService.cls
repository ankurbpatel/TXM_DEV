/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 01/18/2014
* @description Service Class for Task Object
* @name TaskService.cls
* @type Service Class
* @see TaskTrigger.trigger
*/
public with sharing class TaskService {
    /**
    * @description      Gets Task Associated with sObject. Can be Lead or Contact
    * @param  Ids       Set of Task Ids
    */
    public static Task[] getTasksAssociatedWithSobject(SET<Id> Ids) {
        Task[] associatedTasks = new Task[]{};
        if(Ids.size()>0){
            associatedTasks = [SELECT Id,Status FROM Task WHERE WhoId IN : Ids];
        }
        //System.debug('Closed tasks are'+associatedTasks);
        return associatedTasks;
    }
   
    
     public static void changeLeadNameForTask(Map<Id,String> leadMap){
          Task[] associatedTasks = new Task[]{};
           Task[] updateTasks = new Task[]{};
           if(leadMap.size()>0){
           try{
            associatedTasks = [SELECT Id,Status,WhoId FROM Task WHERE WhoId IN : leadMap.keySet() and IsClosed=false];
           }
           catch(exception e){}
           if(associatedTasks.size()>0){
               for(Task t:associatedTasks){
                   t.Lead_Opportunity_Name__c=leadMap.get(t.whoId);
                   updateTasks.add(t);
               }
               if(updateTasks.size()>0){
                   update updateTasks;
               }
           }
        }
     }

    /**
    * @description       Close tasks. Run when leads are assigned from User to a Queue.
    * @param tasks       List of tasks to close.
    * @param status      Status value to set on the task record for closing.
    */
    public static void closeTasksByChangingStatus(Task[] tasks, String status){
        if(tasks.size()>0){
            Task[] updateTasks = new Task[]{};
            for(Task task :tasks){
                task.Status = status;
                updateTasks.add(task);
            }
            if(updateTasks.size()>0){
                update updateTasks;
            }
        }
    }
    
     public static void updateTasksforMergedLeads(Lead[] leads) {
      List<task>taskList=new list<task>();
      Set<id>leadSet=new set<id>();
             for(lead l:leads){
                 leadSet.add(l.id);
             }
             List<task> tasks=[select id,status,IsClosed from task where whoId in:leadSet and IsClosed=:false];
             if(tasks.size()>0){
                 for(task t:tasks){
                     t.status='Completed';
                     taskList.add(t);
                 }
             }
             
             if(taskList.size()>0){
                 update taskList;
             }
     }
     
        
       public static void closeOpenTasksForLoan(Opportunity[] Opps, Map<id,Opportunity> oldOpps) {
          Set<id> oppId=new Set<id>();
          for(Opportunity Opp: Opps){  
            Opportunity oldOpp= oldOpps.get(Opp.Id);
          //  if(Opp.stageName!= oldOpp.stageName && Opp.stageName=='Funded:Confirmed'){
            if(oldOpp.IsClosed==false && opp.IsClosed==true){
               oppId.add(opp.id);   
            }        
          }
         
          if(oppId.size()>0){
              List<task> taskToClose=[select id,Status,IsClosed from task where whatId in:oppId and IsClosed=false];
              List<task> updateTasks=new list<task>();
              for(task t:taskToClose){
                if(t.IsClosed==false){
                  t.Status='Completed';
                  t.Opportunity_closed__c=true;
                  updateTasks.add(t);
                }
              }
              if(updateTasks.size()>0){
                  update updateTasks;
              }
          }
      }
      
 
    /**
    * @description      Gets Open Tasks Associated with leads for Reassignment.
    *                   Creates Initial task if needed.
    * @param leads      List of Leads.
    * @return           Map of Leads and Open tasks associated with them. Key contains Lead id, value contains list of tasks.
    */
     public static Map<Id,Task[]> getOpenTasksArrayMapAssociatedWithLead(Lead[] leads) {
        String taskRecordTypeName = TaskHelper.taskRecordTypeName;
        Id recordTypeId = RecordTypeModel.getRecordTypeIdByName(taskRecordTypeName);

        Map<Id,Task[]> associatedTasksMap = new Map<Id,Task[]>{};
        System.debug(leads);
        if(leads.size()>0){
            System.debug('SELECT Id, WhoId, OwnerId FROM Task WHERE WhoId IN('+leads+') AND IsClosed=false');
            for(Task task: [SELECT Id, WhoId, OwnerId FROM Task WHERE WhoId IN : leads AND IsClosed=false AND RecordTypeId=:recordTypeId]){
                if(associatedTasksMap.containskey(task.WhoId)){
                    Task[] currentTasks = associatedTasksMap.get(task.WhoId);
                    currentTasks.add(task);
                    associatedTasksMap.put(task.WhoId, currentTasks);
                }else{
                    Task[] currentTasks = new Task[]{};
                    currentTasks.add(task);
                    associatedTasksMap.put(task.WhoId, currentTasks);
                }             
            }
        }

        //Search for leads that do not have task associated with them.
        Task[] initialTasks = new Task[]{};
       // for(Id leadId : Ids){
        for(Lead lead :leads){
            Id leadId = lead.Id;
            if(!associatedTasksMap.containskey(leadId) && lead.Status!='Closed'){
                System.debug('lead does not contain Initial task. Creating Initial task'+leadId);
                task initialTask = new Task(subject = 'Initial Call Attempt', whoId = leadId, RecordTypeId = recordTypeId);
                System.debug('Creating initial task for lead '+lead.Id);
                initialTasks.add(initialTask);
            }
        }

        if(initialTasks.size()>0){
            insert initialTasks;
            for(Task taskNew: [SELECT Id,WhoId FROM Task WHERE Id IN : initialTasks]){
                 Task[] currentTasks = new Task[]{};
                 currentTasks.add(taskNew);
                 associatedTasksMap.put(taskNew.WhoId, currentTasks);
            }
        }
        System.debug(associatedTasksMap);
        //--------------------
        return associatedTasksMap;
    }


    /**
    * @description       Creates Initial task for list of leads.
    * @param leads       List of Leads.
    */
     public static void createInitialTaskForLead(Lead[] leads) {
        String taskRecordTypeName = TaskHelper.taskRecordTypeName;
        Id recordTypeId = RecordTypeModel.getRecordTypeIdByName(taskRecordTypeName);

        //Search for leads that do not have task associated with them.
        Task[] initialTasks = new Task[]{};
        for(Lead lead : leads){
           if(lead.Status!='Closed'){
                task initialTask = new Task(subject = 'Initial Call Attempt', whoId = lead.Id, RecordTypeId = recordTypeId);
                System.debug('Creating initial task for lead '+lead.Id);
                initialTasks.add(initialTask);
           }
        }
        if(initialTasks.size()>0){
            insert initialTasks;
        }
    }



    /**
    * @description       Gets Open Tasks Associated with Opportunity for closing.
    * @param Ids         List of Opportunity Ids.
    * @return            List of Tasks
    */
     public static Task[] getOpenTasksMapAssociatedWithOpportunity(List<Id> Ids) {
        Task[] associatedTasks = new Task[]{};
        if(Ids.size()>0){
            associatedTasks = [SELECT Id FROM Task WHERE WhatId IN : Ids and IsClosed=:false];
                    }
        //--------------------
        return associatedTasks;
    }

    /**
    * @description       Gets count of tasks associated with Opportunity.
    * @param Ids         List of Opporunity Ids.
    * @return            Map containing Opportunity and number of tasks associated with that opportunity.
    */ 
    public static  Map<Id,Integer> getCountOfTasksAssociatedWithOpportunity(List<Id> Ids) {
        Map<Id, Integer> counts = new Map<Id, Integer>{};
        if(Ids.size()>0){
            for(AggregateResult ar : [SELECT Count(Id),WhatId FROM Task WHERE WhatId IN : Ids group by WhatId]){
                Integer count = Integer.valueOf(ar.get('expr0'));
                Id OppId = (Id)ar.get('WhatId');
                counts.put(OppId, count);
            }
        }
        //--------------------
        return counts;
    }


    /**
    * @description          Reassignment of tasks when leads are assigned from User to User.
    * @param taskMap        Map containing Lead Id and tasks associated with that lead. Key is lead id, value is List of Tasks.
    * @param newOwner       Map containing lead and new owner for each lead. Key is lead, value is new owner.
    */
     public static void reAssignTasks(Map<Id, Task[]> taskMap, Map<Id,Id> newOwner){
        if(taskMap.size()>0){
            Task[] updateTasks = new Task[]{};
            for(Id leadId :taskMap.keySet()){
                Task[] tasks = taskMap.get(leadId);
                for(Task task:tasks){
                    Id ownerId = newOwner.get(leadId);
                    if(ownerId!=null){
                        task.OwnerId = ownerId;
                        updateTasks.add(task);
                    }
                }               
            }
            if(updateTasks.size()>0){
                update updateTasks;
            }
        }   
    }
      

    /**
    * @description          Stamps Due Date for newly inserted tasks. Fires before insert.
    * @param tasks          List of tasks. 
    */
    public static void stampDueDate(Task[] tasks){
        
        Map<String,Task[]> seperateTasks = TaskService.seperateOpportunityAndLead(tasks);
        Task[] leadTasks = seperateTasks.get('Lead');
        Task[] oppTasks = seperateTasks.get('Opportunity');
        
        if (leadTasks.size()>0){
            System.debug('Running Due Date Stamp for Lead tasks');
            TaskHelper taskHelper = new TaskHelper(leadTasks);
            taskHelper.separateInitialTasksFromOtherTasks();
            taskHelper.stampInitialTasks();
            taskHelper.stampOtherTasks();
        }
        if (oppTasks.size()>0){
             System.debug('Running Due Date Stamp for Opportunity tasks');
             TaskHelperOpportunity taskHelper = new TaskHelperOpportunity(oppTasks);
             taskHelper.separateInitialTasksFromOtherTasks();
             taskHelper.stampInitialTasks();
             taskHelper.stampOtherTasks();
        }
    }

    /**
    * @description          Stamps contact attempts on a task and parent record. Fires after insert.
    * @param tasks          List of tasks.
    */
    public static void stampContactAttempts(Task[] tasks){

        Map<String,Task[]> seperateTasks = TaskService.seperateOpportunityAndLead(tasks);
        Task[] leadTasks = seperateTasks.get('Lead');
        Task[] oppTasks = seperateTasks.get('Opportunity');
        
        if (leadTasks.size()>0){
            System.debug('Running stamp Contact Attempts for Lead tasks');
            TaskHelper taskHelper = new TaskHelper(leadTasks);
            taskHelper.updateCountsInitialSetup();
            taskHelper.updateCounts();
        }
        if (oppTasks.size()>0){
            System.debug('Running stamp contact attempts for Opportunity tasks');
            TaskHelperOpportunity taskHelper = new TaskHelperOpportunity(oppTasks);
            taskHelper.updateCountsInitialSetup();
            taskHelper.updateCounts();
        } 
    }

    /**
    * @description          Updates Stage and Status of Parent records. Fires After update of Tasks.
    * @param oldTasksMap    Map of parent and task record before update(Trigger.old values). Key is lead id, value is old Task. 
    * @param newTasks       List of new tasks.
    */
     public static void updateStatusAndStage(Map<Id,Task>oldTasksMap, Task[] newTasks){
        Task[] updatedTasks = TaskService.getTasksWithDetailUpdated(oldTasksMap, newTasks);
        //System.debug(updatedTasks);

        if(updatedTasks.size()>0){
            Map<String,Task[]> seperateTasks = TaskService.seperateOpportunityAndLead(updatedTasks);
            Task[] leadTasks = seperateTasks.get('Lead');
            Task[] oppTasks = seperateTasks.get('Opportunity');
            
            if (leadTasks.size()>0){
                System.debug('Running update status and stage for Lead tasks');
                TaskHelper taskHelper = new TaskHelper(leadTasks);
                taskHelper.updateStageInitialSetup();
                taskHelper.updateStageAndStatus();
            }
            if (oppTasks.size()>0){
                System.debug('Running update status and stage for Opportunity tasks');
                TaskHelperOpportunity taskHelper = new TaskHelperOpportunity(oppTasks);
                taskHelper.updateStageInitialSetup();
                taskHelper.updateStageAndStatus();
            }
        }
    }
  
  /**
    * @description          Updates Stage of opportunity when task becomes contacted/not needed.
    * @param newTasks       List of new tasks.
    */
         public static void updateOppStage(Task[] newTasks){
        
         Opportunity[] opps = new Opportunity[]{};
         set<id> oppClosed=new set<id>();
         set<id> oppids = new set<id>();
         map<Id,String> oppidstagemap = new map<id,string>();
         map<String,String> stagecode = new map<String,string>{'0'=>'In Process', '1' => 'Closed Lost', '2' => 'In Process','3' => 'Appointment Set', '4' => 'Appointment Not Kept','5' => 'Funded', '6' => 'Funded:Confirmed'};
         for(task t:newTasks){  
             if(t.WhatId!=NULL && t.Opportunity_closed__c!=true && t.type!='Email' ){  
                 oppidstagemap.put(t.WhatId,t.OppStageToBe__c); 
             }
             if(t.detail__c=='Not in Service / Disconnected'){
                  oppids.add(t.whatId);   
             }
         }
         if(oppidstagemap.size()>0){
             List<opportunity>oppList=[select id,stagename,Loan_Bad_Phone_Count__c from Opportunity where id IN :oppidstagemap.keySet()];
             if(oppList.size()>0){
                 for(opportunity o:oppList){ 
                     if(oppidstagemap.keySet().contains(o.id) && o.Loan_Bad_Phone_Count__c!=3 ){
                         o.stagename=stagecode.get(oppidstagemap.get(o.id));
                         o.closedate=date.today();
                     }
                     if(oppids.contains(o.id)){
                         if(o.Loan_Bad_Phone_Count__c==null){ 
                             o.Loan_Bad_Phone_Count__c = 1;
                         }
                         else {
                             o.Loan_Bad_Phone_Count__c = o.Loan_Bad_Phone_Count__c + 1;  
                         } 
                         if(o.Loan_Bad_Phone_Count__c == 3){
                                o.StageName='Closed Lost';
                                oppClosed.add(o.id);
                         }
                     }
                     opps.add(o);
                 }
             }
         }
         if(opps.size()>0){ 
            update opps; 
         }
     }



    
    /**
    * @description          Seperates tasks associated with leads from tasks associated with opportunities.
    * @param tasks          List of tasks.
    * @return               Map containing Lead and opportunity tasks seperated. Key values are 'Lead' and Opportunity. Value contains list of tasks.
    */
    public static Map<String,Task[]> seperateOpportunityAndLead(Task[] tasks){
        Task[] leadTasks = new Task[]{};
        Task[] oppTasks = new Task[]{};
        Map<String, Task[]> seperateTasks = new Map<String, Task[]>{};
        for(Task task : tasks){
            //System.debug('Running separate for task'+task);
            if(task.WhatId == null){
                leadTasks.add(task);
            }else{
                oppTasks.add(task);
            }
        }

        seperateTasks.put('Lead', leadTasks);
        seperateTasks.put('Opportunity', oppTasks);
        return seperateTasks;
    }


    /**
    * @description              Find the Tasks with updated Detail__c field.
    * @param oldTasksMap        Map of parent and task record before update(Trigger.old values). Key is lead id, value is old Task. 
    * @param newTasks           List of tasks.
    * @return                   List of tasks    
    */
    public static Task[] getTasksWithDetailUpdated(Map<Id,Task>oldTasksMap, Task[] newTasks){
        Task[] updatedTasks = new Task[]{};
        Task oldTask;
            for(Task newTask : newTasks){
                if(newTask.Detail__c != ''){
                    oldTask = oldTasksMap.get(newTask.Id);
                    if(oldTask.Detail__c != newTask.Detail__c){
                        updatedTasks.add(newTask);
                    }
                }
            }
        return updatedTasks;
    }

    /**
    * @description Checks for modification of closed records.
    * @param oldTasks   List of tasks before update(Trigger.old values).
    */
    public static void checkIfCompletedTasksAreModified(Task[] oldTasks){
        Id recordTypeId = RecordTypeModel.getRecordTypeIdByName('Standard Task');
        for(task t:oldTasks){
             if(t.status=='Completed' && t.RecordTypeId==recordTypeId){
                 t.addError('Records marked as completed cannot be deleted or updated');
             }
        }
    } 

    /**
    * @description        Hema's Function.
    * @param newTasks     List of tasks.
    */
    public static void taskUpdateOnInsertAndUpdate(Task[] newTasks){
     set<id> whoIds = new set<id>();
     set<id> whatIds=new set<id>();
     String sObjectId;
     for(task t:newTasks) {
         if(t.whoId!=null)
             whoIds.add(t.whoId);
         if(t.whatId!=null)
             whatIds.add(t.whatId);         
     }
     map<id,lead> leads= new map<id, lead>([select id,ownerId,name,Overnight_Lead__c,Store_Phone__c,Restricted_Zip__c,Store_chosen__c,status,PostalCode,Owner.Name,Last_Detail__c,Lead_Id_custom__c,Time_zone__c,LeadSource,createdDate,Product__c,Last_Disposition__c, Owner_Viewed__c, Owner_Viewed_Time__c from lead where id in :whoIds]);
     if(leads.size()>0){
        for(task t:newTasks) {
             if(leads.get(t.whoId)!= null) {
                 t.Lead_Opportunity_name__c = leads.get(t.whoId).Name;
                 t.Lead_Opportunity_Status__c=leads.get(t.whoId).status;
                 t.Lead_Last_Disposition__c=leads.get(t.whoId).Last_Disposition__c;
                 t.Last_Detail__c=leads.get(t.whoId).Last_Detail__c;
                 t.Lead_Opportunity_created_Date__c = leads.get(t.whoId).createdDate;
                 t.Lead_Source__c = leads.get(t.whoId).LeadSource;
                 t.Time_zone__c = leads.get(t.whoId).Time_zone__c;
                 t.Lead_Id__c=leads.get(t.whoId).Lead_Id_custom__c;
                 t.Product_Requested__c = leads.get(t.whoId).Product__c;
                 t.Lead_Postal_Code__c=leads.get(t.whoId).PostalCode;
                 t.Overnight_Lead__c=leads.get(t.whoId).Overnight_Lead__c;
                 t.Restricted_Zip__c=leads.get(t.whoId).Restricted_Zip__c;
                 t.store_chosen__c=leads.get(t.whoId).store_chosen__c;
                 t.Store_Phone__c=leads.get(t.whoId).Store_Phone__c;
                 //to handle order of execution
                 sObjectId=leads.get(t.whoId).OwnerId;
                 if(sObjectId.startsWith('005') && t.OwnerID!=sObjectId){
                     t.OwnerId=leads.get(t.whoId).OwnerId;
                 }                 
                 t.Owner_Viewed__c=leads.get(t.whoId).Owner_Viewed__c; 
                 t.Owner_Viewed_Time__c=leads.get(t.whoId).Owner_Viewed_Time__c;                
            }
         }
     }
     map<id,opportunity> opps= new map<id, opportunity>([select id,OwnerId,Last_Detail__c ,loan_Bad_Phone_Count__c,Store_Phone__c,name,Lead_Id__c,stageName,Restricted_Zip__c,LeadSource,createdDate,Requested_Product__c,Last_Disposition__c from opportunity where id in :whatIds]);
     if(opps.size()>0){
         for(task t:newTasks) {
             if(opps.get(t.whatId)!= null) {
                 t.Lead_Opportunity_name__c = opps.get(t.whatId).Name;
                 t.Lead_Opportunity_Status__c=opps.get(t.whatId).stageName;
                 t.Lead_Last_Disposition__c=opps.get(t.whatId).Last_Disposition__c;
                 t.Last_Detail__c=opps.get(t.whatId).Last_Detail__c;
                 t.Lead_Opportunity_created_Date__c = opps.get(t.whatId).createdDate;
                 t.Lead_Source__c = opps.get(t.whatId).LeadSource;
                 t.Restricted_Zip__c = opps.get(t.whatId).Restricted_Zip__c;
                 t.Lead_Id__c=opps.get(t.whatId).Lead_Id__c;
                 t.Product_Requested__c = opps.get(t.whatId).Requested_Product__c;
                 t.Store_Phone__c=opps.get(t.whatId).Store_Phone__c;
                 if(opps.get(t.whatId).loan_Bad_Phone_Count__c==3){
                     t.Status='Completed';
                 }
                 if(t.OwnerID!=opps.get(t.whatId).OwnerId){
                     t.OwnerId=opps.get(t.whatId).OwnerId;
                 }   
             }
         }
     }
    }
  
    /**
    * @description        close leads/opps at 8th attempt  
    * @description        close leads/opps when 3rd occurrence of Bad Phone - Not in Service / Disconnected - TFS # 45048 - replace taskUpdateLeadOnEighthAttempt with taskUpdateLeadBasedOnAttempt
    * @param newTasks     List of tasks on update only.
    */
    public static void taskUpdateLeadBasedOnAttempt(Task[] newTasks){
       set<Id> leadIds = new set<Id>();
       set<Id> leadIds2 = new set<Id>();
       list<lead> leads = new list<lead>();
       string strBadPhone;
       for(task t:newTasks){
            if(t.Attempt__c==8&&(t.Detail__c!=NULL && t.Detail__c!='')&&(t.Detail__c!='Appointment Set' && t.Detail__c!='Confirmed with Customer'&& t.Detail__c!='Confirmed with Store'))
                leadIds.add(t.WhoId);
            if(t.Detail__c=='Confirmed with Customer'|| t.Detail__c=='Confirmed with Store'|| t.Detail__c=='Not in Service / Disconnected'){
                strBadPhone = t.Detail__c;
                leadIds2.add(t.WhoId);
           }
       }
       if(leadIds2.size()>0 ||leadIds.size()>0){
              List<lead>leadlist=[select Total_Contact_Attempts__c,Lead_Bad_Phone_Count__c from lead where id in:leadIds2 OR (id in:leadIds and (status <> 'Funded:Confirmed' OR status <> 'Funded' OR status <> 'Appointment Set'))];
              for(lead ld:leadlist){
                  if(leadIds2.contains(ld.id)){
                      if(strBadPhone=='Not in Service / Disconnected'){
                            if(ld.Lead_Bad_Phone_Count__c==null ){  
                                ld.Lead_Bad_Phone_Count__c = 1;
                            }                
                             else{
                                ld.Lead_Bad_Phone_Count__c = ld.Lead_Bad_Phone_Count__c + 1;
                            }               
                      }
                      if(ld.Lead_Bad_Phone_Count__c == 3){
                            ld.Status='Closed';
                      }
                      ld.Total_Contact_Attempts__c = 8;
                     // leads.add(ld);
                  } 
                  if(leadIds.contains(ld.id)){
                      ld.Total_Contact_Attempts__c = 8;
                      ld.Status='Closed';
                  }else{}
                  leads.add(ld);
              }
              if(leads.size() > 0)
              update leads;
        }
     } 
       /* if(leadIds2.size()>0){
            for(lead l1:[select Total_Contact_Attempts__c from lead where id in:leadIds2]){
                l1.Total_Contact_Attempts__c = 8;
                leads.add(l1);
            }
        }
        if(leads.size() > 0){
             update leads;
        }
       
        if(leadIds.size()>0){
            for(lead l:[select Total_Contact_Attempts__c from lead where id in:leadIds and (status <> 'Funded:Confirmed' OR status <> 'Funded' OR status <> 'Appointment Set')]){
                l.Total_Contact_Attempts__c = 8;
                l.Status='Closed';
                leads.add(l);
            }
        }
        if(leads.size()>0)   
        update leads; 
    }*/

  
        
    public static void appointmentInBusinessHours (Task[] tasks){
     BusinessHours__c setting;
         for(task task : tasks){  
            if(task.Due_Date_Time__c!=null){
                  String dayOfWeek=task.Due_Date_Time__c.format('EEEE');
                  System.debug('Day : ' + dayOfWeek);
                  if(setting == null) setting = BusinessHours__c.getInstance(dayOfWeek); 
                  System.debug('Setting: ' + setting );
                  Integer endHour = Integer.valueof(setting.EndHour__c);
                  Integer startHour = Integer.valueof(setting.StartHour__c);
                  system.debug('Task Appointment Time is : '+task.Appointment_Time__c);
                  if(task.Appointment_Time__c<startHour || task.Appointment_Time__c>=endHour){
                       task.addError('Please set the appointment time within business hours');   
                  }
            }
            
         }
     }
  
}