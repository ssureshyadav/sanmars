@isTest
public Class TestMARSBatchActivityRetryBulkData
{

    public static TestMethod void activitiesBulkRetry()
    {
        Account firm=MARSDataBundle.createFirm();
        Contact rep=MARSDataBundle.createRep(firm.Id);
        
        Event rMeeting=new Event(WhoId =rep.Id,Subject='Meeting',StartDateTime =DateTime.now(),EndDateTime=DateTime.now().addHours(1),
        EventSubtype='Event',DurationInMinutes =60,IsRecurrence = true,RecurrenceStartDateTime = System.today(),RecurrenceEndDateOnly = System.today()+2,
        RecurrenceType = 'RecursDaily',RecurrenceInterval = 1);
        insert rMeeting; 
        
        Task recurrenceCall=new Task(WhoId=rep.Id,Subject='Call',Status='In Progress',TaskSubtype='Call',
        IsRecurrence = true,RecurrenceStartDateOnly = System.today(),RecurrenceEndDateOnly = System.today()+2,RecurrenceType = 'RecursDaily',
        RecurrenceInterval = 1);
        insert recurrenceCall;

        
        
        MARSActivityUtility.BYPASS_ALL_TRIGGER=true;
        rMeeting.MarsReccurenceId__c =1;
        recurrenceCall.MarsReccurenceId__c =2;
        update rMeeting;
        update recurrenceCall;
        MARSActivityUtility.BYPASS_ALL_TRIGGER=false; 
        
        
        Database.ExecuteBatch(new MARSBatchActivityRetryBulkData());
    }
}