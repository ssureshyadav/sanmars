public class MARSActivitySyncMessageParser
{
    public static Map<String, List<SObject>> parseFirmEvent(String firmEventXML)
    {
        Map<String, List<SObject>> mapFirmEvent = new Map<String, List<SObject>>();
        List<Event> lstParseSuccess=new List<Event>();
        List<EventRelation> lstParseEvtRelationSuccess=new List<EventRelation>();
        List<Event> lstParseFailed=new List<Event>();
        Event FirmEvent;
        EventRelation eventRelation;
        try{
            
            Dom.document doc = new Dom.document();
            doc.load(firmEventXML);
            
            Dom.XMLNode root = doc.getRootElement().getChildElement('FIRMEVENT', 'http://tempuri.org/MarsFirmEvent.xsd');
            if(root !=NULL)
            {        
                for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
                {
                    FirmEvent=new Event();
                    try{          
                    
                        Dom.XMLNode marsFirmEventid = elementsList.getChildElement('EVENT_ID', 'http://tempuri.org/MarsFirmEvent.xsd');
                        if(parseNull(marsFirmEventid.getText()) == '')throw new MarsException('Event id cannot be null');
                        FirmEvent.MarsActivityId__c=parseDecimal(marsFirmEventid.getText());
                        
                        Dom.XMLNode externalFirmEventId = elementsList.getChildElement('EXTERNAL_ID', 'http://tempuri.org/MarsFirmEvent.xsd');
                        if(externalFirmEventId.getText().length()>0)
                        {
                            FirmEvent.Id =parseNull(externalFirmEventId.getText());
                        }
                        
                        
                        Dom.XMLNode accountId = elementsList.getChildElement('FIRM_EXTERNAL_ID', 'http://tempuri.org/MarsFirmEvent.xsd');
                        if(accountId.getText().length()>0)
                        {
                            FirmEvent.whatId =parseNull(accountId.getText());
                        }
                        
                        Dom.XMLNode contactId = elementsList.getChildElement('REP_EXTERNAL_ID', 'http://tempuri.org/MarsFirmEvent.xsd');
                        if(contactId.getText().length()>0)
                        {
                            FirmEvent.whoId =parseNull(contactId.getText());
                        }
                        
                        
                        Dom.XMLNode startDate = elementsList.getChildElement('BEG_DT', 'http://tempuri.org/MarsFirmEvent.xsd'); 
                        FirmEvent.StartDateTime =parseDateTime(startDate.getText());
                        
                        Dom.XMLNode endDate = elementsList.getChildElement('END_DT', 'http://tempuri.org/MarsFirmEvent.xsd'); 
                        FirmEvent.EndDateTime =parseDateTime(endDate.getText());
                        
                        Dom.XMLNode marsUserActivity = elementsList.getChildElement('USERACTIVITY', 'http://tempuri.org/MarsFirmEvent.xsd');
                        Dom.XMLNode reminder = marsUserActivity.getChildElement('ALARM_ON', 'http://tempuri.org/MarsFirmEvent.xsd'); 
                        FirmEvent.IsReminderSet =parseNull(reminder.getText())=='Y'?true:false;
                        
                        
                        Dom.XMLNode recurrence = elementsList.getChildElement('RECURRING_ID', 'http://tempuri.org/MarsFirmEvent.xsd'); 
                        FirmEvent.MarsReccurenceId__c =parseDecimal(recurrence.getText());
                        FirmEvent.Subject ='Firm Event';
                        
                        for(dom.XmlNode childs:elementsList.getChildren())
                        {
                            eventRelation =new EventRelation();
                            if(childs.getName() == 'USERACTIVITY')
                            {
                                Dom.XMLNode marsUserExternalId = childs.getChildElement('SFDC_USR_NM', 'http://tempuri.org/MarsFirmEvent.xsd');   
                                System.debug(marsUserExternalId.getText());
                                eventRelation.RelationId =marsUserExternalId.getText();
                                eventRelation.IsInvitee =true;
                                eventRelation.Status =marsFirmEventid.getText();
                                lstParseEvtRelationSuccess.add(eventRelation);
                            }
                        }
                        
                        lstParseSuccess.add(FirmEvent);
                    }
                    catch(exception e){
                        Dom.XMLNode FirmEventId = elementsList.getChildElement('EVENT_ID', 'http://tempuri.org/MarsFirmEvent.xsd'); 
                        FirmEvent.MarsActivityId__c =parseDecimal(FirmEventId.getText());
                        FirmEvent.Description=e.getMessage()+e.getStackTraceString();
                        lstParseFailed.add(FirmEvent);
                    }
                } 
                mapFirmEvent.put('Success',lstParseSuccess);   
                mapFirmEvent.put('SuccessEventRelation',lstParseEvtRelationSuccess);
                mapFirmEvent.put('Errors', lstParseFailed);
            }
        }
        catch(Exception e){
            System.debug('\n FirmEventXML:'+FirmEventXML);
            System.debug(e.getMessage()+'-'+e.getStackTraceSTring());
        }
        return mapFirmEvent;
    }
    
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
                    
                        Dom.XMLNode marsMeetingid = elementsList.getChildElement('ACTIVITY_ID', 'http://tempuri.org/MarsMeeting.xsd');
                        if(parseNull(marsMeetingid.getText()) == '')throw new MarsException('Activity id cannot be null');
                        Meeting.MarsActivityId__c=parseDecimal(marsMeetingid.getText());
                        
                        Dom.XMLNode externalMeetingId = elementsList.getChildElement('SFDC_EXTERNAL_ID', 'http://tempuri.org/MarsMeeting.xsd');
                        if(externalMeetingId.getText().length()>0)
                        {
                            Meeting.Id =parseNull(externalMeetingId.getText());
                        }
                        
                        Dom.XMLNode externalId = elementsList.getChildElement('EXTERNAL_REP_ID', 'http://tempuri.org/MarsMeeting.xsd');
                        Meeting.whoId =parseNull(externalId.getText());
                        
                        Dom.XMLNode startDate = elementsList.getChildElement('BEG_DT', 'http://tempuri.org/MarsMeeting.xsd'); 
                        //Meeting.StartDateTime =parseDateTime(startDate.getText());
                        Meeting.StartDateTime =System.today();
                        
                        Dom.XMLNode endDate = elementsList.getChildElement('END_DT', 'http://tempuri.org/MarsMeeting.xsd'); 
                        Meeting.EndDateTime =System.today()+1;
                        
                        Dom.XMLNode reminder = elementsList.getChildElement('ALARM_ON', 'http://tempuri.org/MarsMeeting.xsd'); 
                        Meeting.IsReminderSet =parseNull(reminder.getText())=='Y'?true:false;
                        
                        Dom.XMLNode recurrence = elementsList.getChildElement('RECURRING_ID', 'http://tempuri.org/MarsMeeting.xsd'); 
                        Meeting.MarsReccurenceId__c =parseDecimal(recurrence.getText());
                        Meeting.Subject ='Meeting';
                        
                        for(dom.XmlNode childs:elementsList.getChildren())
                        {
                            eventRelation =new EventRelation();
                            if(childs.getName() == 'REPACTIVITY' )
                            {
                                Dom.XMLNode marsRepexternalId = childs.getChildElement('EXTERNAL_ID', 'http://tempuri.org/MarsMeeting.xsd');    
                                System.debug(marsRepexternalId.getText());
                                eventRelation.RelationId =marsRepexternalId.getText();
                                eventRelation.IsInvitee =true;
                                eventRelation.Status =marsMeetingid.getText();
                                lstParseEvtRelationSuccess.add(eventRelation);
                            }
                            
                            if(childs.getName() == 'USERACTIVITY')
                            {
                                Dom.XMLNode marsUserExternalId = childs.getChildElement('SFDC_USR_NM', 'http://tempuri.org/MarsMeeting.xsd');   
                                System.debug(marsUserExternalId.getText());
                                eventRelation.RelationId =marsUserExternalId.getText();
                                eventRelation.IsInvitee =true;
                                eventRelation.Status =marsMeetingid.getText();
                                lstParseEvtRelationSuccess.add(eventRelation);
                            }
                        }
                        lstParseSuccess.add(Meeting);
                    }
                    catch(exception e){
                    
                        Dom.XMLNode MeetingId = elementsList.getChildElement('ACTIVITY_ID', 'http://tempuri.org/MarsMeeting.xsd'); 
                        Meeting.MarsActivityId__c =parseDecimal(MeetingId.getText());
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
    
    public static Map<String, List<Task>> parseCall(String callXML)
    {
        Map<String, List<Task>> mapcall = new Map<String, List<Task>>();
        List<Task> lstParseSuccess=new List<Task>();
        List<Task> lstParseFailed=new List<Task>();
        Task call;
        try{
            
            Dom.document doc = new Dom.document();
            doc.load(callXML);
            
            Dom.XMLNode root = doc.getRootElement().getChildElement('CALL', 'http://tempuri.org/MarsCall.xsd');
            if(root !=NULL)
            {        
                for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
                {
                    call=new Task();
                    try{          
                    
                        Dom.XMLNode marscallid = elementsList.getChildElement('ACTIVITY_ID', 'http://tempuri.org/MarsCall.xsd');
                        if(parseNull(marscallid.getText()) == '')throw new MarsException('call id cannot be null');
                        call.MarsActivityId__c=parseDecimal(marscallid.getText());
                        
                        Dom.XMLNode externalcallId = elementsList.getChildElement('EXTERNAL_ID', 'http://tempuri.org/MarsCall.xsd');
                        if(externalcallId.getText().length()>0)
                        {
                            call.Id =parseNull(externalcallId.getText());
                        }
                        
                        Dom.XMLNode repId = elementsList.getChildElement('EXTERNAL_REP_ID', 'http://tempuri.org/MarsCall.xsd');
                        if(repId.getText().length()>0)
                        {
                            call.whoId =parseNull(repId.getText());
                        }
                        Dom.XMLNode description = elementsList.getChildElement('NOTES', 'http://tempuri.org/MarsCall.xsd'); 
                        call.Description =parseNull(description.getText());
                        
                        call.Status='Completed';
                        call.TaskSubType ='Call';
                        call.Subject ='Call';
                        lstParseSuccess.add(call);
                    }
                    catch(exception e){
                        Dom.XMLNode callId = elementsList.getChildElement('ACTIVITY_ID', 'http://tempuri.org/MarsCall.xsd'); 
                        call.MarsActivityId__c =parseDecimal(callId.getText());
                        call.Description=e.getMessage()+e.getStackTraceString();
                        lstParseFailed.add(call);
                    }
                } 
                mapcall.put('Success',lstParseSuccess);   
                mapcall.put('Errors', lstParseFailed);
            }
        }
        catch(Exception e){
            System.debug('\n callXML:'+callXML);
            System.debug(e.getMessage()+'-'+e.getStackTraceSTring());
        }
        return mapcall;
    }
    
    public static Map<String, List<Task>> parseTickler(String TicklerXML)
    {
        Map<String, List<Task>> mapTickler = new Map<String, List<Task>>();
        List<Task> lstParseSuccess=new List<Task>();
        List<Task> lstParseFailed=new List<Task>();
        Task tickler;
        try{
            
            Dom.document doc = new Dom.document();
            doc.load(TicklerXML);
            
            Dom.XMLNode root = doc.getRootElement().getChildElement('TICKLER', 'http://tempuri.org/MarsTickler.xsd');
            if(root !=NULL)
            {        
                for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
                {
                    tickler=new Task();
                    try{          
                    
                        Dom.XMLNode marsTicklerid = elementsList.getChildElement('ACTIVITY_ID', 'http://tempuri.org/MarsTickler.xsd');
                        if(parseNull(marsTicklerid.getText()) == '')throw new MarsException('Activity id cannot be null');
                        tickler.MarsActivityId__c=parseDecimal(marsTicklerid.getText());
                        
                        Dom.XMLNode externalTicklerId = elementsList.getChildElement('EXTERNAL_ID', 'http://tempuri.org/MarsTickler.xsd');
                        if(externalTicklerId.getText().length()>0)
                        {
                            tickler.Id =parseNull(externalTicklerId.getText());
                        }
                        
                        
                        Dom.XMLNode repId = elementsList.getChildElement('EXTERNAL_REP_ID', 'http://tempuri.org/MarsTickler.xsd');
                        if(repId.getText().length()>0)
                        {
                            tickler.whoId =parseNull(repId.getText());
                        }
                        Dom.XMLNode activityDate = elementsList.getChildElement('BEG_DT', 'http://tempuri.org/MarsTickler.xsd'); 
                        tickler.ActivityDate =parseDate(activityDate.getText());
                        
                        Dom.XMLNode reminder = elementsList.getChildElement('ALARM_ON', 'http://tempuri.org/MarsTickler.xsd'); 
                        tickler.IsReminderSet =parseNull(reminder.getText())=='Y'?true:false;
                        
                        Dom.XMLNode recurrence = elementsList.getChildElement('RECURRING_ID', 'http://tempuri.org/MarsTickler.xsd'); 
                        tickler.MarsReccurenceId__c =parseDecimal(recurrence.getText());
                        tickler.TaskSubType ='Call';
                        tickler.Subject ='Call';
                        lstParseSuccess.add(tickler);
                    }
                    catch(exception e){
                        Dom.XMLNode TicklerId = elementsList.getChildElement('ACTIVITY_ID', 'http://tempuri.org/MarsTickler.xsd'); 
                        tickler.MarsActivityId__c =parseDecimal(TicklerId.getText());
                        tickler.Description=e.getMessage()+e.getStackTraceString();
                        lstParseFailed.add(tickler);
                    }
                } 
                mapTickler.put('Success',lstParseSuccess);   
                mapTickler.put('Errors', lstParseFailed);
            }
        }
        catch(Exception e){
            System.debug('\n TicklerXML:'+TicklerXML);
            System.debug(e.getMessage()+'-'+e.getStackTraceSTring());
        }
        return mapTickler;
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
    
     public static Map<String, List<Sobject>> parseRecurrence(String RecurrenceXML)
    {
        Map<String, List<Sobject>> mapRecurrence = new Map<String, List<Sobject>>();
        List<Task> lstParseTaskSuccess=new List<Task>();
        List<Task> lstParseTaskFailed=new List<Task>();
        List<Event> lstParseEventSuccess=new List<Event>();
        List<Event> lstParseEventFailed=new List<Event>();
        Task taskRecurrence;
        Event eventRecurrence;
        try{
            
            Dom.document doc = new Dom.document();
            doc.load(RecurrenceXML);
            
            Dom.XMLNode root = doc.getRootElement().getChildElement('RECURRENCE', 'http://tempuri.org/MarsRecurrence.xsd');
            if(root !=NULL)
            {        
                for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
                {
                    try{          
                        Dom.XMLNode marsActivityType = elementsList.getChildElement('ACT_TYPE', 'http://tempuri.org/MarsRecurrence.xsd');
                        if(parseNull(marsActivityType.getText()) == '')throw new MarsException('Activity Type cannot be null');
                        if(marsActivityType.getText() == 'MT' || marsActivityType.getText() == 'EV')
                        {
                            eventRecurrence=new Event();
                            eventRecurrence.EventSubType ='Event';
                            eventRecurrence.IsRecurrence =true;
                            
                            Dom.XMLNode startTime = elementsList.getChildElement('START_TIME', 'http://tempuri.org/MarsRecurrence.xsd'); 
                            //eventRecurrence.RecurrenceStartDateTime =parseDate(startTime.getText());
                            eventRecurrence.RecurrenceStartDateTime =DateTime.now();
                            //eventRecurrence.ActivityDateTime =DateTime.now();
                            
                            Dom.XMLNode externalRecurrenceId = elementsList.getChildElement('EXTERNAL_ID', 'http://tempuri.org/MarsRecurrence.xsd');
                            if(externalRecurrenceId.getText().length()>0)
                            {
                                taskRecurrence.Id =parseNull(externalRecurrenceId.getText());
                            }
                            
                            Dom.XMLNode marsRecurrenceid = elementsList.getChildElement('RECURRING_ID', 'http://tempuri.org/MarsRecurrence.xsd');
                            if(parseNull(marsRecurrenceid.getText()) == '')throw new MarsException('Recurrence id cannot be null');
                            eventRecurrence.MarsReccurenceId__c=parseDecimal(marsRecurrenceid.getText());
                            
                            
                            Dom.XMLNode recurrenceType = elementsList.getChildElement('RECURRENCE_TYPE', 'http://tempuri.org/MarsRecurrence.xsd'); 
                            eventRecurrence.RecurrenceType =parseNull(recurrenceType.getText());
                            
                            if(!(eventRecurrence.RecurrenceType =='RecursYearly' 
                            || eventRecurrence.RecurrenceType =='RecursYearlyNth' 
                            || eventRecurrence.RecurrenceType == 'RecursEveryWeekday'))
                            {
                                Dom.XMLNode interval = elementsList.getChildElement('INTERVAL', 'http://tempuri.org/MarsRecurrence.xsd'); 
                                eventRecurrence.RecurrenceInterval =Integer.valueOf(interval.getText());
                            }
                            
                            if(eventRecurrence.RecurrenceType == 'RecursMonthlyNth' || eventRecurrence.RecurrenceType =='RecursYearlyNth')
                            {
                                Dom.XMLNode instance = elementsList.getChildElement('INSTANCE', 'http://tempuri.org/MarsRecurrence.xsd'); 
                                eventRecurrence.RecurrenceInstance =parseNull(instance.getText());
                            }
                            
                            if(eventRecurrence.RecurrenceType =='RecursWeekly' 
                            || eventRecurrence.RecurrenceType =='RecursMonthlyNth' 
                            || eventRecurrence.RecurrenceType =='RecursYearlyNth' 
                            || eventRecurrence.RecurrenceType == 'RecursEveryWeekday')
                            {
                                Dom.XMLNode dayOfWeekMask = elementsList.getChildElement('DAY_OF_WEEK_MASK', 'http://tempuri.org/MarsRecurrence.xsd'); 
                                eventRecurrence.RecurrenceDayOfWeekMask =dayOfWeekMask.getText() == '0'?null:Integer.valueOf(dayOfWeekMask.getText());
                            }
 
                            if(eventRecurrence.RecurrenceType =='RecursMonthly' 
                            || eventRecurrence.RecurrenceType =='RecursYearly')
                            {
                                Dom.XMLNode dayOfMonth = elementsList.getChildElement('DAY_OF_MONTH', 'http://tempuri.org/MarsRecurrence.xsd'); 
                                eventRecurrence.RecurrenceDayOfMonth=dayOfMonth.getText() == '0'?null:Integer.valueOf(dayOfMonth.getText());
                            }
                            
                            if(eventRecurrence.RecurrenceType =='RecursYearlyNth' 
                            || eventRecurrence.RecurrenceType =='RecursYearly')
                            {
                                Dom.XMLNode monthOfYear = elementsList.getChildElement('MONTH_OF_YEAR', 'http://tempuri.org/MarsRecurrence.xsd'); 
                                eventRecurrence.RecurrenceMonthOfYear=monthOfYear.getText();
                                //eventRecurrence.RecurrenceMonthOfYear ='January';
                            }
                            
                            Dom.XMLNode endTime = elementsList.getChildElement('END_TIME', 'http://tempuri.org/MarsRecurrence.xsd'); 
                            eventRecurrence.RecurrenceEndDateOnly =parseDate(endTime.getText());
                            
                            Dom.XMLNode duration = elementsList.getChildElement('DURATION', 'http://tempuri.org/MarsRecurrence.xsd'); 
                            eventRecurrence.DurationInMinutes =Integer.valueOf(duration.getText());
                            lstParseEventSuccess.add(eventRecurrence);
                        }else if(marsActivityType.getText() =='TK')
                        {
                            taskRecurrence=new Task();
                            taskRecurrence.TaskSubType ='Call';
                            taskRecurrence.IsRecurrence =true;
                            
                            Dom.XMLNode startTime = elementsList.getChildElement('START_TIME', 'http://tempuri.org/MarsRecurrence.xsd'); 
                            //taskRecurrence.RecurrenceStartDateOnly =parseDate(startTime.getText());
                            //taskRecurrence.RecurrenceStartDateOnly =System.today();
                            
                            Dom.XMLNode marsRecurrenceid = elementsList.getChildElement('RECURRING_ID', 'http://tempuri.org/MarsRecurrence.xsd');
                            if(parseNull(marsRecurrenceid.getText()) == '')throw new MarsException('Recurrence id cannot be null');
                            taskRecurrence.MarsReccurenceId__c=parseDecimal(marsRecurrenceid.getText());
                            
                            
                            Dom.XMLNode externalRecurrenceId = elementsList.getChildElement('EXTERNAL_ID', 'http://tempuri.org/MarsRecurrence.xsd');
                            if(externalRecurrenceId.getText().length()>0)
                            {
                                taskRecurrence.Id =parseNull(externalRecurrenceId.getText());
                            }
                            
                            Dom.XMLNode recurrenceType = elementsList.getChildElement('RECURRENCE_TYPE', 'http://tempuri.org/MarsRecurrence.xsd'); 
                            taskRecurrence.RecurrenceType =parseNull(recurrenceType.getText());
                            
                            if(!(taskRecurrence.RecurrenceType =='RecursYearly' 
                            || taskRecurrence.RecurrenceType =='RecursYearlyNth' 
                            || taskRecurrence.RecurrenceType == 'RecursEveryWeekday'))
                            {
                                Dom.XMLNode interval = elementsList.getChildElement('INTERVAL', 'http://tempuri.org/MarsRecurrence.xsd'); 
                                taskRecurrence.RecurrenceInterval =Integer.valueOf(interval.getText());
                            }
                            
                            if(eventRecurrence.RecurrenceType == 'RecursMonthlyNth' || eventRecurrence.RecurrenceType =='RecursYearlyNth')
                            {
                                Dom.XMLNode instance = elementsList.getChildElement('INSTANCE', 'http://tempuri.org/MarsRecurrence.xsd'); 
                                taskRecurrence.RecurrenceInstance =parseNull(instance.getText());
                            }
                            
                            if(taskRecurrence.RecurrenceType =='RecursWeekly' 
                            || taskRecurrence.RecurrenceType =='RecursMonthlyNth' 
                            || taskRecurrence.RecurrenceType =='RecursYearlyNth' 
                            || taskRecurrence.RecurrenceType == 'RecursEveryWeekday')
                            {
                                Dom.XMLNode dayOfWeekMask = elementsList.getChildElement('DAY_OF_WEEK_MASK', 'http://tempuri.org/MarsRecurrence.xsd'); 
                                taskRecurrence.RecurrenceDayOfWeekMask =dayOfWeekMask.getText() == '0'?null:Integer.valueOf(dayOfWeekMask.getText());
                            }
 
                            if(taskRecurrence.RecurrenceType =='RecursMonthly' 
                            || taskRecurrence.RecurrenceType =='RecursYearly')
                            {
                                Dom.XMLNode dayOfMonth = elementsList.getChildElement('DAY_OF_MONTH', 'http://tempuri.org/MarsRecurrence.xsd'); 
                                taskRecurrence.RecurrenceDayOfMonth=dayOfMonth.getText() == '0'?null:Integer.valueOf(dayOfMonth.getText());
                            }
                            
                            if(taskRecurrence.RecurrenceType =='RecursYearlyNth' 
                            || taskRecurrence.RecurrenceType =='RecursYearly')
                            {
                                Dom.XMLNode monthOfYear = elementsList.getChildElement('MONTH_OF_YEAR', 'http://tempuri.org/MarsRecurrence.xsd'); 
                                taskRecurrence.RecurrenceMonthOfYear=monthOfYear.getText();
                                //eventRecurrence.RecurrenceMonthOfYear ='January';
                            }
                            
                            Dom.XMLNode endTime = elementsList.getChildElement('END_TIME', 'http://tempuri.org/MarsRecurrence.xsd'); 
                            taskRecurrence.RecurrenceEndDateOnly =parseDate(endTime.getText());
    
                            lstParseTaskSuccess.add(taskRecurrence);
                        }
                    }
                    catch(exception e){
                        Dom.XMLNode marsActivityType = elementsList.getChildElement('ACT_TYPE', 'http://tempuri.org/MarsRecurrence.xsd');
                        if(parseNull(marsActivityType.getText()) == '')throw new MarsException('Activity Type cannot be null');
                        if(marsActivityType.getText() == 'MT' || marsActivityType.getText() == 'EV')
                        {
                            Dom.XMLNode RecurrenceId = elementsList.getChildElement('RECURRING_ID', 'http://tempuri.org/MarsRecurrence.xsd'); 
                            eventRecurrence.MarsReccurenceId__c =parseDecimal(RecurrenceId.getText());
                            eventRecurrence.Description=e.getMessage()+e.getStackTraceString();
                            lstParseEventFailed.add(eventRecurrence);
                        }else if(marsActivityType.getText() =='TK')
                        {
                            Dom.XMLNode RecurrenceId = elementsList.getChildElement('RECURRING_ID', 'http://tempuri.org/MarsRecurrence.xsd'); 
                            taskRecurrence.MarsReccurenceId__c =parseDecimal(RecurrenceId.getText());
                            taskRecurrence.Description=e.getMessage()+e.getStackTraceString();
                            lstParseTaskFailed.add(taskRecurrence);
                        }
                    }
                } 
                mapRecurrence.put('EventSuccess',lstParseEventSuccess);   
                mapRecurrence.put('EventErrors',lstParseEventFailed);   
                mapRecurrence.put('TaskSuccess',lstParseTaskSuccess);   
                mapRecurrence.put('TaskErrors', lstParseTaskFailed);
            }
        }
        catch(Exception e){
            System.debug('\n RecurrenceXML:'+RecurrenceXML);
            System.debug(e.getMessage()+'-'+e.getStackTraceSTring());
        }
        return mapRecurrence;
    }
    
    public static Map<String, List<Sobject>> parseActivityDelete(String deleteXML)
    { 
        Dom.document doc = new Dom.document();
    
        Map<String, List<SObject>> mapDeleteRecords = new Map<String, List<SObject>>();
        List<SObject> lstDeleteRecords=new List<SObject>();
        List<SObject> lstErrorRecords=new List<SObject>();
    
        Event event;
        task task;
        MarsRepTeam__c objteamRep;
        
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
                            event.MarsActivityId__c = parseDecimal(marsId.GetText());
                        }
                        
                        if(elementsList.getName() == 'MEETING')
                        {
                            Dom.XMLNode marsId = elementsList.getChildElement('ACTIVITY_ID', null);
                            event.MarsActivityId__c = parseDecimal(marsId.GetText());
                        }
                        
                        Dom.XMLNode SFDCActivityId = elementsList.getChildElement('EXTERNAL_ID', null);
                        if(SFDCActivityId.GetText().length() == 0){
                            event.Description = 'External Id not found in SFDC';
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
                            event.MarsActivityId__c = parseDecimal(marsId.GetText());
                        }
                        
                        if(elementsList.getName() == 'MEETING')
                        {
                            Dom.XMLNode marsId = elementsList.getChildElement('ACTIVITY_ID', null);
                            event.MarsActivityId__c = parseDecimal(marsId.GetText());
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
                        Dom.XMLNode marsId = elementsList.getChildElement('ACTIVITY_ID', null);
                        Dom.XMLNode SFDCActivityIdId = elementsList.getChildElement('EXTERNAL_ID', null);
                        task.MarsActivityId__c = parseDecimal(marsId.GetText());
                        if(SFDCActivityIdId.GetText().length() == 0){
                            task.Description = 'External Id not found in SFDC';
                            lstErrorRecords.add(task);
                        }
                        else{
                            task.Id = SFDCActivityIdId.GetText();
                            lstDeleteRecords.add(task);
                        }
                    }
                    catch(Exception e){
                        Dom.XMLNode marsId = elementsList.getChildElement('ACTIVITY_ID', null);
                        task.MarsActivityId__c = parseDecimal(marsId.GetText());
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
    
    public static Date parseDate(String datetimevalue)
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
    } 
    
    public static Datetime parseDateTime(String dateTimevalue)
    {
        if(dateTimevalue.length() > 0 )
        {
            String[] formatdate=dateTimevalue.split(' ');
            Date dateValue=Date.parse(formatdate[0]);
            String dateTimeString=String.valueOf(dateValue)+' '+formatdate[1];
            return Datetime.valueOf(dateTimeString);
        }
        else
        {
            return null;
        }
    }
    
    
}