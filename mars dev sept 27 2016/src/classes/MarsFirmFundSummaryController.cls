/**
 *  Description     :   Controller class for managing account fund data 
 *
 *  Created By      :
 *
 *  Created Date    :   08/19/2013
 *
 *  Revision Log    :   V_1.0
 *
    Last Modified Details
    Date        User        Purpose
    --------------------------------------------------------------
    12/2/2013    Suresh     BUG73638
    --------------------------------------------------------------
 **/

public class MarsFirmFundSummaryController 
{    
    //Account
    public MARSFirmSummary__c account {get; set;}
    
    //List to hold MarsRepPeriodSummary records
    public List<AggregateResult> fundRecords{get; set;}
    
     public List<AggregateResult> fundTotal{get; set;}
     
    
    //List to hold fields
    public List<Schema.FieldSetMember> fields{get; set;}
    
    public List<String> vfFields {get; set;}
    
    public MarsFirmFundSummaryController() 
    {        
        //Memory allocation
        fundRecords = new List<AggregateResult>();
        
        //Method calling
        funds();
    }
    
    
    
    //Standard Controller
    /*public MarsFirmFundSummaryControllerDemo(ApexPages.StandardController controller) {        
        //Get record
        account = (MARSFirmSummary__c)controller.getRecord();
        
        //Memory allocation
        fundRecords = new List<AggregateResult>();
        
        //Method calling
        funds();
    }*/  
    
    //This method is to get related fund data for Firm/Office record.
    public void funds() 
    {
        
        try{
            String fieldvalue='';
            String namespaceval = '';
            Integer namespaceLength = 0;
    
           LIST<ApexClass> namespaceprefix=[SELECT NamespacePrefix FROM ApexClass WHERE Name = 'MarsFirmFundSummaryController'];
            
            if(!namespaceprefix.IsEmpty())
            {
                namespaceval = namespaceprefix[0].NamespacePrefix + '__';
                namespaceLength = namespaceval.length();
            }        
            //populate the list with the fields         
            fields = Schema.SObjectType.MarsRepPeriodSummary__c.fieldSets.MarsFirmSummary.getFields();

            for(Schema.FieldSetMember f:fields){
                fieldvalue +=f.getFieldPath().subString(namespaceLength) + ',';
            }
            fieldvalue = fieldvalue.removeEnd(',');
            System.debug('\n Field Value:'+fieldvalue);
            vfFields=fieldvalue.split(',');       
            MARSFirmSummary__c firmsummary=[Select Id,SfdcFirmId__c from MARSFirmSummary__c Where Id =: System.currentPageReference().getParameters().get('Id')];
            fundRecords = MarsFundSummaryHelper.getFundsById('Firm', firmsummary.SfdcFirmId__c , fields);
             if(!fundRecords.IsEmpty()){
                    List<AggregateResult> lastRecord=new List<AggregateResult>();
            lastRecord.add(fundRecords[fundRecords.size()-1]);
            fundTotal=lastRecord;
            System.debug('\n Last record'+fundRecords[fundRecords.size()-1]);
            System.debug('\n fundRecords Size'+fundRecords.size());
            System.debug('\n lstfundSummary Size'+fundTotal);
            }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Add atleast one currency field'));
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()+ex.getStackTraceString()));
        }
    }
    
}