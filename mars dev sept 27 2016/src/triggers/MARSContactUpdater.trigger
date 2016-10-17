/** Description     :   Trigger responsible for all pre and post processing of contact record.
 *
 *  Created By      :
 *
 *  Created Date    :   07/02/2013
 *
 *  Revision Log    :   V_1.0
 *
 * BUG73485: Made the changes for obj.MarsCrdId__c=obj.MarsCrdId__c.toUpperCase(); in the Before Trigger
 Last Modified Details
    Date        User        Purpose
    --------------------------------------------------------------
    12/2/2013    Suresh     BUG73663
    --------------------------------------------------------------
**/

trigger MARSContactUpdater on Contact (before insert,before update,after insert, after update ,before delete, after delete )
{    
    MARSDefaults__c marsDefaults = MarsUtility.MARS_DEFAULTS;
    integer validationResult;
    boolean    contactConversionflg = False;

    //Check for static flag value
    if(MarsUtility.BYPASS_ALL_TRIGGER || (marsDefaults.IntegrationType__c == 0))
        return;
    
    //Manning Rep Summary nightly job fails    
    if(trigger.isAfter && !trigger.isdelete)
    {
        if(MarsValidation.retval != 1)
        return;
    }
        
    List<Contact> marsContacts=new List<Contact>();
    Id repRecordTypeId = MarsUtility.ContactRecordType;
    
    if(trigger.isAfter && trigger.isdelete)
    {
        for(Contact contact:Trigger.old)
        {
            if(contact.RecordTypeId == repRecordTypeId)
            {
                marsContacts.add(contact);
            }
        }
        
        if(marsContacts.isEmpty())
        {
            return;
        }
    }
    
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate))
    {
        for(Contact contact:Trigger.new)
        {
            if(trigger.isUpdate)
            {
                if (contact.RecordTypeId == repRecordTypeId || Trigger.oldMap.get(contact.Id).RecordTypeId == repRecordTypeId)
                {
                   if(contact.MarsSummaryUpdateTime__c != Trigger.oldMap.get(contact.Id).MarsSummaryUpdateTime__c)
                   {
                   return;
                   }
                   else
                   marsContacts.add(contact);
                }
            }
                       
            if(trigger.isInsert && contact.RecordTypeId == repRecordTypeId) //record type = MARS
            {
                marsContacts.add(contact);
            }
        }
        System.debug(LoggingLevel.ERROR, 'CpuTime: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime());
        if(marsContacts.isEmpty())
        {
            return;
        }
    }
    
    
    Boolean marsFieldUpdated=false;
    Map<String, Schema.SObjectField> contactFields = Schema.SObjectType.Contact.fields.getMap();      
    if(trigger.isUpdate && Trigger.isBefore)
    { 
       for(Contact cont:marsContacts)
       {
           System.debug(LoggingLevel.ERROR, 'one time CpuTime: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime());
           if (cont.MarsSummaryUpdateTime__c != Trigger.oldMap.get(cont.Id).MarsSummaryUpdateTime__c){
               return;
           }
           else if(marsFieldUpdated)
           {
               System.debug('\n Inside Break');
               break; 
           }
           else
               MarsUpdateFields(cont,Trigger.oldMap.get(cont.Id));
       }
       if(!marsFieldUpdated)
       {
           return;
       }
    }
        
    public void  MarsUpdateFields(Contact newValues,Contact oldValues)
    {
        List<String> contStandardFields=new List<String>{'AccountId','FirstName','LastName','Title','Salutation','Birthdate','mailingStreet','MailingCity','MailingStateCode','MailingPostalCode','MailingCountryCode','Phone','Fax','Email','MailingLatitude','MailingLongitude','RecordTypeId', 'AssistantName','MobilePhone'};
        //Map<String,String> contStandardFields =new Map<String,String>{'AccountId' => 'accountId','FirstName' => 'FirstName','LastName' => 'LastName','Title' => 'title','Salutation' => 'salutation','Birthdate' => 'birthdate','mailingStreet' => 'mailingStreet','mailingCity' => 'MailingCity','mailingStateCode' => 'mailingStateCode','mailingPostalCode' => 'mailingPostalCode','mailingCountryCode' => 'mailingCountryCode','phone' => 'Phone','fax' => 'Fax','email' => 'email','mailingLatitude' => 'mailingLatitude','mailingLongitude' => 'mailingLongitude','recordTypeId' => 'recordTypeId'};
        for (String str : contactFields.keyset())
        {
            if(str.contains('__c'))
            {
                if(String.valueOf(contactFields.get(str)).contains('marssfs'))
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
                if(str != 'id' && str != 'isdeleted' && str != 'masterrecordid' &&  newValues.get(str) != oldValues.get(str))
                {
                     for(String standardField:contStandardFields)
                     {
                        if(standardField == str)
                        {
                            marsFieldUpdated=true;
                            return;
                        }
                    }
                }
            }
        }
    }

    if(trigger.isDelete && trigger.isAfter)
        MarsValidation.ValidateContact(marsContacts,Trigger.OldMap,'DELETE'); 
    else if(trigger.isUpdate && Trigger.isBefore)
        MarsValidation.ValidateContact(marsContacts,Trigger.OldMap,'UPDATE');
    else if(trigger.isInsert && Trigger.isBefore)
        MarsValidation.ValidateContact(marsContacts,Trigger.OldMap,'INSERT');

    validationResult = MarsValidation.retval;
    System.debug('\n : validationResult' + validationResult);
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
                if(trigger.new.size() > 1 && bulkLoadEnabled==True)
                {
                    List<MARSBatchDataStore__c> bulkLoad=new List<MARSBatchDataStore__c>();
                    for(Contact rep : trigger.new)
                    {
                        if(rep.RecordTypeId == repRecordTypeId)
                        {
                            MARSBatchDataStore__c MARSBatchDataStore = new MARSBatchDataStore__c(ApexComponentName__c = 'MARSContactUpdater', ApexComponentType__c = 'Apex Trigger',
                                                                       MethodName__c = 'MARSContactUpdater', ErrorMessage__c = 'Bulk Insert',
                                                                       OperationType__c = 'REP_INSERT', SfdcAccountId__c = null,
                                                                       SfdcContactId__c = rep.Id, NoOfRetry__c=0,MarsBatchId__c =rep.Id+'REP');
                            bulkLoad.add(MARSBatchDataStore);
                        }
                    }
                    if(!bulkLoad.isEmpty())
                        MarsErrorLogging.createBatchData(bulkLoad);
                }
                else
                {
                    for(Contact rep : trigger.new)
                    {
                        MARSMISGateway.syncContact(rep.Id, 'insert');
                    }
                }
            }
        
            //Check for request type
            if(Trigger.isUpdate)
            {
                //Make callouts only if 1 record is being created. Bulk will be handled by batch process
                if(trigger.new.size() > 1 && bulkLoadEnabled==True)
                {
                    List<MARSBatchDataStore__c> bulkLoad=new List<MARSBatchDataStore__c>();
                    for(Contact rep : trigger.new)
                    {
                        if(rep.RecordTypeId == repRecordTypeId)
                        {
                            MARSBatchDataStore__c MARSBatchDataStore = new MARSBatchDataStore__c(ApexComponentName__c = 'MARSContactUpdater', ApexComponentType__c = 'Apex Trigger',
                                                                       MethodName__c = 'MARSContactUpdater', ErrorMessage__c = 'Bulk Update',
                                                                       OperationType__c = 'REP_UPDATE', SfdcAccountId__c = null,
                                                                       SfdcContactId__c = rep.Id, NoOfRetry__c=0,MarsBatchId__c =rep.Id+'REP');
                            bulkLoad.add(MARSBatchDataStore);
                        }
                    }
                    if(!bulkLoad.isEmpty())
                        MarsErrorLogging.createBatchData(bulkLoad);
                }
                else
                {
                    for(Contact rep : trigger.new)
                    {
                        if(rep.AccountId != null && rep.MarsRepId__c != null && 
                            rep.AccountId != Trigger.oldMap.get(rep.Id).AccountId)
                        {                            
                            String repid=String.valueOf(rep.MarsRepId__c);                        
                            String officeid=String.valueOf(rep.MarsOfficeId__c);                        
                            MARSMISGateway.moveContact(repid, officeid, rep.Id);                        
                        }
                        else
                        {
                            //Calling MarsISgateway class for updating rep
                            MARSMISGateway.syncContact(rep.Id, 'update');
                        }                    
                    }
                }
            }
          /*  if(Trigger.isDelete)
            {
                //Map to hold master record id associated with the contact
                Map<Id , Contact> mapMasterRecordIdWithContact = new Map<Id , Contact>();
                
                //loop through deleted contact records
                for(Contact contact : Trigger.old)
                {
                    //Check for null value and check for execution of merge statement
                    if(contact.MarsRepId__c != null && contact.MasterRecordId != null)
                    {
                        //Populate the map with keys and values where key is master record id and value is contact
                        mapMasterRecordIdWithContact.put(contact.MasterRecordId , contact);
                    }
                } 
                
                //loop through map values
                for(Contact survivingContact : [Select ID, MarsRepId__c FROM Contact Where ID IN : mapMasterRecordIdWithContact.keySet()])
                {
                    //Calling Future Class Method for making the web service callouts for merge Rep record at MARS
                    MARSMISGateway.mergeContact(mapMasterRecordIdWithContact.get(survivingContact.ID).MarsRepId__c, survivingContact.MarsRepId__c,survivingContact.Id);
                }
            } */
        }

        if(Trigger.isBefore && !(Trigger.isDelete))
        {        
            Set<ID> setConIds = new Set<ID>();
            for(Contact obj : marsContacts)
            {
                if(obj.AccountId!= null){
                    setConIds.add(obj.AccountId);
                }        
            } 

            MAP<ID , Account> mapCon = new MAP<ID , Account>([Select Id,BillingCity,BillingCountryCode,BillingPostalCode,BillingStateCode,BillingStreet,MarsOffFirmType__c,MarsFirmId__c,MarsOfficeId__c,Phone,Fax, SFDCFirmSumId__c from Account where id in: setConIds]);
            for(Contact obj : marsContacts)
            {   
                if(obj.AccountId != null)
                {
                    Account office = mapCon.get(obj.AccountId);
                    if(Trigger.isUpdate)
                    {
                        Contact oldContact = Trigger.oldMap.get(obj.Id);
                        if(marsDefaults.CustomContactAddress__c && (oldContact.RecordTypeId != repRecordTypeId)  && (obj.RecordTypeId == repRecordTypeId))
                        {
                            contactConversionflg = True;
                            obj.MarsCountryCd__c = obj.MailingCountryCode;
                            obj.MarsCity__c = obj.MailingCity;
                            obj.MarsAddress__c = obj.MailingStreet;
                            obj.MarsStateId__c = obj.MailingStateCode;
                            obj.MarsZip__c = obj.MailingPostalCode;
                        }
                        
                        if(oldContact.RecordTypeId==repRecordTypeId)
                        {
                            //if marsfirmtype==n
                            if(obj.MarsFirmTypeOverrideFlg__c != 'Y' && obj.AccountId != oldContact.AccountId)
                            {
                                obj.MarsRepFirmType__c=office.MarsOffFirmType__c;
                            }
                            obj.MarsFirmId__c=office.MarsFirmId__c;
                            obj.MarsOfficeId__c=office.MarsOfficeId__c;
                            obj.SFDCFirmSumId__c=office.SFDCFirmSumId__c;
                            
                            if(obj.FirstName != oldContact.FirstName)
                            {
                                if(obj.FirstName != null)
                                { 
                                    obj.MarsFirstNm__c=obj.FirstName;
                                }
                                else
                                {
                                    obj.MarsFirstNm__c=' ';
                                }
                            }
                            if(obj.MarsStatCd__c !=oldContact.MarsStatCd__c){
                                obj.MarsStatUpdDt__c=dateTime.now();
                            }
                        }
                        else
                        {
                            obj.MarsRepFirmType__c=office.MarsOffFirmType__c;
                            obj.MarsFirmId__c=office.MarsFirmId__c;
                            obj.MarsOfficeId__c=office.MarsOfficeId__c;
                            obj.SFDCFirmSumId__c=office.SFDCFirmSumId__c;
                            obj.MarsStatUpdDt__c=Datetime.now();
                            obj.MarsRepStaffCd__c='R';
                            if(obj.FirstName != null)
                            {
                                obj.MarsFirstNm__c=obj.FirstName;
                            }
                            else
                            {
                                obj.MarsFirstNm__c=' ';
                            }
                            if (obj.MarsStatCd__c==null)
                            {
                                obj.MarsStatCd__c='Active';
                            }
                        }
                    }
                    if(Trigger.isInsert)
                    {
                        obj.MarsRepFirmType__c=office.MarsOffFirmType__c;
                        obj.MarsFirmId__c=office.MarsFirmId__c;
                        obj.MarsOfficeId__c=office.MarsOfficeId__c;
                        obj.SFDCFirmSumId__c=office.SFDCFirmSumId__c;
                        obj.MarsStatUpdDt__c=Datetime.now();
                        obj.MarsRepStaffCd__c='R';
                        if(obj.FirstName != null)
                        {
                            obj.MarsFirstNm__c=obj.FirstName;
                        }
                        else
                        {
                            obj.MarsFirstNm__c=' ';
                        }
                        if (obj.MarsStatCd__c==null)
                        {
                            obj.MarsStatCd__c='Active';
                        }
                        if(marsDefaults.CustomContactAddress__c)
                        {
                            obj.MarsCountryCd__c =obj.MailingCountryCode;
                            obj.MarsCity__c =obj.MailingCity;
                            obj.MarsAddress__c = obj.MailingStreet;
                            obj.MarsStateId__c =obj.MailingStateCode;
                            obj.MarsZip__c =obj.MailingPostalCode;
                        }
                    }
                    
                    if(contactConversionflg)
                    {
                        if(obj.MarsAddress__c != office.billingStreet ||
                            obj.MarsCity__c != office.billingCity ||
                            obj.MarsStateId__c != office.billingStateCode ||
                            obj.MarsZip__c != office.billingPostalCode ||
                            obj.MarsCountryCd__c != office.billingCountryCode)
                        {
                            obj.MarsAddrLock__c='Y';
                        }
                        else
                        { 
                            obj.MarsAddrLock__c = 'N';
                            //BUG73663 When Both the address are same.
                            if(obj.phone==null)
                            {
                                obj.Phone=office.Phone;
                            }
                            if(obj.fax==null)
                            {
                                obj.Fax=office.Fax;
                            }
                        }
                    }
                    else if((marsDefaults.CustomContactAddress__c && Trigger.isInsert)||(!marsDefaults.CustomContactAddress__c))
                    {
                        /*if(obj.MailingStreet.contains('\n'))
                        {
                            obj.MailingStreet =obj.MailingStreet.replaceall('\\s','');
                        }*/
                        
                        if(obj.MailingStreet.normalizeSpace() != office.billingStreet.normalizeSpace() ||
                            obj.MailingStateCode != office.billingStateCode ||
                            obj.MailingPostalCode != office.billingPostalCode ||
                            obj.MailingCountryCode != office.billingCountryCode)
                        {
                            obj.MarsAddrLock__c='Y';
                            System.debug('Addr Lock'+obj.MarsAddrLock__c);
                        }
                        else
                        { 
                            obj.MarsAddrLock__c = 'N';
                        }
                        //BUG73663 When Both the address are same.
                        if(obj.phone==null)
                        {
                            obj.Phone=office.Phone;
                        }
                        if(obj.fax==null)
                        {
                            obj.Fax=office.Fax;
                        }
                    }
                }
            }
        }
    }    
}