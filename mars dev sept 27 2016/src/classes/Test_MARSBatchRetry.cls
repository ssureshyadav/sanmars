/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_MARSBatchRetry {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        MarsTerritory__c territory=new MarsTerritory__c();
        territory.MarsChannel__c='Broker-Dealer';   
        territory.MarsInternalNm__c='Ken King';     
        territory.MarsManagerNm__c='Brian Jackson';
        territory.MarsTerrCd__c='A012';
        territory.MarsWholesalerNm__c='Brian Jackson';
        territory.Name='Central';
        
        Account firm=new Account();
        firm.Name='Test Office in TestFirm Controller';
        firm.MarsFirmId__c=1111111;
        firm.BillingStreet='8014 Midlothian Tpke';
        firm.BillingCity='Richmond';
        firm.BillingState='Virginia';
        firm.BillingStateCode='VA';
        firm.BillingCountry='United States';
        firm.BillingCountryCode='US';
        firm.BillingPostalCode='90001';
        firm.MarsFirmType__c ='BD';
        firm.RecordTypeId=MarsUtility.AccountRecordType;
        firm.SfdcLastUpdateType__c = 'F';
        firm.MarsFirmStatUpdDt__c=Datetime.now();
        firm.MarsCrdId__c='A01';
        firm.SfdcLastActionFrom__c='F';
        
        MarsUtility.BYPASS_ALL_TRIGGER=true;
        insert firm;
        
        try{
            Account firm2=new Account();
            firm2.BillingStreet='8014 Midlothian Tpke';
           /* firm2.BillingCity='Richmond';
            firm2.BillingState='Virginia';
            firm2.BillingStateCode='VA';
            firm2.BillingCountry='United States';
            firm2.BillingCountryCode='US';
            firm2.BillingPostalCode='90001';*/
            firm2.MarsFirmType__c ='BD';
            firm2.RecordTypeId=MarsUtility.AccountRecordType;
            firm2.SfdcLastUpdateType__c = 'F';
            firm2.MarsFirmStatUpdDt__c=Datetime.now();
            firm2.MarsCrdId__c='A01';
            firm2.SfdcLastActionFrom__c='F';
        
            insert firm2;
            }catch(Exception e){}
            
        try{
            Account firm3=new Account();
            firm3.BillingStreet='8014 Midlothian Tpke';
            firm3.BillingCity='Richmond';
           /* firm2.BillingState='Virginia';
            firm2.BillingStateCode='VA';
            firm2.BillingCountry='United States';
            firm2.BillingCountryCode='US';
            firm2.BillingPostalCode='90001';*/
        
            insert firm3;
            }catch(Exception e){}
        
        try{
            Account firm1=new Account();
            firm1.Name='Test Office in TestFirm Controller';
            firm1.SfdcLastActionFrom__c='F';
            
            //MarsUtility.BYPASS_ALL_TRIGGER=true;
            insert firm;
        }catch(Exception e){}
        
        
        //validating the validation class 
        try{
            MarsUtility.BYPASS_ALL_TRIGGER=false;
            firm.ParentId=firm.Id;
            update firm;
        }
        catch(Exception e){
            //System.debug(e.getMEssage()); 
        }
        
        try{
            MarsUtility.BYPASS_ALL_TRIGGER=false;
            firm.MarsCrdId__c='ABCDEF';
            update firm;
        }
        catch(Exception e){}
        
        
        try{
            MarsUtility.BYPASS_ALL_TRIGGER=false;
            firm.MarsOfficeId__c=1234;
            update firm;
        }
        catch(Exception e){}
        
        
        try{
            MarsUtility.BYPASS_ALL_TRIGGER=false;
            firm.MarsOfficeStatCd__c='A';
            update firm;
        }catch(Exception e){
            //System.debug(e.getMEssage());   
        }
        
        
        MARSFirmSummary__c firmSummary=new MARSFirmSummary__c();
        firmSummary.MarsCAssets__c=9.4136412;
        firmSummary.MarsCavgAssets__c=1.131760993;
        //firmSummary.MarsFirmId__c=1.0;
        firmSummary.MarsMtdPurch__c=1.8605377;
        firmSummary.MarsMtdRed__c=-1.4930132;
        firmSummary.MarsPdayPurch__c=1.5619329;
        firmSummary.MarsPdayRed__c=-1.4930132;
        firmSummary.MarsPmonthAssets__c=9.4136412;
        firmSummary.MarsPmonthavgAssets__c=0.0;
        firmSummary.MarsPmonthPurch__c=1.7257519;
        firmSummary.MarsPmonthRed__c=-1.642315;
        firmSummary.MarsPweekAssets__c=0.0;
        firmSummary.MarsPweekPurch__c=0.0;
        firmSummary.MarsPweekRed__c=0.0;
        firmSummary.MarsPyearAssets__c=0.0;
        firmSummary.MarsPyearavgAssets__c=0.0;
        firmSummary.MarsPyearPurch__c=3619600;
        firmSummary.MarsPyearRed__c=-665503;
        firmSummary.MarsR12MtdPurch__c=1.32094524;
        firmSummary.MarsR12MtdRed__c=-6.5627445;
        //firmSummary.MarsUpdDt__c=2014-09-29T22:07:50.000Z
        firmSummary.MarsWtdPurch__c=1.5619329;
        firmSummary.MarsWtdRed__c=-1.4930132;
        //firmSummary.MarsYtdNet__c=6.6467079;
        firmSummary.MarsYtdPurch__c=1.32094524;
        firmSummary.MarsYtdRed__c=-6.5627445;
        firmSummary.SfdcFirmId__c=firm.Id;
        
        Contact rep=new Contact();
        rep.FirstName='Rep';
        rep.MarsRepId__c=15645555;
        rep.Phone='9502505860-1234';
        rep.AccountId=firm.Id;
        rep.RecordTypeId=MarsUtility.ContactRecordType;
        rep.Birthdate=Date.valueOf('1966-10-24');
        rep.LastName='In Test_MarsApexGateway Class';
        rep.MailingStreet='8014 Midlothian Tpke';
        rep.MailingState='Virginia';
        rep.MailingStateCode='VA';
        rep.MailingCity='Richmond';
        rep.MailingPostalCode='90001';
        rep.MailingCountry='United States';
        rep.MailingCountryCode='US';
        
        MarsUtility.BYPASS_ALL_TRIGGER=true;
        insert rep;
        
        try{
        MarsUtility.BYPASS_ALL_TRIGGER=false;
        delete rep;
        }catch(Exception e){}
         
        
        MarsRepPeriodSummary__c periodSummary=new MarsRepPeriodSummary__c();
        periodSummary.Name='Money Market I';    
        periodSummary.MarsCAssets__c=0;   
        periodSummary.MarsProdCd__c='PR008'; 
        periodSummary.MarsProdTitle__c='Product Mutual Fund';
        periodSummary.MarsCavgAssets__c=0;   
        periodSummary.MarsFirmId__c=0;    
        periodSummary.MarsMtdPurch__c=0;  
        periodSummary.MarsMtdRed__c=0;    
        periodSummary.MarsOfficeId__c=0;  
        periodSummary.MarsPdayPurch__c=0; 
        periodSummary.MarsPdayRed__c=0;   
        periodSummary.MarsPmonthAssets__c=0;  
        periodSummary.MarsPmonthavgAssets__c=0;   
        periodSummary.MARSUpdDt__c  =DateTime.now()-1;
        //periodSummary.SfdcFirmId__c='0019000000nRm4wAAC';   
        periodSummary.SfdcOfficeId__c=firm.Id; 
        periodSummary.SfdcRepId__c=rep.Id;
        MarsOfficeTerritory__c officeTerr=new MarsOfficeTerritory__c();
        officeTerr.MarsOfficeId__c=578798.0;    
        officeTerr.MarsTerritory__c='A059';
        
        MARSRepPeriodTerritorySummary__c pterrSummary=new MARSRepPeriodTerritorySummary__c();
        pterrSummary.Name='Money Market I';    
        pterrSummary.MarsCAssets__c=0;   
        pterrSummary.MarsProdCd__c='PR008'; 
        //pterrSummary.MarsProdTitle__c='Product Mutual Fund';
        pterrSummary.MarsCavgAssets__c=0;   
        pterrSummary.MarsFirmId__c=0;    
        pterrSummary.MarsMtdPurch__c=0;  
        pterrSummary.MarsMtdRed__c=0;    
        pterrSummary.MarsOfficeId__c=0;  
        pterrSummary.MarsPdayPurch__c=0; 
        pterrSummary.MarsPdayRed__c=0;   
        pterrSummary.MarsPmonthAssets__c=0;  
        pterrSummary.MarsPmonthavgAssets__c=0;   
        pterrSummary.SfdcOfficeId__c=firm.Id; 
        pterrSummary.SfdcRepId__c=rep.Id;
        pterrSummary.MARSTerrCd__c='A012';
        pterrSummary.MARSUpdDt__c  =DateTime.now()-1;
        
        MarsRepTerritory__c repTerr=new MarsRepTerritory__c();
        repTerr.MarsRepId__c=4555777.0; 
        repTerr.MarsTerritory__c='A059'; 
        
        MARSBatchDataStore__c batchRetry=new MARSBatchDataStore__c();
        batchRetry.ApexComponentName__c='MarsBatchRetryBulkData'; 
        batchRetry.ApexComponentType__c='Apex Class';
        batchRetry.OperationType__c = 'FIRM_INSERT';
        batchRetry.ErrorMessage__c='Class.MarsBatchRetryBulkData.execute: line 47, column 1--null--Attempt to de-reference a null object';    
        batchRetry.FailureSystemType__c='MarsBatchRetryBulkData';
        //batchRetry.MarsOfficeId__c=firm.MarsOfficeId__c;    
        //batchRetry.MarsRepId__c='10.0';
        batchRetry.SfdcAccountId__c = firm.Id;
        
        MARSBatchDataStore__c batchRetry2=new MARSBatchDataStore__c();
        batchRetry2.ApexComponentName__c='MarsBatchRetryBulkData'; 
        batchRetry2.ApexComponentType__c='Apex Class';
        batchRetry2.OperationType__c = 'OFFICE_INSERT';
        batchRetry2.ErrorMessage__c='Class.MarsBatchRetryBulkData.execute: line 47, column 1--null--Attempt to de-reference a null object';    
        batchRetry2.FailureSystemType__c='MarsBatchRetryBulkData';
        //batchRetry.MarsOfficeId__c=firm.MarsOfficeId__c;    
        //batchRetry.MarsRepId__c='10.0';
        batchRetry2.SfdcAccountId__c = firm.Id;
        
        MARSBatchDataStore__c batchRetry1=new MARSBatchDataStore__c();
        batchRetry1.ApexComponentName__c='MarsBatchRetryBulkData'; 
        batchRetry1.ApexComponentType__c='Apex Class'; 
        batchRetry1.OperationType__c = 'REP_MOVE';
        batchRetry1.ErrorMessage__c='Class.MarsBatchRetryBulkData.execute: line 47, column 1--null--Attempt to de-reference a null object';    
        batchRetry1.FailureSystemType__c='MarsBatchRetryBulkData';
        //batchRetry1.MarsOfficeId__c='3840.0';    
        //batchRetry1.MarsRepId__c=rep.;
        batchRetry1.SfdcContactId__c = rep.Id;
        
        Test.StartTest();
        
        insert territory;
        insert officeTerr;
        insert repTerr;
        insert batchRetry;
        insert batchRetry1;
        insert batchRetry2;
        insert firmSummary;
        insert periodSummary;
        insert pterrSummary;
        
        firmSummary.Name ='Sampel Firm Test';
        update firmSummary;
        
        
        MARSOffTerr__c oTerr=new MARSOffTerr__c();
        oTerr.SFDCAccountId__c = firm.Id;
        oTerr.MARSOfficeId__c =12344444;
        oTerr.MARSOffTerrCd__c  ='A04 ';
        //oTerr.SFDCTerrCd__c = territory.Id;
        oTerr.MARSTerrCd__c = 'A012';
        oTerr.MARSUpdDt__c = DateTime.now();
        insert oTerr;
        
        MarsRepTerr__c rTerr=new MarsRepTerr__c();
        rTerr.SFDCContactId__c = rep.Id;
        rTerr.MARSRepId__c = 15645555;
        rTerr.MARSRepTerrCd__c= 'A059';
        rTerr.MARSTerrCd__c = 'A012';
        rTerr.MARSUpdDt__c  =DateTime.now();
        insert rTerr;
        
        MARSTerritorySyncDelete__c terrsync=new MARSTerritorySyncDelete__c(Name ='Test');
        insert terrsync;
        
        MarsBatchDelete process = new MarsBatchDelete();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Delete Summary Test', sch, process); 
        
        MARSDefaults__c marsDefaults = new MARSDefaults__c(MARSPassword__c = 'mars', MARSUser__c = 'KMILLER',IntegrationType__c=1,bulkLoadEnabled__c = true, DeleteMARSBatchDataPeriod__c=30, RetryDuration__c=15, MARSEndpointUrl__c='https:\\salesforce.com',EmailErrors__c=true,Email__c='test@test.com');
        insert marsDefaults;
        
        Database.executeBatch(new MarsBatchRetryBulkData());
    
        MarsBatchEmailErrors errors=new MarsBatchEmailErrors();
        system.schedule('Email Errors', sch, errors); 
        
        Test.stopTest(); 
        
        
        
    }
}