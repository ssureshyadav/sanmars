/**
 *  Description     :   This class is there to delete office territory records.
 *
 *  Created By      :
 *
 *  Created Date    :   12/6/2013
 *
 *  Revision Log    :   v_1.0
 *
 **/
@deprecated
global class MARSBatchDeleteOfficeTerritory implements Database.Batchable<sObject>, Database.AllowsCallouts
{    
    public MARSBatchDeleteOfficeTerritory()
    {
    }
    
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT Id FROM MarsOfficeTerritory__c]);
    }
    
    //execute method
    global void execute(Database.BatchableContext BC, List<MarsOfficeTerritory__c> scope)
    {    
        database.delete(scope);
        database.emptyrecyclebin(scope);
    }
    
 
    //Finish method
    global void finish(Database.BatchableContext BC)
    {    }
    
}