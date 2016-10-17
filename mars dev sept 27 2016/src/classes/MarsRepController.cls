public class MarsRepController
{
    
    public String title {get;set;}
    Private Contact rep;
    Private Id repId;
   // List<members> memberRep{get;set;}
   List<MarsRepTeam__c> memberReps;
    
    public MarsRepController() {
        repID = System.currentPageReference().getParameters().get('Id');
        rep=[select Id, MarsRepId__c, MarsRepFirmType__c , MarsRepStaffCd__c from Contact where Id = : repId];
    }
    
    public string getfirmtypeValue(){
            String firmtypeCd = (String) rep.MarsRepFirmType__c;
            String firmType = '';
            
            //Getting firm type description
            for(MarsCd__c codesetting: MarsCd__c.getAll().values())
            {
                if(codesetting.MarsCdType__c == 'FTY' && codesetting.MarsCdCd__c==firmtypeCd){
                    firmType = codesetting.name;
                    }
            }
            if(firmType==''){
                firmType=firmtypeCd;
               }
            return firmType;
    }
    
    public string getreptypeValue(){
            String repstaffCd = (String) rep.MarsRepStaffCd__c;
            String repType = '';
            
            //Getting rep type description
            for(MarsCd__c codesetting: MarsCd__c.getAll().values())
            {
                if(codesetting.MarsCdType__c == 'RRO' && codesetting.MarsCdCd__c==repstaffCd){
                    repType = codesetting.name;
                    }
            }
            if(repType==''){
                repType=repstaffCd;
               }
            return repType;
    }
    
    public Map<Id, String> getterritoryValue()
    {
            Map<ID, String> territoryList = new Map<ID, String> ();
            try
            {
                List<MARSRepTerr__c> repterr=[SELECT SFDCTerrCd__r.Id, SFDCTerrCd__r.Name FROM MARSRepTerr__c WHERE MarsRepId__c = : rep.MarsRepId__c];
                if(!repterr.IsEmpty())
                {
                    for(MARSRepTerr__c t :repterr)
                    {
                        territoryList.Put(t.SFDCTerrCd__r.Id, t.SFDCTerrCd__r.Name);
                    }
                }
            }
            catch(Exception e){
                System.debug(e.getMessage());
            }
            return territoryList;
    }
    
    public List<MarsRepTeam__c> getmemberReps()
    { 
        Id queryId = rep.Id;                       
        if(rep.MarsRepStaffCd__c == 'T')
        {
            title='Member Reps';
            memberReps=[SELECT Id, SfdcRepId__c, SfdcRepId__r.Name, SfdcTeamRepId__c,SfdcTeamRepId__r.Name,MarsSplitPercent__c, SfdcRepId__r.MarsYtdPurch__c, SfdcRepId__r.MarsYtdRed__c, SfdcRepId__r.MarsCAssets__c FROM MarsRepTeam__c WHERE SfdcTeamRepId__c = : queryId];
        }
        else
        {
            title='Team Reps';
            List<MarsRepTeam__c> teamReps = [SELECT ID, SfdcTeamRepId__c FROM MarsRepTeam__c WHERE SfdcRepId__c = : queryId];
            List<ID> teamRepId = new List<ID>();
            for(MarsRepTeam__c team:teamReps)
            {
                teamRepId.add(team.SfdcTeamRepId__c);
            }
            if(!teamRepId.isEmpty())
            {
                memberReps=[SELECT Id, SfdcRepId__c, SfdcRepId__r.Name, SfdcTeamRepId__c,SfdcTeamRepId__r.Name,MarsSplitPercent__c, SfdcRepId__r.MarsYtdPurch__c, SfdcRepId__r.MarsYtdRed__c, SfdcRepId__r.MarsCAssets__c FROM MarsRepTeam__c WHERE SfdcTeamRepId__c in : teamRepId];
            }
        }        
        return memberReps;
    }
}