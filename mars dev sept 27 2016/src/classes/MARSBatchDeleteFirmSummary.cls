@Deprecated
global class MARSBatchDeleteFirmSummary implements Database.Batchable<sObject>, Database.AllowsCallouts
{    
    //Calling Constructor
    public MARSBatchDeleteFirmSummary()
    {    }
    
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        //return Database.getQueryLocator([SELECT Id FROM MARSFirmSummary__c]);
        return null;
    }
    
    //execute method
    global void execute(Database.BatchableContext BC, List<MARSFirmSummary__c> scope)
    {    
        database.delete(scope);
        database.emptyrecyclebin(scope);
    }
    
 
    //Finish method
    global void finish(Database.BatchableContext BC)
    {    }
    
}