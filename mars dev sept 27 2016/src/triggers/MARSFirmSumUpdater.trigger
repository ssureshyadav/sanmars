trigger MARSFirmSumUpdater on MARSFirmSummary__c (before update,before delete) {    

    MARSDefaults__c marsDefaults = MarsUtility.MARS_DEFAULTS;
    
    if(MarsUtility.BYPASS_ALL_TRIGGER || (marsDefaults.IntegrationType__c == 0))
        return;
        
    if(Trigger.isUpdate)
    {
        for(MARSFirmSummary__c firmsum:Trigger.new)
        {
            MARSFirmSummary__c oldfirmSum=Trigger.OldMap.get(firmsum.Id);
            if (firmsum.MarsSummaryUpdateTime__c != oldfirmSum.MarsSummaryUpdateTime__c)
            {
                return;
            }
        }
        integer retval=MarsValidation.validateFirm(Trigger.new,Trigger.oldMap,'UPDATE');
        if(retval ==1){
            updateAccount(Trigger.new,Trigger.oldMap);
        }
    }
    else if(Trigger.isDelete)
    {
        MarsValidation.validateFirm(Trigger.new,Trigger.oldMap,'DELETE');
    }
    
    public void updateAccount(List<MARSFirmSummary__c> newValues,Map<Id,MARSFirmSummary__c> oldValues)
    {
        Set<MARSFirmSummary__c> lstupdateAccounts=new Set<MARSFirmSummary__c>();
        Map<String, Schema.SObjectField> firmFields = Schema.SObjectType.MARSFirmSummary__c.fields.getMap();
        for(MARSFirmSummary__c firmsum:newValues)
        {
            MARSFirmSummary__c oldfirmSum=oldValues.get(firmsum.Id);
            for (String str : firmFields.keyset())
            {
                System.debug('Custom Field Name:'+str);
                if(str.contains('__c'))
                {
                    System.debug('Custom Field Value:'+String.valueOf(firmFields.get(str)).contains('marssfs'));
                    if(String.valueOf(firmFields.get(str)).contains('marssfs'))
                    {
                        System.debug('Comapre'+firmsum.get(str)+oldfirmSum.get(str));
                        if(firmsum.get(str) != oldfirmSum.get(str))
                        {
                            lstupdateAccounts.add(firmsum);
                            break;
                        }
                    }
                }
                else
                {
                    System.debug('\n Str: '+str);
                    System.debug('\n Str: '+firmsum.get(str));
                    System.debug('\n Str: '+oldfirmSum.get(str));
                    if(firmsum.get(str) != oldfirmSum.get(str) && str=='name')
                    {    
                            lstupdateAccounts.add(firmsum);
                            break;
                    }
                }
            } 
        }   
        if(!lstupdateAccounts.isEmpty())
        {
            List<Account> lstAccount=new List<Account>();
            for(MARSFirmSummary__c firm:lstupdateAccounts)
            {
                if(firm.MarsFirmId__c != 0)
                {
                    Account acc=new Account(Id= firm.SfdcFirmId__c);
                    //firm.MarsShortNm__c = firm.Name.length()>15?firm.Name.subString(0,15):firm.Name;
                    acc.MarsCrdId__c = firm.MarsCrdId__c;
                    acc.MarsFirmNm__c= firm.Name;
                    acc.MarsFirmComment__c=firm.MarsFirmComment__c;
                    acc.MarsShortNm__c=firm.MarsShortNm__c;
                    acc.MARSFirmStatCd__c=firm.MARSFirmStatCd__c;
                    acc.MarsOfficeStatCd__c = firm.MARSFirmStatCd__c;
                    acc.MarsFirmStatUpdDt__c=firm.MarsFirmStatUpdDt__c;
                    acc.MarsFirmType__c=firm.MarsFirmType__c;
                    acc.MarsGeoConc__c=firm.MarsGeoConc__c;
                    acc.MarsNsccFirmNbr__c=firm.MarsNsccFirmNbr__c;
                    acc.MarsNbrOfRegStates__c=firm.MarsNbrOfRegStates__c;
                    acc.MarsSalesGoalAmt__c=firm.MarsSalesGoalAmt__c;
                    acc.MarsSdrFlg__c=firm.MarsSdrFlg__c;
                    acc.MarsFirmWebsite__c=firm.MarsFirmWebsite__c;
                    acc.SfdcLastActionFrom__c = 'F';
                    acc.SfdcLastUpdateType__c = 'F';
                    lstAccount.add(acc);
                }
            }
            if(!lstAccount.isEmpty())
            {
                MarsUtility.BYPASS_VALIDATION =true;
                update lstAccount;
                MarsUtility.BYPASS_VALIDATION =false;
            }
        }
    }
}