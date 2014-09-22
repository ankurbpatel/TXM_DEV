trigger TaskTrigger on Task (before insert, before update, before delete, after update, after insert) {

    if(trigger.isBefore){
     
        if(trigger.isInsert){ 
            if(TriggerFirstRunHelper.firstRunTaskDueDateStamping){  
                    TriggerFirstRunHelper.firstRunTaskDueDateStamping = false;
                    TaskService.stampDueDate(trigger.new); 
                } 
                TaskService.taskUpdateOnInsertAndUpdate(trigger.new);
         }
         if(trigger.isUpdate){
                TaskService.appointmentInBusinessHours(trigger.new);
                TaskService.taskUpdateOnInsertAndUpdate(trigger.new);
         }       
    }
        
//---------------------------------------------------------------------------------------------------------------
    if(trigger.isAfter){
        if(trigger.isInsert){
            if(TriggerFirstRunHelper.firstRunTaskContactAttemptsStamping){
                TriggerFirstRunHelper.firstRunTaskContactAttemptsStamping = false;
                TaskService.stampContactAttempts(trigger.new);
               // TaskService.updateOppStage(trigger.new);
            }
        }

        if(trigger.isUpdate){
            if(TriggerFirstRunHelper.firstRunParentStatusUpdate){
                TriggerFirstRunHelper.firstRunParentStatusUpdate = false;
                TaskService.updateStatusAndStage(trigger.oldMap, trigger.new);
                TaskService.taskUpdateLeadBasedOnAttempt(trigger.new);
                TaskService.updateOppStage(trigger.new);
            }
        }
      //  TaskService.updateOppStage(trigger.new);
    }   

}