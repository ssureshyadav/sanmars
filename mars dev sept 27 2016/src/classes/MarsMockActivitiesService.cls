@isTest
private class MarsMockActivitiesService
{
    private static testmethod void activitiesServiceTest()
    {
        apiPhxaComMarsisActivitiesservice.ActivitiesServiceSoap service = MarsActivityUtility.populatedAuthServiceForActivities();

        //Set Mock Callout class 
        Test.setMock(WebServiceMock.class, new MarsMock_ActivityController());
        
        MarsMock_ActivityController.methodNumber = 'Email';
        String emailresponse = service.UpsertEmail('EmailXml');
        
        MarsMock_ActivityController.methodNumber = 'GetCallByActivityID';
        String getCallByActivityIdresponse = service.GetCallByActivityID('123',null,false);
        
        MarsMock_ActivityController.methodNumber = 'Call';
        String callresponse = service.UpsertCall('CallXml');
        
        MarsMock_ActivityController.methodNumber = 'GetRepNotesByID';
        String GetRepNotesByIDresponse= service.GetRepNotesByID('1234');
        
        MarsMock_ActivityController.methodNumber = 'GetFirmEventByActivityID';
        String GetFirmEventByActivityIDresponse = service.GetFirmEventByActivityID('1234',null);
        
        MarsMock_ActivityController.methodNumber = 'RepNotes';
        Boolean UpsertRepNotesresponse = service.UpsertRepNotes('UpsertRepNotesXml');
        
        MarsMock_ActivityController.methodNumber = 'DeleteTickler';
        Boolean DeleteTicklerresponse = service.DeleteTickler('1');
        
        MarsMock_ActivityController.methodNumber = 'DeleteCall';
        Boolean DeleteCallresponse = service.DeleteCall('1');
        
        MarsMock_ActivityController.methodNumber = 'Meeting';
        String meetingresponse = service.UpsertMeeting('MeetingXml');
        
        MarsMock_ActivityController.methodNumber = 'GetMeetingByActivityID';
        String GetMeetingByActivityIDresponse = service.GetMeetingByActivityID('1',null);
        
        MarsMock_ActivityController.methodNumber = 'FirmEvent';
        String firmEventresponse = service.UpsertFirmEvent('FirmEventXml');
        
        MarsMock_ActivityController.methodNumber = 'DeleteMeeting';
        Boolean DeleteMeetingresponse = service.DeleteMeeting('1');
        
        MarsMock_ActivityController.methodNumber = 'DeleteRecurrence';
        Boolean DeleteRecurrenceresponse = service.DeleteRecurrence('1');
        
        MarsMock_ActivityController.methodNumber = 'GetEmailByActivityID';
        String getEmailByActivityIDresponse = service.GetEmailByActivityID('123');
        
        MarsMock_ActivityController.methodNumber = 'DeleteFirmEvent';
        Boolean DeleteFirmEventresponse = service.DeleteFirmEvent('123');
        
        MarsMock_ActivityController.methodNumber = 'DeleteRepNotes';
        Boolean DeleteRepNotesresponse = service.DeleteRepNotes('123');
        
    }
}