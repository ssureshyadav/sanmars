/**
 *  Description     :   This class is there to delete office territory records.
 *
 *  Created By      :
 *
 *  Created Date    :   4/21/2015
 *
 *  Revision Log    :   v_1.0
 *
 **/
global class MARSBatchDeleteOffTerr implements Database.Batchable<sObject>, Database.AllowsCallouts
{    
    public MARSBatchDeleteOffTerr()
    {
    }
    
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT Id FROM MarsOffTerr__c where MARSUpdDt__c > :System.Today()+2 and isDeleted = false ]);
    }
    
    //execute method
    global void execute(Database.BatchableContext BC, List<MarsOffTerr__c> scope)
    {    
        database.delete(scope);
        database.emptyrecyclebin(scope);
    }
    
 
    //Finish method
    global void finish(Database.BatchableContext BC)
    {
        // send an email
        //marsEmailHandler.sendEmail('start deleteterritory');
        //MARSBatchDeleteTerritory deleteTerritory=new MARSBatchDeleteTerritory();
        //Id delTerr=Database.executeBatch(deleteTerritory);
        List<MARSTerritorySyncDelete__c> deleteData=[Select Id from MARSTerritorySyncDelete__c];
        delete deleteData;
        //database.emptyrecyclebin(deleteData);
    }
    
}