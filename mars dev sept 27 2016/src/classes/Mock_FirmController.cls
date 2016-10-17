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
 *  Description     :   Mock class for FirmController class
 * 
 *  Created Date    :   07/22/2013
 *
 *  Created By      :   
 * 
 *  Revision Logs   :   V1.0 - Created
 **/
@isTest(seeAllData=false)
//Mock Class implement the interface
global class Mock_FirmController implements webServiceMock {
    
    //String to hold firm response
    public static String firmResponse = '<MarsFirmDataSet xmlns="http://tempuri.org/MarsFirm.xsd">'
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
                                         + '<OFFICE_NM>HO - Nag Firm</OFFICE_NM>'
                                         + '<ADDRESS1>Wirgo Street</ADDRESS1>'
                                         + '<ADDRESS2>Permula Nagar</ADDRESS2><ADDRESS3 /><ADDRESS4 />'
                                         + '<CITY>Toronto</CITY>'
                                         + '<STATE_ID>FL</STATE_ID>'
                                         + '<ZIP>90001</ZIP>'
                                         + '<COUNTRY_CD>US</COUNTRY_CD>'
                                         + '</FIRM>'
                                    + '</MarsFirmDataSet>';
    
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
            
            apiPhxaComMarsisForupsertservice.UpsertFirmResponse_element response_x=new apiPhxaComMarsisForupsertservice.UpsertFirmResponse_element();
            
            response_x.UpsertFirmResult = firmResponse;
                                    
                response.put('response_x', response_x); 
    }
}