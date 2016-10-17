global class MARSMISGateway{
    
    @future(callout=true)
    webservice static void SyncAccount(ID accountId,String action) {
        string operationType = 'ACCOUNT_' + action.toUpperCase();
        try{        
            Account account = MarsDatabaseUtiltiy.getAccountById(accountid);
            
            //Check either it is firm or office. If updatetype is F creating/updating Firm
            // If updatetype is O creating/updating Office
            if(account.SfdcLastUpdateType__c == 'F')
            {
                operationType = 'FIRM_' + action.toUpperCase();
                //Inserting Firm To Mars
                MARSMISGateway.FirmAtMARS(account,operationType);
                
            }
            else if(account.SfdcLastUpdateType__c == 'O')
            {
                operationType = 'OFFICE_' + action.toUpperCase();
                //Inserting Office To Mars
                MARSMISGateway.OfficeAtMARS(account,operationType);
            }   
        }catch(exception e){
            //Call createLog method for creating the log errors
            MarsErrorLogging.createLog('MARSMISGateway' , 'Apex Class' , 'SyncAccount' , e.getMessage()+'--'+e.getStackTraceString(), operationType, accountId, null);
        }
    }
    
    @future(callout=true)
    webservice static void syncContact(ID contactId,String action) {
        String operationType = 'REP_' + action.toUpperCase();
        try{
            Contact contact=MarsDatabaseUtiltiy.getRepById(contactId);
            
            //Insert firm data in MARS
            MARSMISGateway.RepAtMARS(contact,operationType);
        }
        catch(exception e){
            MarsErrorLogging.createLog('MARSMISGateway' , 'Apex Class' , 'syncContact' , e.getMessage()+'--'+e.getStackTraceString(), operationType, null, contactId);
        }
    }
    
    @future(callout=true)
    webservice static void moveAccount(String officeId,String targetFirmID,ID AccountId) {
      /*  try{
            apiPhxaComMarsisMergemoveservice.MergeMoveServiceSoap service = MarsUtility.populatedAuthServiceForMerge();
            
            MarsUtility.BYPASS_ALL_TRIGGER = true;
            //Call MARS api for move rep record
            service.MoveOffice(officeId,targetFirmID,'N','N','MARSINTG');
            
            //service.MoveRep(repid , officeid, 'N', 'N', 'MARSINTG');            
        }
        catch(exception e){
            MarsErrorLogging.createLog('MARSMISGateway' , 'Apex Class' , 'moveOffice' , e.getMessage()+'--'+e.getStackTraceString(), 'OFFICE_MOVE', AccountId, null);
        }*/
    }
    
    @future(callout=true)
    webservice static void moveContact(String repId,String officeId,ID contactId) {
        try{
            apiPhxaComMarsisMergemoveservice.MergeMoveServiceSoap service = MarsUtility.populatedAuthServiceForMerge();
            system.debug(repid +'~'+officeid);
            
            MarsUtility.BYPASS_ALL_TRIGGER = true;
            //Call MARS api for move rep record
            service.MoveRep(repid , officeid, 'Y', 'N', 'MARSINTG');            
        }
        catch(exception e){
            MarsErrorLogging.createLog('MARSMISGateway' , 'Apex Class' , 'moveContact' , e.getMessage()+'--'+e.getStackTraceString(), 'REP_MOVE', null, contactId);
        }
    }
    
    @future(callout=true)
    webservice static void mergeContact(Decimal mergedRepId , Decimal survivingRepId,ID contactId) {
        /*try {
            //Instantiating MergeMoveService object            
            apiPhxaComMarsisMergemoveservice.MergeMoveServiceSoap service = MarsUtility.populatedAuthServiceForMerge();

            //Set the flag value for by pass the trigger
            MarsUtility.BYPASS_ALL_TRIGGER = true;

            //Call MARS api for merge rep records
            service.MergeRep(String.valueOf(mergedRepId) , String.valueOf(survivingRepId) , 'N', 'N', 'MARSINTG');
        
        } catch (Exception e) {
            //Call createLog method for creating the log errors
            MarsErrorLogging.createLog('MARSMISGateway' , 'Apex Class' , 'mergeContact' , e.getMessage()+'--'+e.getStackTraceString(), 'REP_MERGE', null, contactId);
        }*/
    }
    
    private static void FirmAtMARS(Account firm,String action) {
        try {            
            //Instantiating FORService object
            apiPhxaComMarsisForupsertservice.FORUpsertServiceSoap service=MarsUtility.populatedAuthService();
            //Create firm envelope with the newly created firm data
            String firmEnvelope = MarsXMLEnvelopeBuilder.FirmEnvelope(firm);
            
            String marsResponse = service.UpsertFirm(firmEnvelope);
        
            //Account record Instance going to be updated
            System.debug('\n\n Mars Response:'+marsResponse);
            Account account = MarsUtility.updateAccounByMARSResponse(firm, marsResponse, true,'firm');
            
            //Update account
            UpdateAccountContact(account);
            
            //Creating Firm Summary Record with the firm details
            //if(action.toUpperCase().contains('INSERT'))
            //{    
                List<MARSFirmSummary__c> lstFirmSummary=[Select Id from MARSFirmSummary__c Where SfdcFirmId__c = : account.Id];
                if(lstFirmSummary.size()>0)
                {
                    MARSFirmSummary__c firmsummary=new MARSFirmSummary__c(Id=lstFirmSummary[0].Id);
                    firmsummary.MarsFirmId__c=account.MarsFirmId__c;
                    firmsummary.SfdcFirmId__c=account.Id;
                    UpdateAccountContact(firmsummary); 
                }
            //}
        }
        catch (Exception e) {
                System.debug('Exception Message: '+e.getMessage());
                /*if(action.toUpperCase().contains('INSERT'))
                {
                    MARSFirmSummary__c firmsummary=new MARSFirmSummary__c();
                   // firmsummary.MarsFirmId__c=account.MarsFirmId__c;
                    firmsummary.SfdcFirmId__c=firm.Id;
                    insert firmsummary; 
                }*/
               //UpdateAccountContact(firm);
                MarsErrorLogging.createLog('MARSMISGateway', 'Apex Class', 'FirmAtMARS', e.getMessage()+'--'+e.getStackTraceString(), action, firm.Id, null);
                
        }
    }
    
     private static void OfficeAtMARS(Account office, String action) {
        try {            
            //Create office envelope with the newly created office data
            String officeEnvelope = MarsXMLEnvelopeBuilder.OfficeEnvelope(office);

            //Instantiating FORService object
            apiPhxaComMarsisForupsertservice.FORUpsertServiceSoap service=MarsUtility.populatedAuthService();
            String marsResponse = service.UpsertOffice(officeEnvelope);
            System.debug('\n\n Office Response: @@@@+'+marsResponse);
            Account account = MarsUtility.updateAccounByMARSResponse(office, marsResponse, true,'office');
            UpdateAccountContact(account);
        }
        catch(exception e){                    
            //office.Validated_Insert_Last_Attempt__c = DateTime.Now();
            System.debug('\n Ex'+e.getMessage()+'-'+e.getStackTraceString());
            //UpdateAccountContact(office);
            MarsErrorLogging.createLog('MARSMISGateway', 'Apex Class', 'OfficeAtMARS', e.getMessage()+'--'+e.getStackTraceString(), action, office.Id, null);
        }
    }
    
     private static void RepAtMARS(Contact rep, String action) {
        try {
            //Create rep envelope with the newly created rep data
            String repEnvelope = MarsXMLEnvelopeBuilder.RepEnvelope(rep);

            //Instantiating FORService object
            apiPhxaComMarsisForupsertservice.FORUpsertServiceSoap service=MarsUtility.populatedAuthService();
            String marsResponse = service.UpsertRep(repEnvelope);
            System.debug('\n\n Mars Response:'+marsResponse);
            //Update contact data
            Contact contact = MarsUtility.updateContactByMARSResponse(rep, marsResponse, true);
            UpdateAccountContact(contact);
        }
        catch (Exception e) {
            //UpdateAccountContact(rep);
            MarsErrorLogging.createLog('MARSMISGateway', 'Apex Class', 'RepAtMARS', e.getMessage()+ '--' + e.getStackTraceString(), action, null, rep.Id);
        }
    }
    
    
    private static void UpdateAccountContact(SObject objAccountContact){        
            try
            {
                //Set the Trigger by pass flag
                MarsUtility.BYPASS_ALL_TRIGGER = true;
                update objAccountContact;
            }
            finally
            {   
                //Clear the Trigger by pass flag
                MarsUtility.BYPASS_ALL_TRIGGER = false;
            }
    } 
}