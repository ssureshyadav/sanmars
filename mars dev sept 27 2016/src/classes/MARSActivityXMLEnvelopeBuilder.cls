/** Description     :   This class is to make different XML Envelope required for Task and Event web service callout.
 *
 *  Created By      :
 *
 *  Created Date    :   08/08/2016
 *
 *  Revision Log    :   V_1.0
 *
**/
public with sharing class MARSActivityXMLEnvelopeBuilder {  

    //Method to create XML envelope for rep record
    public static String eventEnvelope(Event evt,String objName) {
        
        Set<Id> setWhoIds=new Set<Id>();
        //Set<Id> setWhatIds=new Set<Id>();
        Map<Id,Contact> mapContacts;
        //Map<Id,Account> mapFirmSummary;
        
        if(evt.WhoId != null)
        {
            setWhoIds.add(evt.WhoId);
        }
        
        List<EventRelation> lstevtRelation=[SELECT EventId,Id,RelationId,Status FROM EventRelation Where EventId = : evt.Id];
        String integrationUser = 'MARSINTG';
        //List<String> lstAttendees=new List<String>();
        String attendees ='';
        
        if(!lstevtRelation.isEmpty())
        {
            for(EventRelation rel:lstevtRelation)
            {
                String objectName =String.valueOf(rel.RelationId.getSObjectType());
                //lstAttendees.add(rel.RelationId);
               /* if(objectName == 'marssfs__MARSFirmSummary__c' || objectName == 'Account')
                {
                    setWhatIds.add(rel.RelationId);    
                }else */
                if(objectName == 'Contact')
                {
                    setWhoIds.add(rel.RelationId);    
                }
            }
            /*if(!setWhatIds.isEmpty())
            {
                System.debug(setWhatIds);
                mapFirmSummary=new Map<Id,Account>([SELECT MarsFirmId__c FROM Account Where (Id IN : setWhatIds OR SFDCFirmSumId__c IN : setWhatIds) AND ParentId =null ]);
            }*/    
            if(!setWhoIds.isEmpty())
            {
                mapContacts =new Map<Id,Contact>([Select Id,MarsRepId__c from Contact Where MarsRepId__c != null And Id IN : setWhoIds]);
                
            }
            for(EventRelation rel:lstevtRelation)
            {
                System.debug(mapContacts);
                System.debug(rel.RelationId);
                if(rel.EventId == evt.Id && mapContacts != null && mapContacts.containsKey(rel.RelationId) && objName =='MEETING')
                {
                    attendees +='<REPATTENDEE>'+mapContacts.get(rel.RelationId).MarsRepId__c+'</REPATTENDEE>';                       
                }
                
                if(rel.EventId == evt.Id && String.valueOf(rel.RelationId).startsWith('005'))
                {
                    attendees +='<USERATTENDEE>'+ rel.RelationId +'</USERATTENDEE>';
                }
            }
            attendees +='<USERATTENDEE>'+ evt.OwnerId+'</USERATTENDEE>';
        }
        
        mapContacts =new Map<Id,Contact>([Select Id,MarsRepId__c from Contact Where MarsRepId__c != null And Id = : evt.WhoId]);
        
        String eventEnvelopeString ='<Mars'+objName+'DataSet xmlns="http://tempuri.org/Mars'+objName+'.xsd"><'+objName.toUpperCase()+'S>';
        
            String address1,address2,address3,address4; 
            
            String recuringInfo='';
            if(evt.RecurrenceActivityId != null)
            {
                recuringInfo +='<RECURRENCEID>'+parseNull(evt.MarsReccurenceId__c)+'</RECURRENCEID>';
                if(evt.IsRecurrence){
                
                        recuringInfo +='<RECURRENCEDAYOFMONTH>'+parseNull(evt.recurrencedayofmonth)+'</RECURRENCEDAYOFMONTH>'
                                +'<ISRECURRENCE>'+evt.Isrecurrence+'</ISRECURRENCE>'
                                +'<RECURRENCEDAYOFWEEKMASK>'+parseNull(evt.recurrencedayofweekmask)+'</RECURRENCEDAYOFWEEKMASK>'
                                +'<RECURRENCEENDDATEONLY>'+parseDateTime(DateTime.newInstance(evt.recurrenceenddateonly,evt.recurrencestartdatetime.Time().addMinutes(evt.DurationInMinutes)))+'</RECURRENCEENDDATEONLY>'
                                +'<RECURRENCEINSTANCE>'+parseNull(evt.recurrenceinstance)+'</RECURRENCEINSTANCE>'
                                +'<RECURRENCEINTERVAL>'+parseNull(evt.recurrenceinterval)+'</RECURRENCEINTERVAL>'
                                +'<RECURRENCEMONTHOFYEAR>'+parseNull(evt.recurrencemonthofyear)+'</RECURRENCEMONTHOFYEAR>'
                                +'<RECURRENCESTARTDATETIME>'+parseDateTime(evt.recurrencestartdatetime)+'</RECURRENCESTARTDATETIME>'
                                +'<RECURRENCETIMEZONESIDKEY>'+parseNull(evt.recurrencetimezonesidkey)+'</RECURRENCETIMEZONESIDKEY>'
                                +'<RECURRENCETYPE>'+parseNull(evt.recurrencetype)+'</RECURRENCETYPE>'
                                +'<RECURRENCEACTIVITYID>'+parseNull(evt.RecurrenceActivityId)+'</RECURRENCEACTIVITYID>';
                }
            }
            
            if(objName =='Meeting')
            {
               eventEnvelopeString += '<'+objName.toUpperCase()+'>'
                                    +'<MTG_CONTACT_ID>'+parseNull(mapContacts.get(evt.WhoId).MarsRepId__c)+'</MTG_CONTACT_ID>'
                                    +'<ACTIVITY_ID>'+parseNull(evt.MarsActivityId__c)+'</ACTIVITY_ID>'
                                    +'<ACT_TYPE>MT</ACT_TYPE>'
                                    +'<MTG_TYPE>'+parseNull(evt.MarsMeetingType__c)+'</MTG_TYPE>' //I refers to Internal Meeting In Mars.
                                    //+'<MTG_PLACE>'+parseNull(evt.Location)+'</MTG_PLACE>'
                                    +'<MTG_DESC>'+ parseNull(evt.Subject) +'</MTG_DESC>'
                                    +'<MTG_ADDR1></MTG_ADDR1>'
                                    +'<MTG_ADDR2></MTG_ADDR2>'
                                    +'<MTG_CITY></MTG_CITY>'
                                    +'<STATE_ID></STATE_ID>'
                                    +'<MTG_ZIP></MTG_ZIP>'
                                    +'<NOTE_TEXT>'+parseNull(evt.Description)+'</NOTE_TEXT>'
                                    +'<COUNTRY_CD></COUNTRY_CD>'
                                    +'<BEG_DT>'+parseDateTime(evt.StartDateTime)+'</BEG_DT>'
                                    +'<END_DT>'+parseDateTime(evt.EndDateTime)+'</END_DT>'
                                    +'<STAT_CD>S</STAT_CD>'
                                    +'<ALARM_ON>'+(evt.IsReminderSet?'Y':'N')+'</ALARM_ON>'
                                    +'<ALARM_NOTICE></ALARM_NOTICE>'
                                    +'<MTG_CONTACT_ID></MTG_CONTACT_ID>'
                                    +'<ORG_USRID>'+integrationUser+'</ORG_USRID>'
                                    +'<NBR_OF_REP_ATTENDEES></NBR_OF_REP_ATTENDEES>'
                                    +'<ENTRY_DT>'+parseDateTime(evt.CreatedDate)+'</ENTRY_DT>'
                                    +'<ENTRY_USR>'+ integrationUser+'</ENTRY_USR>'
                                    +'<UPD_DT>'+parseDateTime(evt.LastModifiedDate)+'</UPD_DT>'
                                    +'<UPD_USR>'+ integrationUser+'</UPD_USR>'
                                    +'<DIRECTIONS></DIRECTIONS>'
                                    +'<NBR_OF_EXT_ATTENDEES></NBR_OF_EXT_ATTENDEES>'
                                    +'<CAMPAIGN_ID></CAMPAIGN_ID>'
                                    +'<RECURRING_ID>'+parseNull(String.valueOf(evt.MarsReccurenceId__c))+'</RECURRING_ID>'
                                    +'<MTG_ADDR3></MTG_ADDR3>'
                                    +'<MTG_ADDR4></MTG_ADDR4>'
                                    +'<SFDC_EXTERNAL_ID>'+evt.Id+'</SFDC_EXTERNAL_ID>'
                                    +'<DIST_CHAN_CD></DIST_CHAN_CD>'
                                    +'<EXCEPTION_FLG></EXCEPTION_FLG>'
                                    +'<EXTERNAL_UID></EXTERNAL_UID>'
                                    +'<ATTENDEES>'+attendees+'</ATTENDEES>'
                                    +'<RECURRENCE>'+recuringInfo+'</RECURRENCE>'
                                    +'</'+objName.toUpperCase()+'>';
            }/*else if(objName =='FirmEvent'){
                eventEnvelopeString += '<'+objName.toUpperCase()+'>'
                                    +'<FIRM_ID>'+parseNull(mapFirmSummary.get(evt.AccountId).MarsFirmId__c)+'</FIRM_ID>'
                                    +'<EVENT_ID>'+parseNull(String.valueOf(evt.MarsActivityId__c))+'</EVENT_ID>'
                                    +'<ACT_TYPE>EV</ACT_TYPE>'
                                    +'<EVENT_PLACE></EVENT_PLACE>'
                                    +'<BEG_DT>'+evt.StartDateTime+'</BEG_DT>'
                                    +'<END_DT>'+evt.EndDateTime+'</END_DT>'
                                    +'<EVENT_TYPE>NC</EVENT_TYPE>'
                                    +'<EVENT_CONTACT_ID>'+(evt.WhoId != null? parseNull(mapContacts.get(evt.WhoId).MarsRepId__c):'')+'</EVENT_CONTACT_ID>'
                                    +'<ORG_USRID>'+integrationUser+'</ORG_USRID>'
                                    +'<STAT_CD>S</STAT_CD>'
                                    +'<EVENT_DESC>'+ parseNull(evt.Description) +'</EVENT_DESC>'
                                    +'<EVENT_ADDR1></EVENT_ADDR1>'
                                    +'<EVENT_ADDR2></EVENT_ADDR2>'
                                    +'<EVENT_CITY></EVENT_CITY>'
                                    +'<STATE_ID></STATE_ID>'
                                    +'<EVENT_ZIP></EVENT_ZIP>'
                                    +'<COUNTRY_CD></COUNTRY_CD>'
                                    +'<OTH_COST></OTH_COST>'
                                    +'<FULLFILMENT_COST></FULLFILMENT_COST>'
                                    +'<UPD_DT>'+ parseDateTime(evt.LastModifiedDate)+'</UPD_DT>'
                                    +'<UPD_USR>'+ integrationUser+'</UPD_USR>'
                                    +'<DIRECTIONS></DIRECTIONS>'
                                    +'<ENTRY_DT>'+parseDateTime(evt.CreatedDate)+'</ENTRY_DT>'
                                    +'<ENTRY_USR>'+integrationUser+'</ENTRY_USR>'
                                    +'<RECURRING_ID>'+parseNull(String.valueOf(evt.MarsReccurenceId__c))+'</RECURRING_ID>'
                                    +'<RECURRENCE>'+recuringInfo+ '</RECURRENCE>'
                                    +'<EVENT_ADDR3></EVENT_ADDR3>'
                                    +'<EVENT_ADDR4></EVENT_ADDR4>'
                                    +'<EXCEPTION_FLG></EXCEPTION_FLG>'
                                    +'<DIST_CHAN_CD></DIST_CHAN_CD>'
                                    +'<CAMPAIGN_ID></CAMPAIGN_ID>'
                                    +'<ATTENDEES>'+attendees+'</ATTENDEES>'+
                                    +'<EXTERNAL_ID>'+evt.Id+'</EXTERNAL_ID>'
                                    +'</'+objName.toUpperCase()+'>';
            }*/
        
        eventEnvelopeString +='</'+objName.toUpperCase()+'S></Mars'+objName+'DataSet>';
        return eventEnvelopeString;                                 
    }
    
    //Method to create XML envelope for rep record
    public static String taskEnvelope(Task tas,String objName) {
        Map<Id,EmailMessage> mapTaskEmailMsg=new Map<Id,EmailMessage>();
        List<Id> lstMessageIds=new List<Id>();
        
        
        String taskEnvelopeString ='<Mars'+objName+'DataSet xmlns="http://tempuri.org/Mars'+ objName +'.xsd"><'+objName.toUpperCase() +'S>';
        
        
        Map<Id,Contact> mapContacts;
        if(tas.WhoId != null)
        {
            mapContacts =new Map<Id,Contact>([Select Id,MarsRepId__c from Contact Where MarsRepId__c != null and Id = : tas.WhoId]);
        }
        
        //Wrapper class for status values
        String integrationUser = 'MARSINTG';
        
        String address1,address2,address3,address4; 
        
        //Populating envelope with the Actual values
        
        
        
        String recuringInfo='';
       
        if(objName =='Call')
        {
            if(tas.RecurrenceActivityId != null)
            {
                recuringInfo +='<RECURRENCEID>'+parseNull(tas.MarsReccurenceId__c)+'</RECURRENCEID>';
                if(tas.IsRecurrence){
                        recuringInfo +='<RECURRENCEDAYOFMONTH>'+parseNull(tas.recurrencedayofmonth)+'</RECURRENCEDAYOFMONTH>'
                                +'<ISRECURRENCE>'+tas.Isrecurrence+'</ISRECURRENCE>'
                                +'<RECURRENCEDAYOFWEEKMASK>'+parseNull(tas.recurrencedayofweekmask)+'</RECURRENCEDAYOFWEEKMASK>'
                                +'<RECURRENCEENDDATEONLY>'+parseDate(tas.recurrenceenddateonly)+'</RECURRENCEENDDATEONLY>'
                                +'<RECURRENCEINSTANCE>'+parseNull(tas.recurrenceinstance)+'</RECURRENCEINSTANCE>'
                                +'<RECURRENCEINTERVAL>'+parseNull(tas.recurrenceinterval)+'</RECURRENCEINTERVAL>'
                                +'<RECURRENCEMONTHOFYEAR>'+parseNull(tas.recurrencemonthofyear)+'</RECURRENCEMONTHOFYEAR>'
                                +'<RECURRENCESTARTDATETIME>'+parseDate(tas.RecurrenceStartDateOnly)+'</RECURRENCESTARTDATETIME>'
                                +'<RECURRENCETIMEZONESIDKEY>'+parseNull(tas.recurrencetimezonesidkey)+'</RECURRENCETIMEZONESIDKEY>'
                                +'<RECURRENCETYPE>'+parseNull(tas.recurrencetype)+'</RECURRENCETYPE>'
                                +'<RECURRENCEACTIVITYID>'+tas.RecurrenceActivityId+'</RECURRENCEACTIVITYID>';
                }
            }
            
            String callType=null;
            if(tas.Status =='Completed')
            {
                callType =parseNull(tas.MarsLogCall__c);
            }else{
                callType =parseNull(tas.MarsCallType__c);
            }
           
            taskEnvelopeString += '<'+objName.toUpperCase() +'>'
                                +'<ACTIVITY_ID>'+parseNull(String.valueOf(tas.MarsActivityId__c))+'</ACTIVITY_ID>' 
                                +'<REP_ID>'+mapContacts.get(tas.WhoId).MarsRepId__c+'</REP_ID>'
                                +'<USR_ID>'+ integrationUser+'</USR_ID>'
                                +'<CALL_TYPE>'+callType+'</CALL_TYPE>'
                                +'<CALL_PRIORITY>'+parseNull(tas.Priority) +'</CALL_PRIORITY>'
                                +'<BEG_DT>'+ (tas.ActivityDate == null?DateTime.now():tas.ActivityDate)+'</BEG_DT>'
                                +'<SCHEDULER>'+(tas.OwnerId == tas.CreatedById?'Y':'N') +'</SCHEDULER>'
                                +'<ALARM_NOTICE>0</ALARM_NOTICE>'
                                +'<ALARM_ON>'+(tas.IsReminderSet?'Y':'N')+'</ALARM_ON>'
                                +'<ENTRY_DT>'+parseDateTime(tas.CreatedDate)+'</ENTRY_DT>'
                                +'<ENTRY_USR>'+ integrationUser+'</ENTRY_USR>'
                                +'<RECURRING_ID>'+parseNull(String.valueOf(tas.MarsReccurenceId__c))+'</RECURRING_ID>'
                                +'<RECURRENCE>'+recuringInfo+'</RECURRENCE>'
                                +'<UPD_DT>'+parseDateTime(tas.LastModifiedDate)+'</UPD_DT>'
                                +'<UPD_USR>'+ integrationUser+'</UPD_USR>'
                                +'<DIST_CHAN_CD></DIST_CHAN_CD>'
                                +'<EXCEPTION_FLG></EXCEPTION_FLG>'
                                +'<CAMPAIGN_ID></CAMPAIGN_ID>'
                                +'<EXTERNAL_ID>'+tas.Id+'</EXTERNAL_ID>'
                                +'<NOTES>'+parseNull(tas.Description)+'</NOTES>'
                                +'<NOTE_TEXT>'+parseNull(tas.Description)+'</NOTE_TEXT>'
                                +'<TKT_ID></TKT_ID>'
                                +'<ACT_TYPE>'+(tas.Status =='Completed'?'CL':'TK')+'</ACT_TYPE>'
                                +'<CALL_INOUT>O</CALL_INOUT>'
                                +'<NOTES>'+parseNull(tas.Description)+'</NOTES>'
                                +'<STAT_CD>'+(tas.Status =='Completed'?'C':'T')+'</STAT_CD>'
                                //+'<LOGCALL>'+parseNull(tas.MarsLogCall__c)+'</LOGCALL>'
                                +'</'+objName.toUpperCase() +'>';
        }          
       
        if(objName =='Email')
        {    
            List<EmailMessage> lstMessage=[Select Id,ActivityId,CcAddress,MessageDate,Status,Subject,TextBody,HasAttachment,ToAddress from EmailMessage where ActivityId = : tas.Id];
            if(lstMessage.isEmpty())
            {
                return null;
            }else{
                for(EmailMessage message:lstMessage)
                {
                    if(message.HasAttachment)
                    {
                        lstMessageIds.add(message.Id);
                    }
                    if(message.ActivityId != null)
                    {
                        mapTaskEmailMsg.put(message.ActivityId,message);
                    }
                }
            }
            
            System.debug('Limits.getHeapSize==>'+Limits.getHeapSize());
            System.debug('Limits.getLimitHeapSize==>'+Limits.getLimitHeapSize());
            String attach='';
            String files='';
            if(!lstMessageIds.isEmpty())
            {
                for(Attachment att:[SELECT Body,BodyLength,ContentType,Id,Name,ParentId FROM Attachment where ParentId IN : lstMessageIds])
                {
                    attach +='<ATTACHMENT>'
                            +'<NAME>'+att.Name+'</NAME>'
                            +'<BODY>'+EncodingUtil.base64Encode(att.body)+'</BODY>'
                            +'</ATTACHMENT>';
                    files +='<FILE NAME="'+att.Name+'"' +' SIZE="'+ att.BodyLength +'"></FILE>';                    
                }
            }
            
            System.debug('Limits.getHeapSize==>'+Limits.getHeapSize());
            System.debug('Limits.getLimitHeapSize==>'+Limits.getLimitHeapSize());
            
            String emailStatus=mapTaskEmailMsg.get(tas.Id).Status;
            String status;
            String marsEmailStatus;
            if(emailStatus =='1')
            {
                status='Read';
                marsEmailStatus ='U';
            }else if(emailStatus =='2')
            {
                status='Replied';
                marsEmailStatus ='S';
            }else if(emailStatus =='3')
            {
                status='Sent';
                marsEmailStatus ='S';
            }else if(emailStatus =='4')
            {
                status='Forwarded';
                marsEmailStatus ='U';
            }    
            
            
             taskEnvelopeString += '<'+objName.toUpperCase() +'>'
                                +'<REP_ID>'+mapContacts.get(tas.WhoId).MarsRepId__c+'</REP_ID>'
                                +'<ACTIVITY_ID>'+parseNull(String.valueOf(tas.MarsActivityId__c))+'</ACTIVITY_ID>' 
                                +'<CC>'+parseNull(lstMessage[0].CcAddress)+'</CC>'
                                +'<TO_ADDRESS>'+parseNull(lstMessage[0].ToAddress)+'</TO_ADDRESS>'
                                +'<SUBJECT>'+parseNull(lstMessage[0].Subject)+'</SUBJECT>'
                                +'<FILES_ATTACHED><FILES>'+parseNull(files)+'</FILES></FILES_ATTACHED>'
                                +'<EMAIL_STAT>'+parseNull(marsEmailStatus) +'</EMAIL_STAT>'
                                +'<STATUS>'+parseNull(status)+'</STATUS>'
                                +'<SENT_DT>'+parseDateTime(lstMessage[0].MessageDate)+'</SENT_DT>'
                                +'<ENTRY_DT>'+parseDateTime(tas.CreatedDate)+'</ENTRY_DT>'
                                +'<ENTRY_USR>'+integrationUser+'</ENTRY_USR>'
                                +'<UPD_DT>'+parseDateTime(tas.LastModifiedDate)+'</UPD_DT>'
                                +'<UPD_USR>'+integrationUser+'</UPD_USR>'
                                +'<CAMPAIGN_ID></CAMPAIGN_ID>'
                                +'<EMAIL_BODY></EMAIL_BODY>'
                                +'<EXTERNAL_ID>'+parseNull(tas.Id)+'</EXTERNAL_ID>'
                                +'<TEMPLATE></TEMPLATE>'
                                +'<ISP_ID></ISP_ID>'
                                +'<SEND_CLASSIFICATION></SEND_CLASSIFICATION>'
                                +'<DIST_CHAN_CD></DIST_CHAN_CD>'
                                +'<ATTACHMENTS>'+parseNull(attach)+'</ATTACHMENTS>'
                                +'</'+objName.toUpperCase() +'>';
        }
        
        
        taskEnvelopeString +='</'+objName.toUpperCase() +'S></Mars'+objName+'DataSet>';
        System.debug(taskEnvelopeString);
        return taskEnvelopeString;                                
    }
    
    public static String noteEnvelope(Note note,String objName) {
        Map<Id,Contact> mapContacts;

        String integrationUser = 'MARSINTG';
        
        mapContacts =new Map<Id,Contact>([Select Id,MarsRepId__c from Contact Where MarsRepId__c != null and Id = : note.ParentId]);
        String noteEnvelopeString ='<MarsRepNotesDataSet xmlns="http://tempuri.org/MarsRepNotes.xsd"><REPNOTES>'
                              +'<REP_ID>'+parseNull(mapContacts.get(note.ParentId).MarsRepId__c)+'</REP_ID>'
                              +'<REP_NOTE>'+parseNull(note.Body)+'</REP_NOTE>'
                              +'<REP_NOTE_ID>'+parseNull(note.Title)+'</REP_NOTE_ID>'
                              +'<NOTE_BY>'+integrationUser+'</NOTE_BY>'
                              +'<EXTERNAL_ID>'+parseNull(note.Id)+'</EXTERNAL_ID>'
                              +'<UPD_DT>'+parseDateTime(note.LastModifiedDate)+'</UPD_DT>'
                              +'<UPD_USR>'+integrationUser+'</UPD_USR>'
                              +'<SYSTEM_FLG></SYSTEM_FLG>'
                              +'</REPNOTES></MarsRepNotesDataSet>';
                              
        System.debug(noteEnvelopeString);                      
        return noteEnvelopeString;
        
        return null;
    }

    //Check for Null and if yes, then return blank
    public static String parseNull(String value) {

        //Return blank if value is null
        if(value == null)
            return '';
            

        //return original value
        return '<![CDATA['+value+']]>';
    }
    
    public static String parseNull(Decimal value) {

        //Return blank if value is null
        if(value == null)
            return '';
            

        //return original value
        return '<![CDATA['+value+']]>';
    }
    
    public static String parseDate(Date value) {

        //Return blank if value is null
        if(value == null)
            return '';

        //return original value
        System.debug('\n\n Exact Value: '+datetime.newinstance(value, time.newinstance(0,0,0,0)).format('MM/dd/yyyy'));
        return datetime.newinstance(value, time.newinstance(0,0,0,0)).format('MM/dd/yyyy');
    }
    public static String parseDateTime(Datetime value) {

        //Return blank if value is null
        if(value == null)
            return '';

        //return original value
        System.debug('\n\n Exact Value: '+value.format('MM/dd/yyyy h:mm:ss a'));
        return value.format('MM/dd/yyyy h:mm:ss a',UserInfo.getTimeZone().getID());
    }
}