/**
 *  Description     :   This class is there to reset batch datastore records.
 *
 *  Created By      :
 *
 *  Created Date    :   01/28/2014
 *
 *  Revision Log    :   v_1.0
 *
 **/
global class MARSBatchResetFailedMsg implements Database.Batchable<sObject>, Database.AllowsCallouts
{    
    public MARSBatchResetFailedMsg ()
    {
    }
    
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT Id,NoOfRetry__c,NextRetryInterval__c,NextRetryAt__c  FROM MARSBatchDataStore__c WHERE NoOfRetry__c > 0]);
    }
    
    //execute method
    global void execute(Database.BatchableContext BC, List<MARSBatchDataStore__c> scope)
    {    
        try{
            
             List<MARSBatchDataStore__c> updateRecords=new List<MARSBatchDataStore__c>();
             
             for(MARSBatchDataStore__c batchData : scope){
                MARSBatchDataStore__c batchRecord=new MARSBatchDataStore__c(id=batchData.Id);
                batchRecord.NoOfRetry__c=0;
                batchRecord.NextRetryInterval__c=0;
                batchRecord.NextRetryAt__c=Datetime.now();
                updateRecords.add(batchRecord);
             }
             //if(updateRecords.size()>0){
             if(!updateRecords.IsEmpty()){
                 MarsUtility.BYPASS_ALL_TRIGGER=true;       
                update updateRecords;
                MarsUtility.BYPASS_ALL_TRIGGER=false;       
             }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
 
    //Finish method
    global void finish(Database.BatchableContext BC)
    {    
    }
    
}