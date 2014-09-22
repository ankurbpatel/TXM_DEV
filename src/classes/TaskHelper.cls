/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 01/18/2014
* @description Helper Class for Task Service. Used when parent of Task is Lead
* @name TaskHelper.cls
* @type Helper Class
* @see TaskService.cls
*/
public with sharing class TaskHelper {
   
/**
* @description List of All Tasks passed to the class.
*/   
private Task[] allTasks {get;set;}  

/**
* @description List of Initial Tasks passed to the class.
*/
private Task[] initialTasks  {get;set;}

/**
* @description List of other Tasks(Not Initial) passed to the class.
*/
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


//private Map<Id,String> parentIdWhoType {get;set;}


//private Map<Id,Id> accountOpportunityMap {get;set;}

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
    public TaskHelper(Task[] tasks) {
        this.allTasks = tasks;      
    }


//------------------------Due Date Functions-----------------------
 /**
 * @description         Seperates Initial tasks from other tasks. At the end of this function Initial tasks and other tasks are filled up with appropriate lists.
 */
    public void separateInitialTasksFromOtherTasks(){
        this.initialTasks = new Task[] {};
        this.otherTasks = new Task[] {};

        String recordTypeName = TaskHelper.taskRecordTypeName;
        Id recordTypeId = RecordTypeModel.getRecordTypeIdByName(recordTypeName);
        for(Task task : this.allTasks){
            if((task.Subject == 'Initial Call Attempt')||(task.Subject == 'Appointment not kept')){
                System.debug('Kiel:Initial Task found');
                this.initialTasks.add(task);
              
            }else if((task.Detail__c !='')&&(task.recordTypeId == recordTypeId)){
                System.debug('Kiel:Other task found');
                this.otherTasks.add(task);
            }else{
                System.debug('Kiel:Else loop hit. There is a problem'+task.due__c);
            }
        }
    }

 /**
 * @description         Stamps initial task Due__c with current Datetime value.
 */
    public void stampInitialTasks(){
        if(this.initialTasks.size()>0){
            for(Task task : initialTasks){
                task.Due__c = Datetime.now();
            }
        }
    }

 /**
 * @description         Stamps Other task Due__c field. Looks at previous task belonging to the current parent to find the value.
 */
    public void stampOtherTasks(){
        if(this.otherTasks.size()>0){
            this.parentIdMap = TaskHelper.findParentWhoIds(this.otherTasks);
            this.parentIdMaxCreatedDateMap = TaskHelper.findParentsMaxTaskDate(this.parentIdMap);
            //System.debug(this.parentIdMap);
            //System.debug(this.parentIdMaxCreatedDateMap);
            this.doCurrentTaskStamping();
        }
    }

    /**
    * @description      Stamps the due date for the task based on previous task values.
    * @see              CallPlanningSetupSettingModel.cls 
    */
    public void doCurrentTaskStamping(){
        //System.debug(this.parentIdMap);
        
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
                Task[] taskTemp = [Select Id,Detail__c,ActivityDate,due__c, Call_Back_Time__c,Due_Date_Time__c from Task where WhoId =:parentId and LastModifiedDate=:maxDateTime LIMIT 1];
                if(taskTemp.size()>0){
                    previousTask = taskTemp[0];
                    currentTask = this.parentIdMap.get(parentId);
                    previousTaskDetail = previousTask.Detail__c;
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
 * @description     Initial Setup to update Contact attempts on Parent Lead and child task object.
 */
public void updateCountsInitialSetup(){
    this.parentIdMap = TaskHelper.findParentWhoIds(this.allTasks);// map of parentId=>task
    this.parentIdCounts = TaskHelper.findCountsOfParentCount(this.parentIdMap.keySet());//map of parentId=>Integer
    //this.parentIdWhoType = TaskHelper.findParentWhoType(this.allTasks);
    //findParentWhoType();

    //System.debug(this.parentIdMap);
    //System.debug(this.parentIdCounts);
    //System.debug(this.parentIdWhoType);
}

 /**
 * @description     Stamps Contact Attemps on parent and child.
 */
 public void updateCounts(){
    //--Start Stamping-------
    Lead[] leadsToUpdate = new Lead[]{};
    Task[] tasksToUpdate = new Task[]{};
    String whoType;
    Integer parentCount;
    Integer parentCountPlusOne;

    if(this.parentIdMap.size()>0){
        for(Id parentId : this.parentIdMap.keySet()){
            parentCount = 0;
            if(this.parentIdCounts.containsKey(parentId)){
                parentCount = this.parentIdCounts.get(parentId);   
            }
            parentCountPlusOne = parentCount + 1;
            
            Lead updateLead = new Lead(Id = parentId, Total_Contact_Attempts__c = parentCount);
            leadsToUpdate.add(updateLead);
            
            if(this.parentIdMap.containsKey(parentId)){
                Task currentTask = this.parentIdMap.get(parentId);
                Task updateTask = new Task(Id = currentTask.Id, Attempt__c = parentCountPlusOne);
                tasksToUpdate.add(updateTask);
            }
        }
        //System.debug(leadsToUpdate);
        //System.debug(tasksToUpdate);   
        if(leadsToUpdate.size()>0){
            update leadsToUpdate;
        }
        if(tasksToUpdate.size()>0){
            update tasksToUpdate;
        }
    }
    
 }


 //-----------------Stage and Status Functions----------------
 /**
 * @description     Initial setup to stamp Status value on parent Lead record.
 */
public void updateStageInitialSetup(){
    //this.parentIdWhoType = TaskHelper.findParentWhoType(this.allTasks);
    //findParentWhoType();
    this.parentIdMap = TaskHelper.findParentWhoIds(this.allTasks);
    this.parentIdTaskDetailDisposition = TaskHelper.findTaskDetailDisposition(this.allTasks);
    //System.debug(this.parentIdWhoType);
    //System.debug(this.parentIdTaskDetailDisposition);
}

 /**
 * @description     Stamps Status value on parent Lead record.
 */
public void updateStageAndStatus(){
    //System.debug('Update Stage and Status hit');
    Opportunity[] opportunitiesToUpdate = new Opportunity[]{};
    Lead[] leadsToUpdate = new Lead[]{};
    String[] detailDisposition = new String[]{};
    String detail;
    String disposition;
    String foundStatus;
    String foundStage;
    String parentType;
    for(Id parentId : this.parentIdMap.keySet()){
        if(this.parentIdTaskDetailDisposition.containsKey(parentId)){
            detailDisposition = this.parentIdTaskDetailDisposition.get(parentId);        
            if(detailDisposition.size()>0){
                detail = detailDisposition[0];
                disposition = detailDisposition[1]; 
            }

            if(detail!=''){
                foundStatus = CallPlanningSetupSettingModel.getStageStatusValues(detail, 'Lead');
                //System.debug('Found status Lead is'+foundStatus);
                if(foundStatus != null){
                    Lead updateLead = new Lead(Id = parentId, Status = foundStatus, Last_Detail__c = detail, Last_Disposition__c = disposition);
                    leadsToUpdate.add(updateLead);
                }
            }
        }
    }
   
    if(leadsToUpdate.size()>0){
        update leadsToUpdate;
   }

}


//---------Utility Functions......
 /**
 * @description         Find number of tasks the parent Lead currently has associated with it.
 * @param whoIds        List of Lead Ids.
 * @return              Map containing Counts of associated tasks. Key is Lead, Value is integer value denoting count.
 */
 public static Map<Id,Integer> findCountsOfParentCount(SET<Id> whoIds){
    Map<Id,Integer> parentIdCounts = new Map<Id,Integer> {};
    for(Id parentIdTemp : whoIds){
        parentIdCounts.put(parentIdTemp, 0);
    }
    Integer count;
    Id parentId; 
    List<String> countsAsContactAttempts = CallPlanningSetupSettingModel.countsAsContactAttempt; 
    String recordTypeName = TaskHelper.taskRecordTypeName;
    Id recordTypeId = RecordTypeModel.getRecordTypeIdByName(recordTypeName);
    //List<task>task=[select id,recordTypeId from task where whoId IN:whoIds]; 
        for(AggregateResult ar:[Select count(Id),whoId from Task where whoId IN:whoIds and recordTypeId=:recordTypeId and Detail__c IN:countsAsContactAttempts group by whoId]){
            count = Integer.valueof(ar.get('expr0'));
            parentId = (Id)ar.get('whoId');
            parentIdCounts.put(parentId, count);
        }
    return parentIdCounts;
 } 

 /**
 * @description         Find parent whoIds for task.
 * @param tasks         List of Tasks.
 * @return              Map containing parent id for each task. Key is Lead Id, Value is task record.
 */
    public static Map<Id,Task> findParentWhoIds(Task[] tasks){
        Map<Id,Task> parentIdMapLocal = new Map<Id,Task>{};
        for(Task otherTask : tasks){
            parentIdMapLocal.put(otherTask.WhoId, otherTask);
        }
        return parentIdMaplocal;
    }

 /**
 * @description         Find Detail and disposition of each task.
 * @param tasks         List of Tasks.
 * @return              Map containing Detail disposition values for each task. Key is Task Id, Value is Array containing Detail Disposition information.
 */
    public static Map<Id,String[]> findTaskDetailDisposition(Task[] tasks){
        Map<Id,String[]> parentIdMapLocal = new Map<Id,String[]>{};
        for(Task task : [Select Id, Detail__c, Disposition__c, whoId from Task where Id IN:tasks]){
            String[] detailDisposition = new String[]{};
            detailDisposition.add(task.Detail__c);
            detailDisposition.add(task.Disposition__c);
            parentIdMapLocal.put(task.whoId, detailDisposition);
        }
        return parentIdMaplocal;
    }

    /**
    * @description          Finds the lead's most recent tasks created Datetime Value.
    * @param parentIdMap    Map containing Lead Ids and created Datetime for the most recent task.
    * @return               Map containing created Datetime values for each task. Key is Task Id, value is created Datetime.
    */
    public static Map<Id,Datetime> findParentsMaxTaskDate(Map<Id,Task> parentIdMap){
        Map<Id,Datetime> tempMap = new Map<Id,Datetime>();
        for(Id tempId : parentIdMap.keySet()){
            tempMap.put(tempId, Datetime.now());
        }
        if(parentIdMap.size()>0){
            Set<Id> parentIds = parentIdMap.keySet();
            
            Id whoId;
            Datetime maxDateTime;
            String recordTypeName = TaskHelper.taskRecordTypeName;
            Id recordTypeId = RecordTypeModel.getRecordTypeIdByName(recordTypeName);
            

            for(AggregateResult ar:[Select Max(LastModifiedDate), WhoId from Task where WhoId IN:parentIds and recordTypeId=:recordTypeId group by WhoId]){
                whoId =  (ID)ar.get('WhoId');
                maxDateTime =  (Datetime)ar.get('expr0');
                tempMap.put(whoId, maxDateTime);
            }            
        }
        return tempMap;
    }
    
}