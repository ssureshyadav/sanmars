@deprecated
global class MARSBatchDeleteTerritorySummary implements Database.Batchable<sObject>, Database.AllowsCallouts
{    
    //Calling Constructor
    public MARSBatchDeleteTerritorySummary()
    {    }
    
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT Id FROM MARSRepPeriodTerritorySummary__c]);
    }
    
    //execute method
    global void execute(Database.BatchableContext BC, List<MARSFirmSummary__c> scope)
    { 
        System.debug(scope.size());   
        database.delete(scope);
        database.emptyrecyclebin(scope);
    }
    
 
    //Finish method
    global void finish(Database.BatchableContext BC)
    {    }
    
}