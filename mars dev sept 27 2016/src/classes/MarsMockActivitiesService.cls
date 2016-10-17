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
        
        MarsMock_ActivityController.methodNumber = 'GetEmailByActivityID';
        String getEmailByActivityIDresponse = service.GetEmailByActivityID('123');
        
        MarsMock_ActivityController.methodNumber = 'Call';
        String callresponse = service.UpsertCall('CallXml');
        
        MarsMock_ActivityController.methodNumber = 'GetCallByActivityID';
        String getCallByActivityIdresponse = service.GetCallByActivityID('123');
        
        MarsMock_ActivityController.methodNumber = 'Tickler';
        String ticklerresponse = service.UpsertTickler('TicklerXml');
        
        MarsMock_ActivityController.methodNumber = 'GetTicklerByActivityID';
        String getTicklerByActivityIDresponse = service.GetTicklerByActivityID('1');
        
        MarsMock_ActivityController.methodNumber = 'Meeting';
        String meetingresponse = service.UpsertMeeting('MeetingXml');
        
        MarsMock_ActivityController.methodNumber = 'FirmEvent';
        String firmEventresponse = service.UpsertFirmEvent('FirmEventXml');
        
        MarsMock_ActivityController.methodNumber = 'DeleteRecurrence';
        Boolean deleteRecurrenceresponse = service.DeleteRecurrence('12','FIRMEVENT');
    }
}