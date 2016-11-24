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
private class Test_MARSMISGateway {

    @testSetup static void setupCommonData(){
        
    }
    
     /*private static testMethod void constantsTest() {
    
            //Custom Setting to hold the Credentials
            MARSDefaults__c marsDefaults = new MARSDefaults__c(MARSPassword__c = 'mars', MARSUser__c = 'KMILLER',IntegrationType__c=1,bulkLoadEnabled__c = true, DeleteMARSBatchDataPeriod__c=30, RetryDuration__c=15, MARSEndpointUrl__c='https:\\salesforce.com');
            insert marsDefaults;
        
            //Test start from here
            Test.startTest();
            
            //populate the getter variable with custom setting with values
            MarsUtility.MARS_DEFAULTS = marsDefaults;
            
            
            //Assert for results
            System.assert(MarsUtility.MARS_DEFAULTS != null);
            
            //populate the getter variable with custom setting with values
            MarsUtility.MARS_DEFAULTS = new MARSDefaults__c();
            

            //Test stop here
            Test.stopTest();    
    }*/
    static testMethod void bulkFirmTest() {
        
        List<Account> lstAccount=new List<Account>();
        
        Account firm=new Account();
        firm.Name='Test Office in TestFirm Controller';
        //firm.MarsFirmId__c=1111111;
        firm.BillingStreet='8014 Midlothian Tpke';
        firm.BillingCity='Richmond';
        firm.BillingStateCode='VA';
        firm.BillingCountry='United States';
        firm.BillingPostalCode='90001';
        firm.BillingCountryCode='US';
        firm.MarsFirmType__c ='BD';
        firm.Phone='950250586012345';
        firm.RecordTypeId=MarsUtility.AccountRecordType;
        firm.SfdcLastUpdateType__c = 'F';
        firm.MarsFirmStatUpdDt__c=Datetime.now();
        firm.MarsCrdId__c='A01';
        firm.SfdcLastActionFrom__c='F';
        
        lstAccount.add(firm);
        
        Account firm1=new Account();
        firm1.Name='Test Office in TestFirm Controller';
        firm1.MarsFirmNm__c='Test Firm In TestFirm Controller';
       // firm1.MarsFirmId__c=1111112;
        firm1.BillingStreet='8014 Midlothian Tpke';
        firm1.BillingCity='Richmond';
        firm1.BillingStateCode='VA';
        firm1.MarsFirmType__c ='BD';
        firm1.Phone='9502505860X1234';
        firm1.RecordTypeId=MarsUtility.AccountRecordType;
        firm1.BillingCountry='United States';
        firm1.BillingCountryCode='US';
        firm1.BillingPostalCode='90001';
        firm1.SfdcLastUpdateType__c = 'F';
        firm1.MarsFirmStatUpdDt__c=Datetime.now();
        firm1.MarsCrdId__c='B01';
        firm1.SfdcLastActionFrom__c='F';
        
        lstAccount.add(firm1);
        
        MarsUtility.BYPASS_ALL_TRIGGER=true;
        insert lstAccount;
        MarsUtility.BYPASS_ALL_TRIGGER=false;
        
         MarsBatchRetryBulkData firmInsertRetry=new MarsBatchRetryBulkData();
        //Set Mock Callout class 
        Test.setMock(WebServiceMock.class, new Mock_FirmController()); 
        //Execute Batch 
        Database.executeBatch(firmInsertRetry, 10); 
        
        update lstAccount;
        
    }
    static testMethod void bulkOfficeTest() {
        
        List<Account> lstAccount=new List<Account>();
        
        Account firm=new Account();
        firm.Name='Test Office in TestFirm Controller';
       // firm.MarsFirmId__c=1111111;
        firm.BillingStreet='8014 Midlothian Tpke \n 8014 Midlothian Tpke \n 8014 Midlothian Tpke \n 8014 Midlothian Tpke \n ';
        firm.BillingCity='Richmond';
        firm.BillingState='Virginia';
        firm.BillingStateCode='VA';
        firm.MarsFirmType__c ='BD';
        firm.RecordTypeId=MarsUtility.AccountRecordType;
        firm.BillingCountry='United States';
        firm.BillingCountryCode='US';
        firm.BillingPostalCode='90001';
        firm.SfdcLastUpdateType__c = 'F';
        firm.MarsFirmStatUpdDt__c=Datetime.now();
        firm.SfdcLastActionFrom__c='F';
        MarsUtility.BYPASS_VALIDATION=true;
        insert firm;
        MarsUtility.BYPASS_VALIDATION=false;
        
        MARSFirmSummary__c firmsummary =new MARSFirmSummary__c();
        firmsummary.Name='Test Office in TestFirm Controller';
        firmsummary.SfdcFirmId__c =firm.ID;
        firmsummary.MarsFirmType__c = firm.MarsFirmType__c;
        insert firmsummary;
        
        MarsUtility.BYPASS_ALL_TRIGGER=true;
        firm.SFDCFirmSumId__c = firmsummary.Id;
        MarsUtility.BYPASS_ALL_TRIGGER=false;
        
        Account office=new Account();
        office.Name='Richmond Office MARSMISGateway Cls';
        office.MarsFirmNm__c='Test Firm In TestFirm Controller';
        office.ParentId=firm.Id;
        //office.MarsOfficeId__c=1111111;
        office.BillingStreet='8014 Midlothian Tpke';
        office.BillingCity='Richmond';
        office.RecordTypeId=MarsUtility.AccountRecordType;
        office.BillingState='Virginia';
        office.BillingStateCode='VA';
        office.BillingCountry='United States';
        office.BillingCountryCode='US';
        office.BillingPostalCode='90001';
        office.SfdcLastUpdateType__c = 'O';
        office.MarsFirmStatUpdDt__c=Datetime.now();
        
        lstAccount.add(office);
        
        Account office1=new Account();
        office1.Name='Test Office MARSMISGateway Cls';
        office1.MarsFirmNm__c='Test office In Testoffice Controller';
        office1.ParentId=firm.Id;
        //office1.MarsOfficeId__c=1111112;
        office1.BillingStreet='8014 Midlothian Tpke';
        office1.BillingCity='Richmond';
        office1.RecordTypeId=MarsUtility.AccountRecordType;
        office1.BillingState='Virginia';
        office1.BillingStateCode='VA';
        office1.BillingCountry='United States';
        office1.BillingCountryCode='US';
        office1.BillingPostalCode='90001';
        office1.SfdcLastUpdateType__c = 'O';
        office1.MarsFirmStatUpdDt__c=Datetime.now();
        
        lstAccount.add(office1);
        
        insert lstAccount;
        
        Test.startTest();
        
        MarsBatchRetryBulkData officeInsertRetry=new MarsBatchRetryBulkData();
        
        //Set Mock Callout class 
        Test.setMock(WebServiceMock.class, new Mock_OfficeController());
        
        //Execute Batch 
        Database.executeBatch(officeInsertRetry, 10); 
        
        
        update lstAccount;
        
        
        Test.stopTest();
        
    }
    
    static testMethod void bulkrepTest() {
        List<Contact> lstContact=new List<Contact>();
        
        Account firm=new Account();
        firm.Name='Test Office in TestFirm Controller';
        //firm.MarsFirmId__c=1111111;
        firm.BillingStreet='8014 Midlothian Tpke \n 8014 Midlothian Tpke \n 8014 Midlothian Tpke \n';
        firm.BillingCity='Richmond';
        firm.BillingState='Virginia';
        firm.BillingStateCode='VA';
        firm.MarsFirmType__c ='BD';
        firm.RecordTypeId=MarsUtility.AccountRecordType;
        firm.BillingCountry='United States';
        firm.BillingCountryCode='US';
        firm.BillingPostalCode='90001';
        firm.SfdcLastUpdateType__c = 'F';
        firm.MarsFirmStatUpdDt__c=Datetime.now();
        firm.SfdcLastActionFrom__c='F';
        
        MarsUtility.BYPASS_VALIDATION =true;
        insert firm;
        MarsUtility.BYPASS_VALIDATION =false;
        
        Contact rep=new Contact();
        rep.FirstName='Rep';
        //rep.MarsRepId__c=155555;
        rep.Phone='950250586';
        rep.AccountId=firm.Id;
        rep.RecordTypeId=MarsUtility.ContactRecordType;
        rep.Birthdate=Date.valueOf('1966-1-24');
        rep.LastName='In Test_MarsApexGateway Class';
        rep.MailingStreet='8014 Midlothian Tpke \n 8014 Midlothian Tpke \n 8014 Midlothian Tpke \n';
        rep.MailingState='Virginia';
        rep.MailingStateCode='VA';
        rep.MailingPostalCode='90001';
        rep.MailingCity='Richmo';
        rep.MailingCountry='United States';
        rep.MailingCountryCode='US';
        rep.MarsFirmId__c=1222222;
        rep.MarsAddrLock__c='N';
        
        lstContact.add(rep);
        
        Contact rep1=new Contact();
        rep1.FirstName='Rep';
        //rep1.MarsRepId__c=155556;
        rep1.Phone='9502505860-1234';
        rep1.AccountId=firm.Id;
        rep1.RecordTypeId=MarsUtility.ContactRecordType;
        rep1.LastName='In Test_MarsApexGateway Class';
        rep1.MailingStreet='8014 Midlothian Tpke,8014 Midlothian Tpke';
        rep1.MailingState='Virginia';
        rep1.MailingStateCode='VA';
        rep1.MailingCity='Richmond';
        rep1.MailingCountry='United States';
        rep1.MailingCountryCode='US';
        rep1.MailingPostalCode='90001';
        rep1.MarsFirmId__c=1222222;
        
        lstContact.add(rep1);
        
        insert lstContact;
        
        System.debug(':Being:');
        
     /*   MARSBatchDataStore__c batchRepInsertData=new MARSBatchDataStore__c();
        batchRepInsertData.OperationType__c='REP_INSERT';
        batchRepInsertData.NoOfRetry__c=2;
        batchRepInsertData.SfdcContactId__c=rep.Id;
        
        insert batchRepInsertData;*/  
        
        
        
        Test.startTest();
        
        
        MarsBatchRetryBulkData repRetry=new MarsBatchRetryBulkData();
        //Set Mock Callout class 
        Test.setMock(WebServiceMock.class, new Mock_RepController());
        //Execute Batch 
        Database.executeBatch(repRetry, 10);
        
        System.debug(':End:');
        
        List<Contact> updContact=new List<Contact>();
        for(Contact con:lstContact){
            contact c=new Contact(Id=con.Id,FirstName='',LastName='Test_MarsApexGateway');
            updContact.add(c);
        }
        if(!updContact.isEmpty())
        {
            update updContact;
        }

        MarsBatchRetryBulkData repupdateRetry=new MarsBatchRetryBulkData();
        //Set Mock Callout class 
        Test.setMock(WebServiceMock.class, new Mock_RepController());
        
        //Execute Batch 
        Database.executeBatch(repupdateRetry, 10);
        
        
       /* Test.setMock(WebServiceMock.class, new Mock_MarsBatchProcessMerge()); 
        DataBase.executeBatch(new MarsBatchProcessMerge(new List<Account>{firm},updContact,'12345'));
        DataBase.executeBatch(new MarsBatchProcessMerge(new List<Account>{firm},new List<Contact>(),'12345'));*/
        
        
        Test.stopTest();
        //delete lstContact;
    }
    /*static testMethod void officeTest() {
        
        Account firm=new Account();
        firm.Name='Test Office in TestFirm Controller';
        firm.MarsFirmNm__c='Test Firm In TestFirm Controller';
        firm.MarsFirmId__c=1111111;
        firm.Phone='9502505860';
        firm.MarsFirmType__c ='BD';
        firm.RecordTypeId=MarsUtility.AccountRecordType;
        firm.BillingStreet='8014 Midlothian Tpke,1 Tower Bridge 100 Front St,8014 Midlothian Tpke,1 Tower Bridge 100 Front St,8014 Midlothian Tpke';
        firm.BillingCity='Richmond';
        firm.BillingState='Virginia';
        firm.BillingCountry='United States';
        firm.BillingPostalCode='90001';
        firm.SfdcLastUpdateType__c = 'F';
        firm.MarsFirmStatUpdDt__c=Datetime.now();
        firm.SfdcLastActionFrom__c='F';

        insert firm;
        
        
        Account firm1=new Account();
        firm1.Name='Test Office in TestFirm Controller';
        firm1.MarsFirmNm__c='Test Firm In TestFirm Controller';
        firm1.MarsFirmId__c=1111116;
        firm1.Phone='9502505860';
        firm1.RecordTypeId=MarsUtility.AccountRecordType;
        firm1.MarsFirmType__c ='BD';
        firm1.BillingStreet='8014 Midlothian Tpke,1 Tower Bridge 100 Front St,8014 Midlothian Tpke,1 Tower Bridge 100 Front St,8014 Midlothian Tpke';
        firm1.BillingCity='Richmond';
        firm1.BillingState='Virginia';
        firm1.BillingCountry='United States';
        firm1.BillingPostalCode='90001';
        firm1.SfdcLastUpdateType__c = 'F';
        firm1.MarsFirmStatUpdDt__c=Datetime.now();
        firm1.SfdcLastActionFrom__c='F';

        insert firm1;
        
        Account office=new Account();
        office.Name='Test Office';
        office.MarsOfficeId__c=133333;
        office.ParentId=firm.Id;
        office.MarsFirmId__c=firm.MarsFirmId__c;
        office.RecordTypeId=MarsUtility.AccountRecordType;
        office.Phone='9502505860-1234';
        office.BillingStreet='8014 Midlothian Tpke';
        office.BillingCity='Richmond';
        office.BillingState='Virginia';
        office.BillingCountry='United States';
        office.BillingPostalCode='90001';
        office.SfdcLastUpdateType__c = 'O';
        
        Test.startTest();
        
        Test.setMock(WebServiceMock.class, new Mock_OfficeController());
        
        MarsUtility.BYPASS_ALL_TRIGGER = false;
        
        insert office;
        
     
        
        Test.stopTest();
        
        Account officeUpdate=new Account(Id=office.Id);
        officeUpdate.SfdcLastActionFrom__c= '';
        officeUpdate.MarsOfficeStatCd__c='Inactive';
        officeUpdate.BillingCity='Phoenix';
        
        update officeUpdate;
        
        
    }
    static testMethod void repTest() {
        Account firm=new Account();
        firm.Name='Test Office in TestFirm Controller';
        firm.MarsFirmNm__c='Test Firm In TestFirm Controller';
        firm.MarsFirmId__c=1111111;
        firm.Phone='9502505860';
        firm.BillingStreet='8014 Midlothian Tpke \n 1 Tower Bridge 100 Front St \n 8014 Midlothian Tpke \n 1 Tower Bridge 100 Front St,8014 Midlothian Tpke,1 Tower Bridge 100 Front St,8014 Midlothian Tpke,1 Tower Bridge 100 Front St,8014 Midlothian Tpke,1 Tower Bridge 100 Front St';
        firm.BillingCity='Richmond';
        firm.MarsFirmType__c ='BD';
        firm.RecordTypeId=MarsUtility.AccountRecordType;
        firm.BillingState='Virginia';
        firm.BillingCountry='United States';
        firm.BillingPostalCode='90001';
        firm.SfdcLastUpdateType__c = 'F';
        firm.MarsFirmStatUpdDt__c=Datetime.now();
        firm.SfdcLastActionFrom__c='F';
        insert firm;
        
        Account office=new Account();
        office.Name='Test Office';
        office.MarsOfficeId__c=133333;
        office.ParentId=firm.Id;
        office.MarsFirmId__c=firm.MarsFirmId__c;
        office.RecordTypeId=MarsUtility.AccountRecordType;
        office.Phone='9502505860-1234';
        office.BillingStreet='8014 Midlothian Tpke \n 1st Floor';
        office.BillingCity='Richmond';
        office.BillingState='Virginia';
        office.BillingCountry='United States';
        office.BillingPostalCode='90001';
        office.SfdcLastUpdateType__c = 'O';
        office.MarsLastSaleDt__c=system.today();
        
        //Test.setMock(WebServiceMock.class, new Mock_OfficeController());

        insert office;
        
        
        
        Contact rep=new Contact();
        rep.FirstName='Rep';
        rep.MarsRepId__c=155555;
        rep.Phone='9502505860-1234';
        rep.AccountId=office.Id;
        rep.RecordTypeId=MarsUtility.ContactRecordType;
        rep.Birthdate=Date.valueOf('1966-10-24');
        rep.LastName='In Test_MarsApexGateway Class';
        rep.MailingStreet='8014 Midlothian Tpke \n 1st Floor';
        rep.MailingStateCode='VA';
        rep.MailingCity='Richmond';
        rep.MailingCountry='United States';
        rep.MailingPostalCode='90001';
        rep.MarsFirmId__c=1222222;
        

        Test.startTest();
        
        Test.setMock(WebServiceMock.class, new Mock_RepController());
        MarsUtility.BYPASS_ALL_TRIGGER = false;
        insert rep;
        
        System.debug('Updating Office');
        Account officeUpdate=new Account(Id=office.Id);
        officeUpdate.SfdcLastActionFrom__c= '';
        officeUpdate.MarsOfficeStatCd__c='Inactive';
        officeUpdate.BillingCity='Phoenix';
        update officeUpdate;
        
        System.debug('Updating Rep');
        Contact repUpdate=new Contact(Id=rep.Id);
        repUpdate.AccountId=firm.Id;
        repUpdate.FirstName='Update Test Firm';

        update repUpdate;
        
        Test.stopTest();
        
       
        
       
    }*/

    static testMethod void firmTest() {
        // TO DO: implement unit test

        Account firm=new Account();
        firm.Name='Test Office in TestFirm Controller';
        firm.MarsFirmNm__c='Test Firm In TestFirm Controller';
        //firm.MarsFirmId__c=1111111;
        //firm.MarsFirmType__c ='BD';
        firm.RecordTypeId=MarsUtility.AccountRecordType;
        firm.Phone='9502505860';
        firm.BillingStreet='8014 Midlothian Tpke,1 Tower Bridge 100 Front St,1894 N Cleveland Massillon Rd,256 W Durham Plaza ';
        firm.BillingCity='Richmond';
        firm.MarsFirmType__c ='BD';
        firm.BillingState='Virginia';
        firm.BillingStateCode='VA';
        firm.BillingCountry='United States';
        firm.BillingCountryCode='US';
        firm.BillingPostalCode='90001';
        firm.SfdcLastUpdateType__c = 'F';
        firm.MarsFirmStatUpdDt__c=Datetime.now();
        firm.SfdcLastActionFrom__c='F';
        
         Test.startTest();
        
        //Set Mock Callout class 
        Test.setMock(WebServiceMock.class, new Mock_FirmController());
        MarsUtility.BYPASS_ALL_TRIGGER = false;
        MarsUtility.BYPASS_VALIDATION =true;
        insert firm;
        MarsUtility.BYPASS_VALIDATION =false;
        
        
        //MArs Recordtype Should not be changed.
        try{
            firm.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('OTHER').getRecordTypeId();
            Update firm;
        }catch(Exception e){
            System.debug('Error Message:'+e.getMessage());
        }
        
        Account firmupdate=new Account(Id=firm.Id);
        firmupdate.BillingStreet='8014 Midlothian Tpke';
        firmupdate.SfdcLastActionFrom__c = 'F';
        firmupdate.MarsFirmType__c ='BD';
        firmupdate.MarsFirmStatUpdDt__c=Datetime.now();
        firmupdate.SfdcLastActionFrom__c =null;
        
         //Test.setMock(WebServiceMock.class, new Mock_FirmUpdateController());

        update firmupdate;
        
        //Mars Records should not be deleted
        try{
            delete firm;
        }catch(Exception e){
            System.debug('Error Message:'+e.getMessage());
        }
        
        Test.stopTest();
        
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
        MarsUtility.BYPASS_ALL_TRIGGER=false;
        
        MARSDefaults__c marsDefaults = new MARSDefaults__c(MARSPassword__c = 'mars', MARSUser__c = 'KMILLER',IntegrationType__c=1,bulkLoadEnabled__c = true, DeleteMARSBatchDataPeriod__c=30, RetryDuration__c=15, MARSEndpointUrl__c='https:\\salesforce.com',AllowRepMove__c =true);
        insert marsDefaults;
        
    }
}