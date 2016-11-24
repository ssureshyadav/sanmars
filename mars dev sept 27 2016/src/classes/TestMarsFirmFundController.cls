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
private class TestMarsFirmFundController {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
         //Firm
        Integer accountCount=[Select count() from Account];
        System.debug('\n Account Count:'+accountCount);
        Account firm=new Account();
        firm.Name='Test Office in TestFirm Controller';
        firm.MarsFirmNm__c='Test Firm In TestFirm Controller';
        firm.MarsFirmId__c=123456;
        firm.RecordTypeId=MarsUtility.AccountRecordType;
        firm.Phone='9502505860';
        firm.BillingStreet='8014 Midlothian Tpke';
        firm.BillingCity='Richmond';
        firm.BillingState='Virginia';
        firm.BillingCountry='United States';
        firm.BillingPostalCode='90001';
        firm.SfdcLastUpdateType__c = 'F';
        firm.SfdcLastActionFrom__c ='F';
        

        MarsUtility.BYPASS_ALL_TRIGGER = true;
        insert firm;
        
        MARSFirmSummary__c firmsummary =new MARSFirmSummary__c();
        firmsummary.Name='Test Office in TestFirm Controller';
        firmsummary.SfdcFirmId__c =firm.ID;
        firmsummary.MarsFirmType__c = firm.MarsFirmType__c;
        insert firmsummary;
        
        Account office=new Account();
        office.Name='Branch Office';
        office.MarsFirmNm__c='Test Firm In TestFirm Controller';
        office.MarsFirmId__c=123456;
        office.MarsOfficeId__c=12344444;
        office.ParentId=firm.Id;
        office.RecordTypeId=MarsUtility.AccountRecordType;
        office.Phone='9502505860';
        office.BillingStreet='8014 Midlothian Tpke';
        office.BillingCity='Richmond';
        office.BillingState='Virginia';
        office.BillingCountry='United States';
        office.BillingPostalCode='90001';
        office.SfdcLastUpdateType__c = 'F';
        

         MarsUtility.BYPASS_ALL_TRIGGER = true;
        insert office;
        
        Contact rep=new Contact();
        rep.FirstName='Rep';
        rep.MarsRepId__c=123456789;
        rep.Phone='9502505860-1234';
        rep.AccountId=firm.Id;
        rep.RecordTypeId=MarsUtility.ContactRecordType;
        rep.Birthdate=Date.valueOf('1966-10-24');
        rep.LastName='In Test_MarsApexGateway Class';
        rep.MailingStreet='8014 Midlothian Tpke,8014 Midlothian Tpke';
        rep.MailingState='Virginia';
        rep.MailingCity='Richmond';
        rep.MailingCountry='United States';
        rep.MailingPostalCode='90001';
        rep.MarsFirmId__c=1222222;
        
        MarsUtility.BYPASS_ALL_TRIGGER = true;
        insert rep;
        
        List<MarsRepPeriodSummary__c> lstMarsRepPeriodSummary=new list<MarsRepPeriodSummary__c>();
        MarsRepPeriodSummary__c periodSummary=new MarsRepPeriodSummary__c();
        periodSummary.MarsFirmId__c=firm.MarsFirmId__c;
        periodSummary.MarsMtdPurch__c=123456;
        periodSummary.MarsYtdPurch__c=56897;
        periodSummary.MarsMtdRed__c=256235;
        periodSummary.MarsProdCd__c='PROD123';
        periodSummary.MarsProdTitle__c='Testing Product';
        periodSummary.SfdcRepId__c=rep.Id ;
        periodSummary.SfdcOfficeId__c=office.Id;
        periodSummary.SfdcFirmId__c=firm.Id;
        insert periodSummary;
        
        Product2 product=new Product2();
        product.MarsProdCd__c='PROD1234';
        product.Name='Product Title'; // mars product title 
        product.MarsFundFamilyDesc__c='Product test';
        product.MarsProdType__c='AB';
        product.ProductCode='PROD1234';
        insert product;
        
        /*MarsOfficeTerritory__c offTerr=new MarsOfficeTerritory__c();
        offTerr.MarsOfficeId__c=123;
        offTerr.MarsTerritory__c='A080';
        offTerr.Name='A04 ';
        insert offTerr;*/
        
        MarsTerritory__c terr=new MarsTerritory__c();
        terr.MarsTerrCd__c='A080';
        terr.MarsChannel__c='CHANNEL';
        terr.MarsWholesalerNm__c='Nick Niebeling';
        terr.MarsInternalNm__c='Nick Niebeling';
        terr.MarsManagerNm__c='Susan Smith';
        terr.MarsEffDt__c=Date.valueOf('2009-09-22');
        
        insert terr;
        
        MARSOffTerr__c oTerr=new MARSOffTerr__c();
        oTerr.SFDCAccountId__c = office.Id;
        oTerr.MARSOfficeId__c =12344444;
        oTerr.MARSOffTerrCd__c  ='A04 ';
        oTerr.SFDCTerrCd__c =terr.Id;
        oTerr.MARSTerrCd__c = 'A080';
        oTerr.MARSUpdDt__c = DateTime.now();
        insert oTerr;
        
        MARSRepTerr__c repTerr=new MARSRepTerr__c();
        repTerr.MarsRepId__c=rep.MarsRepId__c;
        repTerr.MARSTerrCd__c='A080';
        repTerr.Name='A04 ';
        repTerr.SFDCContactId__c=rep.Id;
        repTerr.MARSUpdDt__c = DateTime.now();
        repTerr.MARSRepTerrCd__c=repTerr.MarsRepId__c+repTerr.MARSTerrCd__c;
        insert repTerr;
        
        MarsCd__c mcd=new MarsCd__c();
        mcd.Name='Test';
        mcd.MarsCdCd__c ='IR';
        mcd.MarsCdType__c ='FTY';
        mcd.MarsCdTypeCd__c  ='FTYIR';
        insert mcd;
        
        
        //Test start from here
        Test.startTest();
        
        //Standard Controller
        //ApexPages.StandardController sc = new ApexPages.StandardController(firmsummary);
        system.currentPageReference().getParameters().put('Id',firmsummary.Id);
        MarsFirmFundSummaryController controller = new MarsFirmFundSummaryController();
        
        //ApexPages.StandardController scOffice = new ApexPages.StandardController(office);
        system.currentPageReference().getParameters().put('Id',office.Id);
        MarsOfficeFundSummaryController controller1=new MarsOfficeFundSummaryController();
       
        
        //ApexPages.StandardController scRep = new ApexPages.StandardController(rep);
        system.currentPageReference().getParameters().put('Id',rep.Id);
        MarsRepFundSummaryController controller2=new MarsRepFundSummaryController();

        
        ApexPages.StandardController scProduct = new ApexPages.StandardController(product);
        //system.currentPageReference().getParameters().put('Id',product.Id);
        MarsFundSummaryController controller3=new MarsFundSummaryController(scProduct );
        //Assert for results
        
        
        PageReference pOffice = Page.VF_MarsOfficeInfo;
        Test.setCurrentPageReference(pOffice);
        pOffice.getParameters().put('id', office.Id);
        MarsOfficeController oController = new MarsOfficeController();
        oController.getterritoryValue();
        oController.getfirmtypeValue();
        
        PageReference pRep = Page.VF_MarsRepInfo;
        Test.setCurrentPageReference(pRep);
        pRep.getParameters().put('id', rep.Id);
        MarsRepController rController = new MarsRepController();
        rController.getfirmtypeValue();
        rController.getreptypeValue();
        rController.getterritoryValue();
        rController.getmemberReps();
        //Test stop here
        
        PageReference pFirm = Page.VF_MarsFirmInfo;
        Test.setCurrentPageReference(pFirm);
        pFirm.getParameters().put('id', firmsummary.Id);
        MarsFirmInfoController fController = new MarsFirmInfoController();
        fController.getfirmtypeValue();
        fController.getterritoryValue();
        
        Test.stopTest(); 
    }
}