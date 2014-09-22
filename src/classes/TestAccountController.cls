@isTest
public class TestAccountController {
    
    @isTest public static void TestAccountController() {
        //Insert Accounts
        Account acc = TestUtils.createAccountWithPhone('firstname','1112223333', true);

        AccountController controller = new AccountController(new ApexPages.StandardController(acc));
        Account controllerAccount = controller.account;
        controllerAccount.Phone = '5559991111';
        controller.doSave();
        controller.updateFirstContact();

        Account updatedacc =[Select Id,Phone from Account where Id=:acc.Id];
        System.assertEquals(updatedacc.Phone,'5559991111');
    }
    
}