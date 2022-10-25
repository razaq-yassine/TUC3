public class ExternalSystemService {

    private final static String webServiceURL = 'https://th-apex-http-callout.herokuapp.com/animals';

    /*******************************************************************************************************
    * @author: Yassine RAZAQ (yrazaq@salesforce.com)
    * @description: Registers an atendee in an external System (callout)
    * @param contactName: The Name of attendee
    * @param email: The Email of attendee
    */
    @Future(Callout=true)
    public static void registerAttendee(String contactName, String email) {
        // setting request infos
        HttpRequest request = new HttpRequest();
        request.setEndpoint(webServiceURL);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        request.setBody('{"Name":"' + contactName + '-' + email + '"}');
        // setting http and httpResponse
        Http http = new Http();
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus() + ' ' + response.getBody());
        } else {
            // Everything went as expected.
            notifyAttendeeByEmail(contactName, email);
        }
    }

    /*******************************************************************************************************
    * @author: Yassine RAZAQ (yrazaq@salesforce.com)
    * @description: Notifies the attendee by email that his reuqest was accepted.
    * @param contactName: The Name of Attendee
    * @param email: The Email of Attendee
    */
    @TestVisible
    private static void notifyAttendeeByEmail(String contactName, String email) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { email };
        message.subject = 'Hello '+contactName+'. Your request is validated succefully';
        message.plainTextBody = 'Dear '+contactName+
                '.\nWe would like to inform you that you reservation request was accepted.' +
                '\nBest regards\n\nB.Hotels';
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (results[0].success)
        {
            System.debug('The email was sent successfully.');
        } else
        {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
}
