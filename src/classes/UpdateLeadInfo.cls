public class UpdateLeadInfo
{
ApexPages.StandardController stdController;

public UpdateLeadInfo(ApexPages.StandardController ctl) 
{
        stdController = ctl;
}

public PageReference executeAction()
{
    Lead objLead = (Lead) stdController.getRecord();
    //The vehicle year, make and model fields will be updated to pull from the picklist and/or textbox to populate the appropriate fields.  
    if (objLead.Vehicle_Year__c != null && objLead.Vehicle_Year_BB__c != '--Other--'){  
        objLead.Vehicle_Year_BB__c = objLead.Vehicle_Year__c; 
        objLead.Vehicle_Year__c = '';                
    }
    
    if (objLead.Vehicle_Make__c != null && objLead.Vehicle_Make_BB__c != '--Other--'
        && (objLead.Vehicle_Make_BB__c != '--None--' && objLead.Vehicle_Year_BB__c != '--Other--')){  
        objLead.Vehicle_Make_BB__c = objLead.Vehicle_Make__c; 
        if (objLead.Vehicle_Make_BB__c == objLead.Vehicle_Make__c){                
            objLead.Vehicle_Make__c = '';             
        }                
    }
    
    if (objLead.Vehicle_Model__c != null && objLead.Vehicle_Model_BB__c != '--Other--'
        && (objLead.Vehicle_Model_BB__c != '--None--' && objLead.Vehicle_Year_BB__c != '--Other--')){  
        objLead.Vehicle_Model_BB__c = objLead.Vehicle_Model__c; 
        if (objLead.Vehicle_Model_BB__c == objLead.Vehicle_Model__c){
            objLead.Vehicle_Model__c = '';             
        }                
    }      
 
    //stdController = new ApexPages.StandardController(objLead);
    //return stdController.edit();
    return null;    
}
 

}