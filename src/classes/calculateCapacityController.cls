/**
* @author Hema
* @date 05/05/2014
* @description Controller for calculateCapacity page .
* @name CalculateCapacityController.cls
*/

public with sharing class calculateCapacityController {
    List <Lead_Assignment_Setting__c> LasList=new List<Lead_Assignment_Setting__c> ();
    Map<Id,Integer> NumberOfCurrentOpp = new Map <Id,Integer>{};
    Map<Id,Integer> NumberOfCurrentLeads = new Map <Id,Integer>{};
    Map<Id,Integer> NumberOfCurrentNewLeads = new Map <Id,Integer>{};
    List <Lead_Assignment_Setting__c> updateLasList=new List<Lead_Assignment_Setting__c> ();
    public Id lasId {get;set;}
    datetime myDateTime = datetime.now();
    string mydtstring = mydatetime.format();
   
    public calculateCapacityController(ApexPages.StandardController controller) {
       lasId=ApexPages.currentPage().getParameters().get('id');
    }
    
     public static void calculateForAssignment(List<Lead_Assignment_Setting__c>lasNew, Map<id,Lead_Assignment_Setting__c>oldLasMap){
       Boolean calcul = false; 
       for(Lead_Assignment_Setting__c ls:lasNew){
          if(ls.CalculateCapacity_for_Assignment__c!=oldLasMap.get(ls.Id).CalculateCapacity_for_Assignment__c && ls.CalculateCapacity_for_Assignment__c==true){
              calcul=true;
              system.debug('Calculate capacity for Assignment is :'+ls.CalculateCapacity_for_Assignment__c);
          }
       }
       if(calcul==true){
              Map<Id,Integer> NumberOfCurrentOpp = new Map <Id,Integer>{};
              Map<Id,Integer> NumberOfCurrentLeads = new Map <Id,Integer>{};
              Map<Id,Integer> NumberOfCurrentNewLeads = new Map <Id,Integer>{};
              List <Lead_Assignment_Setting__c> updateLasList=new List<Lead_Assignment_Setting__c> ();
              set<id>userSet=new set<id>();
              datetime myDateTime = datetime.now();
              string mydtstring = mydatetime.format();
              List <Lead_Assignment_Setting__c> LasList= [select id,user__c,Leads_Owned__c,Loans_Owned__c,New_Leads_Owned__c,Total_Capacity__c,New_Lead_Capacity__c from Lead_Assignment_Setting__c where user__c!=null];
              if(LasList.size()>0){
                 for(Lead_Assignment_Setting__c las:lasList){
                     if(las.user__c!=null){
                         userSet.add(las.user__c);
                     }
                 }
                
                 for(Id ownerId:userSet){
                     List<lead> leadOwnedList=[Select status, OwnerId from Lead Where OwnerId =:ownerId and  (status=:'New' OR Status=:'In Process' OR Status=:'Funded') and isConverted=:false ];
                     List<lead> newLeadOwnedList=new List<lead>();
                     for(lead l:leadOwnedList){
                         if(l.status=='New'){
                             newLeadOwnedList.add(l);
                         }
                     }
                   //  List <opportunity> oppOwnedList=[Select stageName, OwnerId from Opportunity Where OwnerId IN:userSet  and (stageName=:'In Process' OR stageName=:'Appointment Not Kept' OR stageName=:'Funded') and isClosed=:false];
                     NumberOfCurrentLeads.put(ownerId,leadOwnedList.size());
                     system.debug('Number of leads owned is'+NumberOfCurrentLeads.size());
                     NumberOfCurrentNewLeads.put(ownerId,newLeadOwnedList.size());
                     system.debug('Number of new leads owned is'+NumberOfCurrentNewLeads.size());
                    // NumberOfCurrentOpp.put(ownerId,oppOwnedList.size());
                    // system.debug('Number of opportunities owned is'+NumberOfCurrentOpp);
                 }
                 
                  //count of opportunities owned per user
                Id userIdTemp2;
                Integer oppTotalTemp;
                for(AggregateResult arOpp : [Select Count(Id),OwnerId from Opportunity Where OwnerId IN:userSet  and (stageName=:'In Process' OR stageName=:'Appointment Not Kept' OR stageName=:'Funded') Group by OwnerId]){
                    userIdTemp2 =  String.valueOf(arOpp.get('OwnerId'));
                    oppTotalTemp = Integer.valueOf(arOpp.get('expr0'));
                    NumberOfCurrentOpp.put(userIdTemp2,oppTotalTemp);
                    system.debug('Number of opportunities owned is'+NumberOfCurrentOpp.size());
        
                }
                /*
                 //count of leads owned per user
                 Id userIdTemp;
                 Integer leadTotalTemp;
                   for(AggregateResult arLead : [Select Count(Id),OwnerId from Lead Where OwnerId IN:userSet  and  status!='Funded:Confirmed' and Status!='Appointment Set' and Status!='Closed' and isConverted=:false Group by OwnerId]){
                        userIdTemp =  String.valueOf(arLead.get('OwnerId'));
                        LeadTotalTemp = Integer.valueOf(arLead.get('expr0'));
                        NumberOfCurrentLeads.put(userIdTemp,LeadTotalTemp);
                        system.debug('Number of leads owned is'+NumberOfCurrentLeads);
                 }
               
                 //count of new leads owned per user
                Id userIdTemp3;
                Integer leadTotalTemp3;
                for(AggregateResult arNewLead : [Select Count(Id),OwnerId from Lead Where OwnerId IN:userSet  and status=:'New' Group by OwnerId]){
                        userIdTemp3 =  String.valueOf(arNewLead.get('OwnerId'));
                        LeadTotalTemp3 = Integer.valueOf(arNewLead.get('expr0'));
                        NumberOfCurrentNewLeads.put(userIdTemp3,LeadTotalTemp3);
                        system.debug('Number of new leads owned is'+NumberOfCurrentNewLeads);
                }*/
                
                
                //updating the lead assignment records with  calculated values
                for(Lead_Assignment_Setting__c lass:lasList){
                    Integer leadsOwned=0;
                    Integer oppsOwned=0;
                    Integer newLeadsOwned=0;
                    Integer CurrentTotalCapacity=0;
                    Integer CurrentNewLeadCapacity=0;
                    
                    if(NumberOfCurrentLeads.get(lass.user__c)!=null){
                      leadsOwned=NumberOfCurrentLeads.get(lass.user__c);
                    } 
                    if(NumberOfCurrentOpp.get(lass.user__c)!=null){
                        oppsOwned=NumberOfCurrentOpp.get(lass.user__c);
                    }
                    if(NumberOfCurrentNewLeads.get(lass.user__c)!=null){
                        lass.New_Leads_Owned__c=NumberOfCurrentNewLeads.get(lass.user__c);
                    } 
                    
                    lass.Leads_Owned__c=leadsOwned;
                    lass.Loans_Owned__c=oppsOwned;
                    lass.CalculateCapacity_for_Assignment__c=false;
                    updateLasList.add(lass);
                    system.debug('Leads Owned are: '+  lass.Leads_Owned__c );
                    system.debug('Loans Owned are: '+  lass.Loans_Owned__c);
                    system.debug('New Leads Owned are: '+ lass.New_Leads_Owned__c);
                }
                 if(updateLasList.size()>0){
                   update updateLasList;
                } 
            }
        }  
     }
 
    public pageReference calculate(){
         LasList= [select id,user__c,Total_Capacity__c,New_Lead_Capacity__c from Lead_Assignment_Setting__c];
         set<id>userSet=new set<id>();
         if(LasList.size()>0){
             for(Lead_Assignment_Setting__c las:lasList){
                 if(las.user__c!=null){
                     userSet.add(las.user__c);
                 }
             }
             //count of leads owned per user
             Id userIdTemp;
             Integer leadTotalTemp;
             for(AggregateResult arLead : [Select Count(Id),OwnerId from Lead Where OwnerId IN:userSet  and  status!='Funded:Confirmed' and Status!='Appointment Set' and Status!='Closed' and isConverted=:false Group by OwnerId]){
                    userIdTemp =  String.valueOf(arLead.get('OwnerId'));
                    LeadTotalTemp = Integer.valueOf(arLead.get('expr0'));
                    NumberOfCurrentLeads.put(userIdTemp,LeadTotalTemp);
                    system.debug('Number of leads owned is'+NumberOfCurrentLeads);
             }
            //count of opportunities owned per user
            Id userIdTemp2;
            Integer oppTotalTemp;
            for(AggregateResult arOpp : [Select Count(Id),OwnerId from Opportunity Where OwnerId IN:userSet  and stageName!='Funded:Confirmed' and stageName!='Appointment Set'and stageName!='Closed Lost' Group by OwnerId]){
                userIdTemp2 =  String.valueOf(arOpp.get('OwnerId'));
                oppTotalTemp = Integer.valueOf(arOpp.get('expr0'));
                NumberOfCurrentOpp.put(userIdTemp2,oppTotalTemp);
                system.debug('Number of opportunities owned is'+NumberOfCurrentOpp);
    
            }
             //count of new leads owned per user
            Id userIdTemp3;
            Integer leadTotalTemp3;
            for(AggregateResult arNewLead : [Select Count(Id),OwnerId from Lead Where OwnerId IN:userSet  and status=:'New' Group by OwnerId]){
                    userIdTemp3 =  String.valueOf(arNewLead.get('OwnerId'));
                    LeadTotalTemp3 = Integer.valueOf(arNewLead.get('expr0'));
                    NumberOfCurrentNewLeads.put(userIdTemp3,LeadTotalTemp3);
                    system.debug('Number of new leads owned is'+NumberOfCurrentNewLeads);
            }
            
            //updating the lead assignment records with  calculated values
            for(Lead_Assignment_Setting__c lass:lasList){
                Integer leadsOwned=0;
                Integer oppsOwned=0;
                Integer newLeadsOwned=0;
                Integer CurrentTotalCapacity=0;
                Integer CurrentNewLeadCapacity=0;
                
                if(NumberOfCurrentLeads.get(lass.user__c)!=null){
                    leadsOwned=NumberOfCurrentLeads.get(lass.user__c);
                } 
                if(NumberOfCurrentOpp.get(lass.user__c)!=null){
                    oppsOwned=NumberOfCurrentOpp.get(lass.user__c);
                } 
                if(NumberOfCurrentNewLeads.get(lass.user__c)!=null){
                    newLeadsOwned=NumberOfCurrentNewLeads.get(lass.user__c);
                } 
                if(lass.Total_Capacity__c-(leadsOwned+oppsOwned)>0)
                CurrentTotalCapacity=  Integer.valueof(lass.Total_Capacity__c-(leadsOwned+oppsOwned));
                if(lass.New_Lead_Capacity__c-newLeadsOwned>0)
                CurrentNewLeadCapacity= Integer.valueof(lass.New_Lead_Capacity__c-newLeadsOwned); 
                      
                lass.CurrentTotalCapacity__c=CurrentTotalCapacity+' (Calculated on '+ mydtstring +')';
                lass.CurrentNewLeadCapacity__c=CurrentNewLeadCapacity+' (Calculated on '+ mydtstring +')';
                lass.CalculateCapacity_for_Assignment__c=false;
                updateLasList.add(lass);
            }
        }
        if(updateLasList.size()>0){
           update updateLasList;
        } 
        if(lasId!=null){
            pageReference p=new pageReference('/'+lasId);
            return p;
        }
      return null;
     }
 
}