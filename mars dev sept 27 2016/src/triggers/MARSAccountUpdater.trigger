/** Description     :   Trigger responsible for all pre and post processing of account record.
 *
 *  Created By      :
 *
 *  Created Date    :   07/02/2013
 *
 *  Revision Log    :   V_1.0
 *
 *  Last Modified Details
    Date        User        Purpose
    --------------------------------------------------------------
    12/23/2013    Suresh     BUG73967
    12/23/2013    Suresh     BUG73952
    01/22/2014    Suresh     BUG73987
    --------------------------------------------------------------
 * BUG73485: Made the changes for office.MarsCrdId__c.toUpperCase() in the Before Trigger(Insert, Update)
**/
trigger MARSAccountUpdater on Account (before insert, before update,after insert, after update,before delete,after delete)
{
    MARSDefaults__c marsDefaults = MarsUtility.MARS_DEFAULTS;
    
    integer validationResult;
    
    if(MarsUtility.BYPASS_ALL_TRIGGER || (marsDefaults.IntegrationType__c == 0))
        return;
                
    if(trigger.isAfter && !trigger.isdelete)
    {
        if(MarsValidation.retval != 1)
        return;
    }
        
    Private static Id firmoffRecordTypeId = MarsUtility.AccountRecordType;
        
    List<Account> marsAccounts =new List<Account>();
    if(trigger.isAfter && trigger.isdelete)
    {
        for(Account account:Trigger.old)
        {
            if(account.RecordTypeId == firmoffRecordTypeId)
            {
                marsAccounts.add(account);
            }
        }
        if(marsAccounts.isEmpty())
        {
            return;    
        }    
    }
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate))
    {
        for(Account account:Trigger.new)
        {
            if(trigger.isUpdate)
            {
                if (account.RecordTypeId == firmoffRecordTypeId ||  Trigger.oldMap.get(account.Id).RecordTypeId == firmoffRecordTypeId)
                {
                    if(account.MarsSummaryUpdateTime__c != Trigger.oldMap.get(account.Id).MarsSummaryUpdateTime__c)
                    {
                        return;
                    }else
                     marsAccounts.add(account );
                }
            }
            
            if(trigger.isInsert && account.RecordTypeId == firmoffRecordTypeId) //record type = MARS
            {
                marsAccounts.add(account);
            }
            
            if(account.RecordTypeId != firmoffRecordTypeId)
            {
                if(account.MarsCrdId__c != null)
                {
                    Account.MarsCrdId__c.addError('Mars CRD cannot be assigned from Non-Mars Record Type');
                }
            }            
        }
        
        if(marsAccounts.isEmpty())
        {
            return;    
        }
    }

    Boolean marsFieldUpdated =false;
    Map<String, Schema.SObjectField> accountFields = Schema.SObjectType.Account.fields.getMap();  
    if(!MarsUtility.BYPASS_VALIDATION)
    {
        if(trigger.isUpdate && Trigger.isBefore)
        {
           for(Account acct:marsAccounts)
           {    
                if (acct.MarsSummaryUpdateTime__c != Trigger.oldMap.get(acct.Id).MarsSummaryUpdateTime__c)
                {
                    return;
                }
                else if(marsFieldUpdated)
                {
                   break; 
                }
                else
                {
                   validateFields(acct,Trigger.oldMap.get(acct.Id));
                }
           }
           if(!marsFieldUpdated)
           {
               return;
           }
        }
        
        if(trigger.isDelete && trigger.isAfter)
        {
            System.debug(marsAccounts);
            System.debug('Old Values:'+Trigger.old);
            MarsValidation.validateAccount(marsAccounts,Trigger.OldMap,'DELETE'); 
        }
        else if(trigger.isUpdate && Trigger.isBefore)
            MarsValidation.validateAccount(marsAccounts,Trigger.OldMap,'UPDATE');
        else if(trigger.isInsert && Trigger.isBefore)
            MarsValidation.validateAccount(marsAccounts,Trigger.OldMap,'INSERT');
     
        validationResult = MarsValidation.retval;
        System.debug('\n : validationResult' + validationResult);
        System.debug('After Execution : '+marsAccounts);
    }
    else if(MarsUtility.BYPASS_VALIDATION)
    {
        validationResult =1;
    }
    
    public void validateFields(Account newValues,Account oldValues)
    {
        List<String> marsStandardFields=new List<String>{'Name','ParentId','BillingStreet','BillingCity','BillingStateCode','BillingPostalCode','BillingCountryCode','RecordTypeId','Phone','Fax','BillingLatitude','BillingLongitude','Website'};
        //Map<String,String> accStandardFields =new Map<String,String>{'Name' => 'Name','ParentId' => 'ParentId','BillingStreet' => 'BillingStreet','BillingCity' => 'BillingCity','BillingStateCode' => 'BillingStateCode','BillingPostalCode' => 'BillingPostalCode','BillingCountryCode' => 'BillingCountryCode','RecordTypeId' => 'RecordTypeId','Phone' => 'Phone','Fax' => 'Fax','BillingLatitude' => 'BillingLatitude','BillingLongitude' => 'BillingLongitude','Website' => 'Website'};
        for (String str : accountFields.keyset())
        {
            if(str.contains('__c'))
            {
                if(String.valueOf(accountFields.get(str)).contains('marssfs'))
                {
                    if(newValues.get(str) != oldValues.get(str))
                    {
                        marsFieldUpdated=true;
                        return;
                    }
                }
            }
            else
            {
                if(newValues.get(str) != oldValues.get(str))
                {
                    for(String marsFields:marsStandardFields)
                    {
                        if(marsFields == str)
                        {
                            marsFieldUpdated=true;
                            return;
                        }
                    }
                }
            }
        }
    }


    if(validationResult == 1)
    { 
        if(Trigger.isAfter)
        {
            Boolean bulkLoadEnabled = marsDefaults.BulkLoadEnabled__c;
            if(Test.isRunningTest())
            {
                bulkLoadEnabled= true;
            }
    
            if(Trigger.isInsert)
            {
                if(trigger.new.size() > 1 && bulkLoadEnabled)
                {
                    List<MARSBatchDataStore__c> bulkLoad=new List<MARSBatchDataStore__c>();
                    for(Account firmoff: trigger.new)
                    {
                        if(firmoff.RecordTypeId == firmoffRecordTypeId)
                        {
                            if(firmoff.ParentId==null)
                            {
                                /*MARSBatchDataStore__c MARSBatchDataStore = new MARSBatchDataStore__c(ApexComponentName__c = 'MARSAccountUpdater', ApexComponentType__c = 'Apex Trigger',
                                                                       MethodName__c = 'MARSAccountUpdater', ErrorMessage__c = 'Bulk Insert',
                                                                       OperationType__c = 'FIRM_INSERT', SfdcAccountId__c = firmoff.Id,
                                                                       SfdcContactId__c = null, NoOfRetry__c=0,MarsBatchId__c =firmoff.Id+'FIRM');
                                bulkLoad.add(MARSBatchDataStore);*/
                            }
                            else
                            {
                                MARSBatchDataStore__c MARSBatchDataStore = new MARSBatchDataStore__c(ApexComponentName__c = 'MARSAccountUpdater', ApexComponentType__c = 'Apex Trigger',
                                                                       MethodName__c = 'MARSAccountUpdater', ErrorMessage__c = 'Bulk Insert',
                                                                       OperationType__c = 'OFFICE_INSERT', SfdcAccountId__c = firmoff.Id,
                                                                       SfdcContactId__c = null, NoOfRetry__c=0,MarsBatchId__c =firmoff.Id+'OFFICE');
                                bulkLoad.add(MARSBatchDataStore);
                            }
                        }
                    }
                    MarsErrorLogging.createBatchData(bulkLoad);
                }
                else
                {
                    for(Account firmoff: trigger.new)
                    {
                        MARSMISGateway.SyncAccount(firmoff.Id, 'insert');
                    }
                }
            }
    
            //Check for request type
            if(Trigger.isUpdate)
            {
                if(trigger.new.size() > 1 && bulkLoadEnabled==True)
                {
                    List<MARSBatchDataStore__c> bulkLoad=new List<MARSBatchDataStore__c>();
                    for(Account firmoff: trigger.new)
                    {
                        if(firmoff.RecordTypeId == firmoffRecordTypeId)
                        {
                             MARSBatchDataStore__c MARSBatchDataStore = new MARSBatchDataStore__c(ApexComponentName__c = 'MARSAccountUpdater', ApexComponentType__c = 'Apex Trigger',
                                                                       MethodName__c = 'MARSAccountUpdater', ErrorMessage__c = 'Bulk Update',
                                                                       OperationType__c = 'OFFICE_UPDATE', SfdcAccountId__c = firmoff.Id,
                                                                       SfdcContactId__c = null, NoOfRetry__c=0,MarsBatchId__c =firmoff.Id+'OFFICE');
                             bulkLoad.add(MARSBatchDataStore);
                         }
                    }
                    if(!bulkLoad.isEmpty())
                    {
                        MarsErrorLogging.createBatchData(bulkLoad);
                    }
                }
                else
                {
                    for(Account firmoff: trigger.new)
                    {
                        MARSMISGateway.SyncAccount(firmoff.Id, 'update');
                    }
                }
            }
        }
    
        if(Trigger.isBefore)
        {
            Set<Id> accountIds = new Set<Id>(); 
            
            if(Trigger.isUpdate)
            {                
                List<Contact> repAddressUpdates= new List<Contact>();
                List<Account> branchFirmNameUpdates=new List<Account>();
                System.debug('\n :In Update');
                for(Account office : marsAccounts)
                {
                    System.debug('SfdcLastActionFrom__c'+office.SfdcLastActionFrom__c);
                    if(office.SfdcLastActionFrom__c == null)
                    {
                        Account oldOffice = Trigger.oldMap.get(office.Id);
                        office.SfdcLastUpdateType__c='O';
                        
                        if(office.MarsOfficeStatCd__c != 'Active' && oldOffice.MarsOfficeStatCd__c == 'Active')
                        {
                            accountIds.add(office.id);
                        }
                        
                        if(office.MarsOfficeStatCd__c != oldOffice.MarsOfficeStatCd__c)
                        {
                            office.MarsOfficeStatUpdDt__c=dateTime.now();
                        }
                        
                        if(office.BillingStreet != oldOffice.BillingStreet || office.BillingCity != oldOffice.BillingCity || office.BillingPostalCode != oldOffice.BillingPostalCode || 
                            office.BillingStateCode != oldOffice.BillingStateCode || office.BillingCountryCode != oldOffice.BillingCountryCode || office.Phone != oldOffice.Phone || office.Fax != oldOffice.Fax)
                        {                            
                            System.debug('Office Id1'+office.id);
                            List<Contact> reps=[SELECT Id,Phone,Fax FROM Contact WHERE AccountId = : office.id and MarsAddrLock__c = 'N'];
                            
                            if(reps.size()>0)
                            {
                                for (Contact rep : reps)  
                                { 
                                   System.debug('rep Id'+rep.id);
                                   Contact updatedContact = new Contact();
                                   updatedContact.Id = rep.Id;
                                   
                                   if(marsDefaults.CustomContactAddress__c)
                                   {
                                        updatedContact.MarsCountryCd__c =office.BillingCountryCode;
                                        updatedContact.MarsCity__c =office.BillingCity;
                                        updatedContact.MarsAddress__c = office.BillingStreet;
                                        updatedContact.MarsStateId__c =office.BillingStateCode;
                                        updatedContact.MarsZip__c =office.BillingPostalCode;
                                   }
                                   else
                                   {
                                       updatedContact.MailingStreet = office.BillingStreet;
                                       updatedContact.MailingCity = office.BillingCity;
                                       updatedContact.MailingStateCode = office.BillingStateCode;
                                       updatedContact.MailingCountryCode = office.BillingCountryCode;
                                       updatedContact.MailingPostalCode = office.BillingPostalCode;
                                   }
                                   if(rep.Phone == oldOffice.Phone)
                                   {
                                       updatedContact.Phone=office.Phone;
                                   }
                                   if(rep.Fax == oldOffice.Fax)
                                   {
                                       updatedContact.Fax=office.Fax;
                                   }
                                   repAddressUpdates.add(updatedContact);
                                }
                            }
                        }                     
                    }
                    else
                    {                    
                        Account oldFirm = Trigger.oldMap.get(office.Id);
                        if(office.MarsFirmNm__c != oldFirm.MarsFirmNm__c)
                        {
                            List<Account> offices=[Select Id from Account where parentID = : office.Id];
                            if(offices.size()>0)
                            {
                                for(Integer i=0;i<offices.size();i++)
                                {
                                    Account branchOffice=new Account(id=offices[i].Id);
                                    branchOffice.MarsFirmNm__c=office.MarsFirmNm__c;
                                    branchFirmNameUpdates.add(branchOffice);
                                }
                            }
                        }
                        if (!branchFirmNameUpdates.isEmpty())
                        { 
                            MarsUtility.BYPASS_ALL_TRIGGER=true;
                            update branchFirmNameUpdates;
                            MarsUtility.BYPASS_ALL_TRIGGER=false;
                        }
                        /*if(office.MarsOfficeId__c == 0 && !(office.Name== 'Unresolved'))
                        {
                            office.MarsOfficeId__c=null;
                        }*/
                        office.SfdcLastActionFrom__c = null;
                    }               
                }
                
                if (!accountIds.isEmpty())
                { 
                    List<Contact> contactUpdates= new List<Contact>();
                    List<Contact> reps=[SELECT Id FROM Contact WHERE AccountId in :accountIds];
                    if(reps.size()>0)
                    {
                        for (Contact rep : reps) 
                        { 
                           Contact updatedContact = new Contact(Id = rep.Id, MarsStatCd__c = 'Inactive', MarsStatUpdDt__c=DateTime.Now() );
                           contactUpdates.add(updatedContact);
                        }
                    }
                    MarsUtility.BYPASS_ALL_TRIGGER=true;
                    update contactUpdates;
                    MarsUtility.BYPASS_ALL_TRIGGER=false;
                }
                if (!repAddressUpdates.isEmpty())
                { 
                    MarsUtility.BYPASS_ALL_TRIGGER=true;
                    update repAddressUpdates;
                    MarsUtility.BYPASS_ALL_TRIGGER=false;
                }
            }
    
            if(Trigger.isInsert)
            {
                for(Account office : marsAccounts)
                {
                    if(office.SfdcLastActionFrom__c == null)
                    {
                        if(office.MarsOfficeStatCd__c==null)
                        {
                            office.MarsOfficeStatCd__c = 'Active';
                        }
                        office.SfdcLastUpdateType__c = 'O';
                    }
                    if(office.SfdcLastActionFrom__c != null)
                    {
                        System.debug('SfdcLastActionFrom__c'+office.SfdcLastActionFrom__c);
                        office.SfdcLastActionFrom__c = null;
                        office.MarsOfficeId__c = null;
                        office.MarsOffFirmType__c = office.MarsFirmType__c;
                        office.MarsOfficeStatCd__c = office.MarsFirmStatCd__c;
                        /*if(office.MarsFirmNm__c != null)
                        {
                            office.MarsShortNm__c = office.MarsFirmNm__c.length()>15?office.MarsFirmNm__c.subString(0,15):office.MarsFirmNm__c;
                        } */
                    }
                }
            }
        }
    }
}