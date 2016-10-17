trigger MarsRepTerrUpdater on MARSRepTerr__c (before Insert)
{    
    Set<String> lstterrCd =new Set<String>();
    for(MARSRepTerr__c repTerr:Trigger.new)
    {
        lstterrCd.add(repTerr.MARSTerrCd__c);
    }
    
    List<MarsTerritory__c> lstTerritory=[select Id,MarsTerrCd__c from MarsTerritory__c Where MarsTerrCd__c IN : lstterrCd];
    Map<String,Id> mapTerritory=new Map<String,Id>();
    for(MarsTerritory__c terr:lstTerritory)
    {
        mapTerritory.put(terr.MarsTerrCd__c,terr.Id);
    }
    
    for(MARSRepTerr__c repTerritory:Trigger.new)
    {
        repTerritory.SFDCTerrCd__c = mapTerritory.get(repTerritory.MARSTerrCd__c);
    }
}