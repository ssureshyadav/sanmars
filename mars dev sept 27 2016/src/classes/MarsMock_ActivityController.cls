@isTest
global with sharing class MarsMock_ActivityController implements webServiceMock{
    
    //Integer variable
    public static String methodNumber;
    
    //String to hold firm response
    public static String ticklerResponseString = '<MarsTicklerDataSet xmlns="http://tempuri.org/MarsTickler.xsd">'
                                                    +'<TICKLER>'
                                                        +'<ACTIVITY_ID>502001190</ACTIVITY_ID>'
                                                        +'<REP_ID>78556</REP_ID>'
                                                        +'<RECURRING_ID />'
                                                        +'<EXTERNAL_ID>00T90000034RZ3iEAG</EXTERNAL_ID>'
                                                    +'</TICKLER>'
                                                +'</MarsTicklerDataSet>';

    //String to hold office response
    public static String callResponseString = '<MarsCallDataSet xmlns="http://tempuri.org/MarsCall.xsd">'
                                                    +'<CALL>'
                                                        +'<ACTIVITY_ID>502001005</ACTIVITY_ID>'
                                                        +'<REP_ID>78556</REP_ID>'
                                                        +'<EXTERNAL_ID>00T90000034RZ3jEAG</EXTERNAL_ID>'
                                                    +'</CALL>'
                                                +'</MarsCallDataSet>';

    //String to hold rep response
    public static String emailResponseString =  '<MarsEmailDataSet xmlns="http://tempuri.org/MarsEmail.xsd">'
                                                +'<EMAIL>'
                                                +'<ACTIVITY_ID>581</ACTIVITY_ID>'
                                                +'<EXTERNAL_ID>00T90000034RZ6SEAW</EXTERNAL_ID>'
                                                +'</EMAIL>'
                                                +'</MarsEmailDataSet>';
                                                
    public static String meetingResponseString = '<MarsMeetingDataSet xmlns="http://tempuri.org/MarsMeeting.xsd">'
                                                +'<MEETING>'
                                                +'<ACTIVITY_ID>503000729</ACTIVITY_ID>'
                                                +'<EXTERNAL_ID>00U9000001BP8OqEAL</EXTERNAL_ID>'
                                                +'</MEETING>'
                                                +'</MarsMeetingDataSet>';

    global void doInvoke(
        
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,  
        String responseType) {
            
            //Check for flag value
            if(methodNumber == 'Email') {
                apiPhxaComMarsisActivitiesservice.UpsertEmailResponse_element response_x = new apiPhxaComMarsisActivitiesservice.UpsertEmailResponse_element();
                response_x.UpsertEmailResult = emailResponseString;                          
                response.put('response_x', response_x);
            } 
            
            if(methodNumber == 'GetEmailByActivityID') {
                apiPhxaComMarsisActivitiesservice.GetEmailByActivityIDResponse_element response_x = new apiPhxaComMarsisActivitiesservice.GetEmailByActivityIDResponse_element();
                response_x.GetEmailByActivityIDResult = emailResponseString;                          
                response.put('response_x', response_x);
            }
            
            if(methodNumber == 'Call') {
                apiPhxaComMarsisActivitiesservice.UpsertCallResponse_element response_x = new apiPhxaComMarsisActivitiesservice.UpsertCallResponse_element();
                response_x.UpsertCallResult= callResponseString;                          
                response.put('response_x', response_x);
            } 
            
            if(methodNumber == 'GetCallByActivityID') {
                apiPhxaComMarsisActivitiesservice.GetCallByActivityIDResponse_element response_x = new apiPhxaComMarsisActivitiesservice.GetCallByActivityIDResponse_element();
                response_x.GetCallByActivityIDResult = callResponseString;                          
                response.put('response_x', response_x);
            }
            
            if(methodNumber == 'Tickler') {
                apiPhxaComMarsisActivitiesservice.UpsertTicklerResponse_element response_x = new apiPhxaComMarsisActivitiesservice.UpsertTicklerResponse_element();
                response_x.UpsertTicklerResult = ticklerResponseString;                          
                response.put('response_x', response_x);
            } 
            
            if(methodNumber == 'GetTicklerByActivityID') {
                apiPhxaComMarsisActivitiesservice.GetTicklerByActivityIDResponse_element response_x = new apiPhxaComMarsisActivitiesservice.GetTicklerByActivityIDResponse_element();
                response_x.GetTicklerByActivityIDResult = ticklerResponseString;                          
                response.put('response_x', response_x);
            }   
            
            if(methodNumber == 'Meeting') {
                apiPhxaComMarsisActivitiesservice.UpsertMeetingResponse_element response_x = new apiPhxaComMarsisActivitiesservice.UpsertMeetingResponse_element();
                response_x.UpsertMeetingResult = meetingResponseString;                          
                response.put('response_x', response_x);
            } 
            
            if(methodNumber == 'FirmEvent') {
                apiPhxaComMarsisActivitiesservice.UpsertFirmEventResponse_element response_x = new apiPhxaComMarsisActivitiesservice.UpsertFirmEventResponse_element();
                response_x.UpsertFirmEventResult = ticklerResponseString;                          
                response.put('response_x', response_x);
            }   
            
            if(methodNumber == 'DeleteRecurrence') {
                apiPhxaComMarsisActivitiesservice.DeleteRecurrenceResponse_element response_x = new apiPhxaComMarsisActivitiesservice.DeleteRecurrenceResponse_element();
                response_x.DeleteRecurrenceResult= true;                          
                response.put('response_x', response_x);
            }            
            
            
                  
        }
}