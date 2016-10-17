/**
 *  Description     :   MarsUtility class for database operations
 *
 *  Created By      :
 *
 *  Created Date    :   0//17/2013
 *
 *  Revision Logs   :   V_1.0 - Created
 *
 **/
public with sharing class MarsDatabaseUtiltiy {
    
    //Get firm record by accountId
    public static Account getAccountById(Id accountid) {
        //throw exception if Firm Id is null
        if(accountid == null)
            throw new MarsException('Account Id is null');
            
        //Fetch data from database
        List<Account> accounts = [SELECT AccountSource,AnnualRevenue,BillingCity,BillingCountryCode,BillingPostalCode,BillingStateCode,
                                    BillingStreet,CreatedById,CreatedDate,Description,Fax,Id,
                                    Industry,IsDeleted,Jigsaw,JigsawCompanyId,LastActivityDate,LastModifiedById,
                                    LastModifiedDate,BillingLatitude, BillingLongitude,
                                    MarsCrdId__c,MarsFirmComment__c,MarsOfficeComments__c,
                                    MarsFirmId__c,MarsFirmNm__c,MarsFirmStatCd__c,MarsFirmStatUpdDt__c,
                                    MarsFirmType__c,MarsFirmWebsite__c,MarsGeoConc__c,MarsLastFirmNoteDt__c,MarsLastMeetingDt__c,
                                    MarsLastSaleDt__c,MarsNbrOfRegStates__c,MarsNsccFirmNbr__c,
                                    MarsOffFirmType__c,MarsOfficeId__c,MarsOfficeMgrId__c,MarsOfficeStatCd__c,MarsOfficeStatUpdDt__c,
                                    MarsSalesGoalAmt__c,MarsSdrFlg__c,MarsShortNm__c,MarsTimeZone__c,MasterRecordId,Name,NumberOfEmployees,
                                    OwnerId,ParentId,Parent.MarsFirmId__c,Parent.MarsFirmType__c,Parent.Name,Phone,SfdcLastUpdateType__c,ShippingCity,ShippingCountry,
                                    ShippingPostalCode,ShippingState,ShippingStreet,SicDesc,SystemModstamp,Type,Website,account.CreatedBy.FirstName, 
                                    account.CreatedBy.LastName,account.LastModifiedBy.FirstName, account.LastModifiedBy.LastName
                                    FROM Account
                                    WHERE ID = : accountid and RecordTypeId = : MarsUtility.AccountRecordType limit 1];
                                    
                                    
        
        //Check for the size and throw error if no record in database
        if(accounts.IsEmpty())
            throw new MarsException('Firm/Office not found');        
        
        //return account instance
        return accounts[0];    
    }

    //Get rep record by contactId
    public static Contact getRepById(Id contactId) {

        //throw exception if Rep Id is null
        if(contactId == null)
            throw new MarsException('Contact Id is null');

        //Fetch data from database   
       List<Contact> contacts = [SELECT ID, MarsCountryCd__c,MarsCity__c,MarsAddress__c,MarsStateId__c,MarsZip__c,MarsOfficeId__c, MarsFirmId__c,AccountId,AssistantName,AssistantPhone,Birthdate,
                                    CreatedDate,LastModifiedDate,LastModifiedById,CreatedById,Description,Email,Fax,FirstName,HomePhone, LastName,MailingCity,
                                    MailingCountryCode,MailingPostalCode,MailingStateCode,MailingStreet,MarsAllowMailings__c,
                                    MarsCrdId__c,MarsEmailId2__c,MarsAddrLock__c,
                                    MarsFirstSaleDt__c,MarsFirstSaleProcessDt__c,MarsLastSaleDt__c,
                                    MarsLastCallDt__c,MarsLastFulfillmentDt__c,
                                    MarsLastLetterDt__c,MarsLastMeetingDt__c,MarsLastNoteDt__c,                                    
                                    MarsFirstNm__c,Account.MarsFirmId__c,Account.MarsOfficeId__c,Account.MarsOffFirmType__c,
                                    MarsMailList__c,MarsMiddleNm__c,MarsNickNm__c,MarsRepComments__c,
                                    MarsPersonalInfo__c,MarsPrefixNm__c,MarsRepFirmType__c,MarsRepId__c,MailingLongitude, MailingLatitude,
                                    MarsRepStaffCd__c,MarsRepSuffixNm__c,MarsSpouseNm__c,MarsStatCd__c,MarsStatUpdDt__c,
                                    MarsTimeZone__c,LeadSource,MobilePhone,Name,OwnerId,Phone,Salutation,Title,contact.CreatedBy.FirstName, 
                                    contact.CreatedBy.LastName, contact.LastModifiedBy.FirstName,contact.LastModifiedBy.LastName
                                    FROM Contact
                                    WHERE ID = : contactId and RecordTypeId =: MarsUtility.ContactRecordType];
                                    

        if(contacts.IsEmpty())
            throw new MarsException('Rep not found');

        return contacts[0];

    }   
}