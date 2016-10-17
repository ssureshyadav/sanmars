public class MARSConfigController
{

    public SelectOption[] selectedFirmTypes { get; set; }

    public SelectOption[] allFirmTypes { get; set; }
    public boolean hasAccess { get; set; }
    
    public boolean displayEdit {get;set;}
    
    public String configUsr { get; set; }
    
    public String configPswd { get; set; }
    
    public boolean editInfo { get; set; }

    public PageReference edit()
    {
        System.debug('HAs Access+'+configUsr+marsUser);
        System.debug('HAs Access'+configUsr);
        System.debug(editInfo);
        displayEdit =true;
        System.debug(displayEdit);
        return null;
    }
    
    public PageReference doAction()
    {
        if(configPswd==''||configPswd==null)
        {
            showContent=true;
            hasAccess=false;
        }
        else if(configPswd=='M@rs2010#7i')
        {
            showContent=true;
            hasAccess=true;
        }
        else
        {
            showContent=false;
        }
        
        if(!showContent)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Failed to login, incorrect Password.'));
        }
        return null;
    }

    public MARSDefaults__c defaults {get;set;}

    public boolean showContent{get;set;}
    
    ////Used in component
    public String marsPassword {get;set;}
    public String marsUser {get;set;}

    public MARSConfigController()
    {
        System.debug('UName:'+configUsr );
        //Get MARS Defaults values
        defaults = MarsUtility.MARS_DEFAULTS;
        
        System.debug(defaults);
        if(defaults.Marspassword__c !=null)
             marsPassword =EncryptString(defaults.Marspassword__c);
         else
         {
             displayEdit = true;
         }
    }
    
    public PageReference save()
    {
        System.debug('HAs Access'+configUsr);
        System.debug(hasAccess);
        System.debug(defaults.Marspassword__c);
        System.debug(defaults.EmailErrors__c);
        if(String.isEmpty(defaults.Marspassword__c)){
            defaults.Marspassword__c.addError('You must enter a value.');
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Password should not be null.'));
            return null;
        }
        if(defaults.EmailErrors__c){
            if(String.isEmpty(defaults.Email__c)){
            defaults.Email__c.addError('You must enter a value.');
            return null;
            }
        }
        Database.upsert(defaults);
        
        displayEdit = false;
        return null;
    }
    
    public PageReference cancel()
    {
        showContent=true;
        displayEdit=false;

        return null;
    }
    
    public String EncryptString(String encryptionValue)
    {
        transient String astrickvalue='';
        for(integer i=0;i<encryptionValue.length();i++)
        {
            astrickvalue +='*';
        }
        return astrickvalue;
    }
    
  /*  public void MarsRemoteSite()
    {
        String endPointURL = defaults.MARSEndpointUrl__c;
        MARSMetaController.createRemoteSiteSettings(endPointUrl);        
    } */
}