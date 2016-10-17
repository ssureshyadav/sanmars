trigger MARSRepPeriodTerritorySummaryUpdater on MARSRepPeriodTerritorySummary__c (before Insert) {
  
    Set<String> setterrCd =new Set<String>();
    for(MARSRepPeriodTerritorySummary__c rptSummary:Trigger.new)
    {
        if(rptSummary.MARSTerrCd__c != null)
        {
            setterrCd.add(rptSummary.MARSTerrCd__c);
        }
    }
    
    if(!setterrCd.isEmpty())
    {
        System.debug(setterrCd);
        List<MarsTerritory__c> lstTerritory=[select Id,MarsTerrCd__c from MarsTerritory__c Where MarsTerrCd__c IN : setterrCd];
        Map<String,Id> mapTerritory=new Map<String,Id>();
        for(MarsTerritory__c terr:lstTerritory)
        {
            mapTerritory.put(terr.MarsTerrCd__c,terr.Id);
        }
        
        for(MARSRepPeriodTerritorySummary__c Summary:Trigger.new)
        {
            if(Summary.MARSTerrCd__c != null)
            {
                Summary.SFDCTerrCd__c = mapTerritory.get(Summary.MARSTerrCd__c);
            }
        }
    }
}