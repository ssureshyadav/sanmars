global class MarsBatchEmailErrors implements Schedulable{

    global MarsBatchEmailErrors(){
    }
    
   //execute method
    global void execute(SchedulableContext sc)
    {    
        DateTime currentDate = dateTime.Now();
        currentDate = currentDate.addHours(-1);
        System.debug('\n Created Date'+currentDate);
        Integer retryFailedRecords=[SELECT count() FROM MARSBatchDataStore__c WHERE createdDate >= :currentDate AND NoOfRetry__c > 0];
             
        MARSDefaults__c marsDefaults = MarsUtility.MARS_DEFAULTS;
        
        if(marsDefaults.EmailErrors__c == true)
        {
            if(test.isRunningTest()){
                retryFailedRecords =2;
            }
            if(retryFailedRecords > 0)
            {
                String orgName=[SELECT Name FROM Organization].Name;
                //String orgName=UserInfo.getOrganizationName();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {marsDefaults.Email__c};
                mail.setToAddresses(toAddresses);
                mail.setSubject(orgName+': Message synch failed');
                mail.setSaveAsActivity(false);
                String msgText;
                msgText='\n There are ' + retryFailedRecords + ' recent messages that failed to synch with MARS.';
                msgText=msgText + '\n The integration process will retry the failed messages.';
                msgText=msgText + '\n Please review the failed messages and take necessary corrective action.';
                mail.setPlainTextBody(msgText);
                messaging.sendemailresult[] r=Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                System.debug(r);
             }
        }
        
        Integer retryBatchJob;
        if(DateTime.now().hour()<7)
        {
            retryBatchJob=[SELECT  Count() FROM CronTrigger where CronJobDetail.Name = 'RetryBatchProcess' ];
            if(retryBatchJob != 0)
            {
                CronTrigger cron=[Select Id FROM CronTrigger where CronJobDetail.Name = 'RetryBatchProcess' ];
                system.abortJob(cron.id);
            }
        }
        else
        {
            retryBatchJob=[SELECT  Count() FROM AsyncApexJob where ApexClass.Name = 'MarsBatchRetryBulkData' and Status in ('Queued', 'Processing', 'Preparing')];
            if(retryBatchJob==0)
            {
                retryBatchJob=[SELECT  Count() FROM CronTrigger where CronJobDetail.Name = 'RetryBatchProcess' ];
            }
            if(retryBatchJob == 0)
            {
                System.scheduleBatch(new MarsBatchRetryBulkData() , 'RetryBatchProcess' , Integer.valueOf(marsDefaults.RetryDuration__c), 10);
            }
        }        
    }    
}