/** Description     :   This class is there to hold all the generic methods.
 *
 *  Created By      :
 *
 *  Created Date    :   07/02/2013
 *
 *  Revision Log    :   V_1.0
 *
**/
public class MarsUtility {

    //Boolean flag for validate whether the contact trigger will execute or not
    public static Boolean BYPASS_ALL_TRIGGER = false;
    public static Boolean BYPASS_VALIDATION = false;
    public static Boolean FirmUpdate = false;
    public static Id AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MARS').getRecordTypeId();
    public static Id ContactRecordType= Schema.Sobjecttype.Contact.getRecordTypeInfosByName().get('MARS').getRecordTypeId();
    public static Id ProductRecordType= Schema.Sobjecttype.Product2.getRecordTypeInfosByName().get('MARS').getRecordTypeId();
    public static Id RepTeamRecordType= Schema.Sobjecttype.MarsRepTeam__c.getRecordTypeInfosByName().get('MARS').getRecordTypeId();
    //public static Id FirmSummaryRecordType= Schema.Sobjecttype.MARSFirmSummary__c.getRecordTypeInfosByName().get('MARS').getRecordTypeId();
    
    
    //public static String classPrefix =[SELECT NamespacePrefix FROM ApexClass WHERE Name = 'MarsUtility'].NamespacePrefix + '__';
    
    public static void UpdateAccountContact(List<SObject> objAccountContact)
    {
            try
            {
                //Set the Trigger by pass flag
                MarsUtility.BYPASS_ALL_TRIGGER = true; 
                update objAccountContact;
            }
            finally
            {   
                //Clear the Trigger by pass flag
                MarsUtility.BYPASS_ALL_TRIGGER = false;
            }
    }
    
    public static MARSDefaults__c MARS_DEFAULTS
    {

        get {

            //Get MARS Defaults values
            MARSDefaults__c marsDefaults = MARSDefaults__c.getOrgDefaults();

            //Check if MARS Defaults is already there or not
            if(marsDefaults == null) {
                marsDefaults = new MARSDefaults__c();
            }

            //Return MARS Defaults
            return marsDefaults;
        }
    } 

    public static apiPhxaComMarsisForupsertservice.FORUpsertServiceSoap populatedAuthService() {
        
        //Variable to hold the MARS Defaults paramters configuration setting
        MARSDefaults__c marsDefaults = MarsUtility.MARS_DEFAULTS;

        //Instantiating FORService object
        apiPhxaComMarsisForupsertservice.FORUpsertServiceSoap service = new apiPhxaComMarsisForupsertservice.FORUpsertServiceSoap();

        //Create Authrization header
        apiPhxaComMarsisForupsertservice.AuthHeader authHeader = new apiPhxaComMarsisForupsertservice.AuthHeader();

        //Populating Authrization Header with valid Credentials with the help of custom setting. By doing this it will remove's our dependencies over
        //environments.
        authHeader.Username = marsDefaults.MARSUser__c;
        authHeader.Password = marsDefaults.MARSPassword__c;
        
        //Setting authorization for ForServiceSoap Object
        service.AuthHeader = authHeader;

        //Setting service timeout time
        service.timeout_x = 60000;
        
        //Return Populated service
        return service;
    }
    
    //Method for populaing Authrization service with valid credentials through custom setting
    public static apiPhxaComMarsisMergemoveservice.MergeMoveServiceSoap populatedAuthServiceForMerge() {

        //Variable to hold the MARS Defaults paramters configuration setting
        MARSDefaults__c marsDefaults = MarsUtility.MARS_DEFAULTS;

        //Instantiating MergeMoveService object
        apiPhxaComMarsisMergemoveservice.MergeMoveServiceSoap service = new apiPhxaComMarsisMergemoveservice.MergeMoveServiceSoap();

        //Create Authrization header
        apiPhxaComMarsisMergemoveservice.AuthHeader authHeader = new apiPhxaComMarsisMergemoveservice.AuthHeader();

        //Populating Authrization Header with valid Credentials with the help of custom setting. By doing this it will remove's our dependencies over
        //environments.
        authHeader.Username = marsDefaults.MARSUser__c;
        authHeader.Password = marsDefaults.MARSPassword__c;

        //Setting authorization for MergeMoveService Object
        service.AuthHeader = authHeader;

        //Setting service timeout time
        service.timeout_x = 60000;

        //Return Populated service
        return service;
    }

    //Method for replace special charectors from phone field
    public static String replaceSpecialCharFromPhone(String phoneString)
    {
        //Checking for special characters
        if(phoneString != null)
        {
            phoneString = phoneString.replaceAll('\\(', '').replaceAll(' ', '').replaceAll('\\)', '').replaceAll('-', '');
        }
        else
        {            
            phoneString='';
        }
        return phoneString;
    }

   //Populate account instance by MARS insert response
    public static Account updateAccounByMARSResponse(Account account, String marsResponse, Boolean isInsert, String Entity)
    {
        MARSDefaults__c defaults=MarsUtility.MARS_DEFAULTS;
        
        //Document class
        Dom.document doc = new Dom.document();

        //Load the response string into dom class
        doc.load(marsResponse);

        //XMLNodeParser
        MarsXMLNodeParser xmlParser = new MarsXMLNodeParser();

        //Passing document to the XML Parser class for getting the values        
        if(Entity == 'firm')
        {
            //populate the account field with values
            xmlParser.XMLNodeParserForFirm(doc);
            account.MarsFirmId__c = Decimal.valueOf(xmlParser.firmId);
            account.MarsOfficeId__c = Decimal.valueOf(xmlParser.homeOfficeId);
            if(defaults.RetainSFDCAccountName__c==false)
            {
                account.Name = xmlParser.officeNm;
            }
        }
        else if(Entity == 'office')
        {
            xmlParser.XMLNodeParserForOffice(doc);
            //populate the account field with values
            account.MarsOfficeId__c = Decimal.valueOf(xmlParser.officeId);
            account.MarsFirmId__c = Decimal.valueOf(xmlParser.firmId);
            if(defaults.RetainSFDCAccountName__c==false)
            {
                account.Name = xmlParser.officeNm;
            }
        }
        return account;
    }

    //Populate contact instance by MARS insert response
    public static Contact updateContactByMARSResponse(Contact contact, String marsResponse, Boolean isInsert)
    {
        //Document class
        Dom.document doc = new Dom.document();

        //Load the response string into dom class
        doc.load(marsResponse);

        //XMLNodeParser
        MarsXMLNodeParser xmlParser = new MarsXMLNodeParser();

        //Passing document to the XML Parser class for getting the values
        xmlParser.XMLNodeParserForRep(doc);

        //populate the contact field with values
        contact.MarsRepId__c = Decimal.valueOf(xmlParser.repId);
        contact.MarsOfficeId__c = Decimal.valueOf(xmlParser.officeId);
        contact.MarsFirmId__c = Decimal.valueOf(xmlParser.firmId);
        return contact;
    }
    
    public static List<String> firmCRDId = new List<String>();
    public static List<String> repCRDId = new List<String>();
    
    public static Map<String,String> mapCRDIds =new Map<String,String>();
    
    public static Map<String,String> checkMapCRD(){
        if(!mapCRDIds.isEmpty()){
            return mapCRDIds;
        }
        return null;
    }
}