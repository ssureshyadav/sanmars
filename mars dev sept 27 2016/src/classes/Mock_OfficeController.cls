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
 *  Description     :   Mock class for Firm, Office and Rep class
 * 
 *  Created Date    :   08/14/2013
 *
 *  Created By      :   
 * 
 *  Revision Logs   :   V1.0 - Created
 **/
@isTest(SeeAllData=false)
global with sharing class Mock_OfficeController implements webServiceMock {
    
    //String to hold office response
    public static String officeResponse = '<MarsOfficeDataSet xmlns="http://tempuri.org/MarsOffice.xsd">'
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
        
        apiPhxaComMarsisForupsertservice.UpsertOfficeResponse_element response_x=new apiPhxaComMarsisForupsertservice.UpsertOfficeResponse_element();
        response_x.UpsertOfficeResult = officeResponse;
            response.put('response_x', response_x);
    }
}