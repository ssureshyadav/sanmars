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
private class TestMarsFirmSumController {

    static testMethod void myUnitTest() {
        Account acc=[Select Id,MarsFirmType__c from Account Where Name = 'Firm Summary Record' limit 1];
        Account hOffice=new Account();
        hOffice.Name='Firm Summary Record';
        hOffice.MarsFirmNm__c='Test Firm In TestFirm Controller';
        hOffice.MarsCrdId__c='ABCDEF';
        hOffice.Phone='9502505860';
        hOffice.BillingStreet='8014 Midlothian Tpke';
        hOffice.BillingCity='Richmond';
        hOffice.BillingState='Virginia';
        hOffice.BillingStateCode='VA';
        hOffice.MarsFirmType__c ='BD';
        hOffice.RecordTypeId=MarsUtility.AccountRecordType;
        hOffice.BillingCountry='United States';
        hOffice.BillingCountryCode='US';
        hOffice.BillingPostalCode='90001';
        hOffice.SfdcLastUpdateType__c = 'F';
        hOffice.SfdcLastActionFrom__c='F';
        
        MARSFirmSummary__c firmsummary =new MARSFirmSummary__c();
        firmsummary.Name='Test Office in TestFirm Controller';
        //firmsummary.SfdcFirmId__c =acc.ID;
        firmsummary.MarsFirmType__c = acc.MarsFirmType__c;
        
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.standardController(firmsummary);
        MarsFirmSumController firmsum=new MarsFirmSumController(sc);
        firmsum.account =hOffice;
        
        firmsum.rectypefld= 'Id,Name,firmsumName';
        firmsum.calledonload();
        firmsum.saveresult();
        MarsUtility.BYPASS_ALL_TRIGGER=true;
        //delete firmsummary;
        
        MarsUtility.BYPASS_ALL_TRIGGER=false;
        
        Apexpages.currentPage().getParameters().put('Id', firmsummary.Id);
        firmsum.getfundsummaryinfo();
        firmsum.saveAndNew();
        Apexpages.currentPage().getParameters().put('retURL','/'+firmsummary.Id);
        firmsum.cancelAction();
        firmsum.getfirmtypeValue();
        List<selectOption> options=firmsum.marsFirmType;
        test.StopTest();
        
            MarsFirmSumController firmsumsave=new MarsFirmSumController(sc);
            MarsUtility.BYPASS_ALL_TRIGGER=true;
            firmsumsave.saveAndNew();
            MarsUtility.BYPASS_ALL_TRIGGER=false;
            firmsumsave.saveresult();
        
    }
     
    @testSetup
    static void allTheDataForThisTestClass() {
        Account firm=new Account();
        firm.Name='Firm Summary Record';
        firm.MarsFirmNm__c='Test Firm In TestFirm Controller';
        firm.MarsCrdId__c='ABCD';
        firm.Phone='9502505860';
        firm.BillingStreet='8014 Midlothian Tpke';
        firm.BillingCity='Richmond';
        firm.BillingState='Virginia';
        firm.BillingStateCode='VA';
        firm.MarsFirmType__c ='BD';
        firm.RecordTypeId=MarsUtility.AccountRecordType;
        firm.BillingCountry='United States';
        firm.BillingCountryCode='US';
        firm.BillingPostalCode='90001';
        firm.SfdcLastUpdateType__c = 'F';
        firm.SfdcLastActionFrom__c='F';
        
        MarsUtility.BYPASS_ALL_TRIGGER=true;
        insert firm;
        MarsUtility.BYPASS_ALL_TRIGGER=true;
        
        MarsCd__c mcd=new MarsCd__c();
        mcd.Name='Test Sasmple';
        mcd.MarsCdCd__c ='IS';
        mcd.MarsCdType__c ='FTY';
        mcd.MarsCdTypeCd__c  ='FTYIS';
        insert mcd;
    }
}