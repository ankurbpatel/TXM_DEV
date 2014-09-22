/**
* @author       Erashad Kurawle
* @company      Bluewolf
* @date         01/23/2013
* @description  Webservice class for Agent Center. Used my Custom links in the Agent Center and Home Page Component DynamicHTML.
* @name         AgentCenter.cls
* @type         WebService Class
*/
global class AgentCenter {

    /**
    * @description  Webservice method to fetch a new Lead from the System. 
    * @param        
    * @return       Results Instance of the Result class. Contains the Result of the Operation
    * @see          AgentCommandCenter.Result 
    */ 
    webservice static Results acceptNextCase(Id userId){
    Results res;
    System.debug(userId);   
        //Id userId = UserInfo.getUserId();
        userRecord userRec = new UserRecord(userId,false);
        System.debug(userRec);
            if(userRec.userExhausted == false){
                Boolean b=userRec.findLeadFromOvernightQueue();
                 if(b==true){
                    res = new Results(true, userRec.leadId, userRec.leadName);
                    userRec.changeLeadLastAssigned();
                }else{
                    String errorMessage = 'There are no Leads Available for assignment at this time. Please try again later.';
                    res = new Results(errorMessage, false);
                }
            }else{
                    String errorMessage = 'You cannot accept new leads at this moment. Reason:'+userRec.capacityErrorMessage+' Increase your capacity or close current leads/opportunities to accept new leads.';
                    res = new Results(errorMessage, false);
            } 
        
        return res;
    }

    /**
    * @description  Webservice method to fetch a new Lead from the System. 
    * @return       Instance of the Result class. Contains the Result of the Operation
    * @see          AgentCommandCenter.Result 
    */ 
    webservice static Results acceptTenDayOldCase(Id userId){
    Results res;    
        userRecord userRec = new UserRecord(userId,false);
        System.debug(userRec);
        
        if(userRec.userExhausted == false){
           Boolean b=userRec.findLeadFromTenDayQueue();
            if(b==true){
                res = new Results(true, userRec.leadId, userRec.leadName);
                userRec.changeLeadLastAssigned();
            }
            else{
                String errorMessage = 'There are no Leads Available for assignment at this time. Please try again later.';
                res = new Results(errorMessage, false);
            }
        
        }else{

                String errorMessage = 'You cannot accept new leads at this moment. Reason:'+userRec.capacityErrorMessage+' Increase your capacity or close current leads/opportunities to accept new leads.';
                res = new Results(errorMessage, false);
        }    
        return res;
    }
    /**
    * @description  Webservice method to get Initial availability of the current logged in User.
    * @return InitialAvailability   Instance of the InitialAvailability Class. Contains Initial availability Information. 
    */
    webservice static InitialAvailability getInitialAvailability(){
        InitialAvailability initial;
        initial = new InitialAvailability();
        Id userId = UserInfo.getUserId();
        UserRecord userRec = new userRecord(userId,true);
        
        if (userRec.lasFound==true){
            Boolean currentAvailability = userRec.currentAvailability;
            Boolean displayTenDayButton = userRec.displayTenDayButton;
            Boolean displayOvernightButton = userRec.displayOvernightButton;

            if(currentAvailability==true){
            initial.fill(true, true, displayOvernightButton, displayTenDayButton);
            }else{
            initial.fill(true, false, displayOvernightButton, displayTenDayButton);
            }
        }else{
            initial.fill(false, false, false, false);
        }
        
        return initial;
    }

    /**
    * @description  Webservice method to set current logged in User's availability to false.
    */
    webservice static void makeUserBusy(){
        Id userId = UserInfo.getUserId();
        userRecord userRec = new UserRecord(userId,true);
        userRec.changeAvailability(false);
    }

    /**
    * @description Wrapper class to hold Lead Assignment settings for a User.
    */ 
    
    public class UserRecord{

        /**
        * @description Current availability of the user.
        */
        private Boolean currentAvailability {get;set;}

        private Id userId {get;set;}
        /**
        * @description total Capacity User can accept.
        */
        private Integer totalCapacity {get;set;}

        /**
        * @description total Lead capacity for the User.
        */
        private Integer leadCapacity {get;set;}

        /**
        * @description Primary key for Lead Assingment Setting.
        */
        private Id LeadAssignmentSettingId {get;set;}

        /**
        * @description totalCapacityLeft = TotalCapacity – 
        *               (New Leads owned by User +
        *                No of Leads owned by user that are not ‘dead/closed’ +
        *                No of Opps that are not ‘dead/closed’ or ‘funded/confirmed’)
        */
        private Integer totalCapacityLeft {get;set;}

        /**
        * @description leadCapacityLeft= New Lead Capacity on Lead Assignment Record – Leads owned by the User that have a blank status
        */
        private Integer leadCapacityLeft {get;set;} 

        /**
        * @description Specifies whether the current user is exhausted or has capacity to accept more leads.
        */
        private boolean userExhausted = false;  

        /**
        * @description Specifies if Lead Assignment setting was found for this user.
        */
        private boolean lasFound {get;set;}

        /**
        * @description List of products user can accept.
        */
        private List<String> productList {get;set;}

        /**
        * @description Holds value of lead id when new lead is assigned to user.
        */
        public Id leadId {get;set;}

        /**
        * @description Holds value of lead Name when new lead is assigned to user.
        */
        public String leadName {get;set;}

        /**
        * @description Error message when capacity is hit.
        */
        public String capacityErrorMessage {get;set;}


        /**
        * @description Specifies whether overnight buttton should be displayed to user or not.
        */
        public boolean displayOvernightButton {get;set;}

        /**
        * @description Specifies whether Ten day buttton should be displayed to user or not.
        */
        public boolean displayTenDayButton {get;set;}

        /**
        * @description Constructor for userRecord
        * @param userIdpassed Current user's Id
        * @param lessData Depending on this parameter, different versions of constructor's are run.
        */
        public UserRecord(Id userIdpassed,Boolean lessData){
            userId = userIdpassed;
            if(lessData){
                constructorLightWeight();
            }else{
                constructorHeavyWeight();
            }
        }
        /**
        * @description Light Weight Constructor. Fetches Lead Assignment setting and basic info about user. 
        */
        public void constructorLightWeight(){   
            this.displayOvernightButton = false;
            this.displayTenDayButton = false;
            List<Lead_Assignment_Setting__c> lasList = [Select Id, Availability__c,
                                                    Accept_Overnight_Leads__c,Accept_10_Day_Leads__c,State_Level_Lead_Owner__c
                                                    from Lead_Assignment_Setting__c 
                                                    where User__c = :userId ];
            /**
            * Check if Lead Assignment Setting exists for user.
            */
            if(lasList.size()>0){
                Lead_Assignment_Setting__c las = lasList[0];
                LeadAssignmentSettingId = las.Id;
                currentAvailability = las.Availability__c;
                lasFound = true;
                /**
                * Toggle Display for overnight button.
                */
                this.displayOvernightButton = (Boolean)las.Accept_Overnight_Leads__c;
                //this.displayTenDayButton = (Boolean)las.Accept_10_Day_Leads__c;
                this.displayTenDayButton = (Boolean)las.State_Level_Lead_Owner__c;

            }else{
                currentAvailability = false;
                lasFound = false;
            }
        }

        /**
        * @description Heavy Weight Constructor. Fetches Lead Assignment setting and other information like Current capacity and used capcity.
        */
        public void constructorHeavyWeight(){
            this.displayOvernightButton = false;
            this.displayTenDayButton = false;
            List<Lead_Assignment_Setting__c> lasList = [Select Id, Availability__c, Accept_Overnight_Leads__c, Accept_10_Day_Leads__c, 
                                                    New_Lead_Capacity__c, Total_Capacity__c, Product__c,State_Level_Lead_Owner__c 
                                                    from Lead_Assignment_Setting__c 
                                                    where User__c = :userId ];
            /**
            * Check if Lead Assignment Setting exists for user.
            */
            if(lasList.size()>0){
                Lead_Assignment_Setting__c las = lasList[0];
                LeadAssignmentSettingId = las.Id;
                totalCapacity = Integer.valueof(las.Total_Capacity__c);
                leadCapacity = Integer.valueof(las.New_Lead_Capacity__c);
                leadCapacityLeft = 0;
                totalCapacityLeft = 0;
                lasFound = true;
                fetchUsedCapacity();
                List<String> productList = new List<String>{};
                if(las.Product__c!=null){
                    productList = las.Product__c.split(';');
                }
                
                this.productList = productList;

                /**
                * Toggle Display for overnight button.
                */
                this.displayOvernightButton = (Boolean)las.Accept_Overnight_Leads__c;
                //this.displayTenDayButton = (Boolean)las.Accept_10_Day_Leads__c;
                this.displayTenDayButton = (Boolean)las.State_Level_Lead_Owner__c;

            }else{
                totalCapacity = 0;
                leadCapacity = 0;
                leadCapacityLeft = 0;
                totalCapacityLeft = 0;
                lasFound = true;
            }

        }

        /**
        * @description Changes availability of the current logged in user.
        * @param currentAvailability    True or false value that defines value to set current Availability.
        */
        public void changeAvailability(Boolean currentAvailability){
            if(lasFound){       
                Id primaryId = LeadAssignmentSettingId;
                Lead_Assignment_Setting__c las = new Lead_Assignment_Setting__c(Id=primaryId,Availability__c=currentAvailability);
                update las;
            }
        }

        /**
        * @description Get Used Capacity Values.
        */
        public void fetchUsedCapacity(){

                //Fill up Lead Capacity of Each user.
                Integer leadTotalTemp = 0;
               // for(AggregateResult arLead : [Select Count(Id),OwnerId from Lead Where OwnerId =:userId and Status in ('Contacted','Open','New') Group by OwnerId]){ 
                for(AggregateResult arLead : [Select Count(Id),OwnerId from Lead Where OwnerId =:userId and  isConverted=:false and Status NOT IN ('Funded:Confirmed','Appointment Set' ,'Closed') Group by OwnerId]){        
                    LeadTotalTemp = Integer.valueOf(arLead.get('expr0'));
                }
                
                Integer NewleadTotalTemp = 0;
               // for(AggregateResult arLead : [Select Count(Id),OwnerId from Lead Where OwnerId =:userId and Status in ('Contacted','Open','New') Group by OwnerId]){ 
                for(AggregateResult arNewLead : [Select Count(Id),OwnerId from Lead Where OwnerId =:userId and  isConverted=:false and Status=:'New' Group by OwnerId]){        
                    NewleadTotalTemp = Integer.valueOf(arNewLead.get('expr0'));
                }

                //Fill up Opportunity Capacity of Each user.
                Integer oppTotalTemp = 0;
               // for(AggregateResult arOpp : [Select Count(Id),OwnerId from Opportunity Where OwnerId =:userId and StageName NOT IN ('Closed Won','Closed Lost') Group by OwnerId]){
                for(AggregateResult arOpp : [Select Count(Id),OwnerId from Opportunity Where OwnerId =:userId and StageName NOT IN ('Funded:Confirmed','Appointment Set' ,'Closed Lost') Group by OwnerId]){
                    oppTotalTemp = Integer.valueOf(arOpp.get('expr0'));
                }

                fillRemainingValues(leadTotalTemp,NewleadTotalTemp,oppTotalTemp);
        }
        /**
        * @description Fill Capacity values for a particular user. 
        */ 
       
        public void fillRemainingValues(Integer UsedLeadCapacity,Integer NewLeadsOwned, Integer UsedTotalCapacity){
            
            this.leadCapacityLeft = leadCapacity - NewLeadsOwned;
            this.totalCapacityLeft = totalCapacity - (UsedLeadCapacity + UsedTotalCapacity);

            System.debug('Lead capacity is'+this.leadCapacity);
            System.debug('Used Lead capacity is'+UsedLeadCapacity);
            System.debug('New Leads Owned is'+NewLeadsOwned);
            System.debug('Total capacity is'+this.totalCapacity);
            System.debug('Used Total capacity is'+UsedTotalCapacity);
            System.debug('New Lead capacity left is'+this.leadCapacityLeft);
            System.debug('Total capacity left is'+this.totalCapacityLeft);


            if(this.leadCapacityLeft < 1){
                this.userExhausted = true;
                this.capacityErrorMessage = ' Lead capacity of '+this.leadCapacity+' reached.';
            }
            if(this.totalCapacityLeft < 1){
                this.userExhausted = true;
                this.capacityErrorMessage = this.capacityErrorMessage + ' Total capacity of '+this.totalCapacity+' reached.';
            }
        }


        /**
        * @description Change Lead Last Assigned Date, if new lead is assigned to current user
        */
        public void changeLeadLastAssigned(){
            Datetime currenttime = datetime.now();  
            //Find Primary id for Object Lead_Assignment_Setting.
            Id primaryId = this.LeadAssignmentSettingId;
            Lead_Assignment_Setting__c updateLeadAssignment = new Lead_Assignment_Setting__c(Id=primaryId,Lead_Last_Assigned_Date__c=currenttime);
            update updateLeadAssignment;
        }

        /**
        * @description finds leads from overnight queue and assigns it to current user
        * @return returns true if lead is found. False otherwise
        */
        public boolean findLeadFromOvernightQueue(){
            boolean returnVal;
            Id overnightId = QueueService.overnightQueueId;
            if(productList.size()>0){
                List<Lead> leadList = [Select Id,OwnerId,Name,Lead_Assigned__c,Restricted_Zip__c from Lead where OwnerId=:overnightId and Restricted_Zip__c=:false and Derived_Product__c IN:productList  and Lead_Assigned__c=:false and Display_Phone__c=true order by CreatedDate DESC LIMIT 1];
                if(leadList.size()>0){
                  Lead lead = [select Id,OwnerId,Lead_Assigned__c ,Name from Lead where id=:leadList[0].id limit 1 FOR UPDATE];
                    if(lead.Lead_Assigned__c==false){
                            lead.OwnerId = userId;
                            leadId = lead.Id;
                            leadName = lead.Name;
                            lead.Lead_Assigned__c=true;
                            update lead;
                         //   leadList.remove(0);
                            returnVal = true;
                        } else{
                            findLeadFromOvernightQueue();
                            returnVal = true;
                        }
                        //createInitialTask(lead.Id,userId);
                  }else{
                        system.debug('There are no leads in the overnight lead queue');
                        returnVal = false;
                }
            }else{
                  system.debug('The product list is empty for the overnight lead queue');
                  returnVal = false;
            }
            System.debug('Return val is'+returnVal);
            return returnVal;
        }

        /**
        * @description finds leads from ten day queue and assigns it to current user
        * @return returns true if lead is found. False otherwise
        */
        public boolean findLeadFromTenDayQueue(){
            System.debug('Inside ten day function');
            boolean returnVal;
            Id overnightId = QueueService.overnightQueueId;
            if(productList.size()>0){
                List<Lead> leadList = [Select Id,OwnerId,Name,Lead_Assigned__c,Restricted_Zip__c from Lead where OwnerId=:overnightId and Restricted_Zip__c=:true and Derived_Product__c IN:productList and  Lead_Assigned__c=:false and Display_Phone__c=true order by CreatedDate];
                if(leadList.size()>0){
                   Lead lead =[Select Id,OwnerId,Name,Lead_Assigned__c from Lead where id=:leadList[0].id LIMIT 1 FOR UPDATE];
                    if(lead.Lead_Assigned__c==false){
                        lead.OwnerId = userId;
                        leadId = lead.Id;
                        leadName = lead.Name;
                        lead.Lead_Assigned__c=true;
                        update lead;
                       // leadList.remove(0);
                        //createInitialTask(lead.Id,userId);
                        returnVal = true;
                     }else{
                         findLeadFromTenDayQueue();
                         returnVal = true;
                     }
                }else{
                    system.debug('There are no leads in the state level lead queue');
                    returnVal = false;
                }
            }else{
                 system.debug('The product list is empty for the state level lead queue');
                returnVal = false;
            }
            return returnVal;
        }

        /**
        * @description Creates Initial task when new lead is assigned. This is no longer needed. Initial task is created on Lead trigger
        * @deprecated
        * @return returns true if lead is found. False otherwise
        */
      /*  public void createInitialTask(Id leadId, Id ownerId){
            Task[] foundTask = [Select Id from Task where WhoId = :leadId AND IsClosed=false];
            if(foundTask.size() == 0){
                task initialTask = new Task(subject = 'Initial Call Attempt', whoId = leadId, OwnerId = ownerId);
                insert initialTask;
            }           
        }*/

    }


    /**
    * @description Inner Wrapper class to wrap results of the Fetch Lead Operation
    */
    global class Results{
        webservice Boolean leadAssigned {get;set;}
        webservice Id leadId {get;set;}
        webservice String leadName {get;set;}
        webservice String errorMessage {get;set;}

        /**
        * @description Empty constructor
        */
        public Results(){
        }

        /**
        * @description Set method to set values of parameters.
        */
        public Results(Boolean leadAssigned, Id leadId, String leadName){
            this.leadAssigned = leadAssigned;
            this.leadId = leadId;
            this.leadName = leadName;
        }

        /**
        * @description Set method to set values of parameters.
        */
        public Results(String errorMessage, Boolean leadAssigned){
            this.leadAssigned = leadAssigned;
            this.errorMessage = errorMessage;
        }

    } 

    /**
    * @description Inner Wrapper class to wrap results of the Fetch Lead Operation
    */
    global class InitialAvailability{
        webservice Boolean found {get;set;}
        webservice Boolean available {get;set;}
        webservice Boolean displayOvernightButton {get;set;}
        webservice Boolean displayTenDayButton {get;set;}

        /**
        * @description Constructor method
        */
        public InitialAvailability(){
        }

        /**
        * @description fills parameter values for this class.
        */
        public void fill(Boolean found, Boolean available, Boolean displayOvernightButton, Boolean displayTenDayButton){
            this.found = found;
            this.available = available;
            this.displayOvernightButton = displayOvernightButton;
            this.displayTenDayButton = displayTenDayButton;
        }

    } 

}