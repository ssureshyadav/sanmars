global without sharing class MARSPostInstall implements InstallHandler
{
    global void onInstall(InstallContext context)
    {
        if(!context.isUpgrade()) 
        {
            String sch = '0 15 * * * ?';
            MarsBatchEmailErrors emailErrors = new MarsBatchEmailErrors();
            String emailErr = system.schedule('MarsErrorNotification', sch, emailErrors);
        }else
        {
            Integer retryBatchJob=[SELECT  Count() FROM AsyncApexJob where ApexClass.Name = 'MarsBatchEmailErrors' and Status in ('Queued', 'Processing', 'Preparing')];
            if(retryBatchJob==0)
            {
                retryBatchJob=[SELECT  Count() FROM CronTrigger where CronJobDetail.Name = 'MarsErrorNotification' ];
            }
            if(retryBatchJob == 0)
            {
                String sch = '0 15 * * * ?';
                System.schedule('MarsErrorNotification', sch, new MarsBatchEmailErrors());
            }
        }
    }
}