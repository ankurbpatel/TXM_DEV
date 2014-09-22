/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 02/06/2014
* @description Model Class to retrieve Custom Setting Call Back Time
* @name CallBackTimeSettingModel
* @type Model Class
*/
public with sharing class CallBackTimeSettingModel {
	public static List<Call_Back_Time__c>  callBackTime
    {
        get
        {
            if(callBackTime == null){
            	callBackTime = Call_Back_Time__c.getall().values();
            } 
            return callBackTime;
        }
        public set;
    }


    public static Map<String, Call_Back_Time__c> callBackTimeMap{get;set;}
    
    static{
        callBackTimeMap = new Map<String,Call_Back_Time__c>{};
        for(Call_Back_Time__c cps : callBackTime){
            callBackTimeMap.put(cps.Name, cps);
        }
    }


    public static DateTime getDueDate(String name){
        Datetime dueDate = Datetime.now();
        System.debug(dueDate);
        Integer addMinutes = 0;
        if(callBackTimeMap.containsKey(name)){
            Call_Back_Time__c callBackTimeRecord;
            callBackTimeRecord = callBackTimeMap.get(name);
            if(callBackTimeRecord.Defer_to_Next_Day__c == true){
            	Integer tommTime = Integer.valueOf(callBackTimeRecord.Tomorrow_Time__c);
            	dueDate = CallBackTimeSettingModel.getTomorrowTime(tommTime);           
            }else{
	            addMinutes = Integer.valueOf(callBackTimeRecord.Call_Back_Minutes__c);
	            dueDate = dueDate.addMinutes(addMinutes);
            }                   
        }
        return dueDate;
    }


	public static Datetime getTomorrowTime(Integer hour) {
		Date tomorrowDate = Date.Today().adddays(1);
		Time tm = Time.newInstance(hour,00,00,00);
		Datetime dueTime = Datetime.newInstance(tomorrowDate,tm);
		return dueTime;
	}
}