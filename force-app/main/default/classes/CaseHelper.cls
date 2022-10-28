/**
 * @File               : CaseHelper
 * @Description        : Usefull methods for Case records
 * @Author             : Yassine RAZAQ (yrazaq@salesforce.com)
 * @Group              : 
 * @Last Modified On   : 25/10/2022
 * @Modification Log   :
 *======================================================================================
 * Ver         Date                           Author                  Modification
 *======================================================================================
 * 1.0      25/10/2022                   Yassine RAZAQ               Initial version
 **/

public with sharing class CaseHelper {

    /*******************************************************************************************************
    * @author: Yassine RAZAQ (yrazaq@salesforce.com)
    * @description: Checks if the case is related to an Account, and if the Account has a minimum
    * number of contacts depending on case Origin. The methods also blocks any case with Origin other
    * than Phone or Web.
    * @param cases: A list of concerned cases
    */
    public static void checkAttendees(List<Case> cases) {
        // avoinding NPE
        if (cases != null) {
            // storing accountIds to bulk fetching accounts
            List<Id> accountIds = new List<Id>();
            for (Case aCase : cases) {
                if (aCase.AccountId != null) {
                    accountIds.add(aCase.AccountId);
                } else {
                    // if a case has no accountId, an Error is thrown.
                    aCase.addError(System.Label.Case_AccountRequiredError);
                    break;
                }
            }

            // getting related accounts
            Map<Id, Account> accountsMap = new Map<Id, Account>([SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accountIds]);
            // looping threw cases to check for number of contacts based on case Origin.
            for (Case aCase : cases) {
                for (Id accountId : accountIds) {
                    // checking if we got the right account
                    if (aCase.AccountId == accountId) {
                        Integer contactsSize = 0;
                        // Getting Contacts size by loop instead of size() to avoid QueryException
                        for (Contact aContact : accountsMap.get(accountId).Contacts){
                            contactsSize++;
                        }
                        if (contactsSize == 0) {
                            // if contactSize is 0 an Error should be thrown.
                            aCase.addError(System.Label.Case_ContactsRequiredError);
                        } else {
                            System.debug('@yassine Origin '+aCase.Origin);
                            // throwing errors depending on case Origin
                            switch on aCase.Origin {
                                when 'Web' {
                                    if (contactsSize > 1) {
                                        aCase.addError(System.Label.Case_WebMaxLimitError);
                                    }
                                }
                                when 'Phone' {
                                    if (contactsSize > 3) {
                                        aCase.addError(System.Label.Case_PhoneMaxError);
                                    }
                                }
                                when else {
                                    aCase.addError(System.Label.Case_OriginNotAllowedError);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    /*******************************************************************************************************
    * @author: Yassine RAZAQ (yrazaq@salesforce.com)
    * @description: Handles actions to be done when cases are updated to 'closed'
    * @param cases: A list of concerned cases
    */
    public static void handleClosedCases(List<Case> cases){
        List<Case> closedCases = new List<Case>();
        for (Case aCase : cases){
            if (aCase.Status == 'Closed') {
                closedCases.add(aCase);
            }
        }
        if (!closedCases.isEmpty()) {
            List<Contact> contacts = new List<Contact>();
            // getting related contacts with one soql querry
            List<Account> relatedAccounts = [SELECT Id, (SELECT Name, Email FROM Contacts) FROM Account];
            for (Account acc : relatedAccounts){
                if (acc.Contacts.size()>0) {
                    for (Contact con: acc.Contacts){
                        contacts.add(con);
                    }
                }
            }
            // registring attendee for each contact
            for (Contact contact : contacts){
                ExternalSystemService.registerAttendee(contact.Name, contact.Email);
            }
        }
    }
}