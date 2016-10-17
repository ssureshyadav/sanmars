/**
 *  Description     :   This class is there to delete summary records.
 *
 *  Created By      :
 *
 *  Created Date    :   12/6/2013
 *
 *  Revision Log    :   v_1.0
 *
 **/
global class MARSBatchDeleteSummary implements Database.Batchable<sObject>, Database.AllowsCallouts
{    
    //Calling Constructor
    public MARSBatchDeleteSummary()
    {    }
    
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        List<AggregateResult> assestDateResult=[SELECT Max(MarsUpdDt__c) max FROM MarsRepPeriodSummary__c where isdeleted =false];
        System.debug(assestDateResult[0].get('max'));
        Date MaxDate=Date.valueOf(assestDateResult[0].get('max'));
        return Database.getQueryLocator([SELECT Id FROM MarsRepPeriodSummary__c WHERE MarsUpdDt__c <: MaxDate and isDeleted = false]);
        //return Database.getQueryLocator([SELECT Id FROM MarsRepPeriodSummary__c]);
    }
    
    //execute method
    global void execute(Database.BatchableContext BC, List<MarsRepPeriodSummary__c> scope)
    {    
        database.delete(scope);
        database.emptyrecyclebin(scope);
    }
    
 
    //Finish method
    global void finish(Database.BatchableContext BC)
    {    
        MARSBatchDeleteTerrSummary deleteterrSummary=new MARSBatchDeleteTerrSummary();
        Id delTerrSummary=Database.executeBatch(deleteterrSummary);
    }
    
}