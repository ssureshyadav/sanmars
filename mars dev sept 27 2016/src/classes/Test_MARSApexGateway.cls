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
private class Test_MARSApexGateway {

    @testSetup static void setupTestData()
    {
        Account firm=new Account();
        firm.Name='Firm Account';
        firm.MarsFirmNm__c='Firm Account';
        firm.MarsCrdId__c='ABCD';
        firm.MarsFirmId__c=123455;
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
        MarsUtility.BYPASS_ALL_TRIGGER=false;
    }
   
    static testMethod void myUnitTest() {
        
        //Target Firm
        Account firm = [SELECT Id,MarsFirmId__c,Name,MarsFirmNm__c,MarsCrdId__c,Phone,MarsFirmStatCd__c,BillingStreet,BillingCity,BillingState,BillingStateCode,MarsFirmType__c,RecordTypeId,BillingCountry,BillingCountryCode,BillingPostalCode,SfdcLastUpdateType__c,SfdcLastActionFrom__c FROM Account WHERE Name = 'Firm Account' LIMIT 1];
        
        MARSFirmSummary__c firmsummary =new MARSFirmSummary__c();
        firmsummary.Name='Test Office in TestFirm Controller';
        firmsummary.SfdcFirmId__c =firm.ID;
        firmsummary.MarsFirmType__c = firm.MarsFirmType__c;
        insert firmsummary;
        
        
        MARSDefaults__c defaults=new MARSDefaults__c();
        defaults.MARSUser__c='ABCD';
        defaults.RetryDuration__c=15;
        defaults.MARSPassword__c='****';
        defaults.MARSEndpointUrl__c='http://test.com/';
        defaults.IntegrationType__c=1;
        defaults.EmailErrors__c=true;
        defaults.Email__c='test@test.com';
        defaults.DeleteMARSBatchDataPeriod__c=30;
        defaults.BulkLoadEnabled__c=true;
        defaults.AllowRepMove__c=true;
        defaults.CustomContactAddress__c=true;
        //defaults.MarsMaxRecordsMoveMerge__c =2000;
        insert defaults;
        
        System.debug('\n Firm Response: '+firm);
        
        Account firm1=new Account();
        firm1.Name='Test Office in TestFirm Controller';
        //firm1.MarsFirmId__c=123455;
        firm1.MarsFirmType__c ='BD';
        firm1.RecordTypeId=MarsUtility.AccountRecordType;
        firm1.Phone='95025058601234';
        firm1.BillingStreet='8014 Midlo \n thian \n Tpke;8014 Midlothian \n Tpke;8014 \n Midlothian Tpke';
        firm1.BillingCity='Richmond';
        firm1.BillingState='Virginia';
        firm1.BillingStateCode='VA';
        firm1.BillingPostalCode='90001';
        firm1.BillingCountry='United States';
        firm1.BillingCountryCode='US';
        firm1.SfdcLastUpdateType__c = 'F';
        firm1.SfdcLastActionFrom__c= 'F';
        firm1.MarsFirmTypeOverrideFlg__c= 'N';
        
        //MarsUtility.BYPASS_ALL_TRIGGER=true;
        MarsUtility.BYPASS_VALIDATION=true;
        insert firm1;
        MarsUtility.BYPASS_VALIDATION=false;
        
       
        Account office=new Account();
        office.Name='Test Office';
        //office.MarsOfficeId__c=123456;
        office.ParentId=firm.Id;
        office.RecordTypeId=MarsUtility.AccountRecordType;
        office.MarsFirmId__c=firm.MarsFirmId__c;
        office.Phone='9502505860-1234';
        office.BillingStreet='8014 \n Mid \n lothi \n an Tpke';
        office.BillingCity='Richmond';
        office.BillingState='Virginia';
        office.BillingStateCode='VA';
        office.BillingPostalCode='90001';
        office.BillingCountry='United States';
        office.BillingCountryCode='US';
        office.SfdcLastUpdateType__c = 'O';
        
        //MarsUtility.BYPASS_ALL_TRIGGER=true;
        insert office;

        
        Account office1=new Account();
        office1.Name='Test Office';
        office1.MarsOfficeId__c=123455;
        office1.ParentId=firm1.Id;
        office1.RecordTypeId=MarsUtility.AccountRecordType;
        office1.MarsFirmId__c=firm1.MarsFirmId__c;
        office1.Phone='9502505860X1234545';
        office1.BillingStreet='Billing Address8014 \n Midlothian Tpke,1 \n Tower Bridge 100 Front St,1894 \n N Cleveland Massillon Rd,256 W Durham Plaza,\n Billing Address8014 Midlothian Tpke';
        office1.BillingCity='Richmond';
        office1.BillingState='Virginia';
        office1.BillingStateCode='VA';
        office1.BillingPostalCode='90001';
        office1.BillingCountry='United States';
        office1.BillingCountryCode='US';
        office1.SfdcLastUpdateType__c = 'O';
        
        MarsUtility.BYPASS_ALL_TRIGGER=true;
        insert office1;
        MarsUtility.BYPASS_ALL_TRIGGER=false;
        
        Account office2=new Account();
        office2.Name='Test Office';
        office2.MarsOfficeId__c=123485;
        office2.ParentId=firm1.Id;
        office2.RecordTypeId=MarsUtility.AccountRecordType;
        office2.MarsFirmId__c=firm1.MarsFirmId__c;
        office2.Phone='9502505860X1234545';
        office2.BillingStreet='Billing Address8014 \n Midlothian Tpke,1 \n Tower Bridge 100 Front St,1894 \n N Cleveland Massillon Rd,256 W Durham Plaza,\n Billing Address8014 Midlothian Tpke';
        office2.BillingCity='Richmond';
        office2.BillingState='Virginia';
        office2.BillingStateCode='VA';
        office2.BillingPostalCode='90001';
        office2.BillingCountry='United States';
        office2.BillingCountryCode='US';
        office2.SfdcLastUpdateType__c = 'O';
        office2.SFDCFirmSumId__c=firmsummary.Id;
        
        MarsUtility.BYPASS_ALL_TRIGGER=true;
        insert office2;
        MarsUtility.BYPASS_ALL_TRIGGER=false;
        
        Contact cont=new Contact();
        cont.FirstName='Rep';
        //rep.MarsRepId__c=155555;
        cont.Phone='9502505860X1234567';
        cont.AccountId=office.Id;
        cont.RecordTypeId=MarsUtility.ContactRecordType;
        cont.Birthdate=Date.valueOf('1966-10-24');
        cont.LastName='In Test_MarsApexGateway Class';
        cont.MailingStreet='8014 Midlothian Tpke';
        cont.MailingState='California';
        cont.MailingStateCode='CA';
        cont.MailingCity='Richmond';
        cont.MarsAddrLock__c = 'N';
        cont.MailingPostalCode='90001';
        cont.MailingCountry='United States';
        cont.MailingCountryCode='US';
        cont.MarsOfficeId__c=office2.MarsOfficeId__c;
        cont.MarsFirmId__c=office.MarsFirmId__c;
        
        //MarsUtility.BYPASS_ALL_TRIGGER=true;
        insert cont;
        
        
        Contact rep=new Contact();
        rep.FirstName='Rep';
        rep.MarsRepId__c=155555;
        rep.Phone='9502505860-1234';
        rep.AccountId=office.Id;
        rep.RecordTypeId=MarsUtility.ContactRecordType;
        rep.Birthdate=Date.valueOf('1966-10-24');
        rep.LastName='In Test_MarsApexGateway Class';
        rep.MailingStreet='8014 Midlothian Tpke';
        rep.MailingState='Virginia';
        rep.MailingCity='Richmond';
        rep.MarsAddrLock__c = 'N';
        rep.MailingPostalCode='90001';
        rep.MailingCountry='United States';
        rep.MarsOfficeId__c=office1.MarsOfficeId__c;
        rep.MarsFirmId__c=office.MarsFirmId__c;
        
        MarsUtility.BYPASS_ALL_TRIGGER=true;
        insert rep;
        MarsUtility.BYPASS_ALL_TRIGGER=false;

        System.debug('Rep Response:'+rep);
        
        Account updfirm=new Account(Id=firm.Id);
        updfirm.MarsFirmNm__c='Test Firm';
        updfirm.SfdcLastActionFrom__c='O';
        update updfirm; 
        
        System.debug('Update Office Address');
        Account updateOffice=new Account(id=office.Id);
        updateOffice.BillingStreet='Billing Address8014 hian Tpke \n Midlot,1 Tower Bridge 100';
        updateOffice.BillingCity='Richmon';
        updateOffice.MarsOfficeStatCd__c='InActive';
        update updateOffice;

        update rep;
        
        
        Contact rep1=new Contact();
        rep1.FirstName='Rep';
        rep1.marsrepId__c=166666;
        rep1.MarsCrdId__c='ABC123';
        rep1.AccountId=office1.Id;
        rep1.RecordTypeId=MarsUtility.ContactRecordType;
        rep1.LastName='In Test_MarsApexGateway ';
        rep1.MailingStreet=office1.BillingStreet;
        rep1.MailingState=office1.BillingState;
        rep1.MailingCity=office1.BillingCity;
        rep1.MailingPostalCode=office1.BillingPostalCode;
        rep1.MailingCountry=office1.BillingCountry;
        rep1.MarsOfficeId__c=office1.MarsOfficeId__c;
        rep1.MarsFirmId__c=office1.MarsFirmId__c;
        
        MarsUtility.BYPASS_ALL_TRIGGER=true;
        insert rep1; 
        
       MarsTerritory__c terr=new MarsTerritory__c();
       terr.MarsTerrCd__c ='ABC';
       insert terr;
        
        
        MARSRepTerr__c repTerr=new MARSRepTerr__c();
        repTerr.MARSTerrCd__c='ABC';
        repTerr.SFDCContactId__c=rep1.Id;
        repTerr.MARSRepId__c=166666;
        repTerr.MARSUpdDt__c=System.now();
        repTerr.MARSRepTerrCd__c='ABC';
        insert repTerr;
        
        MARSOffTerr__c offterr=new MARSOffTerr__c();
        offterr.SFDCAccountId__c = office.Id;
        offterr.MARSOfficeId__c =123456789;
        offterr.MARSOffTerrCd__c='ABC';
        offterr.MARSTerrCd__c='ABC';
        offterr.MARSUpdDt__c=System.now();
        insert offterr;
        
        
        try{
            MarsUtility.BYPASS_ALL_TRIGGER=false;
            delete rep;
        }
        catch(Exception e){
            
        }
        try{
            delete firm;
        }catch(Exception e){
            
        }
        
        MarsRepTeam__c teamRep=new MarsRepTeam__c();
        teamRep.MarsRepId__c =155555;
        teamRep.MarsSplitPercent__c = 33;
        teamRep.MarsTeamRepId__c = 166666;
        teamRep.SfdcRepId__c =rep.Id;
        teamRep.SfdcTeamRepId__c = rep1.Id;
        teamRep.RecordTypeId= MarsUtility.RepTeamRecordType;
        
        try{
            MarsUtility.BYPASS_ALL_TRIGGER=false;
            insert teamRep;
        }catch(Exception e){
            System.debug('Exception in Updating'+e.getMessage());
        }
        
        MarsUtility.BYPASS_ALL_TRIGGER=true;
        insert teamRep;
        
        try{
            MarsUtility.BYPASS_ALL_TRIGGER=false;
            update teamRep;
        }catch(Exception e){
            System.debug('Exception in Updating'+e.getMessage());
        }
        
        try{
            MarsUtility.BYPASS_ALL_TRIGGER=false;
            delete teamRep;
        }catch(Exception e){
            System.debug('Exception in Updating'+e.getMessage());
        }
        
        Product2 product=new Product2();
        product.RecordTypeId=MarsUtility.ProductRecordType;           
        product.ProductCode='PROD004';
        product.Name ='Release 1';                    
        product.MarsShareClass__c='A  ';
        product.MarsShareClassDesc__c='A Class';
        product.MarsProdType__c='AN';
        product.MarsProdTypeDesc__c='Annuity';
        product.MarsProdGrp__c='B   ';
        product.MarsProdGrpDesc__c='Balanced';
        product.MarsFundFamily__c='MAR';
        product.MarsFundFamilyDesc__c='MARS Funds';
        product.MarsFundComp__c='COM';
        product.MarsFundCompDesc__c='Competitor Funds';
        product.RecordTypeId=MarsUtility.ProductRecordType;
        
        MarsUtility.BYPASS_ALL_TRIGGER=true;
        insert product;
        
        try{
            MarsUtility.BYPASS_ALL_TRIGGER=false;
            update product;
        }catch(Exception e){
            System.debug('Exception in Updating'+e.getMessage());
        }
        
        try{
            MarsUtility.BYPASS_ALL_TRIGGER=false;
            delete product;
        }catch(Exception e){
            System.debug('Exception in Updating'+e.getMessage());
        }
        
        
        Test.startTest();
        //Batch Initializing
        
        List<MARSApexGateway.ACK> upsertFirmResult=new List<MARSApexGateway.ACK>(); 
        
        //upsertFirmResult=MARSApexGateway.SyncFirms('<MarsFirmDataSet xmlns=\"http://tempuri.org/MarsFirm.xsd\">  <FIRM>     <FIRM_ID>1496</FIRM_ID>     <EXTERNAL_FIRM_ID />    <SHORT_NM></SHORT_NM> <FIRM_COMMENT />     <FIRM_NAME>CRI Securities LLC</FIRM_NAME>     <FIRM_NAME_CAPS>CRI SECURITIES LLC</FIRM_NAME_CAPS>     <SHORT_NAME>CRI Securities</SHORT_NAME>     <SHORT_NAME_CAPS>CRI SECURITIES</SHORT_NAME_CAPS>     <HOME_OFFICE_ID>2563</HOME_OFFICE_ID>     <NUMBER_OF_REG_STATES />     <GEO_CONC />     <LAST_FIRM_NOTE_DATE />     <ADDRESS_ID>2523</ADDRESS_ID>     <FIRM_TYPE>IN</FIRM_TYPE>     <WEB_SITE />     <STATUS_CD>CONFIRMED</STATUS_CD>     <PARENT_FIRM_ID>xx</PARENT_FIRM_ID>     <STATUS_UPDATE_DATE>1/19/2011 3:18:17 PM</STATUS_UPDATE_DATE>     <NEW_FIRM_TYPE />     <SALES_GOAL_AMOUNT />     <ENTRY_DATE>1/19/2011 3:18:17 PM</ENTRY_DATE>     <ENTRY_USER>KMILLER </ENTRY_USER>     <UPDATE_DATE>1/19/2011 3:18:17 PM</UPDATE_DATE>     <UPDATE_USER>KMILLER </UPDATE_USER>     <KEY_ACCT_TERR />     <NSCC_FIRM_NBR />     <SDR_FLG />     <CALL_CD>1</CALL_CD>     <MAIL_CD>1</MAIL_CD>     <EMAIL_CD>1</EMAIL_CD>     <CRD_ID />     <PRIM_PHONE>6516653907</PRIM_PHONE>     <PRIM_PHONE_EXT />     <PRIM_FAX />     <EXTERNAL_ID />     <CONFIRM_YN>Y</CONFIRM_YN>     <REP_TERR_BASED_ON>R</REP_TERR_BASED_ON>  </FIRM>  <FIRM>     <FIRM_ID>2016</FIRM_ID>     <EXTERNAL_FIRM_ID />    <SHORT_NM></SHORT_NM> <FIRM_COMMENT />     <FIRM_NAME>CRI Securities LLC</FIRM_NAME>     <FIRM_NAME_CAPS>CRI SECURITIES LLC</FIRM_NAME_CAPS>     <SHORT_NAME>CRI Securities</SHORT_NAME>     <SHORT_NAME_CAPS>CRI SECURITIES</SHORT_NAME_CAPS>     <HOME_OFFICE_ID>2564</HOME_OFFICE_ID>     <NUMBER_OF_REG_STATES />     <GEO_CONC />     <LAST_FIRM_NOTE_DATE />     <ADDRESS_ID>2523</ADDRESS_ID>     <FIRM_TYPE>IN</FIRM_TYPE>     <WEB_SITE />     <STATUS_CD>CONFIRMED</STATUS_CD>     <PARENT_FIRM_ID>xx</PARENT_FIRM_ID>     <STATUS_UPDATE_DATE>1/19/2011 3:18:17 PM</STATUS_UPDATE_DATE>     <NEW_FIRM_TYPE />     <SALES_GOAL_AMOUNT />     <ENTRY_DATE>1/19/2011 3:18:17 PM</ENTRY_DATE>     <ENTRY_USER>KMILLER </ENTRY_USER>     <UPDATE_DATE>1/19/2011 3:18:17 PM</UPDATE_DATE>     <UPDATE_USER>KMILLER </UPDATE_USER>     <KEY_ACCT_TERR />     <NSCC_FIRM_NBR />     <SDR_FLG />     <CALL_CD>1</CALL_CD>     <MAIL_CD>1</MAIL_CD>     <EMAIL_CD>1</EMAIL_CD>     <CRD_ID />     <PRIM_PHONE>6516653907</PRIM_PHONE>     <PRIM_PHONE_EXT />     <PRIM_FAX />     <EXTERNAL_ID />     <CONFIRM_YN>Y</CONFIRM_YN>     <REP_TERR_BASED_ON>R</REP_TERR_BASED_ON>   </FIRM><FIRM>     <FIRM_ID>2016</FIRM_ID>     <EXTERNAL_FIRM_ID />    <SHORT_NM></SHORT_NM> <FIRM_COMMENT />     <FIRM_NAME>CRI Securities LLC</FIRM_NAME>     <FIRM_NAME_CAPS>CRI SECURITIES LLC</FIRM_NAME_CAPS>     <SHORT_NAME>CRI Securities</SHORT_NAME>     <SHORT_NAME_CAPS>CRI SECURITIES</SHORT_NAME_CAPS>     <HOME_OFFICE_ID>2564</HOME_OFFICE_ID>     <NUMBER_OF_REG_STATES />     <GEO_CONC />     <LAST_FIRM_NOTE_DATE />     <ADDRESS_ID>2523</ADDRESS_ID>     <FIRM_TYPE>IN</FIRM_TYPE>     <WEB_SITE />     <STATUS_CD>CONFIRMED</STATUS_CD>     <PARENT_FIRM_ID>xx</PARENT_FIRM_ID>     <STATUS_UPDATE_DATE>1/19/2011 3:18:17 PM</STATUS_UPDATE_DATE>     <NEW_FIRM_TYPE />     <SALES_GOAL_AMOUNT />     <ENTRY_DATE>1/19/2011 3:18:17 PM</ENTRY_DATE>     <ENTRY_USER>KMILLER </ENTRY_USER>     <UPDATE_DATE>1/19/2011 3:18:17 PM</UPDATE_DATE>     <UPDATE_USER>KMILLER </UPDATE_USER>     <KEY_ACCT_TERR />     <NSCC_FIRM_NBR />     <SDR_FLG />     <CALL_CD>1</CALL_CD>     <MAIL_CD>1</MAIL_CD>     <EMAIL_CD>1</EMAIL_CD>     <CRD_ID />     <PRIM_PHONE>6516653907</PRIM_PHONE>     <PRIM_PHONE_EXT />     <PRIM_FAX />     <EXTERNAL_ID />     <CONFIRM_YN>Y</CONFIRM_YN>     <REP_TERR_BASED_ON>R</REP_TERR_BASED_ON>   </FIRM></MarsFirmDataSet>');
        //upsertFirmResult=MARSApexGateway.SyncFirms('<MarsFirmDataSet xmlns=\"http://tempuri.org/MarsFirm.xsd\"><FIRM>     <FIRM_ID>254789</FIRM_ID>     <EXTERNAL_FIRM_ID />    <SHORT_NM></SHORT_NM> <FIRM_COMMENT />     <FIRM_NAME>CRI Securities LLC</FIRM_NAME>     <FIRM_NAME_CAPS>CRI SECURITIES LLC</FIRM_NAME_CAPS>     <SHORT_NAME>CRI Securities</SHORT_NAME>     <SHORT_NAME_CAPS>CRI SECURITIES</SHORT_NAME_CAPS>     <HOME_OFFICE_ID>2563</HOME_OFFICE_ID>     <NUMBER_OF_REG_STATES />     <GEO_CONC />     <LAST_FIRM_NOTE_DATE />     <ADDRESS_ID>2523</ADDRESS_ID>     <FIRM_TYPE>IN</FIRM_TYPE>     <WEB_SITE />     <STATUS_CD>CONFIRMED</STATUS_CD>     <PARENT_FIRM_ID>xx</PARENT_FIRM_ID>     <STATUS_UPDATE_DATE>1/19/2011</STATUS_UPDATE_DATE>     <NEW_FIRM_TYPE />     <SALES_GOAL_AMOUNT />     <ENTRY_DATE>1/19/2011 PM</ENTRY_DATE>     <ENTRY_USER>KMILLER </ENTRY_USER>     <UPDATE_DATE>1/19/2011 3:18:17</UPDATE_DATE>     <UPDATE_USER>KMILLER </UPDATE_USER>     <KEY_ACCT_TERR />     <NSCC_FIRM_NBR />     <SDR_FLG />     <CALL_CD>1</CALL_CD>     <MAIL_CD>1</MAIL_CD>     <EMAIL_CD>1</EMAIL_CD>     <CRD_ID />     <PRIM_PHONE>6516653907</PRIM_PHONE>     <PRIM_PHONE_EXT />     <PRIM_FAX />     <EXTERNAL_ID />     <CONFIRM_YN>Y</CONFIRM_YN>     <REP_TERR_BASED_ON>R</REP_TERR_BASED_ON>  </FIRM>  <FIRM>     <FIRM_ID>22235454</FIRM_ID>     <EXTERNAL_FIRM_ID />    <SHORT_NM></SHORT_NM> <FIRM_COMMENT />     <FIRM_NAME>CRI Securities LLC</FIRM_NAME>     <FIRM_NAME_CAPS>CRI SECURITIES LLC</FIRM_NAME_CAPS>     <SHORT_NAME>CRI Securities</SHORT_NAME>     <SHORT_NAME_CAPS>CRI SECURITIES</SHORT_NAME_CAPS>     <HOME_OFFICE_ID>2564</HOME_OFFICE_ID>     <NUMBER_OF_REG_STATES />     <GEO_CONC />     <LAST_FIRM_NOTE_DATE />     <ADDRESS_ID>2523</ADDRESS_ID>     <FIRM_TYPE>IN</FIRM_TYPE>     <WEB_SITE />     <STATUS_CD>CONFIRMED</STATUS_CD>     <PARENT_FIRM_ID>xx</PARENT_FIRM_ID>     <STATUS_UPDATE_DATE>1/19/2011 3:18:17 PM</STATUS_UPDATE_DATE>     <NEW_FIRM_TYPE />     <SALES_GOAL_AMOUNT />     <ENTRY_DATE>1/19/2011 3:18:17 PM</ENTRY_DATE>     <ENTRY_USER>KMILLER </ENTRY_USER>     <UPDATE_DATE>1/19/2011 3:18:17 PM</UPDATE_DATE>     <UPDATE_USER>KMILLER </UPDATE_USER>     <KEY_ACCT_TERR />     <NSCC_FIRM_NBR />     <SDR_FLG />     <CALL_CD>1</CALL_CD>     <MAIL_CD>1</MAIL_CD>     <EMAIL_CD>1</EMAIL_CD>     <CRD_ID />     <PRIM_PHONE>6516653907</PRIM_PHONE>     <PRIM_PHONE_EXT />     <PRIM_FAX />     <EXTERNAL_ID />     <CONFIRM_YN>Y</CONFIRM_YN>     <REP_TERR_BASED_ON>R</REP_TERR_BASED_ON>   </FIRM><FIRM>     <FIRM_ID>2222456</FIRM_ID>     <EXTERNAL_FIRM_ID />    <SHORT_NM></SHORT_NM> <FIRM_COMMENT />     <FIRM_NAME>CRI Securities LLC</FIRM_NAME>     <FIRM_NAME_CAPS>CRI SECURITIES LLC</FIRM_NAME_CAPS>     <SHORT_NAME>CRI Securities</SHORT_NAME>     <SHORT_NAME_CAPS>CRI SECURITIES</SHORT_NAME_CAPS>     <HOME_OFFICE_ID>2555555555</HOME_OFFICE_ID>     <NUMBER_OF_REG_STATES />     <GEO_CONC />     <LAST_FIRM_NOTE_DATE />     <ADDRESS_ID>2523</ADDRESS_ID>     <FIRM_TYPE>IN</FIRM_TYPE>     <WEB_SITE />     <STATUS_CD>CONFIRMED</STATUS_CD>     <PARENT_FIRM_ID>xx</PARENT_FIRM_ID>     <STATUS_UPDATE_DATE>1/19/2011 3:18:17 PM</STATUS_UPDATE_DATE>     <NEW_FIRM_TYPE />     <SALES_GOAL_AMOUNT />     <ENTRY_DATE>1/19/2011 3:18:17 PM</ENTRY_DATE>     <ENTRY_USER>KMILLER </ENTRY_USER>     <UPDATE_DATE>1/19/2011 3:18:17 PM</UPDATE_DATE>     <UPDATE_USER>KMILLER </UPDATE_USER>     <KEY_ACCT_TERR />     <NSCC_FIRM_NBR />     <SDR_FLG />     <CALL_CD>1</CALL_CD>     <MAIL_CD>1</MAIL_CD>     <EMAIL_CD>1</EMAIL_CD>     <CRD_ID />     <PRIM_PHONE>6516653907</PRIM_PHONE>     <PRIM_PHONE_EXT />     <PRIM_FAX />     <EXTERNAL_ID />     <CONFIRM_YN>Y</CONFIRM_YN>     <REP_TERR_BASED_ON>R</REP_TERR_BASED_ON>   </FIRM></MarsFirmDataSet>');
        upsertFirmResult=MARSApexGateway.SyncFirms('<MarsFirmDataSet xmlns=\"http://tempuri.org/MarsFirm.xsd\"><FIRM>     <FIRM_ID>254789</FIRM_ID>  <OFFICE_NM>CRI Securities LLC</OFFICE_NM>   <EXTERNAL_FIRM_ID />    <SHORT_NM></SHORT_NM> <FIRM_COMMENT />     <FIRM_NAME>CRI Securities LLC</FIRM_NAME>     <FIRM_NAME_CAPS>CRI SECURITIES LLC</FIRM_NAME_CAPS>     <SHORT_NAME>CRI Securities</SHORT_NAME>     <SHORT_NAME_CAPS>CRI SECURITIES</SHORT_NAME_CAPS>     <HOME_OFFICE_ID>2563</HOME_OFFICE_ID>     <NUMBER_OF_REG_STATES />     <GEO_CONC />     <LAST_FIRM_NOTE_DATE />     <ADDRESS_ID>2523</ADDRESS_ID>     <FIRM_TYPE>IN</FIRM_TYPE><ADDRESS1>1 st street</ADDRESS1><ADDRESS2>2nd street</ADDRESS2><ADDRESS3>3rd street</ADDRESS3><ADDRESS4>4th street</ADDRESS4><CITY>Los vages</CITY><STATE_ID>LA</STATE_ID><ZIP>90001</ZIP><COUNTRY_CD>US</COUNTRY_CD>     <WEB_SITE />     <STATUS_CD>CONFIRMED</STATUS_CD>     <PARENT_FIRM_ID>xx</PARENT_FIRM_ID>     <STATUS_UPDATE_DATE>1/19/2011 3:18:17 PM</STATUS_UPDATE_DATE>     <NEW_FIRM_TYPE />     <SALES_GOAL_AMOUNT />     <ENTRY_DATE>1/19/2011 PM</ENTRY_DATE>     <ENTRY_USER>KMILLER </ENTRY_USER>     <UPDATE_DATE>1/19/2011 3:18:17</UPDATE_DATE>     <UPDATE_USER>KMILLER </UPDATE_USER>     <KEY_ACCT_TERR />     <NSCC_FIRM_NBR />     <SDR_FLG />     <CALL_CD>1</CALL_CD>     <MAIL_CD>1</MAIL_CD>     <EMAIL_CD>1</EMAIL_CD>     <CRD_ID>TEST123</CRD_ID>     <PRIM_PHONE>6516653907</PRIM_PHONE>     <PRIM_PHONE_EXT />     <PRIM_FAX />     <EXTERNAL_ID />     <CONFIRM_YN>Y</CONFIRM_YN>     <REP_TERR_BASED_ON>R</REP_TERR_BASED_ON>  </FIRM>  <FIRM>     <FIRM_ID>22235454</FIRM_ID>    <OFFICE_NM>CRI Securities LLC</OFFICE_NM> <EXTERNAL_FIRM_ID />    <SHORT_NM></SHORT_NM> <FIRM_COMMENT />     <FIRM_NAME>CRI Securities LLC</FIRM_NAME>     <FIRM_NAME_CAPS>CRI SECURITIES LLC</FIRM_NAME_CAPS>     <SHORT_NAME>CRI Securities</SHORT_NAME>     <SHORT_NAME_CAPS>CRI SECURITIES</SHORT_NAME_CAPS>     <HOME_OFFICE_ID>2564</HOME_OFFICE_ID>     <NUMBER_OF_REG_STATES />     <GEO_CONC />     <LAST_FIRM_NOTE_DATE />     <ADDRESS_ID>2523</ADDRESS_ID>     <FIRM_TYPE>IN</FIRM_TYPE>  <ADDRESS1>1 st street</ADDRESS1><ADDRESS2></ADDRESS2><ADDRESS3></ADDRESS3><ADDRESS4></ADDRESS4><CITY>Los vages</CITY><STATE_ID>LA</STATE_ID><ZIP>90001</ZIP><COUNTRY_CD>US</COUNTRY_CD>   <WEB_SITE />     <STATUS_CD>CONFIRMED</STATUS_CD>     <PARENT_FIRM_ID>xx</PARENT_FIRM_ID>     <STATUS_UPDATE_DATE>1/19/2011 3:18:17 PM</STATUS_UPDATE_DATE>     <NEW_FIRM_TYPE />     <SALES_GOAL_AMOUNT />     <ENTRY_DATE>1/19/2011 3:18:17 PM</ENTRY_DATE>     <ENTRY_USER>KMILLER </ENTRY_USER>     <UPDATE_DATE>1/19/2011 3:18:17 PM</UPDATE_DATE>     <UPDATE_USER>KMILLER </UPDATE_USER>     <KEY_ACCT_TERR />     <NSCC_FIRM_NBR />     <SDR_FLG />     <CALL_CD>1</CALL_CD>     <MAIL_CD>1</MAIL_CD>     <EMAIL_CD>1</EMAIL_CD>     <CRD_ID />     <PRIM_PHONE>6516653907</PRIM_PHONE>     <PRIM_PHONE_EXT />     <PRIM_FAX />     <EXTERNAL_ID />     <CONFIRM_YN>Y</CONFIRM_YN>     <REP_TERR_BASED_ON>R</REP_TERR_BASED_ON>   </FIRM><FIRM>     <FIRM_ID>222245</FIRM_ID> <OFFICE_NM>CRI Securities LLC</OFFICE_NM>    <EXTERNAL_FIRM_ID />    <SHORT_NM></SHORT_NM> <FIRM_COMMENT />     <FIRM_NAME>CRI Securities LLC</FIRM_NAME>     <FIRM_NAME_CAPS>CRI SECURITIES LLC</FIRM_NAME_CAPS>     <SHORT_NAME>CRI Securities</SHORT_NAME>     <SHORT_NAME_CAPS>CRI SECURITIES</SHORT_NAME_CAPS>     <HOME_OFFICE_ID>255555</HOME_OFFICE_ID>     <NUMBER_OF_REG_STATES />     <GEO_CONC />     <LAST_FIRM_NOTE_DATE />     <ADDRESS_ID>2523</ADDRESS_ID>     <FIRM_TYPE>IN</FIRM_TYPE>  <ADDRESS1>1 st street</ADDRESS1><ADDRESS2></ADDRESS2><ADDRESS3></ADDRESS3><ADDRESS4></ADDRESS4><CITY>Los vages</CITY><STATE_ID>LA</STATE_ID><ZIP>90001</ZIP><COUNTRY_CD>US</COUNTRY_CD>    <WEB_SITE />     <STATUS_CD>CONFIRMED</STATUS_CD>     <PARENT_FIRM_ID>xx</PARENT_FIRM_ID>     <STATUS_UPDATE_DATE>1/19/2011 3:18:17 PM</STATUS_UPDATE_DATE>     <NEW_FIRM_TYPE />     <SALES_GOAL_AMOUNT />     <ENTRY_DATE>1/19/2011 3:18:17 PM</ENTRY_DATE>     <ENTRY_USER>KMILLER </ENTRY_USER>     <UPDATE_DATE>1/19/2011 3:18:17 PM</UPDATE_DATE>     <UPDATE_USER>KMILLER </UPDATE_USER>     <KEY_ACCT_TERR />     <NSCC_FIRM_NBR />     <SDR_FLG />     <CALL_CD>1</CALL_CD>     <MAIL_CD>1</MAIL_CD>     <EMAIL_CD>1</EMAIL_CD>     <CRD_ID />     <PRIM_PHONE>6516653907</PRIM_PHONE>     <PRIM_PHONE_EXT />     <PRIM_FAX />     <EXTERNAL_ID />     <CONFIRM_YN>Y</CONFIRM_YN>     <REP_TERR_BASED_ON>R</REP_TERR_BASED_ON>   </FIRM></MarsFirmDataSet>');
        upsertFirmResult=MARSApexGateway.SyncFirms('');
        
        
        System.debug('\n Before Offices List');
        List<MARSApexGateway.ACK> upsertOfficeResponse=new List<MARSApexGateway.ACK>();
        upsertOfficeResponse=MARSApexGateway.SyncOffices('<?xml version="1.0" encoding="utf-16"?><MarsOfficeDataSet xmlns="http://tempuri.org/MarsOffice.xsd"><OFFICE><OFFICE_ID>2563</OFFICE_ID><EXTERNAL_OFFICE_ID /><FIRM_ID>1496</FIRM_ID><EXTERNAL_FIRM_ID>'+firm.Id+'</EXTERNAL_FIRM_ID><OFFICE_NM>MN, Saint Paul, 400 Robert Street North</OFFICE_NM><OFFICE_NM_CAPS>MN, SAINT PAUL, 400 ROBERT STREET NORTH</OFFICE_NM_CAPS><ADDR_ID>2523</ADDR_ID><ADDRESS1>400 Robert Street North</ADDRESS1><ADDRESS2 /><ADDRESS3 /><ADDRESS4 /><CITY>Saint Paul</CITY><STATE_ID>MN</STATE_ID><ZIP>55101</ZIP><COUNTRY_CD>US</COUNTRY_CD><PHONE>6516653907</PHONE><EXTENSION>1234</EXTENSION><FAX /><STATUS_CD>CONFIRMED</STATUS_CD><OFFICE_FIRM_TYPE>IN</OFFICE_FIRM_TYPE><ENTRY_DATE>1/19/2011 3:18:17 PM</ENTRY_DATE><ENTRY_USR>KMILLER </ENTRY_USR><UPDATE_DATE>1/19/2011 3:18:17 PM</UPDATE_DATE><UPDATE_USR>KMILLER </UPDATE_USR><OFFICE_MANAGER_ID /><NUMBER_OF_REPS>0</NUMBER_OF_REPS><TIMEZONE /><LAST_MEETING_DATE /><OFFICE_COMMENT /><STATUS_UPDATE_DATE>1/19/2011 3:18:17 PM</STATUS_UPDATE_DATE><NEW_OFFICE_FIRM_TYPE /><WEB_SITE /><HOME_OFF_FLAG>Y</HOME_OFF_FLAG><CALL_CD>1</CALL_CD><CALL_CD_OVERRIDE_FLG><FIRM_TYPE_OVERRIDE_FLG>Y</FIRM_TYPE_OVERRIDE_FLG></CALL_CD_OVERRIDE_FLG><MAIL_CD>1</MAIL_CD><MAIL_CD_OVERRIDE_FLG /><EMAIL_CD>1</EMAIL_CD><EMAIL_CD_OVERRIDE_FLG /><LATITUDE /><LONGITUDE /><CONFIRM_YN>Y</CONFIRM_YN><CITY_CAPS>SAINT PAUL</CITY_CAPS><FIRM_NM>CRI Securities LLC</FIRM_NM><FIRM_NM_CAPS>CRI SECURITIES LLC</FIRM_NM_CAPS></OFFICE><OFFICE><OFFICE_ID>2564</OFFICE_ID><EXTERNAL_OFFICE_ID /><FIRM_ID>1496</FIRM_ID><EXTERNAL_FIRM_ID></EXTERNAL_FIRM_ID><OFFICE_NM>MN, Saint Paul, 400 Robert Street North</OFFICE_NM><OFFICE_NM_CAPS>MN, SAINT PAUL, 400 ROBERT STREET NORTH</OFFICE_NM_CAPS><ADDR_ID>2523</ADDR_ID><ADDRESS1>400 Robert Street North</ADDRESS1><ADDRESS2 /><ADDRESS3 /><ADDRESS4 /><CITY>Saint Paul</CITY><STATE_ID>MN</STATE_ID><ZIP>55101</ZIP><COUNTRY_CD>US</COUNTRY_CD><PHONE>6516653907</PHONE><EXTENSION>1234</EXTENSION><FAX /><STATUS_CD>CONFIRMED</STATUS_CD><OFFICE_FIRM_TYPE>IN</OFFICE_FIRM_TYPE><ENTRY_DATE>1/19/2011 3:18:17 PM</ENTRY_DATE><ENTRY_USR>KMILLER </ENTRY_USR><UPDATE_DATE>1/19/2011 3:18:17 PM</UPDATE_DATE><UPDATE_USR>KMILLER </UPDATE_USR><FIRM_TYPE_OVERRIDE_FLG>N</FIRM_TYPE_OVERRIDE_FLG><OFFICE_MANAGER_ID /><NUMBER_OF_REPS>0</NUMBER_OF_REPS><TIMEZONE /><LAST_MEETING_DATE /><OFFICE_COMMENT /><STATUS_UPDATE_DATE>1/19/2011 3:18:17 PM</STATUS_UPDATE_DATE><NEW_OFFICE_FIRM_TYPE /><LAST_SALE_DT></LAST_SALE_DT><WEB_SITE /><HOME_OFF_FLAG>N</HOME_OFF_FLAG><CALL_CD>1</CALL_CD><CALL_CD_OVERRIDE_FLG></CALL_CD_OVERRIDE_FLG><MAIL_CD>1</MAIL_CD><MAIL_CD_OVERRIDE_FLG /><EMAIL_CD>1</EMAIL_CD><EMAIL_CD_OVERRIDE_FLG /><LATITUDE /><LONGITUDE /><CONFIRM_YN>Y</CONFIRM_YN><CITY_CAPS>SAINT PAUL</CITY_CAPS><FIRM_NM>CRI Securities LLC</FIRM_NM><FIRM_NM_CAPS>CRI SECURITIES LLC</FIRM_NM_CAPS></OFFICE><OFFICE><OFFICE_ID>2564</OFFICE_ID><EXTERNAL_OFFICE_ID /><FIRM_ID>1496</FIRM_ID><EXTERNAL_FIRM_ID>'+firm.Id+'</EXTERNAL_FIRM_ID><OFFICE_NM>MN, Saint Paul, 400 Robert Street North</OFFICE_NM><OFFICE_NM_CAPS>MN, SAINT PAUL, 400 ROBERT STREET NORTH</OFFICE_NM_CAPS><ADDR_ID>2523</ADDR_ID><ADDRESS1>400 Robert Street North</ADDRESS1><ADDRESS2 /><ADDRESS3 /><ADDRESS4 /><CITY>Saint Paul</CITY><STATE_ID>MN</STATE_ID><ZIP>55101</ZIP><COUNTRY_CD>US</COUNTRY_CD><PHONE>6516653907</PHONE><EXTENSION /><FAX /><STATUS_CD>CONFIRMED</STATUS_CD><OFFICE_FIRM_TYPE>IN</OFFICE_FIRM_TYPE><ENTRY_DATE>1/19/2011 3:18:17 PM</ENTRY_DATE><ENTRY_USR>KMILLER </ENTRY_USR><UPDATE_DATE>1/19/2011 3:18:17 PM</UPDATE_DATE><UPDATE_USR>KMILLER </UPDATE_USR><FIRM_TYPE_OVERRIDE_FLG>N</FIRM_TYPE_OVERRIDE_FLG><OFFICE_MANAGER_ID /><NUMBER_OF_REPS>0</NUMBER_OF_REPS><TIMEZONE /><LAST_MEETING_DATE /><LAST_SALE_DT></LAST_SALE_DT><OFFICE_COMMENT /><STATUS_UPDATE_DATE>1/19/2011 3:18:17 PM</STATUS_UPDATE_DATE><NEW_OFFICE_FIRM_TYPE /><WEB_SITE /><HOME_OFF_FLAG>N</HOME_OFF_FLAG><CALL_CD>1</CALL_CD><CALL_CD_OVERRIDE_FLG></CALL_CD_OVERRIDE_FLG><MAIL_CD>1</MAIL_CD><MAIL_CD_OVERRIDE_FLG /><EMAIL_CD>1</EMAIL_CD><EMAIL_CD_OVERRIDE_FLG /><LATITUDE /><LONGITUDE /><CONFIRM_YN>Y</CONFIRM_YN><CITY_CAPS>SAINT PAUL</CITY_CAPS><FIRM_NM>CRI Securities LLC</FIRM_NM><FIRM_NM_CAPS>CRI SECURITIES LLC</FIRM_NM_CAPS></OFFICE><OFFICE><OFFICE_ID>2566</OFFICE_ID><EXTERNAL_OFFICE_ID /><FIRM_ID>1496</FIRM_ID><EXTERNAL_FIRM_ID></EXTERNAL_FIRM_ID><OFFICE_NM>MN, Saint Paul, 400 Robert Street North</OFFICE_NM><OFFICE_NM_CAPS>MN, SAINT PAUL, 400 ROBERT STREET NORTH</OFFICE_NM_CAPS><ADDR_ID>2523</ADDR_ID><ADDRESS1>400 Robert Street North</ADDRESS1><ADDRESS2 /><ADDRESS3 /><ADDRESS4 /><CITY>Saint Paul</CITY><STATE_ID>MN</STATE_ID><ZIP>55101</ZIP><COUNTRY_CD>US</COUNTRY_CD><PHONE>6516653907</PHONE><EXTENSION /><FAX /><STATUS_CD>CONFIRMED</STATUS_CD><OFFICE_FIRM_TYPE>IN</OFFICE_FIRM_TYPE><ENTRY_DATE>1/244/2011 3:18:17 PM</ENTRY_DATE><ENTRY_USR>KMILLER </ENTRY_USR><UPDATE_DATE>1/19/2011 3:18:17 PM</UPDATE_DATE><UPDATE_USR>KMILLER </UPDATE_USR><LAST_SALE_DT></LAST_SALE_DT><FIRM_TYPE_OVERRIDE_FLG>N</FIRM_TYPE_OVERRIDE_FLG><OFFICE_MANAGER_ID /><NUMBER_OF_REPS>0</NUMBER_OF_REPS><TIMEZONE /><LAST_MEETING_DATE >1/19/2011 3:18:17 PM</LAST_MEETING_DATE ><OFFICE_COMMENT /><STATUS_UPDATE_DATE>1/19/2011 3:18:17 PM</STATUS_UPDATE_DATE><NEW_OFFICE_FIRM_TYPE /><WEB_SITE /><HOME_OFF_FLAG>N</HOME_OFF_FLAG><CALL_CD>1</CALL_CD><CALL_CD_OVERRIDE_FLG>713</CALL_CD_OVERRIDE_FLG><MAIL_CD>1</MAIL_CD><MAIL_CD_OVERRIDE_FLG /><EMAIL_CD>1</EMAIL_CD><EMAIL_CD_OVERRIDE_FLG /><LATITUDE /><LONGITUDE /><CONFIRM_YN>Y</CONFIRM_YN><CITY_CAPS>SAINT PAUL</CITY_CAPS><FIRM_NM>CRI Securities LLC</FIRM_NM><FIRM_NM_CAPS>CRI SECURITIES LLC</FIRM_NM_CAPS></OFFICE></MarsOfficeDataSet>');
        upsertOfficeResponse=MARSApexGateway.SyncOffices('');
        System.debug('\n After Offices List');
        
        List<MARSApexGateway.ACK> insertRepResponse=new List<MARSApexGateway.ACK>(); 
        insertRepResponse=MARSApexGateway.SyncReps('<?xml version="1.0" encoding="utf-16"?><MarsRepDataSet xmlns="http://tempuri.org/MarsRep1.xsd"><REP><REP_ID>6535</REP_ID><FIRM_ID>1</FIRM_ID><OFF_ID>1745</OFF_ID><FIRST_NM>Test With more than 40 characters 1111111111111</FIRST_NM><LAST_NM>Peterson</LAST_NM><LAST_NM_CAPS>PETERSON</LAST_NM_CAPS><TITLE /><SALUTATION /><BIRTH_MMDD>1010</BIRTH_MMDD><BIRTH_YYYY>1989</BIRTH_YYYY><NICK_NM /><SPOUSE_NM /><PERSONAL_INFO /><FIRST_SALE_DT>1/26/2011 12:00:00 AM</FIRST_SALE_DT><ASST_NM /><SALES_STAT_CD>X</SALES_STAT_CD><LAST_SALE_DT>1/28/2011 12:00:00 AM</LAST_SALE_DT><ORIG_CD /><LAST_MTG_DT>1/28/2011 12:00:00 AM</LAST_MTG_DT><LAST_CALL_DT /><LAST_NOTE_DT /><LAST_FULFILLMENT_DT /><PRIM_MOBILE>9502505860</PRIM_MOBILE><LAST_LETTER_DT /><MAIL_LIST /><ADDR1>234 Elmount St</ADDR1><ADDR2>234</ADDR2><ADDR3>Elmount </ADDR3><ADDR4>Elmount St</ADDR4><CITY>Elk Grove Village</CITY><STATE_ID>IL</STATE_ID><FIRM_TYPE_OVERRIDE_FLG></FIRM_TYPE_OVERRIDE_FLG><ZIP>60009</ZIP><COUNTRY_CD>US</COUNTRY_CD><PRIM_PHONE>8745685689</PRIM_PHONE><PRIM_PHONE_EXT>1234</PRIM_PHONE_EXT><PRIM_FAX /><TIME_ZONE /><REP_STAFF_CD>R</REP_STAFF_CD><STAT_CD>A </STAT_CD><EMAIL_ID>kcshekhar121@gmail.com;kcshekhar121@gmail.com</EMAIL_ID><EMAIL_ID2 /><REP_COMMENT /><PREFIX_NM>null</PREFIX_NM><MIDDLE_NM /><SUFFIX_NM /><REP_FIRM_TYPE>IN</REP_FIRM_TYPE><STAT_UPD_DT>1/26/2011 6:04:00 PM</STAT_UPD_DT><ALLOW_MAILINGS>N</ALLOW_MAILINGS><FIRST_SALE_PROCESS_DT>1/26/2011 12:00:00 AM</FIRST_SALE_PROCESS_DT><HOUSE_REP>X</HOUSE_REP><EXTERNAL_REP_ID /><EXTERNAL_OFF_ID>'+office.Id+'</EXTERNAL_OFF_ID><EXTERNAL_FIRM_ID>752</EXTERNAL_FIRM_ID><ADDRESS_LOCKED>N</ADDRESS_LOCKED><ENTRY_USR>KMILLER </ENTRY_USR><ENTRY_DT>1/26/2011 6:02:38 PM</ENTRY_DT><UPD_USR>SYSTEM  </UPD_USR><UPD_DT>8/6/2013 7:00:39 PM</UPD_DT><CALL_CD>1</CALL_CD><CALL_CD_OVERRIDE_FLG /><MAIL_CD>1</MAIL_CD><MAIL_CD_OVERRIDE_FLG /><EMAIL_CD>1</EMAIL_CD><EMAIL_CD_OVERRIDE_FLG /><CRD_ID/><LATITUDE /><LONGITUDE /><DONOTCALL /><DONOTMAIL /><DONOTEMAIL /><CONFIRM_YN>Y</CONFIRM_YN><RECORD_TYPE>R</RECORD_TYPE><SEARCH_STATE_ID>IL</SEARCH_STATE_ID><SEARCH_COUNTRY_CD>US</SEARCH_COUNTRY_CD><SEARCH_PRIM_PHONE>8745685689          </SEARCH_PRIM_PHONE><SEARCH_TIME_ZONE /><SEARCH_ZIP>60009</SEARCH_ZIP><SEARCH_CITY>ELK GROVE VILLAGE</SEARCH_CITY><FIRST_NM_CAPS>KRIS</FIRST_NM_CAPS><REP_REGISTRATION /></REP><REP><REP_ID>6536</REP_ID><FIRM_ID>1</FIRM_ID><OFF_ID>1745</OFF_ID><FIRST_NM>null</FIRST_NM><LAST_NM>Peterson</LAST_NM><LAST_NM_CAPS>PETERSON</LAST_NM_CAPS><TITLE /><SALUTATION /><BIRTH_MMDD>101</BIRTH_MMDD><BIRTH_YYYY>1989</BIRTH_YYYY><NICK_NM /><SPOUSE_NM /><PERSONAL_INFO /><FIRST_SALE_DT>1/26/2011 12:00:00 AM</FIRST_SALE_DT><ASST_NM /><SALES_STAT_CD>X</SALES_STAT_CD><LAST_SALE_DT>1/28/2011 12:00:00 AM</LAST_SALE_DT><ORIG_CD /><LAST_MTG_DT /><LAST_CALL_DT /><LAST_NOTE_DT /><LAST_FULFILLMENT_DT /><LAST_LETTER_DT /><FIRM_TYPE_OVERRIDE_FLG></FIRM_TYPE_OVERRIDE_FLG><MAIL_LIST /><ADDR1>234 Elmount St</ADDR1><ADDR2>234</ADDR2><ADDR3>Elmount </ADDR3><ADDR4>Elmount St</ADDR4><CITY>Elk Grove Village</CITY><STATE_ID>IL</STATE_ID><ZIP>60009</ZIP><COUNTRY_CD>US</COUNTRY_CD><PRIM_PHONE>8745685689</PRIM_PHONE><PRIM_PHONE_EXT /><PRIM_FAX /><TIME_ZONE /><REP_STAFF_CD>R</REP_STAFF_CD><STAT_CD>A </STAT_CD><EMAIL_ID>kcshekhar121@gmail.com</EMAIL_ID><EMAIL_ID2 /><REP_COMMENT /><PREFIX_NM>null</PREFIX_NM><MIDDLE_NM /><SUFFIX_NM /><REP_FIRM_TYPE>IN</REP_FIRM_TYPE><STAT_UPD_DT>1/26/2011 6:04:00 PM</STAT_UPD_DT><ALLOW_MAILINGS>N</ALLOW_MAILINGS><FIRST_SALE_PROCESS_DT>1/26/2011 12:00:00 AM</FIRST_SALE_PROCESS_DT><HOUSE_REP>X</HOUSE_REP><EXTERNAL_REP_ID /><EXTERNAL_OFF_ID>'+office.Id+'</EXTERNAL_OFF_ID><EXTERNAL_FIRM_ID>752</EXTERNAL_FIRM_ID><ADDRESS_LOCKED>N</ADDRESS_LOCKED><ENTRY_USR>KMILLER </ENTRY_USR><ENTRY_DT>1/26/2011 6:02:38 PM</ENTRY_DT><UPD_USR>SYSTEM  </UPD_USR><UPD_DT>8/6/2013 7:00:39 PM</UPD_DT><CALL_CD>1</CALL_CD><CALL_CD_OVERRIDE_FLG /><MAIL_CD>1</MAIL_CD><MAIL_CD_OVERRIDE_FLG /><EMAIL_CD>1</EMAIL_CD><EMAIL_CD_OVERRIDE_FLG /><CRD_ID>ABC123</CRD_ID><LATITUDE /><LONGITUDE /><DONOTCALL /><DONOTMAIL /><DONOTEMAIL /><CONFIRM_YN>Y</CONFIRM_YN><RECORD_TYPE>R</RECORD_TYPE><SEARCH_STATE_ID>IL</SEARCH_STATE_ID><SEARCH_COUNTRY_CD>US</SEARCH_COUNTRY_CD><SEARCH_PRIM_PHONE>8745685689          </SEARCH_PRIM_PHONE><SEARCH_TIME_ZONE /><SEARCH_ZIP>60009</SEARCH_ZIP><SEARCH_CITY>ELK GROVE VILLAGE</SEARCH_CITY><FIRST_NM_CAPS>KRIS</FIRST_NM_CAPS><REP_REGISTRATION /></REP><REP><REP_ID>6536</REP_ID><FIRM_ID>1221</FIRM_ID><OFF_ID>1745</OFF_ID><FIRST_NM>null</FIRST_NM><LAST_NM>Peterson</LAST_NM><LAST_NM_CAPS>PETERSON</LAST_NM_CAPS><TITLE /><SALUTATION /><BIRTH_MMDD>101</BIRTH_MMDD><BIRTH_YYYY>1989</BIRTH_YYYY><NICK_NM /><SPOUSE_NM /><PERSONAL_INFO /><FIRST_SALE_DT>126-d2011 12:00:00 AM</FIRST_SALE_DT><ASST_NM /><SALES_STAT_CD>X</SALES_STAT_CD><FIRM_TYPE_OVERRIDE_FLG></FIRM_TYPE_OVERRIDE_FLG><LAST_SALE_DT>1/28/2011 12:00:00 AM</LAST_SALE_DT><ORIG_CD /><LAST_MTG_DT /><LAST_CALL_DT /><LAST_NOTE_DT /><LAST_FULFILLMENT_DT /><LAST_LETTER_DT /><MAIL_LIST /><ADDR1>234 Elmount St</ADDR1><ADDR2>234</ADDR2><ADDR3>Elmount </ADDR3><ADDR4>Elmount St</ADDR4><CITY>Elk Grove Village</CITY><STATE_ID>IL</STATE_ID><ZIP>60009</ZIP><COUNTRY_CD>US</COUNTRY_CD><PRIM_MOBILE></PRIM_MOBILE><PRIM_PHONE>8745685689</PRIM_PHONE><PRIM_PHONE_EXT /><PRIM_FAX /><TIME_ZONE /><REP_STAFF_CD>R</REP_STAFF_CD><STAT_CD>A </STAT_CD><EMAIL_ID>kcshekhar121@gmail.com</EMAIL_ID><EMAIL_ID2 /><REP_COMMENT /><PREFIX_NM>null</PREFIX_NM><MIDDLE_NM /><SUFFIX_NM /><REP_FIRM_TYPE>IN</REP_FIRM_TYPE><STAT_UPD_DT>1/26/2011 6:04:00 PM</STAT_UPD_DT><ALLOW_MAILINGS>N</ALLOW_MAILINGS><FIRST_SALE_PROCESS_DT>1/26/2011 12:00:00 AM</FIRST_SALE_PROCESS_DT><HOUSE_REP>X</HOUSE_REP><EXTERNAL_REP_ID /><EXTERNAL_OFF_ID>'+office.Id+'</EXTERNAL_OFF_ID><EXTERNAL_FIRM_ID>752</EXTERNAL_FIRM_ID><ADDRESS_LOCKED>N</ADDRESS_LOCKED><ENTRY_USR>KMILLER </ENTRY_USR><ENTRY_DT>1/26/2011 6:02:38 PM</ENTRY_DT><UPD_USR>SYSTEM  </UPD_USR><UPD_DT>8/6/2013 7:00:39 PM</UPD_DT><CALL_CD>1</CALL_CD><CALL_CD_OVERRIDE_FLG /><MAIL_CD>1</MAIL_CD><MAIL_CD_OVERRIDE_FLG /><EMAIL_CD>1</EMAIL_CD><EMAIL_CD_OVERRIDE_FLG /><CRD_ID /><LATITUDE /><LONGITUDE /><DONOTCALL /><DONOTMAIL /><DONOTEMAIL /><CONFIRM_YN>Y</CONFIRM_YN><RECORD_TYPE>R</RECORD_TYPE><SEARCH_STATE_ID>IL</SEARCH_STATE_ID><SEARCH_COUNTRY_CD>US</SEARCH_COUNTRY_CD><SEARCH_PRIM_PHONE>8745685689          </SEARCH_PRIM_PHONE><SEARCH_TIME_ZONE /><SEARCH_ZIP>60009</SEARCH_ZIP><SEARCH_CITY>ELK GROVE VILLAGE</SEARCH_CITY><FIRST_NM_CAPS>KRIS</FIRST_NM_CAPS><REP_REGISTRATION /></REP><REP><REP_ID>6537</REP_ID><FIRM_ID>1221</FIRM_ID><OFF_ID>1745</OFF_ID><FIRST_NM>null</FIRST_NM><LAST_NM>Peterson</LAST_NM><LAST_NM_CAPS>PETERSON</LAST_NM_CAPS><TITLE /><SALUTATION /><BIRTH_MMDD>101</BIRTH_MMDD><BIRTH_YYYY>1989</BIRTH_YYYY><NICK_NM /><SPOUSE_NM /><PERSONAL_INFO /><FIRST_SALE_DT>126-d2011 12:00:00 AM</FIRST_SALE_DT><ASST_NM /><SALES_STAT_CD>X</SALES_STAT_CD><LAST_SALE_DT>1/28/2011 12:00:00 AM</LAST_SALE_DT><ORIG_CD /><LAST_MTG_DT /><LAST_CALL_DT /><LAST_NOTE_DT /><LAST_FULFILLMENT_DT /><LAST_LETTER_DT /><MAIL_LIST /><ADDR1>234 Elmount St</ADDR1><ADDR2>234</ADDR2><ADDR3>Elmount </ADDR3><ADDR4>Elmount St</ADDR4><CITY>Elk Grove Village</CITY><STATE_ID>IL</STATE_ID><ZIP>60009</ZIP><COUNTRY_CD>US</COUNTRY_CD><PRIM_PHONE>8745685689</PRIM_PHONE><PRIM_PHONE_EXT /><PRIM_FAX /><TIME_ZONE /><REP_STAFF_CD>R</REP_STAFF_CD><STAT_CD>A </STAT_CD><FIRM_TYPE_OVERRIDE_FLG></FIRM_TYPE_OVERRIDE_FLG><EMAIL_ID>kcshekhar121@gmail.com</EMAIL_ID><EMAIL_ID2 /><REP_COMMENT /><PREFIX_NM>null</PREFIX_NM><MIDDLE_NM /><SUFFIX_NM /><REP_FIRM_TYPE>IN</REP_FIRM_TYPE><STAT_UPD_DT>1/26/2011 6:04:00 PM</STAT_UPD_DT><ALLOW_MAILINGS>N</ALLOW_MAILINGS><FIRST_SALE_PROCESS_DT>1/26/2011 12:00:00 AM</FIRST_SALE_PROCESS_DT><HOUSE_REP>X</HOUSE_REP><EXTERNAL_REP_ID /><EXTERNAL_OFF_ID>'+office.Id+'</EXTERNAL_OFF_ID><EXTERNAL_FIRM_ID>752</EXTERNAL_FIRM_ID><ADDRESS_LOCKED>N</ADDRESS_LOCKED><ENTRY_USR>KMILLER </ENTRY_USR><ENTRY_DT>1/26/2011 6:02:38 PM</ENTRY_DT><UPD_USR>SYSTEM  </UPD_USR><UPD_DT>8/6/2013 7:00:39 PM</UPD_DT><CALL_CD>1</CALL_CD><CALL_CD_OVERRIDE_FLG /><MAIL_CD>1</MAIL_CD><MAIL_CD_OVERRIDE_FLG /><EMAIL_CD>1</EMAIL_CD><EMAIL_CD_OVERRIDE_FLG /><CRD_ID /><LATITUDE /><LONGITUDE /><DONOTCALL /><DONOTMAIL /><DONOTEMAIL /><CONFIRM_YN>Y</CONFIRM_YN><RECORD_TYPE>R</RECORD_TYPE><SEARCH_STATE_ID>IL</SEARCH_STATE_ID><SEARCH_COUNTRY_CD>US</SEARCH_COUNTRY_CD><SEARCH_PRIM_PHONE>8745685689          </SEARCH_PRIM_PHONE><SEARCH_TIME_ZONE /><SEARCH_ZIP>60009</SEARCH_ZIP><SEARCH_CITY>ELK GROVE VILLAGE</SEARCH_CITY><FIRST_NM_CAPS>KRIS</FIRST_NM_CAPS><REP_REGISTRATION /></REP></MarsRepDataSet>');
        insertRepResponse=MARSApexGateway.SyncReps('');
        
        List<MARSApexGateway.ACK> insertProductResponse=new List<MARSApexGateway.ACK>();
        insertProductResponse=MARSApexGateway.SyncProducts('<MarsProductDataSet xmlns="http://tempuri.org/MarsProduct.xsd"><PRODUCT><PROD_CD>PROD005</PROD_CD><EXTERNAL_ID></EXTERNAL_ID><PROD_ID>123</PROD_ID><PROD_TITLE>Release 1</PROD_TITLE><SHARE_CLASS>A</SHARE_CLASS><SHARE_CLASS_DESC>A Class</SHARE_CLASS_DESC><PROD_TYPE>AN</PROD_TYPE> <PROD_TYPE_DESC>Annuity</PROD_TYPE_DESC><PROD_STAT>O </PROD_STAT> <PROD_STAT_DESC>Open To New Investments</PROD_STAT_DESC><PROD_GRP>B</PROD_GRP> <PROD_GRP_DESC>Balanced</PROD_GRP_DESC><PROD_CUSIP /><SHORT_NM>Prod11</SHORT_NM><INVESTMENT_OBJECTIVE>AG </INVESTMENT_OBJECTIVE><INVESTMENT_OBJECTIVE_DESC>Aggressive Growth</INVESTMENT_OBJECTIVE_DESC><STAT_UPD_DT>5/21/2004 4:12:47 PM</STAT_UPD_DT><FUND_TYPE>CE </FUND_TYPE><FUND_TYPE_DSC>Closed End</FUND_TYPE_DSC> <ASSET_CLASS>EQ </ASSET_CLASS><ASSET_CLASS_DESC>Equities</ASSET_CLASS_DESC> <FUND_FAMILY>MAR</FUND_FAMILY><FUND_FAMILY_DESC>MARS Funds</FUND_FAMILY_DESC><FUND_COMP>COM</FUND_COMP><FUND_COMP_DESC>Competitor Funds</FUND_COMP_DESC> <ACRONYM /><FUND_OPEN_DT /><FUND_CLOSED_DT /><BD_TIER /><BANK_TIER /> <INST_TIER /> <LOAD_FUND /> <BD_LOAD_INDICATOR /> <CURRENCY_CODE /> <NAV /><NAV_DT /><ICI_FUND_CAT /><MCKINSEY_FUND_CAT /> <SALES_CHARGE_CD /><FIRM_ID /><ASSET_SUB_CLASS /><ASSET_SUB_CLASS_DESC /><UNIV_FUND_CD /><PROD_TRUST_FUND_CAT /><BUSINESS_TYPE /> <BUSINESS_TYPE_DESC /><PROD_FAMILY_GRP /><PROD_FAMILY_GRP_DESC /><DOMICILE_CD /><DOMICILE_CD_DESC /><COMPANY_CD /><COMPANY_CD_DESC /><DISTRIBUTOR_CD /><DISTRIBUTOR_CD_DESC /><COMPOSITION_CD>SI</COMPOSITION_CD><COMPOSITION_CD_DESC>Single</COMPOSITION_CD_DESC> <MGMT_FEE /><TICKER /><ENTRY_USR>KMILLER </ENTRY_USR><ENTRY_DT>5/21/2004 4:12:44 PM</ENTRY_DT> <UPD_USR>KMILLER </UPD_USR><UPD_DT>5/21/2004 4:13:25 PM</UPD_DT> <ACTIVITY_PROD_TYPE_FLG>N</ACTIVITY_PROD_TYPE_FLG><ACTIVITY_ASSET_SUB_CLASS_FLG>N</ACTIVITY_ASSET_SUB_CLASS_FLG></PRODUCT><PRODUCT><PROD_CD>PROD004</PROD_CD><EXTERNAL_ID></EXTERNAL_ID><PROD_ID>12344</PROD_ID><PROD_TITLE>Bhasker</PROD_TITLE><SHARE_CLASS>A</SHARE_CLASS><SHARE_CLASS_DESC>A Class</SHARE_CLASS_DESC><PROD_TYPE>AN</PROD_TYPE> <PROD_TYPE_DESC>Annuity</PROD_TYPE_DESC><PROD_STAT>O </PROD_STAT> <PROD_STAT_DESC>Open To New Investments</PROD_STAT_DESC><PROD_GRP>B</PROD_GRP> <PROD_GRP_DESC>Balanced</PROD_GRP_DESC><PROD_CUSIP /><SHORT_NM>Prod11</SHORT_NM><INVESTMENT_OBJECTIVE>AG </INVESTMENT_OBJECTIVE><INVESTMENT_OBJECTIVE_DESC>Aggressive Growth</INVESTMENT_OBJECTIVE_DESC><STAT_UPD_DT>5/21/2004 4:12:47 PM</STAT_UPD_DT><FUND_TYPE>CE </FUND_TYPE><FUND_TYPE_DSC>Closed End</FUND_TYPE_DSC> <ASSET_CLASS>EQ </ASSET_CLASS><ASSET_CLASS_DESC>Equities</ASSET_CLASS_DESC> <FUND_FAMILY>MAR</FUND_FAMILY><FUND_FAMILY_DESC>MARS Funds</FUND_FAMILY_DESC><FUND_COMP>COM</FUND_COMP><FUND_COMP_DESC>Competitor Funds</FUND_COMP_DESC> <ACRONYM /><FUND_OPEN_DT /><FUND_CLOSED_DT /><BD_TIER /><BANK_TIER /> <INST_TIER /> <LOAD_FUND /> <BD_LOAD_INDICATOR /> <CURRENCY_CODE /> <NAV /><NAV_DT /><ICI_FUND_CAT /><MCKINSEY_FUND_CAT /> <SALES_CHARGE_CD /><FIRM_ID /><ASSET_SUB_CLASS /><ASSET_SUB_CLASS_DESC /><UNIV_FUND_CD /><PROD_TRUST_FUND_CAT /><BUSINESS_TYPE /> <BUSINESS_TYPE_DESC /><PROD_FAMILY_GRP /><PROD_FAMILY_GRP_DESC /><DOMICILE_CD /><DOMICILE_CD_DESC /><COMPANY_CD /><COMPANY_CD_DESC /><DISTRIBUTOR_CD /><DISTRIBUTOR_CD_DESC /><COMPOSITION_CD>SI</COMPOSITION_CD><COMPOSITION_CD_DESC>Single</COMPOSITION_CD_DESC> <MGMT_FEE /><TICKER /><ENTRY_USR>KMILLER </ENTRY_USR><ENTRY_DT>5/21/2004 4:12:44 PM</ENTRY_DT> <UPD_USR>KMILLER </UPD_USR><UPD_DT>5/21/2004 4:13:25 PM</UPD_DT> <ACTIVITY_PROD_TYPE_FLG>N</ACTIVITY_PROD_TYPE_FLG><ACTIVITY_ASSET_SUB_CLASS_FLG>N</ACTIVITY_ASSET_SUB_CLASS_FLG></PRODUCT><PRODUCT> <PROD_CD>PROD002</PROD_CD><EXTERNAL_ID></EXTERNAL_ID><PROD_ID>1234</PROD_ID><PROD_TITLE>Bhasker</PROD_TITLE><SHARE_CLASS>A</SHARE_CLASS><SHARE_CLASS_DESC>A Class</SHARE_CLASS_DESC><PROD_TYPE>AN</PROD_TYPE> <PROD_TYPE_DESC>Annuity</PROD_TYPE_DESC><PROD_STAT>O </PROD_STAT> <PROD_STAT_DESC>Open To New Investments</PROD_STAT_DESC><PROD_GRP>B</PROD_GRP> <PROD_GRP_DESC>Balanced</PROD_GRP_DESC><PROD_CUSIP /><SHORT_NM>Prod11</SHORT_NM><INVESTMENT_OBJECTIVE>AG </INVESTMENT_OBJECTIVE><INVESTMENT_OBJECTIVE_DESC>Aggressive Growth</INVESTMENT_OBJECTIVE_DESC><STAT_UPD_DT>5/21/2004 4:12:47 PM</STAT_UPD_DT><FUND_TYPE>CE </FUND_TYPE><FUND_TYPE_DSC>Closed End</FUND_TYPE_DSC> <ASSET_CLASS>EQ </ASSET_CLASS><ASSET_CLASS_DESC>Equities</ASSET_CLASS_DESC> <FUND_FAMILY>MAR</FUND_FAMILY><FUND_FAMILY_DESC>MARS Funds</FUND_FAMILY_DESC><FUND_COMP>COM</FUND_COMP><FUND_COMP_DESC>Competitor Funds</FUND_COMP_DESC> <ACRONYM /><FUND_OPEN_DT /><FUND_CLOSED_DT /><BD_TIER /><BANK_TIER /> <INST_TIER /> <LOAD_FUND /> <BD_LOAD_INDICATOR /> <CURRENCY_CODE /> <NAV /><NAV_DT /><ICI_FUND_CAT /><MCKINSEY_FUND_CAT /> <SALES_CHARGE_CD /><FIRM_ID /><ASSET_SUB_CLASS /><ASSET_SUB_CLASS_DESC /><UNIV_FUND_CD /><PROD_TRUST_FUND_CAT /><BUSINESS_TYPE /> <BUSINESS_TYPE_DESC /><PROD_FAMILY_GRP /><PROD_FAMILY_GRP_DESC /><DOMICILE_CD /><DOMICILE_CD_DESC /><COMPANY_CD /><COMPANY_CD_DESC /><DISTRIBUTOR_CD /><DISTRIBUTOR_CD_DESC /><COMPOSITION_CD>SI</COMPOSITION_CD><COMPOSITION_CD_DESC>Single</COMPOSITION_CD_DESC> <MGMT_FEE /><TICKER /><ENTRY_USR>KMILLER </ENTRY_USR><ENTRY_DT>5/21/2004 4:12:44 PM</ENTRY_DT> <UPD_USR>KMILLER </UPD_USR><UPD_DT>5/21/2004 4:13:25 PM</UPD_DT> <ACTIVITY_PROD_TYPE_FLG>N</ACTIVITY_PROD_TYPE_FLG><ACTIVITY_ASSET_SUB_CLASS_FLG>N</ACTIVITY_ASSET_SUB_CLASS_FLG></PRODUCT><PRODUCT> <PROD_CD>PROD001</PROD_CD><EXTERNAL_ID></EXTERNAL_ID><PROD_ID>12</PROD_ID><PROD_TITLE>Bhasker</PROD_TITLE><SHARE_CLASS>A</SHARE_CLASS><SHARE_CLASS_DESC>A Class</SHARE_CLASS_DESC><PROD_TYPE>AN</PROD_TYPE> <PROD_TYPE_DESC>Annuity</PROD_TYPE_DESC><PROD_STAT>O </PROD_STAT> <PROD_STAT_DESC>Open To New Investments</PROD_STAT_DESC><PROD_GRP>B</PROD_GRP> <PROD_GRP_DESC>Balanced</PROD_GRP_DESC><PROD_CUSIP /><SHORT_NM>Prod11</SHORT_NM><INVESTMENT_OBJECTIVE>AG </INVESTMENT_OBJECTIVE><INVESTMENT_OBJECTIVE_DESC>Aggressive Growth</INVESTMENT_OBJECTIVE_DESC><STAT_UPD_DT>5/21/2004 4:12:47 PM</STAT_UPD_DT><FUND_TYPE>CE </FUND_TYPE><FUND_TYPE_DSC>Closed End</FUND_TYPE_DSC> <ASSET_CLASS>EQ </ASSET_CLASS><ASSET_CLASS_DESC>Equities</ASSET_CLASS_DESC> <FUND_FAMILY>MAR</FUND_FAMILY><FUND_FAMILY_DESC>MARS Funds</FUND_FAMILY_DESC><FUND_COMP>COM</FUND_COMP><FUND_COMP_DESC></FUND_COMP_DESC> <ACRONYM /><FUND_OPEN_DT /><FUND_CLOSED_DT /><BD_TIER /><BANK_TIER /> <INST_TIER /> <LOAD_FUND /> <BD_LOAD_INDICATOR /> <CURRENCY_CODE /> <NAV /><NAV_DT /><ICI_FUND_CAT /><MCKINSEY_FUND_CAT /> <SALES_CHARGE_CD /><FIRM_ID /><ASSET_SUB_CLASS /><ASSET_SUB_CLASS_DESC /><UNIV_FUND_CD /><PROD_TRUST_FUND_CAT /><BUSINESS_TYPE /> <BUSINESS_TYPE_DESC /><PROD_FAMILY_GRP /><PROD_FAMILY_GRP_DESC /><DOMICILE_CD /><DOMICILE_CD_DESC /><COMPANY_CD /><COMPANY_CD_DESC /><DISTRIBUTOR_CD /><DISTRIBUTOR_CD_DESC /><COMPOSITION_CD>SI</COMPOSITION_CD><COMPOSITION_CD_DESC>Single</COMPOSITION_CD_DESC> <MGMT_FEE /><TICKER /><ENTRY_USR>KMILLER </ENTRY_USR><ENTRY_DT>5/21/2004 4:12:44 PM</ENTRY_DT> <UPD_USR>KMILLER </UPD_USR><UPD_DT>5/21/2004 4:13:25 PM</UPD_DT> <ACTIVITY_PROD_TYPE_FLG>N</ACTIVITY_PROD_TYPE_FLG><ACTIVITY_ASSET_SUB_CLASS_FLG>N</ACTIVITY_ASSET_SUB_CLASS_FLG></PRODUCT> </MarsProductDataSet>');
        insertProductResponse=MARSApexGateway.SyncProducts('');
        
        System.debug('Sync Team Reps');
        List<MARSApexGateway.ACK> insertTeamRepResponse=new List<MARSApexGateway.ACK>();
        insertTeamRepResponse=MARSApexGateway.SyncTeamReps('<MarsTeamRepDataSet xmlns="http://tempuri.org/MarsTeamRep.xsd"> <TEAM_REP> <TEAM_REP_ID>724</TEAM_REP_ID> <REP_ID>10</REP_ID> <SPLIT_PERCENT>33.33</SPLIT_PERCENT><EXTERNAL_TEAM_ID>'+rep1.Id+'</EXTERNAL_TEAM_ID> <EXTERNAL_REP_ID >'+rep.Id+'</EXTERNAL_REP_ID > <EXTERNAL_ID/> </TEAM_REP> <TEAM_REP> <TEAM_REP_ID>724</TEAM_REP_ID> <REP_ID>13</REP_ID> <SPLIT_PERCENT>33.33</SPLIT_PERCENT> <EXTERNAL_TEAM_ID></EXTERNAL_TEAM_ID>  <EXTERNAL_REP_ID /> <EXTERNAL_ID/></TEAM_REP> <TEAM_REP> <TEAM_REP_ID>724</TEAM_REP_ID> <REP_ID>14</REP_ID> <SPLIT_PERCENT>33.34</SPLIT_PERCENT> <EXTERNAL_TEAM_ID /> <EXTERNAL_REP_ID /> <EXTERNAL_ID/></TEAM_REP> </MarsTeamRepDataSet>');
        insertTeamRepResponse=MARSApexGateway.SyncTeamReps('');
        
        MARSApexGateway.ACK syncMergeFirm=new MARSApexGateway.ACK();
        syncMergeFirm = MARSApexGateway.SyncMergeFirm('123456', '123455', firm.Id, '', '<MarsFirmDataSet xmlns=\"http://tempuri.org/MarsFirm.xsd\"></MarsFirmDataSet>');
        syncMergeFirm = MARSApexGateway.SyncMergeFirm('123456', '123455', '', firm1.Id, '<MarsFirmDataSet xmlns=\"http://tempuri.org/MarsFirm.xsd\"></MarsFirmDataSet>');
        syncMergeFirm = MARSApexGateway.SyncMergeFirm('123456', '123455', firm.Id, firm1.Id, '');
        //syncMergeFirm = MARSApexGateway.SyncMergeFirm('123456', '123455', firm.Id, firm1.Id, '<MarsFirmDataSet xmlns=\"http://tempuri.org/MarsFirm.xsd\"> <FIRM>     <FIRM_ID>254789</FIRM_ID>     <EXTERNAL_FIRM_ID />    <SHORT_NM></SHORT_NM> <FIRM_COMMENT />     <FIRM_NAME>CRI Securities LLC</FIRM_NAME>     <FIRM_NAME_CAPS>CRI SECURITIES LLC</FIRM_NAME_CAPS>     <SHORT_NAME>CRI Securities</SHORT_NAME>     <SHORT_NAME_CAPS>CRI SECURITIES</SHORT_NAME_CAPS>     <HOME_OFFICE_ID>2563</HOME_OFFICE_ID>     <NUMBER_OF_REG_STATES />     <GEO_CONC />     <LAST_FIRM_NOTE_DATE />     <ADDRESS_ID>2523</ADDRESS_ID>     <FIRM_TYPE>IN</FIRM_TYPE>     <WEB_SITE />     <STATUS_CD>CONFIRMED</STATUS_CD>     <PARENT_FIRM_ID>xx</PARENT_FIRM_ID>     <STATUS_UPDATE_DATE>1/19/2011 3:18:17 PM</STATUS_UPDATE_DATE>     <NEW_FIRM_TYPE />     <SALES_GOAL_AMOUNT />     <ENTRY_DATE>1/19/2011 3:18:17 PM</ENTRY_DATE>     <ENTRY_USER>KMILLER </ENTRY_USER>     <UPDATE_DATE>1/19/2011 3:18:17 PM</UPDATE_DATE>     <UPDATE_USER>KMILLER </UPDATE_USER>     <KEY_ACCT_TERR />     <NSCC_FIRM_NBR />     <SDR_FLG />     <CALL_CD>1</CALL_CD>     <MAIL_CD>1</MAIL_CD>     <EMAIL_CD>1</EMAIL_CD>     <CRD_ID />     <PRIM_PHONE>6516653907</PRIM_PHONE>     <PRIM_PHONE_EXT />     <PRIM_FAX />     <EXTERNAL_ID />     <CONFIRM_YN>Y</CONFIRM_YN>     <REP_TERR_BASED_ON>R</REP_TERR_BASED_ON>  </FIRM> </MarsFirmDataSet>');
        syncMergeFirm = MARSApexGateway.SyncMergeFirm('123456', '123455', firm.Id, firm1.Id, '<MarsFirmDataSet xmlns="http://tempuri.org/MarsFirm.xsd"><FIRM><FIRM_ID>22022</FIRM_ID><EXTERNAL_FIRM_ID>'+ firm.Id + '</EXTERNAL_FIRM_ID><FIRM_COMMENT /><FIRM_NAME>Scanlan, John D.</FIRM_NAME><FIRM_NAME_CAPS>SCANLAN, JOHN D.</FIRM_NAME_CAPS><SHORT_NAME>Scanlan, John D</SHORT_NAME><SHORT_NAME_CAPS>SCANLAN, JOHN D</SHORT_NAME_CAPS><HOME_OFFICE_ID>22022</HOME_OFFICE_ID><NUMBER_OF_REG_STATES /><GEO_CONC /><LAST_FIRM_NOTE_DATE>7/13/2015 1:19:37 AM</LAST_FIRM_NOTE_DATE><ADDRESS_ID /><FIRM_TYPE>IT</FIRM_TYPE><WEB_SITE /><STATUS_CD>Active</STATUS_CD><PARENT_FIRM_ID>xx</PARENT_FIRM_ID><STATUS_UPDATE_DATE>5/4/2004 3:44:55 PM</STATUS_UPDATE_DATE><NEW_FIRM_TYPE /><SALES_GOAL_AMOUNT /><ENTRY_DATE>5/4/2004 3:44:55 PM</ENTRY_DATE><ENTRY_USER>CONVERT </ENTRY_USER><UPDATE_DATE>7/13/2015 1:19:29 AM</UPDATE_DATE><UPDATE_USER>KMILLER </UPDATE_USER><KEY_ACCT_TERR /><NSCC_FIRM_NBR /><SDR_FLG /><CALL_CD>1</CALL_CD><MAIL_CD>1</MAIL_CD><EMAIL_CD>1</EMAIL_CD><CRD_ID /><PRIM_PHONE>4157513009</PRIM_PHONE><PRIM_PHONE_EXT /><PRIM_FAX /><EXTERNAL_ID>0019000001J8GMWAA3</EXTERNAL_ID><CONFIRM_YN>Y</CONFIRM_YN><REP_TERR_BASED_ON>R</REP_TERR_BASED_ON><OFFICE_NM>CA, San Francisco, 40 Paramoun</OFFICE_NM><ADDRESS1>40 Paramount Terrace</ADDRESS1><ADDRESS2 /><ADDRESS3 /><ADDRESS4 /><CITY>San Francisco</CITY><STATE_ID>CA</STATE_ID><ZIP>94118</ZIP><COUNTRY_CD>US</COUNTRY_CD></FIRM></MarsFirmDataSet>');
        
        MARSApexGateway.ACK syncMergeOffice=new MARSApexGateway.ACK();
        syncMergeOffice = MARSApexGateway.SyncMergeOffice('123456', '123455', office.Id, '', '<?xml version="1.0" encoding="utf-16"?><MarsOfficeDataSet xmlns="http://tempuri.org/MarsOffice.xsd"><OFFICE><OFFICE_ID>23219</OFFICE_ID><EXTERNAL_OFFICE_ID>'+office.Id+'</EXTERNAL_OFFICE_ID><FIRM_ID>23219</FIRM_ID><EXTERNAL_FIRM_ID>0019000001J8GfiAAF</EXTERNAL_FIRM_ID><OFFICE_NM>FL, Key Biscayne, 155 Ocean La</OFFICE_NM><OFFICE_NM_CAPS>FL, KEY BISCAYNE, 155 OCEAN LA</OFFICE_NM_CAPS><ADDR_ID>22823</ADDR_ID><ADDRESS1>155 Ocean Lane Dr # 913</ADDRESS1><ADDRESS2 /><ADDRESS3 /><ADDRESS4 /><CITY>Key Biscayne</CITY><STATE_ID>FL</STATE_ID><ZIP>33149</ZIP><COUNTRY_CD>US</COUNTRY_CD><PHONE>3053618808</PHONE><EXTENSION /><FAX /><STATUS_CD>Active</STATUS_CD><OFFICE_FIRM_TYPE>IT</OFFICE_FIRM_TYPE><ENTRY_DATE>5/4/2004 3:44:56 PM</ENTRY_DATE><ENTRY_USR>CONVERT </ENTRY_USR><UPDATE_DATE>7/13/2015 1:40:24 AM</UPDATE_DATE><UPDATE_USR>KMILLER </UPDATE_USR><OFFICE_MANAGER_ID /><NUMBER_OF_REPS>0</NUMBER_OF_REPS><TIMEZONE /><LAST_MEETING_DATE /><OFFICE_COMMENT /><STATUS_UPDATE_DATE>5/4/2004 4:04:36 PM</STATUS_UPDATE_DATE><NEW_OFFICE_FIRM_TYPE /><WEB_SITE /><HOME_OFF_FLAG>Y</HOME_OFF_FLAG><CALL_CD>1</CALL_CD><CALL_CD_OVERRIDE_FLG /><MAIL_CD>1</MAIL_CD><MAIL_CD_OVERRIDE_FLG /><EMAIL_CD>1</EMAIL_CD><EMAIL_CD_OVERRIDE_FLG /><LATITUDE /><LONGITUDE /><CONFIRM_YN>Y</CONFIRM_YN><CITY_CAPS>KEY BISCAYNE</CITY_CAPS><FIRM_NM>8808 Corporation</FIRM_NM><FIRM_NM_CAPS>8808 CORPORATION</FIRM_NM_CAPS><LAST_SALE_DT /><FIRM_TYPE_OVERRIDE_FLG>N</FIRM_TYPE_OVERRIDE_FLG></OFFICE></MarsOfficeDataSet>');
        syncMergeOffice = MARSApexGateway.SyncMergeOffice('123456', '123455', '', office1.Id, '<?xml version="1.0" encoding="utf-16"?><MarsOfficeDataSet xmlns="http://tempuri.org/MarsOffice.xsd"><OFFICE><OFFICE_ID>23219</OFFICE_ID><EXTERNAL_OFFICE_ID>'+office.Id+'</EXTERNAL_OFFICE_ID><FIRM_ID>23219</FIRM_ID><EXTERNAL_FIRM_ID>0019000001J8GfiAAF</EXTERNAL_FIRM_ID><OFFICE_NM>FL, Key Biscayne, 155 Ocean La</OFFICE_NM><OFFICE_NM_CAPS>FL, KEY BISCAYNE, 155 OCEAN LA</OFFICE_NM_CAPS><ADDR_ID>22823</ADDR_ID><ADDRESS1>155 Ocean Lane Dr # 913</ADDRESS1><ADDRESS2 /><ADDRESS3 /><ADDRESS4 /><CITY>Key Biscayne</CITY><STATE_ID>FL</STATE_ID><ZIP>33149</ZIP><COUNTRY_CD>US</COUNTRY_CD><PHONE>3053618808</PHONE><EXTENSION /><FAX /><STATUS_CD>Active</STATUS_CD><OFFICE_FIRM_TYPE>IT</OFFICE_FIRM_TYPE><ENTRY_DATE>5/4/2004 3:44:56 PM</ENTRY_DATE><ENTRY_USR>CONVERT </ENTRY_USR><UPDATE_DATE>7/13/2015 1:40:24 AM</UPDATE_DATE><UPDATE_USR>KMILLER </UPDATE_USR><OFFICE_MANAGER_ID /><NUMBER_OF_REPS>0</NUMBER_OF_REPS><TIMEZONE /><LAST_MEETING_DATE /><OFFICE_COMMENT /><STATUS_UPDATE_DATE>5/4/2004 4:04:36 PM</STATUS_UPDATE_DATE><NEW_OFFICE_FIRM_TYPE /><WEB_SITE /><HOME_OFF_FLAG>Y</HOME_OFF_FLAG><CALL_CD>1</CALL_CD><CALL_CD_OVERRIDE_FLG /><MAIL_CD>1</MAIL_CD><MAIL_CD_OVERRIDE_FLG /><EMAIL_CD>1</EMAIL_CD><EMAIL_CD_OVERRIDE_FLG /><LATITUDE /><LONGITUDE /><CONFIRM_YN>Y</CONFIRM_YN><CITY_CAPS>KEY BISCAYNE</CITY_CAPS><FIRM_NM>8808 Corporation</FIRM_NM><FIRM_NM_CAPS>8808 CORPORATION</FIRM_NM_CAPS><LAST_SALE_DT /><FIRM_TYPE_OVERRIDE_FLG>N</FIRM_TYPE_OVERRIDE_FLG></OFFICE></MarsOfficeDataSet>');
        syncMergeOffice = MARSApexGateway.SyncMergeOffice('123456', '123455', office.Id, office1.Id, '<?xml version="1.0" encoding="utf-16"?><MarsOfficeDataSet xmlns="http://tempuri.org/MarsOffice.xsd"><OFFICE><OFFICE_ID>23219</OFFICE_ID><EXTERNAL_OFFICE_ID>'+office.Id+'</EXTERNAL_OFFICE_ID><FIRM_ID>23219</FIRM_ID><EXTERNAL_FIRM_ID>0019000001J8GfiAAF</EXTERNAL_FIRM_ID><OFFICE_NM>FL, Key Biscayne, 155 Ocean La</OFFICE_NM><OFFICE_NM_CAPS>FL, KEY BISCAYNE, 155 OCEAN LA</OFFICE_NM_CAPS><ADDR_ID>22823</ADDR_ID><ADDRESS1>155 Ocean Lane Dr # 913</ADDRESS1><ADDRESS2 /><ADDRESS3 /><ADDRESS4 /><CITY>Key Biscayne</CITY><STATE_ID>FL</STATE_ID><ZIP>33149</ZIP><COUNTRY_CD>US</COUNTRY_CD><PHONE>3053618808</PHONE><EXTENSION /><FAX /><STATUS_CD>Active</STATUS_CD><OFFICE_FIRM_TYPE>IT</OFFICE_FIRM_TYPE><ENTRY_DATE>5/4/2004 3:44:56 PM</ENTRY_DATE><ENTRY_USR>CONVERT </ENTRY_USR><UPDATE_DATE>7/13/2015 1:40:24 AM</UPDATE_DATE><UPDATE_USR>KMILLER </UPDATE_USR><OFFICE_MANAGER_ID /><NUMBER_OF_REPS>0</NUMBER_OF_REPS><TIMEZONE /><LAST_MEETING_DATE /><OFFICE_COMMENT /><STATUS_UPDATE_DATE>5/4/2004 4:04:36 PM</STATUS_UPDATE_DATE><NEW_OFFICE_FIRM_TYPE /><WEB_SITE /><HOME_OFF_FLAG>Y</HOME_OFF_FLAG><CALL_CD>1</CALL_CD><CALL_CD_OVERRIDE_FLG /><MAIL_CD>1</MAIL_CD><MAIL_CD_OVERRIDE_FLG /><EMAIL_CD>1</EMAIL_CD><EMAIL_CD_OVERRIDE_FLG /><LATITUDE /><LONGITUDE /><CONFIRM_YN>Y</CONFIRM_YN><CITY_CAPS>KEY BISCAYNE</CITY_CAPS><FIRM_NM>8808 Corporation</FIRM_NM><FIRM_NM_CAPS>8808 CORPORATION</FIRM_NM_CAPS><LAST_SALE_DT /><FIRM_TYPE_OVERRIDE_FLG>N</FIRM_TYPE_OVERRIDE_FLG></OFFICE></MarsOfficeDataSet>');
        
       MARSApexGateway.ACK syncMergeRep=new MARSApexGateway.ACK();
        syncMergeRep = MARSApexGateway.SyncMergeRep('', '166666', rep.Id, '', '<?xml version="1.0" encoding="utf-16"?><MarsRepDataSet xmlns="http://tempuri.org/MarsRep1.xsd"><REP>  <REP_ID>63495</REP_ID>  <FIRM_ID>25607</FIRM_ID>  <OFF_ID>25705</OFF_ID>  <FIRST_NM>Rep</FIRST_NM>  <LAST_NM>1</LAST_NM>  <LAST_NM_CAPS>1</LAST_NM_CAPS>  <TITLE />  <SALUTATION />  <BIRTH_MMDD />  <BIRTH_YYYY />  <NICK_NM />  <SPOUSE_NM />  <PERSONAL_INFO />  <FIRST_SALE_DT />  <ASST_NM />  <SALES_STAT_CD>X</SALES_STAT_CD>  <LAST_SALE_DT />  <ORIG_CD />  <LAST_MTG_DT />  <LAST_CALL_DT />  <LAST_NOTE_DT>7/13/2015 1:47:24 AM</LAST_NOTE_DT>  <LAST_FULFILLMENT_DT />  <LAST_LETTER_DT />  <MAIL_LIST />  <ADDR1>6-3-832/2a</ADDR1>  <ADDR2 />  <ADDR3 />  <ADDR4 />  <CITY>Los Angeles</CITY>  <STATE_ID>CA</STATE_ID>  <ZIP>90001</ZIP>  <COUNTRY_CD>US</COUNTRY_CD>  <PRIM_PHONE>4159017010</PRIM_PHONE>  <PRIM_PHONE_EXT />  <PRIM_FAX>96852</PRIM_FAX>  <TIME_ZONE />  <REP_STAFF_CD>R</REP_STAFF_CD>  <STAT_CD>Active</STAT_CD>  <EMAIL_ID />  <EMAIL_ID2 />  <REP_COMMENT />  <PREFIX_NM />  <MIDDLE_NM />  <SUFFIX_NM />  <REP_FIRM_TYPE>IN</REP_FIRM_TYPE>  <STAT_UPD_DT>7/8/2015 2:55:46 AM</STAT_UPD_DT>  <ALLOW_MAILINGS>N</ALLOW_MAILINGS>  <FIRST_SALE_PROCESS_DT />  <HOUSE_REP>X</HOUSE_REP>  <EXTERNAL_REP_ID>'+ rep.Id+'</EXTERNAL_REP_ID>  <EXTERNAL_OFF_ID>'+office.Id+'</EXTERNAL_OFF_ID>  <EXTERNAL_FIRM_ID>0019000001QqQ2XAAV</EXTERNAL_FIRM_ID>  <ADDRESS_LOCKED>N</ADDRESS_LOCKED>  <ENTRY_USR>KMILLER </ENTRY_USR>  <ENTRY_DT>7/8/2015 2:55:11 AM</ENTRY_DT>  <UPD_USR>KMILLER </UPD_USR>  <UPD_DT>7/13/2015 1:47:24 AM</UPD_DT>  <CALL_CD>1</CALL_CD>  <CALL_CD_OVERRIDE_FLG />  <MAIL_CD>1</MAIL_CD>  <MAIL_CD_OVERRIDE_FLG />  <EMAIL_CD>1</EMAIL_CD>  <EMAIL_CD_OVERRIDE_FLG />  <CRD_ID />  <LATITUDE />  <LONGITUDE />  <DONOTCALL />  <DONOTMAIL />  <DONOTEMAIL />  <CONFIRM_YN>Y</CONFIRM_YN>  <RECORD_TYPE>I</RECORD_TYPE>  <SEARCH_STATE_ID>CA</SEARCH_STATE_ID>  <SEARCH_COUNTRY_CD>US</SEARCH_COUNTRY_CD>  <SEARCH_PRIM_PHONE>4159017010          </SEARCH_PRIM_PHONE>  <SEARCH_TIME_ZONE />  <SEARCH_ZIP>90001</SEARCH_ZIP>  <SEARCH_CITY>LOS ANGELES</SEARCH_CITY>  <FIRST_NM_CAPS>REP</FIRST_NM_CAPS>  <REP_REGISTRATION />  <FIRM_TYPE_OVERRIDE_FLG>N</FIRM_TYPE_OVERRIDE_FLG></REP></MarsRepDataSet>');
        //syncMergeRep = MARSApexGateway.SyncMergeRep('155555', '', '', rep1.Id, '<?xml version="1.0" encoding="utf-16"?><MarsRepDataSet xmlns="http://tempuri.org/MarsRep1.xsd"><REP>  <REP_ID>63495</REP_ID>  <FIRM_ID>25607</FIRM_ID>  <OFF_ID>25705</OFF_ID>  <FIRST_NM>Rep</FIRST_NM>  <LAST_NM>1</LAST_NM>  <LAST_NM_CAPS>1</LAST_NM_CAPS>  <TITLE />  <SALUTATION />  <BIRTH_MMDD />  <BIRTH_YYYY />  <NICK_NM />  <SPOUSE_NM />  <PERSONAL_INFO />  <FIRST_SALE_DT />  <ASST_NM />  <SALES_STAT_CD>X</SALES_STAT_CD>  <LAST_SALE_DT />  <ORIG_CD />  <LAST_MTG_DT />  <LAST_CALL_DT />  <LAST_NOTE_DT>7/13/2015 1:47:24 AM</LAST_NOTE_DT>  <LAST_FULFILLMENT_DT />  <LAST_LETTER_DT />  <MAIL_LIST />  <ADDR1>6-3-832/2a</ADDR1>  <ADDR2 />  <ADDR3 />  <ADDR4 />  <CITY>Los Angeles</CITY>  <STATE_ID>CA</STATE_ID>  <ZIP>90001</ZIP>  <COUNTRY_CD>US</COUNTRY_CD>  <PRIM_PHONE>4159017010</PRIM_PHONE>  <PRIM_PHONE_EXT />  <PRIM_FAX>96852</PRIM_FAX>  <TIME_ZONE />  <REP_STAFF_CD>R</REP_STAFF_CD>  <STAT_CD>Active</STAT_CD>  <EMAIL_ID />  <EMAIL_ID2 />  <REP_COMMENT />  <PREFIX_NM />  <MIDDLE_NM />  <SUFFIX_NM />  <REP_FIRM_TYPE>IN</REP_FIRM_TYPE>  <STAT_UPD_DT>7/8/2015 2:55:46 AM</STAT_UPD_DT>  <ALLOW_MAILINGS>N</ALLOW_MAILINGS>  <FIRST_SALE_PROCESS_DT />  <HOUSE_REP>X</HOUSE_REP>  <EXTERNAL_REP_ID>'+ rep.Id+'</EXTERNAL_REP_ID>  <EXTERNAL_OFF_ID>'+office.Id+'</EXTERNAL_OFF_ID>  <EXTERNAL_FIRM_ID>0019000001QqQ2XAAV</EXTERNAL_FIRM_ID>  <ADDRESS_LOCKED>N</ADDRESS_LOCKED>  <ENTRY_USR>KMILLER </ENTRY_USR>  <ENTRY_DT>7/8/2015 2:55:11 AM</ENTRY_DT>  <UPD_USR>KMILLER </UPD_USR>  <UPD_DT>7/13/2015 1:47:24 AM</UPD_DT>  <CALL_CD>1</CALL_CD>  <CALL_CD_OVERRIDE_FLG />  <MAIL_CD>1</MAIL_CD>  <MAIL_CD_OVERRIDE_FLG />  <EMAIL_CD>1</EMAIL_CD>  <EMAIL_CD_OVERRIDE_FLG />  <CRD_ID />  <LATITUDE />  <LONGITUDE />  <DONOTCALL />  <DONOTMAIL />  <DONOTEMAIL />  <CONFIRM_YN>Y</CONFIRM_YN>  <RECORD_TYPE>I</RECORD_TYPE>  <SEARCH_STATE_ID>CA</SEARCH_STATE_ID>  <SEARCH_COUNTRY_CD>US</SEARCH_COUNTRY_CD>  <SEARCH_PRIM_PHONE>4159017010          </SEARCH_PRIM_PHONE>  <SEARCH_TIME_ZONE />  <SEARCH_ZIP>90001</SEARCH_ZIP>  <SEARCH_CITY>LOS ANGELES</SEARCH_CITY>  <FIRST_NM_CAPS>REP</FIRST_NM_CAPS>  <REP_REGISTRATION />  <FIRM_TYPE_OVERRIDE_FLG>N</FIRM_TYPE_OVERRIDE_FLG></REP></MarsRepDataSet>');
        syncMergeRep = MARSApexGateway.SyncMergeRep('155555', '166666', rep.Id, rep1.Id, '<?xml version="1.0" encoding="utf-16"?><MarsRepDataSet xmlns="http://tempuri.org/MarsRep1.xsd"><REP>  <REP_ID>63495</REP_ID>  <FIRM_ID>25607</FIRM_ID>  <OFF_ID>25705</OFF_ID>  <FIRST_NM>Rep</FIRST_NM>  <LAST_NM>1</LAST_NM>  <LAST_NM_CAPS>1</LAST_NM_CAPS>  <TITLE />  <SALUTATION />  <BIRTH_MMDD />  <BIRTH_YYYY />  <NICK_NM />  <SPOUSE_NM />  <PERSONAL_INFO />  <FIRST_SALE_DT />  <ASST_NM />  <SALES_STAT_CD>X</SALES_STAT_CD>  <LAST_SALE_DT />  <ORIG_CD />  <LAST_MTG_DT />  <LAST_CALL_DT />  <LAST_NOTE_DT>7/13/2015 1:47:24 AM</LAST_NOTE_DT>  <LAST_FULFILLMENT_DT />  <LAST_LETTER_DT />  <MAIL_LIST />  <ADDR1>6-3-832/2a</ADDR1>  <ADDR2 />  <ADDR3 />  <ADDR4 />  <CITY>Los Angeles</CITY>  <STATE_ID>CA</STATE_ID>  <ZIP>90001</ZIP>  <COUNTRY_CD>US</COUNTRY_CD>  <PRIM_PHONE>4159017010</PRIM_PHONE>  <PRIM_PHONE_EXT />  <PRIM_FAX>96852</PRIM_FAX>  <TIME_ZONE />  <REP_STAFF_CD>R</REP_STAFF_CD>  <STAT_CD>Active</STAT_CD>  <EMAIL_ID />  <EMAIL_ID2 />  <REP_COMMENT />  <PREFIX_NM />  <MIDDLE_NM />  <SUFFIX_NM />  <REP_FIRM_TYPE>IN</REP_FIRM_TYPE>  <STAT_UPD_DT>7/8/2015 2:55:46 AM</STAT_UPD_DT>  <ALLOW_MAILINGS>N</ALLOW_MAILINGS>  <FIRST_SALE_PROCESS_DT />  <HOUSE_REP>X</HOUSE_REP>  <EXTERNAL_REP_ID>'+ rep.Id+'</EXTERNAL_REP_ID>  <EXTERNAL_OFF_ID>'+office.Id+'</EXTERNAL_OFF_ID>  <EXTERNAL_FIRM_ID>0019000001QqQ2XAAV</EXTERNAL_FIRM_ID>  <ADDRESS_LOCKED>N</ADDRESS_LOCKED>  <ENTRY_USR>KMILLER </ENTRY_USR>  <ENTRY_DT>7/8/2015 2:55:11 AM</ENTRY_DT>  <UPD_USR>KMILLER </UPD_USR>  <UPD_DT>7/13/2015 1:47:24 AM</UPD_DT>  <CALL_CD>1</CALL_CD>  <CALL_CD_OVERRIDE_FLG />  <MAIL_CD>1</MAIL_CD>  <MAIL_CD_OVERRIDE_FLG />  <EMAIL_CD>1</EMAIL_CD>  <EMAIL_CD_OVERRIDE_FLG />  <CRD_ID />  <LATITUDE />  <LONGITUDE />  <DONOTCALL />  <DONOTMAIL />  <DONOTEMAIL />  <CONFIRM_YN>Y</CONFIRM_YN>  <RECORD_TYPE>I</RECORD_TYPE>  <SEARCH_STATE_ID>CA</SEARCH_STATE_ID>  <SEARCH_COUNTRY_CD>US</SEARCH_COUNTRY_CD>  <SEARCH_PRIM_PHONE>4159017010          </SEARCH_PRIM_PHONE>  <SEARCH_TIME_ZONE />  <SEARCH_ZIP>90001</SEARCH_ZIP>  <SEARCH_CITY>LOS ANGELES</SEARCH_CITY>  <FIRST_NM_CAPS>REP</FIRST_NM_CAPS>  <REP_REGISTRATION />  <FIRM_TYPE_OVERRIDE_FLG>N</FIRM_TYPE_OVERRIDE_FLG></REP></MarsRepDataSet>');
       
        MARSApexGateway.ACK syncMoveOffice=new MARSApexGateway.ACK();
        syncMoveOffice = MARSApexGateway.SyncMoveOffice('123456', '123485', '', '', '');
        syncMoveOffice = MARSApexGateway.SyncMoveOffice('', '123485', '', '', '<?xml version="1.0" encoding="utf-16"?><MarsOfficeDataSet xmlns="http://tempuri.org/MarsOffice.xsd"><OFFICE><OFFICE_ID>23219</OFFICE_ID><EXTERNAL_OFFICE_ID>'+office2.Id+'</EXTERNAL_OFFICE_ID><FIRM_ID>23219</FIRM_ID><EXTERNAL_FIRM_ID>0019000001J8GfiAAF</EXTERNAL_FIRM_ID><OFFICE_NM>FL, Key Biscayne, 155 Ocean La</OFFICE_NM><OFFICE_NM_CAPS>FL, KEY BISCAYNE, 155 OCEAN LA</OFFICE_NM_CAPS><ADDR_ID>22823</ADDR_ID><ADDRESS1>155 Ocean Lane Dr # 913</ADDRESS1><ADDRESS2 /><ADDRESS3 /><ADDRESS4 /><CITY>Key Biscayne</CITY><STATE_ID>FL</STATE_ID><ZIP>33149</ZIP><COUNTRY_CD>US</COUNTRY_CD><PHONE>3053618808</PHONE><EXTENSION /><FAX /><STATUS_CD>Active</STATUS_CD><OFFICE_FIRM_TYPE>IT</OFFICE_FIRM_TYPE><ENTRY_DATE>5/4/2004 3:44:56 PM</ENTRY_DATE><ENTRY_USR>CONVERT </ENTRY_USR><UPDATE_DATE>7/13/2015 1:40:24 AM</UPDATE_DATE><UPDATE_USR>KMILLER </UPDATE_USR><OFFICE_MANAGER_ID /><NUMBER_OF_REPS>0</NUMBER_OF_REPS><TIMEZONE /><LAST_MEETING_DATE /><OFFICE_COMMENT /><STATUS_UPDATE_DATE>5/4/2004 4:04:36 PM</STATUS_UPDATE_DATE><NEW_OFFICE_FIRM_TYPE /><WEB_SITE /><HOME_OFF_FLAG>Y</HOME_OFF_FLAG><CALL_CD>1</CALL_CD><CALL_CD_OVERRIDE_FLG /><MAIL_CD>1</MAIL_CD><MAIL_CD_OVERRIDE_FLG /><EMAIL_CD>1</EMAIL_CD><EMAIL_CD_OVERRIDE_FLG /><LATITUDE /><LONGITUDE /><CONFIRM_YN>Y</CONFIRM_YN><CITY_CAPS>KEY BISCAYNE</CITY_CAPS><FIRM_NM>8808 Corporation</FIRM_NM><FIRM_NM_CAPS>8808 CORPORATION</FIRM_NM_CAPS><LAST_SALE_DT /><FIRM_TYPE_OVERRIDE_FLG>N</FIRM_TYPE_OVERRIDE_FLG></OFFICE></MarsOfficeDataSet>');
        syncMoveOffice = MARSApexGateway.SyncMoveOffice('123456', '', '', '', '<?xml version="1.0" encoding="utf-16"?><MarsOfficeDataSet xmlns="http://tempuri.org/MarsOffice.xsd"><OFFICE><OFFICE_ID>23219</OFFICE_ID><EXTERNAL_OFFICE_ID>'+office2.Id+'</EXTERNAL_OFFICE_ID><FIRM_ID>23219</FIRM_ID><EXTERNAL_FIRM_ID>0019000001J8GfiAAF</EXTERNAL_FIRM_ID><OFFICE_NM>FL, Key Biscayne, 155 Ocean La</OFFICE_NM><OFFICE_NM_CAPS>FL, KEY BISCAYNE, 155 OCEAN LA</OFFICE_NM_CAPS><ADDR_ID>22823</ADDR_ID><ADDRESS1>155 Ocean Lane Dr # 913</ADDRESS1><ADDRESS2 /><ADDRESS3 /><ADDRESS4 /><CITY>Key Biscayne</CITY><STATE_ID>FL</STATE_ID><ZIP>33149</ZIP><COUNTRY_CD>US</COUNTRY_CD><PHONE>3053618808</PHONE><EXTENSION /><FAX /><STATUS_CD>Active</STATUS_CD><OFFICE_FIRM_TYPE>IT</OFFICE_FIRM_TYPE><ENTRY_DATE>5/4/2004 3:44:56 PM</ENTRY_DATE><ENTRY_USR>CONVERT </ENTRY_USR><UPDATE_DATE>7/13/2015 1:40:24 AM</UPDATE_DATE><UPDATE_USR>KMILLER </UPDATE_USR><OFFICE_MANAGER_ID /><NUMBER_OF_REPS>0</NUMBER_OF_REPS><TIMEZONE /><LAST_MEETING_DATE /><OFFICE_COMMENT /><STATUS_UPDATE_DATE>5/4/2004 4:04:36 PM</STATUS_UPDATE_DATE><NEW_OFFICE_FIRM_TYPE /><WEB_SITE /><HOME_OFF_FLAG>Y</HOME_OFF_FLAG><CALL_CD>1</CALL_CD><CALL_CD_OVERRIDE_FLG /><MAIL_CD>1</MAIL_CD><MAIL_CD_OVERRIDE_FLG /><EMAIL_CD>1</EMAIL_CD><EMAIL_CD_OVERRIDE_FLG /><LATITUDE /><LONGITUDE /><CONFIRM_YN>Y</CONFIRM_YN><CITY_CAPS>KEY BISCAYNE</CITY_CAPS><FIRM_NM>8808 Corporation</FIRM_NM><FIRM_NM_CAPS>8808 CORPORATION</FIRM_NM_CAPS><LAST_SALE_DT /><FIRM_TYPE_OVERRIDE_FLG>N</FIRM_TYPE_OVERRIDE_FLG></OFFICE></MarsOfficeDataSet>');
        syncMoveOffice = MARSApexGateway.SyncMoveOffice('123456', '123485', '', office1.Id, '<?xml version="1.0" encoding="utf-16"?><MarsOfficeDataSet xmlns="http://tempuri.org/MarsOffice.xsd"><OFFICE><OFFICE_ID>12345645</OFFICE_ID><EXTERNAL_OFFICE_ID>'+office2.Id+'</EXTERNAL_OFFICE_ID><FIRM_ID>23219</FIRM_ID><EXTERNAL_FIRM_ID>0019000001J8GfiAAF</EXTERNAL_FIRM_ID><OFFICE_NM>FL, Key Biscayne, 155 Ocean La</OFFICE_NM><OFFICE_NM_CAPS>FL, KEY BISCAYNE, 155 OCEAN LA</OFFICE_NM_CAPS><ADDR_ID>22823</ADDR_ID><ADDRESS1>155 Ocean Lane Dr # 913</ADDRESS1><ADDRESS2 /><ADDRESS3 /><ADDRESS4 /><CITY>Key Biscayne</CITY><STATE_ID>FL</STATE_ID><ZIP>33149</ZIP><COUNTRY_CD>US</COUNTRY_CD><PHONE>3053618808</PHONE><EXTENSION /><FAX /><STATUS_CD>Active</STATUS_CD><OFFICE_FIRM_TYPE>IT</OFFICE_FIRM_TYPE><ENTRY_DATE>5/4/2004 3:44:56 PM</ENTRY_DATE><ENTRY_USR>CONVERT </ENTRY_USR><UPDATE_DATE>7/13/2015 1:40:24 AM</UPDATE_DATE><UPDATE_USR>KMILLER </UPDATE_USR><OFFICE_MANAGER_ID /><NUMBER_OF_REPS>0</NUMBER_OF_REPS><TIMEZONE /><LAST_MEETING_DATE /><OFFICE_COMMENT /><STATUS_UPDATE_DATE>5/4/2004 4:04:36 PM</STATUS_UPDATE_DATE><NEW_OFFICE_FIRM_TYPE /><WEB_SITE /><HOME_OFF_FLAG>Y</HOME_OFF_FLAG><CALL_CD>1</CALL_CD><CALL_CD_OVERRIDE_FLG /><MAIL_CD>1</MAIL_CD><MAIL_CD_OVERRIDE_FLG /><EMAIL_CD>1</EMAIL_CD><EMAIL_CD_OVERRIDE_FLG /><LATITUDE /><LONGITUDE /><CONFIRM_YN>Y</CONFIRM_YN><CITY_CAPS>KEY BISCAYNE</CITY_CAPS><FIRM_NM>8808 Corporation</FIRM_NM><FIRM_NM_CAPS>8808 CORPORATION</FIRM_NM_CAPS><LAST_SALE_DT /><FIRM_TYPE_OVERRIDE_FLG>N</FIRM_TYPE_OVERRIDE_FLG></OFFICE></MarsOfficeDataSet>');
        
        MARSApexGateway.ACK syncRep=new MARSApexGateway.ACK();

        syncRep=MARSApexGateway.SyncMoveRep('<?xml version="1.0" encoding="utf-16"?><MarsRepDataSet xmlns="http://tempuri.org/MarsRep1.xsd"><REP><REP_ID>122252</REP_ID><FIRM_ID>1</FIRM_ID><OFF_ID>abcd</OFF_ID><FIRST_NM>Test With more than 40 characters</FIRST_NM><LAST_NM>PETERSON</LAST_NM><LAST_NM_CAPS>PETERSON</LAST_NM_CAPS><TITLE /><SALUTATION /><BIRTH_MMDD>1010</BIRTH_MMDD><BIRTH_YYYY>1989</BIRTH_YYYY><NICK_NM /><SPOUSE_NM /><PERSONAL_INFO /><FIRST_SALE_DT>1/26/2011 12:00:00 AM</FIRST_SALE_DT><ASST_NM /><SALES_STAT_CD>X</SALES_STAT_CD><LAST_SALE_DT>1/28/2011 12:00:00 AM</LAST_SALE_DT><ORIG_CD /><LAST_MTG_DT>1/28/2011 12:00:00 AM</LAST_MTG_DT><LAST_CALL_DT /><LAST_NOTE_DT /><LAST_FULFILLMENT_DT /><LAST_LETTER_DT /><MAIL_LIST /><ADDR1>234 Elmount St</ADDR1><ADDR2>234</ADDR2><ADDR3>Elmount </ADDR3><ADDR4>Elmount St</ADDR4><CITY>Elk Grove Village</CITY><STATE_ID>IL</STATE_ID><ZIP>60009</ZIP><COUNTRY_CD>US</COUNTRY_CD><PRIM_PHONE>8745685689</PRIM_PHONE><PRIM_PHONE_EXT /><PRIM_FAX /><TIME_ZONE /><REP_STAFF_CD>R</REP_STAFF_CD><STAT_CD>A </STAT_CD><EMAIL_ID>kcshekhar121@gmail.com</EMAIL_ID><EMAIL_ID2 /><REP_COMMENT /><PREFIX_NM>null</PREFIX_NM><MIDDLE_NM /><SUFFIX_NM /><REP_FIRM_TYPE>IN</REP_FIRM_TYPE><STAT_UPD_DT>1/26/2011 6:04:00 PM</STAT_UPD_DT><ALLOW_MAILINGS>N</ALLOW_MAILINGS><FIRST_SALE_PROCESS_DT>1/26/2011 12:00:00 AM</FIRST_SALE_PROCESS_DT><HOUSE_REP>X</HOUSE_REP><EXTERNAL_REP_ID /><EXTERNAL_OFF_ID></EXTERNAL_OFF_ID><EXTERNAL_FIRM_ID>752</EXTERNAL_FIRM_ID><ADDRESS_LOCKED>N</ADDRESS_LOCKED><ENTRY_USR>KMILLER </ENTRY_USR><ENTRY_DT>1/26/2011 6:02:38 PM</ENTRY_DT><UPD_USR>SYSTEM  </UPD_USR><UPD_DT>8/6/2013 7:00:39 PM</UPD_DT><CALL_CD>1</CALL_CD><CALL_CD_OVERRIDE_FLG /><MAIL_CD>1</MAIL_CD><MAIL_CD_OVERRIDE_FLG /><EMAIL_CD>1</EMAIL_CD><EMAIL_CD_OVERRIDE_FLG /><CRD_ID /><LATITUDE /><LONGITUDE /><DONOTCALL /><DONOTMAIL /><DONOTEMAIL /><CONFIRM_YN>Y</CONFIRM_YN><RECORD_TYPE>R</RECORD_TYPE><SEARCH_STATE_ID>IL</SEARCH_STATE_ID><SEARCH_COUNTRY_CD>US</SEARCH_COUNTRY_CD><SEARCH_PRIM_PHONE>8745685689          </SEARCH_PRIM_PHONE><SEARCH_TIME_ZONE /><SEARCH_ZIP>60009</SEARCH_ZIP><SEARCH_CITY>ELK GROVE VILLAGE</SEARCH_CITY><FIRST_NM_CAPS>KRIS</FIRST_NM_CAPS><REP_REGISTRATION /></REP></MarsRepDataSet>','6535');
        syncRep=MARSApexGateway.SyncMoveRep('', '6535');
        //syncRep=MARSApexGateway.SyncMoveRep('<?xml version="1.0" encoding="utf-16"?><MarsRepDataSet xmlns="http://tempuri.org/MarsRep1.xsd"><REP></REP></MarsRepDataSet>','');
        
        
        List<MARSApexGateway.ACK> syncDeleteOfficeRep=new List<MARSApexGateway.ACK>();
        syncDeleteOfficeRep=MARSApexGateway.SyncDelete('<MarsDataset><Rep><REP_ID>166666</REP_ID><EXTERNAL_ID>'+rep.Id+'</EXTERNAL_ID></Rep><Rep><REP_ID>166666</REP_ID><EXTERNAL_ID></EXTERNAL_ID></Rep><Rep><REP_ID>166666</REP_ID><SFDC_ID></SFDC_ID></Rep></MarsDataset>');
        syncDeleteOfficeRep=MARSApexGateway.SyncDelete('<MarsDataset><Office><OFF_ID>123456</OFF_ID><EXTERNAL_ID></EXTERNAL_ID></Office><Office><OFF_ID>123456</OFF_ID><EXTERNAL_ID>'+office.Id+'</EXTERNAL_ID></Office></MarsDataset>');
        syncDeleteOfficeRep=MARSApexGateway.SyncDelete('<MarsDataset><TeamRep><TEAM_REP_ID>166666</TEAM_REP_ID><REP_ID>155555</REP_ID><EXTERNAL_ID>'+teamRep.Id+'</EXTERNAL_ID></TeamRep></MarsDataset>');
        
        List<MARSApexGateway.ACK> syncFirmType=new List<MARSApexGateway.ACK>();
        syncFirmType=MARSApexGateway.SyncFirmType('<MarsDataset xmlns="http://tempuri.org/MarsFirmType.xsd"><FIRM_TYPE><CODE>BK</CODE><DESCRIPTION>Bank Broker Dealer</DESCRIPTION></FIRM_TYPE><FIRM_TYPE><CODE>BK</CODE><DESCRIPTION>Bank Broker Dealer</DESCRIPTION></FIRM_TYPE></MarsDataset>');
        syncFirmType=MARSApexGateway.SyncFirmType('');
        
        Test.stopTest(); 
        
    }
     
    
}