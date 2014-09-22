public class taskpagectrl {

//parent opportunity
Opportunity opp; 

// pagerefernce task
public Task tsk {get;set;}

//dummay task that is inserted without any detail__c value
public Task nulltsk; 

// contact id for who_id in task
id coid;

// recordtype foro task
id recordtypeid ;

//Run Once
integer runOnce=1;

//constructor - initializing all the variables
    public taskpagectrl(ApexPages.StandardController controller) {
     opp = (Opportunity)controller.getRecord();
     coid = [select ContactId from OpportunityContactRole where OpportunityId=:opp.id].ContactId;
     recordtypeid = [select Id from recordtype where Name='Standard Task' and sobjecttype='Task'].Id;
     tsk = prepareTask(tsk); 
     nulltsk= prepareTask(nulltsk); 
      
    }
 
 public task prepareTask(task temptsk){
         
         temptsk= new Task(Status='In Progress',Priority='Normal');
         temptsk.attempt__c=null;
         temptsk.ownerId=userinfo.getuserId();
         temptsk.whatid=opp.id; 
         temptsk.whoid=coid;
         temptsk.subject='Manual Follow Up';
         temptsk.recordtypeid=recordtypeid; 
         return temptsk;
    }
 
    public pageReference update1(){   
        if(RunOnce==1){
            // inerting the dummy task.
            insert nulltsk;  
            
            // preparing the taskk values selected by user 
            map<string,string> taskval = new map<string,string>();
            taskval.put('Disposition',tsk.Disposition__c);
            taskval.put('detail',tsk.detail__c);
            taskval.put('Call_Back_Time',tsk.Call_Back_Time__c);
            
            // calling a future method for consistent record update.
            makefollowupcall.taskupdate(nulltsk.id,taskval);
            
           // pageReference o = new pageReference('/'+opp.id);
           runOnce++;
            
        }
        return null;
    
    }
    

}