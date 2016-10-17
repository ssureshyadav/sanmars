public class MarsFundSummaryController {    
    //Products
    Product2 marsproduct {get; set;}
        
    public List<AggregateResult> fundRecords{get; set;}
    
    //List to hold fields
    public List<Schema.FieldSetMember> fields{get; set;}
    
    public List<String> vfFields {get; set;}

    public MarsFundSummaryController(ApexPages.StandardController controller)
    {
        marsproduct = (Product2) controller.getRecord();
        fundRecords = new List<AggregateResult>();        
        //Method calling
        funds();
    }
    
    public void funds()
    {
        try
        {
            String fieldvalue='';
            String namespaceval = '';
            Integer namespaceLength = 0;
    
            LIST<ApexClass> namespaceprefix=[SELECT NamespacePrefix FROM ApexClass WHERE Name = 'MarsFundSummaryController'];
            
            //if(namespaceprefix.size()>0)
            if(!namespaceprefix.IsEmpty())
            {
                namespaceval = namespaceprefix[0].NamespacePrefix + '__';
                namespaceLength = namespaceval.length();
            }
            //populate the list with the fields         
            fields = Schema.SObjectType.MarsRepPeriodSummary__c.fieldSets.MarsProductSummary.getFields();
            System.debug('\nFields:'+fields);
           
            for(Schema.FieldSetMember f:fields)
            {
                fieldvalue +=f.getFieldPath().subString(namespaceLength) + ',';
            }      
            
            fieldvalue = fieldvalue.removeEnd(',');
            vfFields=fieldvalue.split(',');
            System.debug('\n VfFields:'+vfFields);
            fundRecords = MarsFundSummaryHelper.getFundsById('Product', marsproduct.Id, fields);
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Add atleast one currency field.'));
        }
     }     
}