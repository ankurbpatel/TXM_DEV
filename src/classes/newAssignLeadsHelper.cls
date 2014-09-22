/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 12/23/2013
* @description Helper class to help with assignment of records.
* @name AssignLeadsHelper.cls
* @type Helper Wrapper Class
* @see LeadService.cls
*/
public with sharing class newAssignLeadsHelper {
    
    /**
    * @description Contains a Map of Products.
    * Key contains Name of product.
    * Value is an object of productUserQueue Class.
    */
    private Map<String,productUserQueue> productUserMap;
    /**
    * @description Contains a list of Users.
    * Key contains Id of Users. 
    * Value contains an object of userRecord Class.
    */
    private Map<Id,userRecord> userMap; 
    /**
    * @description Contains a list of Users.
    * Key contains lead assignment record. 
    * Value contains an object of userRecord Class.
    */
    private Map<Lead_Assignment_Setting__c,userRecord> userMapNew;

    /**
    * @description Constructor Method.
    */
    public void assignLeadsHelper() {
    }   
    /**
    * @description Runs the Different functions to perform lead Assignment.
    * @param leads List of Leads that need to be worked on.
    */
    public void run(Lead[] leads) {
        this.getProductList(leads);
        this.getAvailableUsers();
        this.getAvailableUserCapacity();
        //System.debug(this.productUserMap);
        //System.debug(this.userMap);
        this.performAssignment(leads);
        this.changeLeadLastAssigned();
        //System.debug(this.productUserMap);
        //System.debug(this.userMap);
    }
        
    /**
    * @description Runs through the list of leads to find list of products that need to be assigned and fills up productUserMap
    * @param leads List of Leads that need to be worked on.
    */
    public void getProductList(Lead[] leads){
        //System.debug('Get product list run');
        String productName;
        Map<String,productUserQueue> productUserMap = new Map<String,productUserQueue>{};
        for (Lead lead : leads){
            productName = lead.Derived_Product__c;
            if((lead.Derived_Product__c != '-')&&(!productUserMap.containsKey(productName))){
                productUserQueue productQueueRecord = new productUserQueue(productName);
                productUserMap.put(productName, productQueueRecord);
            }
            /*else if(lead.Derived_Product__c == '-'){
                //Brand and Product name does not exist.
                //Assign lead to Lead Exception Queue.
                lead.OwnerId = exceptionQueueId;
                unassignedIds.add(lead.Id);
            }*/
        }
        this.productUserMap=productUserMap;
    }


    /**
    * @description Using the product map found by above function "getProductList", it gets a list of users available for each product.
    * It adds these users to the productUserQueue of each product existing in productUserMap.
    * @see assignLeadsHelper.productUserMap
    */
    public void getAvailableUsers(){

        //Temporary variables
        String productNameList;
        String[] productNameArray = new String[]{};
        productUserQueue currentproductUserQueue;

        Map<Id,userRecord> userMap = new Map<Id,userRecord>{};
        Map<Lead_Assignment_Setting__c,userRecord> userMapNew = new Map<Lead_Assignment_Setting__c,userRecord>{};

        String query = 'select Id,User__c,User__r.IsActive, Product__c,Total_Capacity__c,New_Leads_Owned__c,Loans_Owned__c, Leads_Owned__c,Real_time_Lead_User__c,New_Lead_Capacity__c,Lead_Last_Assigned_Date__c,Availability__c from Lead_Assignment_Setting__c where User__r.IsActive=true and User__c!=null';
        String add_query = '';
        if(this.productUserMap.size()>0){
            add_query+=' AND Product__c includes (';
            for (String productName : this.productUserMap.keyset()){
                add_query+='\''+productName+'\',';
            }   
            add_query = add_query.Substring(0,add_query.length()-1);
            add_query +=') ';
            query+=add_query+' ORDER by Lead_Last_Assigned_Date__c';

            //System.debug(query);
            Lead_Assignment_Setting__c[] userSettings = Database.query(query);
            
            
            
            //Iterate through UserSettings
            for(Lead_Assignment_Setting__c userSetting :userSettings){
                System.debug('Is user Active:' + userSetting.user__r.IsActive);
                productNameList = userSetting.Product__c;
                if(userSetting.Product__c != null){
                    productNameArray=productNameList.split(';');
                    //System.debug(productNameList);
                    boolean userIsAvailable = userSetting.Availability__c;
                    boolean userIsRealTime = userSetting.Real_time_Lead_User__c;
                    for(String productName : productNameArray){
                        //System.debug(productName);
                        if(this.productUserMap.containsKey(productName)){
                            //System.Debug('If Hit');
                            currentproductUserQueue = this.productUserMap.get(productName);
                            //System.debug(this.productUserMap.get(productName));
                            //System.debug(currentproductUserQueue);
                            if(userIsAvailable && userIsRealTime){
                                currentproductUserQueue.addUserIdToLast(userSetting.User__c);
                            }else{
                                currentproductUserQueue.productSupported = true;
                            }                       
                            //System.debug(currentproductUserQueue);
                        }else{
                            //System.Debug('Else Hit');
                        }                   
                    }
                    //Create User Record and add it to Map
                    if(userIsAvailable && userIsRealTime){
                        userRecord userRec = new userRecord(userSetting.Id,userSetting.User__c,Integer.valueOf(userSetting.Total_Capacity__c),Integer.valueof(userSetting.New_Lead_Capacity__c),userSetting.Lead_Last_Assigned_Date__c);
                        userMap.put(userSetting.User__c, userRec);
                        userMapNew.put(userSetting,userRec);
                    }
                }
            }
        }else{
            System.Debug('No Products Available. Something wrong');
        }

        //System.debug('product user map is'+this.productUserMap);
        this.userMap = userMap;
        this.userMapNew = userMapNew;         
    }
    
    /**
    * @description Gets current Used Capacity of each user and calculates remaining capacity for each user.
    */
    public void getAvailableUserCapacity(){
        Map<Id,Integer> NumberOfCurrentOpp = new Map <Id,Integer>{};
        Map<Id,Integer> NumberOfCurrentLeads = new Map <Id,Integer>{};
        Map<Id,Integer> NumberOfCurrentNewLeads = new Map <Id,Integer>{};
        Set<Id> userSet = new Set<Id>{};
        Set<Lead_Assignment_Setting__c> userList = new Set<Lead_Assignment_Setting__c>{};
        userSet = this.userMap.keyset();
        userList= this.userMapNew.keyset();
        
        
        for(Lead_Assignment_Setting__c userLas : userList){
            Integer leadOwn=Integer.Valueof(userLas.Leads_Owned__c);
            Integer loanOwn=Integer.Valueof(userLas.Loans_Owned__c);
            Integer newLeadsOwn=Integer.Valueof(userLas.New_Leads_Owned__c);
            NumberOfCurrentOpp.put(userLas.user__c,leadOwn);
            NumberOfCurrentLeads.put(userLas.user__c,loanOwn);
            NumberOfCurrentNewLeads.put(userLas.user__c,newLeadsOwn);
        }

       /* for(Id userId : userSet){
            NumberOfCurrentOpp.put(userId,0);
            NumberOfCurrentLeads.put(userId,0);
        }

        //Fill up Lead Capacity of Each user.
        Id userIdTemp;
        Integer leadTotalTemp;
        //  for(AggregateResult arLead : [Select Count(Id),OwnerId from Lead Where OwnerId IN:userSet and Status in ('Contacted','Open','New') Group by OwnerId]){
       // for(AggregateResult arLead : [Select Count(Id),OwnerId from Lead Where OwnerId IN:userSet and  isConverted=:false and Status NOT IN('Funded:Confirmed','Appointment Set' ,'Closed') Group by OwnerId]){
                for(AggregateResult arLead : [Select Count(Id),OwnerId from Lead Where OwnerId IN:userSet and  isConverted=:false and LeadStatus__c IN('New','In Process' ,'Funded') and OwnerId!=null and LeadStatus__c!=null Group by OwnerId]){
            userIdTemp =  String.valueOf(arLead.get('OwnerId'));
            LeadTotalTemp = Integer.valueOf(arLead.get('expr0'));
            NumberOfCurrentLeads.put(userIdTemp,LeadTotalTemp);
        }
        
        Id userIdNewTemp;
        Integer leadTotalNewTemp=0;
        for(AggregateResult arNewLead : [Select Count(Id),OwnerId from Lead Where OwnerId IN:userSet and  isConverted=:false and Status=:'New'  Group by OwnerId]){
            userIdNewTemp=  String.valueOf(arNewLead.get('OwnerId'));
            leadTotalNewTemp= Integer.valueOf(arNewLead.get('expr0'));
            system.debug('New Leads Owned by this UserId is '+userIdNewTemp);
            NumberOfCurrentNewLeads.put(userIdNewTemp,leadTotalNewTemp);
        }

        //Fill up Opportunity Capacity of Each user.
        Id userIdTemp2;
        Integer oppTotalTemp;
        //  for(AggregateResult arOpp : [Select Count(Id),OwnerId from Opportunity Where OwnerId IN:userSet and StageName NOT IN ('Closed Won','Closed Lost') Group by OwnerId]){
        for(AggregateResult arOpp : [Select Count(Id),OwnerId from Opportunity Where OwnerId IN:userSet and StageName NOT IN('Funded:Confirmed','Appointment Set' ,'Closed Lost')  Group by OwnerId]){
            userIdTemp2 =  String.valueOf(arOpp.get('OwnerId'));
            oppTotalTemp = Integer.valueOf(arOpp.get('expr0'));
            NumberOfCurrentOpp.put(userIdTemp2,oppTotalTemp);
        }*/

        //Fill up UserRecords with correct values.
        userRecord currentUserRecord;
        for(Id userId : userSet){
            currentUserRecord = this.userMap.get(userId);
            system.debug('User Id is '+userId);
            system.debug('NumberOfCurrentLeads are: '+NumberOfCurrentLeads.get(userId));
            system.debug('NumberOfCurrentNewLeads are: '+NumberOfCurrentNewLeads.get(userId));
            system.debug('NumberOfCurrentOpp owner are: '+NumberOfCurrentOpp.get(userId));
            currentUserRecord.fillCapacityValues(NumberOfCurrentLeads.get(userId),NumberOfCurrentNewLeads.get(userId),NumberOfCurrentOpp.get(userId));
            this.userMap.put(userId,currentUserRecord);
        }

    }

    
    /**
    * @description Performs actual assignment.
    * @param leads List of leads that need to be reassigned.
    */
    public void performAssignment(Lead[] leads){
        //Lead[] leads = [Select Id,OwnerId,Product__c from Lead where ID IN:leadIds];

        //System.debug(leads);
        //Iterate through List of leads
        String productName;
        userRecord userRecord;
        productUserQueue productUserQueue;
        Id userId;
        boolean done;
        boolean error;
        boolean userlistFinished;

        Set<Id> unassignedIds = new Set<Id>();
        Id unassignedId = QueueService.unassignedQueueId;   
        Id exceptionQueueId = QueueService.exceptionQueueId;

        Lead[] updatableLeads = new Lead[]{};   

        Lead[] assignableLeadTempArray = new Lead[]{};
        //Map<Id,Id> oldOwner = new Map<Id,Id>{};
        Map<Id,Id> newOwner = new Map<Id,Id>{};

        for(Lead lead:leads){
                //updating Bypass_Assignment is to activate the normal assignment logic for Store Agent Leads 
                Lead assignableLeadsTemp = new Lead(Id=lead.Id, Reassigned_Lead__c = false,Bypass_Assignment__c=false);
                assignableLeadTempArray.add(assignableLeadsTemp);
             
                //Get the Product Name Subscribed by the lead.
                productName = lead.Derived_Product__c;
                System.debug('Product Name is '+productName);
                System.debug('Product user map is '+this.productUserMap);
            if(this.productUserMap.containsKey(productName)){
                //Product Name Exists.
                productUserQueue = this.productUserMap.get(productName);    
                
                if(productUserQueue.productSupported==true){
                    //userIdList is not blank. Product is supported.

                    //Set Done and finished to false before finding suitable user.
                    done=false;
                    userlistFinished=false;
                    //Iterate until you find a suitable user to assign the lead to or no user exists for the product.
                    while((!done)&&(!userlistFinished) && (lead.Display_Phone__c==true)){
                        if(productUserQueue.hasUserAvailable()){
                            //Get the user from the top of Queue.
                            userId = productUserQueue.removeFirstUserId();
                            userRecord = this.userMap.get(userId);
                            
                            system.debug('Current lead owner is :' +lead.OwnerId);
                            system.debug('User exhausted?: '+ userId +' '+userRecord.userExhausted+' '+ userRecord);
                            system.debug('lead Id is :'+lead.Id);
                            
                            
                            if(!userRecord.userExhausted){
                                //If user is not exhausted,assign lead to user.
                                userRecord.userAssignedNewLead();
                                productUserQueue.addUserIdToLast(userId);
                                //---------Change from before to after------
                                //lead.OwnerId = userId;
                                    Lead updateLead = new Lead(Id=lead.Id, OwnerId = userId,Owner_Assigned_Time__c=system.now());
                                    updatableLeads.add(updateLead);
                                    //---------Change from before to after------
    
                                    //------------------Record change of owner for task Reassignment.------
                                    //oldOwner.add(lead.Id,lead.OwnerId);
                                    newOwner.put(lead.Id,userId);
                                    //------------------------------------------------------------------------
                                    done = true;
                                    System.debug(userId +' assigned to '+lead.Id+' for product '+productName);
                               }else{
                                //If user is exhausted, do not add him back to queue and continue ahead.
                                //System.debug(userId +' is exhausted');
                            }
                        }else{
                            userlistFinished = true;
                            //Assign this lead to the unassigned.
                            System.debug('Product '+productName+' could not be assigned for lead '+lead.Id);
                        }   
                    }//End of While loop. Assignment is successfull or failed.
                      system.debug('User list is finished?:' +userlistFinished);
                    if(userlistFinished || lead.Display_Phone__c==false){
                        //The lead could not be assigned to a suitable user.
                        //Assign lead to Unassigned Queue.              
                        //---------Change from before to after------
                        //lead.OwnerId = unassignedId;
                      
                        Lead updateLead = new Lead(Id=lead.Id, OwnerId = unassignedId);
                        updatableLeads.add(updateLead);
                        //---------Change from before to after------
                        unassignedIds.add(lead.Id);
                    }
                //End of 'if product Name is supported by any of the users'.    
                }else{
                    //Product Name Not Supported by any users.
                    System.debug('Product Name '+productName+'is not supported by any user for lead'+lead.Id);
                    //Assign lead to Lead Exception Queue.
                    //---------Change from before to after------
                    //lead.OwnerId = exceptionQueueId;
                    Lead updateLead = new Lead(Id=lead.Id, OwnerId = exceptionQueueId);
                    updatableLeads.add(updateLead);
                    //---------Change from before to after------
                    unassignedIds.add(lead.Id);

                }
            }else{
                //Product Name does not exist.
                System.debug('Product Name '+productName+'does not exist for lead'+lead.Id);
                //Assign lead to Lead Exception Queue.
                //---------Change from before to after------
                //lead.OwnerId = exceptionQueueId;
                Lead updateLead = new Lead(Id=lead.Id, OwnerId = exceptionQueueId);
                updatableLeads.add(updateLead);
                //---------Change from before to after------
                unassignedIds.add(lead.Id);
            }
        }//End of For Loop for Leads
        if(assignableLeadTempArray.size()>0){
            system.debug('xxxxxxxxxxxxxxxxxxxxxxxxxxxx'+assignableLeadTempArray);
            update assignableLeadTempArray;
        }

        /*
        if(unassignedIds.size()>0){
            // Run only for Trigger Update task.
            // During insert operation tasks are not present.
            // So this saves resources.
            if(trigger.isUpdate){
                Task[] associatedTasks = TaskService.getTasksAssociatedWithSobject(unassignedIds);
                TaskService.closeTasksByChangingStatus(associatedTasks, 'ReAssigned');
            }
            
        }
        */
        if(updatableLeads.size()>0){
            //  LeadService.reassignAssociatedTasks(updatableLeads,newOwner);
            update updatableLeads;
        }
        
    
    }
    
    /**
    * @description If a user was assigned a new lead by this trigger context, it changes the Last_Reassigned time for that user to current 

time.
    */
    public void changeLeadLastAssigned(){
        Lead_Assignment_Setting__c[] updateLeadAssignments = new Lead_Assignment_Setting__c[]{};
        Id primaryId;
        Datetime currenttime = datetime.now();
        //Iterate through all the userMap values to find userRecords that have LeadLastAssignedchanged set to true.
        for(userRecord user: this.userMap.values()){
            if(user.leadLastAssignedchanged==true){
                //If LeadLastAssigned has changed. Find Primary id for Object Lead_Assignment_Setting.
                primaryId = user.LeadAssignmentSettingId;
                Lead_Assignment_Setting__c updateLeadAssignment = new Lead_Assignment_Setting__c(Id=primaryId,Lead_Last_Assigned_Date__c=currenttime);
                updateLeadAssignments.add(updateLeadAssignment);
            }
        }
        //System.debug(updateLeadAssignments);
        if(updateLeadAssignments.size()>0){
            update updateLeadAssignments;
        }   
    }


    /**
    * @description Wrapper Class to hold Instance of a single product record. Implements a Queue Data Structure in Apex.
    */
    public class ProductUserQueue{
        /**
        * @description Name of Product
        */
        public String productName;
    
        /**
        * @description List of userId Ordered by priority.
        * This is essentially a queue. 
        * First user is taken of the Queue for Assignment.
        * If the Assignment is succcessfull, use is removed at put at end of queue
        */
        public LIST<Id> userIdList {get;set;}

        /**
        * @description If any user is found that supports the product, then this is set to true.
        * If it is false, it means the product is not supported. Lead will go to exception Queue.
        */
        public boolean productSupported {get;set;}

        /**
        * @description Constructor
        * @param productName Name of the product
        */
        public productUserQueue(String productName){
            this.productName=productName;
            this.userIdList = new LIST<Id>{};
            this.productSupported = false;
        }

        

        /**
        * @description Similar to queue method Queue.Enqueue(). Adds the user to end of the list.
        * @param userId userId for the user.
        */
        public void addUserIdToLast(Id userId){
            //System.debug(userId);
            this.userIdList.add(Userid);
            if(this.productSupported == false){
                this.productSupported = true;
            }
        }

        
        /**
        * @description Similar to queue method Queue.Dequeue(). Removes first User from list and return user id.
        * @return Id User id removed from the top of the Queue.
        */ 
        public Id removeFirstUserId(){
            Id currentId;
            List<String> newUserIdList = new List<String>{};
            Iterator<Id> listIterator = this.userIdList.iterator();
            currentId = listIterator.next();
            while(listIterator.hasNext()){
                    newUserIdList.add(listIterator.next());
            }
            this.userIdList=newUserIdList;
            return currentId;
        }

        /**
        * @description Returns if Product has users Available for assignment.
        * @return boolean True or False.
        */
        public boolean hasUserAvailable(){
            return (!this.useridList.isEmpty());
        }

    }


    /**
    * @description Wrapper class to hold a single User Record.
    */ 
    public class UserRecord{
        /**
        * @description Salesforce Id for the User.
        */
        public Id userId;

        /**
        * @descriptionlead lastAssigned
        */
        public Datetime leadLastAssigned;

        /**
        * @description If user is assigned a new lead during the process, his leadLastAssignedValue will change
        */
        public boolean leadLastAssignedchanged;

        /**
        * @description total Capacity User can accept.
        */
        public Integer totalCapacity;

        /**
        * @description total Lead capacity for the User.
        */
        public Integer leadCapacity;

        /**
        * @description Primary key for Lead Assingment Setting.
        */
        public Id LeadAssignmentSettingId;

        /**
        * @description totalCapacityLeft = TotalCapacity – 
        *               (New Leads owned by User +
        *                No of Leads owned by user that are not ‘dead/closed’ +
        *                No of Opps that are not ‘dead/closed’ or ‘funded/confirmed’)
        */
        public Integer totalCapacityLeft;

        /**
        * @description leadCapacityLeft= New Lead Capacity on Lead Assignment Record – Leads owned by the User that have a blank status
        */
        public Integer leadCapacityLeft;    

        /**
        * @description Specifies whether the current user is exhausted or has capacity to accept more leads.
        */
        public boolean userExhausted = false;   

        /**
        * @description Constructor for userRecord
        */
        public userRecord(Id LeadAssignmentSettingId, Id userId, Integer totalCapacity, Integer leadCapacity, Datetime leadLastAssigned){
            this.LeadAssignmentSettingId = LeadAssignmentSettingId;
            this.userId = userId;
            this.totalCapacity = totalCapacity;
            this.leadCapacity = leadCapacity;
            this.leadLastAssigned = leadLastAssigned;           
            this.leadLastAssignedchanged = false;
        }

        /**
        * @description Method Run when New Lead is assigned to the User Record. 
        */ 
        public void userAssignedNewLead(){
            this.totalCapacityLeft -= 1;
            this.leadCapacityLeft -= 1;
            this.leadLastAssignedchanged = true;
            if(this.leadCapacityLeft < 1 || this.totalCapacityLeft < 1){
                this.userExhausted = true;
            }
        }

        /**
        * @description Fill Capacity values for a particular user. 
        */ 
        public void fillCapacityValues(Integer UsedLeadCapacity,Integer UsedNewLeadCapacity,Integer UsedTotalCapacity){
            system.debug('Total leads Owned is '+UsedLeadCapacity);
            system.debug('New leads Owned is '+UsedNewLeadCapacity);
            system.debug('Total records Owned is '+UsedTotalCapacity);
           
           
            Integer UsedNewLeadOwned=0;
            if(UsedNewLeadCapacity!=null)UsedNewLeadOwned=UsedNewLeadCapacity;
            this.leadCapacityLeft = this.leadCapacity - UsedNewLeadOwned;
            this.totalCapacityLeft = this.totalCapacity - (UsedLeadCapacity + UsedTotalCapacity);
            system.debug('Lead capacity left is '+this.leadCapacityLeft);
            system.debug('Total Capacity left is '+this.totalCapacityLeft);
            if(this.leadCapacityLeft < 1 || this.totalCapacityLeft < 1){
                this.userExhausted = true;
            }
        }

    }

}