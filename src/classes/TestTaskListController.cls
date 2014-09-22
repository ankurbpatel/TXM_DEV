@isTest
private class TestTaskListController{
    private static testMethod void testTaskListController(){ 
        TaskListController t2 = new TaskListController();
         date lDate=Date.newInstance(2014, 03, 01);     
       // Lead ld= new lead(LastName='test',Status='New');
       // insert ld;
       // Task tk=new task(Priority='Normal',Status='Not Started', whoId=ld.Id, OwnerId=userinfo.getuserid(),Disposition__c='',Due__c=system.now()-1,Lead_Opportunity_created_Date__c=system.now());
       // insert tk; 
      //  list<task> tList=[select id,Subject__c,Lead_Opportunity_Status__c, Owner.Name,Due__c, Time_zone__c,Overdue__c,Last_Detail__c,Product_Requested__c,Lead_Id__c,status,Lead_Last_Disposition__c,Lead_Source__c, Lead_Loan__c,whatID, whoID, Description,Worklist_Priority__c, LastModifiedBy.name, LastModifiedDate, createdDate ,Attempt__c from task where OwnerId=:userinfo.getuserid() and isClosed=:false  and Disposition__c=:'' and Overdue__c=true and Display_Phone__c=true   and Lead_Opportunity_created_Date__c>=:lDate];
      Test.startTest(); 
        t2.SelectedPage='0';
        t2.total_size=1;
        t2.list_size=5;
        t2.getTasks();    
        t2.getDisableNext();
        t2.getDisablePrevious();
        t2.getTotal_size();
        t2.Next();
        t2.Previous();  
        t2.End();    
        t2.refreshGrid();        
        t2.getPageNumber();
        t2.getTotalPages();
        t2.refreshPage();
        t2.getString();
        t2.setString('test');
        t2.currentPage=1;
       system.assertequals(t2.gettasks(),null);
        Test.stopTest();
     }  
        
       private static testMethod void testTaskListController4(){ 
       Test.startTest();  
         TaskListController t = new TaskListController();
       
        date leadDate=Date.newInstance(2014, 03, 01);     
        Lead ld= new lead(LastName='test',Status='New');
        insert ld;
        Task tk=new task(Priority='Normal',Status='Not Started', whoId=ld.Id, OwnerId=userinfo.getuserid(),Disposition__c='',Due__c=system.now()-1,Lead_Opportunity_created_Date__c=system.now());
        insert tk; 
        list<task> tkList=new list<task>();
        tkList=[select id,Subject__c,Lead_Opportunity_Status__c, Owner.Name, Time_zone__c,Overdue__c,Last_Detail__c,Product_Requested__c,Lead_Id__c,status,Lead_Last_Disposition__c,Lead_Source__c, Lead_Loan__c,whatID, whoID, Description,LastModifiedBy.name, LastModifiedDate, createdDate ,Attempt__c from task where id=:tk.id];
        t.SelectedPage='0';
        t.list_size=1;
        t.total_size=50; 
        t.getTasks();  
        t.getDisableNext();
        t.getDisablePrevious();
        t.getTotal_size();
        t.Next();
        t.Previous();  
        t.End();    
        t.refreshGrid();        
        t.getPageNumber();
        t.getTotalPages();
        t.refreshPage();
        t.getString();
        t.setString('test');
        t.currentPage=1;
              Test.stopTest();

     //  system.assertequals(t.gettasks().size(),1);
    //    system.assertequals(t.gettasks()[0].id,tklist[0].id);
    }
    
     private static testMethod void testTaskListController3(){ 
        TaskListController t3 = new TaskListController();
        Test.startTest();
        date lDate2=Date.newInstance(2014, 03, 01);     
        Lead ld3= new lead(LastName='test',Status='New');
        insert ld3;
        Task tk3=new task(Priority='Normal',Status='Not Started', whoId=ld3.Id, OwnerId=userinfo.getuserid(),Disposition__c='',Due__c=system.now()-1,Lead_Opportunity_created_Date__c=system.now());
        insert tk3; 
        list<task> tkList3=new list<task>();
        tkList3=[select id,Subject__c,Lead_Opportunity_Status__c, Owner.Name, Time_zone__c,Overdue__c,Last_Detail__c,Product_Requested__c,Lead_Id__c,status,Lead_Last_Disposition__c,Lead_Source__c, Lead_Loan__c,whatID, whoID, Description, LastModifiedBy.name, LastModifiedDate, createdDate ,Attempt__c from task where id=:tk3.id];
        t3.SelectedPage='1';
        t3.total_size=1;
        t3.list_size=5;
        t3.getTasks();    
        t3.getDisableNext();
        t3.getDisablePrevious();
        t3.getTotal_size();
        t3.Next();
           t3.Previous();  
        t3.End();    
        t3.refreshGrid();        
        t3.getPageNumber();
        t3.getTotalPages();
        t3.refreshPage();
        t3.getString();
        t3.setString('test');
        t3.currentPage=1;
     //   system.assertequals(t3.gettasks().size(),2);
     //   system.assertequals(t3.gettasks()[0].id,tklist3[0].id);
        Test.stopTest();
    }
    
   
}