@isTest (SeeAllData=true)
private class TestTaskpagectrl{

    @isTest public static void Testtaskpage() {
        Test.startTest();
        Profile profile = TestUtils.getProfile('System Administrator');
        User user = TestUtils.createUser('lastName', 'alias', profile.Id, true);
        id leadrectypeid = [select id from recordtype where name='OSR Lead' and sobjecttype='Lead'].id;
        lead testlead = new lead(lastname='test name', recordtypeid=leadrectypeid);
        insert testlead;
        
        task t = [select disposition__c,Detail__c from task where whoid=:testlead.id limit 1];
        
        t.disposition__c='Contacted';
        t.Detail__c = 'Appointment Set';
        update t;
       
        RecordType rt=[select id from recordtype where Name=:'Business Account'];
        Account a=new account(Name='test',recordtypeId=rt.id);
        insert a;
        Opportunity o=new Opportunity(stageName='Funded:Confirmed',Name='test',AccountId=a.id,CloseDate=date.today(),Brand__c='Titlemax');
        insert o;
        Contact c=new Contact(AccountId=a.id,LastName='test');
        insert c;
        OpportunityContactRole ocr=new OpportunityContactRole (contactId=c.id , OpportunityId=o.id);
        insert ocr;

        opportunity topp = [select id from opportunity  where id=:o.id Order by createddate desc limit 1];
        System.assertEquals(topp.id,o.id);
        PageReference pageRef = Page.newtaskforoppty;
        pageRef.getParameters().put('id', String.valueOf(topp.Id));
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(topp);
        taskpagectrl testtask = new taskpagectrl(sc);
        
        testtask.update1();
        
        Test.stopTest();
    }
    
}