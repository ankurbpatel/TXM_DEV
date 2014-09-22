public with sharing class UserDeactivatedRecords {

     public static void reassignLeads(List<user>newUsers,Map<id,user> oldUsers){
        set<id>userIdSet=new set<id>();
        Map<id,id>userManagerIdMap=new Map<id,id>();
        

        for(user u:newUsers){ 
            if(u.isActive==false && oldUsers.get(u.id).isActive==true){
                userIdSet.add(u.Id);
               userManagerIdMap.put(u.Id,u.ManagerId);
            }
        }
        if(userIdSet.size()>0){
            reassignAllRecords(UserIdSet,userManagerIdMap);
        }
     }
     
     @future
     public static void reassignAllRecords(set<id>userIdSet,Map<id,id>userManagerIdMap){   
        set<user>userSet=new set<user>();
        List<lead>leadList=new list<lead>();
        List<lead>updateLead=new list<lead>();
        List<Opportunity>oppList=new list<Opportunity>();
        List<Opportunity>updateOpp=new list<Opportunity>();
        List<task>taskList=new list<task>();
        List<task>updateTask=new list<task>();
        Map<opportunity,Id>userOppMap=new Map<opportunity,Id>();
        Id unassignedQueueId= QueueService.unassignedQueueId;

        if(userIdSet.size()>0){
           for(Id Id:userIdSet){
             List<Opportunity>userOppList=new list<Opportunity>();
             User deactUser=[select id,name,ManagerId from User where id=:id limit 1];
             User mgrUser=[select id, email from user where id=:deactUser.ManagerId limit 1];
             leadList=[select id,ownerId from lead where ownerId =:Id and isConverted=:false and Status in('New','In Process')];
             oppList=[select id,ownerId from Opportunity where  ownerId =:Id and stageName in('In Process','Appointment Not Kept')];
             taskList=[select id,ownerId from task where ownerId =:Id and isClosed=:false];  
             
              if(leadList.size()>0){
                 for(lead l:leadList){
                      l.OwnerId=unassignedQueueId;
                      //TFS:55034 - Set flag to indicate lead was reassigned from a deactivated user
                      l.Lead_From_Deactivated_User__c = TRUE;                        
                      updateLead.add(l);
                 } 
              }
              if(oppList.size()>0){
                 for(opportunity o:oppList){
                      userOppList.add(o);
                      userOppMap.put(o,o.OwnerId);
                      o.ownerId=mgrUser.Id; 
                      updateOpp.add(o);
                  }
              }
              if(taskList.size()>0){
                  for(task t:taskList){
                      t.status='Completed';
                      updateTask.add(t);
                  }
              }
              if(userOppList.size()>0) 
              sendEmail(userOppList,deactUser,mgrUser);  
           }
           if(updateLead.size()>0)
              update updateLead;
               
           if(updateOpp.size()>0)
              update updateOpp;
               
           if(updateTask.size()>0)
              update updateTask;
           
         }
     }
    
    public static void sendEmail(List<opportunity> oppListEmail,User deactUser,User mgrUser) {
        // Define the email
        if(deactUser.id!=null){
               String subject;
               String body;
               //addresses =u.Manager.Email;
               string[] toaddress = New String[] {mgrUser.Email};
               Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
               subject='User '+deactUser.Name+'DEACTIVATED';
               body='Hello,  '+deactUser.Name+' has been deactivated in Salesforce.  '+oppListEmail.size()+' Loans(s), previously assigned to this OSR, have been reassigned to you.  Please reassign these records to active OSRs in your team.';
               email.setSubject( subject );
               email.setToAddresses(toaddress);
               email.setPlainTextBody( body );
               //email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

               // Sends the email
               Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
         }
    }
    
    public static void InActiveOwnerLoans(List<opportunity>newLoans, Map<id,opportunity>oldLoans){
         Set<Id>Owner=new set<Id>();
         List<opportunity >oppList=new List<opportunity >();
         Map<id,Opportunity>ownerOppMap=new Map<id,Opportunity>();
         List<string>loanNumbers=new List <string>();
         Set<user> userSet=new Set<user>();
      
         for(opportunity o:newLoans){
           if(o.StageName=='Appointment Not Kept' && oldLoans.get(o.id).StageName=='Appointment Set'){
             Owner.add(o.ownerId);
             oppList.add(o);
           }
         }
         if(owner.size()>0){
             List <user> userList=[select id,Name, isActive,ManagerId from user where id in:owner];
             for(user u:userList){
                 if(u.isActive==false){
                     userSet.add(u);
                 }
             }
             system.debug('Inactive user size is'+userSet.size());
             if(userSet.size()>0){
                 for(user u:userSet){ 
                     if(u.isActive==false && u.ManagerId!=null){
                         User mgrUser=[select id,email from user where id=:u.ManagerId limit 1];
                         for(opportunity o:oppList){
                             if(o.ownerId==u.Id){
                                 loanNumbers.add(o.Loan_Number__c);
                                 o.ownerId=mgrUser.Id;
                                 o.Reason_for_Owner_Change__c='Previously owner by '+u.name+' who has been deactivated. ';
                             }
                         }
                         system.debug('Number of loans changed to Appointment not kept for this user is: '+loanNumbers.size());
                         String subject;
                         String body;
                         string[] toaddress = New String[] {mgrUser.Email};
                         Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                         subject='Appointment Not Kept for loan owned by deactivated user - '+u.Name;
                         body='Hello,  '+u.Name+' has been deactivated in Salesforce. '+loanNumbers.size()+' Loan(s), previously owned by this OSR, has been reassigned to you as the status of the loan has been changed from "Appointment set" to "Appointment not Kept".  Please reassign this/these  loan(s) to an active OSR in your team.';
                         email.setSubject( subject );
                         email.setToAddresses(toaddress);
                         email.setPlainTextBody( body );
                         Messaging.SendEmailResult [] r = 
                         Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
                     }
                 }
             }
         }
     }
}