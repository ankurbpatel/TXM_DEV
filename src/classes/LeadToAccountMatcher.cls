/**
* @author Erashad Kurawle
* @company Bluewolf
* @modified Dheeraj
* @date 01/25/2014
* @description Extends Abstract class MatchHelper Class. Performs LeadToAccountMatching.
* @name MatchHelperClass.cls
* @type Abstract Class
* @see LeadService.cls
*/
public class LeadToAccountMatcher extends MatchHelperClass{

    /**
    * @description Temporary list of leads for matching purpose
    */
    Lead[] leadsInQuestion;
    /**
    * @description Constructor Method
    */
    public LeadToAccountMatcher(Lead[] leads) {
        this.leads = leads;
        this.perfectMatch = new Map<Id,Id> {};
        this.ambiguousMatch = new Map<Id,list<Id>> {};
    }

    /**
    * @description Overriden Method to do actual matching. 
    */ 
    public override void doMatching(){
        System.debug('Inside do Matching');
        System.debug(this.leads);
        // Step 1)Iterate through leads gathering all phone number
         set<string> phoneSet=new set<string>();
         list<account> accountList=new list <account>();
Map<Id,Id> pp= new Map<Id,Id>();
         Map<Id,list<Id>> ap= new Map<Id,list<Id>>();


        //End of this step you have a set of Phone numbers.
        for(Lead l: this.leads){
            if(l.MobilePhone!='' && l.MobilePhone!=null)
                phoneSet.add(l.MobilePhone);
            if(l.Phone!='' && l.Phone!=null) 
                phoneSet.add(l.Phone);
            if(l.Alternate_Phone__c!='' && l.Alternate_Phone__c!=null)     
                phoneSet.add(l.Alternate_Phone__c);
        }
        system.debug(phoneSet);

        try {
           // get account list here
            accountList = [select Id,  Phone, PersonOtherPhone, PersonMobilePhone, PersonHomePhone
                        from Account 
                        where ((Phone in:phoneSet ) AND createdDate = LAST_N_DAYS:10)]; 
             System.debug(accountList);
         }
         catch(DmlException e){ } 
         
         System.debug(accountList);
         if(accountList.size()>0){  
            for(Lead l:this.leads){
                List<Id> matchAccount = new list<Id>();
                for(Account acc:accountList){
                    //add match logic here
                    if(l.MobilePhone==acc.Phone || l.Phone==acc.Phone || l.Alternate_Phone__c==acc.Phone || l.MobilePhone==acc.PersonOtherPhone || l.Phone==acc.PersonOtherPhone || l.Alternate_Phone__c==acc.PersonOtherPhone || l.MobilePhone==acc.PersonMobilePhone || l.Phone==acc.PersonMobilePhone || l.Alternate_Phone__c==acc.PersonMobilePhone || l.MobilePhone==acc.PersonHomePhone || l.Phone==acc.PersonHomePhone || l.Alternate_Phone__c==acc.PersonHomePhone )
                    {
                         matchAccount.add(acc.id);   
                    }     
                }
                if(matchAccount.size() == 1){
                   pp.put(l.id, matchAccount[0]);    
                }
                if(matchAccount.size() > 1){
                   ap.put(l.id, matchAccount);    
                }
            }
            this.perfectMatch = pp;
            this.ambiguousMatch = ap;
          }

          System.debug(this.perfectMatch);  
          System.debug(this.ambiguousMatch);
          
    }
    public override void takeActionAfterMatching(){
        LeadConvertUtility.convertLeads(this.perfectMatch,this.ambiguousMatch,this.leads,false);
    }

}