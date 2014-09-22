/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 01/07/2013
* @description Controller for Account Object. Helps with hiding/displaying of Phone number based on timezone values and current time
* @name AccountController.cls
* @type Controller Class
* @see pages/AccountPhoneNumberEdit.page
*/
public with sharing class AccountController {
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
    * @description Account Record passed through the standard controller.
    */
    public Account account {get;set;}  

    /** 
    * @description Constructor method.
    * @param stdController Standard Controller.
    */
    public AccountController(ApexPages.StandardController stdController) {
         
            List<String> fields = new List<String>();
            fields.add('Phone');
            fields.add('PersonHomePhone');
            fields.add('PersonMobilePhone');
            fields.add('PersonOtherPhone');
            fields.add('Display_Phone__c');
            fields.add('First_Contact_Attempt__c');
            fields.add('First_Contact_Made__c');
            if (!Test.isRunningTest()){            
            stdController.addFields(fields); 
         }    
            this.account = (Account)stdController.getRecord();
            displayPhone = account.Display_Phone__c; 
            firstContactMade = account.First_Contact_Made__c;            
    }

    /** 
    * @description Performs Save
    */
    public void doSave(){
        update account;
    }

    /** 
    * @description Updates First Contact made on the Account to current Date time.
    */
    public void updateFirstContact(){
        account.First_Contact_Made__c = true;
        account.First_Contact_Attempt__c = Datetime.now();
        firstContactMade = true;
        update account;
    }
}