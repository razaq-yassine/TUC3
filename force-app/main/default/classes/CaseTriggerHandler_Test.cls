/**
 * @File               : CaseTriggerHandler
 * @Description        : Test class for Helper. No assertion needed since there is no logic coded in a trigger handler
 * @Author             : Yassine RAZAQ (yrazaq@salesforce.com)
 * @Group              : 
 * @Last_Modified_On   : 25/10/2022
 * @Modification_Log   :
 *======================================================================================
 * Ver         Date                           Author                  Modification
 *======================================================================================
 * 1.0      25/10/2022                   Yassine RAZAQ               Initial version
 **/
@isTest
public class CaseTriggerHandler_Test {

    @testsetup
    static void testsetup() {
        // ============ Accounts ============
        Account account1 = TestDataFactory.account(); // 2 contacts
        account1.Name = 'account1';
        Account account2 = TestDataFactory.account(); // 4 contacts
        account2.Name = 'account2';
        Account account3 = TestDataFactory.account(); // 0 contacts
        account3.Name = 'account3';
        insert new List<Account>{
                account1, account2, account3
        };
        // ============ Contacts ============
        // ---- 2 contacts linked with account1 (2)----
        Contact contact1 = TestDataFactory.contact();
        contact1.AccountId = account1.Id;
        Contact contact2 = TestDataFactory.contact();
        contact2.AccountId = account1.Id;
        // ---- 4 contacts linked with account2 ----
        Contact contact3 = TestDataFactory.contact();
        contact3.AccountId = account2.Id;
        Contact contact4 = TestDataFactory.contact();
        contact4.AccountId = account2.Id;
        Contact contact5 = TestDataFactory.contact();
        contact5.AccountId = account2.Id;
        Contact contact6 = TestDataFactory.contact();
        contact6.AccountId = account2.Id;
        insert new List<Contact>{
                contact1, contact2, contact3, contact4, contact5, contact6
        };
        // case to be closed
        Case aCase = TestDataFactory.case();
        aCase.AccountId = account1.Id;
        aCase.Origin = 'Phone';
        insert aCase;
    }

    @IsTest
    static void checkContactsNbr_InWebCase_Test() {
        String error = '';
        // getting data
        Account account1 = [SELECT Id FROM Account WHERE Name = 'account1' LIMIT 1];
        // start test
        Test.startTest();
        try {
            // Case1= {Origin: Web, Account: notNull, Contacts: 2}
            Case case1 = TestDataFactory.case();
            case1.Origin = 'Web';
            case1.AccountId = account1.Id;
            case1.Subject = 'case1';
            insert case1;
        } catch (Exception e) {
            error = e.getMessage();
        }
        Test.stopTest();
        // Asertion
        System.assertNotEquals(error, '');
        System.assert(error.contains(System.Label.Case_WebMaxLimitError));
    }

    @isTest
    static void checkContactsNbr_InPhoneCase_Test() {
        String error = '';
        // getting data
        Account account2 = [SELECT Id FROM Account WHERE Name = 'account2' LIMIT 1];
        // start test
        Test.startTest();
        try {
            // Case2= {Origin: Phone, Account: notNull, Contacts: 4}
            Case case2 = TestDataFactory.case();
            case2.Origin = 'Phone';
            case2.AccountId = account2.Id;
            case2.Subject = 'case2';
            insert case2;
        } catch (Exception e) {
            error = e.getMessage();
        }
        Test.stopTest();
        // Asertion
        System.assertNotEquals(error, '');
        System.assert(error.contains(System.Label.Case_PhoneMaxError));
    }

    @isTest
    static void checkIfZeroContacts_Test() {
        String error = '';
        // getting data
        Account account3 = [SELECT Id FROM Account WHERE Name = 'account3' LIMIT 1];
        // start test
        Test.startTest();
        try {
            // Case3= {Origin: Web, Account: notNull, Contacts: 0}
            Case case3 = TestDataFactory.case();
            case3.Origin = 'Web';
            case3.Subject = 'case3';
            case3.AccountId = account3.Id;
            insert case3;
        } catch (Exception e) {
            error = e.getMessage();
        }
        Test.stopTest();
        // Asertion
        System.assertNotEquals(error, '');
        System.assert(error.contains(System.Label.Case_ContactsRequiredError));
    }

    @isTest
    static void checkIfAccountNull_Test() {
        String error = '';
        // start test
        Test.startTest();
        try {
            // Case4= {Origin: Web, Account: null, Contacts: 0}
            Case case4 = TestDataFactory.case();
            case4.Origin = 'Web';
            case4.Subject = 'case4';
            insert case4;
        } catch (Exception e) {
            error = e.getMessage();
        }
        Test.stopTest();
        // Asertion
        System.assertNotEquals(error, '');
        System.assert(error.contains(System.Label.Case_AccountRequiredError));
    }

    @isTest
    static void checkIfOriginNotAllowed_Test() {
        String error = '';
        // getting data
        Account account2 = [SELECT Id FROM Account WHERE Name = 'account2' LIMIT 1];

        // start test
        Test.startTest();
        try {
            // Case5= {Origin: Email, Account: notNull, Contacts: 4}
            Case case5 = TestDataFactory.case();
            case5.Origin = 'Email';
            case5.Subject = 'case5';
            case5.AccountId = account2.Id;
            insert case5;
        } catch (Exception e) {
            error = e.getMessage();
        }
        Test.stopTest();
        // Asertion
        System.assertNotEquals(error, '');
        System.assert(error.contains(System.Label.Case_OriginNotAllowedError));
    }

    @isTest
    static void onUpdate_Test() {
        String error = '';
        // getting data
        List<Case> cases = [SELECT Id FROM Case];
        for (Case aCase : cases){aCase.Status='Closed';}
        // setting fake response with Mock
        Test.setMock(HttpCalloutMock.class, new AttendeeRegistrationMock());
        // start test
        Test.startTest();
        update cases;
        Test.stopTest();
        // No assertion needed since buisness logic is tested directly from helper class

    }
}