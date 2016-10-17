/**
 *  Description     :   This class is there to delete rep territory records.
 *
 *  Created By      :
 *
 *  Created Date    :   4/21/2015
 *
 *  Revision Log    :   v_1.0
 *
 **/
global class MARSBatchDeleteRepTerr implements Database.Batchable<sObject>, Database.AllowsCallouts
{    
    //Calling Constructor
    public MARSBatchDeleteRepTerr()
    {
    }
    
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT Id FROM MarsRepTerr__c Where MARSUpdDt__c > : System.Today()+2 and isDeleted = false]);
    }
    
    //execute method
    global void execute(Database.BatchableContext BC, List<MarsRepTerr__c> scope)
    {    
        database.delete(scope);
        database.emptyrecyclebin(scope);
    }    
 
    //Finish method
    global void finish(Database.BatchableContext BC)
    {
        // send an email
        //marsEmailHandler.sendEmail('start deleteoffterr');
        MARSBatchDeleteOffTerr deleteOffTerr=new MARSBatchDeleteOffTerr();
        Id delOffTerr=Database.executeBatch(deleteOffTerr);
    }
}