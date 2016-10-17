/**
 *  Description     :   Controller class for managing account fund data 
 *
 *  Created By      :
 *
 *  Created Date    :   08/19/2013
 *
 *  Revision Log    :   V_1.0
 *
 **/

public class MarsOfficeFundSummaryController 
{ 
    public MarsOfficeFundSummaryController() {
        
        //Memory allocation
        fundRecords = new List<AggregateResult>();
        
        //Method calling
        funds();
    }

   
    //Account
    public Account account {get; set;}
    
    //List to hold MarsRepPeriodSummary records
    public List<AggregateResult> fundRecords{get; set;}
    
    public List<AggregateResult> fundTotal{get; set;}
    
    //List to hold fields
    public List<Schema.FieldSetMember> fields{get; set;}
    
    public List<String> vfFields {get; set;}
    
    //Standard Controller
    /*public MarsOfficeFundSummaryController(ApexPages.StandardController controller) {        
        //Get record
        account = (Account)controller.getRecord();
        
        //Memory allocation
        fundRecords = new List<AggregateResult>();
        
        //Method calling
        funds();
    }*/  
    
    //This method is to get related fund data for Firm/Office record.
    public void funds()
    {
        try
        {
            String fieldvalue='';
            String namespaceval = '';
            Integer namespaceLength = 0;
    
            LIST<ApexClass> namespaceprefix=[SELECT NamespacePrefix FROM ApexClass WHERE Name = 'MarsOfficeFundSummaryController'];
            
            //if(namespaceprefix.size()>0)
            if(!namespaceprefix.IsEmpty())
            {
                namespaceval = namespaceprefix[0].NamespacePrefix + '__';
                namespaceLength = namespaceval.length();
            }
                    
            //populate the list with the fields         
            //fields = Schema.SObjectType.sfsmars__MarsRepPeriodSummary__c.fieldSets.sfsmars__MarsOfficeSummary.getFields();
            fields = Schema.SObjectType.MarsRepPeriodSummary__c.fieldSets.MarsOfficeSummary.getFields();
            
            System.debug(fields);
            // In visualforcepages the alias should not be more than 25 characters, So concatenating .
            // For Bug BUG73638 We have added this logic and in the visualforce page we are using the vfFields instead of fields.
            for(Schema.FieldSetMember f:fields)
            {
                fieldvalue +=f.getFieldPath().subString(namespaceLength) + ',';
            }      
            
            fieldvalue = fieldvalue.removeEnd(',');
            vfFields=fieldvalue.split(',');
            
            fundRecords = MarsFundSummaryHelper.getFundsById('Office', Apexpages.currentPage().getParameters().get('Id'), fields);
            
            if(!fundRecords.IsEmpty())
            {
                List<AggregateResult> lastRecord=new List<AggregateResult>();
                lastRecord.add(fundRecords[fundRecords.size()-1]);
                fundTotal=lastRecord;
                System.debug('\n Last record'+fundRecords[fundRecords.size()-1]);
                System.debug('\n fundRecords Size'+fundRecords.size());
                System.debug('\n lstfundSummary Size'+fundTotal);
            }
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Add atleast one currency field.'));
        }
    }
}