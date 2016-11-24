public class MARSActivitySyncMessageParser
{
    public static Map<String, List<Sobject>> parseMeeting(String meetingXML)
    {
        Map<String, List<Sobject>> mapMeeting = new Map<String, List<Sobject>>();
        List<Event> lstParseSuccess=new List<Event>();
        List<EventRelation> lstParseEvtRelationSuccess=new List<EventRelation>();
        List<Event> lstParseFailed=new List<Event>();
        Event Meeting;
        EventRelation eventRelation;
        try{
            
            Dom.document doc = new Dom.document();
            doc.load(meetingXML);
            
            Dom.XMLNode root = doc.getRootElement().getChildElement('MEETING', 'http://tempuri.org/MarsMeeting.xsd');
            if(root !=NULL)
            {        
                for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
                {
                    Meeting=new Event();
                    try{          
                        Meeting.MARSActivitytype__c ='MT';
                            
                        Dom.XMLNode externalId = elementsList.getChildElement('EXTERNAL_REP_ID', 'http://tempuri.org/MarsMeeting.xsd');
                        Meeting.whoId =parseNull(externalId.getText());
                        
                        Dom.XMLNode recurrence = elementsList.getChildElement('RECURRING_ID', 'http://tempuri.org/MarsMeeting.xsd'); 
                        Meeting.MarsReccurenceId__c =parseDecimal(recurrence.getText());
                        
                        Dom.XMLNode meetingType= elementsList.getChildElement('MTG_TYPE', 'http://tempuri.org/MarsMeeting.xsd'); 
                        Meeting.MarsMeetingType__c=parseNull(meetingType.getText());
                        
                        Dom.XMLNode meetingDesc= elementsList.getChildElement('MTG_DESC', 'http://tempuri.org/MarsMeeting.xsd'); 
                        Meeting.Subject =parseNull(meetingDesc.getText());
                        
                        Dom.XMLNode owner= elementsList.getChildElement('ORG_USRID', 'http://tempuri.org/MarsMeeting.xsd'); 
                        Meeting.OwnerId =parseNull(owner.getText());
                        
                        Dom.XMLNode noteText= elementsList.getChildElement('NOTE_TEXT', 'http://tempuri.org/MarsMeeting.xsd'); 
                        Meeting.Description=parseNull(noteText.getText());
                        
                       /* Dom.XMLNode meetingAddr1= elementsList.getChildElement('MTG_ADDR1', 'http://tempuri.org/MarsMeeting.xsd'); 
                        Dom.XMLNode meetingAddr2= elementsList.getChildElement('MTG_ADDR2', 'http://tempuri.org/MarsMeeting.xsd'); 
                        Dom.XMLNode meetingCity= elementsList.getChildElement('MTG_CITY', 'http://tempuri.org/MarsMeeting.xsd'); 
                        Dom.XMLNode meetingState= elementsList.getChildElement('STATE_ID', 'http://tempuri.org/MarsMeeting.xsd'); 
                        Dom.XMLNode meetingZip= elementsList.getChildElement('MTG_ZIP', 'http://tempuri.org/MarsMeeting.xsd'); 
                        Dom.XMLNode meetingcountry= elementsList.getChildElement('COUNTRY_CD', 'http://tempuri.org/MarsMeeting.xsd'); 
                        
                        Meeting.Location=parseNull(meetingAddr1.getText().trim()) +' '
                                           +parseNull(meetingAddr2.getText().trim())+' '
                                           +parseNull(meetingCity.getText().trim())+' '
                                           +parseNull(meetingState.getText().trim())+' '
                                           +parseNull(meetingcountry.getText().trim())+' '
                                           +parseNull(meetingZip.getText().trim());*/
                        
                        Dom.XMLNode recurrenceflag = elementsList.getChildElement('RECURRENCE_FLG', 'http://tempuri.org/MarsMeeting.xsd'); 
                        if(parsenull(recurrenceflag.getText()) =='Y')
                        {   
                            if(recurrence.getText() == '')throw new MarsException('Recurrence id cannot be null');
                            Meeting.IsRecurrence =true;

                            Dom.XMLNode startTime = elementsList.getChildElement('START_TIME', 'http://tempuri.org/MarsMeeting.xsd'); 
                            Meeting.RecurrenceStartDateTime =parseDateTime(startTime.getText());
                            Meeting.ActivityDate =parseDateTime(startTime.getText()).Date();
                            
                            Dom.XMLNode externalRecurrenceId = elementsList.getChildElement('RECURRENCE_EXTERNAL_ID', 'http://tempuri.org/MarsMeeting.xsd');
                            if(externalRecurrenceId.getText().length()>0)
                            {
                                Meeting.Id =parseNull(externalRecurrenceId.getText());
                            }
                            
                            Dom.XMLNode recurrenceType = elementsList.getChildElement('RECURRENCE_TYPE', 'http://tempuri.org/MarsMeeting.xsd'); 
                            Meeting.RecurrenceType =parseNull(recurrenceType.getText());
                            
                            System.debug(Meeting.RecurrenceType);
                            
                            if(!(Meeting.RecurrenceType =='RecursYearly' 
                            || Meeting.RecurrenceType =='RecursYearlyNth' 
                            || Meeting.RecurrenceType == 'RecursEveryWeekday'))
                            {
                                Dom.XMLNode interval = elementsList.getChildElement('INTERVAL', 'http://tempuri.org/MarsMeeting.xsd'); 
                                Meeting.RecurrenceInterval =Integer.valueOf(interval.getText());
                            }else{
                                Meeting.RecurrenceInterval =null;
                            }
                            
                            if(Meeting.RecurrenceType == 'RecursMonthlyNth' || Meeting.RecurrenceType =='RecursYearlyNth')
                            {
                                Dom.XMLNode instance = elementsList.getChildElement('INSTANCE', 'http://tempuri.org/MarsMeeting.xsd'); 
                                Meeting.RecurrenceInstance =parseNull(instance.getText());
                            }else{
                                Meeting.RecurrenceInstance =null;
                            }
                            
                            if(Meeting.RecurrenceType =='RecursWeekly' 
                            || Meeting.RecurrenceType =='RecursMonthlyNth' 
                            || Meeting.RecurrenceType =='RecursYearlyNth' 
                            || Meeting.RecurrenceType == 'RecursEveryWeekday')
                            {
                                Dom.XMLNode dayOfWeekMask = elementsList.getChildElement('DAY_OF_WEEK_MASK', 'http://tempuri.org/MarsMeeting.xsd'); 
                                Meeting.RecurrenceDayOfWeekMask =Integer.valueOf(dayOfWeekMask.getText());
                            }else{
                                Meeting.RecurrenceDayOfWeekMask =null;
                            }
                            
                            if(Meeting.RecurrenceType =='RecursMonthly' 
                            || Meeting.RecurrenceType =='RecursYearly')
                            {
                                Dom.XMLNode dayOfMonth = elementsList.getChildElement('DAY_OF_MONTH', 'http://tempuri.org/MarsMeeting.xsd'); 
                                Meeting.RecurrenceDayOfMonth=dayOfMonth.getText() == '0'?null:Integer.valueOf(dayOfMonth.getText());
                            }else{
                                Meeting.RecurrenceDayOfMonth =null;
                            }
                            
                            if(Meeting.RecurrenceType =='RecursYearlyNth' 
                            || Meeting.RecurrenceType =='RecursYearly')
                            {
                                Dom.XMLNode monthOfYear = elementsList.getChildElement('MONTH_OF_YEAR', 'http://tempuri.org/MarsMeeting.xsd'); 
                                Meeting.RecurrenceMonthOfYear=monthOfYear.getText();
                                //FirmEvent.RecurrenceMonthOfYear ='January';
                            }else{
                                Meeting.RecurrenceMonthOfYear=null;
                            }
                            
                            Dom.XMLNode endTime = elementsList.getChildElement('END_TIME', 'http://tempuri.org/MarsMeeting.xsd'); 
                            Meeting.RecurrenceEndDateOnly =parseDateTime(endTime.getText()).Date();
                            
                            meeting.DurationInMinutes = Math.Mod(Integer.valueOf((parseDateTime(endTime.getText()).getTime() - parseDateTime(startTime.getText()).getTime()) / (60 * 1000)), 60);
                            System.debug(parseDateTime(endTime.getText()).minute());
                            System.debug(parseDateTime(startTime.getText()).minute());
                            System.debug(meeting.DurationInMinutes);
                            
                        }else
                        {
                            Dom.XMLNode marsMeetingid = elementsList.getChildElement('ACTIVITY_ID', 'http://tempuri.org/MarsMeeting.xsd');
                            if(parseNull(marsMeetingid.getText()) == '')throw new MarsException('Activity id cannot be null');
                            Meeting.MarsActivityId__c=parseDecimal(marsMeetingid.getText());
                            
                            Dom.XMLNode externalMeetingId = elementsList.getChildElement('SFDC_EXTERNAL_ID', 'http://tempuri.org/MarsMeeting.xsd');
                            if(externalMeetingId.getText().length()>0)
                            {
                                Meeting.Id =parseNull(externalMeetingId.getText());
                            }
                            
                            Dom.XMLNode startDate = elementsList.getChildElement('BEG_DT', 'http://tempuri.org/MarsMeeting.xsd'); 
                            Meeting.StartDateTime =parseDateTime(startDate.getText());
                            //Meeting.StartDateTime =System.today();
                            
                            Dom.XMLNode endDate = elementsList.getChildElement('END_DT', 'http://tempuri.org/MarsMeeting.xsd'); 
                            Meeting.EndDateTime = parseDateTime(endDate.getText());
                            
                           /* Dom.XMLNode reminder = elementsList.getChildElement('ALARM_ON', 'http://tempuri.org/MarsMeeting.xsd'); 
                            Meeting.IsReminderSet =parseNull(reminder.getText())=='Y'?true:false;*/
                            
                            if(Meeting.MarsReccurenceId__c != null)
                            {
                                if(Meeting.Id == null)
                                {
                                    Dom.XMLNode recurrenceSFDCId = elementsList.getChildElement('RECURRENCE_EXTERNAL_ID', 'http://tempuri.org/MarsMeeting.xsd'); 
                                    //Meeting.RecurrenceActivityId = parseNull(recurrenceSFDCId.getText());
                                    MARSActivityUtility.setRecurrenceId.add(recurrenceSFDCId.getText());
                                }
                            }
                            
                            
                            
                            for(dom.XmlNode childs:elementsList.getChildren())
                            {
                                eventRelation =new EventRelation();
                                if(childs.getName() == 'REPACTIVITY' )
                                {
                                    Dom.XMLNode marsRepexternalId = childs.getChildElement('EXTERNAL_ID', 'http://tempuri.org/MarsMeeting.xsd');    
                                    System.debug(marsRepexternalId.getText());
                                    eventRelation.RelationId =marsRepexternalId.getText();
                                    //eventRelation.IsInvitee =true;
                                    eventRelation.Status =marsMeetingid.getText();
                                    lstParseEvtRelationSuccess.add(eventRelation);
                                }
                                
                                if(childs.getName() == 'USERACTIVITY')
                                {
                                    Dom.XMLNode marsUserExternalId = childs.getChildElement('SFDC_USR_ID', 'http://tempuri.org/MarsMeeting.xsd');   
                                    System.debug(marsUserExternalId.getText());
                                    eventRelation.RelationId =marsUserExternalId.getText();
                                    //eventRelation.IsInvitee =true;
                                    eventRelation.Status =marsMeetingid.getText();
                                    lstParseEvtRelationSuccess.add(eventRelation);
                                }
                            }
                        }
                        lstParseSuccess.add(Meeting);
                    }
                    catch(exception e){
                        Dom.XMLNode MeetingId = elementsList.getChildElement('ACTIVITY_ID', 'http://tempuri.org/MarsMeeting.xsd'); 
                        Dom.XMLNode recurrence = elementsList.getChildElement('RECURRING_ID', 'http://tempuri.org/MarsMeeting.xsd'); 
                        if(MeetingId.getText() != null)
                        {
                            Meeting.MarsActivityId__c =parseDecimal(MeetingId.getText());
                        }else{
                            Meeting.MARSReccurenceId__c =parseDecimal(recurrence.getText());
                        }
                        Meeting.Description=e.getMessage()+e.getStackTraceString();
                        lstParseFailed.add(Meeting);
                    }
                } 

                mapMeeting.put('Success',lstParseSuccess);
                mapMeeting.put('SuccessEventRelation',lstParseEvtRelationSuccess);   
                mapMeeting.put('Errors', lstParseFailed);
            }
        }
        catch(Exception e){
            System.debug('\n MeetingXML:'+MeetingXML);
            System.debug(e.getMessage()+'-'+e.getStackTraceSTring());
        }
        return mapMeeting;
    }
    
    public static Map<String, List<Task>> parseCall(String CallXML)
    {
        Map<String, List<Task>> mapCall = new Map<String, List<Task>>();
        List<Task> lstParseSuccess=new List<Task>();
        List<Task> lstParseFailed=new List<Task>();
        Task call;
        try{
            
            Dom.document doc = new Dom.document();
            doc.load(CallXML);
            Dom.XMLNode root = doc.getRootElement().getChildElement('CALL', 'http://tempuri.org/MarsCall.xsd');
            if(root !=NULL)
            { 
                for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
                {
                    call=new Task();
                    try{          
                        call.TaskSubType ='Call';
                        
                        
                        Dom.XMLNode repId = elementsList.getChildElement('EXTERNAL_REP_ID', 'http://tempuri.org/MarsCall.xsd');
                        if(repId.getText().length()>0)
                        {
                            call.whoId =parseNull(repId.getText());
                        }
                        
                        Dom.XMLNode externalcallId = elementsList.getChildElement('EXTERNAL_ID', 'http://tempuri.org/MarsCall.xsd');
                        if(externalcallId.getText().length()>0)
                        {
                            call.Id =parseNull(externalcallId.getText());
                        }
                        
                        Dom.XMLNode ownerId = elementsList.getChildElement('USR_ID', 'http://tempuri.org/MarsCall.xsd');
                        if(ownerId.getText().length()>0)
                        {
                            call.OwnerId =parseNull(ownerId.getText());
                        }
                        
                        Dom.XMLNode marsactivityType = elementsList.getChildElement('ACT_TYPE', 'http://tempuri.org/MarsCall.xsd');
                        Call.MARSActivitytype__c =marsactivityType.getText();
                        if(call.MARSActivitytype__c == 'CL')
                        {
                        
                            call.MARSActivitytype__c =marsactivityType.getText();
                            call.Status='Completed';
                            Dom.XMLNode marscallid = elementsList.getChildElement('ACTIVITY_ID', 'http://tempuri.org/MarsCall.xsd');
                            if(parseNull(marscallid.getText()) == '')throw new MarsException('call id cannot be null');
                            call.MarsActivityId__c=parseDecimal(marscallid.getText());
                            
                            Dom.XMLNode description = elementsList.getChildElement('NOTES', 'http://tempuri.org/MarsCall.xsd'); 
                            call.Description =parseNull(description.getText());
                            
                            string logcall='';
                            for(dom.XmlNode childs:elementsList.getChildren())
                            {
                                if(childs.getName() == 'LOGCALL' )
                                {
                                   Dom.XMLNode calltypes = childs.getChildElement('CALL_TYPE', 'http://tempuri.org/MarsCall.xsd');    
                                   logcall += parseNull(calltypes.getText()) + ';';
                                }
                            }
                            
                            if(logcall != null)
                            {
                                call.MarsLogCall__c =logcall.removeEnd(';');
                            }
                        }else 
                        {
                            call.MARSActivitytype__c = 'TK';
                            
                            Dom.XMLNode callType = elementsList.getChildElement('CALL_TYPE', 'http://tempuri.org/MarsCall.xsd'); 
                            call.MarsCallType__c =parseNull(callType.getText());
                            
                            
                            Dom.XMLNode callPriority = elementsList.getChildElement('CALL_PRIORITY', 'http://tempuri.org/MarsCall.xsd'); 
                            call.Priority =parseNull(callPriority.getText());
                            
                            Dom.XMLNode noteText= elementsList.getChildElement('NOTE_TEXT', 'http://tempuri.org/MarsCall.xsd'); 
                            call.Description=parseNull(noteText.getText());
                            
                            
                            Dom.XMLNode recurrence = elementsList.getChildElement('RECURRING_ID', 'http://tempuri.org/MarsCall.xsd'); 
                            call.MarsReccurenceId__c =parseDecimal(recurrence.getText());
                            
                            
                            Dom.XMLNode recurrenceflag = elementsList.getChildElement('RECURRENCE_FLG', 'http://tempuri.org/MarsCall.xsd'); 
                            if(parsenull(recurrenceflag.getText()) =='Y')
                            {   
                                if(recurrence.getText() == '')throw new MarsException('Recurrence id cannot be null');
                                call.IsRecurrence =true;
    
                                Dom.XMLNode startTime = elementsList.getChildElement('START_TIME', 'http://tempuri.org/MarsCall.xsd'); 
                                call.RecurrenceStartDateOnly =parseDateTime(startTime.getText()).Date();
                                //taskRecurrence.RecurrenceStartDateOnly =System.today();
                                
                                Dom.XMLNode marsRecurrenceid = elementsList.getChildElement('RECURRING_ID', 'http://tempuri.org/MarsCall.xsd');
                                if(parseNull(marsRecurrenceid.getText()) == '')throw new MarsException('Recurrence id cannot be null');
                                call.MarsReccurenceId__c=parseDecimal(marsRecurrenceid.getText());
                                
                                
                                Dom.XMLNode externalRecurrenceId = elementsList.getChildElement('RECURRENCE_EXTERNAL_ID', 'http://tempuri.org/MarsCall.xsd');
                                if(externalRecurrenceId.getText().length()>0)
                                {
                                    call.Id =parseNull(externalRecurrenceId.getText());
                                }
                                
                                Dom.XMLNode recurrenceType = elementsList.getChildElement('RECURRENCE_TYPE', 'http://tempuri.org/MarsCall.xsd'); 
                                call.RecurrenceType =parseNull(recurrenceType.getText());
                                
                                if(!(call.RecurrenceType =='RecursYearly' 
                                || call.RecurrenceType =='RecursYearlyNth' 
                                || call.RecurrenceType == 'RecursEveryWeekday'))
                                {
                                    Dom.XMLNode interval = elementsList.getChildElement('INTERVAL', 'http://tempuri.org/MarsCall.xsd'); 
                                    call.RecurrenceInterval =Integer.valueOf(interval.getText());
                                }else
                                {
                                    call.RecurrenceInterval =null;
                                }
                                
                                if(call.RecurrenceType == 'RecursMonthlyNth' || Call.RecurrenceType =='RecursYearlyNth')
                                {
                                    Dom.XMLNode instance = elementsList.getChildElement('INSTANCE', 'http://tempuri.org/MarsCall.xsd'); 
                                    call.RecurrenceInstance =parseNull(instance.getText());
                                }else{
                                    call.RecurrenceInstance =null;
                                }
                                
                                if(call.RecurrenceType =='RecursWeekly' 
                                || call.RecurrenceType =='RecursMonthlyNth' 
                                || call.RecurrenceType =='RecursYearlyNth' 
                                || call.RecurrenceType == 'RecursEveryWeekday')
                                {
                                    Dom.XMLNode dayOfWeekMask = elementsList.getChildElement('DAY_OF_WEEK_MASK', 'http://tempuri.org/MarsCall.xsd'); 
                                    call.RecurrenceDayOfWeekMask =dayOfWeekMask.getText() == '0'?null:Integer.valueOf(dayOfWeekMask.getText());
                                }else{
                                    call.RecurrenceDayOfWeekMask =null;
                                }
     
                                if(call.RecurrenceType =='RecursMonthly' 
                                || call.RecurrenceType =='RecursYearly')
                                {
                                    Dom.XMLNode dayOfMonth = elementsList.getChildElement('DAY_OF_MONTH', 'http://tempuri.org/MarsCall.xsd'); 
                                    call.RecurrenceDayOfMonth=dayOfMonth.getText() == '0'?null:Integer.valueOf(dayOfMonth.getText());
                                }else{
                                    call.RecurrenceDayOfMonth=null;
                                }
                                
                                if(call.RecurrenceType =='RecursYearlyNth' 
                                || call.RecurrenceType =='RecursYearly')
                                {
                                    Dom.XMLNode monthOfYear = elementsList.getChildElement('MONTH_OF_YEAR', 'http://tempuri.org/MarsCall.xsd'); 
                                    call.RecurrenceMonthOfYear=monthOfYear.getText();
                                    //eventRecurrence.RecurrenceMonthOfYear ='January';
                                }else{
                                    call.RecurrenceMonthOfYear=null;
                                }
                                
                                Dom.XMLNode endTime = elementsList.getChildElement('END_TIME', 'http://tempuri.org/MarsCall.xsd'); 
                                call.RecurrenceEndDateOnly =parseDateTime(endTime.getText()).Date();
                                
                            }else
                            {
                                Dom.XMLNode marsCallid = elementsList.getChildElement('ACTIVITY_ID', 'http://tempuri.org/MarsCall.xsd');
                                if(parseNull(marsCallid.getText()) == '')throw new MarsException('Activity id cannot be null');
                                call.MarsActivityId__c=parseDecimal(marsCallid.getText());
                                
                                Dom.XMLNode activityDate = elementsList.getChildElement('BEG_DT', 'http://tempuri.org/MarsCall.xsd'); 
                                call.ActivityDate =parseDateTime(activityDate.getText()).Date();
                                
                                /*Dom.XMLNode reminder = elementsList.getChildElement('ALARM_ON', 'http://tempuri.org/MarsCall.xsd'); 
                                call.IsReminderSet =parseNull(reminder.getText())=='Y'?true:false;*/
                                
                                if(call.MarsReccurenceId__c != null)
                                {
                                    if(call.Id == null)
                                    {
                                        Dom.XMLNode recurrenceSFDCId = elementsList.getChildElement('RECURRENCE_EXTERNAL_ID', 'http://tempuri.org/MarsCall.xsd'); 
                                        //Call.RecurrenceActivityId = parseNull(recurrenceSFDCId.getText());
                                        MARSActivityUtility.setRecurrenceId.add(recurrenceSFDCId.getText());
                                    }
                                }
                            }
                        }
                        System.debug(call.Id);
                        if(call.Id == null){
                            call.Subject ='Call';    
                        }
                        lstParseSuccess.add(call);
                    }
                    catch(exception e){
                        Dom.XMLNode CallId = elementsList.getChildElement('ACTIVITY_ID', 'http://tempuri.org/MarsCall.xsd'); 
                        Dom.XMLNode recurrence = elementsList.getChildElement('RECURRING_ID', 'http://tempuri.org/MarsCall.xsd'); 
                        if(CallId.getText() != null)
                        {
                            Call.MarsActivityId__c =parseDecimal(CallId.getText());
                        }else{
                            Call.MARSReccurenceId__c =parseDecimal(recurrence.getText());
                        }
                        Call.Description=e.getMessage()+e.getStackTraceString();
                        lstParseFailed.add(Call);
                    }
                } 
                mapCall.put('Success',lstParseSuccess);   
                mapCall.put('Errors', lstParseFailed);
            }
        }
        catch(Exception e){
            System.debug('\n CallXML:'+CallXML);
            System.debug(e.getMessage()+'-'+e.getStackTraceSTring());
        }
        return mapCall;
    }
    
    public static Map<String, List<Sobject>> parseEmail(String EmailXML)
    {
        Map<String, List<Sobject>> mapEmail = new Map<String, List<Sobject>>();
        List<Task> lstParseTaskSuccess=new List<Task>();
        List<Task> lstParseTaskFailed=new List<Task>();
        List<EmailMessage> lstParseMessageSuccess=new List<EmailMessage>();
        Task email;
        EmailMessage message=new EmailMessage();
        try{
            
            Dom.document doc = new Dom.document();
            doc.load(EmailXML);
            
            Dom.XMLNode root = doc.getRootElement().getChildElement('EMAIL', 'http://tempuri.org/MarsEmail.xsd');
            Dom.XMLNode repActivityEmail = doc.getRootElement().getChildElement('REP_ACTIVITY_EMAIL', 'http://tempuri.org/MarsEmail.xsd');
            if(root !=NULL)
            {        
                for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
                {
                    email=new Task();
                    try{          
                        if(root.getName() == 'EMAIL')
                        {
                            Dom.XMLNode marsEmailid = elementsList.getChildElement('ACTIVITY_ID', 'http://tempuri.org/MarsEmail.xsd');
                            if(parseNull(marsEmailid.getText()) == '')throw new MarsException('Activity id cannot be null');
                            email.MarsActivityId__c=parseDecimal(marsEmailid.getText());
                            
                            Dom.XMLNode marsRepActivity = elementsList.getChildElement('REP_ACTIVITY_EMAIL', 'http://tempuri.org/MarsEmail.xsd');
                            Dom.XMLNode externalId = marsRepActivity .getChildElement('EXTERNAL_ID', 'http://tempuri.org/MarsEmail.xsd');
                            email.whoId =parseNull(externalId.getText());
                            
                            Dom.XMLNode emailAddress = marsRepActivity .getChildElement('EMAIL_ADDR', 'http://tempuri.org/MarsEmail.xsd');
                            message.ToAddress=parseNull(emailAddress.getText());
                            
                            
                            Dom.XMLNode cc = elementsList.getChildElement('CC', 'http://tempuri.org/MarsEmail.xsd');
                            message.CcAddress=parseNull(cc.getText());
                            
                            
                            Dom.XMLNode subject= elementsList.getChildElement('SUBJECT', 'http://tempuri.org/MarsEmail.xsd');
                            message.Subject=parseNull(subject.getText());
                            email.Subject =message.Subject;
                            
                            Dom.XMLNode emailBody= elementsList.getChildElement('EMAIL_BODY', 'http://tempuri.org/MarsEmail.xsd');
                            message.TextBody=parseNull(emailBody.getText());
                            
                            Dom.XMLNode emailStatus= elementsList.getChildElement('EMAIL_STAT', 'http://tempuri.org/MarsEmail.xsd');
                            message.Status='3';
                            
                            Dom.XMLNode messageDate= elementsList.getChildElement('SENT_DT', 'http://tempuri.org/MarsEmail.xsd');
                            message.MessageDate=DateTime.now();
                            
                            message.FromAddress =UserInfo.getUserEmail();
                            message.Incoming =true;
                            
                            email.TaskSubType ='Email';
                            email.MARSActivitytype__c ='EM';
                            email.Description = 'To: '+ message.ToAddress + ' CC: ' + message.CcAddress + ' BCC: '+ 'Attachment: --none-- Subject: ' + message.Subject +' Body: '+message.TextBody;
                            lstParseMessageSuccess.add(message);
                            lstParseTaskSuccess.add(Email);
                        }
                        
                    }
                    catch(exception e){
                        Dom.XMLNode EmailId = elementsList.getChildElement('ACTIVITY_ID', 'http://tempuri.org/MarsEmail.xsd'); 
                        Email.MarsActivityId__c =parseDecimal(EmailId.getText());
                        Email.Description=e.getMessage()+e.getStackTraceString();
                        lstParseTaskFailed.add(Email);
                    }
                } 
                mapEmail.put('Success',lstParseTaskSuccess);   
                mapEmail.put('Errors', lstParseTaskFailed);
                mapEmail.put('MessageSuccess',lstParseMessageSuccess);   
                
            }
        }
        catch(Exception e){
            System.debug('\n EmailXML:'+EmailXML);
            System.debug(e.getMessage()+'-'+e.getStackTraceSTring());
        }
        return mapEmail;
    }
    
    public static Map<String, List<SObject>> parseNotes(String notesXML)
    {
        Map<String, List<ContentNote>> mapNote = new Map<String, List<ContentNote>>();

        List<ContentNote> lstParseSuccess=new List<ContentNote>();
        List<ContentNote> lstParseFailed=new List<ContentNote>();
        ContentNote note;
        
        try{
            
            Dom.document doc = new Dom.document();
            doc.load(notesXML);
            
            Dom.XMLNode root = doc.getRootElement().getChildElement('REPNOTES', 'http://tempuri.org/MarsRepNotes.xsd');
            if(root !=NULL)
            {        
                for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
                {
                    note=new ContentNote();
                    try{          
                        
                        Dom.XMLNode repNote = elementsList.getChildElement('REP_NOTE', 'http://tempuri.org/MarsRepNotes.xsd'); 
                        note.Content =Blob.valueOf(repNote.getText());
                        
                        Dom.XMLNode sfdcNoteId = elementsList.getChildElement('EXTERNAL_ID', 'http://tempuri.org/MarsRepNotes.xsd'); 
                        if(String.isNotEmpty(sfdcNoteId.getText()))
                        {
                            note.Id =parseNull(sfdcNoteId.getText());
                        }
                        
                        /*Dom.XMLNode ownerId = elementsList.getChildElement('NOTE_BY', 'http://tempuri.org/MarsRepNotes.xsd'); 
                        if(ownerId.getText() != null)
                        {
                            note.OwnerId=parseNull(ownerId.getText());
                        }*/
                        
                        Dom.XMLNode noteId = elementsList.getChildElement('NOTE_ID', 'http://tempuri.org/MarsRepNotes.xsd'); 
                        if(noteId.getText() != null)
                        {
                            note.Title=parseNull(noteId.getText());
                        }
                        
                        Dom.XMLNode contactId = elementsList.getChildElement('EXTERNAL_REP_ID', 'http://tempuri.org/MarsRepNotes.xsd'); 
                        if(parseNull(contactId.getText()) != null)
                        {
                            MARSActivityUtility.mapSFDCActivityId.put(Decimal.valueOf(noteId.getText()),contactId.getText());
                        }
                        
                        lstParseSuccess.add(note);
                    }
                    catch(exception e){
                        Dom.XMLNode noteId = elementsList.getChildElement('NOTE_ID', 'http://tempuri.org/MarsRepNotes.xsd'); 
                        if(noteId.getText() != null)
                        {
                            note.Title=noteId.getText();
                        }
                        note.Content=Blob.valueOf(e.getMessage()+e.getStackTraceString());
                        lstParseFailed.add(note);
                    }
                } 
                mapNote.put('Success',lstParseSuccess);   
                mapNote.put('Errors', lstParseFailed);
            }
        }
        catch(Exception e){
            System.debug(e.getMessage()+'-'+e.getStackTraceSTring());
        }
        return mapNote;
    }
    
    public static Map<String, List<Sobject>> parseActivityDelete(String deleteXML)
    { 
        Dom.document doc = new Dom.document();
    
        Map<String, List<SObject>> mapDeleteRecords = new Map<String, List<SObject>>();
        List<SObject> lstDeleteRecords=new List<SObject>();
        List<SObject> lstErrorRecords=new List<SObject>();
    
        Event event;
        task task;
        
        String objectType;
        doc.load(deleteXML);
        System.debug('\nDelete xml'+deleteXML);
        Dom.XMLNode root = doc.getRootElement();
    
        if(root !=NULL)
        {
            if(doc.getRootElement().getChildElement('MEETING', null) != null || doc.getRootElement().getChildElement('FIRMEVENTS', null) != null){
                objectType = 'Event';
            }
            else if(doc.getRootElement().getChildElement('CALL', null) != null || doc.getRootElement().getChildElement('TICKLER', null) != null){
                objectType = 'Task';
            }else if(doc.getRootElement().getChildElement('RECURRENCE', null) != null)
            {
                dom.XmlNode recurrenceNode=doc.getRootElement().getChildElement('RECURRENCE', null);
                Dom.XMLNode activityType=recurrenceNode.getChildElement('ACT_TYPE', null);
                if(activityType.getText() =='MT')
                {
                    objectType = 'Event';
                }else if(activityType.getText() =='TK')
                {
                    objectType = 'Task';    
                }
            }
    
            if(objectType == 'Event')
            {
                for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
                {
                    event= new Event();
                    try
                    {
                        if(elementsList.getName() == 'FIRMEVENTS')
                        {
                            Dom.XMLNode marsId = elementsList.getChildElement('EVENT_ID', null);
                            event.MarsActivityId__c = parseDecimal(marsId.getText());
                        }
                        
                        if(elementsList.getName() == 'RECURRENCE')
                        {
                            Dom.XMLNode recurringId = elementsList.getChildElement('RECURRING_ID', null);
                            event.MarsActivityId__c= parseDecimal(recurringId.getText());
                        }
                        
                        if(elementsList.getName() == 'MEETING')
                        {
                            Dom.XMLNode marsId = elementsList.getChildElement('ACTIVITY_ID', null);
                            event.MarsActivityId__c = parseDecimal(marsId.getText());
                        }
                        
                        Dom.XMLNode SFDCActivityId = elementsList.getChildElement('EXTERNAL_ID', null);
                        if(SFDCActivityId.getText().length() == 0){
                            event.Description = 'External Id should not be null';
                            lstErrorRecords.add(event);
                        }
                        else{
                            event.Id = SFDCActivityId.GetText();
                            lstDeleteRecords.add(event);
                        }
                    }
                    catch(Exception e)
                    {
                        if(elementsList.getName() == 'FIRMEVENT')
                        {
                            Dom.XMLNode marsId = elementsList.getChildElement('EVENT_ID', null);
                            event.MarsActivityId__c = parseDecimal(marsId.getText());
                        }
                        
                        if(elementsList.getName() == 'RECURRENCE')
                        {
                            Dom.XMLNode recurringId = elementsList.getChildElement('RECURRING_ID', null);
                            event.MarsActivityId__c= parseDecimal(recurringId.getText());
                        }
                        
                        if(elementsList.getName() == 'MEETING')
                        {
                            Dom.XMLNode marsId = elementsList.getChildElement('ACTIVITY_ID', null);
                            event.MarsActivityId__c = parseDecimal(marsId.getText());
                        }
                        event.Description = e.getMessage()+e.getStackTraceString();
                        lstErrorRecords.add(event);
                    }
                }
            }
            else if(objectType == 'Task')
            {
                for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
                {
                    task= new task();
                    try
                    {
                        
                        
                        if(elementsList.getName() == 'RECURRENCE')
                        {
                            Dom.XMLNode recurringId = elementsList.getChildElement('RECURRING_ID', null);
                            task.MarsActivityId__c = parseDecimal(recurringId.getText());
                        }else{
                            Dom.XMLNode marsId = elementsList.getChildElement('ACTIVITY_ID', null);
                            task.MarsActivityId__c = parseDecimal(marsId.getText());
                        }
                        
                        Dom.XMLNode SFDCActivityIdId = elementsList.getChildElement('EXTERNAL_ID', null);
                        
                        if(SFDCActivityIdId.getText().length() == 0){
                            task.Description = 'External Id should not be null';
                            lstErrorRecords.add(task);
                        }
                        else{
                            task.Id = SFDCActivityIdId.getText();
                            lstDeleteRecords.add(task);
                        }
                    }
                    catch(Exception e){
                        if(elementsList.getName() == 'RECURRENCE')
                        {
                            Dom.XMLNode recurringId = elementsList.getChildElement('RECURRING_ID', null);
                            task.MarsActivityId__c = parseDecimal(recurringId.getText());
                        }else{
                            Dom.XMLNode marsId = elementsList.getChildElement('ACTIVITY_ID', null);
                            task.MarsActivityId__c = parseDecimal(marsId.getText());
                        }
                        task.Description = e.getMessage();
                        lstErrorRecords.add(task);
                    }
                }
            }
    
            System.debug('\n Error Records:'+lstErrorRecords);
            System.debug('\n Success Records:'+lstDeleteRecords);
            mapDeleteRecords.put(objectType+'Errors',lstErrorRecords);
            mapDeleteRecords.put(objectType+'Success',lstDeleteRecords);
        }        
        return mapDeleteRecords;
    }
    
    public static String parseNull(String value)
    {        
        //Return blank if value is null
        if(value == null)
            return '';
        
        //return original value
        return value;
    }
    
    public static Decimal parseDecimal(String value)
    {
        if(value.length() > 0 )
        {
            //Decimal decimalValue=Decimal.valueOf(value);
            return Decimal.valueOf(value);
        }
        else
        {
            return null;
        }
    }  
    
    /*public static Date parseDate(String datetimevalue)
    {
        if(datetimevalue.length() > 0 )
        {
            String[] formatdate=dateTimevalue.split(' ');
            Date dateValue=Date.parse(formatdate[0]);
            return dateValue;
        }
        else
        {
            return null;
        }
    } */
    
    public static Datetime parseDateTime(String dateTimevalue)
    {
        if(dateTimevalue.length() > 0 )
        {
            String[] formatdate=dateTimevalue.split(' ');
            Date dateValue=Date.parse(formatdate[0]);
            String dateTimeString=String.valueOf(dateValue)+' '+formatdate[1];
            return Datetime.valueOfGMT(dateTimeString);
        }
        else
        {
            return null;
        }
    }
    
    
}