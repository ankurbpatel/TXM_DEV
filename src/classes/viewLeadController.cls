public class  viewLeadController {
Lead l {get;set;}
Lead lead {get;set;}
public string userid {get;set;}  
public boolean upd {get;set;} 
public integer localtime {get;set;}
public datetime myDateTime {get;set;}
public string mydtstring {get;set;}
public String userProfile {get;set;}
User user;

    public viewLeadController(ApexPages.StandardController controller) {
        upd =false;
        this.l=(lead)controller.getRecord();
        lead=[select id,IsUnreadByOwner,Owner_Viewed__c,LastViewedDate,Owner_Profile__c,Owner_Last_Viewed__c, Owner_Viewed_Time__c, IsConverted, OwnerId ,First_Contact_Made__c from lead where id=:L.id];
        if(lead.Owner_Last_Viewed__c!=null){
            myDateTime = lead.Owner_Last_Viewed__c;
            mydtstring = mydatetime.format();
        }
        userid=userInfo.getUserid();
        user=[select id,name,profile.Name from User where id =: userid];
        userProfile =user.profile.Name;
    }
    
    public PageReference oppPage() {
    
        if(lead.Owner_Viewed__c==null  && userid==lead.OwnerId && lead.IsUnreadByOwner==true && lead.IsConverted==false){
            
            lead.Owner_Viewed__c=user.name;    
            lead.Owner_Viewed_Time__c = Datetime.now();
            system.debug('Updating the lead');
            update lead;
        }
        if(userid==lead.OwnerId && lead.IsConverted==false){
            lead.Owner_Last_Viewed__c=system.now();
            update lead;
        }
        
        if(lead.IsConverted==true){
            PageReference oppPage= new PageReference ('/p/lead/ViewConvertedLead/d?id='+l.id);
            oppPage.setRedirect(true); 
            return oppPage;
        }
     
        return null;
   
    }

}