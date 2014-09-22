/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 01/29/2014
* @description Model Class to retrieve Custom Setting Call Planning Setup.
* @name CallPlanningSetupSettingModel
* @type Model Class
*/
public with sharing class CallPlanningSetupSettingModel {
	public static List<Call_Planning_Setup__c>  callPlanningSetup
    {
        get
        {
            if(callPlanningSetup == null){
            	callPlanningSetup = Call_Planning_Setup__c.getall().values();
            } 
            return callPlanningSetup;
        }
        public set;
    }


    public static Map<String,Call_Planning_Setup__c> callPlanningSetupMap{get;set;}
    
    static{
        callPlanningSetupMap = new Map<String,Call_Planning_Setup__c>{};
        for(Call_Planning_Setup__c cps : callPlanningSetup){
            callPlanningSetupMap.put(cps.Name, cps);
        }
    }

    public static List<String> countsAsContactAttempt{get;set;}

    static{
        countsAsContactAttempt = new List<String>{};
        String name; 
        for (Call_Planning_Setup__c callPlanningSetupRecord : callPlanningSetup){           
            if(callPlanningSetupRecord.Counts_as_Contact_Attempt__c == true){
                name = callPlanningSetupRecord.Name;
                countsAsContactAttempt.add(name);
            }                  
        }  
    }

    /**
    * @description get Due Date from Custom settings based on name and previous task values.
    */
    public static DateTime getDueDate(String name,Task previousTask){
        Datetime dueDate = Datetime.now();
        System.debug(dueDate);
        Integer addHours = 0;
        Integer addMinutes = 0;
        String recordName;
        String callBackTime;
        if(callPlanningSetupMap.containsKey(name)){
            Call_Planning_Setup__c callPlanningSetupRecord;
            callPlanningSetupRecord = callPlanningSetupMap.get(name);
            recordName = callPlanningSetupRecord.Name;
            if(callPlanningSetupRecord.Override_Due_Date__c == true){
                callBackTime = previousTask.Call_Back_Time__c;
                dueDate = CallBackTimeSettingModel.getDueDate(callBackTime);
            }else{
                addHours = Integer.valueOf(callPlanningSetupRecord.Due_Date_Hour__c);
                addMinutes = Integer.valueOf(callPlanningSetupRecord.Due_Date_Minutes__c);
                dueDate = dueDate.addHours(addHours);
                dueDate = dueDate.addMinutes(addMinutes);
            }                   
        }
        
        return dueDate;
    }

    /**
    * @description get Stage Name and Status Name.
    */
    public static String getStageStatusValues(String name,String type){
        String returnString;
        if(callPlanningSetupMap.containsKey(name)){
            Call_Planning_Setup__c callPlanningSetupRecord;
            callPlanningSetupRecord = callPlanningSetupMap.get(name);
            if(type == 'Opportunity'){
                returnString = callPlanningSetupRecord.Parent_Opportunity_Stage__c;      
            }else{
                returnString = callPlanningSetupRecord.Parent_Lead_Status__c;
            }                 
        }else{
            if(type == 'Opportunity'){
                returnString = 'Prospecting';
            }else{
                returnString = 'New';
            }
        }
        return returnString;
    }


}