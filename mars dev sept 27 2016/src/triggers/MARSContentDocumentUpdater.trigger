trigger MARSContentDocumentUpdater on ContentDocument(before insert,before update,after insert,after update,before delete,after delete) {

 MARSDefaults__c marsDefaults = MarsUtility.MARS_DEFAULTS;
    if(MarsActivityUtility.BYPASS_ALL_TRIGGER || marsDefaults.IntegrationType__c == 0 || !marsDefaults.MARSActivityPreference__c)
    {
        return;
    }
    
    if(Trigger.isBefore && !Trigger.isDelete)
    {
        for(ContentDocument note:Trigger.new)
        {
            //ContentDocumentLink.Body=note.Body+'Description changed';
            System.debug(Trigger.new);
        }
    }
    
    List<MARSBatchDataStore__c> bulkLoad=new List<MARSBatchDataStore__c>();
    if(Trigger.isBefore && Trigger.isDelete)
    {
        //Mars Records Validations
        for(ContentDocument note:Trigger.old)
        {
            if(Trigger.old.size() ==1)
            {
                MarsActivityMISGateway.SyncDeleteActivity(note.Id,'REPNOTES');
            }
            else{
                MARSBatchDataStore__c MARSBatchDataStore = new MARSBatchDataStore__c(ApexComponentName__c = 'MARSContentDocumentUpdater', ApexComponentType__c = 'Apex Trigger',
                                                           MethodName__c = 'MARSContentDocumentUpdater', ErrorMessage__c = 'Bulk Delete',MarsObjectId__c = note.Id,
                                                           OperationType__c = 'REPNOTES_DELETE', NoOfRetry__c=0,MarsBatchId__c =note.Id+'REPNOTES');
                bulkLoad.add(MARSBatchDataStore);
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
        System.debug(trigger.new.size());
        Map<Id,Id> mapeventAccountIds=new Map<Id,Id>();
        Set<Id> lstContactId=new Set<Id>();
        Set<Id> setNoteId=new Set<Id>();
        Map<Id,Id> mapDocumentLinkcontactId=new Map<Id,Id>();
        
        for(ContentDocument doc:Trigger.new)
        {
            setNoteId.add(doc.Id);
        }
        
        if(!setNoteId.isEmpty())
        {
            for(ContentDocumentLink docLink:[SELECT ContentDocumentId,Id,LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN : setNoteId])
            {
                if(docLink.LinkedEntityId != null && docLink.LinkedEntityId.getSObjectType().getDescribe().getName() == 'Contact'){
                    mapDocumentLinkcontactId.put(docLink.ContentDocumentId,docLink.LinkedEntityId);
                }
            }
        }
        
        for(ContentDocument cDocument:Trigger.new)
        {
            if(mapDocumentLinkcontactId.containskey(cDocument.Id)) //Rep Note
            {
                lstContactId.add(mapDocumentLinkcontactId.get(cDocument.Id));
            }
        }
        
        Map<Id,Contact> mapContact=new Map<Id,Contact>();
        if(!lstContactId.isEmpty())
        {
            mapContact=new Map<Id,Contact>([Select Id from Contact where Id IN : lstContactId and MarsRepId__c != null]);
        }
        
        for(ContentDocument cDocument:Trigger.new)
        {
            if(mapDocumentLinkcontactId.containskey(cDocument.Id) && mapContact != null && mapContact.containsKey(mapDocumentLinkcontactId.get(cDocument.Id))) //Rep Note
            {
                if(Trigger.new.size() ==1)
                {
                    MARSActivityMISGateway.SyncNote(cDocument.Id,'NOTE');
                }else{
                    MARSBatchDataStore__c MARSBatchDataStore = new MARSBatchDataStore__c(ApexComponentName__c = 'MARSNoteUpdater', ApexComponentType__c = 'Apex Trigger',
                                                                       MethodName__c = 'MARSNoteUpdater', ErrorMessage__c = 'Bulk Upsert',MarsObjectId__c =cDocument.Id,
                                                                       OperationType__c = 'NOTE_UPSERT', NoOfRetry__c=0,MarsBatchId__c =cDocument.Id+'NOTE');
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