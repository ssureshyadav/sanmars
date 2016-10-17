global Class MARSActivityApexGateway{

    global class ACK 
    {
        webservice String SFDCObjectId;
        webservice String MarsObjectId;
        webservice boolean Result;
        webservice String ErrorMessage;
    }
    
    //FirmEvent
    webservice static List<ACK> SyncFirmEvent(String firmEventXML)
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
                            objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstFirmEvent[i].MarsActivityId__c)+']]>';
                            objSFDCResponse.Result=result[i].isSuccess();
                        }
                        else
                        {
                            objSFDCResponse.SFDCObjectId='';
                            objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstFirmEvent[i].MarsActivityId__c)+']]>';
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
                    objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(errorFirmEvent[i].MarsActivityId__c)+']]>';
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
    }
    
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
                            objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstMeeting[i].MarsActivityId__c)+']]>';
                            objSFDCResponse.Result=result[i].isSuccess();
                        }
                        else
                        {
                            objSFDCResponse.SFDCObjectId='';
                            objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstMeeting[i].MarsActivityId__c)+']]>';
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
                    objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(errorMeeting[i].MarsActivityId__c)+']]>';
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
                            objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstCall[i].MarsActivityId__c)+']]>';
                            objSFDCResponse.Result=result[i].isSuccess();
                        }
                        else
                        {
                            objSFDCResponse.SFDCObjectId='';
                          
                            // Assigning rep ids(EXERNAL_ID__c in salesforce) to MarsObjectId
                            objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstCall[i].MarsActivityId__c)+']]>';
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
                    objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(errorCall[i].MarsActivityId__c)+']]>';
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
    
      //Tickler
    webservice static List<ACK> SyncTickler(String ticklerXML)
    {
        System.debug(ticklerXML);
        List<ACK> lstResponse=new List<ACK>();           
        try
        {
            Map<String, List<Task>> marsTickler=MarsActivitySyncMessageParser.parseTickler(ticklerXML);
            System.debug(marsTickler);
            if(marsTickler.containsKey('Success'))
            {
                List<Task> lstTickler=marsTickler.get('Success');
                if(!lstTickler.IsEmpty())
                { 
                    //Bypassing the trigger                        
                    MarsActivityUtility.BYPASS_ALL_TRIGGER=true;
                    List<Database.UpsertResult> result= Database.upsert(lstTickler, false);
    
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
                            objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstTickler[i].MarsActivityId__c)+']]>';
                            objSFDCResponse.Result=result[i].isSuccess();
                        }
                        else
                        {
                            objSFDCResponse.SFDCObjectId='';
                          
                            // Assigning rep ids(EXERNAL_ID__c in salesforce) to MarsObjectId
                            objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstTickler[i].MarsActivityId__c)+']]>';
                            objSFDCResponse.Result=result[i].isSuccess();
                            objSFDCResponse.ErrorMessage=result[i].errors[0].message+result[i].errors[0].fields;
                        }
                        // Adding the upsertresult object to list
                        lstResponse.add(objSFDCResponse);
                    }
                }
            }
            if(marsTickler.containsKey('Errors'))
            {
                List<Task> errorTickler=marsTickler.get('Errors');
                //if(errorProducts.size()>0)
                if(!errorTickler.IsEmpty())
                {
                    for(integer i=0;i<errorTickler.size();i++){
                    ACK objSFDCResponse=new ACK();
                    objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(errorTickler[i].MarsActivityId__c)+']]>';
                    objSFDCResponse.Result=false;
                    objSFDCResponse.ErrorMessage=errorTickler[i].Description;
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
    
    //Recurrence
    webservice static List<ACK> SyncRecurrence(String recurenceXML)
    {
        System.debug(recurenceXML);
        List<ACK> lstResponse=new List<ACK>();           
        try
        {
            Map<String, List<Sobject>> marsRecurrence=MarsActivitySyncMessageParser.parseRecurrence(recurenceXML);
            System.debug(marsRecurrence);
            if(marsRecurrence.containsKey('EventSuccess'))
            {
                List<Event> lstRecurrence=marsRecurrence.get('EventSuccess');
                if(!lstRecurrence.IsEmpty())
                { 
                    //Bypassing the trigger                        
                    MarsActivityUtility.BYPASS_ALL_TRIGGER=true;
                    List<Database.UpsertResult> result= Database.upsert(lstRecurrence, false);
    
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
                            objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstRecurrence[i].MarsReccurenceId__c)+']]>';
                            objSFDCResponse.Result=result[i].isSuccess();
                        }
                        else
                        {
                            objSFDCResponse.SFDCObjectId='';
                          
                            // Assigning rep ids(EXERNAL_ID__c in salesforce) to MarsObjectId
                            objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstRecurrence[i].MarsReccurenceId__c)+']]>';
                            objSFDCResponse.Result=result[i].isSuccess();
                            objSFDCResponse.ErrorMessage=result[i].errors[0].message+result[i].errors[0].fields;
                        }
                        // Adding the upsertresult object to list
                        lstResponse.add(objSFDCResponse);
                    }
                }
            }
            if(marsRecurrence.containsKey('EventErrors'))
            {
                List<Event> errorRecurrence=marsRecurrence.get('EventErrors');
                //if(errorProducts.size()>0)
                if(!errorRecurrence.IsEmpty())
                {
                    for(integer i=0;i<errorRecurrence.size();i++){
                    ACK objSFDCResponse=new ACK();
                    objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(errorRecurrence[i].MarsReccurenceId__c)+']]>';
                    objSFDCResponse.Result=false;
                    objSFDCResponse.ErrorMessage=errorRecurrence[i].Description;
                    lstResponse.add(objSFDCResponse);
                    }
                }
            }
            
            if(marsRecurrence.containsKey('TaskSuccess'))
            {
                List<Task> lstRecurrence=marsRecurrence.get('TaskSuccess');
                if(!lstRecurrence.IsEmpty())
                { 
                    //Bypassing the trigger                        
                    MarsActivityUtility.BYPASS_ALL_TRIGGER=true;
                    List<Database.UpsertResult> result= Database.upsert(lstRecurrence, false);
    
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
                            objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstRecurrence[i].MarsReccurenceId__c)+']]>';
                            objSFDCResponse.Result=result[i].isSuccess();
                        }
                        else
                        {
                            objSFDCResponse.SFDCObjectId='';
                          
                            // Assigning rep ids(EXERNAL_ID__c in salesforce) to MarsObjectId
                            objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstRecurrence[i].MarsReccurenceId__c)+']]>';
                            objSFDCResponse.Result=result[i].isSuccess();
                            objSFDCResponse.ErrorMessage=result[i].errors[0].message+result[i].errors[0].fields;
                        }
                        // Adding the upsertresult object to list
                        lstResponse.add(objSFDCResponse);
                    }
                }
            }
            if(marsRecurrence.containsKey('TaskErrors'))
            {
                List<Task> errorRecurrence=marsRecurrence.get('TaskErrors');
                //if(errorProducts.size()>0)
                if(!errorRecurrence.IsEmpty())
                {
                    for(integer i=0;i<errorRecurrence.size();i++){
                    ACK objSFDCResponse=new ACK();
                    objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(errorRecurrence[i].MarsReccurenceId__c)+']]>';
                    objSFDCResponse.Result=false;
                    objSFDCResponse.ErrorMessage=errorRecurrence[i].Description;
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