trigger LoanTrigger on Opportunity (after update,before update) {
   
   if(trigger.isBefore){
      UserDeactivatedRecords.InActiveOwnerLoans(trigger.new,trigger.oldMap);
   }
   
   if(trigger.isAfter ){
        TaskService.closeOpenTasksForLoan(trigger.new,trigger.oldMap);
   }
}