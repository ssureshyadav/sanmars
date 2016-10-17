trigger MarsTaskUpdater on Task (before insert,before update,after insert,after update,before delete,after delete) {
    
    MARSDefaults__c marsDefaults = MarsUtility.MARS_DEFAULTS;
    if(MarsActivityUtility.BYPASS_ALL_TRIGGER || marsDefaults.IntegrationType__c == 0 || marsDefaults.MARSActivityPreference__c)
    {
        return;
    }
    
    List<MARSBatchDataStore__c> bulkLoad=new List<MARSBatchDataStore__c>();
    
    if(Trigger.isBefore && !Trigger.isDelete)
    {
        //Mars Records Validations
        for(Task tas:Trigger.new)
        {
        }
    }
    
    if(Trigger.isBefore && Trigger.isDelete)
    {
        //Mars Records Validations
        for(Task tas:Trigger.old)
        {
            if((tas.MarsReccurenceId__c != null && tas.IsRecurrence) || (tas.MarsActivityId__c != null && !tas.IsRecurrence))
            {
                if(tas.TaskSubtype =='Call' && tas.Status != 'Completed')
                {
                    if(tas.MarsActivityId__c != null)
                    {
                        if(Trigger.old.size() ==1)
                        {
                        //Delete Call to mars
                            if(tas.MarsActivityId__c != null)
                            {
                                MarsActivityMISGateway.SyncDeleteActivity(String.valueOf(tas.MarsActivityId__c),'TICKLER');
                            }else if(tas.MarsReccurenceId__c != null)
                            {
                                MarsActivityMISGateway.SyncDeleteActivity(String.valueOf(tas.MarsReccurenceId__c),'RECURRENCE');
                            }
                        }else{
                            MARSBatchDataStore__c MARSBatchDataStore = new MARSBatchDataStore__c(ApexComponentName__c = 'MarsTaskUpdater', ApexComponentType__c = 'Apex Trigger',
                                                                       MethodName__c = 'MarsTaskUpdater', ErrorMessage__c = 'Bulk Delete',MarsObjectId__c = String.valueOf(tas.MarsActivityId__c == null? tas.MarsReccurenceId__c :tas.MarsActivityId__c),
                                                                       OperationType__c = 'TASK_DELETE', NoOfRetry__c=0,MarsBatchId__c =tas.Id+String.valueOf(tas.MarsActivityId__c == null?'RECURRENCE':'TICKLER'));
                             bulkLoad.add(MARSBatchDataStore);
                        }
                    }
                }else if(tas.TaskSubtype =='Call' && tas.Status == 'Completed'){
                    MarsActivityMISGateway.SyncDeleteActivity(String.valueOf(tas.MarsActivityId__c),'CALL');
                }else if(tas.TaskSubtype =='Email'){
                    MarsActivityMISGateway.SyncDeleteActivity(String.valueOf(tas.MarsActivityId__c),'EMAIL');
                }   
            }
        }
        if(!bulkLoad.isEmpty())
        {
            MarsErrorLogging.createBatchData(bulkLoad);
        }
    }
    
    
    
    if(!Trigger.isDelete)
    if(Trigger.isAfter)
    {
        Set<Id> lstContactId=new Set<Id>();
        
        for(Task tas:Trigger.new)
        {
            if(tas.WhoId != null && (tas.TaskSubtype == 'Email' || tas.TaskSubtype == 'Call')) //Rep Events
            {
                lstContactId.add(tas.WhoId);
            }
        }
        
        Map<Id,Contact> mapContact=new Map<Id,Contact>();
        if(!lstContactId.isEmpty())
        {
            mapContact=new Map<Id,Contact>([Select Id from Contact where Id IN : lstContactId and MarsRepId__c != null]);
        }
        
        for(Task tas:Trigger.new)
        {
            if(tas.WhoId != null && mapContact.containsKey(tas.WhoId) && (tas.TaskSubtype == 'Email' || tas.TaskSubtype == 'Call')) //Rep Events
            {
                if(tas.TaskSubtype == 'Email')
                {
                    if(Trigger.new.size() ==1)
                    {
                        MarsActivityMISGateway.SyncTask(tas.Id,'EMAIL');
                    }else{
                        MARSBatchDataStore__c MARSBatchDataStore = new MARSBatchDataStore__c(ApexComponentName__c = 'MarsTaskUpdater', ApexComponentType__c = 'Apex Trigger',
                                                                   MethodName__c = 'MarsTaskUpdater', ErrorMessage__c = 'Bulk Upsert',MarsObjectId__c =tas.Id,
                                                                   OperationType__c = 'TASK_UPSERT', NoOfRetry__c=0,MarsBatchId__c =tas.Id+'EMAIL');
                         bulkLoad.add(MARSBatchDataStore);
                    }
                }else if(tas.TaskSubtype == 'Call')
                {
                    if(Trigger.new.size() ==1 && !tas.isRecurrence)
                    {
                        MarsActivityMISGateway.SyncTask(tas.Id,'CALL');
                    }else{
                        MARSBatchDataStore__c MARSBatchDataStore = new MARSBatchDataStore__c(ApexComponentName__c = 'MarsTaskUpdater', ApexComponentType__c = 'Apex Trigger',
                                                                   MethodName__c = 'MarsTaskUpdater', ErrorMessage__c = 'Bulk Upsert',MarsObjectId__c =tas.Id,
                                                                   OperationType__c = 'TASK_UPSERT', NoOfRetry__c=0,MarsBatchId__c =tas.Id+'CALL');
                         bulkLoad.add(MARSBatchDataStore);
                    }
                }
            }
        }
        
        if(!bulkLoad.isEmpty())
        {
            MarsErrorLogging.createBatchData(bulkLoad);
        }
    }

}