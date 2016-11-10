@isTest
private class MarsTestSyncTasks 
{
    
    private static TestMethod void createCall()
    {
        Account firm=MARSDataBundle.createFirm();
        Contact rep=MARSDataBundle.createRep(firm.Id);
        
        Task tickler=new Task(WhoId=rep.Id,Subject='Call',ActivityDate =System.today(),Status='In Progress',TaskSubtype='Call');
        tickler.MARSActivityType__c ='MT';
        
        //Validations Check
        try{
            insert tickler;
        }catch(Exception e){}
        tickler.MARSReccurenceId__c=1;
        try{
            insert tickler;
        }catch(Exception e){}
        tickler.MARSActivityId__c=1;
        try{
            insert tickler;
        }catch(Exception e){}
        
        //Tickler
        tickler.MARSActivityType__c =null;
        tickler.MARSReccurenceId__c=null;
        tickler.MARSActivityId__c=null;
        insert tickler;
        tickler.MarsActivityId__c=11;
        
        
        MARSActivityUtility.BYPASS_ALL_TRIGGER=true;
            update tickler;
        MARSActivityUtility.BYPASS_ALL_TRIGGER=false;
        
        //Validations Check
        try{
            tickler.MarsActivityId__c=15;
            update tickler;
        }catch(Exception e){}
                
        String marsResponse ='<MarsCallDataSet xmlns="http://tempuri.org/MarsCall.xsd"><CALL><ACTIVITY_ID>502001411</ACTIVITY_ID><RECURRING_ID /><ACT_TYPE /></CALL></MarsCallDataSet>';
        MarsActivityUtility.updateObjByMARSResponse(tickler,marsResponse,true,'CALL');    
        
        //Call
        Task Call=new Task(WhoId=rep.Id,Subject='Call',Status='Completed',TaskSubtype='Call');
        insert call;
        MARSActivityUtility.BYPASS_ALL_TRIGGER=true;
            call.MarsActivityId__c=11;
            update call;
        MARSActivityUtility.BYPASS_ALL_TRIGGER=false;        
        
        
        //Email
        Task email=new Task(WhoId=rep.Id,Subject='Email',Status='Completed',TaskSubtype='Email');
        insert email;
        MARSActivityUtility.BYPASS_ALL_TRIGGER=true;
            email.MarsActivityId__c=11;
            update email;
        MARSActivityUtility.BYPASS_ALL_TRIGGER=false;        
          
        String marsEmailResponse ='<MarsEmailDataSet xmlns="http://tempuri.org/MarsEmail.xsd"><EMAIL><ACTIVITY_ID>650</ACTIVITY_ID><EXTERNAL_ID>'+email.Id+'</EXTERNAL_ID></EMAIL></MarsEmailDataSet>';
        MarsActivityUtility.updateObjByMARSResponse(email,marsEmailResponse,true,'EMAIL');  
        
        
        //Recurrence
        Task recurrenceCall=new Task(WhoId=rep.Id,Subject='Call',Status='In Progress',TaskSubtype='Call',
        IsRecurrence = true,RecurrenceStartDateOnly = System.today(),RecurrenceEndDateOnly = System.today()+2,RecurrenceType = 'RecursDaily',
        RecurrenceInterval = 1);
        insert recurrenceCall;
        MARSActivityUtility.BYPASS_ALL_TRIGGER=true;
            recurrenceCall.MARSReccurenceId__c=11;
            update recurrenceCall;
        MARSActivityUtility.BYPASS_ALL_TRIGGER=false;   
        
        //Validations Check
        try{
            recurrenceCall.MARSReccurenceId__c=15;
            update recurrenceCall;
        }catch(Exception e){}
        
        //delete tickler;
        //delete call;
        //delete email;
        //delete recurrenceCall;
        
    }
    
    private static TestMethod void processBulkRecords()
    {
        Account firm=MARSDataBundle.createFirm();
        Contact rep=MARSDataBundle.createRep(firm.Id);
        List<MARSActivityApexGateway.ACK> callResponse=MARSActivityApexGateway.SyncCall(MARSDataBundle.ticklerXml(rep.Id,'1','',''));
        MARSActivityApexGateway.SyncCall(MARSDataBundle.ticklerXml(rep.Id,'2','',''));
        
        //Recurrence Meeting
        List<MARSActivityApexGateway.ACK> meetingRecurResponse=MARSActivityApexGateway.SyncCall(MARSDataBundle.ticklerRecurrenceXml(rep.Id,'1'));
        
        //Recurrence Child Meetings
        MARSActivityApexGateway.SyncCall(MARSDataBundle.ticklerXml(rep.Id,'3',meetingRecurResponse[0].SFDCObjectId,'1'));
        
        if(callResponse[0].Result)
        {
            Task tsk=[Select Id from Task where Id =: callResponse[0].SFDCObjectId];
            tsk.MARSActivityType__c ='PP';
            try{
            update tsk;
            }catch(Exception e){}
        }
        
        Task tickler=new Task(WhoId=rep.Id,Subject='Call',ActivityDate =System.today(),Status='In Progress',TaskSubtype='Call');
        //tickler.MARSActivityType__c ='MT';
        insert tickler;
        
        
        delete [Select Id from Task where WhoId = : rep.Id];
        
        Database.executeBatch(new MARSBatchActivityRetryBulkData());
    }
}