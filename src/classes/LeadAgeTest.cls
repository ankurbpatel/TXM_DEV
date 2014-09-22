@isTest
private class LeadAgeTest {

	private static testMethod void testLeadAge() {
		String leadJSON = '{"attributes":{"type":"Lead","url":"/services/data/v25.0/sobjects/Lead/00Qe0000003yEbR"},"Id":"00Qe0000003yEbR","Company":"Appirio","LastName":"Sharma","CreatedDate":"2014-09-01T11:54:26.000+0000"}'; 
		
		Lead lead1 = (Lead) JSON.deserialize(leadJSON, Lead.class);  
		
		Lead lead2 = new Lead(Id = lead1.Id);
		update lead2;
		
		lead2 = [SELECT Lead_Age__c,CreatedDate FROM Lead WHERE Id=:lead2.Id];
		
		System.debug('####-'+lead2.CreatedDate);
	}

}