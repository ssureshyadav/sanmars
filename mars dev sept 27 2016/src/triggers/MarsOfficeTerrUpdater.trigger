trigger MarsOfficeTerrUpdater on MARSOffTerr__c (before Insert)
{
    Set<String> lstterrCd =new Set<String>();
    for(MARSOffTerr__c offTerr:Trigger.new)
    {
            lstterrCd.add(offTerr.MARSTerrCd__c);
    }
    
    List<MarsTerritory__c> lstTerritory=[select Id,MarsTerrCd__c from MarsTerritory__c Where MarsTerrCd__c IN : lstterrCd];
    Map<String,Id> mapTerritory=new Map<String,Id>();
    for(MarsTerritory__c terr:lstTerritory)
    {
        mapTerritory.put(terr.MarsTerrCd__c,terr.Id);
    }
    
    for(MARSOffTerr__c officeTerritory:Trigger.new)
    {
        officeTerritory.SFDCTerrCd__c =mapTerritory.get(officeTerritory.MARSTerrCd__c);
    } 
}