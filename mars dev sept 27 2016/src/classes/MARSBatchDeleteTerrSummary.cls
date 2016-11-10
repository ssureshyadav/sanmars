global class MARSBatchDeleteTerrSummary implements Database.Batchable<sObject>, Database.AllowsCallouts
{    
    private Date terrSummaryDate;
    //Calling Constructor
    public MARSBatchDeleteTerrSummary(Date terrSummaryDate)
    {
        this.terrSummaryDate =terrSummaryDate;
    }
    
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('Terr Summary Date'+terrSummaryDate);
        return Database.getQueryLocator([SELECT Id FROM MARSRepPeriodTerritorySummary__c WHERE MarsUpdDt__c <: terrSummaryDate and isDeleted = false]);
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