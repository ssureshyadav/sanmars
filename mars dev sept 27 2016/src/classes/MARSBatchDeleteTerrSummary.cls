global class MARSBatchDeleteTerrSummary implements Database.Batchable<sObject>, Database.AllowsCallouts
{    
    //Calling Constructor
    public MARSBatchDeleteTerrSummary()
    {    }
    
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        List<AggregateResult> assestDateResult=[SELECT Max(MarsUpdDt__c) max FROM MARSRepPeriodTerritorySummary__c where isdeleted =false];
        System.debug(assestDateResult[0].get('max'));
        Date MaxDate=Date.valueOf(assestDateResult[0].get('max'));
        return Database.getQueryLocator([SELECT Id FROM MARSRepPeriodTerritorySummary__c WHERE MarsUpdDt__c <: MaxDate and isDeleted = false]);
        //return Database.getQueryLocator([SELECT Id FROM MARSRepPeriodTerritorySummary__c where isDeleted = false]);
    }
    
    //execute method
    global void execute(Database.BatchableContext BC, List<MARSRepPeriodTerritorySummary__c> scope)
    { 
        System.debug(scope.size());   
        database.delete(scope);
        database.emptyrecyclebin(scope);
    }
    
 
    //Finish method
    global void finish(Database.BatchableContext BC)
    {    }
    
}