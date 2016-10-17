/** Description     :   This class is to make different XML Envelope required for Firm, Office and Rep. web service callout.
 *
 *  Created By      :
 *
 *  Created Date    :   07/02/2013
 *
 *  Revision Log    :   V_1.0
 *
**/
public with sharing class MarsXMLEnvelopeBuilder {  
    
    public static String FirmEnvelope(Account firm) {
        
        System.debug('Firm In Xml Envelope Builder:'+firm);
        //String to hold the Firm Envelope
        String firmEnvelopeString;
        String extension;
        String phone;
        //try{
        //String to hold phone value
        String phoneString = MarsUtility.replaceSpecialCharFromPhone(firm.Phone);        
        
        //Wrapper class for status values
        String integrationUser = 'MARSINTG';
        
        String fax=MarsUtility.replaceSpecialCharFromPhone(firm.Fax);

        //String to hold phone value
        if(phoneString.length()>10)
        {
            if(phoneString.contains('X'))
            {
                   phone=phoneString.subString(0,phoneString.lastIndexOf('X'));
                   extension=phoneString.subString(phoneString.lastIndexOf('X')+1);
                   if(extension.length()>5)
                   {
                        phone = phone + extension;
                        extension='';
                   }
            }
            else
            {
                /*if(phoneString.subString(10).isNumeric() && !(phoneString.subString(10).length() > 5))
                {
                    phone=phoneString.substring(0, 10);
                    extension=phoneString.subString(10);
                }
                else*/
                phone=phoneString;
            }
        }
        else
        {
            phone=phoneString;              
        }
        
        String address1,address2,address3,address4;
        
        System.debug('\n\n Billing Address'+firm.BillingStreet);
        
        if(firm.BillingStreet != null)
        { 
            //Check for valid billing country
            String[] myStrings = new String[4];
            myStrings = firm.BillingStreet.split('\n');
            
            if (myStrings.size() >3)
            { 
                address1 = myStrings[0].trim();
                address2 = myStrings[1].trim();
                address3 = myStrings[2].trim();
                address4 = myStrings[3].trim();
            }
            else if (myStrings.size() ==3)
            { 
                address1 = myStrings[0].trim();
                address2 = myStrings[1].trim();
                address3 = myStrings[2].trim();
            }
            else if (myStrings.size() ==2)
            { 
                address1 = myStrings[0].trim();
                address2 = myStrings[1].trim();
            }
            else
            { 
                address1 = myStrings[0].trim();
            }
        }
        
        try{
                //Populating Firm Envelope String with Actual values
                firmEnvelopeString = '<MarsFirmAndOfficeDataSet xmlns="http://tempuri.org/MarsFirmAndOffice.xsd">'
                                    +'<FIRMAndOFFICE>' 
                                    +'<FIRM_ID>'+parseNull(String.valueOf(firm.MarsFirmId__c))+'</FIRM_ID>'
                                    +'<FIRM_COMMENT >'+ parseNull(firm.MarsFirmComment__c)+'</FIRM_COMMENT >'
                                    +'<FIRM_NAME>'+parseNull(firm.MarsFirmNm__c)+'</FIRM_NAME>' 
                                    +'<SHORT_NAME>'+parseNull(firm.MarsShortNm__c)+'</SHORT_NAME>'
                                    +'<HOME_OFFICE_ID>'+parseNull(String.valueOf(firm.MarsOfficeId__c))+'</HOME_OFFICE_ID>' 
                                    +'<NUMBER_OF_REG_STATES>'+parseNull(String.valueOf(firm.MarsNbrOfRegStates__c))+'</NUMBER_OF_REG_STATES>'
                                    +'<GEO_CONC >'+ parseNull(firm.MarsGeoConc__c)+'</GEO_CONC>'
                                    +'<LAST_FIRM_NOTE_DATE >'+ parseDateTime(firm.MarsLastFirmNoteDt__c)+'</LAST_FIRM_NOTE_DATE>'
                                    +'<FIRM_TYPE>'+parseNull(firm.MarsFirmType__c)+'</FIRM_TYPE>' 
                                    +'<WEB_SITE >'+parseNull(firm.MarsFirmWebsite__c)+'</WEB_SITE >'
                                    +'<STATUS_CD>'+parseNull(firm.MarsFirmStatCd__c == 'Active'?'A':'B')+'</STATUS_CD>'
                                    +'<STATUS_UPDATE_DATE>'+parseDateTime(firm.MarsFirmStatUpdDt__c)+'</STATUS_UPDATE_DATE>'
                                    +'<SALES_GOAL_AMOUNT >'+ parseNull(String.valueOf(firm.MarsSalesGoalAmt__c)) +'</SALES_GOAL_AMOUNT >'
                                    +'<ENTRY_DATE>' + parseDateTime(firm.createdDate) + '</ENTRY_DATE><REP_TERR_BASED_ON>R</REP_TERR_BASED_ON> <CALL_CD>1</CALL_CD><MAIL_CD>1</MAIL_CD><EMAIL_CD>1</EMAIL_CD>'
                                    +'<ENTRY_USER>' + integrationUser + '</ENTRY_USER>'
                                    +'<UPDATE_DATE>' + parseDateTime(firm.lastModifiedDate) + '</UPDATE_DATE>'
                                    +'<UPDATE_USER>' + integrationUser + '</UPDATE_USER>'
                                    +'<NSCC_FIRM_NBR >'+parseNull(firm.MarsNsccFirmNbr__c)+'</NSCC_FIRM_NBR >'
                                    +'<SDR_FLG >'+parseNull(firm.MarsSdrFlg__c)+'</SDR_FLG >'
                                    +'<CRD_ID >'+parseNull(firm.MarsCrdId__c)+'</CRD_ID >'
                                    +'<EXTERNAL_ID>'+parseNull(firm.Id)+'</EXTERNAL_ID>'
                                    +'<OFFICE_EXTERNAL_ID>'+parseNull(firm.Id)+'</OFFICE_EXTERNAL_ID>'
                                    +'<EXTERNAL_FIRM_ID>'+parseNull(firm.Id)+'</EXTERNAL_FIRM_ID >'
                                    +'<OFFICE_NM>'+parseNull(firm.Name)+'</OFFICE_NM>'
                                    +'<ADDRESS1>'+parseNull(address1)+'</ADDRESS1>' 
                                    +'<ADDRESS2>'+parseNull(address2)+'</ADDRESS2 >'
                                    +'<ADDRESS3>'+parseNull(address3)+'</ADDRESS3 >'
                                    +'<ADDRESS4>'+parseNull(address4)+'</ADDRESS4 >'
                                    +'<CITY>'+parseNull(firm.BillingCity)+'</CITY>'
                                    +'<STATE_ID>'+parseNull(firm.BillingStateCode)+'</STATE_ID>'
                                    +'<ZIP>'+parseNull(firm.BillingPostalCode)+'</ZIP>'
                                    +'<COUNTRY_CD>' + parseNull(firm.BillingCountryCode) + '</COUNTRY_CD>'
                                    +'<PRIM_PHONE>'+parseNull(phone)+'</PRIM_PHONE>'
                                    +'<PRIM_PHONE_EXT>'+parseNull(extension)+'</PRIM_PHONE_EXT>'
                                    +'<PRIM_FAX>'+parseNull(fax)+'</PRIM_FAX>'
                                    +'<OFFICE_MANAGER_ID>'+parseNull(String.ValueOf(firm.MarsOfficeMgrId__c)) + '</OFFICE_MANAGER_ID>' 
                                    +'<OFFICE_NUMBER_OF_REPS />'
                                    +'<OFFICE_TIMEZONE>'+parsenull(firm.MarsTimeZone__c)+'</OFFICE_TIMEZONE>' 
                                    +'<OFFICE_LAST_MEETING_DATE>' +parseDateTime(firm.MarsLastMeetingDt__c) +'</OFFICE_LAST_MEETING_DATE >'
                                    +'<OFFICE_WEB_SITE>'+parsenull(firm.website)+'</OFFICE_WEB_SITE>'  
                                    +'<OFFICE_LATITUDE>'+parseNull(String.ValueOf(firm.billinglatitude))+'</OFFICE_LATITUDE>'
                                    +'<OFFICE_LONGITUDE>'+parseNull(String.ValueOf(firm.billinglongitude))+'</OFFICE_LONGITUDE>'
                                  +'</FIRMAndOFFICE>'
                                +'</MarsFirmAndOfficeDataSet>';
                                
                                System.debug(firmEnvelopeString );
        }catch(exception e){
            
            System.debug('\n\n Error in Xml Envelope Builder:'+e.getStackTraceString()+'--'+e.getCause()+'--'+e.getmessage());
        }                                                   
        //Return String
        System.debug(firmEnvelopeString);
        return firmEnvelopeString;
    } 

    //Method to create the Envelope for office record
    public static String OfficeEnvelope(Account office)
    {
        //String to hold office envelope
        String officeEnvelopeString;
        String extension;
        String phone;
        
        String fax=MarsUtility.replaceSpecialCharFromPhone(office.Fax);

        //String to hold phone value
        String phoneString = MarsUtility.replaceSpecialCharFromPhone(office.Phone);
        //String to hold phone value
        if(phoneString.length()>10)
        {
            if(phoneString.contains('X'))
            {
                   phone=phoneString.subString(0,phoneString.lastIndexOf('X'));
                   extension=phoneString.subString(phoneString.lastIndexOf('X')+1);
                   if(extension.length()>5)
                   {
                        phone = phone + extension;
                        extension='';
                   }
            }
            else
            {
                /*if(phoneString.subString(10).isNumeric() && !(phoneString.subString(10).length() > 5))
                {
                    phone=phoneString.substring(0, 10);
                    extension=phoneString.subString(10);
                }
                else*/
                phone=phoneString;
            }
        }
        else
        {
            phone=phoneString;              
        }

        //Wrapper class for status values
        String integrationUser = 'MARSINTG';

        //String to hold valid billing state and country
        String address1,address2,address3,address4;
        
        System.debug('\n\n Billing Address'+office.BillingStreet);
        
        if(office.BillingStreet != null)
        { 
            //Check for valid billing country
            String[] myStrings = new String[4];
            myStrings = office.BillingStreet.split('\n');
            
            if (myStrings.size() >3)
            { 
                address1 = myStrings[0].trim();
                address2 = myStrings[1].trim();
                address3 = myStrings[2].trim();
                address4 = myStrings[3].trim();
            }
            else if (myStrings.size() ==3)
            { 
                address1 = myStrings[0].trim();
                address2 = myStrings[1].trim();
                address3 = myStrings[2].trim();
            }
            else if (myStrings.size() ==2)
            { 
                address1 = myStrings[0].trim();
                address2 = myStrings[1].trim();
            }
            else
            { 
                address1 = myStrings[0].trim();
            }
        }
            
        System.debug('\n\n Parent Firm_id Value'+office.Parent.MarsFirmId__c);
        //Populating Office Envelope String with Actual values
        officeEnvelopeString = '<MarsOfficeDataSet xmlns="http://tempuri.org/MarsOffice.xsd">'
                                  +'<OFFICE>'
                                      +'<OFFICE_ID>'+parseNull(String.valueOf(office.MarsOfficeId__c))+'</OFFICE_ID>' 
                                      +'<EXTERNAL_OFFICE_ID>'+parseNull(office.Id)+'</EXTERNAL_OFFICE_ID>' 
                                      +'<FIRM_ID>'+parseNull(String.valueOf(office.MarsFirmId__c))+'</FIRM_ID>'
                                      +'<OFFICE_NM>'+parseNull(office.Name)+'</OFFICE_NM>'
                                      +'<ADDRESS1>'+parseNull(address1)+'</ADDRESS1>' 
                                      +'<ADDRESS2>'+parseNull(address2)+'</ADDRESS2 >'
                                      +'<ADDRESS3>'+parseNull(address3)+'</ADDRESS3 >'
                                      +'<ADDRESS4>'+parseNull(address4)+'</ADDRESS4 >'
                                      +'<CITY>'+parseNull(office.BillingCity)+'</CITY>'
                                      +'<STATE_ID>'+parseNull(office.BillingStateCode)+'</STATE_ID>'
                                      +'<ZIP>'+parseNull(office.BillingPostalCode)+'</ZIP>'
                                      +'<COUNTRY_CD>' + parseNull(office.BillingCountryCode) + '</COUNTRY_CD>'
                                      +'<PHONE>'+parseNull(phone)+'</PHONE>'
                                      +'<EXTENSION>'+parseNull(extension)+'</EXTENSION>'
                                      +'<FAX>'+parseNull(fax)+'</FAX>'
                                      +'<STATUS_CD>' + parseNull(office.MarsOfficeStatCd__c) + '</STATUS_CD> '
                                      +'<OFFICE_FIRM_TYPE>' + parseNull(office.MarsOffFirmType__c) + '</OFFICE_FIRM_TYPE> '
                                      +'<ENTRY_DATE>'+parseDateTime(office.createdDate)+'</ENTRY_DATE>'
                                      +'<ENTRY_USR>'+integrationUser+'</ENTRY_USR>'
                                      +'<UPDATE_DATE>'+parseDateTime(office.lastModifiedDate)+'</UPDATE_DATE>'
                                      +'<UPDATE_USR>'+integrationUser+'</UPDATE_USR>'
                                      +'<OFFICE_MANAGER_ID>'+parseNull(String.ValueOf(office.MarsOfficeMgrId__c)) + '</OFFICE_MANAGER_ID>' 
                                      +'<NUMBER_OF_REPS />'
                                      +'<TIMEZONE>'+parsenull(office.MarsTimeZone__c)+'</TIMEZONE>' 
                                      +'<LAST_MEETING_DATE>' +parseDateTime(office.MarsLastMeetingDt__c) +'</LAST_MEETING_DATE >'
                                      +'<OFFICE_COMMENT>'+parseNull(office.MarsOfficeComments__c)+'</OFFICE_COMMENT>' 
                                      +'<STATUS_UPDATE_DATE>'+parseDateTime(office.MarsOfficeStatUpdDt__c)+'</STATUS_UPDATE_DATE>'//need to change this field value
                                      +'<WEB_SITE>'+parsenull(office.website)+'</WEB_SITE>'  
                                      +'<LATITUDE>'+parseNull(String.ValueOf(office.billinglatitude))+'</LATITUDE>'
                                      +'<LONGITUDE>'+parseNull(String.ValueOf(office.billinglongitude))+'</LONGITUDE>'
                                      +'<LAST_SALE_DT>'+parseDate(office.MarsLastSaleDt__c)+'</LAST_SALE_DT>'
                                  +'</OFFICE>'
                                  +'</MarsOfficeDataSet>';
                                     
        //Return Office Envelope String
        System.debug(officeEnvelopeString);
        return officeEnvelopeString;
    }
  
    //Method to create XML envelope for rep record
    public static String RepEnvelope(Contact rep) {
        
        String phone,extension;

        //String to hold phone value
        String phoneString = MarsUtility.replaceSpecialCharFromPhone(rep.Phone);
        //String to hold phone value
        if(phoneString.length()>10){
            if(phoneString.contains('X')){
                   phone=phoneString.subString(0,phoneString.lastIndexOf('X'));
                   extension=phoneString.subString(phoneString.lastIndexOf('X')+1);
                   if(extension.length()>5){
                        phone = phone + extension;
                   }
            }else{
               /* if(phoneString.subString(10).isNumeric() && !(phoneString.subString(10).length() > 5)){
                    phone=phoneString.substring(0, 10);
                    extension=phoneString.subString(10);
                }
                else*/
                phone=phoneString;
            }
        }
        else{
            phone=phoneString;
        }
        
        String mobilephone=MarsUtility.replaceSpecialCharFromPhone(rep.MobilePhone);
        
        String fax=MarsUtility.replaceSpecialCharFromPhone(rep.Fax);

        //Wrapper class for status values
        String integrationUser = 'MARSINTG';
        //String to hold valid mailing state and country
        String mailingState;
        String mailingCountry;
        
        String address1,address2,address3,address4; 
        
        if(rep.FirstName == null){
            rep.FirstName=' ';
        }
        
        if(rep.MarsFirstNm__c == null){
            rep.MarsFirstNm__c =' ';
        }
        
        if(rep.MailingStreet != null) {            
            String[] myStrings = new String[4];
            myStrings = rep.MailingStreet.split('\n');
            if (myStrings.size() >3)
            { 
                address1 = myStrings[0].trim();
                address2 = myStrings[1].trim();
                address3 = myStrings[2].trim();
                address4 = myStrings[3].trim();
            }
            else if (myStrings.size() ==3)
            { 
                address1 = myStrings[0].trim();
                address2 = myStrings[1].trim();
                address3 = myStrings[2].trim();
            }
            else if (myStrings.size() ==2)
            { 
                address1 = myStrings[0].trim();
                address2 = myStrings[1].trim();
            }
            else
            { 
                address1 = myStrings[0].trim();
            }
        }

        //Check for null
        if(rep.MailingStateCode != null) {
            mailingState = rep.MailingStateCode;
            //Check for valid mailing state
        }

        //Check for null
        if(rep.MailingCountryCode != null) {
             mailingCountry = rep.MailingCountryCode;
            //Check for valid mailing country       
        }

        //String to hold birthdate value
        String birthMonthAndDate;
        String birthYear;

        //Check for null
        if(rep.Birthdate != null) {
            String birthDay = String.valueOf(rep.Birthdate.day());
            If(birthDay.Length() == 1){
                birthDay = '0'+birthDay;
            }
            birthMonthAndDate = String.valueOf(rep.Birthdate.month()) + birthDay;
            birthYear = String.valueOf(rep.Birthdate.year());
        }
        else
        {
            birthMonthAndDate = '';
            birthYear = '';
        }
        
        //try{
        
        System.debug('\n : Rep First Name:'+rep.MarsFirstNm__c);
        System.debug('\n : Rep First Name:'+rep.FirstName);
            
        //Populating envelope with the Actual values
        String repEnvelopeString = '<MarsRepDataSet xmlns="http://tempuri.org/MarsRep1.xsd"> '
                                                     + '<REP> ' 
                                                            +'<REP_ID>'+parseNull(String.valueOf(rep.MarsRepId__c))+'</REP_ID>'
                                                            +'<FIRM_ID>'+parseNull(String.valueOf(rep.MarsFirmId__c))+'</FIRM_ID>'
                                                            +'<OFF_ID>'+parseNull(String.valueOf(rep.MarsOfficeId__c))+'</OFF_ID>'
                                                            +'<FIRST_NM>'+parseNull(rep.MarsFirstNm__c)+'</FIRST_NM>'  
                                                            +'<LAST_NM>'+parseNull(rep.LastName)+'</LAST_NM>'
                                                            +'<TITLE>'+parseNull(rep.Title)+'</TITLE>'
                                                            +'<SALUTATION >'+ parseNull(rep.Salutation) +'</SALUTATION >'
                                                            +'<BIRTH_MMDD >'+ birthMonthAndDate +'</BIRTH_MMDD >'
                                                            +'<BIRTH_YYYY >'+ birthYear  +'</BIRTH_YYYY >'
                                                            +'<NICK_NM >'+ parseNull(rep.MarsNickNm__c) +'</NICK_NM >'
                                                            +'<SPOUSE_NM >'+ parseNull(rep.MarsSpouseNm__c) +'</SPOUSE_NM >'
                                                            +'<PERSONAL_INFO >'+ parseNull(rep.MarsPersonalInfo__c) +'</PERSONAL_INFO >'
                                                            +'<FIRST_SALE_DT >'+ parseDate(rep.MarsFirstSaleDt__c) +'</FIRST_SALE_DT >' 
                                                            +'<ASST_NM>'+parseNull(rep.AssistantName)+'</ASST_NM>' 
                                                            +'<LAST_SALE_DT >'+ parseDate(rep.MarsLastSaleDt__c) +'</LAST_SALE_DT >' 
                                                            +'<LAST_MTG_DT >'+ parseDateTime(rep.MarsLastMeetingDt__c)+'</LAST_MTG_DT >'
                                                            +'<LAST_CALL_DT >'+ parseDateTime(rep.MarsLastCallDt__c)+'</LAST_CALL_DT >'
                                                            +'<LAST_NOTE_DT >'+ parseDateTime(rep.MarsLastNoteDt__c)+'</LAST_NOTE_DT >'
                                                            +'<LAST_FULFILLMENT_DT >'+ parseDateTime(rep.MarsLastFulfillmentDt__c)+'</LAST_FULFILLMENT_DT >'
                                                            +'<LAST_LETTER_DT >'+ parseDateTime(rep.MarsLastLetterDt__c)+'</LAST_LETTER_DT >'                                                       
                                                            +'<MAIL_LIST >'+ parseNull(rep.MarsMailList__c)+'</MAIL_LIST >'
                                                            +'<ADDR1>'+parseNull(address1)+'</ADDR1>'
                                                            +'<ADDR2 >'+ parseNull(address2)+'</ADDR2 >'
                                                            +'<ADDR3 >'+ parseNull(address3)+'</ADDR3 >'
                                                            +'<ADDR4 >'+ parseNull(address4)+'</ADDR4 >'
                                                            +'<CITY>'+parseNull(rep.MailingCity)+'</CITY>'
                                                            +'<STATE_ID>'+parseNull(rep.MailingStateCode)+'</STATE_ID>' 
                                                            +'<ZIP>'+parseNull(rep.MailingPostalCode)+'</ZIP>'
                                                            +'<COUNTRY_CD>'+parseNull(rep.MailingCountryCode)+'</COUNTRY_CD>' 
                                                            +'<PRIM_PHONE>'+parseNull(phone)+'</PRIM_PHONE>'
                                                            +'<PRIM_MOBILE>'+parseNull(mobilephone)+'</PRIM_MOBILE>'
                                                            +'<PRIM_PHONE_EXT>'+parseNull(extension)+'</PRIM_PHONE_EXT>'
                                                            +'<PRIM_FAX>'+parseNull(fax)+'</PRIM_FAX>'  
                                                            +'<TIME_ZONE>'+ parseNull(rep.MarsTimeZone__c)+'</TIME_ZONE >'
                                                            +'<REP_STAFF_CD>'+parseNull(rep.MarsRepStaffCd__c)+'</REP_STAFF_CD>' 
                                                            +'<STAT_CD>'+parseNull(rep.MarsStatCd__c)+'</STAT_CD>' 
                                                            +'<EMAIL_ID>'+parseNull(rep.Email)+'</EMAIL_ID>'
                                                            +'<EMAIL_ID2>'+ parseNull(rep.MarsEmailId2__c)+'</EMAIL_ID2>'
                                                            +'<REP_COMMENT>'+ parseNull(rep.MarsRepComments__c)+'</REP_COMMENT>'
                                                            +'<PREFIX_NM>'+ parseNull(rep.MarsPrefixNm__c)+'</PREFIX_NM>'
                                                            +'<MIDDLE_NM >'+ parseNull(rep.MarsMiddleNm__c)+'</MIDDLE_NM >'
                                                            +'<SUFFIX_NM >'+ parseNull(rep.MarsRepSuffixNm__c)+'</SUFFIX_NM >'
                                                            +'<REP_FIRM_TYPE>'+parseNull(rep.MarsRepFirmType__c)+'</REP_FIRM_TYPE>' 
                                                            +'<STAT_UPD_DT>'+parseDateTime(rep.MarsStatUpdDt__c)+'</STAT_UPD_DT>'
                                                            +'<ALLOW_MAILINGS>'+parseNull(rep.MarsAllowMailings__c)+'</ALLOW_MAILINGS>'
                                                            +'<FIRST_SALE_PROCESS_DT >'+ parseDate(rep.MarsFirstSaleProcessDt__c)+'</FIRST_SALE_PROCESS_DT >' 
                                                            +'<EXTERNAL_REP_ID>'+parseNull(rep.Id)+'</EXTERNAL_REP_ID>'
                                                            +'<ADDRESS_LOCKED>'+parseNull(rep.MarsAddrLock__c)+'</ADDRESS_LOCKED>' 
                                                            +'<ENTRY_USR>' + integrationUser + '</ENTRY_USR> '
                                                            +'<ENTRY_DT>' + parseDateTime(rep.createdDate) + '</ENTRY_DT> '
                                                            +'<UPD_USR>' + integrationUser + '</UPD_USR> '
                                                            +'<UPD_DT>' + parseDateTime(rep.lastModifiedDate) + '</UPD_DT> '  
                                                            +'<CRD_ID >'+ parseNull(rep.MarsCrdId__c) +'</CRD_ID >'
                                                            +'<LATITUDE>'+parseNull(String.ValueOf(rep.mailinglatitude))+'</LATITUDE>' 
                                                            +'<LONGITUDE>'+parseNull(String.ValueOf(rep.mailinglongitude))+'</LONGITUDE>' 
                                                     + '</REP> '
                                                 + '</MarsRepDataSet>';
                                                 System.debug('rep Xml:'+repEnvelopeString);
                                                 return repEnvelopeString;                                 
        //}catch(exception e){
        //    System.debug('\n\n Error:'+e.getStackTraceString()+'--'+e.getCause()+'--'+e.getmessage());
        //    return null;
        //}                           
        //Retrun Rep Envelope String
        
    }

    //Check for Null and if yes, then return blank
    public static String parseNull(String value) {

        //Return blank if value is null
        if(value == null)
            return '';
            

        //return original value
        return '<![CDATA['+value+']]>';
    }
    public static String parseDate(Date value) {

        //Return blank if value is null
        if(value == null)
            return '';

        //return original value
        System.debug('\n\n Exact Value: '+datetime.newinstance(value, time.newinstance(0,0,0,0)).format('MM/dd/yyyy'));
        return datetime.newinstance(value, time.newinstance(0,0,0,0)).format('MM/dd/yyyy');
    }
    public static String parseDateTime(Datetime value) {

        //Return blank if value is null
        if(value == null)
            return '';

        //return original value
        System.debug('\n\n Exact Value: '+value.format('MM/dd/yyyy h:mm:ss a'));
        return value.format('MM/dd/yyyy h:mm:ss a');
    }
}