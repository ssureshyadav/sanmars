Public with sharing class MarsFirmSumController
{

    public MARSFirmSummary__c firmsummary {get; set;}
    public Boolean checkreloadpage {get; set;}
    public ApexPages.StandardController stdController {get;set;}
    public Boolean firmNameEdit {get; set;}
    MARSDefaults__c marsDefaults = MarsUtility.MARS_DEFAULTS;
    
    public MarsFirmSumController(ApexPages.StandardController controller) 
    {
        //this.stdController = controller;
        System.debug('\n Constructor Call');
        List<String> lstString=new List<String>();
        for(String str:Schema.SobjectType.MARSFirmSummary__c.fields.getMap().keySet()){
            lstString.add(str);
        }
        if (!Test.isRunningTest())
        {
            controller.addFields(lstString);
        }
        //controller.addFields(new List<String>{'Name','MarsFirmComment__c','Marsfirmstatcd__c','MarsCrdId__c','MarsFirmWebsite__c','MarsLastFirmNoteDt__c'});
        stdController = controller;
        firmsummary = (MARSFirmSummary__c) controller.getRecord();
        string officeNamingMethod = marsDefaults.MARSOfficeNamingMethod__c;
        if(officeNamingMethod == 'FA' || officeNamingMethod == 'FI' || officeNamingMethod == 'FS' || officeNamingMethod == 'SF')
        {
            firmNameEdit = False;
        }
        else
        {
            firmNameEdit = True;
        }
        objectselected='marssfs__MARSFirmSummary__c';
        objectfieldlist = new list<objectfieldinfo>();
        account =new Account();
        account.BillingCountryCode ='US';
        checkreloadpage =false;
    }
    
    public List<SObjectField> firmSumFields {get;set;}
    public List<String> lsFieldNames {get;set;}
    public Account account {get;set;}

    public string rectypefld {get;set;}
    public string objectselected {get;set;}
    public list<objectfieldinfo> objectfieldlist {get;set;}
    
    public void getfundsummaryinfo(){
        String querybody='';
        if(ApexPages.CurrentPage().getParameters().get('Id') != null)
        {
            for(String str:Schema.SobjectType.MARSFirmSummary__c.fields.getMap().keySet()){
                querybody=querybody+str+',';
            }
            querybody=querybody.removeEnd(',');
            System.debug(querybody);
            firmsummary =Database.query('Select '+querybody +' from MARSFirmSummary__c Where Id =' + '\'' + Apexpages.currentPage().getParameters().get('Id') + '\'');
        }
    }
    
     public List<selectOption> marsFirmType
    {
        get
        {
            List<selectOption> options = new List<selectOption>();
            for (MarsCd__c type : MarsCd__c.getAll().values())
            {
                if(type.MarsCdType__c == 'FTY')
                {
                    options.add(new SelectOption(type.MarsCdCd__c,type.Name));
                }
            }
            return options;
        }
        set; 
    }
    
    //Method used to get the firm type values in the firm_edit page
    public List<SelectOption> getfirmstatusValue()
    {
        List<selectOption> statusOptions = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription = MARSFirmSummary__c.MarsFirmStatCd__c.getDescribe();
        List<Schema.PicklistEntry> firmstatus = statusFieldDescription.getPicklistValues();
        if(!firmstatus.IsEmpty())
        {
            for(Schema.Picklistentry picklistEntry:firmstatus)
            {
                statusOptions.add(new SelectOption(pickListEntry.getLabel(),pickListEntry.getValue()));
            }
        }
        return statusOptions;
    }
    
    public string getfirmtypeValue()
    {
        if(firmsummary != null)
        {
            String firmType = '';
            String firmtypeCd;
            List<MARSFirmSummary__c> firmvalue=[select MarsFirmType__c from MARSFirmSummary__c where Id = : firmsummary.Id Limit 1];
            if(!firmvalue.IsEmpty())
            {
                firmtypeCd = (String) firmvalue[0].MarsFirmType__c;

                //Adding custom settings to the select list
                for(MarsCd__c codesetting: MarsCd__c.getAll().values())
                {
                    if(codesetting.MarsCdType__c == 'FTY' && codesetting.MarsCdCd__c==firmtypeCd)
                    {
                        firmType = codesetting.name;
                    }
                }
            }
            if(firmType=='')
            {
                firmType=firmtypeCd;
            }
            return firmType;
        }
        else
        {
            return null;
        }
    }
 
    //method called on onload of page to showdata fields with data dynamically
    public void calledonload()
    {
        firmSumFields =new List<SObjectField>();

        list<String> reqfldlist=new list<String>();
        
        list<string> reqfldlist_temp=rectypefld.split('%firmsum%');
        if(reqfldlist_temp.size()!=1)
        reqfldlist=reqfldlist_temp[1].split(',');
        rectypefld=reqfldlist_temp[0];
        list<string> rlist=new list<string>(); 
        if(rectypefld !='' || rectypefld!=null)
        {
            rlist=rectypefld.split(',');
        }
        objectfieldinfo sfld;
        for(string r1 :rlist)
        {
            sfld=new objectfieldinfo();
            if(r1!='' || r1!=null)
            {
                //check if required
                sfld.apiname=r1;
                sfld.isrequired=false;
                for(String req:reqfldlist)
                {
                    if(r1.trim()==req.trim())
                    sfld.isrequired=true;
                }
                objectfieldlist.add(sfld);
            }
        }
        checkreloadpage =true;
        //getfundsummaryinfo();
    }
    public class objectfieldinfo
    {
        public string apiname{get;set;}             
        public boolean isrequired{get;set;}        
    }
    
    public PageReference saveresult()
    {
        try
        {
            if(firmsummary.Id == null)
            {
                firmsummary.MarsShortNm__c = firmsummary.Name.length()>15?firmsummary.Name.subString(0,15):firmsummary.Name;
                if(firmsummary.MarsCrdId__c != null)
                {
                   firmsummary.MarsCrdId__c =firmsummary.MarsCrdId__c.toUpperCase(); 
                }
                account.MarsCrdId__c = firmsummary.MarsCrdId__c;
                account.MarsFirmNm__c= firmsummary.Name;
                account.MarsFirmComment__c=firmsummary.MarsFirmComment__c;
                account.MarsShortNm__c=firmsummary.MarsShortNm__c;
                account.MarsFirmStatUpdDt__c=firmsummary.MarsFirmStatUpdDt__c;
                account.MarsGeoConc__c=firmsummary.MarsGeoConc__c;
                account.MarsNsccFirmNbr__c=firmsummary.MarsNsccFirmNbr__c;
                account.MarsNbrOfRegStates__c=firmsummary.MarsNbrOfRegStates__c;
                account.MarsSalesGoalAmt__c=firmsummary.MarsSalesGoalAmt__c;
                account.MarsSdrFlg__c=firmsummary.MarsSdrFlg__c;
                account.MarsFirmWebsite__c=firmsummary.MarsFirmWebsite__c;
                account.SfdcLastActionFrom__c = 'F';
                account.SfdcLastUpdateType__c = 'F';
                if(firmsummary.MarsFirmStatCd__c == null){
                    firmsummary.MarsFirmStatCd__c ='Active';
                }
                account.MARSFirmStatCd__c=firmsummary.MARSFirmStatCd__c;
                account.RecordTypeId=MarsUtility.AccountRecordType;
                integer validationcount=MarsValidation.validateFirm(new List<MARSFirmSummary__c>{firmsummary},new Map<Id,MARSFirmSummary__c>(),'INSERT');
                if(validationcount == -1)
                {
                    return null;
                }
                MarsUtility.BYPASS_VALIDATION =true;
                Database.insert(account);
                MarsUtility.BYPASS_VALIDATION =false;
                
                firmsummary.SfdcFirmId__c =account.ID;
                firmsummary.MarsFirmType__c = account.MarsFirmType__c;
                MarsUtility.BYPASS_ALL_TRIGGER=true;
                insert firmsummary;
                
                Account acc=new Account(Id=account.Id);
                acc.SFDCFirmSumId__c = firmsummary.Id;
                update acc;
                MarsUtility.BYPASS_ALL_TRIGGER=false;
            }else{
                update firmsummary;
            }
            
            PageReference detailview = new pagereference('/'+firmsummary.Id);
            detailview.setRedirect(true);
            return detailview;
        }
        catch(DmlException e)
        {   
            if(e.getMessage().contains('duplicate value found'))
            {
                List<Account> acc=[select id,Name From Account where MarsCrdId__c= : firmsummary.MarsCrdId__c limit 1];
                if(!acc.IsEmpty())
                {
                    firmsummary.MarsCrdId__c.addError('Duplicate value on record :'+acc[0].Name);
                    
                    firmsummary.MarsFirmType__c=firmsummary.MarsFirmType__c;
                }
            }else
            {
                firmsummary.addError(e.getMessage());
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,e.getMessage()));
            }
            return null;
        }
    }

    public Pagereference saveAndNew()
    {
        // code to do saving goes here
        try
        {
            if(firmsummary.Id == null)
            {
                firmsummary.MarsShortNm__c = firmsummary.Name.length()>15?firmsummary.Name.subString(0,15):firmsummary.Name;
                if(firmsummary.MarsCrdId__c != null)
                {
                   firmsummary.MarsCrdId__c =firmsummary.MarsCrdId__c.toUpperCase(); 
                }
                account.MarsCrdId__c = firmsummary.MarsCrdId__c;
                account.MarsFirmNm__c= firmsummary.Name;
                account.MarsFirmComment__c=firmsummary.MarsFirmComment__c;
                account.MarsShortNm__c=firmsummary.MarsShortNm__c;
                account.MarsFirmStatUpdDt__c=firmsummary.MarsFirmStatUpdDt__c;
                account.MarsGeoConc__c=firmsummary.MarsGeoConc__c;
                account.MarsNsccFirmNbr__c=firmsummary.MarsNsccFirmNbr__c;
                account.MarsNbrOfRegStates__c=firmsummary.MarsNbrOfRegStates__c;
                account.MarsSalesGoalAmt__c=firmsummary.MarsSalesGoalAmt__c;
                account.MarsSdrFlg__c=firmsummary.MarsSdrFlg__c;
                account.MarsFirmWebsite__c=firmsummary.MarsFirmWebsite__c;
                account.SfdcLastActionFrom__c = 'F';
                account.SfdcLastUpdateType__c = 'F';
                if(firmsummary.MarsFirmStatCd__c == null)
                {
                    firmsummary.MarsFirmStatCd__c='Active';
                }
                account.MARSFirmStatCd__c=firmsummary.MARSFirmStatCd__c;
                account.RecordTypeId=MarsUtility.AccountRecordType;
                integer validationcount=MarsValidation.validateFirm(new List<MARSFirmSummary__c>{firmsummary},new Map<Id,MARSFirmSummary__c>(),'INSERT');
                if(validationcount == -1)
                {
                    return null;
                }
                MarsUtility.BYPASS_VALIDATION =true;
                Database.insert(account);
                MarsUtility.BYPASS_VALIDATION =false;
                
                firmsummary.SfdcFirmId__c =account.ID;
                firmsummary.MarsFirmType__c = account.MarsFirmType__c;
                MarsUtility.BYPASS_ALL_TRIGGER=true;
                insert firmsummary;
                
                Account acc=new Account(Id=account.Id);
                acc.SFDCFirmSumId__c = firmsummary.Id;
                update acc;
                MarsUtility.BYPASS_ALL_TRIGGER=false;
            }else
            {
                update firmsummary;
            }

            PageReference detailview = new pagereference('/apex/VF_FirmEdit?retURL=/'+firmsummary.Id);
            detailview.setRedirect(true);
            return detailview;
        }
        catch(DmlException e)
        {
            if(e.getMessage().contains('duplicate value found'))
            {
                List<Account> acc=[select id,Name From Account where MarsCrdId__c= : firmsummary.MarsCrdId__c limit 1];
                if(!acc.IsEmpty())
                {
                    firmsummary.MarsCrdId__c.addError('Duplicate value on record :'+acc[0].Name);
                    firmsummary.MarsFirmType__c=firmsummary.MarsFirmType__c;
                }
            }else
            {
                firmsummary.Name.addError(e.getMessage());
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,e.getMessage()));
            }
            return null;
        }
    }
    
    public pageReference cancelAction()
    {
        PageReference page;
        if(apexpages.currentPage().getParameters().get('retURL') == 'VF_FirmList')
        {
            page = new PageReference('/apex/VF_FirmList');
        }
        else if(apexpages.currentPage().getParameters().get('retURL') == 'VF_FirmView')
        {
            page = new PageReference('/apex/VF_FirmView');
        }
        else
        {
            page = new PageReference(apexpages.currentPage().getParameters().get('retURL'));
        }
        Page.setRedirect(true);
        return Page;
    }
}