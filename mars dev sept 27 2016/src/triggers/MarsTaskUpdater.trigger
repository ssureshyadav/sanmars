trigger MarsTaskUpdater on Task (before insert,before update,after insert,after update,before delete,after delete) {
    
    MARSDefaults__c marsDefaults = MarsUtility.MARS_DEFAULTS;
    if(MarsActivityUtility.BYPASS_ALL_TRIGGER || marsDefaults.IntegrationType__c == 0 || !(marsDefaults.MARSActivityPreference__c))
    {
        return;
    }
    
    if(Trigger.isBefore && !Trigger.isDelete)
    {
        for(Task tas:Trigger.new)
        {
            if(Trigger.isInsert)
            {
                if(tas.MARSActivityId__c != null && tas.RecurrenceActivityId == null)
                {
                    tas.addError('Mars Activity Id Should not be specified');
                }
                
                if(tas.MARSReccurenceId__c != null && tas.RecurrenceActivityId == null)
                {
                    tas.addError('Mars Reccurence Id Should not be specified');
                }
                if(tas.MARSActivityType__c != null && tas.RecurrenceActivityId == null)
                {
                    tas.addError('Mars Activity Type Should not be specified');
                }
                tas.MARSChkUpdDesc__c = true;
            }else if(Trigger.isUpdate)
            {
                if(Trigger.oldMap.get(tas.Id).MARSActivityId__c != null && tas.MARSActivityId__c != Trigger.oldMap.get(tas.Id).MARSActivityId__c)
                {
                    tas.addError('Mars Activity Id Should not be Modified');
                }
                
                if(Trigger.oldMap.get(tas.Id).MARSReccurenceId__c != null && tas.MARSReccurenceId__c != Trigger.oldMap.get(tas.Id).MARSReccurenceId__c)
                {
                    tas.addError('Mars Reccurence Id Should not be Modified');
                }
                
                if(Trigger.oldMap.get(tas.Id).MARSActivityType__c != null && tas.MARSActivityType__c != Trigger.oldMap.get(tas.Id).MARSActivityType__c)
                {
                    tas.addError('Mars Activity Type Should not be Modified');
                }
                
                if(Trigger.oldMap.get(tas.Id).Description != null && tas.Description != Trigger.oldMap.get(tas.Id).Description)
                {
                    tas.MARSChkUpdDesc__c = true;
                }
            }
        }
    }

    List<MARSBatchDataStore__c> bulkLoad=new List<MARSBatchDataStore__c>();
    if(Trigger.isBefore && Trigger.isDelete)
    {
        //Mars Records Validations
        for(Task tas:Trigger.old)
        {
            if((tas.MarsReccurenceId__c != null && tas.IsRecurrence) || (tas.MarsActivityId__c != null && !tas.IsRecurrence))
            {
                if(tas.TaskSubtype =='Call' && tas.Status != 'Completed')
                {
                    if(Trigger.old.size() ==1)
                    {
                        if(tas.MarsActivityId__c != null)
                        {
                            //Delete Call to mars
                            if(tas.MarsActivityId__c != null)
                            {
                                MarsActivityMISGateway.SyncDeleteActivity(String.valueOf(tas.MarsActivityId__c),'TICKLER');
                            }
                        }else if(tas.MarsReccurenceId__c != null)
                        {
                            MarsActivityMISGateway.SyncDeleteActivity(String.valueOf(tas.MarsReccurenceId__c),'RECURRENCE');
                            List<Task> lstreccurTask=[Select Id,MarsActivityId__c,MarsReccurenceId__c from Task where RecurrenceActivityId =: tas.Id AND MarsActivityId__c != null];
                            if(!lstreccurTask.isEmpty())
                            {
                                for(Task cTask:lstreccurTask)
                                {
                                       MARSBatchDataStore__c MARSBatchDataStore = new MARSBatchDataStore__c(ApexComponentName__c = 'MarsTaskUpdater', ApexComponentType__c = 'Apex Trigger',
                                                                       MethodName__c = 'MarsTaskUpdater', ErrorMessage__c = 'Bulk Delete',MarsObjectId__c = String.valueOf(cTask.MarsActivityId__c == null? cTask.MarsReccurenceId__c :cTask.MarsActivityId__c),
                                                                       OperationType__c = 'TASK_DELETE', NoOfRetry__c=0,MarsBatchId__c =cTask.Id+String.valueOf(cTask.MarsActivityId__c == null?'RECURRENCE':'TICKLER'));
                                       bulkLoad.add(MARSBatchDataStore);
                                }
                            }
                        }
                    }else{
                            MARSBatchDataStore__c MARSBatchDataStore = new MARSBatchDataStore__c(ApexComponentName__c = 'MarsTaskUpdater', ApexComponentType__c = 'Apex Trigger',
                                                                       MethodName__c = 'MarsTaskUpdater', ErrorMessage__c = 'Bulk Delete',MarsObjectId__c = String.valueOf(tas.MarsActivityId__c == null? tas.MarsReccurenceId__c :tas.MarsActivityId__c),
                                                                       OperationType__c = 'TASK_DELETE', NoOfRetry__c=0,MarsBatchId__c =tas.Id+String.valueOf(tas.MarsActivityId__c == null?'RECURRENCE':'TICKLER'));
                             bulkLoad.add(MARSBatchDataStore);
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
    
    if(!Trigger.isDelete && Trigger.isAfter )
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
                }else if(tas.TaskSubtype == 'Call' && (tas.Status =='Completed' || tas.ActivityDate != null || tas.RecurrenceActivityId != null))
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