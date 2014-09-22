public class UpdateLoanInfo
{
ApexPages.StandardController stdController;

public UpdateLoanInfo(ApexPages.StandardController ctl) 
{
        stdController = ctl;
}

public PageReference executeAction()
{
    Opportunity objLoan = (Opportunity) stdController.getRecord();
    //The vehicle year, make and model fields will be updated to pull from the picklist and/or textbox to populate the appropriate fields.  
    if (objLoan.Vehicle_Year__c != null && objLoan.Vehicle_Year_BB__c != '--Other--'){  
        objLoan.Vehicle_Year_BB__c = objLoan.Vehicle_Year__c; 
        objLoan.Vehicle_Year__c = '';                
    }
    
    if (objLoan.Vehicle_Make__c != null && objLoan.Vehicle_Make_BB__c != '--Other--'
        && (objLoan.Vehicle_Make_BB__c != '--None--' && objLoan.Vehicle_Year_BB__c != '--Other--')){  
        objLoan.Vehicle_Make_BB__c = objLoan.Vehicle_Make__c; 
        if (objLoan.Vehicle_Make_BB__c == objLoan.Vehicle_Make__c){                
            objLoan.Vehicle_Make__c = '';             
        }                
    }
    
    if (objLoan.Vehicle_Model__c != null && objLoan.Vehicle_Model_BB__c != '--Other--'
        && (objLoan.Vehicle_Model_BB__c != '--None--' && objLoan.Vehicle_Year_BB__c != '--Other--')){  
        objLoan.Vehicle_Model_BB__c = objLoan.Vehicle_Model__c; 
        if (objLoan.Vehicle_Model_BB__c == objLoan.Vehicle_Model__c){
            objLoan.Vehicle_Model__c = '';             
        }                
    }    
 
    //stdController = new ApexPages.StandardController(objLoan);
    //return stdController.edit();
    return null;    
}
 

}