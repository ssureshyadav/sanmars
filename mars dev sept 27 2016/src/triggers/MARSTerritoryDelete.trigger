trigger MARSTerritoryDelete on MARSTerritorySyncDelete__c (after insert)
{
    if(Trigger.new.size() > 0)
    {
       Database.executeBatch(new MARSBatchDeleteRepTerr());
       Database.executeBatch(new MARSBatchDeleteSummary());
    }
}