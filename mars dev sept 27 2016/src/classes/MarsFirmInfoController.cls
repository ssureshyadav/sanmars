public class MarsFirmInfoController {

    Private MARSFirmSummary__c firm;
    Private Id firmId;    
    
    public MarsFirmInfoController() {
            firmId = System.currentPageReference().getParameters().get('Id');
            firm = [select Id, MarsFirmType__c, MarsfirmId__c from MARSFirmSummary__c where Id = : firmId];
        }    
    
    public string getfirmtypeValue(){
            String firmtypeCd = (String) firm.MarsFirmType__c;
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
    
    public Map<Id, String> getterritoryValue(){
            Map<ID, String> territoryList = new Map<ID, String> ();
            /*try
            {
                List<MARSOffTerr__c> firmterr=[SELECT SFDCTerrCd__r.Id, SFDCTerrCd__r.Name FROM MARSOffTerr__c WHERE MarsfirmId__c = : firm.MarsfirmId__c];
                if(!firmterr.IsEmpty())
                {
                    for(MARSOffTerr__c t :firmterr)
                    {
                        territoryList.Put(t.SFDCTerrCd__r.Id, t.SFDCTerrCd__r.Name);
                    }
                }
            }
            catch(exception e){}*/
            return territoryList;
    }       
}