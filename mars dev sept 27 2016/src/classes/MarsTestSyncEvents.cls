@isTest
private class MarsTestSyncEvents 
{
    
    private static TestMethod void createEvent()
    {   
        Account firm=MARSDataBundle.createFirm();
        Contact rep=MARSDataBundle.createRep(firm.Id);
        
        Event meeting=new Event(WhoId =rep.Id,Subject='Meeting',StartDateTime =DateTime.now(),EndDateTime=DateTime.now().addHours(1),
        EventSubtype='Event',DurationInMinutes =60,ActivityDate = System.today());
        
        //Validations Check
        meeting.MARSActivityType__c ='MT';
        try{insert meeting;}catch(Exception e){}
        
        meeting.MARSReccurenceId__c=1;
        try{insert meeting;}catch(Exception e){}

        meeting.MARSActivityId__c=1;
        try{insert meeting;}catch(Exception e){}
        
        //Tickler
        meeting.MARSActivityType__c =null;
        meeting.MARSReccurenceId__c=null;
        meeting.MARSActivityId__c=null;
        insert meeting;
        
        EventRelation er = new EventRelation(EventId = meeting.Id, 
            RelationId = rep.Id);
        insert er;
        
        String marsResponse ='<MarsMeetingDataSet xmlns="http://tempuri.org/MarsMeeting.xsd"><MEETING>  <ACTIVITY_ID>503001154</ACTIVITY_ID>  <RECURRING_ID>1234</RECURRING_ID></MEETING></MarsMeetingDataSet>';
        MarsActivityUtility.updateObjByMARSResponse(meeting,marsResponse,true,'Meeting');    
       
        MARSActivityUtility.BYPASS_ALL_TRIGGER=true;
        meeting.MarsActivityId__c=1;
        update meeting;
        MARSActivityUtility.BYPASS_ALL_TRIGGER=false;   
        
        meeting.MarsActivityId__c=3;
        try{update meeting;}catch(Exception e){}
        
        Event rMeeting=new Event(WhoId =rep.Id,Subject='Meeting',StartDateTime =DateTime.now(),EndDateTime=DateTime.now().addHours(1),
        EventSubtype='Event',DurationInMinutes =60,IsRecurrence = true,RecurrenceStartDateTime = System.today(),RecurrenceEndDateOnly = System.today()+2,
        RecurrenceType = 'RecursDaily',RecurrenceInterval = 1);

        insert rMeeting; 
        
        MARSActivityUtility.BYPASS_ALL_TRIGGER=true;
        rMeeting.MarsReccurenceId__c =1;
        update rMeeting;
        MARSActivityUtility.BYPASS_ALL_TRIGGER=false;        
        
        rMeeting.MARSReccurenceId__c=3;
        try{update meeting;}catch(Exception e){}
        
        //delete meeting;
        //delete rMeeting;
    }
    
    private static TestMethod void processBulkRecords()
    {
        Account firm=MARSDataBundle.createFirm();
        Contact rep=MARSDataBundle.createRep(firm.Id);
        Set<Id> eventSet=new Set<Id>();
        List<MARSActivityApexGateway.ACK> meetingResponse=MARSActivityApexGateway.SyncMeeting(MARSDataBundle.meetingXml(rep.Id,'1','',''));
        MARSActivityApexGateway.SyncMeeting(MARSDataBundle.meetingXml(rep.Id,'2','',''));
        
        //Recurrence Meeting
        List<MARSActivityApexGateway.ACK> meetingRecurResponse=MARSActivityApexGateway.SyncMeeting(MARSDataBundle.meetingRecurrenceXml(rep.Id,'1'));
        
        //Recurrence Child Meetings
        MARSActivityApexGateway.SyncMeeting(MARSDataBundle.meetingXml(rep.Id,'3',meetingRecurResponse[0].SFDCObjectId,'1'));
        
        if(meetingResponse[0].Result)
        {
            Event evt=[Select Id from Event where Id =: meetingResponse[0].SFDCObjectId];
            evt.MARSActivityType__c ='EV';
            try{
            update evt;
            }catch(Exception e){}
        }
        
        Event meeting=new Event(WhoId =rep.Id,Subject='Meeting',StartDateTime =DateTime.now(),EndDateTime=DateTime.now().addHours(1),
        EventSubtype='Event',DurationInMinutes =60,ActivityDate = System.today());
        insert meeting;
        
        //delete meeting;
        
        delete [Select Id from Event where WhoId = : rep.Id];
        
        Database.executeBatch(new MARSBatchActivityRetryBulkData());
    }
}