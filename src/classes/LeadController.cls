/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 01/07/2013
* @description Controller for Lead Object. Helps with hiding/displaying of Phone number based on timezone values and current time
* @name AccountController.cls
* @type Controller Class
* @see pages/LeadPhoneNumberEdit.page
*/
public with sharing class LeadController {

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
    * @description Lead Record passed through the standard controller.
    */   
    public Lead lead {get;set;}  

    /** 
    * @description Constructor method
    * @param stdController Standard Controller
    */
    public LeadController(ApexPages.StandardController stdController) {
        
            List<String> fields = new List<String>();
            fields.add('First_Contact_Attempt_By__c');
            fields.add('Phone');
            fields.add('Alternate_Phone__c');
            fields.add('MobilePhone');
            fields.add('Display_Phone__c');
            fields.add('First_Contact_Attempt__c');
            fields.add('First_Contact_Made__c');
            if (!Test.isRunningTest()){            
            stdController.addFields(fields); 
         }    
            this.lead = (Lead)stdController.getRecord();
            displayPhone = lead.Display_Phone__c;
            firstContactMade = lead.First_Contact_Made__c;
    }
    /** 
    * @description Performs Save
    */
    public void doSave(){
        update lead;
    }

    /** 
    * @description Updates First Contact made on the Account to current Date time.
    */
    public string userid;    
    public void updateFirstContact(){
        userid=userInfo.getUserid();
        User user=[select id,name from User where id =: userid];
        lead.First_Contact_Attempt_By__c=user.name;    
        lead.First_Contact_Made__c = true;
        lead.First_Contact_Attempt__c = Datetime.now();
        firstContactMade = true;
        update lead;
    }

}