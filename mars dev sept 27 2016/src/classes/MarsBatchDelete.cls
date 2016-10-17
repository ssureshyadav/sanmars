global class MarsBatchDelete implements Schedulable
{
    global void execute(SchedulableContext sc)
    { 
        try
        {
            /*MARSBatchDeleteSummary deleteSummary=new MARSBatchDeleteSummary();
            Id delSum=Database.executeBatch(deleteSummary);
            
            MARSBatchDeleteTerrSummary deleteterrSummary=new MARSBatchDeleteTerrSummary();
            Id delTerrSummary=Database.executeBatch(deleteterrSummary);*/
            
            MARSBatchDeleteDataStore deleteBatchDataStore=new MARSBatchDeleteDataStore();
            Id delBatchDataStore=Database.executeBatch(deleteBatchDataStore);            
            
       /*     
            MARSBatchDeleteRepTerr deleteRepTerr=new MARSBatchDeleteRepTerr();
            Id delRepTerr=Database.executeBatch(deleteRepTerr);
            
            MARSBatchDeleteOffTerr deleteOffTerr=new MARSBatchDeleteOffTerr();
            Id delOffTerr=Database.executeBatch(deleteOffTerr);
            
            MARSBatchDeleteRepTerritory deleteRepTerritory=new MARSBatchDeleteRepTerritory();
            Id delRepTerr=Database.executeBatch(deleteRepTerritory);
            
            MARSBatchDeleteOfficeTerritory deleteOfficeTerritory=new MARSBatchDeleteOfficeTerritory();
            Id delOffTerr=Database.executeBatch(deleteOfficeTerritory);
            
            MARSBatchDeleteTerritory deleteTerritory=new MARSBatchDeleteTerritory();
            Id delTerr=Database.executeBatch(deleteTerritory);
       */   

        }        
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
        
    }
}