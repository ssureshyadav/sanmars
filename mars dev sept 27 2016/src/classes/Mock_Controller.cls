/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
global with sharing class Mock_Controller implements webServiceMock{
    
    //Integer variable
    public static Integer methodNumber;
    
    //String to hold firm response
    public static String firmResponseString = '<MarsFirmDataSet xmlns="http://tempuri.org/MarsFirm.xsd">'
                                             + '<FIRM>'
                                             + '<FIRM_ID>7304</FIRM_ID>'
                                             + '<EXTERNAL_FIRM_ID />'
                                             + '<FIRM_COMMENT />'
                                             + '<FIRM_NAME>Testt Firm 11 1 1</FIRM_NAME>'
                                             + '<FIRM_NAME_CAPS>TESTT FIRM 11 1 1</FIRM_NAME_CAPS>'
                                             + '<SHORT_NAME>Testt Firm 11 1</SHORT_NAME>'
                                             + '<SHORT_NAME_CAPS>TESTT FIRM 11 1</SHORT_NAME_CAPS>'
                                             + '<HOME_OFFICE_ID>1001007989</HOME_OFFICE_ID>'
                                             + '<NUMBER_OF_REG_STATES />'
                                             + '<GEO_CONC />'
                                             + '<LAST_FIRM_NOTE_DATE />'
                                             + '<ADDRESS_ID>1001008029</ADDRESS_ID>'
                                             + '<FIRM_TYPE>NN</FIRM_TYPE>'
                                             + '<WEB_SITE />'
                                             + '<STATUS_CD xml:space="preserve">  </STATUS_CD>'
                                             + '<PARENT_FIRM_ID>xx</PARENT_FIRM_ID>'
                                             + '<STATUS_UPDATE_DATE>8/14/2013 5:36:35 AM</STATUS_UPDATE_DATE>'
                                             + '<NEW_FIRM_TYPE />'
                                             + '<SALES_GOAL_AMOUNT />'
                                             + '<ENTRY_DATE>8/14/2013 8:36:38 AM</ENTRY_DATE>'
                                             + '<ENTRY_USER>VGANDRA </ENTRY_USER>'
                                             + '<UPDATE_DATE>8/14/2013 8:36:38 AM</UPDATE_DATE>'
                                             + '<UPDATE_USER>VGANDRA </UPDATE_USER>'
                                             + '<KEY_ACCT_TERR />'
                                             + '<NSCC_FIRM_NBR />'
                                             + '<SDR_FLG />'
                                             + '<CALL_CD>1</CALL_CD>'
                                             + '<MAIL_CD>1</MAIL_CD>'
                                             + '<EMAIL_CD>1</EMAIL_CD>'
                                             + '<CRD_ID />'
                                             + '<PRIM_PHONE>4563214563</PRIM_PHONE>'
                                             + '<PRIM_PHONE_EXT />'
                                             + '<PRIM_FAX />'
                                             + '<EXTERNAL_ID />'
                                             + '<CONFIRM_YN>Y</CONFIRM_YN>'
                                             + '<REP_TERR_BASED_ON>R</REP_TERR_BASED_ON>'
                                             + '</FIRM>'
                                        + '</MarsFirmDataSet>';

    //String to hold office response
    public static String officeResponseString = '<MarsOfficeDataSet xmlns="http://tempuri.org/MarsOffice.xsd">'
                                                     + '<OFFICE>'  
                                                     + '<OFFICE_ID>1001008008</OFFICE_ID>'
                                                     + '<EXTERNAL_OFFICE_ID />'
                                                     + '<FIRM_ID>7143</FIRM_ID>'
                                                     + '<EXTERNAL_FIRM_ID />'
                                                     + '<OFFICE_NM>test</OFFICE_NM>'
                                                     + '<OFFICE_NM_CAPS>TEST</OFFICE_NM_CAPS>'
                                                     + '<ADDR_ID>1001008048</ADDR_ID>'
                                                     + '<ADDRESS1>test</ADDRESS1>'
                                                     + '<ADDRESS2>test</ADDRESS2>'
                                                     + '<ADDRESS3>test</ADDRESS3>'
                                                     + '<ADDRESS4>test</ADDRESS4>'
                                                     + '<CITY>teset</CITY>'
                                                     + '<STATE_ID>AR</STATE_ID>'
                                                     + '<ZIP>1234</ZIP>'
                                                     + '<COUNTRY_CD>US</COUNTRY_CD>'
                                                     + '<PHONE>987654321</PHONE>'
                                                     + '<EXTENSION />'
                                                     + '<FAX />'
                                                     + '<STATUS_CD xml:space="preserve">  </STATUS_CD>'
                                                     + '<OFFICE_FIRM_TYPE>NN</OFFICE_FIRM_TYPE>'
                                                     + '<ENTRY_DATE>8/14/2013 10:04:28 AM</ENTRY_DATE>'
                                                     + '<ENTRY_USR>VGANDRA </ENTRY_USR>'
                                                     + '<UPDATE_DATE>8/14/2013 10:04:28 AM</UPDATE_DATE>'
                                                     + '<UPDATE_USR>VGANDRA </UPDATE_USR>'
                                                     + '<OFFICE_MANAGER_ID />'
                                                     + '<NUMBER_OF_REPS />'
                                                     + '<TIMEZONE />'
                                                     + '<LAST_MEETING_DATE />'
                                                     + '<OFFICE_COMMENT />'
                                                     + '<STATUS_UPDATE_DATE>8/14/2013 7:04:24 AM</STATUS_UPDATE_DATE>'
                                                     + '<NEW_OFFICE_FIRM_TYPE />'
                                                     + '<WEB_SITE />'
                                                     + '<HOME_OFF_FLAG>N</HOME_OFF_FLAG>'
                                                     + '<CALL_CD>1</CALL_CD>'
                                                     + '<CALL_CD_OVERRIDE_FLG />'
                                                     + '<MAIL_CD>1</MAIL_CD>'
                                                     + '<MAIL_CD_OVERRIDE_FLG />'
                                                     + '<EMAIL_CD>1</EMAIL_CD>'
                                                     + '<EMAIL_CD_OVERRIDE_FLG />'
                                                     + '<LATITUDE />'
                                                     + '<LONGITUDE />'
                                                     + '<CONFIRM_YN>Y</CONFIRM_YN>'
                                                     + '<CITY_CAPS>TESET</CITY_CAPS>'
                                                     + '<FIRM_NM>Test Firm 200</FIRM_NM>'
                                                     + '<FIRM_NM_CAPS>TEST FIRM 200</FIRM_NM_CAPS>'
                                                     + '</OFFICE>'
                                                     + '</MarsOfficeDataSet>';

    //String to hold rep response
    public static String repResponseString =  '<MarsRepDataSet xmlns="http://tempuri.org/MarsRep1.xsd">'
                                             + '<REP>'
                                             + '<REP_ID>2481003762</REP_ID>'
                                             + '<FIRM_ID>7143</FIRM_ID>'
                                             + '<OFF_ID>1001008007</OFF_ID>'
                                             + '<FIRST_NM>test</FIRST_NM>'
                                             + '<LAST_NM>Test</LAST_NM>'
                                             + '<LAST_NM_CAPS>TEST</LAST_NM_CAPS>'
                                             + '<TITLE />'
                                             + '<SALUTATION>Mr.</SALUTATION>'
                                             + '<BIRTH_MMDD>87</BIRTH_MMDD>'
                                             + '<BIRTH_YYYY>1988</BIRTH_YYYY>'
                                             + '<NICK_NM />'
                                             + '<SPOUSE_NM />'
                                             + '<PERSONAL_INFO />'
                                             + '<FIRST_SALE_DT />'
                                             + '<ASST_NM />'
                                             + '<SALES_STAT_CD>X</SALES_STAT_CD>'
                                             + '<LAST_SALE_DT />'
                                             + '<ORIG_CD />'
                                             + '<LAST_MTG_DT />'
                                             + '<LAST_CALL_DT />'
                                             + '<LAST_NOTE_DT />'
                                             + '<LAST_FULFILLMENT_DT />'
                                             + '<LAST_LETTER_DT />'
                                             + '<MAIL_LIST />'
                                             + '<ADDR1>test</ADDR1>'
                                             + '<ADDR2>test</ADDR2>'
                                             + '<ADDR3>test</ADDR3>'
                                             + '<ADDR4>test</ADDR4>'
                                             + '<CITY>test</CITY>'
                                             + '<STATE_ID>AL</STATE_ID>'
                                             + '<ZIP>1234</ZIP>'
                                             + '<COUNTRY_CD>US</COUNTRY_CD>'
                                             + '<PRIM_PHONE>null</PRIM_PHONE>'
                                             + '<PRIM_PHONE_EXT />'
                                             + '<PRIM_FAX />'
                                             + '<TIME_ZONE />'
                                             + '<REP_STAFF_CD>R</REP_STAFF_CD>'
                                             + '<STAT_CD>Active</STAT_CD>'
                                             + '<EMAIL_ID>test@tester.com</EMAIL_ID>'
                                             + '<EMAIL_ID2 />'
                                             + '<REP_COMMENT />'
                                             + '<PREFIX_NM />'
                                             + '<MIDDLE_NM />'
                                             + '<SUFFIX_NM />'
                                             + '<REP_FIRM_TYPE>NC</REP_FIRM_TYPE>'
                                             + '<STAT_UPD_DT>8/14/2013 7:04:58 AM</STAT_UPD_DT>'
                                             + '<ALLOW_MAILINGS>N</ALLOW_MAILINGS>'
                                             + '<FIRST_SALE_PROCESS_DT />'
                                             + '<HOUSE_REP>X</HOUSE_REP>'
                                             + '<EXTERNAL_REP_ID />'
                                             + '<EXTERNAL_OFF_ID />'
                                             + '<EXTERNAL_FIRM_ID />'
                                             + '<ADDRESS_LOCKED>N</ADDRESS_LOCKED>'
                                             + '<ENTRY_USR>VGANDRA </ENTRY_USR>'
                                             + '<ENTRY_DT>8/14/2013 10:05:02 AM</ENTRY_DT>'
                                             + '<UPD_USR>VGANDRA </UPD_USR>'
                                             + '<UPD_DT>8/14/2013 10:05:02 AM</UPD_DT>'
                                             + '<CALL_CD>1</CALL_CD>'
                                             + '<CALL_CD_OVERRIDE_FLG>N</CALL_CD_OVERRIDE_FLG>'
                                             + '<MAIL_CD>1</MAIL_CD>'
                                             + '<MAIL_CD_OVERRIDE_FLG>N</MAIL_CD_OVERRIDE_FLG>'
                                             + '<EMAIL_CD>1</EMAIL_CD>'
                                             + '<EMAIL_CD_OVERRIDE_FLG>N</EMAIL_CD_OVERRIDE_FLG>'
                                             + '<CRD_ID />'
                                             + '<LATITUDE />'
                                             + '<LONGITUDE />'
                                             + '<DONOTCALL />'
                                             + '<DONOTMAIL />'
                                             + '<DONOTEMAIL />'
                                             + '<CONFIRM_YN>Y</CONFIRM_YN>'
                                             + '<RECORD_TYPE>I</RECORD_TYPE>'
                                             + '<SEARCH_STATE_ID>AL</SEARCH_STATE_ID>'
                                             + '<SEARCH_COUNTRY_CD>US</SEARCH_COUNTRY_CD>'
                                             + '<SEARCH_PRIM_PHONE>null</SEARCH_PRIM_PHONE>'
                                             + '<SEARCH_TIME_ZONE />'
                                             + '<SEARCH_ZIP>1234</SEARCH_ZIP>'
                                             + '<SEARCH_CITY>TEST</SEARCH_CITY>'
                                             + '<FIRST_NM_CAPS>TEST</FIRST_NM_CAPS>'
                                             + '<REP_REGISTRATION />'
                                             + '</REP>'
                                             + '</MarsRepDataSet>';

    global void doInvoke(
        
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,  
        String responseType) {
            
        //Check for flag value
        
        if(methodNumber == 38) {
            
            apiPhxaComMarsisMergemoveservice.GetMoveMergeTransactionsByRangeResponse_element response_x = new apiPhxaComMarsisMergemoveservice.GetMoveMergeTransactionsByRangeResponse_element();
            response_x.GetMoveMergeTransactionsByRangeResult = repResponseString;
                                    
                response.put('response_x', response_x);
        } else if(methodNumber == 39) {
            
            apiPhxaComMarsisMergemoveservice.GetMoveMergeTransactionsResponse_element response_x = new apiPhxaComMarsisMergemoveservice.GetMoveMergeTransactionsResponse_element();
            response_x.GetMoveMergeTransactionsResult = repResponseString;
                                    
                response.put('response_x', response_x);
        } else if(methodNumber == 40) {
            
            apiPhxaComMarsisMergemoveservice.MergeOfficeResponse_element response_x = new apiPhxaComMarsisMergemoveservice.MergeOfficeResponse_element();
            response_x.MergeOfficeResult = true;
                                    
                response.put('response_x', response_x);
        } else if(methodNumber == 41) {
            
            apiPhxaComMarsisMergemoveservice.MergeFirmResponse_element response_x = new apiPhxaComMarsisMergemoveservice.MergeFirmResponse_element();
            response_x.MergeFirmResult = true;
                                    
                response.put('response_x', response_x);
        } else if(methodNumber == 42) {
            
            apiPhxaComMarsisMergemoveservice.MoveOfficeResponse_element response_x = new apiPhxaComMarsisMergemoveservice.MoveOfficeResponse_element();
            response_x.MoveOfficeResult = true;
                                    
                response.put('response_x', response_x);
        } else if(methodNumber == 43) {
            
            apiPhxaComMarsisMergemoveservice.MergeRepResponse_element response_x = new apiPhxaComMarsisMergemoveservice.MergeRepResponse_element();
            response_x.MergeRepResult = true;
                                    
                response.put('response_x', response_x);
        } else if(methodNumber == 44) {
            
            apiPhxaComMarsisMergemoveservice.MoveRepResponse_element response_x = new apiPhxaComMarsisMergemoveservice.MoveRepResponse_element();
            response_x.MoveRepResult = true;
                                    
                response.put('response_x', response_x);
        } else if(methodNumber == 45) {
            
            apiPhxaComMarsisMergemoveservice.UpdateMoveMergeStatusResponse_element response_x = new apiPhxaComMarsisMergemoveservice.UpdateMoveMergeStatusResponse_element();
            response_x.UpdateMoveMergeStatusResult= true;
            
            response.put('response_x', response_x);
        }
        
        

        }
}