public class MarsOfficeController {

    Private Account office;
    Private Id officeId;    
    
    public MarsOfficeController() {
            officeId = System.currentPageReference().getParameters().get('Id');
            office = [select Id, MarsOffFirmType__c, MarsOfficeId__c from Account where Id = : officeId];
        }    
    
    public string getfirmtypeValue(){
            String firmtypeCd = (String) office.MarsOffFirmType__c;
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
            try
            {
                List<MARSOffTerr__c> officeterr=[SELECT SFDCTerrCd__r.Id, SFDCTerrCd__r.Name FROM MARSOffTerr__c WHERE MarsOfficeId__c = : office.MarsOfficeId__c];
                if(!officeterr.IsEmpty())
                {
                    for(MARSOffTerr__c t :officeterr)
                    {
                        territoryList.Put(t.SFDCTerrCd__r.Id, t.SFDCTerrCd__r.Name);
                    }
                }
            }
            catch(exception e){}
            return territoryList;
    }       
}