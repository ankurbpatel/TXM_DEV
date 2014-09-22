public class TaskListController {

   String s = 'My worklist';
   public Set<string>zipcode{get;set;}
  
    public void  refreshPage(){
        total_size= [select count() from Task where OwnerId=:userinfo.getuserid() and isClosed=:false and Disposition__c=:'' and Overdue__c=true and Display_Phone__c=true  and Lead_Opportunity_created_Date__c>=:leadDate] ;
    }
    
    public String getString() {
        return null;
    }
    
    public void setString(String s) {
        this.s = s;
    }
 
    public integer counter{get;set;}  //keeps track of the offset
    public integer list_size{get;set;} //sets the page size or number of rows
    public integer total_size{get;set;} //used to show user the total size of the list
    public integer totalPages{get;set;}
    public date leadDate=Date.newInstance(2014, 03, 01);
    public integer recordNo{get;set;}
    public integer recordNoLast{get;set;}
    public integer currentPage{get;set;}      
     
    public string selectedPage{get;set{selectedPage=value;}
    }
    
    public TaskListController() {
       counter=0;
       list_size=50;
       total_size = [select count() from Task where OwnerId=:userinfo.getuserid() and isClosed=:false  and Disposition__c=:'' and Overdue__c=true and Display_Phone__c=true   and Lead_Opportunity_created_Date__c>=:leadDate]; //set the total size in the constructor
       selectedPage='0';
       /*zipcode=new set<string>();
       List<ZIP_code__c>zipList=[select id, ZIP_code_value__c, Restricted_Zip__c from ZIP_code__c where  Restricted_Zip__c=:true];
       if(zipList.size()>0){
           for(ZIP_code__c z:zipList){
              if(z.ZIP_code_value__c!=null){
                   zipcode.add(z.ZIP_code_value__c);
              }
 
           }
       }*/
    }                                                    
    
    public Task[] getTasks() {
                  
        if (selectedPage != '0'){ 
        counter = list_size*integer.valueOf(selectedPage)-list_size;}
 
 
        try { //we have to catch query exceptions in case the list is greater than 2000 rows
 
              Task[] taskList = [select  id,Subject__c,Overnight_Lead__c ,Store_Phone__c,store_chosen__c,Lead_Opportunity_Status__c,Detail__c,Lead_Opportunity_Name__c,Restricted_Zip__c,Lead_Postal_Code__c, Owner.Name,Due__c, Time_zone__c,Overdue__c,Last_Detail__c,Product_Requested__c,Lead_Id__c,status,Lead_Last_Disposition__c,Lead_Source__c, Lead_Loan__c,whatID, whoID, Description,Worklist_Priority__c, LastModifiedBy.name, LastModifiedDate, createdDate ,Attempt__c From task  where OwnerId=:userinfo.getuserid() and isClosed=:false and Disposition__c=:'' and Overdue__c=true and Display_Phone__c=true   and Lead_Opportunity_created_Date__c>=:leadDate  ORDER BY Worklist_Priority__c  limit :list_size
                                    offset :counter]; 
 
              for(task t:taskList){
                   /* if(zipcode.contains(t.Lead_Postal_Code__c )){
                        t.Restricted_Zip__c=true;
                    }*/
                    if(t.whatId!=null){
                        t.lead_loan_URL__c='/'+t.WhatId;
                    }
                    else{
                     t.lead_loan_URL__c='/'+t.WhoId;
                    }
              }
              //  total_size= taskList.size();
              if(tasklist.size()>0){  
                    if (math.mod(total_size, list_size) > 0) {
                        totalPages = total_size/list_size + 1;
                    } else {
                        totalPages = (total_size/list_size);
                    } 
                    
                           
                    if (selectedPage == '0') {
                        currentPage = counter/list_size + 1;
                        recordNo=counter+1;
                        recordNoLast=counter+taskList.size();
                    } else {
                        currentPage = integer.valueOf(selectedPage);
                        recordNo=counter+1;
                        recordNoLast=counter+taskList.size();
                    }                    
                    return taskList;
              }else {return null;}
        
        } catch (QueryException e) {                            
                ApexPages.addMessages(e);                   
                return null;
        }        
    }
    
    
    
    public PageReference refreshGrid() { //user clicked a page number        
        system.debug('**** ' + selectedPage);
        return null;
    }
    
    public PageReference Previous() { //user clicked previous button
        selectedPage = '0';
        counter -= list_size;
        return null;
    }

    public PageReference Next() { //user clicked next button
        selectedPage = '0';
        counter += list_size;
        return null;
    }

    public PageReference End() { //user clicked end
        selectedPage = '0';
        counter = total_size - math.mod(total_size, list_size);
        return null;
    }
    
    public Boolean getDisablePrevious() { //this will disable the previous and beginning buttons
        if (counter>0) return false; else return true;
    }

    public Boolean getDisableNext() { //this will disable the next and end buttons
        if (counter + list_size < total_size) return false; else return true;
       //if (counter>50) return false; else return true;
    }

    public Integer getTotal_size() {
        return total_size;
    }
    
    public Integer getPageNumber() {
        return counter/list_size + 1;
    }

    public Integer getTotalPages() {
        if (math.mod(total_size, list_size) > 0) {
            return total_size/list_size + 1;
        } else {
            return (total_size/list_size);
        }
    }
  
}