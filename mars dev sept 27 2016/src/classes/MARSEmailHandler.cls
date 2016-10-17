public class MARSEmailHandler
{
    public static void sendEmail(string body)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // email address of the salesforce email service
        String[] toAddresses = new String[] {'myhandler@x4m9vxsizy32oug74yh6rhj7e.in.salesforce.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Test Batch' );
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}