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
private class TestMarsFirmController {

    @testSetup static void setupTestData()
    {
        Account firm=new Account();
        firm.Name='Firm Account';
        firm.MarsFirmNm__c='Firm Account';
        firm.MarsCrdId__c='ABCD';
        firm.Phone='9502505860';
        firm.MarsFirmStatCd__c='Active';
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
        
        /*MARSFirmSummary__c firmsummary =new MARSFirmSummary__c();
        firmsummary.Name='Test Office in TestFirm Controller';
        firmsummary.SfdcFirmId__c =firm.ID;
        firmsummary.MarsFirmType__c = firm.MarsFirmType__c;
        firmsummary.MarsCrdId__c='ABCD';
        firmsummary.MarsFirmStatCd__c=firm.MarsFirmStatCd__c;
        insert firmsummary;*/
        
    }

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        MarsCd__c mcd=new MarsCd__c();
        mcd.Name='Test Sasmple';
        mcd.MarsCdCd__c ='IS';
        mcd.MarsCdType__c ='FTY';
        mcd.MarsCdTypeCd__c  ='FTYIS';
        insert mcd;

        Account firm = [SELECT Id,Name,MarsFirmNm__c,MarsCrdId__c,Phone,MarsFirmStatCd__c,BillingStreet,BillingCity,BillingState,BillingStateCode,MarsFirmType__c,RecordTypeId,BillingCountry,BillingCountryCode,BillingPostalCode,SfdcLastUpdateType__c,SfdcLastActionFrom__c FROM Account WHERE Name = 'Firm Account' LIMIT 1];
        
        test.startTest();
        try
        {
            MARSFirmSummary__c firmsummary =new MARSFirmSummary__c();
            firmsummary.Name='Test Office in TestFirm Controller';
            firmsummary.SfdcFirmId__c =firm.ID;
            firmsummary.MarsFirmType__c = firm.MarsFirmType__c;
            insert firmsummary;
            
            firmsummary.MarsFirmType__c = 'CD';
            update firmsummary;
            
            delete firmsummary;
        
        }catch(Exception e){}
        
        Account office=new Account();
        office.Name='Test Office in TestFirm Controller';
        office.ParentId=firm.Id;
        office.MarsFirmNm__c='Test Firm In TestFirm Controller';
        office.Phone='9502505860';
        office.RecordTypeId=MarsUtility.AccountRecordType;
        office.BillingStreet='8014 Midlothian Tpke';
        office.BillingCity='Richmond';
        office.BillingStateCode='VA';
        office.BillingCountryCode='US';
        office.BillingPostalCode='90001';
        office.SfdcLastUpdateType__c = 'O';
        
        insert office;
        
        ApexPages.StandardController sc = new ApexPages.standardController(firm);
         
        MarsFirmController controller=new MarsFirmController(sc);

        Apexpages.currentPage().getParameters().put('searchtext', 'SFDC');
        
        Apexpages.currentPage().getParameters().put('Id', firm.Id);
        
        controller.accountID=firm.Id;
        controller.getfirmtypeValue();
        controller.getfirmstatusValue();
        controller.refresh();
        controller.getpageSubtitle();
        
        controller.firmOfficesRefreshList();
        
        Apexpages.currentPage().getParameters().put('owned', 'true');
        
        controller.searchvalue();
        //controller.officerecordsvalue=200;
        
        Apexpages.currentPage().getParameters().put('owned', 'false');
        
        controller.searchvalue();
        
        controller.getOfficeList();
        
        controller.getviews();
        controller.getsideviews();
        controller.getCurrentList();
        
        controller.newOffice();
        
        controller.sidebardropdown();
        //controller.processview();
        
        controller.selecteddropdown='C';
        controller.sidebardropdown();
        
        controller.selecteddropdown='V';
        controller.sidebardropdown();
        
        controller.selectedpicklistvalue='F';
        controller.refreshList();
        controller.getCurrentFirmList();
        
        controller.selectedpicklistvalue='A';
        //controller.processview();
        controller.refreshList();
        
        controller.selectedpicklistvalue='I';
        //controller.processview();
        controller.refreshList();
        
        controller.firmOffices();
        controller.relatedOfficeList();
        controller.relatedListOffice();
        
        controller.query='Search String';
        controller.runQuery();
        
        controller.query='';
        controller.runQuery();

        controller.newOfficeRelatedList();
        //
        
        Apexpages.currentPage().getParameters().put('alpha', 'A');
        
        controller.refreshList();
        
        Apexpages.currentPage().getParameters().put('alpha', 'Other');
        
        controller.refreshList();
        
        controller.First();
        controller.Last();
        controller.Previous();
        controller.Next();
        controller.getSortDirection();
        controller.viewSearchData();
        
        
        Apexpages.currentPage().getParameters().put('selectedpicklist', 'I');
        controller.ViewData();
        
        Apexpages.currentPage().getParameters().put('selectedpicklist', 'A');
        controller.ViewData();
        
        Apexpages.currentPage().getParameters().put('selectedpicklist', 'F');
        controller.ViewData();

        test.stopTest();
        
        String redirectPage=controller.redirect().getUrl();
        String newactionPage=controller.newaction().getUrl();
        String editfirmPage=controller.editfirm().getUrl();
        
        String namespaceval = '';
        Integer namespaceLength = 0;
         LIST<ApexClass> namespaceprefix=[SELECT NamespacePrefix FROM ApexClass WHERE Name = 'TestMarsFirmController'];
        
        //if(namespaceprefix.size()>0)
        if(!namespaceprefix.IsEmpty())
        {
            namespaceval = namespaceprefix[0].NamespacePrefix + '__';
            namespaceLength = namespaceval.length();
        } 
        
        System.debug('\n Name Space Value:'+namespaceval);
        
        ///apex/sfsmars__VF_FirmView?selectedpicklist=I&alphabet=
        System.assertEquals('/apex/'+namespaceval+'VF_FirmView?selectedpicklist=I', redirectPage);
        System.assertEquals('/apex/'+namespaceval+'VF_firmedit?retURL=%2Fapex%2FVF_FirmView', newactionPage );
        System.assertEquals('/apex/'+namespaceval+'VF_firmedit?id='+firm.id, editfirmPage);
        
        controller.accountID = null;
        firm.id=null;
        firm.MarsCrdId__c='ABCD';
        //controller.saveresult();
        
        firm.MarsOfficeStatUpdDt__c = Datetime.parse('10/14/2011 11:46 AM');
        //controller.saveresult(); 
    }
}