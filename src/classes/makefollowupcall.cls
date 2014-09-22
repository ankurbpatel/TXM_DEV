global class makefollowupcall{

  @future 
  public static void taskupdate(Id taskid, map<string,string> taskvalues) {
     task oldtask = [select Disposition__c,detail__c,Call_Back_Time__c from task where id=:taskid limit 1];
     oldtask.Disposition__c=  taskvalues.get('Disposition');
     oldtask.detail__c=  taskvalues.get('detail');
     oldtask.Call_Back_Time__c =  taskvalues.get('Call_Back_Time');
     
     update oldtask;
     
  }
}