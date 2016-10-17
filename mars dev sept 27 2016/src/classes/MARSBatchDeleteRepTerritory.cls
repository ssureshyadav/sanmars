/**
 *  Description     :   This class is there to delete rep territory records.
 *
 *  Created By      :
 *
 *  Created Date    :   12/6/2013
 *
 *  Revision Log    :   v_1.0
 *
 **/
@deprecated
global class MARSBatchDeleteRepTerritory implements Database.Batchable<sObject>, Database.AllowsCallouts
{    
    //Calling Constructor
    public MARSBatchDeleteRepTerritory()
    {
    }
    
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT Id FROM MarsRepTerritory__c]);
    }
    
    //execute method
    global void execute(Database.BatchableContext BC, List<MarsRepTerritory__c> scope)
    {    
        database.delete(scope);
        database.emptyrecyclebin(scope);
    }
    
 
    //Finish method
    global void finish(Database.BatchableContext BC)
    {    }
    
}