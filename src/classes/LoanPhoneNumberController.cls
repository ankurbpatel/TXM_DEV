/**
* @author Hema
* @date 03/27/2014
* @description Controller for opportunity Object. Helps with hiding/displaying of Phone number based on timezone values and current time
* @name LoanController.cls
* @type Controller Class
* @see pages/LoanPhoneNumberEdit.page
*/
public with sharing class LoanPhoneNumberController {

     /**
    * @description Standard controller for the page.
    */
    public ApexPages.StandardController stdController {get;set;}
    
    /**
    * @description Boolean value that dictates whether the Phone number needs to be displayed on the front end.
    */  
    public boolean displayPhone {get;set;}
    
    /** 
    * @description Boolean value which specifies if the First Contact has been made with the Account. 
    */
    public boolean firstContactMade {get;set;}
 
    /** 
    * @description opportunity/Account Record passed through the standard controller.
    */   
    public opportunity opportunity {get;set;}  
    public Account Account {get;set;} 
    /** 
    * @description Constructor method
    * @param stdController Standard Controller
    */
    public LoanPhoneNumberController(ApexPages.StandardController stdController) {
        
           List<String> fields = new List<String>();
            fields.add('First_Contact_Attempt_By__c');
            fields.add('Cell_phones__c');
            fields.add('Home_phones__c');
            fields.add('Alternate_phones__c');
            fields.add('Display_Phone__c');
            fields.add('First_Contact_Attempt__c');
            fields.add('First_Contact_Made__c');
            if (!Test.isRunningTest()){            
            stdController.addFields(fields); 
         }    
            this.opportunity= (opportunity)stdController.getRecord();
            this.Account=this.opportunity.Account;
            displayPhone = opportunity.Display_Phone__c;
            firstContactMade = opportunity.First_Contact_Made__c;
    }
    /** 
    * @description Performs Save
    */
    public void doSave(){
        update opportunity;
        update Account;
    }

    /** 
    * @description Updates First Contact made on the Account to current Date time.
    */
    public string userid;    
    public void updateFirstContact(){
         if(opportunity.id!=null){
            userid=userInfo.getUserid();
            User user=[select id,name from User where id =: userid];
            opportunity.First_Contact_Attempt_By__c=user.name;    
            opportunity.First_Contact_Made__c = true;
            opportunity.First_Contact_Attempt__c = Datetime.now();
            firstContactMade = true;
            update opportunity;
         }
    }

}