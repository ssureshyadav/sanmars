global class MarsBatchRetryBulkData implements Database.Batchable<sObject>, Database.AllowsCallouts{

    global MarsBatchRetryBulkData()
    {
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        DateTime currentDate = dateTime.Now();
        System.debug('\n Current Date'+currentDate);
        return Database.getQueryLocator([SELECT Id, SfdcAccountId__c, ApexComponentName__c, ApexComponentType__c, SfdcContactId__c, MethodName__c, NoOfRetry__c,OperationType__c,
                                            NextRetryInterval__c,NextRetryAt__c,MarsObjectId__c
                                            FROM MARSBatchDataStore__c 
                                            WHERE NextRetryAt__c <= :currentDate
                                            ORDER BY LastModifieddate]);
    }

    //execute method
    global void execute(Database.BatchableContext BC, List<MARSBatchDataStore__c> scope)
    {
        System.debug('\n In Execute:');
        
        //apiPhxaComMarsisForservice.FORServiceSoap service = MarsUtility.populatedAuthService();
        apiPhxaComMarsisForupsertservice.FORUpsertServiceSoap service=MarsUtility.populatedAuthService();
        try
        {
            //Create a set to hold the Firm records Id values
            String entity;
            String marsResponse;

            //Create a list of accounts to be updated
            Set<Account> accounts = new Set<Account>();
            Set<Contact> contacts = new Set<Contact>();
            List<Id> firmIds=new List<Id>();
            Set<MARSFirmSummary__c> marsFirmSummary=new Set<MARSFirmSummary__c>(); 

            List<MARSBatchDataStore__c> errors=new List<MARSBatchDataStore__c>();
            List<MARSBatchDataStore__c> errorSuccess=new List<MARSBatchDataStore__c>();

            //Loop through the batch data records
            for(MARSBatchDataStore__c batchData : scope)
            {
                try
                {
                    System.debug('Operation Type'+batchData.OperationType__c);
                    if(batchData.SfdcAccountId__c != null)
                    {
                        Account firmOff = MarsDatabaseUtiltiy.getAccountById(batchData.SfdcAccountId__c);
                        System.debug('\n In first if block');
                        if(batchData.OperationType__c.startsWith('FIRM'))
                        {
                            System.debug('\n In Second if block'); 
                            //Create firm envelope with the newly created firm data
                            entity='firm';
                             
                            String firmEnvelope = MarsXMLEnvelopeBuilder.FirmEnvelope(firmOff);

                            //Create office envelope populated with data
                            String officeEnvelope = MarsXMLEnvelopeBuilder.OfficeEnvelope(firmOff);

                            //Call MARS api to insert data
                            marsResponse = service.UpsertFirm(firmEnvelope);
                        }
                        else if(batchData.OperationType__c.startsWith('OFFICE'))
                        {
                            entity='office';
                            
                            if(firmoff.MarsFirmId__c==null)
                            {
                                firmoff.MarsFirmId__c = firmoff.Parent.MarsFirmId__c;
                            }
                            if(firmoff.MarsOffFirmType__c==null)
                            {
                                firmoff.MarsOffFirmType__c = firmoff.Parent.MarsFirmType__c;
                            }
                            String officeEnvelope = MarsXMLEnvelopeBuilder.OfficeEnvelope(firmOff);

                            //Call MARS api to insert data
                            marsResponse = service.UpsertOffice(officeEnvelope);
                        }
                        
                        //Parse response and add in list
                        Account firmoffResponse=new Account();
                        firmoffResponse.Id = firmOff.Id;
                        firmoffResponse.ParentId=firmOff.ParentId;
                        Account objresponse = MarsUtility.updateAccounByMARSResponse(firmoffResponse, marsResponse, true,entity);
                        errorSuccess.add(batchData);
                        accounts.add(objresponse);
                        
                        if(entity=='firm')
                        {
                            MARSFirmSummary__c summary=new MARSFirmSummary__c();
                            summary.MarsFirmId__c=objresponse.MarsFirmId__c;
                            summary.SfdcFirmId__c=objresponse.Id;
                            firmIds.add(objresponse.Id);
                            marsFirmSummary.add(summary);
                        }
                        System.debug(accounts);
                    }
                    else if(batchData.SfdcContactId__c != null)
                    {
                        System.debug('\n Processing Contact');
                        Contact rep = MarsDatabaseUtiltiy.getRepById(batchData.SfdcContactId__c);
                        if(batchData.OperationType__c.startsWith('REP'))
                        {
                            //Call MARS api to insert data
                            if(rep.MarsFirmId__c==null)
                            {
                                rep.MarsFirmId__c = rep.Account.MarsFirmId__c;
                            }
                            if(rep.MarsOfficeId__c==null)
                            {
                                rep.MarsOfficeId__c = rep.Account.MarsOfficeId__c;
                            }
                            if(rep.MarsRepFirmType__c==null)
                            {
                                rep.MarsRepFirmType__c = rep.Account.MarsOffFirmType__c;
                            }
                            String repEnvelope = MarsXMLEnvelopeBuilder.RepEnvelope(rep);
                            System.debug('\n Rep Envelope'+repEnvelope);
                            marsResponse = service.UpsertRep(repEnvelope);
                        }
                        else if(batchData.OperationType__c.endsWith('MOVE'))
                        {
                            rep = MarsDatabaseUtiltiy.getRepById(batchData.SfdcContactId__c);
                            apiPhxaComMarsisMergemoveservice.MergeMoveServiceSoap moveservice = MarsUtility.populatedAuthServiceForMerge();

                            //Call MARS api for move rep record
                            Boolean moveContact=moveservice.MoveRep(String.valueOf(rep.MarsRepId__c) , String.valueOf(rep.MarsOfficeId__c), 'N', 'N', 'MARSINTG');
                            System.debug('\n Move Contact Response:'+moveContact);
                        }

                        //Parse response and add in list
                        Contact repResponse = new Contact();
                        repResponse.Id = rep.Id;
                        Contact objresponse = MarsUtility.updateContactByMARSResponse(repResponse,marsResponse, true);

                        System.debug('\n Batch Data:'+batchData);
                        errorSuccess.add(batchData);
                        System.debug('\n Error Success:'+errorSuccess);
                        contacts.add(objresponse);
                    }
                    else if(batchData.MarsObjectId__c != null)
                    {
                        errorSuccess.add(batchData);
                    }
                }
                catch (Exception e)
                {
                    //update last failure
                    MARSBatchDataStore__c retryError=new MARSBatchDataStore__c();
                    System.debug('Error Message: '+e.getMessage()+e.getStackTraceString());
                    
                    if(e.getMessage() == 'Rep not found' || e.getMessage() =='Firm/Office not found')
                    {
                        //do nothing
                    }
                    else
                    {
                        retryError.Id=batchData.Id;
                        retryError.ApexComponentName__c='MarsBatchRetryBulkData';
                        retryError.ApexComponentType__c='Apex Class';
                        retryError.MethodName__c='MarsBatchRetryBulkData';
                        retryError.NoOfRetry__c = batchData.NoOfRetry__c+1;
                        if(batchData.NoOfRetry__c==0)
                        {
                            retryError.NextRetryInterval__c=15;
                        }
                        else if(batchData.NoOfRetry__c==1 && batchData.NextRetryInterval__c == 0)
                        {
                            retryError.NextRetryInterval__c=15;
                        }
                        else
                        {
                            retryError.NextRetryInterval__c=batchData.NextRetryInterval__c*2;
                        }
                        retryError.NextRetryAt__c=Datetime.now().addminutes(Integer.valueOf(retryError.NextRetryInterval__c));
                        retryError.ErrorMessage__c=e.getStackTraceString()+'--'+e.getCause()+'--'+e.getmessage();
    
                        errors.add(retryError);
                    }
                }
            }

            //Update data in bulk and BY_PASS all the triggers
            if(!accounts.IsEmpty())
            {
                List<Account> account=new List<Account>();
                account.addall(accounts);
                try
                {
                    MarsUtility.UpdateAccountContact(account);
                }
                catch(exception e){
                    System.debug(e.getMessage());
                }
                //Checking set for size
            }
            
            System.debug(marsFirmSummary);
            if(!marsFirmSummary.IsEmpty())
            {
                List<MARSFirmSummary__c> lstsummary=new List<MARSFirmSummary__c>();
                List<MARSFirmSummary__c> updateSummary=[select Id,SfdcFirmId__c from MARSFirmSummary__c where SfdcFirmId__c IN : firmIds ];
                for(MARSFirmSummary__c fSummary:marsFirmSummary)
                {
                    for(MARSFirmSummary__c updfirm:updateSummary){
                        if(fSummary.SfdcFirmId__c == updfirm.SfdcFirmId__c){
                            MARSFirmSummary__c sum=new MARSFirmSummary__c(Id = updfirm.Id);
                            sum.MarsFirmId__c = fSummary.MarsFirmId__c;
                            lstsummary.add(sum);
                        }
                    }
                }
                if(!lstsummary.isEmpty())
                {
                    MarsUtility.BYPASS_ALL_TRIGGER=true;
                    update lstsummary; 
                    MarsUtility.BYPASS_ALL_TRIGGER=false;
                }
                
            }

            if(!contacts.IsEmpty())
            {
                List<Contact> contact=new List<Contact>();
                System.debug(contacts);
                contact.addall(contacts);
                MarsUtility.UpdateAccountContact(contact);
            }
 
            if(!errorSuccess.IsEmpty()){
                MarsUtility.BYPASS_ALL_TRIGGER=true;
                delete errorSuccess;
                MarsUtility.BYPASS_ALL_TRIGGER=false;
            }

            System.debug('\n Errors'+errors);
            
            update errors;

        }
        catch(exception e){
            System.debug(e.getMessage()+e.getStackTraceString());
        }
    }
    
    //Finish method
    global void finish(Database.BatchableContext BC)
    {
        Integer duration=0;
        
        if(MARSDefaults__c.getOrgDefaults().RetryDuration__c != null)
        {
            duration=Integer.valueOf(MARSDefaults__c.getOrgDefaults().RetryDuration__c);   
        }
        else
        {
            duration=15;
        }
        
        List<CronTrigger> lstCronTrigger=[SELECT Id,State, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger where CronJobDetail.Name = 'RetryActivitiesBatchProcess'];
        
        if(lstCronTrigger.IsEmpty() && DateTime.now().hour()>= 7)
        {
            System.scheduleBatch(new MARSBatchActivityRetryBulkData() , 'RetryActivitiesBatchProcess' , duration, 1);
        }        
    }
}