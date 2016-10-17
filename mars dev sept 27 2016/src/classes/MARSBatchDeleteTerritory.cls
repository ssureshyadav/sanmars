/**
 *  Description     :   This class is there to delete territory records.
 *
 *  Created By      :
 *
 *  Created Date    :   12/6/2013
 *
 *  Revision Log    :   v_1.0
 *
 **/
@deprecated
global class MARSBatchDeleteTerritory implements Database.Batchable<sObject>, Database.AllowsCallouts
{    
    //Calling Constructor
    public MARSBatchDeleteTerritory()
    {
    }
    
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT Id FROM MarsTerritory__c]);
    }
    
    //execute method
    global void execute(Database.BatchableContext BC, List<MarsTerritory__c> scope)
    {    
        database.delete(scope);
        database.emptyrecyclebin(scope);
    }
    
 
    //Finish method
    global void finish(Database.BatchableContext BC)
    {    }
    
}