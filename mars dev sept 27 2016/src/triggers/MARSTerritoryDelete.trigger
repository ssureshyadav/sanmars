trigger MARSTerritoryDelete on MARSTerritorySyncDelete__c (after insert)
{
    if(Trigger.new.size() > 0)
    {
       MARSRepPeriodTerritorySummary__c terrSummary=[SELECT Id,MarsUpdDt__c 
                                                           FROM 
                                                               MARSRepPeriodTerritorySummary__c 
                                                           WHERE 
                                                               isDeleted = false 
                                                           ORDER BY 
                                                               MarsUpdDt__c DESC NULLS LAST
                                                           LIMIT 1];
                                                       
        MarsRepPeriodSummary__c summary=[SELECT Id,MarsUpdDt__c 
                                                   FROM 
                                                       MarsRepPeriodSummary__c
                                                   WHERE 
                                                       isDeleted = false 
                                                   ORDER BY 
                                                       MarsUpdDt__c DESC NULLS LAST
                                                   LIMIT 1];
                                                   
        Date summaryDate =summary.MarsUpdDt__c.Date();
        Date terrSummaryDate =terrSummary.MarsUpdDt__c.Date();
        System.debug(summaryDate);
        System.debug(terrSummaryDate);                                               

       Database.executeBatch(new MARSBatchDeleteRepTerr());
       Database.executeBatch(new MARSBatchDeleteSummary(summaryDate,terrSummaryDate));
    }
}