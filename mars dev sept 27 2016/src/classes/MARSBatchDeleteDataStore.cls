/**
 *  Description     :   This class is there to delete batch datastore records.
 *
 *  Created By      :
 *
 *  Created Date    :   01/08/2014
 *
 *  Revision Log    :   v_1.0
 *
 **/
global class MARSBatchDeleteDataStore implements Database.Batchable<sObject>, Database.AllowsCallouts {    
    public MARSBatchDeleteDataStore()
    {
    }
    
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        Integer nbrofDays=0;
        DateTime    refDate = system.Now();
      
        if(MARSDefaults__c.getOrgDefaults().DeleteMARSBatchDataPeriod__c != null)
        {
            nbrofDays=-1*Integer.valueOf(MARSDefaults__c.getOrgDefaults().DeleteMARSBatchDataPeriod__c);  
        }
        else
        {
            nbrofDays=-30;
        }
        refDate = refDate.addDays(nbrofDays);
        System.debug(refDate);
        if(test.isRunningTest()){
            return Database.getQueryLocator([SELECT Id FROM MARSBatchDataStore__c]);
        }
        return Database.getQueryLocator([SELECT Id FROM MARSBatchDataStore__c WHERE CreatedDate < :refDate and isDeleted = false]);
        
    }
    
    //execute method
    global void execute(Database.BatchableContext BC, List<MARSBatchDataStore__c> scope)
    {    
        MarsUtility.BYPASS_ALL_TRIGGER=true;       
        database.delete(scope);
        MarsUtility.BYPASS_ALL_TRIGGER=false;       
        database.emptyrecyclebin(scope);
    }
    
 
    //Finish method
    global void finish(Database.BatchableContext BC)
    {    }
    
}