trigger MarsProductUpdater on Product2 (before insert,before update,before delete)
{
     MARSDefaults__c marsDefaults = MarsUtility.MARS_DEFAULTS;
    
    //Check for static flag value
    if(MarsUtility.BYPASS_ALL_TRIGGER || (marsDefaults.IntegrationType__c == 0))
        return;
        
     if(!(Trigger.isDelete))
     {
        for(Product2 product: Trigger.new)
        {
            if(Trigger.isInsert)
            {
                if(product.RecordTypeId == MarsUtility.ProductRecordType)
                {
                    product.addError('Mars Products Cannot be Created from SFDC.');
                }
            }
            else
            {
                Product2 oldProduct = Trigger.oldMap.get(product.Id);
                if(product.RecordTypeId == MarsUtility.ProductRecordType||oldProduct.RecordTypeId == MarsUtility.ProductRecordType)
                {
                    product.addError('Mars Products Cannot be Updated from SFDC.');
                }
            }
            return;
        }
    }
    else if(Trigger.isDelete)
    {
        for(Product2 product: Trigger.old)
        {
            if(product.RecordTypeId == MarsUtility.ProductRecordType)
            {
                product.addError('Mars Products Cannot be Deleted from SFDC.');
            }            
            return;
        }
    }
}