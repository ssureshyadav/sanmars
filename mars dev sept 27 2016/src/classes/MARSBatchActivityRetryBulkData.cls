global class MARSBatchActivityRetryBulkData implements Database.Batchable<sObject>, Database.AllowsCallouts{

    global MarsBatchActivityRetryBulkData()
    {
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        DateTime currentDate = dateTime.Now();
        System.debug('\n Current Date'+currentDate);
        return Database.getQueryLocator([SELECT Id, SfdcAccountId__c, ApexComponentName__c, ApexComponentType__c, SfdcContactId__c, MethodName__c, NoOfRetry__c,OperationType__c,
                                            NextRetryInterval__c,NextRetryAt__c,MarsObjectId__c,MarsBatchId__c
                                            FROM MARSBatchDataStore__c 
                                            WHERE NextRetryAt__c <= :currentDate and SfdcAccountId__c = null and SfdcContactId__c = null 
                                            ORDER BY LastModifieddate]);
    }

    //execute method
    global void execute(Database.BatchableContext BC, List<MARSBatchDataStore__c> scope)
    {
        System.debug('\n In Execute:');
        Set<Event> lstEvent = new Set<Event>();
        Set<Task> lstTask = new Set<Task>();
        apiPhxaComMarsisActivitiesservice.ActivitiesServiceSoap service=MarsActivityUtility.populatedAuthServiceForActivities();
        try
        {
            //Create a set to hold the Firm records Id values
            String entity;
            String marsResponse;

            List<MARSBatchDataStore__c> errors=new List<MARSBatchDataStore__c>();
            List<MARSBatchDataStore__c> errorSuccess=new List<MARSBatchDataStore__c>();

            //Loop through the batch data records
            for(MARSBatchDataStore__c batchData : scope)
            {
                try
                {
                    System.debug('Operation Type'+batchData.OperationType__c);
                    if(batchData.OperationType__c.contains('DELETE'))
                    {
                        if(batchData.MarsBatchId__c.contains('MEETING'))
                        {
                            service.DeleteMeeting(String.valueOf(batchData.MarsObjectId__c));
                        }else if(batchData.MarsBatchId__c.contains('FIRMEVENT'))
                        {
                            service.DeleteFirmEvent(String.valueOf(batchData.MarsObjectId__c));
                        }else if(batchData.MarsBatchId__c.contains('TICKLER'))
                        {
                            service.DeleteTickler(String.valueOf(batchData.MarsObjectId__c));
                        }else if(batchData.MarsBatchId__c.contains('RECURRENCE'))
                        {
                            service.DeleteRecurrence(String.valueOf(batchData.MarsObjectId__c));
                        }else if(batchData.MarsBatchId__c.contains('CALL'))
                        {
                            service.DeleteCall(String.valueOf(batchData.MarsObjectId__c));
                        }
                    }else
                    {
                        if(batchData.OperationType__c.startsWith('EVENT'))
                        {
                            Event event = MarsActivityDatabaseUtiltiy.getEventById(batchData.MarsObjectId__c); 
                            if(!event.IsRecurrence && event.RecurrenceActivityId != null && event.MarsReccurenceId__c == null)
                            {
                                continue;
                            }
                            if(batchData.MarsBatchId__c.contains('MEETING'))
                            {
                                String meetingEnvelope = MarsActivityXMLEnvelopeBuilder.eventEnvelope(event,'MEETING');
                                System.debug(meetingEnvelope);
                                marsResponse = service.UpsertMeeting(meetingEnvelope);
                                Event evt=(Event)MarsActivityUtility.updateObjByMARSResponse(event,marsResponse,true,'MEETING');
                                lstEvent.add(evt);
                            }else if(batchData.MarsBatchId__c.contains('FIRMEVENT'))
                            {
                                String meetingEnvelope = MarsActivityXMLEnvelopeBuilder.eventEnvelope(event,'FIRMEVENT');
                                System.debug(meetingEnvelope);
                                marsResponse = service.UpsertFirmEvent(meetingEnvelope);
                                System.debug(marsResponse);
                                Event evt=(Event)MarsActivityUtility.updateObjByMARSResponse(event,marsResponse,true,'FIRMEVENT');
                                System.debug(evt);
                                lstEvent.add(evt);
                            }
                        }
                        else if(batchData.OperationType__c.toUpperCase().startsWith('TASK'))
                        {
                            Task tas = MarsActivityDatabaseUtiltiy.getTaskById(batchData.MarsObjectId__c); 
                            if(!tas.IsRecurrence && tas.RecurrenceActivityId != null && tas.MarsReccurenceId__c == null)
                            {
                                continue;
                            }
                            if(batchData.MarsBatchId__c.contains('CALL'))
                            {
                                String meetingEnvelope = MarsActivityXMLEnvelopeBuilder.taskEnvelope(tas,'CALL');
                                marsResponse = service.UpsertCall(meetingEnvelope);
                                Task task=(Task)MarsActivityUtility.updateObjByMARSResponse(tas,marsResponse,true,'CALL');
                                lstTask.add(task);
                            }else if(batchData.MarsBatchId__c.contains('EMAIL'))
                            {
                                String meetingEnvelope = MarsActivityXMLEnvelopeBuilder.taskEnvelope(tas,'EMAIL');
                                marsResponse = service.UpsertEmail(meetingEnvelope);
                                Task task=(Task)MarsActivityUtility.updateObjByMARSResponse(tas,marsResponse,true,'EMAIL');
                                lstTask.add(task);
                            }/*else if(batchData.MarsBatchId__c.contains('TICKLER'))
                            {
                                String meetingEnvelope = MarsActivityXMLEnvelopeBuilder.taskEnvelope(tas,'TICKLER');
                                marsResponse = service.UpsertTickler(meetingEnvelope);
                                Task task=(Task)MarsActivityUtility.updateObjByMARSResponse(tas,marsResponse,true,'TICKLER');
                                lstTask.add(task);
                            }*/
                        }
                    }
                    errorSuccess.add(batchData);
                }
                catch (Exception e)
                {
                    //update last failure
                    if(e.getMessage().contains('List has no rows for assignment to SObject')){
                        errorSuccess.add(batchData);
                    }else{
                        MARSBatchDataStore__c retryError=new MARSBatchDataStore__c();
                        System.debug('Error Message: '+e.getMessage()+e.getStackTraceString());
                        
                        retryError.Id=batchData.Id;
                        retryError.ApexComponentName__c='MarsBatchRetryBulkData';
                        retryError.ApexComponentType__c='Apex Class';
                        retryError.MethodName__c='MarsBatchRetryBulkData';
                        retryError.NoOfRetry__c = batchData.NoOfRetry__c+1;
                        if(batchData.NoOfRetry__c==0)
                        {
                            retryError.NextRetryInterval__c=15;
                        }
                        else if(batchData.NoOfRetry__c==1 && batchData.NextRetryInterval__c == 0)
                        {
                            retryError.NextRetryInterval__c=15;
                        }
                        else
                        {
                            retryError.NextRetryInterval__c=batchData.NextRetryInterval__c*2;
                        }
                        retryError.NextRetryAt__c=Datetime.now().addminutes(Integer.valueOf(retryError.NextRetryInterval__c));
                        retryError.ErrorMessage__c=e.getStackTraceString()+'--'+e.getCause()+'--'+e.getmessage();
    
                        errors.add(retryError);
                    }
                }
            }
            
            if(!lstEvent.IsEmpty())
            {
                List<Event> event=new List<Event>();
                event.addall(lstEvent);
                MarsActivityUtility.BYPASS_ALL_TRIGGER=true;
                update event;
                MarsActivityUtility.BYPASS_ALL_TRIGGER=false;
            }
            
            if(!lstTask.IsEmpty())
            {
                List<Task> tas=new List<Task>();
                tas.addall(lstTask);
                MarsActivityUtility.BYPASS_ALL_TRIGGER=true;
                update tas;
                MarsActivityUtility.BYPASS_ALL_TRIGGER=false;
            }
            

            if(!errorSuccess.IsEmpty()){
                MarsActivityUtility.BYPASS_ALL_TRIGGER=true;
                delete errorSuccess;
                MarsActivityUtility.BYPASS_ALL_TRIGGER=false;
            }

            System.debug('\n Errors'+errors);
            
            update errors;

        }
        catch(exception e){
            System.debug(e.getMessage()+e.getStackTraceString());
        }
    }
    
    //Finish method
    global void finish(Database.BatchableContext BC)
    {
        Integer duration=0;
        
        if(MARSDefaults__c.getOrgDefaults().RetryDuration__c != null)
        {
            duration=Integer.valueOf(MARSDefaults__c.getOrgDefaults().RetryDuration__c);   
        }
        else
        {
            duration=15;
        }
        
        List<CronTrigger> lstCronTrigger=[SELECT Id,State, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger where CronJobDetail.Name = 'RetryBatchProcess'];
        
        if(lstCronTrigger.IsEmpty() && DateTime.now().hour()>= 7)
        {
            System.scheduleBatch(new MarsBatchRetryBulkData() , 'RetryBatchProcess' , duration, 10);
        }         
    }
}