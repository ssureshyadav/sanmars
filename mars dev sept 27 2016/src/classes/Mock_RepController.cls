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
 
 /**       
 *  Description     :   Mock class for RepController class
 * 
 *  Created Date    :   08/14/2013
 *
 *  Created By      :   
 * 
 *  Revision Logs   :   V1.0 - Created
 **/
@isTest(seeAllData=false)
//Mock Class implement the interface
global class Mock_RepController implements webServiceMock {
    
    //String to hold rep response
    public static String repResponse = '<MarsRepDataSet xmlns="http://tempuri.org/MarsRep1.xsd">'
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
            
            apiPhxaComMarsisForupsertservice.UpsertRepResponse_element response_x=new apiPhxaComMarsisForupsertservice.UpsertRepResponse_element(); 
            response_x.UpsertRepResult = repResponse;
                                    
                    response.put('response_x', response_x); 
    }
}