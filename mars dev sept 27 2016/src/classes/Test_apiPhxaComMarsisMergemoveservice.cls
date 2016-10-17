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
 *  Description     :   Test class for apiPhxaComMarsisMergemoveservice class
 * 
 *  Created Date    :   08/16/2013
 *
 *  Created By      :   
 * 
 *  Revision Logs   :   V1.0 - Created
 *
 *  Code Coverage   :   95%
 **/
@isTest(seeAllData=false)
private class Test_apiPhxaComMarsisMergemoveservice {

    //Test Method
    private static testMethod void myUnitTest() {
        
        //Custom Setting(MARS Defaults)
        MARSDefaults__c marsDefaults = MarsUtility.MARS_DEFAULTS ;
                
        //Test start from here
        Test.startTest();
        
        //Inner Class instance
        apiPhxaComMarsisMergemoveservice.MergeRepResponse_element controller1 = new apiPhxaComMarsisMergemoveservice.MergeRepResponse_element();
        apiPhxaComMarsisMergemoveservice.MoveRepResponse_element controller2 = new apiPhxaComMarsisMergemoveservice.MoveRepResponse_element();
        
        //Instantiating MergeMoveService object
        apiPhxaComMarsisMergemoveservice.MergeMoveServiceSoap service = MarsUtility.populatedAuthServiceForMerge();

        //Set Mock Callout class 
        Test.setMock(WebServiceMock.class, new Mock_Controller());
        
        //Set the value 
        Mock_Controller.methodNumber = 38;
          
        //Method Calling       
        String response = service.GetMoveMergeTransactionsByRange('1001008010' , 'test' , 1 , 5);
        
        //Set the value 
        Mock_Controller.methodNumber = 39;
          
        //Method Calling       
        response = service.GetMoveMergeTransactions('1001008010' , 'test');
        
        //Set the value 
        Mock_Controller.methodNumber = 40;
          
        //Method Calling       
        Boolean isSuccess = service.MergeOffice('1001008010' , '1001008010' , 'false' , 'false' , '1001008010');
        
        //Set the value 
        Mock_Controller.methodNumber = 41;
          
        //Method Calling       
        isSuccess = service.MergeFirm('1001' , '1001008010' , 'false' , 'false' , '1001008010');
        
        //Set the value 
        Mock_Controller.methodNumber = 42;
          
        //Method Calling       
        isSuccess = service.MoveOffice('1001008010' , '1001008010' , 'false' , 'false' , '1001008010');
        
        //Set the value 
        Mock_Controller.methodNumber = 43;
          
        //Method Calling       
        isSuccess = service.MergeRep('1001008010' , '1001008010' , 'N' , 'N' , '1001008010');
        
        //Set the value 
        Mock_Controller.methodNumber = 44;
          
        //Method Calling       
        isSuccess = service.MoveRep('1001008010' , '1001008010' , 'N' , 'N' , '1001008010');
        
        //Test stop here
        Test.stopTest();       
    }
}