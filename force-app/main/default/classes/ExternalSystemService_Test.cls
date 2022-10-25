/**
 * @File               : ExternalSystemService_Test
 * @Description        : Test class for ExternalSystemServices methods
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
public class ExternalSystemService_Test {

    @testsetup
    static void testsetup() {
        insert TestDataFactory.contact();
    }

    @isTest
    static void registerAttendee_Test() {
        // getting data
        List<Contact> contacts = [SELECT Name, Email FROM Contact];
        // setting fake response with Mock
        Test.setMock(HttpCalloutMock.class, new AttendeeRegistrationMock());
        // start test
        Test.startTest();
        for(Contact contact : contacts){
            ExternalSystemService.registerAttendee(contact.Name, contact.Email);
        }
        Test.stopTest();
    }

    @isTest
    static void notifyAttendeeByEmail_Test() {
        // getting data
        List<Contact> contacts = [SELECT Name, Email FROM Contact];
        // setting fake response with Mock
        // start test
        Test.startTest();
        for(Contact contact : contacts){
            ExternalSystemService.notifyAttendeeByEmail(contact.Name, contact.Email);
        }
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        // Asserting
        // The number of email invocations should be equal to number of contacts.
        System.assertEquals(contacts.size(), invocations);
    }
}