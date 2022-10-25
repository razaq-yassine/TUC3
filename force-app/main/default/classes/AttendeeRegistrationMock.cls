/**
 * @File               : AttendeeRegistrationMock
 * @Description        : Test class to provide a mock response
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
public class AttendeeRegistrationMock implements HttpCalloutMock{
    public HttpResponse respond(HttpRequest req) {
        // A fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status":"success"}');
        res.setStatusCode(201);
        return res;
    }
}