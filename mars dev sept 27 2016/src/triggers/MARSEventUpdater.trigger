trigger MARSEventUpdater on Event (before insert,before update,after insert,after update,before delete,after delete) {
    
    MARSDefaults__c marsDefaults = MarsUtility.MARS_DEFAULTS;
    if(MarsActivityUtility.BYPASS_ALL_TRIGGER || marsDefaults.IntegrationType__c == 0 || marsDefaults.MARSActivityPreference__c)
    {
        return;
    }
    
    List<MARSBatchDataStore__c> bulkLoad=new List<MARSBatchDataStore__c>();
    if(Trigger.isBefore && !Trigger.isDelete)
    {
        for(Event evt:Trigger.new)
        {
            //validations
        }
    }
    
    if(Trigger.isBefore && Trigger.isDelete)
    {
        //Mars Records Validations
        List<Id> lstDelDataStore=new List<Id>();
        for(Event evt:Trigger.old)
        {
            System.debug(evt.MarsReccurenceId__c);
            if((evt.MarsReccurenceId__c != null && evt.IsRecurrence) || (evt.MarsActivityId__c != null && !evt.IsRecurrence))
            {
                if(evt.WhoId != null){
                    if(Trigger.old.size() ==1)
                    {
                        //Delete Call to mars
                        if(evt.MarsActivityId__c != null)
                        {
                            MarsActivityMISGateway.SyncDeleteActivity(String.valueOf(evt.MarsActivityId__c),'MEETING');
                        }else if(evt.MarsReccurenceId__c != null)
                        {
                            MarsActivityMISGateway.SyncDeleteActivity(String.valueOf(evt.MarsReccurenceId__c),'RECURRENCE');
                        }
                    }else{
                        MARSBatchDataStore__c MARSBatchDataStore = new MARSBatchDataStore__c(ApexComponentName__c = 'MarsEventUpdater', ApexComponentType__c = 'Apex Trigger',
                                                                   MethodName__c = 'MarsEventUpdater', ErrorMessage__c = 'Bulk Delete',MarsObjectId__c =String.valueOf(evt.MarsActivityId__c == null ?evt.MarsReccurenceId__c:evt.MarsActivityId__c),
                                                                   OperationType__c = 'EVENT_DELETE', NoOfRetry__c=0,MarsBatchId__c =evt.Id+String.valueOf(evt.MarsActivityId__c != null ?'MEETING':'RECURRENCE'));
                         bulkLoad.add(MARSBatchDataStore);
                    }                
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
            if(evt.WhoId != null && mapContact != null && mapContact.containsKey(evt.WhoId) && evt.WhatId == null) //Rep Events
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