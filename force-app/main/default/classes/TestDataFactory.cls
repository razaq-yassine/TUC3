/**
 * @File               : TestDataFactory
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
public class TestDataFactory {

    @IsTest
    public static Account account(){
        Account record = new Account();
        record.Name = 'Account '+String.valueOf(Math.random() * 1000);
        return record;
    }
    @IsTest
    public static Contact contact(){
        Contact record = new Contact();
        record.LastName = 'Name '+String.valueOf(Math.random() * 1000);
        record.Email = 'email'+String.valueOf(Math.random() * 1000)+'@domain.com';
        return record;
    }

    @IsTest
    public static Case case(){
        Case record =  new Case();
        record.Status = 'New';
        record.Origin = 'Phone';
        return record;
    }
}