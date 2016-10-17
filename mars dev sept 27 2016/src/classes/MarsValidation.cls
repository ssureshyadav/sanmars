public class MarsValidation
{
    /*
        Return Values
            -1 : validation failed
             0 : no additional processing required in parent
             1 : additional processing in parent
    */
    
    public static integer retval;
    
    public static integer validateFirm(List<MARSFirmSummary__c> lstNewRecords, Map<Id,MARSFirmSummary__c> lstOldRecords, String action)
    {
        if(action == 'DELETE')
        {
            for(MARSFirmSummary__c firm:lstOldRecords.values()){
                firm.addError('Mars Firm cannot be deleted');
                retval = -1;
                return retval;
            }
        }
        for(MARSFirmSummary__c firm:lstNewRecords)
        {
            MARSFirmSummary__c oldFirm=new MARSFirmSummary__c();
            if(action == 'INSERT')
            {
                 oldFirm= firm;
            }
            else if(action == 'UPDATE')
            {    
                oldFirm= lstOldRecords.get(firm.Id);
            }

            if(action == 'UPDATE')
            {                    
                if(firm.MarsCrdId__c!=null && firm.MarsCrdId__c!=oldfirm.MarsCrdId__c)
                {
                    firm.MarsCrdId__c=firm.MarsCrdId__c.toUpperCase();
                    if(checkcrdId('MARSFirmSummary__c',firm.MarsCrdId__c) > 0)
                    {
                        firm.MarsCrdId__c.addError('CRD already defined for another firm.');
                        retval = -1;
                        return retval;
                    }
                }
            
                if(firm.MarsFirmId__c == 0)
                {
                    firm.Name.addError('This is a System record and should not be modified.');
                    retval = -1;
                    return retval;
                }
                
                if(firm.MarsFirmType__c != oldfirm.MarsFirmType__c)
                {
                    firm.MarsFirmType__c.addError('Firm Type cannot be modified');
                    retval = -1;
                    return retval;
                }
                
                if(firm.MarsShortNm__c != oldfirm.MarsShortNm__c)
                {
                    firm.MarsShortNm__c.addError('Short Name cannot be modified');
                    retval = -1;
                    return retval;
                }
                
                if(firm.MarsFirmId__c != oldfirm.MarsFirmId__c && oldfirm.MarsFirmId__c != null)
                {
                    firm.MarsFirmId__c.addError('Firm Id cannot be modified');
                    retval = -1;
                    return retval;
                }
            }
            else if(action == 'INSERT')
            {
                if(!String.IsEmpty(firm.MarsCrdId__c))
                {
                    firm.MarsCrdId__c=firm.MarsCrdId__c.toUpperCase();
                    if(checkcrdId('MARSFirmSummary__c',firm.MarsCrdId__c) > 0)
                    {
                        firm.MarsCrdId__c.addError('CRD already defined for another firm.');
                        retval = -1;
                        return retval;
                    }
                }
                
                if(firm.MarsFirmId__c != null)
                {
                    firm.MarsFirmId__c.addError('Firm Id cannot be modified');
                    retval = -1;  
                    return retval;
                }
            }
        }
        retval = 1;
        return retval;
    }

    private static integer checkcrdId(String objectName,String crdid){
        return DataBase.countQuery('SELECT COUNT() FROM '+ ObjectName +' WHERE MarsCrdId__c = '+ '\''+crdid+'\'');
    }
    
    public static integer validateAccount(List<Account> lstNewRecords, Map<Id,Account> lstOldRecords, String action)
    {
        MARSDefaults__c defaults=MarsUtility.MARS_DEFAULTS;
        Id firmoffRecordTypeId = MarsUtility.AccountRecordType;
        List<Id> lstParentAccountIds=new List<Id>();
        
        for(Account account:lstNewRecords)
        {
            if(action == 'DELETE')
            {
                //record type other than MARS
                if(account.RecordTypeId != firmoffRecordTypeId)
                {
                    retval = 0;
                    return retval;
                }
                if(account.SfdcLastActionFrom__c == null)
                { 
                    account.addError('Mars Office cannot be deleted');
                    retval = -1;
                    return retval;
                }
                else 
                {
                    account.addError('Mars Firm cannot be deleted');
                    retval = -1;
                    return retval;
                }
            }
            else
            {
                Account oldAccount=new Account();
                if(action == 'INSERT')
                {
                     oldAccount = account;
                }
                else if(action == 'UPDATE')
                {    
                    oldAccount = lstOldRecords.get(account.Id);
                }
                if((action == 'INSERT' && account.RecordTypeId != firmoffRecordTypeId)
                    ||(action == 'UPDATE' && account.RecordTypeId != firmoffRecordTypeId && oldAccount.RecordTypeId != firmoffRecordTypeId))
                {
                    retval = 0;
                    return retval;
                }
                //office validation
                System.debug(account.SfdcLastUpdateType__c+account.SfdcLastActionFrom__c);
                if(account.SfdcLastActionFrom__c == null)
                {                    
                    if(action == 'UPDATE')
                    {                    
                        if (account.MarsSummaryUpdateTime__c != oldAccount.MarsSummaryUpdateTime__c)
                        {
                            retval = 0;
                            return retval;
                        }
                        
                        if(account.RecordTypeId != firmoffRecordTypeId)
                        {
                            account.addError('Mars Record Type cannot be changed');
                            retval = -1;
                            return retval;
                        }
                        
                        if(account.MarsFirmType__c != oldAccount.MarsFirmType__c)
                        {
                            account.MarsFirmType__c.addError('Firm Type cannot be modified');
                            retval = -1;
                            return retval;
                        }
                        
                        if(account.MarsOffFirmType__c!= account.MarsOffFirmType__c)
                        {
                            account.MarsOffFirmType__c.addError('Office Firm Type cannot be modified');
                            retval = -1;
                            return retval;
                        }
                        
                        if(account.MarsShortNm__c != oldAccount.MarsShortNm__c)
                        {
                            account.MarsShortNm__c.addError('Short Name cannot be modified');
                            retval = -1;
                            return retval;
                        }
                        
                        if(oldAccount.ParentId == null && account.ParentId != null && oldAccount.RecordTypeId == firmoffRecordTypeId)
                        {
                            account.ParentId.addError('Parent Account cannot be assigned to an office that is already a parent.');
                            retval = -1;
                            return retval;
                        }
                        else if(oldAccount.ParentId != account.ParentId && oldAccount.RecordTypeId == firmoffRecordTypeId)
                        {
                            account.ParentId.addError('Parent Account cannot be modified.');
                            retval = -1;
                            return retval;
                        }
                        else if(account.ParentId == null && oldAccount.RecordTypeId != firmoffRecordTypeId && account.RecordTypeId == firmoffRecordTypeId)
                        {
                            account.ParentId.addError('Parent Account cannot be blank.');
                            retval = -1;
                            return retval;
                        }
                    
                        //BUG73586 Removed the validation rule and added validation rule logic.
                        if(account.MarsOfficeId__c == 0)
                        {
                            account.addError('This is a System record and should not be modified.');
                            retval = -1;
                            return retval;
                        }
                    
                        //BUG73487 Status Of home office should be controlled by parent.
                        if(account.ParentId==null && account.MarsOfficeStatCd__c != oldAccount.MarsOfficeStatCd__c)
                        {
                            account.MarsOfficeStatCd__c.addError('Status of Parent Account cannot be modified.');
                            retval = -1;
                            return retval;
                        }                        
    
                        //&& oldAccount.MarsCrdId__c != null
                        if((account.MarsCrdId__c != oldAccount.MarsCrdId__c))
                        {
                            account.MarsCrdId__c.addError('CRD cannot be modified from office.');
                            retval = -1;
                            return retval;
                        }
                        
                        if(account.MarsOfficeId__c != oldAccount.MarsOfficeId__c)
                        {
                            account.MarsOfficeId__c.addError('Office Id cannot be modified');
                            retval = -1;
                            return retval;
                        }
                    }
                    else if(action == 'INSERT')
                    {
                        if(account.MarsCrdId__c != null)
                        {
                            account.MarsCrdId__c.addError('CRD cannot be modified from office.');
                            retval = -1; 
                            return retval;
                        }
                        if(account.MarsOfficeId__c != null)
                        {
                            account.MarsOfficeId__c.addError('Office Id cannot be modified');
                            retval = -1;
                            return retval;
                        }
                        if(account.ParentId == null)
                        {
                            account.ParentId.addError('Parent Account cannot be blank.');
                            retval = -1;
                            return retval;
                        }
                    }
                    if(account.ParentId != null)
                    {
                        lstParentAccountIds.add(account.ParentId); 
                    }
                }
                // firm validations
                else
                {
                   if(account.SfdcLastActionFrom__c =='F'){
                       account.addError('Firm Operation cannot be Performed from Office');
                       retval = -1;
                       return retval;
                   }
                }           
                //address validation
                if(String.isBlank(account.BillingStreet))
                {
                    account.BillingStreet.addError('Billing Street should not be null.');
                    retval = -1;
                    return retval;
                }
                if(String.isBlank(account.BillingCity))
                {
                    account.BillingCity.addError('Billing City should not be null.');
                    retval = -1;
                    return retval;
                }
                if(String.isBlank(account.BillingCountryCode) || (account.BillingCountryCode==null))
                {
                    account.BillingCountryCode.addError('Billing Country should not be null.');
                    retval = -1;
                    return retval;
                }
                if(account.BillingCountryCode == 'US' && (String.isBlank(account.BillingStateCode) || (account.BillingStateCode==null)))
                {
                    account.BillingStateCode.addError('Billing State should not be null.');
                    retval = -1;
                    return retval;
                }                
                if(account.BillingCountryCode == 'US' && String.isBlank(account.BillingPostalCode))
                {
                    account.BillingPostalCode.addError('Billing Zip/Postal Code should not be null.');
                    retval = -1;
                    return retval;
                }
                if(account.SFDCFirmSumId__c != oldAccount.SFDCFirmSumId__c && oldAccount.SFDCFirmSumId__c != null)
                {
                    account.SFDCFirmSumId__c.addError('Firm cannot be changed');
                    retval = -1;
                    return retval;
                }
                
            }
        }
        
        System.debug('\n lst'+lstParentAccountIds);
        if(!lstParentAccountIds.IsEmpty())
        {
            MAP<ID,MARSFirmSummary__c> mapParentAccount= new MAP<ID,MARSFirmSummary__c>();
            List<MARSFirmSummary__c> lstFirmSummary= [Select Id,SfdcFirmId__c,SfdcFirmId__r.RecordTypeId,SfdcFirmId__r.ParentId,SfdcFirmId__r.MarsFirmId__c,SfdcFirmId__r.MarsFirmNm__c,SfdcFirmId__r.MarsFirmType__c,SfdcFirmId__r.MarsFirmStatCd__c,SfdcFirmId__r.MarsOfficeStatCd__c from MARSFirmSummary__c Where SfdcFirmId__c IN : lstParentAccountIds];
            //MAP<ID,Account> mapParentAccount= new MAP<ID,Account>([Select Id, RecordTypeId, ParentId ,MarsFirmId__c,MarsFirmNm__c,MarsFirmType__c,MarsOfficeStatCd__c from Account where Id in: lstParentAccountIds]);
            if(!lstFirmSummary.isEmpty())
            {
                for(MARSFirmSummary__c summary:lstFirmSummary)
                {
                    mapParentAccount.put(summary.SfdcFirmId__c,summary);
                }
            }
            for(Account paValidation:lstNewRecords)
            {
                if(paValidation.parentId != null)
                {
                    if(paValidation.MarsOfficeStatCd__c == 'Active' && mapParentAccount.get(paValidation.parentId).SfdcFirmId__r.MarsFirmStatCd__c != paValidation.MarsOfficeStatCd__c)
                    {
                         paValidation.MarsOfficeStatCd__c.addError('Office Status cannot be made active for inactive Firm');
                         retval = -1;
                         return retval;
                    }
                    if(mapParentAccount.get(paValidation.parentId).SfdcFirmId__r.RecordTypeId != firmoffRecordTypeId)
                    {
                         paValidation.ParentId.addError('Only MARS account can be a Parent Account.');
                         retval = -1;
                         return retval;
                    }
    
                    if(mapParentAccount.get(paValidation.parentId).SfdcFirmId__r.ParentId != null)
                    {
                        paValidation.ParentId.addError('Only Firms can be a Parent Account.');
                        retval = -1;
                        return retval;
                    }
                    else
                    {
                        paValidation.MarsFirmId__c = mapParentAccount.get(paValidation.parentId).SfdcFirmId__r.MarsFirmId__c;
                        paValidation.MarsFirmNm__c = mapParentAccount.get(paValidation.parentId).SfdcFirmId__r.MarsFirmNm__c;
                        paValidation.MarsOffFirmType__c = mapParentAccount.get(paValidation.parentId).SfdcFirmId__r.MarsFirmType__c;
                        if(paValidation.MarsOfficeStatCd__c ==null){
                            paValidation.MarsOfficeStatCd__c = mapParentAccount.get(paValidation.parentId).SfdcFirmId__r.MarsFirmStatCd__c;
                        }
                        paValidation.SFDCFirmSumId__c = mapParentAccount.get(paValidation.ParentId).Id;
                    }
                }
            }
        }
        retval = 1;
        return retval;
    }

    public static Integer ValidateContact(List<Contact> lstRecords,Map<Id,Contact> lstOldRecords ,String action)
    {
        MARSDefaults__c defaults=MarsUtility.MARS_DEFAULTS;
        Boolean repMove=defaults.AllowRepMove__c;
        Boolean statusChanged=false;
        
        Id officeRecordTypeId = MarsUtility.AccountRecordType;
        Id repRecordTypeId = MarsUtility.ContactRecordType;        
        list<Id> lstAccountIds=new List<Id>();

        for(Contact contact:lstRecords)
        {
            if(action == 'DELETE')
            {
                //record type other than MARS
                if(contact.RecordTypeId != repRecordTypeId)
                {
                    retval = 0;
                    return retval;
                }
                else
                {
                    contact.addError('Mars Contacts cannot be deleted');
                    retval = -1;
                    return retval;
                }
            }
            else
            {
                Contact oldRep=new Contact();
                if(action == 'INSERT')
                {
                     oldRep = contact;
                }
                else if(action == 'UPDATE')
                {    
                    oldRep = lstOldRecords.get(contact.Id);
                }

                if(!String.IsEmpty(contact.MarsCrdId__c))
                {
                    contact.MarsCrdId__c=contact.MarsCrdId__c.toUpperCase();
                }

                if((action == 'INSERT' && contact.RecordTypeId != repRecordTypeId)
                    ||(action == 'UPDATE' && contact.RecordTypeId != repRecordTypeId && repRecordTypeId != oldRep.RecordTypeId))
                {
                    retval = 0;
                    return retval;
                }

                if(action == 'UPDATE')
                {
                    if (contact.MarsSummaryUpdateTime__c != oldRep.MarsSummaryUpdateTime__c)
                    {
                        retval = 0;
                        return retval;
                    }
                    if(contact.RecordTypeId != repRecordTypeId)
                    {
                        contact.addError('Mars Record Type cannot be changed.');
                        retval = -1;
                        return retval;
                    }
                    
                    if(contact.MarsRepId__c != oldRep.MarsRepId__c)
                    {
                        contact.MarsRepId__c.addError('Mars Rep Id cannot be changed.');
                        retval = -1;
                        return retval;
                    }
                    
                    if(contact.MarsRepStaffCd__c != oldRep.MARSRepStaffCd__c)
                    {
                        contact.MarsRepStaffCd__c.addError('MARS Staff code cannot be modified.');
                        retval = -1;
                        return retval;
                    }
                    
                    if(contact.MarsRepFirmType__c != oldRep.MarsRepFirmType__c)
                    {
                        contact.MarsRepFirmType__c.addError('MARS rep type cannot be modified.');
                        retval = -1;
                        return retval;
                    }
                    
                    if(contact.MarsFirmTypeOverrideFlg__c != oldRep.MarsFirmTypeOverrideFlg__c)
                    {
                        contact.MarsFirmTypeOverrideFlg__c.addError('MARS Firm type Override Flag cannot be modified.');
                        retval = -1;
                        return retval;
                    }
                    

                    if(!repMove)
                    {
                        if(contact.AccountId != oldRep.AccountId && oldRep.RecordTypeId==repRecordTypeId)
                        {
                           contact.AccountId.addError('Rep cannot be moved; Please check with Sys Admin.');
                           retval = -1;
                           return retval;   
                        }
                    }
                    else if(repMove)
                    {
                        if(contact.AccountId != oldRep.AccountId)
                        {
                            if(contact.MarsRepStaffCd__c == 'T')
                            {
                                contact.AccountId.addError('Team Rep cannot be moved in SFDC.');
                                retval = -1;
                                return retval;
                            }
                            else if([SELECT COUNT() FROM MarsRepTeam__c WHERE SfdcRepId__c = :contact.Id] > 0)
                            {
                                contact.AccountId.addError('Member of Rep Teams cannot be moved in SFDC.');
                                retval = -1;
                                return retval;
                            }
                        }
                    }
                    if(contact.MarsRepStaffCd__c == 'T')
                    {
                        if(contact.MarsCrdId__c != null)
                        {
                           contact.MarsCrdId__c.addError('Crd Id cannot be specified for Team Rep.');
                           retval = -1;
                           return retval;   
                        }
                        if(contact.Title != null)
                        {
                           contact.Title.addError('Title cannot be specified for Team Rep.');
                           retval = -1;
                           return retval;   
                        }
                        if(contact.AssistantName != null)
                        {
                           contact.AssistantName.addError('Assistant Name cannot be specified for Team Rep.');
                           retval = -1;
                           return retval;   
                        }
                        if(contact.MarsStatCd__c != oldRep.MarsStatCd__c)
                        {
                           contact.MarsStatCd__c.addError('Status of Team Rep cannot be modified.');
                           retval = -1;
                           return retval;   
                        }
                    }
                }                
                else if(action == 'INSERT')
                {
                    if(contact.MarsRepId__c != null)
                    {
                        contact.MarsRepId__c.addError('Mars Rep Id should not be specified.');
                        retval = -1;
                        return retval; 
                    }
                }
                
                //address validation
                if(String.isBlank(contact.MailingStreet))
                {
                    contact.MailingStreet.addError('Mailing Street should not be null.');
                    retval = -1;
                    return retval;
                }
                
                if(String.isBlank(contact.MailingCity))
                {
                    contact.MailingCity.addError('Mailing City should not be null.');
                    retval = -1;
                    return retval;
                }
                
                if(String.isBlank(contact.MailingCountryCode)||(contact.MailingCountryCode==null))
                {
                    contact.MailingCountryCode.addError('Mailing Country should not be null.');
                    retval = -1;
                    return retval;
                }
                
                if(contact.MailingCountryCode=='US' && (String.isBlank(contact.MailingStateCode)||(contact.MailingStateCode==null)))
                {
                    contact.MailingStateCode.addError('Mailing State should not be null.');
                    retval = -1;
                    return retval;
                }
                
                if(contact.MailingCountryCode=='US' && String.isBlank(contact.MailingPostalCode))
                {
                    contact.MailingPostalCode.addError('Mailing Zip/Postal Code should not be null.');
                    retval = -1;
                    return retval;
                }
                
                if(contact.SFDCFirmSumId__c != oldRep.SFDCFirmSumId__c && oldRep.SFDCFirmSumId__c != null)
                {
                    contact.SFDCFirmSumId__c.addError('Firm cannot be changed');
                    retval = -1;
                    return retval;
                }
                
                
                
                if(contact.MarsRepId__c == 0)
                {
                    contact.addError('This is a System record and should not be modified.');
                    retval = -1;
                    return retval;
                }
                
                if(contact.AccountId==null)
                { 
                    contact.AccountId.addError('Account cannot be blank.');
                    retval = -1;
                    return retval;
                }
                else
                {
                    lstAccountIds.add(contact.AccountId);
                }
                
                
            }
        }

        if(!lstAccountIds.IsEmpty())
        {
            Map<Id,Account> mapAccount=new Map<Id,Account>([Select Id, RecordTypeId,MarsOfficeStatCd__c from Account where Id IN : lstAccountIds]);
            for(Contact con:lstRecords)
            {
                if(mapAccount.get(con.AccountId).RecordTypeId != officeRecordTypeId)
                {
                    con.AccountId.addError('Only MARS Office can be selected.');
                    retval = -1;
                    return retval;
                }
                if(con.MarsStatCd__c == 'Active' && mapAccount.get(con.AccountId).MarsOfficeStatCd__c != con.MarsStatCd__c)
                {
                    con.MarsStatCd__c.addError('Rep Status cannot be made active for inactive office.');
                    retval = -1;
                    return retval;
                }                
                
            }
        }
        retval = 1;
        return retval;
    }
}