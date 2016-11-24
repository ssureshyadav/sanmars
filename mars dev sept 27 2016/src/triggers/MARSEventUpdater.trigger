trigger MARSEventUpdater on Event (before insert,before update,after insert,after update,before delete,after delete) {
    
    MARSDefaults__c marsDefaults = MarsUtility.MARS_DEFAULTS;
    if(MarsActivityUtility.BYPASS_ALL_TRIGGER || marsDefaults.IntegrationType__c == 0 || (!marsDefaults.MARSActivityPreference__c))
    {
        return;
    }
    
    List<MARSBatchDataStore__c> bulkLoad=new List<MARSBatchDataStore__c>();
    if(Trigger.isBefore && !Trigger.isDelete)
    {
        System.debug(Trigger.new);
        //Mars Records Validations
        for(Event evt:Trigger.new)
        {
            if(Trigger.isInsert)
            {
                if(evt.MARSActivityId__c != null && evt.RecurrenceActivityId == null)
                {
                    evt.addError('Mars Activity Id Should not be specified');
                }
                
                if(evt.MARSReccurenceId__c != null && evt.RecurrenceActivityId == null)
                {
                    evt.addError('Mars Reccurence Id Should not be specified');
                }
                if(evt.MARSActivityType__c != null && evt.RecurrenceActivityId == null)
                {
                    evt.addError('Mars Activity Type Should not be specified');
                }
                evt.MARSChkUpdDesc__c = true;
            }else if(Trigger.isUpdate)
            {
                if(Trigger.oldMap.get(evt.Id).MARSActivityId__c != null && evt.MARSActivityId__c != Trigger.oldMap.get(evt.Id).MARSActivityId__c)
                {
                    evt.addError('Mars Activity Id Should not be Modified');
                }
                
                if(Trigger.oldMap.get(evt.Id).MARSReccurenceId__c != null && evt.MARSReccurenceId__c != Trigger.oldMap.get(evt.Id).MARSReccurenceId__c)
                {
                    evt.addError('Mars Reccurence Id Should not be Modified');
                }
                
                if(Trigger.oldMap.get(evt.Id).MARSActivityType__c != null && evt.MARSActivityType__c != Trigger.oldMap.get(evt.Id).MARSActivityType__c)
                {
                    evt.addError('Mars Activity Type Should not be Modified');
                }
                
                if(Trigger.oldMap.get(evt.Id).Description != null && evt.Description != Trigger.oldMap.get(evt.Id).Description)
                {
                    evt.MARSChkUpdDesc__c = true;
                }
            }
        }
    }
    
    if(Trigger.isBefore && Trigger.isDelete)
    {
        //Mars Records Validations
        List<Id> lstDelDataStore=new List<Id>();
        for(Event evt:Trigger.old)
        {
            System.debug(evt.MarsReccurenceId__c);
            System.debug(evt.WhoId);
            if((evt.MarsReccurenceId__c != null && evt.IsRecurrence) || (evt.MarsActivityId__c != null && !evt.IsRecurrence) && evt.WhoId != null)
            {
                if(Trigger.old.size() ==1)
                {
                    //Delete Call to mars
                    if(evt.MarsActivityId__c != null)
                    {
                        MarsActivityMISGateway.SyncDeleteActivity(String.valueOf(evt.MarsActivityId__c),'MEETING');
                    }else if(evt.MarsReccurenceId__c != null)
                    {
                        MarsActivityMISGateway.SyncDeleteActivity(String.valueOf(evt.MarsReccurenceId__c),'RECURRENCE');
                        List<Event> lstreccurEvent=[Select Id,MarsActivityId__c,MarsReccurenceId__c from Event where RecurrenceActivityId =: evt.Id AND MarsActivityId__c != null];
                        if(!lstreccurEvent.isEmpty())
                        {
                            for(Event cEvent:lstreccurEvent)
                            {
                                MARSBatchDataStore__c MARSBatchDataStore = new MARSBatchDataStore__c(ApexComponentName__c = 'MarsEventUpdater', ApexComponentType__c = 'Apex Trigger',
                                                                   MethodName__c = 'MarsEventUpdater', ErrorMessage__c = 'Bulk Delete',MarsObjectId__c =String.valueOf(cEvent.MarsActivityId__c == null ?cEvent.MarsReccurenceId__c:cEvent.MarsActivityId__c),
                                                                   OperationType__c = 'EVENT_DELETE', NoOfRetry__c=0,MarsBatchId__c =cEvent.Id+String.valueOf(cEvent.MarsActivityId__c != null ?'MEETING':'RECURRENCE'));
                                bulkLoad.add(MARSBatchDataStore);
                            }
                        }
                    }
                }else{
                    MARSBatchDataStore__c MARSBatchDataStore = new MARSBatchDataStore__c(ApexComponentName__c = 'MarsEventUpdater', ApexComponentType__c = 'Apex Trigger',
                                                               MethodName__c = 'MarsEventUpdater', ErrorMessage__c = 'Bulk Delete',MarsObjectId__c =String.valueOf(evt.MarsActivityId__c == null ?evt.MarsReccurenceId__c:evt.MarsActivityId__c),
                                                               OperationType__c = 'EVENT_DELETE', NoOfRetry__c=0,MarsBatchId__c =evt.Id+String.valueOf(evt.MarsActivityId__c != null ?'MEETING':'RECURRENCE'));
                     bulkLoad.add(MARSBatchDataStore);
                }                
            }else{
                lstDelDataStore.add(evt.Id);
            }
        }
        
        if(!lstDelDataStore.isEmpty())
        {
            List<MARSBatchDataStore__c> lstDelbatchData=[Select Id from MARSBatchDataStore__c Where MarsObjectId__c = : lstDelDataStore];
            delete lstDelbatchData;
        }
        if(!bulkLoad.isEmpty())
        {
            MarsErrorLogging.createBatchData(bulkLoad);
        }
    }
    
    if(!Trigger.isDelete)
    if(Trigger.isAfter)
    {
        System.debug(trigger.new.size());
        Map<Id,Id> mapeventAccountIds=new Map<Id,Id>();
        Set<Id> lstContactId=new Set<Id>();
        
        for(Event evt:Trigger.new)
        {
            if(evt.WhoId != null) //Rep Events
            {
                lstContactId.add(evt.WhoId);
            }
        }
        
        Map<Id,Contact> mapContact=new Map<Id,Contact>();
        Map<Id,Account> mapFirm=new Map<Id,Account>();
        if(!lstContactId.isEmpty())
        {
            mapContact=new Map<Id,Contact>([Select Id from Contact where Id IN : lstContactId and MarsRepId__c != null]);
        }
        
        for(Event evt:Trigger.new)
        {
            if(evt.WhoId != null && mapContact != null && mapContact.containsKey(evt.WhoId)) //Rep Events // && evt.WhatId == null(For FirmEvents) 
            {
                String objectName =String.valueOf(evt.WhoId.getSObjectType());
                if(objectName == 'Contact')
                {
                    if(Trigger.new.size() ==1 && !(evt.isRecurrence))
                    {
                        MARSActivityMISGateway.SyncEvent(evt.Id,'MEETING');
                    }else{
                        MARSBatchDataStore__c MARSBatchDataStore = new MARSBatchDataStore__c(ApexComponentName__c = 'MarsEventUpdater', ApexComponentType__c = 'Apex Trigger',
                                                                           MethodName__c = 'MarsEventUpdater', ErrorMessage__c = 'Bulk Upsert',MarsObjectId__c =evt.Id,
                                                                           OperationType__c = 'EVENT_UPSERT', NoOfRetry__c=0,MarsBatchId__c =evt.Id+'MEETING');
                         bulkLoad.add(MARSBatchDataStore);
                    }
                }
            }
        }
        
        if(!bulkLoad.isEmpty())
        {
            System.debug(bulkLoad);
            MarsErrorLogging.createBatchData(bulkLoad);
        }
    }

}