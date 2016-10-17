global class MARSActivityMISGateway{

    @future(callout=true)
    webservice static void SyncDeleteActivity(String marsactivityId,String objName) {
        try{        
                
            apiPhxaComMarsisActivitiesservice.ActivitiesServiceSoap service=MarsActivityUtility.populatedAuthServiceForActivities();
            if(objName =='FIRMEVENT')
            {
                if(!service.DeleteFirmEvent(marsactivityId))
                {
                    MarsActivityErrorLogging.createLog('MARSMISGateway' , 'Apex Class' , 'SyncDeleteActivity' , '', 'ACTIVITY_DELETE', null, null);
                }
            }
            
            if(objName =='RECURRENCE')
            {
                if(!service.DeleteRecurrence(marsactivityId))
                {
                    MarsActivityErrorLogging.createLog('MARSMISGateway' , 'Apex Class' , 'SyncDeleteActivity' , '', 'ACTIVITY_DELETE', null, null);
                }
            }
            
            if(objName =='MEETING')
            {
                if(!service.DeleteMeeting(marsactivityId))
                {
                    MarsActivityErrorLogging.createLog('MARSMISGateway' , 'Apex Class' , 'SyncDeleteActivity' , '', 'ACTIVITY_DELETE', null, null);
                }
            }
            
            if(objName =='TICKLER')
            {
                if(!service.DeleteTickler(marsactivityId))
                {
                    MarsActivityErrorLogging.createLog('MARSMISGateway' , 'Apex Class' , 'SyncDeleteActivity' , '', 'ACTIVITY_DELETE', null, null);
                }
            }
            
            if(objName =='CALL')
            {
                if(!service.DeleteCall(marsactivityId))
                {
                    MarsActivityErrorLogging.createLog('MARSMISGateway' , 'Apex Class' , 'SyncDeleteActivity' , '', 'ACTIVITY_DELETE', null, null);
                }
            }
            
            if(objName =='EMAIL')
            {
               /* if(!service.DeleteMeeting(marsactivityId))
                {
                    MarsActivityErrorLogging.createLog('MARSMISGateway' , 'Apex Class' , 'SyncDeleteActivity' , '', 'ACTIVITY_DELETE', null, null);
                }*/
            }
            
        }catch(exception e){
            System.debug(e.getMessage()+e.getStackTraceString());
            MarsErrorLogging.createLog('MARSMISGateway' , 'Apex Class' , 'SyncDeleteActivity' , e.getMessage()+'--'+e.getStackTraceString(), 'ACTIVITY_DELETE', null, null);
        }
    }

    @future(callout=true)
    webservice static void SyncTask(ID taskId,String objName) {
        try{        
                
            Task lsttask = MarsActivityDatabaseUtiltiy.getTaskById(taskId);
            MARSActivityMISGateway.tasksAtMARS(lsttask,objName);
        }catch(exception e){
            System.debug(e.getMessage()+e.getStackTraceString());
            MarsActivityErrorLogging.createLog('MARSMISGateway' , 'Apex Class' , 'SyncTask' , e.getMessage()+'--'+e.getStackTraceString(), 'TASK_UPSERT', taskId, taskId+objName);
        }
    }
    
    @future(callout=true)
    webservice static void SyncEvent(ID eventId,String objName) {
        System.debug('Count:'+eventId);
        try{        
                
            Event lstevent = MarsActivityDatabaseUtiltiy.getEventById(eventId);
            MARSActivityMISGateway.eventsAtMARS(lstevent,objName);
        }catch(exception e){
            System.debug(e.getMessage()+e.getStackTraceString());
            //Call createLog method for creating the log errors
            MarsActivityErrorLogging.createLog('MARSMISGateway' , 'Apex Class' , 'SyncEvent' , e.getMessage()+'--'+e.getStackTraceString(), 'EVENT_UPSERT', eventId, eventId+objName);
        }
    }
    
    private static void eventsAtMARS(Event lstevent,String objName) {
            
            String eventEnvelope = MarsActivityXMLEnvelopeBuilder.eventEnvelope(lstevent,objName);
            System.debug(eventEnvelope);
            apiPhxaComMarsisActivitiesservice.ActivitiesServiceSoap service=MarsActivityUtility.populatedAuthServiceForActivities();
            String marsResponse=null;
            if(objName =='MEETING')
            {
                marsResponse = service.UpsertMeeting(eventEnvelope);

            }else if(objName =='FIRMEVENT')
            {
                marsResponse = service.UpsertFirmEvent(eventEnvelope);
            }
            System.debug(marsResponse);
            List<Sobject> lstresponse=MarsActivityUtility.updateObjByMARSResponse(lstevent,marsResponse,true,objName);
            MarsActivityUtility.BYPASS_ALL_TRIGGER =true;
            update lstresponse;
            MarsActivityUtility.BYPASS_ALL_TRIGGER=false;
    }
    
    private static void tasksAtMARS(Task lstTask,String objName) {
            
            String taskEnvelope = MarsActivityXMLEnvelopeBuilder.taskEnvelope(lstTask,objName);
            System.debug(taskEnvelope);
            apiPhxaComMarsisActivitiesservice.ActivitiesServiceSoap service=MarsActivityUtility.populatedAuthServiceForActivities();
            String marsResponse=null;
            if(objName == 'CALL')
            {
                marsResponse = service.UpsertCall(taskEnvelope);
            }
            
            if(objName == 'TICKLER')
            {
                marsResponse = service.UpsertTickler(taskEnvelope);
            }
            
            if(objName == 'EMAIL')
            {
                marsResponse = service.UpsertEmail(taskEnvelope);
            }
            
            List<Sobject> lstresponse=MarsActivityUtility.updateObjByMARSResponse(lstTask,marsResponse,true,objName);
            MarsActivityUtility.BYPASS_ALL_TRIGGER =true;
            update lstresponse;
            MarsActivityUtility.BYPASS_ALL_TRIGGER=false;
    }
}