@deprecated
global class MARSEmailServiceHandler implements Messaging.InboundEmailHandler
{
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope)
    {
        if (email.plainTextBody== 'start deleteoffterr')
        {
            // create the instance of office territory delete batch class
            MARSBatchDeleteOffTerr deleteOffTerr=new MARSBatchDeleteOffTerr();
            Id delOffTerr=Database.executeBatch(deleteOffTerr);
        }
        else if (email.plainTextBody== 'start deleteterritory')
        {
            // create the instance of territory delete batch class
            MARSBatchDeleteTerritory deleteTerritory=new MARSBatchDeleteTerritory();
            Id delTerr=Database.executeBatch(deleteTerritory);
        }

        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        return result;
    }
}