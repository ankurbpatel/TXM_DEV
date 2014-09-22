@isTest
public class TestDisplayPhoneController{
    public static testmethod void My_Method(){
    //Account acc = TestUtils.createAccountWithPhone('firstname','11122233');
    Account acc=new Account();
        acc.name='test';
        insert acc;
    ApexPages.StandardController sc = new ApexPages.StandardController(acc); 
    DisplayPhoneController obj = new DisplayPhoneController();
    }
}