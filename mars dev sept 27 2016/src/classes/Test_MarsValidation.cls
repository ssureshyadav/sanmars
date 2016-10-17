@isTest
public Class Test_MarsValidation
{

    @testSetup static void FORData()
    {
        List<Account> lstAccount=new List<Account>();
        Id accRecTypeId =MarsUtility.AccountRecordType;
        for(Integer i=0;i<2;i++)
        {
            Account firm=new Account();
            firm.Name='Firm Controller'+i;
            //firm1.MarsFirmId__c=123455;
            firm.MarsCrdId__c ='TESTCLASS'+i;
            firm.MarsFirmType__c ='BD';
            firm.RecordTypeId=accRecTypeId;
            firm.Phone='95025058601234';
            firm.BillingStreet='8014 Midlo \n thian \n Tpke;8014 Midlothian \n Tpke;8014 \n Midlothian Tpke';
            firm.BillingCity='Richmond';
            firm.BillingState='Virginia';
            firm.BillingStateCode='VA';
            firm.BillingPostalCode='90001';
            firm.BillingCountry='United States';
            firm.BillingCountryCode='US';
            firm.SfdcLastUpdateType__c = 'F';
            firm.SfdcLastActionFrom__c= 'O';
            firm.MarsFirmTypeOverrideFlg__c= 'N';
            lstAccount.add(firm);
        }
        
        insert lstAccount;
        List<MARSFirmSummary__c> lstFirmSummary=new List<MARSFirmSummary__c>();
        for(Account fim:lstAccount)
        {
            MARSFirmSummary__c firmsummary =new MARSFirmSummary__c();
            firmsummary.Name='Test Office in TestFirm Controller';
            firmsummary.SfdcFirmId__c =fim.ID;
            firmsummary.MarsCrdId__c =fim.MarsCrdId__c;
            firmsummary.MarsFirmType__c = fim.MarsFirmType__c;
            lstFirmSummary.add(firmsummary);
        }
        insert lstFirmSummary;  
    }
    
    public static TestMethod void validateFirm()
    {
        List<MARSFirmSummary__c> lstFirmSummary =[Select Id,MarsCrdId__c,MarsShortNm__c,MarsFirmType__c,MarsFirmId__c from MARSFirmSummary__c]; 
        lstFirmSummary[0].MarsCrdId__c ='TESTCLASS1';
        try{
            update lstFirmSummary[0];
        }catch(Exception e){}
        
        try{
            lstFirmSummary[0].MarsCrdId__c ='TESTCLASS0';
            lstFirmSummary[0].MarsFirmType__c ='C';
            //lstFirmSummary[0].MarsFirmId__c=0;
            update lstFirmSummary[0];
        }catch(Exception e){}
        
        try{
            lstFirmSummary[0].MarsFirmType__c ='BD';
            lstFirmSummary[0].MarsShortNm__c='test';
            update lstFirmSummary[0];
        }catch(Exception e){}
        
        try{
            lstFirmSummary[0].MarsShortNm__c='';
            lstFirmSummary[0].MarsFirmId__c =0;
            update lstFirmSummary[0];
        }catch(Exception e){}
        
        try{
            delete lstFirmSummary[0];
        }catch(Exception e){}
    }
    
    public static TestMethod void validateOffice()
    {

        List<Account> lstAccount=[Select Id,SfdcLastActionFrom__c,RecordTypeId,MarsSummaryUpdateTime__c,MarsFirmType__c,
                                    MarsOffFirmType__c,MarsShortNm__c,ParentId,MarsOfficeId__c,MarsOfficeStatCd__c,MarsCrdId__c,
                                    BillingStreet,BillingCity,BillingCountryCode,BillingStateCode,BillingPostalCode,SFDCFirmSumId__c from Account];
                                    
        lstAccount[0].MarsCrdId__c ='TESTCLASS1';
        try{
            update lstAccount[0];
        }catch(Exception e){}
        
        try{
            lstAccount[0].MarsCrdId__c ='TESTCLASS0';
            lstAccount[0].MarsFirmType__c ='C';
            //lstFirmSummary[0].MarsFirmId__c=0;
            update lstAccount[0];
        }catch(Exception e){}
        
        try{
            lstAccount[0].MarsFirmType__c ='BD';
            lstAccount[0].MarsShortNm__c='test';
            update lstAccount[0];
        }catch(Exception e){}
        
        try{
            lstAccount[0].MarsShortNm__c='';
            lstAccount[0].MarsFirmId__c =0;
            update lstAccount[0];
        }catch(Exception e){}
        
        try{
            delete lstAccount[0];
        }catch(Exception e){}
    }
}