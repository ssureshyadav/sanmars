@isTest
private Class MarsTestActivities
{
    @testSetup static void setupTestData()
    {
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
        
        Account firm=new Account();
        firm.Name='Firm Account';
        firm.MarsFirmNm__c='Firm Account';
        firm.MarsCrdId__c='ABCD';
        firm.MarsFirmId__c=123455;
        firm.MarsOfficeId__c=12;
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
        
        MARSFirmSummary__c firmsummary =new MARSFirmSummary__c();
        firmsummary.Name='Test Office in TestFirm Controller';
        firmsummary.SfdcFirmId__c =firm.ID;
        firmsummary.MarsFirmType__c = firm.MarsFirmType__c;
        insert firmsummary;
        
        Contact rep=new Contact();
        rep.FirstName='Rep';
        rep.MarsRepId__c=155555;
        rep.Phone='9502505860-1234';
        rep.AccountId=firm.Id;
        rep.RecordTypeId=MarsUtility.ContactRecordType;
        rep.Birthdate=Date.valueOf('1966-10-24');
        rep.LastName='In Test_MarsApexGateway Class';
        rep.MailingStreet='8014 Midlothian Tpke';
        rep.MailingState='Virginia';
        rep.MailingCity='Richmond';
        rep.MarsAddrLock__c = 'N';
        rep.MailingPostalCode='90001';
        rep.MailingCountry='United States';
        rep.MarsOfficeId__c=firm.MarsOfficeId__c;
        rep.MarsFirmId__c=firm.MarsFirmId__c;
        
        MarsUtility.BYPASS_ALL_TRIGGER=true;
        insert rep;
        MarsUtility.BYPASS_ALL_TRIGGER=false;        
    }
   
    private static TestMethod void testTasks()
    {
        
        List<Contact> lstContact=[Select Id,MarsRepId__c from Contact];
        //Create Tickler
        Task tickler=new Task();
        tickler.WhoId=lstContact[0].Id;
        tickler.Subject='Call';
        tickler.Status='In Progress';
        tickler.TaskSubtype='Call';
        tickler.IsRecurrence = true;
        tickler.RecurrenceStartDateOnly = System.today();
        tickler.RecurrenceEndDateOnly = System.today()+30;
        tickler.RecurrenceType = 'RecursDaily';
        tickler.RecurrenceInterval = 1; 
        //tickler.DurationInMinutes =1440;
        //tickler.ActivityDate = System.today();
        insert tickler;
        
        //Create Call
        Task call=new Task();
        call.WhoId=lstContact[0].Id;
        call.Subject='Call';
        call.Status='Completed';
        call.TaskSubtype='Call';
        insert call;
        
        //Create Email
        Task email=new Task();
        email.WhoId=lstContact[0].Id;
        email.Subject='Email';
        email.Subject='Email: test';
        email.TaskSubtype='Email';
        email.Status='Completed';
        email.Description='To: Testing Attachments Body: asdfasd'; 
        insert email;
        
        Case cas=new Case(Status='closed');
        insert cas;
        
        EmailMessage[] newEmail = new EmailMessage[0];
 
        newEmail.add(new EmailMessage(FromAddress = 'test@test.com',
        FromName = 'Email Msg',ToAddress = 'test@test.com',
        Subject = email.subject,TextBody = 'Sending Email',Status='3',ParentId = cas.Id,ActivityId = email.Id)); 
        //
        //ParentId = email.Id, 
        //HtmlBody = email.htmlBody,
        insert newEmail;
        
        update email;
    }
    
    private static TestMethod void testEvents()
    {
        List<Contact> lstContact=[Select Id,MarsRepId__c from Contact];
        List<MARSFirmSummary__c> lstFirmsummary=[Select Id from MARSFirmSummary__c];
        List<Account> lstAccount=[Select Id from Account];
        
        //Create Meeting
        Event meeting=new Event();
        meeting.WhoId=lstContact[0].Id;
        meeting.Subject='Meeting';
        meeting.StartDateTime =DateTime.now();
        meeting.EndDateTime=DateTime.now().addHours(1);
        meeting.EventSubtype='Event';
        meeting.IsRecurrence = true;
        meeting.RecurrenceStartDateTime = System.today();
        meeting.RecurrenceEndDateOnly = System.today()+30;
        meeting.RecurrenceType = 'RecursDaily';
        meeting.RecurrenceInterval = 1; // This means that the event will wait 1 day before recurring again
        meeting.IsAllDayEvent =true;
        meeting.DurationInMinutes =1440;
        meeting.ActivityDate = System.today();
        insert meeting;
        
        //Create FirmEvent
        Event firmEvent=new Event();
        firmEvent.WhoId=lstContact[0].Id;
        firmEvent.WhatId=lstFirmsummary[0].Id;
        firmEvent.Subject='Meeting';
        firmEvent.StartDateTime =DateTime.now();
        firmEvent.EndDateTime=DateTime.now().addHours(1);
        firmEvent.EventSubtype='Event';
        firmEvent.IsRecurrence = true;
        firmEvent.RecurrenceStartDateTime = System.today();
        firmEvent.RecurrenceEndDateOnly = System.today()+30;
        firmEvent.RecurrenceType = 'RecursDaily';
        firmEvent.RecurrenceInterval = 1; 
        firmEvent.IsAllDayEvent =true;
        firmEvent.DurationInMinutes =1440;
        firmEvent.Description ='Test Description';
        firmEvent.ActivityDate = System.today();
        insert firmEvent;
        
        firmEvent.WhatId =lstAccount[0].Id;
        update firmEvent;
        
        
    }
    
    private static TestMethod void exceptionCheck()
    {
        try{
            MarsActivityDatabaseUtiltiy.getEventById('');
        }catch(Exception e){}
        
        try{
            MarsActivityDatabaseUtiltiy.getEventById('00u123455567656');
        }catch(Exception e){}
        
        try{
            MarsActivityDatabaseUtiltiy.getTaskById('');
        }catch(Exception e){}
        
        try{
            MarsActivityDatabaseUtiltiy.getTaskById('00u123455567656');
        }catch(Exception e){}
        
    }
}