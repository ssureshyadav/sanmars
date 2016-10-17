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
@isTest(seealldata=true)
private class TestMARSConfigController {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        MARSConfigController controller=new MARSConfigController();
        
      /*  MARSDefaults__c defaults=new MARSDefaults__c();
        defaults.MARSUser__c='ABCD';
        defaults.RetryDuration__c=15;
        defaults.MARSPassword__c='****';
        defaults.MARSEndpointUrl__c='http://test.com/';
        defaults.IntegrationType__c=1;
        defaults.EmailErrors__c=true;
        defaults.Email__c='test@test.com';
        defaults.DeleteMARSBatchDataPeriod__c=30;
        defaults.BulkLoadEnabled__c=true;
        defaults.AllowRepMove__c=true;
        
        insert defaults;*/
        
        controller.configUsr='';
        controller.configPswd='';
        controller.doAction();
        controller.edit();
        controller.cancel();
        test.startTest();
            
            controller.save();
        test.stopTest();
    }
}