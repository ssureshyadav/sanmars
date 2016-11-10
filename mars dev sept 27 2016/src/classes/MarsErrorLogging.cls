/**
 *  Description     :   This class is to log all the errors in a custom object. This will help is tracking the issue if something gets fail.
 *
 *  Created By      :
 *
 *  Created Date    :   07/08/2013
 *
 *  Revision Log    :   V_1.0
 *
 **/
public with sharing class MarsErrorLogging {

    //This method is to capture the error accour during the transaction with record and failure details
    public static void createLog(String cName , String cType , String mName , String eMessage, String operationType, Id accountId, Id contactId) {

        //Create new record(Mars Error Log)
        try{
            MARSBatchDataStore__c marsErrorLog = new MARSBatchDataStore__c(ApexComponentName__c = cName , ApexComponentType__c = cType,
                                                                           MethodName__c = mName , ErrorMessage__c = eMessage,
                                                                           OperationType__c = operationType, SfdcAccountId__c = accountId,
                                                                           SfdcContactId__c = contactId,NoOfRetry__c=1,
                                                                           NextRetryInterval__c=15,NextRetryAt__c=DateTime.now().addminutes(15));
            if(operationType.contains('FIRM') && accountId !=null){
                marsErrorLog.MarsBatchId__c = accountId+'FIRM';                                                               
            }else if(operationType.contains('OFFICE') && accountId !=null){
                marsErrorLog.MarsBatchId__c = accountId+'OFFICE';                                                               
            }else if(operationType.contains('REP') && !operationType.contains('MOVE') && contactId != null){
                marsErrorLog.MarsBatchId__c = contactId+'REP';                                                               
            }else if(operationType.contains('REP') && operationType.contains('MOVE') && contactId != null){
                marsErrorLog.MarsBatchId__c = contactId+'REPMOVE';                                                               
            }
            //Insert
            System.debug('\n\n Mars Error Log:'+marsErrorLog);
            MarsUtility.BYPASS_ALL_TRIGGER=true;       
            upsert marsErrorLog MarsBatchId__c;
            MarsUtility.BYPASS_ALL_TRIGGER=false;
        }
        catch(Exception e){
            System.debug('\n Error In Error Log Object'+e.getMessage()+'--'+e.getStackTraceString());
        }
    }
    

    //This method is to upsert records in bulk
    public static void createBatchData(list<MARSBatchDataStore__c> marsBulkData) {

        //Create new record
        try{
            //Upsert
            System.debug('\n\n Mars Bulk Data Log:'+marsBulkData);
            MarsUtility.BYPASS_ALL_TRIGGER=true;
            upsert marsBulkData MarsBatchId__c;
            MarsUtility.BYPASS_ALL_TRIGGER=false;
        }
        catch(Exception e){
            System.debug('\n Error In Error Log Object'+e.getMessage()+'--'+e.getStackTraceString());
        }
    }

}