/** Description     :   This class is to parse the response values from the XML Nodes.
 *
 *  Created By      :
 *
 *  Created Date    :   07/02/2013
 *
 *  Revision Log    :   V_1.0
 *
**/
public with sharing class MarsXMLNodeParser {

    //String to hold the values retrieved from the document envelope
    public String firmId;
    public String homeOfficeId;
    public String officeId;                     
    public String repId;
    public String officeNm;
    
    //Method for parsing DOM.Document for Firm
    public void XMLNodeParserForFirm(Dom.Document marsDataEnvelopeDocument) {

        //Geting FIRM Node
        Dom.XMLNode insertFirmNode = marsDataEnvelopeDocument.getRootElement()
                                                .getChildElement('FIRM' , 'http://tempuri.org/MarsFirm.xsd');
            
        //Check Node for null
        if(insertFirmNode != null)
        {
            //Checking for node child Element
            //FIRM ID
            Dom.XMLNode firmNode = insertFirmNode.getChildElement('FIRM_ID', 'http://tempuri.org/MarsFirm.xsd');
            firmId = firmNode.getText();
            
            //HOME OFFICE ID
            Dom.XMLNode homeOfficeNode = insertFirmNode.getChildElement('HOME_OFFICE_ID', 'http://tempuri.org/MarsFirm.xsd');
            homeOfficeId = homeOfficeNode.getText();

            //HOME OFFICE NAME
            Dom.XMLNode officeName = insertFirmNode.getChildElement('OFFICE_NM', 'http://tempuri.org/MarsFirm.xsd');
            officeNm = officeName.getText();
        }
    }

    //Method for parsing DOM.Document for Office
    public void XMLNodeParserForOffice(Dom.Document marsDataEnvelopeDocument) {

        //Geting Office Node
        Dom.XMLNode insertOfficeNode = marsDataEnvelopeDocument.getRootElement()
                                                .getChildElement('OFFICE', 'http://tempuri.org/MarsOffice.xsd');

        //Check Node for null
        if(insertOfficeNode != null)
        {
            //Checking for node child Element
            //Office Id
            Dom.XMLNode officeNode = insertOfficeNode.getChildElement('OFFICE_ID', 'http://tempuri.org/MarsOffice.xsd');
            officeId = officeNode.getText();

            //Firm Id
            Dom.XMLNode firmNode = insertOfficeNode.getChildElement('FIRM_ID', 'http://tempuri.org/MarsOffice.xsd');
            firmId = firmNode.getText();

            //OFFICE NAME
            Dom.XMLNode officeName = insertOfficeNode.getChildElement('OFFICE_NM', 'http://tempuri.org/MarsOffice.xsd');
            officeNm = officeName.getText();
        }
    }

    //Method for parsing DOM.Document for Rep
    public void XMLNodeParserForRep(Dom.Document marsDataEnvelopeDocument) {

        //Geting Rep Node
        Dom.XMLNode insertRepNode = marsDataEnvelopeDocument.getRootElement()
                                                .getChildElement('REP', 'http://tempuri.org/MarsRep1.xsd');

        //Check Node for null
        if(insertRepNode != null) {

            //Checking for node child Element
            //REP Id
            Dom.XMLNode repNode = insertRepNode.getChildElement('REP_ID', 'http://tempuri.org/MarsRep1.xsd');
            repId = repNode.getText();

            //Firm Id
            Dom.XMLNode firmNode = insertRepNode.getChildElement('FIRM_ID', 'http://tempuri.org/MarsRep1.xsd');
            firmId = firmNode.getText();

            //Office Id
            Dom.XMLNode officeNode = insertRepNode.getChildElement('OFF_ID', 'http://tempuri.org/MarsRep1.xsd');
            officeId = officeNode.getText();
        }
    }
}