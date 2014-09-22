public  class closedTasksController {
Id Id {get;set;}
List<task>TaskList{get;set;}
List<lead>worklist;

    public closedTasksController(ApexPages.StandardController controller) {
     this.Id=ApexPages.currentPage().getParameters().get('id') ;
     worklist =[select id,(Select Subject__c, Due__c, Description,Owner.Name, ActivityType,LastModifiedBy.name, LastModifiedDate, createdDate ,Attempt__c From ActivityHistories ORDER BY CreatedDate DESC ) from Lead where id=:Id];
    
    }
    
    public ActivityHistory[] getTaskList() {
      if(worklist.size()>0){
           List<ActivityHistory> newList=worklist[0].ActivityHistories;
           return newList;
      }
      return null;
    }
}