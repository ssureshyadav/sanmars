global Class MARSActivityApexGateway{

    global class ACK 
    {
        webservice String SFDCObjectId;
        webservice String MarsObjectId;
        webservice boolean Result;
        webservice String ErrorMessage;
    }
    
    //FirmEvent
    /*webservice static List<ACK> SyncFirmEvent(String firmEventXML)
    {
        System.debug(firmEventXML);
        List<ACK> lstResponse=new List<ACK>();           
        try
        {
            Map<String, List<Sobject>> marsFirmEvent=MarsActivitySyncMessageParser.parseFirmEvent(firmEventXML);
            System.debug(marsFirmEvent);
            if(marsFirmEvent.containsKey('Success'))
            {
                List<Event> lstFirmEvent=marsFirmEvent.get('Success');
                if(!lstFirmEvent.IsEmpty())
                { 
                    //Bypassing the trigger                        
                    MarsActivityUtility.BYPASS_ALL_TRIGGER=true;
                    if(!MARSActivityUtility.setRecurrenceId.isEmpty())
                    {
                        Map<Date,Id> mapactivityDate=new Map<Date,Id>();
                        for(Event evt:[Select Id,ActivityDate,ActivityDateTime from Event where isrecurrence =false and RecurrenceActivityId IN : MARSActivityUtility.setRecurrenceId])
                        {
                            mapactivityDate.put(evt.ActivityDate,evt.Id);
                        }
                        
                        System.debug(mapactivityDate);
                        for(Event evt:lstFirmEvent)
                        {
                            System.debug(evt.StartDateTime);
                            System.debug(evt.StartDateTime.Date());
                            if(mapactivityDate.containsKey(evt.StartDateTime.Date()))
                            {
                                evt.Id =mapactivityDate.get(evt.StartDateTime.Date());
                                System.debug(evt.Id);
                            }
                        }
                    }
                    List<Database.UpsertResult> result= Database.upsert(lstFirmEvent, false);
                    MarsActivityUtility.BYPASS_ALL_TRIGGER=false;                     
                    
                    if(marsFirmEvent.containsKey('SuccessEventRelation'))
                    {
                        List<EventRelation> lstRelation=new List<EventRelation>();
                        List<EventRelation> lstevtRelation=marsFirmEvent.get('SuccessEventRelation');
                        for(Integer i=0;i<result.size();i++)
                        {
                            for(EventRelation relation:lstevtRelation)
                            {
                                if(relation.Status == String.valueOf(lstFirmEvent[i].MarsActivityId__c))
                                {
                                   EventRelation evt=relation.clone();
                                   evt.EventId =result[i].Id;
                                   System.debug('Owner Id:'+lstFirmEvent[i].OwnerId);
                                   if(lstFirmEvent[i].OwnerId != evt.RelationId)
                                   {
                                       evt.Status ='New';
                                       lstRelation.add(evt);
                                   }
                                }
                            }
                        }
                        
                        if(!lstRelation.isEmpty())
                        {
                            List<Database.UpsertResult> eventRelationresult= Database.upsert(lstRelation, false);
                            System.debug(eventRelationresult);
                        }
                    }
                    
                    for(Integer i=0;i<result.size();i++)
                    {
                        ACK objSFDCResponse=new ACK();
                        if(result[i].isSuccess())
                        {
                            // Assigning Salesforce ids to SFDCObjectId
                            objSFDCResponse.SFDCObjectId=result[i].Id;
                            // Assigning rep ids(EXTERNAL_ID__c in salesforce) to MarsObjectId
                            if(lstFirmEvent[i].MarsActivityId__c !=null)
                            {
                                objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstFirmEvent[i].MarsActivityId__c)+']]>';
                            }else{
                                objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstFirmEvent[i].MARSReccurenceId__c)+']]>';
                            }
                            objSFDCResponse.Result=result[i].isSuccess();
                        }
                        else
                        {
                            objSFDCResponse.SFDCObjectId='';
                            if(lstFirmEvent[i].MarsActivityId__c !=null)
                            {
                                objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstFirmEvent[i].MarsActivityId__c)+']]>';
                            }else{
                                objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstFirmEvent[i].MARSReccurenceId__c)+']]>';
                            }
                            objSFDCResponse.Result=result[i].isSuccess();
                            objSFDCResponse.ErrorMessage=result[i].errors[0].message+result[i].errors[0].fields;
                        }
                        // Adding the upsertresult object to list
                        lstResponse.add(objSFDCResponse);
                    }
                }
            }
            if(marsFirmEvent.containsKey('Errors'))
            {
                List<Event> errorFirmEvent=marsFirmEvent.get('Errors');
                //if(errorProducts.size()>0)
                if(!errorFirmEvent.IsEmpty())
                {
                    for(integer i=0;i<errorFirmEvent.size();i++){
                    ACK objSFDCResponse=new ACK();
                    if(errorFirmEvent[i].MarsActivityId__c !=null)
                    {
                        objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(errorFirmEvent[i].MarsActivityId__c)+']]>';
                    }else{
                        objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(errorFirmEvent[i].MARSReccurenceId__c)+']]>';
                    }
                    
                    objSFDCResponse.Result=false;
                    objSFDCResponse.ErrorMessage=errorFirmEvent[i].Description;
                    lstResponse.add(objSFDCResponse);
                    }
                }
            }
        }
        catch(exception e)
        {
            ACK objSFDCResponse=new ACK();
            objSFDCResponse.Result=false;
            objSFDCResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();    
            lstResponse.add(objSFDCResponse);
        }
        System.debug('\n Response Output:'+lstResponse);
        return lstResponse;
    }*/
    
    //Meeting
    webservice static List<ACK> SyncMeeting(String meetingXML)
    {
        System.debug(meetingXML);
        List<ACK> lstResponse=new List<ACK>();           
        try
        {
            Map<String, List<Sobject>> marsMeeting=MarsActivitySyncMessageParser.parseMeeting(meetingXML);
            System.debug(marsMeeting);
            if(marsMeeting.containsKey('Success'))
            {
                List<Event> lstMeeting=marsMeeting.get('Success');
                if(!lstMeeting.IsEmpty())
                { 
                    //Bypassing the trigger                        
                    MarsActivityUtility.BYPASS_ALL_TRIGGER=true;
                   /* if(!MARSActivityUtility.mapSFDCActivityId.isEmpty())
                    {
                        MARSActivityUtility.updateRecurrence();
                    }*/
                    if(!MARSActivityUtility.setRecurrenceId.isEmpty())
                    {
                        Map<Date,Id> mapactivityDate=new Map<Date,Id>();
                        for(Event evt:[Select Id,ActivityDate,ActivityDateTime from Event where isrecurrence =false and RecurrenceActivityId IN : MARSActivityUtility.setRecurrenceId])
                        {
                            mapactivityDate.put(evt.ActivityDate,evt.Id);
                        }
                        
                        System.debug(mapactivityDate);
                        for(Event evt:lstMeeting)
                        {
                            System.debug(evt.StartDateTime);
                            System.debug(evt.StartDateTime.Date());
                            if(mapactivityDate.containsKey(evt.StartDateTime.Date()))
                            {
                                evt.Id =mapactivityDate.get(evt.StartDateTime.Date());
                                System.debug(evt.Id);
                            }
                        }
                    }
                    List<Database.UpsertResult> result= Database.upsert(lstMeeting, false);
                    MarsActivityUtility.BYPASS_ALL_TRIGGER=false;                     
                    
                    if(marsMeeting.containsKey('SuccessEventRelation'))
                    {
                        List<EventRelation> lstRelation=new List<EventRelation>();
                        List<EventRelation> lstevtRelation=marsMeeting.get('SuccessEventRelation');
                        for(Integer i=0;i<result.size();i++)
                        {
                            for(EventRelation relation:lstevtRelation)
                            {
                                if(relation.Status == String.valueOf(lstMeeting[i].MarsActivityId__c))
                                {
                                   EventRelation evt=relation.clone();
                                   evt.EventId =result[i].Id;
                                   if(lstMeeting[i].WhoId != evt.RelationId)
                                   {
                                       evt.Status ='New';
                                       lstRelation.add(evt);
                                   }
                                   
                                }
                            }
                        }
                        
                        if(!lstRelation.isEmpty())
                        {
                            List<Database.UpsertResult> eventRelationresult= Database.upsert(lstRelation, false);
                            System.debug(eventRelationresult);
                        }
                    }
                    
                    for(Integer i=0;i<result.size();i++)
                    {
                        ACK objSFDCResponse=new ACK();
                        if(result[i].isSuccess())
                        {
                            // Assigning Salesforce ids to SFDCObjectId
                            objSFDCResponse.SFDCObjectId=result[i].Id;
                            // Assigning rep ids(EXTERNAL_ID__c in salesforce) to MarsObjectId
                            if(lstMeeting[i].MarsActivityId__c != null)
                            {
                                objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstMeeting[i].MarsActivityId__c)+']]>';
                            }else{
                                objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstMeeting[i].MARSReccurenceId__c)+']]>';
                            }
                            objSFDCResponse.Result=result[i].isSuccess();
                        }
                        else
                        {
                            objSFDCResponse.SFDCObjectId='';
                            if(lstMeeting[i].MarsActivityId__c != null)
                            {
                                objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstMeeting[i].MarsActivityId__c)+']]>';
                            }else{
                                objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstMeeting[i].MARSReccurenceId__c)+']]>';
                            }
                            objSFDCResponse.Result=result[i].isSuccess();
                            objSFDCResponse.ErrorMessage=result[i].errors[0].message+result[i].errors[0].fields;
                        }
                        // Adding the upsertresult object to list
                        lstResponse.add(objSFDCResponse);
                    }
                }
            }
            if(marsMeeting.containsKey('Errors'))
            {
                List<Event> errorMeeting=marsMeeting.get('Errors');
                //if(errorProducts.size()>0)
                if(!errorMeeting.IsEmpty())
                {
                    for(integer i=0;i<errorMeeting.size();i++){
                    ACK objSFDCResponse=new ACK();
                    if(errorMeeting[i].MarsActivityId__c != null)
                    {
                        objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(errorMeeting[i].MarsActivityId__c)+']]>';
                    }else{
                        objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(errorMeeting[i].MARSReccurenceId__c)+']]>';
                    }
                    objSFDCResponse.Result=false;
                    objSFDCResponse.ErrorMessage=errorMeeting[i].Description;
                    lstResponse.add(objSFDCResponse);
                    }
                }
            }
        }
        catch(exception e)
        {
            ACK objSFDCResponse=new ACK();
            objSFDCResponse.Result=false;
            objSFDCResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();    
            lstResponse.add(objSFDCResponse);
        }
        System.debug('\n Response Output:'+lstResponse);
        return lstResponse;
    }
    
    //Call
    webservice static List<ACK> SyncCall(String CallXML)
    {
        System.debug(CallXML);
        List<ACK> lstResponse=new List<ACK>();           
        try
        {
            Map<String, List<Task>> marsCall=MarsActivitySyncMessageParser.parseCall(CallXML);
            System.debug(marsCall);
            if(marsCall.containsKey('Success'))
            {
                List<Task> lstCall=marsCall.get('Success');
                if(!lstCall.IsEmpty())
                { 
                    //Bypassing the trigger                        
                    MarsActivityUtility.BYPASS_ALL_TRIGGER=true;
                    /*if(!MARSActivityUtility.mapSFDCActivityId.isEmpty())
                    {
                        MARSActivityUtility.updateRecurrence();
                    }*/
                    if(!MARSActivityUtility.setRecurrenceId.isEmpty())
                    {
                        Map<Date,Id> mapactivityDate=new Map<Date,Id>();
                        for(Task tas:[Select Id,ActivityDate from Task where isrecurrence =false and RecurrenceActivityId IN : MARSActivityUtility.setRecurrenceId])
                        {
                            mapactivityDate.put(tas.ActivityDate,tas.Id);
                        }
                        
                        System.debug(mapactivityDate);
                        for(Task tas:lstCall)
                        {
                            if(mapactivityDate.containsKey(tas.ActivityDate))
                            {
                                tas.Id =mapactivityDate.get(tas.ActivityDate);
                            }
                        }
                    }
                    List<Database.UpsertResult> result= Database.upsert(lstCall, false);
    
                    //Enable the trigger                        
                    MarsActivityUtility.BYPASS_ALL_TRIGGER=false;                     
                    // looping the upsertcontacts results to get the salesforce ids and mars rep ids.
                    for(Integer i=0;i<result.size();i++)
                    {
                        ACK objSFDCResponse=new ACK();
                        if(result[i].isSuccess())
                        {
                            // Assigning Salesforce ids to SFDCObjectId
                            objSFDCResponse.SFDCObjectId=result[i].Id;
                            // Assigning rep ids(EXTERNAL_ID__c in salesforce) to MarsObjectId
                            if(lstCall[i].MarsActivityId__c != null)
                            {
                                objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstCall[i].MarsActivityId__c)+']]>';
                            }else{
                                objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstCall[i].MARSReccurenceId__c)+']]>';
                            }
                            objSFDCResponse.Result=result[i].isSuccess();
                        }
                        else
                        {
                            objSFDCResponse.SFDCObjectId='';
                          
                            // Assigning rep ids(EXERNAL_ID__c in salesforce) to MarsObjectId
                            if(lstCall[i].MarsActivityId__c != null)
                            {
                                objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstCall[i].MarsActivityId__c)+']]>';
                            }else{
                                objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstCall[i].MARSReccurenceId__c)+']]>';
                            }
                            objSFDCResponse.Result=result[i].isSuccess();
                            objSFDCResponse.ErrorMessage=result[i].errors[0].message+result[i].errors[0].fields;
                        }
                        // Adding the upsertresult object to list
                        lstResponse.add(objSFDCResponse);
                    }
                }
            }
            if(marsCall.containsKey('Errors'))
            {
                List<Task> errorCall=marsCall.get('Errors');
                //if(errorProducts.size()>0)
                if(!errorCall.IsEmpty())
                {
                    for(integer i=0;i<errorCall.size();i++){
                    ACK objSFDCResponse=new ACK();
                    if(errorCall[i].MarsActivityId__c != null)
                    {
                        objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(errorCall[i].MarsActivityId__c)+']]>';
                    }else{
                        objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(errorCall[i].MARSReccurenceId__c)+']]>';
                    }
                    objSFDCResponse.Result=false;
                    objSFDCResponse.ErrorMessage=errorCall[i].Description;
                    lstResponse.add(objSFDCResponse);
                    }
                }
            }
        }
        catch(exception e)
        {
            ACK objSFDCResponse=new ACK();
            objSFDCResponse.Result=false;
            objSFDCResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();    
            lstResponse.add(objSFDCResponse);
            // Creating the Errorlogging record.
        }
        System.debug('\n Response Output:'+lstResponse);
        return lstResponse;
    }
    
    //Email
    webservice static List<ACK> SyncEmail(String EmailXML)
    {
        System.debug(EmailXML);
        List<ACK> lstResponse=new List<ACK>();           
        try
        {
            Map<String, List<Sobject>> marsEmail=MarsActivitySyncMessageParser.parseEmail(EmailXML);
            System.debug(marsEmail);
            if(marsEmail.containsKey('Success'))
            {
                List<Task> lstEmail=marsEmail.get('Success');
                if(!lstEmail.IsEmpty())
                { 
                    //Bypassing the trigger                        
                    MarsActivityUtility.BYPASS_ALL_TRIGGER=true;
                    List<Database.UpsertResult> result= Database.upsert(lstEmail, false);
                    MarsActivityUtility.BYPASS_ALL_TRIGGER=false;
                    
                    if(marsEmail.containsKey('MessageSuccess'))
                    {
                        List<EmailMessage> lstMessage=new List<EmailMessage>();
                        List<EmailMessage> lstEmailMessage=marsEmail.get('MessageSuccess');
                        for(Integer i=0;i<result.size();i++)
                        {
                            for(EmailMessage message:lstEmailMessage)
                            {
                                if(message.Subject == String.valueOf(lstEmail[i].Subject))
                                {
                                   //message.RelatedToId=  result[i].Id;
                                   lstMessage.add(message);
                                }
                            }
                        }
                        
                        if(!lstMessage.isEmpty())
                        {
                            List<Database.UpsertResult> emailMessageresult= Database.upsert(lstMessage, false);
                            System.debug(emailMessageresult);
                        }
                    }
                                         
                    // looping the upsertcontacts results to get the salesforce ids and mars rep ids.
                    for(Integer i=0;i<result.size();i++)
                    {
                        ACK objSFDCResponse=new ACK();
                        if(result[i].isSuccess())
                        {
                            // Assigning Salesforce ids to SFDCObjectId
                            objSFDCResponse.SFDCObjectId=result[i].Id;
                            // Assigning rep ids(EXTERNAL_ID__c in salesforce) to MarsObjectId
                            objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstEmail[i].MarsActivityId__c)+']]>';
                            objSFDCResponse.Result=result[i].isSuccess();
                        }
                        else
                        {
                            objSFDCResponse.SFDCObjectId='';
                          
                            // Assigning rep ids(EXERNAL_ID__c in salesforce) to MarsObjectId
                            objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstEmail[i].MarsActivityId__c)+']]>';
                            objSFDCResponse.Result=result[i].isSuccess();
                            objSFDCResponse.ErrorMessage=result[i].errors[0].message+result[i].errors[0].fields;
                        }
                        // Adding the upsertresult object to list
                        lstResponse.add(objSFDCResponse);
                    }
                }
            }
            if(marsEmail.containsKey('Errors'))
            {
                List<Task> errorEmail=marsEmail.get('Errors');
                //if(errorProducts.size()>0)
                if(!errorEmail.IsEmpty())
                {
                    for(integer i=0;i<errorEmail.size();i++){
                    ACK objSFDCResponse=new ACK();
                    objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(errorEmail[i].MarsActivityId__c)+']]>';
                    objSFDCResponse.Result=false;
                    objSFDCResponse.ErrorMessage=errorEmail[i].Description;
                    lstResponse.add(objSFDCResponse);
                    }
                }
            }
        }
        catch(exception e)
        {
            ACK objSFDCResponse=new ACK();
            objSFDCResponse.Result=false;
            objSFDCResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();    
            lstResponse.add(objSFDCResponse);
            // Creating the Errorlogging record.
        }
        System.debug('\n Response Output:'+lstResponse);
        return lstResponse;
    }
    
    //Rep notes
    webservice static List<ACK> SyncRepNotes(String RepNotesXML)
    {
        System.debug(RepNotesXML);
        List<ACK> lstResponse=new List<ACK>();           
        try
        {
            Map<String, List<ContentNote>> marsRepNotes=MarsActivitySyncMessageParser.parseNotes(RepNotesXML);
            List<ContentDocumentLink> listCDocumentLink=new List<ContentDocumentLink>();
            if(marsRepNotes.containsKey('Success'))
            {
                List<ContentNote> lstNote=marsRepNotes.get('Success');
                if(!lstNote.IsEmpty())
                { 
                    List<ContentNote> insNote=new List<ContentNote>();
                    List<ContentNote> updNote=new List<ContentNote>();
                    for(ContentNote chkNote:lstNote)
                    {
                        if(chkNote.Id != null)
                        {
                            updNote.add(chkNote);
                        }else{
                            insNote.add(chkNote);
                        }
                    }
                    //Bypassing the trigger                        
                    MarsActivityUtility.BYPASS_ALL_TRIGGER=true;
                    List<Database.saveResult> result=new List<Database.saveResult>();
                    if(!updNote.isEmpty())
                    {
                        result.addAll(Database.Update(updNote, false));
                    }
                    
                    if(!insNote.isEmpty())
                    {
                        result.addAll(Database.insert(insNote, false));
                    }
                         
                    // looping the upsertcontacts results to get the salesforce ids and mars rep ids.
                    for(Integer i=0;i<result.size();i++)
                    {
                        ACK objSFDCResponse=new ACK();
                        if(result[i].isSuccess())
                        {
                            // Assigning Salesforce ids to SFDCObjectId
                            objSFDCResponse.SFDCObjectId=result[i].Id;
                            if(MARSActivityUtility.mapSFDCActivityId.containsKey(Decimal.valueOf(lstNote[i].Title)))
                            {
                                ContentDocumentLink link=new ContentDocumentLink();
                                link.ContentDocumentId =result[i].Id;
                                link.LinkedEntityId = MARSActivityUtility.mapSFDCActivityId.get(Decimal.valueOf(lstNote[i].Title));
                                link.ShareType ='V';
                                listCDocumentLink.add(link);
                            }
                            
                            // Assigning rep ids(EXTERNAL_ID__c in salesforce) to MarsObjectId
                            if(lstNote[i].Title != null)
                            {
                                objSFDCResponse.MarsObjectId='<![CDATA['+lstNote[i].Title+']]>';
                            }
                            objSFDCResponse.Result=result[i].isSuccess();
                        }
                        else
                        {
                            objSFDCResponse.SFDCObjectId='';
                          
                            // Assigning rep ids(EXERNAL_ID__c in salesforce) to MarsObjectId
                            if(lstNote[i].Title != null)
                            {
                                objSFDCResponse.MarsObjectId='<![CDATA['+lstNote[i].Title+']]>';
                            }
                            objSFDCResponse.Result=result[i].isSuccess();
                            objSFDCResponse.ErrorMessage=result[i].errors[0].message+result[i].errors[0].fields;
                        }
                        // Adding the upsertresult object to list
                        lstResponse.add(objSFDCResponse);
                    }
                    
                    if(!listCDocumentLink.isEmpty())
                    {
                        List<Database.UpsertResult> cDocLinkresult= Database.upsert(listCDocumentLink, false);
                    }
                    MarsActivityUtility.BYPASS_ALL_TRIGGER=false;
                }
            }
            if(marsRepNotes.containsKey('Errors'))
            {
                List<ContentNote> errorNote=marsRepNotes.get('Errors');
                //if(errorProducts.size()>0)
                if(!errorNote.IsEmpty())
                {
                    for(integer i=0;i<errorNote.size();i++){
                    ACK objSFDCResponse=new ACK();
                    if(errorNote[i].Title != null)
                    {
                        objSFDCResponse.MarsObjectId='<![CDATA['+errorNote[i].Title+']]>';
                    }
                    objSFDCResponse.Result=false;
                    objSFDCResponse.ErrorMessage=errorNote[i].Content.toString();
                    lstResponse.add(objSFDCResponse);
                    }
                }
            }
        }
        catch(exception e)
        {
            ACK objSFDCResponse=new ACK();
            objSFDCResponse.Result=false;
            objSFDCResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();    
            lstResponse.add(objSFDCResponse);
            // Creating the Errorlogging record.
        }
        System.debug('\n Response Output:'+lstResponse);
        return lstResponse;
    }
    
    webservice static List<ACK> SyncActivityDelete(String deleteXML)
    {
        System.debug(deleteXML);
        List<ACK> lstResponse=new List<ACK>();
    
        try
        {
            Map<String, List<Sobject>> deleteRecords=MarsActivitySyncMessageParser.parseActivityDelete(deleteXML);
            String objectType;
            List<Event> lstEventDelete;
            List<Task> lstTaskDelete;
    
            if(deleteRecords.containsKey('EventSuccess') || deleteRecords.containsKey('EventErrors'))
            {
               objectType = 'Event';
            }
            else if(deleteRecords.containsKey('TaskSuccess') || deleteRecords.containsKey('TaskErrors'))
            {
                objectType = 'Task';
            }
             
            System.debug('\n Object Type:'+objectType);
            if(objectType=='Event')
            {
                if(deleteRecords.containsKey('EventSuccess'))
                {
                    lstEventDelete=deleteRecords.get('EventSuccess');
                    System.debug('\n List Size()'+lstEventDelete.size());
                    
                    if(!lstEventDelete.IsEmpty())
                    {                    
                        MarsActivityUtility.BYPASS_ALL_TRIGGER=true;
                        List<Database.DeleteResult> deleteResult = Database.Delete(lstEventDelete);
                        MarsActivityUtility.BYPASS_ALL_TRIGGER=false;
                        for(integer i=0;i<deleteresult.size();i++)
                        {
                            ACK objSFDCResponse=new ACK();
                            if(deleteresult[i].isSuccess())
                            {
                                objSFDCResponse.SFDCObjectId=deleteresult[i].Id;
                                objSFDCResponse.MarsObjectId=String.valueOf(lstEventDelete[i].MarsActivityId__c);
                                objSFDCResponse.Result=deleteresult[i].isSuccess();
                            }
                            else
                            {
                                objSFDCResponse.SFDCObjectId=deleteresult[i].Id;
                                objSFDCResponse.MarsObjectId=String.valueOf(lstEventDelete[i].MarsActivityId__c);
                                objSFDCResponse.Result=deleteresult[i].isSuccess();
                                objSFDCResponse.ErrorMessage=deleteresult[i].errors[0].message;
                            }
                            lstResponse.add(objSFDCResponse);
                        }
                    }
                }
                if(deleteRecords.containsKey('EventErrors'))
                {
                    lstEventDelete=deleteRecords.get('EventErrors');
                    
                    if(!lstEventDelete.IsEmpty())
                    {                        
                        System.debug('\n in Error Block');
                        for(integer i=0;i<lstEventDelete.size();i++)
                        {
                            ACK objSFDCResponse=new ACK();
                            objSFDCResponse.MarsObjectId=String.valueOf(lstEventDelete[i].MarsActivityId__c);
                            objSFDCResponse.Result=false;
                            objSFDCResponse.ErrorMessage=lstEventDelete[i].Description;
                            if(objSFDCResponse.ErrorMessage == 'External Id not found in SFDC')
                            {
                                List<Event> lstEvent=[SELECT Id FROM Event WHERE MarsActivityId__c = :lstEventDelete[i].MarsActivityId__c];
                                if(!lstEvent.isEmpty())
                                {
                                    MarsActivityUtility.BYPASS_ALL_TRIGGER =true;
                                    delete lstEvent;
                                    MarsActivityUtility.BYPASS_ALL_TRIGGER =false;
                                }
                                objSFDCResponse.Result = true; 
                            }
                            lstResponse.add(objSFDCResponse);
                        }
                    }
                }
            }
            else if(objectType=='Task')
            {
                if(deleteRecords.containsKey('TaskSuccess'))
                {
                    lstTaskDelete=deleteRecords.get('TaskSuccess');
                    if(!lstTaskDelete.IsEmpty())
                    {
                        MarsActivityUtility.BYPASS_ALL_TRIGGER=true;
                        List<Database.DeleteResult> deleteResult = Database.Delete(lstTaskDelete,false);
                        System.debug('\n Delete Result'+deleteResult);
                        MarsActivityUtility.BYPASS_ALL_TRIGGER=false;
                        for(integer i=0;i<deleteresult.size();i++)
                        {
                            ACK objSFDCResponse=new ACK();
                            if(deleteresult[i].isSuccess())
                            {
                                objSFDCResponse.SFDCObjectId=deleteresult[i].Id;
                                objSFDCResponse.MarsObjectId=String.valueOf(lstTaskDelete[i].MarsActivityId__c);
                                objSFDCResponse.Result=deleteresult[i].isSuccess();
                            }
                            else
                            {
                                objSFDCResponse.SFDCObjectId=deleteresult[i].Id;
                                objSFDCResponse.MarsObjectId=String.valueOf(lstTaskDelete[i].MarsActivityId__c);
                                objSFDCResponse.Result=deleteresult[i].isSuccess();
                                objSFDCResponse.ErrorMessage=deleteresult[i].errors[0].message;
                            }
                            lstResponse.add(objSFDCResponse);
                        }
                    }
                }
                if(deleteRecords.containsKey('TaskErrors'))
                {
                    lstTaskDelete=deleteRecords.get('TaskErrors');
                    if(!lstTaskDelete.IsEmpty())
                    {
                        for(integer i=0;i<lstTaskDelete.size();i++)
                        {
                            ACK objSFDCResponse=new ACK();
                            objSFDCResponse.MarsObjectId=String.valueOf(lstTaskDelete[i].MarsActivityId__c);
                            objSFDCResponse.ErrorMessage=lstTaskDelete[i].Description;
                            objSFDCResponse.Result=false;
                            if(objSFDCResponse.ErrorMessage == 'External Id not found in SFDC')
                            {
                                List<Task> lstTask=[SELECT Id FROM Task WHERE MarsActivityId__c = :lstTaskDelete[i].MarsActivityId__c];
                                if(!lstTask.isEmpty())
                                {
                                    MarsActivityUtility.BYPASS_ALL_TRIGGER =true;
                                    delete lstTask;
                                    MarsActivityUtility.BYPASS_ALL_TRIGGER =false;
                                }
                                objSFDCResponse.Result = true; 
                            }
                            lstResponse.add(objSFDCResponse);
                        }
                    }
                }
            }
        }
        catch (exception e)
        {
            ACK objSFDCResponse=new ACK();
            objSFDCResponse.Result=false;
            objSFDCResponse.MarsObjectId='';
            objSFDCResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();
            lstResponse.add(objSFDCResponse);
            System.debug(e.getStackTraceString()+'--'+e.getmessage());
        }
        System.debug('\n Output Response:'+lstResponse);
        return lstResponse;
    }
}