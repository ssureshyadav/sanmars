trigger MARSNoteUpdater on Note (before insert,before update,after insert,after update,before delete,after delete) {

 MARSDefaults__c marsDefaults = MarsUtility.MARS_DEFAULTS;
    if(MarsActivityUtility.BYPASS_ALL_TRIGGER || marsDefaults.IntegrationType__c == 0 || (!marsDefaults.MARSActivityPreference__c))
    {
        return;
    }
    
    List<MARSBatchDataStore__c> bulkLoad=new List<MARSBatchDataStore__c>();
     if(Trigger.isBefore && !Trigger.isDelete)
    {
        for(Note note:Trigger.new)
        {
        }
    }
    
    if(Trigger.isBefore && Trigger.isDelete)
    {
        //Mars Records Validations
        List<Id> lstDelDataStore=new List<Id>();
        for(Note evt:Trigger.old)
        {

        }
    }
    
    if(!Trigger.isDelete)
    if(Trigger.isAfter)
    {
        System.debug(trigger.new.size());
        Map<Id,Id> mapeventAccountIds=new Map<Id,Id>();
        Set<Id> lstContactId=new Set<Id>();
        
        for(Note evt:Trigger.new)
        {
            String objectName =String.valueOf(evt.ParentId.getSObjectType());
            if(evt.ParentId != null && objectName == 'Contact') //Rep Note
            {
                lstContactId.add(evt.ParentId);
            }
        }
        
        Map<Id,Contact> mapContact=new Map<Id,Contact>();
        if(!lstContactId.isEmpty())
        {
            mapContact=new Map<Id,Contact>([Select Id from Contact where Id IN : lstContactId and MarsRepId__c != null]);
        }
        
        for(Note evt:Trigger.new)
        {
            if(evt.ParentId != null && mapContact != null && mapContact.containsKey(evt.ParentId)) //Rep Note
            {
                if(Trigger.new.size() ==1)
                {
                    MARSActivityMISGateway.SyncNote(evt.Id,'NOTE');
                }else{
                    MARSBatchDataStore__c MARSBatchDataStore = new MARSBatchDataStore__c(ApexComponentName__c = 'MARSNoteUpdater', ApexComponentType__c = 'Apex Trigger',
                                                                       MethodName__c = 'MARSNoteUpdater', ErrorMessage__c = 'Bulk Upsert',MarsObjectId__c =evt.Id,
                                                                       OperationType__c = 'NOTE_UPSERT', NoOfRetry__c=0,MarsBatchId__c =evt.Id+'NOTE');
                     bulkLoad.add(MARSBatchDataStore);
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