trigger MARSEmailUpdater on EmailMessage (before delete,before Insert,after insert) {

    List<MARSBatchDataStore__c> bulkLoad=new List<MARSBatchDataStore__c>();
    if(Trigger.isBefore && Trigger.isDelete)
    {
        //Mars Records Validations
        List<Id> lstDelDataStore=new List<Id>();
        if(Trigger.old.size() ==1)
        {
            Task tas=[Select Id,MarsActivityId__c From Task where Id = : Trigger.old[0].ActivityId];
            if(tas.MarsActivityId__c != null)
            {
                MarsActivityMISGateway.SyncDeleteActivity(String.valueOf(tas.MarsActivityId__c),'EMAIL');
            }
        }
        else
        {
            List<Id> lstTaskId=new List<Id>();
            for(EmailMessage eMessage:Trigger.old)
            {
                if(eMessage.ActivityId != null)
                {
                    lstTaskId.add(eMessage.ActivityId);
                }
            }
            
            if(!lstTaskId.isempty())
            {
                Map<Id,Task> mapTask=new Map<Id,Task>([Select Id,MarsActivityId__c From Task where Id IN : lstTaskId and MarsActivityId__c != null]);
                if(!mapTask.isEmpty())
                {
                    for(EmailMessage eMessage:Trigger.old)
                    {
                        if(eMessage.ActivityId != null && mapTask.containsKey(eMessage.ActivityId))
                        {
                            MARSBatchDataStore__c MARSBatchDataStore = new MARSBatchDataStore__c(ApexComponentName__c = 'MARSEmailUpdater', ApexComponentType__c = 'Apex Trigger',
                                                                       MethodName__c = 'MARSEmailUpdater', ErrorMessage__c = 'Bulk Delete',MarsObjectId__c =String.valueOf((mapTask.get(eMessage.ActivityId)).MarsActivityId__c),
                                                                       OperationType__c = 'TASK_DELETE', NoOfRetry__c=0,MarsBatchId__c =eMessage.Id+'EMAIL');
                            bulkLoad.add(MARSBatchDataStore);
                        }
                    }
                }
            }       
        }
        
        if(!bulkLoad.isEmpty())
        {
            MarsErrorLogging.createBatchData(bulkLoad);
        }
    }
    
    if(Trigger.isInsert && Trigger.isAfter)
    {
        System.debug(Trigger.new);
    }

}