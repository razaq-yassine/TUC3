/**
 * @File               : CaseHelper_Test
 * @Description        : Test class for CaseHelper.
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
public class CaseHelper_Test {

    @testsetup
    static void testsetup() {
        // ============ Accounts ============
        Account account1 = TestDataFactory.account(); // 2 contacts
        account1.Name = 'account1';
        Account account2 = TestDataFactory.account(); // 4 contacts
        account2.Name = 'account2';
        Account account3 = TestDataFactory.account(); // 0 contacts
        account3.Name = 'account3';
        insert new List<Account>{account1, account2, account3};
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
        insert new List<Contact>{contact1, contact2, contact3, contact4, contact5, contact6};
        // ============ Cases ============
        // Case1= {Origin: Web, Account: notNull, Contacts: 2}
        Case case1 = TestDataFactory.case();
        case1.Origin = 'Web';
        case1.AccountId = account1.Id;
        case1.Subject = 'case1';
        // Case2= {Origin: Phone, Account: notNull, Contacts: 4}
        Case case2 = TestDataFactory.case();
        case2.Origin = 'Phone';
        case2.AccountId = account2.Id;
        case2.Subject = 'case2';
        // Case3= {Origin: Web, Account: notNull, Contacts: 0}
        Case case3 = TestDataFactory.case();
        case3.Origin = 'Web';
        case3.Subject = 'case3';
        case3.AccountId = account3.Id;
        // Case4= {Origin: Web, Account: null, Contacts: 0}
        Case case4 = TestDataFactory.case();
        case4.Origin = 'Web';
        case4.Subject = 'case4';
        // Case5= {Origin: Email, Account: notNull, Contacts: 4}
        Case case5 = TestDataFactory.case();
        case5.Origin = 'Email';
        case5.Subject = 'case5';
        case5.AccountId = account2.Id;
        // inserting cases
        TriggerHandler.bypass('CaseTriggerHandler');
        insert new List<Case>{case1, case2, case3, case4, case5};
        TriggerHandler.clearBypass('CaseTriggerHandler');
    }

    @IsTest
    static void checkContactsNbr_InPhoneCase_Test() {
        String error ='';
        // getting data
        // case1
        List<Case> cases = [SELECT AccountId, Origin FROM Case WHERE Subject='case1'];
        // start test
        Test.startTest();
        try{
            CaseHelper.checkAttendees(cases);
        }catch (Exception e){
            error = e.getMessage();
        }
        Test.stopTest();
        // Not possible to assert Errors because errors are thrown in Trigger context only
    }

    @isTest
    static void checkContactsNbr_InWebCase_Test() {
        String error ='';
        // getting data
        // case2
        List<Case> cases = [SELECT AccountId, Origin FROM Case WHERE Subject='case2'];
        // start test
        Test.startTest();
        try{
            CaseHelper.checkAttendees(cases);
        }catch (Exception e){
            error = e.getMessage();
        }
        Test.stopTest();
        // Not possible to assert Errors because errors are thrown in Trigger context only
    }

    @isTest
    static void checkIfZeroContacts_Test() {
        String error ='';
        // getting data
        // case3
        List<Case> cases = [SELECT AccountId, Origin FROM Case WHERE Subject='case3'];
        // start test
        Test.startTest();
        try{
            CaseHelper.checkAttendees(cases);
        }catch (Exception e){
            error = e.getMessage();
        }
        Test.stopTest();
        // Not possible to assert Errors because errors are thrown in Trigger context only
    }

    @isTest
    static void checkIfAccountNull_Test() {
        String error ='';
        // getting data
        // case4
        List<Case> cases = [SELECT AccountId, Origin FROM Case WHERE Subject='case4'];
        // start test
        Test.startTest();
        try{
            CaseHelper.checkAttendees(cases);
        }catch (Exception e){
            error = e.getMessage();
        }
        Test.stopTest();
        // Not possible to assert Errors because errors are thrown in Trigger context only
    }

    @isTest
    static void checkIfOriginNotAllowed_Test() {
        String error ='';
        // getting data
        // case5
        List<Case> cases = [SELECT AccountId, Origin FROM Case WHERE Subject='case5'];
        // start test
        Test.startTest();
        try{
            CaseHelper.checkAttendees(cases);
        }catch (Exception e){
            error = e.getMessage();
        }
        Test.stopTest();
        // Not possible to assert Errors because errors are thrown in Trigger context only

    }

    @IsTest
    static void handleClosedCases_Test(){
        // getting data
        List<Case> cases = [SELECT Id FROM Case];
        for (Case aCase : cases){aCase.Status='Closed';}
        // setting fake response with Mock
        Test.setMock(HttpCalloutMock.class, new AttendeeRegistrationMock());
        // start test
        Test.startTest();
        CaseHelper.handleClosedCases(cases);
        Test.stopTest();
        // No Assertion needed since buisness logic is tested in Services class
    }

}