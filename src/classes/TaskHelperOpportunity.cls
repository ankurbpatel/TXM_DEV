/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 02/12/2014
* @description Helper Class for Task Service. Used when parent of Task is Lead
* @name TaskHelperOpportunity.cls
* @type Helper Class
* @see TaskService.cls
*/
public with sharing class TaskHelperOpportunity {
   
private Task[] allTasks {get;set;}    
private Task[] initialTasks  {get;set;}
private Task[] otherTasks {get;set;}

/**
* @description Record Type of Call Planning Tasks. Only these tasks will be inspected by this class during insert/update operation.
*/
public static final String taskRecordTypeName = 'Standard Task';

//----------
/**
* @description parentIdMap Contains Id of Parent as key, Id of Task as Value.
*/
private Map<Id,Task> parentIdMap {get;set;}

/**
* @description parentIdMap Contains Id of Parent as key and max created date of task as value.
*/
private Map<Id,Datetime> parentIdMaxCreatedDateMap {get;set;}

/**
* @description Id contains Id of Parent and count includes total count of Tasks owned by the parent.
*/
private Map<Id,Integer> parentIdCounts {get;set;}

/**
* @description Id contains Id of Parent and count includes total count of Tasks owned by the parent.
*/
private Map<Id,String[]> parentIdTaskDetailDisposition {get;set;}


/**
* @description Constructor
* @param tasks List of tasks.
*/
    public TaskHelperOpportunity(Task[] tasks) {
        this.allTasks = tasks;      
    }


//------------------------Due Date Functions-----------------------
    /**
    * @description seperates Initial tasks from Other tasks. Needed for due date stamping.
    */
    public void separateInitialTasksFromOtherTasks(){
        this.initialTasks = new Task[] {};
        this.otherTasks = new Task[] {};

        String recordTypeName = TaskHelperOpportunity.taskRecordTypeName;
        Id recordTypeId = RecordTypeModel.getRecordTypeIdByName(recordTypeName);
        for(Task task : this.allTasks){
            if((task.Subject == 'Initial Call Attempt')||(task.Subject == 'Appointment not kept')){
                this.initialTasks.add(task);
            }else if((task.Detail__c != '')&&(task.recordTypeId == recordTypeId)){
                this.otherTasks.add(task);
            }
        }
    }

    /**
    * @description Stamps initial tasks with current due date.
    */
    public void stampInitialTasks(){
        if(this.initialTasks.size()>0){
            for(Task task : initialTasks){
                task.Due__c = Datetime.now();
            }
        }
    }

    /**
    * @description Stamps other tasks. Uses Custom setting 'Call Planning Setup' to determine Due Date.
    */
    public void stampOtherTasks(){
        if(this.otherTasks.size()>0){
            this.parentIdMap = TaskHelperOpportunity.findParentWhoIds(this.otherTasks);
            this.parentIdMaxCreatedDateMap = TaskHelperOpportunity.findParentsMaxTaskDate(this.parentIdMap);
            //System.debug(this.parentIdMap);
            //System.debug(this.parentIdMaxCreatedDateMap);

            this.doCurrentTaskStamping();
        }
    }

    /**
    * @description Stamps the due date for the task based on previous task values.
    */
    public void doCurrentTaskStamping(){
        //System.debug(this.parentIdMap);
        //System.debug(this.parentIdMaxCreatedDateMap);
        
        if(this.parentIdMaxCreatedDateMap.size()>0){
            Datetime maxDateTime;
            Task currentTask;
            Task previousTask;
            String previousTaskDetail;
            Integer addHour;
            Integer addMinute;

            Datetime dueDate;
            for(Id parentId : this.parentIdMaxCreatedDateMap.keySet()){
                maxDateTime = this.parentIdMaxCreatedDateMap.get(parentId);
                Task[] taskTemp = [Select Id,Detail__c,Call_Back_Time__c,Due_Date_Time__c from Task where WhatId =:parentId and CreatedDate =:maxDateTime LIMIT 1];
                if(taskTemp.size()>0){
                    previousTask = taskTemp[0];
                    previousTaskDetail = previousTask.Detail__c;
                    currentTask = this.parentIdMap.get(parentId);
                    //System.debug(previousTaskDetail);
                    //System.debug(currentTask);
                    if(previousTask.Call_Back_Time__c=='Other' && previousTask.Due_Date_Time__c!=null ){
                        dueDate=previousTask.Due_Date_Time__c;   
                    }
                    else{
                        dueDate = CallPlanningSetupSettingModel.getDueDate(previousTaskDetail,previousTask);
                    }
                    currentTask.Due__c = dueDate;
                }
            }
        }
    }
 //----------------------------Count functions------------------------------
    /**
    * @description Stamps due date for task based on previous task values.
    */
    public void updateCountsInitialSetup(){
        this.parentIdMap = TaskHelperOpportunity.findParentWhoIds(this.allTasks);
        this.parentIdCounts = TaskHelperOpportunity.findCountsOfParentCount(this.parentIdMap.keySet());
        //this.parentIdWhoType = TaskHelperOpportunity.findParentWhoType(this.allTasks);
        //findParentWhoType();

        //System.debug(this.parentIdMap);
        //System.debug(this.parentIdCounts);
        //System.debug(this.parentIdWhoType);
    }
    /**
    * @description Updates Contact attempts on Task and Parent Opportunity Record
    */
     public void updateCounts(){
        //--Start Stamping-------
        Opportunity[] opportunitiesToUpdate = new Opportunity[]{};
        Task[] tasksToUpdate = new Task[]{};
        String whoType;
        Integer parentCount = 0;
        Integer parentCountPlusOne = 0;
        Task currentTask;

        if(this.parentIdMap.size()>0){
            for(Id parentId : this.parentIdMap.keySet()){
                //whoType = this.parentIdWhoType.get(parentId);                
                parentCount = this.parentIdCounts.get(parentId);
                parentCountPlusOne = parentCount + 1;
                currentTask = this.parentIdMap.get(parentId);                
                Opportunity updateOpp = new Opportunity(Id = parentId, Total_Contact_Attempts__c = parentCount);
                opportunitiesToUpdate.add(updateOpp);
                Task updateTask = new Task(Id = currentTask.Id, Attempt__c = parentCountPlusOne);
                tasksToUpdate.add(updateTask);                
            }
            //System.debug(tasksToUpdate);
            System.debug(opportunitiesToUpdate);
            if(opportunitiesToUpdate.size()>0){
                update opportunitiesToUpdate;
            } 
            if(tasksToUpdate.size()>0){
                update tasksToUpdate;
            }
        }
        
     }


     //-----------------Stage and Status Functions----------------
    /**
    * @description Initial Setup for Stage and Status stamping on parent record. Creates parentIdMap and parentIdTaskDetailDisposition
    */
    public void updateStageInitialSetup(){
        this.parentIdMap = TaskHelperOpportunity.findParentWhoIds(this.allTasks);
        this.parentIdTaskDetailDisposition = TaskHelperOpportunity.findTaskDetailDisposition(this.allTasks);
        //System.debug(this.parentIdTaskDetailDisposition);
    }
    /**
    * @description Updates stage on opportunity record. Uses parentIdMap and parentIdTaskDetailDisposition
    */
    public void updateStageAndStatus(){
        //System.debug('Update Stage and Status hit');
        Opportunity[] opportunitiesToUpdate = new Opportunity[]{};
        String[] detailDisposition = new String[]{};
        String detail;
        String disposition;
        String foundStatus;
        String foundStage;
        String parentType;
        for(Id parentId : this.parentIdMap.keySet()){
            detailDisposition = this.parentIdTaskDetailDisposition.get(parentId);
            if(detailDisposition.size()>0){
                detail = detailDisposition[0];
                disposition = detailDisposition[1]; 
            }

            if(detail!=''){
                //System.debug('Parent type is Opportunity');
                foundStage = CallPlanningSetupSettingModel.getStageStatusValues(detail, 'Opportunity');
                //System.debug('Found Stage Opportunity is'+foundStage);
                if(foundStage != null){
                    Opportunity updateOpp = new Opportunity(Id = parentId, StageName = foundStage, Last_Detail__c = detail, Last_Disposition__c = disposition);
                    opportunitiesToUpdate.add(updateOpp);
                }  
            }
        }

        if(opportunitiesToUpdate.size()>0){
            update opportunitiesToUpdate;
        }    
    }


    //---------Utility Functions......
     /**
     * @description Find number of tasks associated with an opportunity
     * @param whatIds Set of Opportunity Ids
     * @return Contains a map of opportunity id and count of tasks
     */
     public static Map<Id,Integer> findCountsOfParentCount(SET<Id> whatIds){
        Map<Id,Integer> parentIdCounts = new Map<Id,Integer> {};
        for(Id parentIdTemp : whatIds){
            parentIdCounts.put(parentIdTemp, 0);
        }
        Integer count;
        Id parentId; 
        List<String> countsAsContactAttempts = CallPlanningSetupSettingModel.countsAsContactAttempt; 
        String recordTypeName = TaskHelperOpportunity.taskRecordTypeName;
        Id recordTypeId = RecordTypeModel.getRecordTypeIdByName(recordTypeName);
            for(AggregateResult ar:[Select count(Id), WhatId from Task where WhatId IN:whatIds and recordTypeId=:recordTypeId and Detail__c IN:countsAsContactAttempts group by WhatId]){
                count = Integer.valueof(ar.get('expr0'));
                parentId = (Id)ar.get('WhatId');
                parentIdCounts.put(parentId, count);
            }
        return parentIdCounts;
     } 

     /**
     * @description Given a list of tasks, finds opportunities associated with them.
     * @param tasks Set of Opportunity Ids
     * @return Contains a map of opportunity id and tasks
     */
        public static Map<Id,Task> findParentWhoIds(Task[] tasks){
            Map<Id,Task> parentIdMapLocal = new Map<Id,Task>{};
            String oppId;
            for(Task otherTask : tasks){
                oppId=otherTask.whatId;
                if(oppId.startsWith('006')){
                    parentIdMapLocal.put(otherTask.WhatId, otherTask);
                }
            }
            return parentIdMaplocal;
        }

        public static Map<Id,String[]> findTaskDetailDisposition(Task[] tasks){
            Map<Id,String[]> parentIdMapLocal = new Map<Id,String[]>{};
            for(Task task : [Select Id, Detail__c, Disposition__c, WhatId from Task where Id IN:tasks]){
                String[] detailDisposition = new String[]{};
                detailDisposition.add(task.Detail__c);
                detailDisposition.add(task.Disposition__c);
                parentIdMapLocal.put(task.WhatId, detailDisposition);
            }
            return parentIdMaplocal;
        }

        /**
        * @description Finds the parents most recent tasks created Datetime Value.
        */
        public static Map<Id,Datetime> findParentsMaxTaskDate(Map<Id,Task> parentIdMap){
            Map<Id,Datetime> tempMap = new Map<Id,Datetime>();
            for(Id tempId : parentIdMap.keySet()){
                tempMap.put(tempId, Datetime.now());
            }
            if(parentIdMap.size()>0){
                Set<Id> parentIds = parentIdMap.keySet();
                
                Id whatId;
                Datetime maxDateTime;
                String recordTypeName = TaskHelperOpportunity.taskRecordTypeName;
                Id recordTypeId = RecordTypeModel.getRecordTypeIdByName(recordTypeName);

                for(AggregateResult ar:[Select Max(CreatedDate),WhatId from Task where WhatId IN:parentIds and recordTypeId=:recordTypeId group by WhatId]){
                    whatId =  (ID)ar.get('WhatId');
                    maxDateTime =  (Datetime)ar.get('expr0');
                    tempMap.put(whatId, maxDateTime);
                }            
            }
            return tempMap;
        }
    
}