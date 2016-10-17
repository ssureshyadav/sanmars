/** Description     :   This class is to parse the request from the XML Nodes.
 *
 * Created By        :  Suresh
 *
 * Created Date      :  08/25/2013
 *
 * Last Modified By  :  
 *
 * Last Modified Date:  
 *
 * Revision Log     :   V_1.0
 *
      Last Modified Details
    Date        User        Purpose
    --------------------------------------------------------------
    12/3/2013    Suresh     BUG73597
    12/4/2013    Suresh     BUG73667

    --------------------------------------------------------------
**/

public class MarsSyncMessageParser
{   
    public static Map<String, List<Account>> ParseFirm(String FirmXML)
    {
        Id marsAccountRecordType=MarsUtility.AccountRecordType;
        Map<String, List<Account>> mapFirm = new Map<String, List<Account>>();
        List<Account> lstParseSuccess=new List<Account>();
        List<Account> lstParseFailed=new List<Account>();
        
        Account firmObject;        
        
        //Creating the dom.document object to parse the input xml
        Dom.document doc = new Dom.document();
         
        //Passing string to the XML Parser class for getting the values
        doc.load(FirmXML);
                          
        Dom.XMLNode root = doc.getRootElement().getChildElement('FIRM', 'http://tempuri.org/MarsFirm.xsd');
                  
        if(root !=NULL)
        {
            for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
            {
                firmObject=new Account();
                try
                {                    
                    Dom.XMLNode firmId = elementsList.getChildElement('FIRM_ID', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.MarsFirmId__c =Decimal.valueOf(firmId.getText());
    
                    Dom.XMLNode firmName = elementsList.getChildElement('FIRM_NAME', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.MarsFirmNm__c =parseNull(firmName.getText());
                    
                    Dom.XMLNode externalFirmId = elementsList.getChildElement('EXTERNAL_FIRM_ID', 'http://tempuri.org/MarsFirm.xsd');
                    if(externalFirmId.getText().length()>0)
                    {
                        firmObject.Id=parseNull(externalFirmId.getText());
                    }
                    
                    Dom.XMLNode firmShortName = elementsList.getChildElement('SHORT_NAME', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.MarsShortNm__c=parseNull(firmShortName.getText());
                    
                    Dom.XMLNode homeOfficeId = elementsList.getChildElement('HOME_OFFICE_ID', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.MarsOfficeId__c=parseDecimal(homeOfficeId.getText());
                    
                    Dom.XMLNode regStates = elementsList.getChildElement('NUMBER_OF_REG_STATES', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.MarsNbrOfRegStates__c=parseDecimal(regStates.getText());
                    
                    Dom.XMLNode geoConc = elementsList.getChildElement('GEO_CONC', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.MarsGeoConc__c=parsenull(geoConc.getText());
                
                    Dom.XMLNode lastFirmNoteDt = elementsList.getChildElement('LAST_FIRM_NOTE_DATE', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.MarsLastFirmNoteDt__c=parseDateTime(lastFirmNoteDt.getText());
                    
                    Dom.XMLNode statusCode = elementsList.getChildElement('STATUS_CD', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.MarsFirmStatCd__c=parsenull(statusCode.getText());
                     
                    Dom.XMLNode firmDescription = elementsList.getChildElement('FIRM_COMMENT', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.MarsFirmComment__c=parseNull(firmDescription.getText());

                    Dom.XMLNode firmType = elementsList.getChildElement('FIRM_TYPE', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.MarsFirmType__c=parseNull(firmType.getText());  
                    
                    Dom.XMLNode salesGoalAmt = elementsList.getChildElement('SALES_GOAL_AMOUNT', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.MarsSalesGoalAmt__c=parseDecimal(salesGoalAmt.getText());
                    
                    Dom.XMLNode statUpdateDate = elementsList.getChildElement('STATUS_UPDATE_DATE', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.MarsFirmStatUpdDt__c=parseDateTime(statUpdateDate.getText());
                    
                    Dom.XMLNode nsccFirmNbr = elementsList.getChildElement('NSCC_FIRM_NBR', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.MarsNsccFirmNbr__c=parseNull(nsccFirmNbr.getText());
                
                    Dom.XMLNode sdrFlag = elementsList.getChildElement('SDR_FLG', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.MarsSdrFlg__c=parseNull(sdrFlag.getText());
                    
                    Dom.XMLNode website = elementsList.getChildElement('WEB_SITE', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.MarsFirmWebsite__c=parseNull(website.getText());
                    
                    Dom.XMLNode crdId = elementsList.getChildElement('CRD_ID', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.MarsCrdId__c=parseNull(crdId.getText());
                    
                    if(crdId.getText().length()>0 && externalFirmId.getText().length()==0)
                    {
                        MarsUtility.firmCRDId.add(crdId.getText().trim());
                    }
                    
                    Dom.XMLNode officeName = elementsList.getChildElement('OFFICE_NM', 'http://tempuri.org/MarsFirm.xsd');

                    if(externalFirmId.getText().length()>0)
                    {
                        MARSDefaults__c defaults=MarsUtility.MARS_DEFAULTS;
                        if(defaults.RetainSFDCAccountName__c==false)
                        {
                            firmObject.Name = parseNull(officeName.getText());
                        }
                    }
                    else
                    {
                        firmObject.Name = parseNull(officeName.getText());
                    }
                    
                    firmObject.ParentId = null;
                        
                    Dom.XMLNode address1 = elementsList.getChildElement('ADDRESS1', 'http://tempuri.org/MarsFirm.xsd');
                             
                    Dom.XMLNode address2 = elementsList.getChildElement('ADDRESS2', 'http://tempuri.org/MarsFirm.xsd');
                     
                    Dom.XMLNode address3 = elementsList.getChildElement('ADDRESS3', 'http://tempuri.org/MarsFirm.xsd');
                        
                    Dom.XMLNode address4 = elementsList.getChildElement('ADDRESS4', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.BillingStreet=parseNull(address1.getText().trim())+'\n'
                                               +parseNull(address2.getText().trim())+'\n'
                                               +parseNull(address3.getText().trim())+'\n'
                                               +parseNull(address4.getText().trim());
                    
                    Dom.XMLNode city = elementsList.getChildElement('CITY', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.BillingCity=parseNull(city.getText());
                    
                    Dom.XMLNode state = elementsList.getChildElement('STATE_ID', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.BillingStateCode=parseNull(state.getText());
                    
                    Dom.XMLNode zip = elementsList.getChildElement('ZIP', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.BillingPostalCode=parseNull(zip.getText());
                      
                    Dom.XMLNode country = elementsList.getChildElement('COUNTRY_CD', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.BillingCountryCode=parseNull(country.getText());
                    firmObject.SfdcLastUpdateType__c='F';
                    firmObject.SfdcLastActionFrom__c=null;         
                    firmObject.RecordTypeId=marsAccountRecordType;   
                     
                    lstParseSuccess.add(firmObject);
                }
                catch(exception e)
                {
                    Dom.XMLNode firmId = elementsList.getChildElement('FIRM_ID', 'http://tempuri.org/MarsFirm.xsd');
                    firmObject.MarsFirmId__c =Decimal.valueOf(parsenull(firmId.getText()));
                    firmObject.Description=e.getMessage()+e.getStackTraceString();
                    lstParseFailed.add(firmObject);
                }
            }
            mapFirm.put('Success',lstParseSuccess);
            mapFirm.put('Errors',lstParseFailed);
        }
        return mapFirm;
    }
    
    public static Map<String, List<Account>> ParseOffice(String OfficeXML)
    {
        Id marsAccountRecordType=MarsUtility.AccountRecordType;
        Map<String, List<Account>> mapOffice = new Map<String, List<Account>>();
        
        List<Account> lstParseSuccess=new List<Account>();
        List<Account> lstParseFailed =new List<Account>();
        
        Account accountObject;
        
        //Creating the dom.document object to parse the input xml
        Dom.document doc = new Dom.document();
         
        //Passing string to the XML Parser class for getting the values
        doc.load(OfficeXML);
       
        Dom.XMLNode Office = doc.getRootElement().getChildElement('OFFICE' , 'http://tempuri.org/MarsOffice.xsd');
        if(Office != Null )
        {
            for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
            {
                accountObject=new Account();
                
                try
                {
                    //Mars OfficeId
                    Dom.XMLNode officeId = elementsList.getChildElement('OFFICE_ID', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.MarsOfficeId__c=Decimal.valueOf(officeId.getText());

                    Dom.XMLNode externalOfficeId = elementsList.getChildElement('EXTERNAL_OFFICE_ID', 'http://tempuri.org/MarsOffice.xsd');
                    if(externalOfficeId.getText().length()>0)
                    {
                        accountObject.Id=parseNull(externalOfficeId.getText());
                    }
                    
                    Dom.XMLNode externalFirmId = elementsList.getChildElement('EXTERNAL_FIRM_ID', 'http://tempuri.org/MarsOffice.xsd');
                    Dom.XMLNode HomeOfficeFlagNode = elementsList.getChildElement('HOME_OFF_FLAG', 'http://tempuri.org/MarsOffice.xsd'); 
                    if((HomeOfficeFlagNode.getText()) == 'N')
                    {                       
                       if(externalFirmId.getText().length()>0)
                       {
                            System.debug('\n External Field Value:'+externalFirmId.getText());
                            accountObject.ParentId=parseNull(externalFirmId.getText());
                            accountObject.MarsFirmType__c=null;
                            accountObject.MarsCrdId__c=null;
                            accountObject.MarsFirmNm__c= null;
                            accountObject.MarsFirmComment__c=null;
                            accountObject.MarsShortNm__c=null;
                            //accountObject.MARSFirmStatCd__c=null;
                            //accountObject.MarsOfficeStatCd__c = null;
                            accountObject.MarsGeoConc__c=null;
                            accountObject.MarsNsccFirmNbr__c=null;
                            accountObject.MarsNbrOfRegStates__c=null;
                            accountObject.MarsSalesGoalAmt__c=null;
                            accountObject.MarsSdrFlg__c=null;
                            accountObject.MarsFirmWebsite__c=null;
                            accountObject.MarsLastFirmNoteDt__c=null;
                       }
                    }
                    else
                    {
                       if((externalOfficeId.getText().length()==0) && (externalFirmId.getText().length()>0))
                       {
                           accountObject.Id=parseNull(externalFirmId.getText());
                       }
                    }
                    
                    //Mars FirmId
                    Dom.XMLNode firmId = elementsList.getChildElement('FIRM_ID', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.MarsFirmId__c =parseDecimal(firmId.getText());
                    
                    Dom.XMLNode firmname = elementsList.getChildElement('FIRM_NM', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.MarsFirmNm__c =firmname.getText();
                    
                    Dom.XMLNode officeManagerId = elementsList.getChildElement('OFFICE_MANAGER_ID', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.MarsOfficeMgrId__c=parseDecimal(officeManagerId.getText());
                    
                    Dom.XMLNode officeName = elementsList.getChildElement('OFFICE_NM', 'http://tempuri.org/MarsOffice.xsd');

                    if((externalOfficeId.getText().length()>0) && (externalFirmId.getText().length()>0))
                    {
                        MARSDefaults__c defaults=MarsUtility.MARS_DEFAULTS;
                        if(defaults.RetainSFDCAccountName__c==false)
                        {
                            accountObject.Name=parseNull(officeName.getText());
                        }
                    }
                    else
                    {
                        accountObject.Name=parseNull(officeName.getText());
                    }
                    
                    Dom.XMLNode firmTypeOverrideFlg = elementsList.getChildElement('FIRM_TYPE_OVERRIDE_FLG', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.MarsFirmTypeOverrideFlg__c=parseNull(firmTypeOverrideFlg.getText());
                    
                    Dom.XMLNode address1 = elementsList.getChildElement('ADDRESS1', 'http://tempuri.org/MarsOffice.xsd');
                             
                    Dom.XMLNode address2 = elementsList.getChildElement('ADDRESS2', 'http://tempuri.org/MarsOffice.xsd');
                     
                    Dom.XMLNode address3 = elementsList.getChildElement('ADDRESS3', 'http://tempuri.org/MarsOffice.xsd');
                        
                    Dom.XMLNode address4 = elementsList.getChildElement('ADDRESS4', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.BillingStreet=parseNull(address1.getText().trim())+'\n'
                                               +parseNull(address2.getText().trim())+'\n'
                                               +parseNull(address3.getText().trim())+'\n'
                                               +parseNull(address4.getText().trim());

                    Dom.XMLNode city = elementsList.getChildElement('CITY', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.BillingCity=parseNull(city.getText());
                    
                    Dom.XMLNode state = elementsList.getChildElement('STATE_ID', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.BillingStateCode=parseNull(state.getText());
                    
                    Dom.XMLNode zip = elementsList.getChildElement('ZIP', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.BillingPostalCode=parseNull(zip.getText());
                    
                      
                    Dom.XMLNode country = elementsList.getChildElement('COUNTRY_CD', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.BillingCountryCode=parseNull(country.getText());
                
                    Dom.XMLNode primPhone = elementsList.getChildElement('PHONE', 'http://tempuri.org/MarsOffice.xsd');
                    
                    Dom.XMLNode primPhoneExt = elementsList.getChildElement('EXTENSION', 'http://tempuri.org/MarsOffice.xsd');
            
                    if(primPhoneExt.getText().length()>0)
                    {
                        accountObject.Phone= parsePhoneFax(primPhone.getText())+' X' +parseNull(primPhoneExt.getText());
                    }
                    else
                    {
                        accountObject.Phone=parsePhoneFax(primPhone.getText());
                    }
                            
                    Dom.XMLNode primFax = elementsList.getChildElement('FAX', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.Fax=parsePhoneFax(primFax.getText());
                    
                    Dom.XMLNode timeZone = elementsList.getChildElement('TIMEZONE', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.MarsTimeZone__c=parseNull(timeZone.getText());
                    
                    Dom.XMLNode lastMtGdt = elementsList.getChildElement('LAST_MEETING_DATE', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.MarsLastMeetingDt__c=parseDateTime(lastMtGdt.getText());
                    
                    Dom.XMLNode statusCode = elementsList.getChildElement('STATUS_CD', 'http://tempuri.org/MarsOffice.xsd');             
                    accountObject.MarsOfficeStatCd__c=parseNull(statusCode.getText());
                    
                    Dom.XMLNode officeDescription = elementsList.getChildElement('OFFICE_COMMENT', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.MarsOfficeComments__c=parseNull(officeDescription.getText());

                    Dom.XMLNode officeFirmType = elementsList.getChildElement('OFFICE_FIRM_TYPE', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.MarsOffFirmType__c=parseNull(officeFirmType.getText()); 
                    
                    Dom.XMLNode statusUpdateDate = elementsList.getChildElement('STATUS_UPDATE_DATE', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.MarsOfficeStatUpdDt__c=parseDateTime(statusUpdateDate.getText());
                    
                    Dom.XMLNode latitude = elementsList.getChildElement('LATITUDE', 'http://tempuri.org/MarsOffice.xsd');
                    if(parseDecimal(latitude.getText()) != 9999.99 )
                    accountObject.BillingLatitude=parseDecimal(latitude.getText());
                     
                    Dom.XMLNode longitude = elementsList.getChildElement('LONGITUDE', 'http://tempuri.org/MarsOffice.xsd');
                    if(parseDecimal(longitude.getText()) != 9999.99 )
                        accountObject.BillingLongitude=parseDecimal(longitude.getText());
                    
                    Dom.XMLNode lastSaleDate = elementsList.getChildElement('LAST_SALE_DT', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.MarsLastSaleDt__c=parseDate(lastSaleDate.getText());
                    
                    Dom.XMLNode website = elementsList.getChildElement('WEB_SITE', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.Website=parseNull(website.getText());
                    
                    accountObject.SfdcLastUpdateType__c='O';
                    accountObject.RecordTypeId=marsAccountRecordType;
                        
                    lstParseSuccess.add(accountObject);
                }
                catch(exception e)
                {
                    Dom.XMLNode officeId = elementsList.getChildElement('OFFICE_ID', 'http://tempuri.org/MarsOffice.xsd');
                    accountObject.MarsOfficeId__c=Decimal.valueOf(parseNull(officeId.getText()));
                    accountObject.Description=e.getMessage()+e.getStackTraceString();
                    System.debug(e.getMessage()+e.getStackTraceString());
                    
                    lstParseFailed.add(accountObject);                    
                }
            }
            mapOffice.put('Success',lstParseSuccess);
            mapOffice.put('Errors',lstParseFailed);
        }  
        return mapOffice;      
    }
    
    public static Map<String, List<Contact>> ParseRep(String RepXML)
    {
        Id marsContactRecordType=MarsUtility.ContactRecordType;
        Map<String, List<Contact>> mapRep = new Map<String, List<Contact>>();
        
        // Creating the list object to get reps from the composite xml
        List<Contact> lstParseSuccess=new List<Contact>();
        List<Contact> lstParseFailed=new List<Contact>();
        Contact objContact;
    
        //Creating the dom.document object to parse the input xml
        Dom.document doc = new Dom.document();
     
        //Passing string to the XML Parser class for getting the values
        doc.load(RepXML);
        
        System.debug(RepXML);
        Dom.XMLNode root = doc.getRootElement().getChildElement('REP' , 'http://tempuri.org/MarsRep1.xsd');
        if(root !=NULL)
        { 
            for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
            {
                objContact=new Contact();
                try
                {   
                    // Mars Repid
                    Dom.XMLNode repId = elementsList.getChildElement('REP_ID', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsRepId__c =Decimal.valueOf(parseNull(repId.getText()));
                    
                    //Mars FirmId
                    Dom.XMLNode firmId = elementsList.getChildElement('FIRM_ID', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsFirmId__c =Decimal.valueOf(parseNull(firmId.getText()));
                    
                    Dom.XMLNode externalOfficeId = elementsList.getChildElement('EXTERNAL_OFF_ID', 'http://tempuri.org/MarsRep1.xsd');
                    
                    if(externalOfficeId.getText().length()>0)
                    {
                        objContact.AccountId =parseNull(externalOfficeId.getText());
                    }
                    
                    if(String.IsEmpty(objContact.AccountId))
                        throw new MarsException('Mars Account Should not be null');
                    
                    Dom.XMLNode externalRepId = elementsList.getChildElement('EXTERNAL_REP_ID', 'http://tempuri.org/MarsRep1.xsd');
                    if(externalRepId.getText().length()>0)
                    {
                        objContact.Id =parseNull(externalRepId.getText());
                    }
                    
                    //Mars OfficeId
                    Dom.XMLNode offId = elementsList.getChildElement('OFF_ID', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsOfficeId__c=Decimal.valueOf(parseNull(offId.getText()));
                    
                    //Rep First Name
                    Dom.XMLNode firstName = elementsList.getChildElement('FIRST_NM', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsFirstNm__c= parseNull(firstName.getText());
                    if(parseNull(firstName.getText()).length() > 40)
                    {
                        objContact.FirstName= parseNull(firstName.getText()).subString(0,40);
                    }
                    else
                        objContact.FirstName= parseNull(firstName.getText());                    
                    
                    //Rep Last Name
                    Dom.XMLNode lastName = elementsList.getChildElement('LAST_NM', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.LastName= parseNull(lastName.getText());
                    
                    // Rep Title
                    Dom.XMLNode title = elementsList.getChildElement('TITLE', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.Title= parseNull(title.getText());
                    
                    // Rep Salutatioin
                    Dom.XMLNode salutation = elementsList.getChildElement('SALUTATION', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.Salutation= parseNull(salutation.getText());
                    
                    //Rep Mobile
                    Dom.XMLNode mobile= elementsList.getChildElement('PRIM_MOBILE', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MobilePhone= parsePhoneFax(mobile.getText());
                    
                    // Rep Birth Month Day
                    Dom.XMLNode birthmd = elementsList.getChildElement('BIRTH_MMDD', 'http://tempuri.org/MarsRep1.xsd');
                    if(parseNull(birthmd.getText()).length()>0 )
                    {
                        String month,day;    
                        if(birthmd.getText().length() ==3)
                        {
                         day=birthmd.getText().substring(1,3);  
                         month=birthmd.getText().substring(0,1); 
                        } 
                        else 
                        {
                            if(birthmd.getText().length() ==4)
                            {
                                day=birthmd.getText().substring(2,4);
                                month=birthmd.getText().substring(0,2);
                            }   
                        }
                    
                        // Rep Birth Year
                        Dom.XMLNode birthyear = elementsList.getChildElement('BIRTH_YYYY', 'http://tempuri.org/MarsRep1.xsd');
                        if(parseNull(birthyear.getText()).length()>0 && month != null && day != null)
                        {  
                            Integer intBirthyear=Integer.valueOf(birthyear.getText());
                            if(intBirthyear > 1900)
                            {
                            objContact.Birthdate= Date.valueOf(parseNull(birthyear.getText()+'-'+month+'-'+day));
                            }
                        }   
                    }
                    else{
                        objContact.Birthdate= null;
                    }
                    
                    // Rep Nick Name
                    Dom.XMLNode nickNM = elementsList.getChildElement('NICK_NM', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsNickNm__c= parseNull(nickNM.getText());
                    
                     // Rep Spouse Name
                    Dom.XMLNode spouseNM = elementsList.getChildElement('SPOUSE_NM', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsSpouseNm__c= parseNull(spouseNM.getText());
                    
                    // Rep Personal Info
                    Dom.XMLNode personalInfo = elementsList.getChildElement('PERSONAL_INFO', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsPersonalInfo__c= parseNull(personalInfo.getText());
                    
                    // Rep First Sale Date
                    Dom.XMLNode firstSaleDt = elementsList.getChildElement('FIRST_SALE_DT', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsFirstSaleDt__c=parseDate(firstSaleDt.getText());
    
                    // Rep Assistant Name
                    Dom.XMLNode asstnm = elementsList.getChildElement('ASST_NM', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.AssistantName= parseNull(asstnm.getText());
                    
                    // Rep Last Sale Date
                    Dom.XMLNode lastSaleDt = elementsList.getChildElement('LAST_SALE_DT', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsLastSaleDt__c=parseDate(lastSaleDt.getText());
                    
                    // Rep Last Meeting Date
                    Dom.XMLNode lastmtgdt = elementsList.getChildElement('LAST_MTG_DT', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsLastMeetingDt__c=parseDateTime(lastmtgdt.getText());
                    
                    Dom.XMLNode lastCallDt = elementsList.getChildElement('LAST_CALL_DT', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsLastCallDt__c=parseDateTime(lastCallDt.getText());
                    
                    Dom.XMLNode lastNoteDt = elementsList.getChildElement('LAST_NOTE_DT', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsLastNoteDt__c=parseDateTime(lastNoteDt.getText());
                    
                    Dom.XMLNode lastfulfillmentDt = elementsList.getChildElement('LAST_FULFILLMENT_DT', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsLastFulfillmentDt__c=parseDateTime(lastfulfillmentDt.getText());
                    
                    Dom.XMLNode lastLetterDt = elementsList.getChildElement('LAST_LETTER_DT', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsLastLetterDt__c=parseDateTime(lastLetterDt.getText());
                    
                    Dom.XMLNode mailList = elementsList.getChildElement('MAIL_LIST', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsMailList__c=parseNull(mailList.getText());
                   
                    // Rep Address 1
                    Dom.XMLNode address1 = elementsList.getChildElement('ADDR1', 'http://tempuri.org/MarsRep1.xsd');
                    
                    // Rep Address 2
                    Dom.XMLNode address2 = elementsList.getChildElement('ADDR2', 'http://tempuri.org/MarsRep1.xsd');
                    
                    // Rep Address 3
                    Dom.XMLNode address3 = elementsList.getChildElement('ADDR3', 'http://tempuri.org/MarsRep1.xsd');
                    
                    // Rep Address 4
                    Dom.XMLNode address4 = elementsList.getChildElement('ADDR4', 'http://tempuri.org/MarsRep1.xsd');
                    String strmailingStreet=parseNull(address1.getText().trim()) + '\n'
                                             +parseNull(address2.getText().trim()) +'\n'
                                             +parseNull(address3.getText().trim()) + '\n'
                                             +parseNull(address4.getText().trim());
                                             
                    
                    //Rep City
                    Dom.XMLNode mailingCity = elementsList.getChildElement('CITY', 'http://tempuri.org/MarsRep1.xsd');
                    String strMailingCity=parseNull(mailingCity.getText());
                    
                    // Rep State
                    Dom.XMLNode mailingState = elementsList.getChildElement('STATE_ID', 'http://tempuri.org/MarsRep1.xsd');
                    String strMailingStateCode=parseNull(mailingState.getText());
                    
                    // Rep Postalcode 
                    Dom.XMLNode mailingPostalCode = elementsList.getChildElement('ZIP', 'http://tempuri.org/MarsRep1.xsd');
                    String strMailingPostalCode=parseNull(mailingPostalCode.getText());       
                  
                    // Rep Country
                    Dom.XMLNode mailingCountry = elementsList.getChildElement('COUNTRY_CD', 'http://tempuri.org/MarsRep1.xsd');
                    String strMailingCountryCode=parseNull(mailingCountry.getText());                    
                    
                    MARSDefaults__c defaults=MarsUtility.MARS_DEFAULTS;
                    if(defaults.CustomContactAddress__c)
                    {
                        objContact.MarsCountryCd__c = strMailingCountryCode;
                        objContact.MarsCity__c = strMailingCity;
                        objContact.MarsAddress__c = strmailingStreet;
                        objContact.MarsStateId__c = strMailingStateCode;
                        objContact.MarsZip__c = strMailingPostalCode;
                    }
                    if((externalRepId.getText().length() == 0 && defaults.customContactAddress__c)||(!defaults.customContactAddress__c))
                    {
                        objContact.MailingCountryCode = strMailingCountryCode;
                        objContact.MailingCity = strMailingCity;
                        objContact.MailingStreet = strmailingStreet;
                        objContact.MailingStateCode = strMailingStateCode;
                        objContact.MailingPostalCode = strMailingPostalCode;
                    }                    
                    
                    // Rep Primary Phone
                    Dom.XMLNode primPhone = elementsList.getChildElement('PRIM_PHONE', 'http://tempuri.org/MarsRep1.xsd');
                    
                    // Rep Prim Phone Extension
                    Dom.XMLNode primPhoneExt = elementsList.getChildElement('PRIM_PHONE_EXT', 'http://tempuri.org/MarsRep1.xsd');
                    if(primPhoneExt.getText().length()>0)
                    {                    
                        objContact.Phone=parsePhoneFax(primPhone.getText()) +' X'+parseNull(primPhoneExt.getText());
                    }
                    else
                        objContact.Phone=parsePhoneFax(primPhone.getText());
                    
                    // Rep Primary Fax
                    Dom.XMLNode primFax = elementsList.getChildElement('PRIM_FAX', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.Fax=parsePhoneFax(primFax.getText());                    
                    
                    Dom.XMLNode timeZone = elementsList.getChildElement('TIME_ZONE', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsTimeZone__c=parseNull(timeZone.getText());
                    
                    // Rep Staff Code
                    Dom.XMLNode RepStaffCode = elementsList.getChildElement('REP_STAFF_CD', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsRepStaffCd__c=parseNull(RepStaffCode.getText());
                    
                    //Rep Stat Code
                    Dom.XMLNode statCd = elementsList.getChildElement('STAT_CD', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsStatCd__c=parseNull(statCd.getText());
                    
                    //Rep Email
                    //BUG73507 If Multiple Emails in the gettng only the first email.
                    Dom.XMLNode emailId = elementsList.getChildElement('EMAIL_ID', 'http://tempuri.org/MarsRep1.xsd');
                    if(emailId.getText().length()>0)
                    {
                        //System.debug('Email Value:'+emailId.getText());
                        if(emailId.getText().contains(';'))
                        {
                            String[] Emails=emailId.getText().split(';');
                            objContact.Email=Emails[0];
                        }
                        else
                        {
                            //BUG73507 Bug Reopened.
                            objContact.Email=parseNull(emailId.getText());
                        }
                    }
                    else
                    {
                        //BUG73507 Bug Reopened.
                        objContact.Email=parseNull(emailId.getText());
                    }

                    //BUG73507 If Multiple Emails in the gettng only the first email.
                    Dom.XMLNode Email2 = elementsList.getChildElement('EMAIL_ID2', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsEmailId2__c=parseNull(Email2.getText());          
                    
                    //Rep Comments
                    Dom.XMLNode repComment = elementsList.getChildElement('REP_COMMENT', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsRepComments__c=parseNull(repComment.getText());

                     //Rep Prefix name
                    Dom.XMLNode PrefixName = elementsList.getChildElement('PREFIX_NM', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsPrefixNm__c=parseNull(PrefixName.getText());
                    
                    //REp Middle Name
                    Dom.XMLNode middleName = elementsList.getChildElement('MIDDLE_NM', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsMiddleNm__c=parseNull(middleName.getText());
                    
                     //Rep Sufix name
                    Dom.XMLNode sufixName = elementsList.getChildElement('SUFFIX_NM', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsRepSuffixNm__c=parseNull(sufixName.getText());
                    
                    //Rep Firm Type 
                    Dom.XMLNode RepFirmType = elementsList.getChildElement('REP_FIRM_TYPE', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsRepFirmType__c=parseNull(RepFirmType.getText());
                    
                    Dom.XMLNode firmTypeOverrideFlg = elementsList.getChildElement('FIRM_TYPE_OVERRIDE_FLG', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsFirmTypeOverrideFlg__c=parseNull(firmTypeOverrideFlg.getText()); 
                    
                    Dom.XMLNode statupddt = elementsList.getChildElement('STAT_UPD_DT', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsStatUpdDt__c=parseDateTime(statupddt.getText());
                    
                    Dom.XMLNode allowMailing = elementsList.getChildElement('ALLOW_MAILINGS', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsAllowMailings__c=parseNull(allowMailing.getText());
                    
                    Dom.XMLNode firstsaleprocess = elementsList.getChildElement('FIRST_SALE_PROCESS_DT', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsFirstSaleProcessDt__c=parseDate(firstsaleprocess.getText());
                    
                    //Rep Crd Id
                    Dom.XMLNode crdId = elementsList.getChildElement('CRD_ID', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsCrdId__c=parseNull(crdId.getText());
                    
                    if(crdId.getText().length()>0 && externalRepId.getText().length()==0)
                    {
                        MarsUtility.repCRDId.add(crdId.getText());
                    }
                    
                    //Mailing Latitude: value outside of valid range on numeric field: 9999.99
                    Dom.XMLNode latitude = elementsList.getChildElement('LATITUDE', 'http://tempuri.org/MarsRep1.xsd');
                    if(parseDecimal(latitude.getText()) != 9999.99 )
                    objContact.MailingLatitude=parseDecimal(latitude.getText());
                    
                    //Mailing Latitude: value outside of valid range on numeric field: 9999.99
                    Dom.XMLNode longitude = elementsList.getChildElement('LONGITUDE', 'http://tempuri.org/MarsRep1.xsd');
                    if(parseDecimal(longitude.getText()) != 9999.99 )
                    objContact.MailingLongitude=parseDecimal(longitude.getText());
                    
                    Dom.XMLNode addrLock = elementsList.getChildElement('ADDRESS_LOCKED' , 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsAddrLock__c=parseNull(addrLock.getText());
                    
                    objContact.RecordTypeId=marsContactRecordType;
     
                    // add parsed contact object to list                                
                    lstParseSuccess.add(objContact);                    
                }
                catch(exception e){
                    Dom.XMLNode repId = elementsList.getChildElement('REP_ID', 'http://tempuri.org/MarsRep1.xsd');
                    objContact.MarsRepId__c =Decimal.valueOf(parseNull(repId.getText()));
                    System.debug('Error In Rep :'+e.getStackTraceString()+'--'+e.getCause()+'--'+e.getmessage());
                    objContact.Description=e.getStackTraceString()+'--'+e.getCause()+'--'+e.getmessage();
                    lstParseFailed.add(objContact);
                }
            }
            mapRep.put('Success',lstParseSuccess);   
            mapRep.put('Errors', lstParseFailed);
        }
        //returning list of contacts.
        return mapRep;
    }    
    
    
    public static Map<String, List<MarsRepTeam__c>> ParseTeamRep(String teamRepXML)
    {
        Id marsRepTeamRecordType=MarsUtility.RepTeamRecordType;
        Map<String, List<MarsRepTeam__c>> mapRep = new Map<String, List<MarsRepTeam__c>>();
        
        // Creating the list object to get reps from the composite xml
        List<MarsRepTeam__c> lstParseSuccess=new List<MarsRepTeam__c>();
        List<MarsRepTeam__c> lstParseFailed=new List<MarsRepTeam__c>();
        MarsRepTeam__c objteamRep;
    
        //Creating the dom.document object to parse the input xml
        Dom.document doc = new Dom.document();
     
        //Passing string to the XML Parser class for getting the values
        doc.load(teamRepXML);        
        
        System.debug('teamRepXML'+teamRepXML);
        Dom.XMLNode root = doc.getRootElement().getChildElement('TEAM_REP' , 'http://tempuri.org/MarsTeamRep.xsd');
        if(root !=NULL)
        { 
            for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
            {
                objteamRep=new MarsRepTeam__c();
                try
                {
                     objteamRep.RecordTypeId=marsRepTeamRecordType;
                     Dom.XMLNode repId = elementsList.getChildElement('REP_ID', 'http://tempuri.org/MarsTeamRep.xsd');
                     objteamRep.MarsRepId__c =Decimal.valueOf(parseNull(repId.getText()));
                     
                     Dom.XMLNode teamRepId = elementsList.getChildElement('TEAM_REP_ID', 'http://tempuri.org/MarsTeamRep.xsd');
                     objteamRep.MarsTeamRepId__c =Decimal.valueOf(parseNull(teamRepId.getText()));
                     
                     Dom.XMLNode splitPercent = elementsList.getChildElement('SPLIT_PERCENT', 'http://tempuri.org/MarsTeamRep.xsd');
                     if(String.isNotBlank(splitPercent.getText()))
                     objteamRep.MarsSplitPercent__c =Decimal.valueOf(parseNull(splitPercent.getText()));
                     
                     Dom.XMLNode externalTeamRepId = elementsList.getChildElement('EXTERNAL_TEAM_ID', 'http://tempuri.org/MarsTeamRep.xsd');
                     if(String.isNotBlank(externalTeamRepId.getText()))
                     objteamRep.SfdcTeamRepId__c =parseNull(externalTeamRepId.getText());
                     
                     Dom.XMLNode externalRepId = elementsList.getChildElement('EXTERNAL_REP_ID', 'http://tempuri.org/MarsTeamRep.xsd');
                     if(String.isNotBlank(externalRepId.getText()))
                     objteamRep.SfdcRepId__c =parseNull(externalRepId.getText());
                     
                     Dom.XMLNode externalTeamId = elementsList.getChildElement('EXTERNAL_ID', 'http://tempuri.org/MarsTeamRep.xsd');
                     if(String.isNotBlank(externalTeamId.getText()))
                     objteamRep.Id =parseNull(externalTeamId.getText());
                     
                    lstParseSuccess.add(objteamRep);                    
                }
                catch(exception e){
                    Dom.XMLNode teamRepId = elementsList.getChildElement('TEAM_REP_ID', 'http://tempuri.org/MarsTeamRep.xsd');
                    objteamRep.MarsTeamRepId__c = Decimal.valueOf(parseNull(teamRepId.getText()));
                    System.debug('Error In Rep :'+e.getStackTraceString()+'--'+e.getCause()+'--'+e.getmessage());
                    objteamRep.Name=e.getStackTraceString()+'--'+e.getCause()+'--'+e.getmessage();
                    lstParseFailed.add(objteamRep);
                }
            }
            mapRep.put('Success',lstParseSuccess);   
            mapRep.put('Errors', lstParseFailed);
        }

        return mapRep;
    }      
    
    public static Map<String, List<Product2>> parseProduct(String ProductXML)
    {
        Map<String, List<Product2>> mapProducts = new Map<String, List<Product2>>();
        Id marsProductRecordType=MarsUtility.ProductRecordType;
        List<Product2> lstParseSuccess=new List<Product2>();
        List<Product2> lstParseFailed=new List<Product2>();
        Product2 product;
        try{
            
            System.debug('\n ProductXML: '+ProductXML);
            
            Dom.document doc = new Dom.document();
            doc.load(ProductXML);
            
            Dom.XMLNode root = doc.getRootElement().getChildElement('PRODUCT', 'http://tempuri.org/MarsProduct.xsd');
            if(root !=NULL)
            {        
                for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
                {
                    product=new Product2();
                    try{          
                    
                        product.RecordTypeId=MarsUtility.ProductRecordType;           
                        Dom.XMLNode productCode = elementsList.getChildElement('PROD_CD', 'http://tempuri.org/MarsProduct.xsd');
                        if(parseNull(productCode.getText()) == '')throw new MarsException('Prod code cannot be null');
                        product.MarsProdCd__c=parseNull(productCode.getText());
                        product.ProductCode=parseNull(productCode.getText());
                        
                        Dom.XMLNode externalProductId = elementsList.getChildElement('EXTERNAL_ID', 'http://tempuri.org/MarsProduct.xsd');
                        if(externalProductId.getText().length()>0)
                        {
                            product.Id =parseNull(externalProductId.getText());
                        }
                        
                        Dom.XMLNode prodId = elementsList.getChildElement('PROD_ID', 'http://tempuri.org/MarsProduct.xsd');
                        if(prodId.getText().length()>0)
                        {
                            product.MarsProdId__c =Decimal.valueOf(parseNull(prodId.getText()));
                        }
                        Dom.XMLNode univFundCd = elementsList.getChildElement('UNIV_FUND_CD', 'http://tempuri.org/MarsProduct.xsd'); 
                        product.MarsUnivFundCd__c=parseNull(univFundCd.getText());
                
                        Dom.XMLNode productTitle = elementsList.getChildElement('PROD_TITLE', 'http://tempuri.org/MarsProduct.xsd'); 
                        product.Name =parseNull(productTitle.getText());                    
                                
                        Dom.XMLNode shareClass = elementsList.getChildElement('SHARE_CLASS', 'http://tempuri.org/MarsProduct.xsd');
                        product.MarsShareClass__c=parseNull(shareClass.getText());
                                
                        Dom.XMLNode shareClassDesc = elementsList.getChildElement('SHARE_CLASS_DESC', 'http://tempuri.org/MarsProduct.xsd');
                        product.MarsShareClassDesc__c=parseNull(shareClassDesc.getText());
                       
                        Dom.XMLNode productType = elementsList.getChildElement('PROD_TYPE', 'http://tempuri.org/MarsProduct.xsd');
                        product.MarsProdType__c=parseNull(productType.getText());
                       
                        Dom.XMLNode productTypeDesc = elementsList.getChildElement('PROD_TYPE_DESC', 'http://tempuri.org/MarsProduct.xsd');
                        product.MarsProdTypeDesc__c=parseNull(productTypeDesc.getText());
                                                                
                        Dom.XMLNode productGroup = elementsList.getChildElement('PROD_GRP', 'http://tempuri.org/MarsProduct.xsd');
                        product.MarsProdGrp__c=parseNull(productGroup.getText());
                                                                
                        Dom.XMLNode productGroupDesc = elementsList.getChildElement('PROD_GRP_DESC', 'http://tempuri.org/MarsProduct.xsd');
                        product.MarsProdGrpDesc__c=parseNull(productGroupDesc.getText());
                                            
                        Dom.XMLNode productCusip = elementsList.getChildElement('PROD_CUSIP', 'http://tempuri.org/MarsProduct.xsd');
                        product.MarsProdCusip__c= parseNull(productCusip.getText());
                                      
                        Dom.XMLNode fundFamily = elementsList.getChildElement('FUND_FAMILY', 'http://tempuri.org/MarsProduct.xsd');
                        product.MarsFundFamily__c=parseNull(fundFamily.getText());
                                      
                        Dom.XMLNode fundFamilyDesc = elementsList.getChildElement('FUND_FAMILY_DESC', 'http://tempuri.org/MarsProduct.xsd');
                        product.MarsFundFamilyDesc__c=parseNull(fundFamilyDesc.getText());
                                            
                        Dom.XMLNode fundComp = elementsList.getChildElement('FUND_COMP', 'http://tempuri.org/MarsProduct.xsd');
                        product.MarsFundComp__c=parseNull(fundComp.getText());
                                            
                        Dom.XMLNode fundCompDesc = elementsList.getChildElement('FUND_COMP_DESC', 'http://tempuri.org/MarsProduct.xsd');
                        product.MarsFundCompDesc__c=parseNull(fundCompDesc.getText());
                                                  
                        if(Test.isRunningTest()){
                            product.MarsFundCompDesc__c=fundCompDesc.getText().toLowerCase();
                        }
                        product.RecordTypeId=marsProductRecordType;
                        product.isActive=true;
                        lstParseSuccess.add(product);
                    }
                    catch(exception e){
                        
                        Dom.XMLNode prodId = elementsList.getChildElement('PROD_ID', 'http://tempuri.org/MarsProduct.xsd'); 
                        product.MarsProdId__c =Decimal.valueOf(parseNull(prodId.getText()));
                        product.Name=e.getMessage();
                        lstParseFailed.add(product);
                    }
                } 
                mapProducts.put('Success',lstParseSuccess);   
                mapProducts.put('Errors', lstParseFailed);
            }
        }
        catch(Exception e){
            System.debug('\n ProductXML:'+ProductXML);
        }
        return mapProducts;
    }
    
    public static Map<String, List<MarsTerritory__c>> parseTerritory(String TerritoryXML)
    {
        Map<String, List<MarsTerritory__c>> mapTerritory = new Map<String, List<MarsTerritory__c>>();
        List<MarsTerritory__c> lstParseSuccess=new List<MarsTerritory__c>();
        List<MarsTerritory__c> lstParseFailed=new List<MarsTerritory__c>();
        MarsTerritory__c territory;
        try{
            
            Dom.document doc = new Dom.document();
            doc.load(TerritoryXML);
            
            Dom.XMLNode root = doc.getRootElement().getChildElement('TERRITORY_DETAILS', 'http://tempuri.org/MarsTerritoryDetails.xsd');
            if(root !=NULL)
            {        
                for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
                {
                    territory=new MarsTerritory__c();
                    try{          
                    
                        Dom.XMLNode territoryCode = elementsList.getChildElement('TERR_CD', 'http://tempuri.org/MarsTerritoryDetails.xsd');
                        if(parseNull(territoryCode.getText()) == '')throw new MarsException('Territory code cannot be null');
                        territory.MarsTerrCd__c=parseNull(territoryCode.getText());
                        
                        Dom.XMLNode externalterritoryId = elementsList.getChildElement('EXTERNAL_ID', 'http://tempuri.org/MarsTerritoryDetails.xsd');
                        if(externalterritoryId.getText().length()>0)
                        {
                            territory.Id =parseNull(externalterritoryId.getText());
                        }
                        
                        Dom.XMLNode managerName = elementsList.getChildElement('MGR_USRID', 'http://tempuri.org/MarsTerritoryDetails.xsd'); 
                        territory.MarsManagerNm__c=parseNull(managerName.getText());
                
                        Dom.XMLNode wholeSalerName = elementsList.getChildElement('WHOLE_USRID', 'http://tempuri.org/MarsTerritoryDetails.xsd'); 
                        territory.MarsWholesalerNm__c =parseNull(wholeSalerName.getText());                    
                                
                        Dom.XMLNode terrDesc = elementsList.getChildElement('TERR_DESC', 'http://tempuri.org/MarsTerritoryDetails.xsd');
                        territory.Name=parseNull(terrDesc.getText());
                                
                        Dom.XMLNode channel = elementsList.getChildElement('DIST_CHAN_CD', 'http://tempuri.org/MarsTerritoryDetails.xsd');
                        territory.MarsChannel__c=parseNull(channel.getText());
                       
                        //Dom.XMLNode updatedate = elementsList.getChildElement('UPD_DT', 'http://tempuri.org/MarsTerritoryDetails.xsd');
                        //territory.MarsUpdDt__c=parseDateTime(updatedate.getText());
                        territory.MarsUpdDt__c=DateTime.now();
                       
                        Dom.XMLNode internalName = elementsList.getChildElement('TELE_USRID', 'http://tempuri.org/MarsTerritoryDetails.xsd');
                        territory.MarsInternalNm__c=parseNull(internalName.getText());
                                                                
                        Dom.XMLNode effectiveDate = elementsList.getChildElement('EFF_DT', 'http://tempuri.org/MarsTerritoryDetails.xsd');
                        territory.MarsEffDt__c=parseDate(effectiveDate.getText());
                                                                
                        lstParseSuccess.add(territory);
                    }
                    catch(exception e){
                        
                        Dom.XMLNode terrcode = elementsList.getChildElement('TERR_CD', 'http://tempuri.org/MarsTerritoryDetails.xsd'); 
                        territory.MarsTerrCd__c =parseNull(terrcode.getText());
                        territory.Name=e.getMessage();
                        lstParseFailed.add(territory);
                    }
                } 
                mapTerritory.put('Success',lstParseSuccess);   
                mapterritory.put('Errors', lstParseFailed);
            }
        }
        catch(Exception e){
            System.debug('\n territoryXML:'+territoryXML);
            System.debug(e.getMessage()+'-'+e.getStackTraceSTring());
        }
        return mapTerritory;
    }

    public static Map<String, List<MarsCd__c>> parseFirmType(String FirmTypeXML)
    {
        Map<String, List<MarsCd__c>> mapFirmType = new Map<String, List<MarsCd__c>>();
        List<MarsCd__c> lstParseSuccess=new List<MarsCd__c>();
        List<MarsCd__c> lstParseFailed=new List<MarsCd__c>();
        MarsCd__c CodeValues;
        
        Dom.document doc = new Dom.document();
        doc.load(FirmTypeXML);
        Dom.XMLNode root = doc.getRootElement();
        String namespace='http://tempuri.org/MarsFirmType.xsd';
        if(root !=NULL)
        {
            for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
            {
                CodeValues=new MarsCd__c();
                try{  
                    System.debug('Element List Value:'+elementsList);                      
                    Dom.XMLNode cdCode = elementsList.getChildElement('CODE', namespace);
                    System.debug('Code Value:'+cdCode.getText());
                    if(parseNull(cdCode.getText()) == '')throw new MarsException('Firm Type Code cannot be null'); 
                    CodeValues.MarsCdCd__c=parseNull(cdCode.getText());
                    
                    CodeValues.MarsCdType__c='FTY';
                    
                    CodeValues.MarsCdTypeCd__c='FTY' + parseNull(cdCode.getText());
            
                    Dom.XMLNode codeDesc = elementsList.getChildElement('DESCRIPTION', namespace); 
                    CodeValues.Name =parseNull(codeDesc.getText());
                            
                    lstParseSuccess.add(CodeValues);
                }
                catch(exception e){
                    Dom.XMLNode cdCode = elementsList.getChildElement('CODE', namespace); 
                    CodeValues.MarsCdCd__c=parseNull(cdCode.getText());
                    CodeValues.Name=e.getMessage();
                    lstParseFailed.add(CodeValues);
                }
            } 
            mapFirmType.put('Success',lstParseSuccess);   
            mapFirmType.put('Errors', lstParseFailed);
        }
        return mapFirmType;
    }
    
    public static Map<String, List<Sobject>> parseDelete(String deleteXML)
    { 
        Dom.document doc = new Dom.document();

        Map<String, List<SObject>> mapDeleteRecords = new Map<String, List<SObject>>();
        List<SObject> lstDeleteRecords=new List<SObject>();
        List<SObject> lstErrorRecords=new List<SObject>();

        Account officeObject;
        Contact repObject;
        MarsRepTeam__c objteamRep;
        
        String objectType;
        //Sample xml  <MarsDataset><Rep><FIRM_ID></FIRM_ID><OFF_ID></OFF_ID><REP_ID></REP_ID></Rep></MarsDataset>
        //Passing string to the XML Parser sclass for getting the values
        doc.load(deleteXML);
        System.debug('\nDelete xml'+deleteXML);
        Dom.XMLNode root = doc.getRootElement();

        if(root !=NULL)
        {
            if(doc.getRootElement().getChildElement('Rep', null) != null){
                objectType = 'Rep';
            }
            else if(doc.getRootElement().getChildElement('Office', null) != null){
                objectType = 'Office';
            }
            else if(doc.getRootElement().getChildElement('TeamRep', null) != null){
                objectType = 'TeamRep';
            }

            if(objectType == 'Office')
            {
                for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
                {
                    officeObject= new Account();
                    try
                    {
                        Dom.XMLNode marsOfficeId = elementsList.getChildElement('OFF_ID', null);
                        System.debug('\n Mars Office ID'+marsOfficeId);
                        Dom.XMLNode SFDCOfficeId = elementsList.getChildElement('EXTERNAL_ID', null);
                        officeObject.MarsOfficeId__c = parseDecimal(marsOfficeId.GetText());
                        System.debug('\n Text Id value:'+SFDCOfficeId.GetText());
                        if(SFDCOfficeId.GetText().length() == 0){
                            officeObject.Description = 'External Id not found in SFDC';
                            lstErrorRecords.add(officeObject);
                        }
                        else{
                            officeObject.Id = SFDCOfficeId.GetText();
                            lstDeleteRecords.add(officeObject);
                        }
                    }
                    catch(Exception e)
                    {
                        Dom.XMLNode marsOfficeId = elementsList.getChildElement('OFF_ID', null);
                        officeObject.MarsOfficeId__c = parseDecimal(marsOfficeId.GetText());
                        officeObject.Description = e.getMessage()+e.getStackTraceString();
                        lstErrorRecords.add(officeObject);
                    }
                }
            }
            else if(objectType == 'Rep')
            {
                
                for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
                {
                    System.debug('\n Rep Child Elements'+elementsList);
                    repObject= new Contact();
                    try
                    {
                        Dom.XMLNode marsRepId = elementsList.getChildElement('REP_ID', null);
                        System.debug('\n Mars ID'+marsrepId);
                        Dom.XMLNode SFDCRepId = elementsList.getChildElement('EXTERNAL_ID', null);
                        repObject.MarsRepId__c = parseDecimal(marsRepId.GetText());
                        if(SFDCRepId.GetText().length() == 0){
                            repObject.Description = 'External Id not found in SFDC';
                            lstErrorRecords.add(repObject);
                        }
                        else{
                            repObject.Id = SFDCRepId.GetText();
                            lstDeleteRecords.add(repObject);
                        }
                    }
                    catch(Exception e){
                        Dom.XMLNode marsRepId = elementsList.getChildElement('REP_ID', null);
                        repObject.MarsRepId__c = parseDecimal(marsRepId.GetText());
                        repObject.Description = e.getMessage();
                        lstErrorRecords.add(repObject);
                    }
                }
            }
            else if(objectType == 'TeamRep'){
            
                for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
                {
                    objteamRep= new MarsRepTeam__c();
                    try
                    {
                        Dom.XMLNode marsTeamRepId = elementsList.getChildElement('TEAM_REP_ID', null);
                        Dom.XMLNode marsRepId = elementsList.getChildElement('REP_ID', null);
                        Dom.XMLNode SFDCTeamRepId = elementsList.getChildElement('EXTERNAL_ID', null);
                        objteamRep.MarsRepId__c = parseDecimal(marsRepId.GetText());
                        objteamRep.MarsTeamRepId__c = parseDecimal(marsTeamRepId.GetText());
                        if(SFDCTeamRepId.GetText().length() == 0){
                            objteamRep.Name= 'External Id not found in SFDC';
                            lstErrorRecords.add(objteamRep);
                        }
                        else{
                            objteamRep.Id = SFDCTeamRepId.GetText();
                            lstDeleteRecords.add(objteamRep);
                        }
                    }
                    catch(Exception e){
                        Dom.XMLNode teamRepId = elementsList.getChildElement('TEAM_REP_ID', null);
                        objteamRep.MarsTeamRepId__c = Decimal.valueOf(parseNull(teamRepId.getText()));
                        objteamRep.Name=e.getStackTraceString()+'--'+e.getCause()+'--'+e.getmessage();
                        lstErrorRecords.add(objteamRep);
                    }
                }
            
            }
            System.debug('\n Error Records:'+lstErrorRecords);
            System.debug('\n Success Records:'+lstDeleteRecords);
            mapDeleteRecords.put(objectType+'Errors',lstErrorRecords);
            mapDeleteRecords.put(objectType+'Success',lstDeleteRecords);
        }        
        return mapDeleteRecords;
    }

    public static String parseNull(String value)
    {        
        //Return blank if value is null
        if(value == null)
            return '';
        
        //return original value
        return value;
    }

    public static Decimal parseDecimal(String value)
    {
        if(value.length() > 0 )
        {
            //Decimal decimalValue=Decimal.valueOf(value);
            return Decimal.valueOf(value);
        }
        else
        {
            return null;
        }
    }   

    public static Date parseDate(String datetimevalue)
    {
        if(datetimevalue.length() > 0 )
        {
            String[] formatdate=dateTimevalue.split(' ');
            Date dateValue=Date.parse(formatdate[0]);
            return dateValue;
        }
        else
        {
            return null;
        }
    }    

    public static Datetime parseDateTime(String dateTimevalue)
    {
        if(dateTimevalue.length() > 0 )
        {
            String[] formatdate=dateTimevalue.split(' ');
            Date dateValue=Date.parse(formatdate[0]);
            String dateTimeString=String.valueOf(dateValue)+' '+formatdate[1];
            return Datetime.valueOf(dateTimeString);
        }
        else
        {
            return null;
        }
    }
    
     public static String parsePhoneFax(String value) {

        if(value.isNumeric() && value.length() ==10){
            value='('+value.substring(0,3)+')'+' '+value.substring(3,6)+'-'+value.subString(6,value.length());
        }else if(value.isNumeric() && value.length() ==11 && value.subString(0,1) == '1'){
                value='('+value.substring(1,4)+')'+' '+value.substring(4,7)+'-'+value.subString(7,value.length());
        }
         
        //Return blank if value is null
        if(value == null)
            return '';
        return value;
    } 
}