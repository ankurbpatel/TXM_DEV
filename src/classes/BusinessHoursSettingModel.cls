/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 01/08/2013
* @description Model Class to retrieve Custom Settings.
* @name BusinessHoursSettingModel
* @type Model Class
*/
public class BusinessHoursSettingModel {
    /**
    * @description Contains custom setting Business Hours.
    */
    public static BusinessHours__c setting
    {
        get
        {   
            Datetime dt = DateTime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0));
            String dayOfWeek=dt.format('EEEE');
            System.debug('Day : ' + dayOfWeek);
            if(setting == null) setting = BusinessHours__c.getInstance(dayOfWeek); 
            return setting;
        }
        public set;
    }
    /**
    * @description Contains value of end hour from custom setting Business Hours. If not present returns default value 21.
    */
    public static Integer endHour
    {
        get
        {
            if(setting != null) {
                return Integer.valueof(setting.EndHour__c);
            }else{
                return 21;
            }
        }
    }
    /**
    * @description Contains value of start hour from custom setting Business Hours. If not present returns default value 8.
    */
    public static Integer startHour
    {
        get
        {
            if(setting != null) {
                return Integer.valueof(setting.StartHour__c);
            }else{
                return 8;
            }
        }
    }
    /**
    * @description Contains value of minute difference from custom setting Business Hours. If not present returns default value 10.
    */
    public static Integer minuteDiff
    {
        get
        {
            if(setting != null) {
                return Integer.valueof(setting.MinuteDifference__c);
            }else{
                return 10;
            }
        }
    }
}