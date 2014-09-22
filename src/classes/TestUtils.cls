/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 12/27/2013
* @description Utility class for Test class.
* @name assignLeadsHelper.cls
* @type Utility Class
* @see TestUtils.cls
*/
public class TestUtils {
    
    /**
    * @description Creates a single lead.
    */
    public static Lead createLead(String firstName,String lastName,String company,String status,String postalCode, Boolean doInsert){
   
        Lead lead = new Lead(FirstName=firstName,LastName=lastName,Company=company,Status=status,PostalCode=postalCode);
        //lead.Brand_Requested__c = 'Some brand';
        if(doInsert)
            insert lead;
        return lead;
    }

    /**
    * @description Creates a single lead with Phone.
    */
    public static Lead createLeadWithPhone(String firstName,String lastName,String company,String status,String postalCode,String phone, Boolean doInsert){

        Lead lead = new Lead(FirstName=firstName,LastName=lastName,Company=company,Status=status,Phone=phone,PostalCode=postalCode);
        //lead.Brand_Requested__c = 'Some brand';
        if(doInsert)
            insert lead;
        return lead;
    }
    
    /**
    * @description Creates Bulk Leads.
    */
    public static Lead[] createLeadsBulk(String firstName,String lastName,String company,String status,String postalCode, Boolean doInsert){
   
        List<Lead> leads = new List<Lead>{};     
        for(Integer i = 0; i < 200; i++){
            Lead lead = new Lead(FirstName=firstName + i,LastName=lastName+i,Company=company,Status=status,PostalCode=postalCode);
            //lead.Brand_Requested__c = 'Some brand';
            leads.add(lead);
        }
        if(doInsert)
            insert leads;
        return leads;
    }
    
    /**
    * @description Creates Leads with Product field Set.
    */
    public static Lead createLeadWithProduct(String firstName,String lastName,String company,String status,String postalCode, String product, Boolean doInsert){
        
        Lead lead = new Lead(FirstName=firstName,LastName=lastName,Company=company,Status=status,PostalCode=postalCode , Product_Requested__c = product);
        //lead.Brand_Requested__c = 'Some brand';
        if(doInsert)
            insert lead;
        return lead;
    }

    /**
    * @description Creates Leads with Product field Set. Brand is also passed
    */
    public static Lead createLeadWithProduct(String firstName,String lastName,String company,String status,String postalCode, String brand, String product, Boolean doInsert){
        
        Lead lead = new Lead(FirstName=firstName,LastName=lastName,Company=company,Status=status,PostalCode=postalCode , Brand_Requested__c = brand , Product_Requested__c = product);
        //lead.Brand_Requested__c = 'Some brand';
        if(doInsert)
            insert lead;
        return lead;
    }
    
    /**
    * @description Creates Some junk Zip Code Records.
    */
    public static Zip_Code__c[] createSomeZipCodeRecords(){
        /**
        * Create test Data.
        */
        Zip_Code__c[] zip_codes = new Zip_Code__c[]{
                                  new Zip_Code__c(Time_zone__c='EST',ZIP_code_value__c='10018'),  
                                  new Zip_Code__c(Time_zone__c='PST',ZIP_code_value__c='95002'),  
                                  new Zip_Code__c(Time_zone__c='MST',ZIP_code_value__c='87101'),  
                                  new Zip_Code__c(Time_zone__c='CST',ZIP_code_value__c='75019')
                                  };
        insert zip_codes;   
        return zip_codes;
    }
  

    /**
    * @description Creates single Account.
    */
    public static Account createAccount(String name, String uniquePersonId, Boolean doInsert){
        Id recordTypeId = TestUtils.getRecordType('Business Account');
        Account acc = new Account(Name = name, RecordTypeId = recordTypeId, Unique_Person_Id__c = uniquePersonId);
        if(doInsert)
            insert acc;
        return acc;
    }
    
    /**
    * @description Creates single Account with Phone.
    */
    public static Account createAccountWithPhone(String name, String phone, Boolean doInsert){
        Id recordTypeId = TestUtils.getRecordType('Business Account');
        Account acc = new Account(Name = name, RecordTypeId = recordTypeId, Phone = phone, Unique_Person_Id__c = '656352');
        if(doInsert)
            insert acc;
        return acc;
    }

        /**
    * @description Creates single Account with Phone.
    */
    public static Account createAccountWithPhoneUniqueId(String name, String uniquePersonId, String phone, Boolean doInsert){
        Id recordTypeId = TestUtils.getRecordType('Business Account');
        Account acc = new Account(Name = name, RecordTypeId = recordTypeId, Phone = phone, Unique_Person_Id__c = uniquePersonId);
        if(doInsert)
            insert acc;
        return acc;
    }
    /**
    * @description Creates single opportunity.
    */
    public static Opportunity createOpportunity(Account acc, String name, Double amount,String stageName,Id ownerId, Boolean doInsert, String loanNumber){
        Opportunity opp = new Opportunity(AccountId = acc.id, Name = name, Amount = amount, StageName = stageName,OwnerId = ownerId, CloseDate = Date.Today().addMonths(2), Unique_Loan_Id__c = loanNumber);
       
        if(doInsert)
            insert opp;
            
        return opp;
    }
    

    /**
    * @description Creates a single User.
    */
    public static User createUser(String lastName, String alias, Id profileId, Boolean doInsert){
        User usr = new User(LastName = lastName, Alias = alias , Email = lastName +'@childfund.org', Username = lastName+'@test.com',
                                    ProfileId = profileId, IsActive = true, LanguageLocaleKey = 'en_US', TimeZoneSidKey = 'America/New_York',
                                    EmailEncodingKey = 'ISO-8859-1', LocaleSidKey = 'en_US');
        
        if(doInsert)
            insert usr;
            
        return usr;    
    }

    public static Task createTask(Id whoId,Boolean doInsert){

        Task task =new Task(Description = 'Some desc',
                                        Priority = 'Normal',
                                        Status = 'Not Started',
                                        Subject = 'Some Subject',
                                        IsReminderSet = false,
                                        ReminderDateTime = System.now()+1,
                                        WhoId = whoId);
        if(doInsert)
            insert task;
            
        return task;
    }
    
        
    /**
    * @description Creates Lead Assignment Setting Record.
    */
    public static Lead_Assignment_Setting__c createLeadAssignmentSetting(User user,Boolean availability,Datetime leadLastAssignedDate, Integer leadCapacity,String product, Integer totalCapacity, Boolean doInsert){
        Lead_Assignment_Setting__c leadSetting = new Lead_Assignment_Setting__c(User__c = user.id,Real_time_Lead_User__c=true, Availability__c = availability,Lead_Last_Assigned_Date__c = leadLastAssignedDate, New_Lead_Capacity__c = leadCapacity, Product__c = product, Total_Capacity__c = totalCapacity,Accept_Overnight_Leads__c = true);
    
        if(doInsert)
            insert leadSetting;
            
        return leadSetting;
    }
        
    /**
    * @description Returns profile record for a specific profile Name.
    */
    public static Profile getProfile(String profileName){
        return [SELECT Id FROM Profile WHERE Name like: '%'+profileName+'%' limit 1];
        //return [SELECT Id FROM Profile WHERE Name like: 'System Administrator' limit 1];
    }

    
    /**
    * @description Returns RecordTypeId for a specific RecordType Name.
    */
    public static Id getRecordType(String recordTypeName){
        RecordType R = [Select Id,Name from RecordType where Name=:recordTypeName];
        return R.Id;
    }


    /**
    * @description To be used only when test is run without seeAllData=True.
    * Helper method to create Custom Setting Business Hours to be used by Test methods.
    */ 
    public static void setupTestBusinessHourCustomSetting(){
        BusinessHours__c setting = BusinessHoursSettingModel.setting;
        if(setting == null){
            setting = new BusinessHours__c(Name ='Business Hours',EndHour__c=21,StartHour__c=8,MinuteDifference__c=10);
            //insert setting;
            BusinessHoursSettingModel.setting = setting;    
        }
        
        
    }


    /**
    * @description Sets Test Time within Business Hours
    */
    public static void setTestingTimeWithinBusinessHours(){
        //Make sure current time of insertion is not after business Hours.
        String stringDateGMT = '2013-10-05 10:03:20';
        TestLeadTrigger.currentTime = datetime.valueOf(stringDateGMT);
    }

    /**
    * @description Sets Test Time after Business Hours
    */
    public static void setTestingTimeAfterBusinessHours(){
        //Pass GMT Datetime
        String stringDateGMT = '2013-10-05 03:03:20';
        TestLeadTrigger.currentTime = datetime.valueOf(stringDateGMT);
        
    }
        
}