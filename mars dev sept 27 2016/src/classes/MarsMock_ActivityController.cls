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
                                                
    public static String firmEventResponseString ='<MarsFirmEventDataSet xmlns="http://tempuri.org/MarsFirmEvents.xsd">'
                                                    +'<FIRMEVENTS>'
                                                    +'<FIRMEVENT>'
                                                    +'<FIRM_ID>1</FIRM_ID>'
                                                    +'<EVENT_ID></EVENT_ID>'
                                                    +'<ACT_TYPE>MT</ACT_TYPE>'
                                                    +'</FIRMEVENT>'
                                                    +'</FIRMEVENTS>'
                                                    +'</MarsFirmEventDataSet>';
                                                    
    public static String repNotesResponseString ='<MarsRepNotesDataSet xmlns="http://tempuri.org/MarsRepNotes.xsd">'
                                                  +'<REPNOTES>'
                                                  +'<REP_ID>63403</REP_ID>'
                                                  +'<NOTE_ID>4857</NOTE_ID>'
                                                  +'<NOTE_DT>26-09-2014 18:05:03</NOTE_DT>'
                                                  +'<NOTE_BY>KMILLER </NOTE_BY>'
                                                  +'<REP_NOTE>Rep moved from Salesfocus Solutions Home Office, Salesfocus Solutions (25635) to SFS Branch 1, Salesfocus Solutions (25636)</REP_NOTE>'
                                                  +'<UPD_DT>26-09-2014 18:21:03</UPD_DT>'
                                                  +'<UPD_USR>KMILLER </UPD_USR>'
                                                  +'<SYSTEM_FLG>Y</SYSTEM_FLG>'
                                                  +'<EXTERNAL_REP_ID>0039000001rbZ69AAE</EXTERNAL_REP_ID>'
                                                  +'<EXTERNAL_ID />'
                                                  +'</REPNOTES>'
                                                +'</MarsRepNotesDataSet>';

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
            
            if(methodNumber == 'Meeting') {
                apiPhxaComMarsisActivitiesservice.UpsertMeetingResponse_element response_x = new apiPhxaComMarsisActivitiesservice.UpsertMeetingResponse_element();
                response_x.UpsertMeetingResult = meetingResponseString;                          
                response.put('response_x', response_x);
            } 
            
            if(methodNumber == 'GetMeetingByActivityID') {
                apiPhxaComMarsisActivitiesservice.GetMeetingByActivityIDResponse_element response_x = new apiPhxaComMarsisActivitiesservice.GetMeetingByActivityIDResponse_element();
                response_x.GetMeetingByActivityIDResult = meetingResponseString;                          
                response.put('response_x', response_x);
            }
            
            if(methodNumber == 'FirmEvent') {
                apiPhxaComMarsisActivitiesservice.UpsertFirmEventResponse_element response_x = new apiPhxaComMarsisActivitiesservice.UpsertFirmEventResponse_element();
                response_x.UpsertFirmEventResult = ticklerResponseString;                          
                response.put('response_x', response_x);
            } 
            
            if(methodNumber == 'GetFirmEventByActivityID') {
                apiPhxaComMarsisActivitiesservice.GetFirmEventByActivityIDResponse_element response_x = new apiPhxaComMarsisActivitiesservice.GetFirmEventByActivityIDResponse_element();
                response_x.GetFirmEventByActivityIDResult= firmEventResponseString;                          
                response.put('response_x', response_x);
            }
            
            if(methodNumber == 'GetRepNotesByID') {
                apiPhxaComMarsisActivitiesservice.GetRepNotesByIDResponse_element response_x = new apiPhxaComMarsisActivitiesservice.GetRepNotesByIDResponse_element();
                response_x.GetRepNotesByIDResult= repNotesResponseString ;                          
                response.put('response_x', response_x);
            }
            
            if(methodNumber == 'DeleteRecurrence') {
                apiPhxaComMarsisActivitiesservice.DeleteRecurrenceResponse_element response_x = new apiPhxaComMarsisActivitiesservice.DeleteRecurrenceResponse_element();
                response_x.DeleteRecurrenceResult= true;                          
                response.put('response_x', response_x);
            }    
            
            if(methodNumber == 'DeleteFirmEvent') {
                apiPhxaComMarsisActivitiesservice.DeleteFirmEventResponse_element response_x = new apiPhxaComMarsisActivitiesservice.DeleteFirmEventResponse_element();
                response_x.DeleteFirmEventResult= true;                          
                response.put('response_x', response_x);
            }     
            
            if(methodNumber == 'DeleteRepNotes') {
                apiPhxaComMarsisActivitiesservice.DeleteRepNotesResponse_element response_x = new apiPhxaComMarsisActivitiesservice.DeleteRepNotesResponse_element();
                response_x.DeleteRepNotesResult= true;                          
                response.put('response_x', response_x);
            }
            
            if(methodNumber == 'DeleteMeeting') {
                apiPhxaComMarsisActivitiesservice.DeleteMeetingResponse_element response_x = new apiPhxaComMarsisActivitiesservice.DeleteMeetingResponse_element();
                response_x.DeleteMeetingResult= true;                          
                response.put('response_x', response_x);
            }
            
            if(methodNumber == 'RepNotes') {
                apiPhxaComMarsisActivitiesservice.UpsertRepNotesResponse_element response_x = new apiPhxaComMarsisActivitiesservice.UpsertRepNotesResponse_element();
                response_x.UpsertRepNotesResult= true;                          
                response.put('response_x', response_x);
            }
            
            if(methodNumber == 'DeleteTickler') {
                apiPhxaComMarsisActivitiesservice.DeleteTicklerResponse_element response_x = new apiPhxaComMarsisActivitiesservice.DeleteTicklerResponse_element();
                response_x.DeleteTicklerResult= true;                          
                response.put('response_x', response_x);
            } 
            
            if(methodNumber == 'DeleteCall') {
                apiPhxaComMarsisActivitiesservice.DeleteCallResponse_element response_x = new apiPhxaComMarsisActivitiesservice.DeleteCallResponse_element();
                response_x.DeleteCallResult= true;                          
                response.put('response_x', response_x);
            } 
                  
        }
}