/**
 *  Description     :   Helper class for holding generic funds processing methods   
 *
 *  Created By      :
 *
 *  Created Date    :   08/19/2013
 *
 *  Revision Log    :   V_1.0
 *
 **/
 
public class MARSFundSummaryHelper
{
    //This method will retrieve all the funds records from database.
   
    //This method will retrieve all the funds records from database.
    public static List<AggregateResult> getFundsById(String entityType, Id entityId , List<Schema.FieldSetMember> fields)
    {     
        System.debug('\n entityIds'+entityId);
        //String to hold soql string
        String query = 'SELECT ';
        String querywhere = ' ';
        String namespaceval = ' ';
        Integer namespaceLength = 0;

        LIST<ApexClass> namespaceprefix=[SELECT NamespacePrefix FROM ApexClass WHERE Name = 'MARSFundSummaryHelper' AND NamespacePrefix != null];
        
        //if(namespaceprefix.size()>0)
        if(!namespaceprefix.IsEmpty())
        {
            namespaceval = namespaceprefix[0].NamespacePrefix + '__';
            namespaceLength = namespaceval.length();
        }        
        
        String rollupfields='';
        //loop through fields
        for(Schema.FieldSetMember f : fields)
        {
            System.debug('\n Get Type:'+f.getType());
            if(f.getType() == Schema.DisplayType.DOUBLE)
            {
                query += 'sum('+ f.getFieldPath()  + ') ' + f.getFieldPath().subString(namespaceLength)  + ', ';
                querywhere += 'or (' + f.getFieldPath() + ' != 0) ';
            }
            else if(f.getType() == Schema.DisplayType.DATE)
            {
                query += 'max('+ f.getFieldPath()  + ') ' + f.getFieldPath().subString(namespaceLength)  + ', ';
            }
            else
            {
                rollupfields +=f.getFieldPath() + ', ';
                query += f.getFieldPath() + ' ' + f.getFieldPath().subString(namespaceLength)  + ', ';
            }
        }
        rollupfields=rollupfields.removeEnd(', ');
        System.debug('\n Rollup Fields:'+rollupfields);     
        query = query.removeEnd(', ');
        query += ' FROM '+ namespaceval + 'MarsRepPeriodSummary__c WHERE ';
        
        If (entityType == 'Firm')
        {
            query += namespaceval + 'MarsTeamRep__c = null and ' + namespaceval + 'SfdcFirmId__c =: entityId';
        }                
        
        If (entityType == 'Office')
        {
            query += namespaceval + 'MarsTeamRep__c = null and ' + namespaceval + 'SfdcOfficeId__c =: entityId';
        }
                
        If (entityType == 'Rep')
        {
            query += namespaceval + 'SfdcRepId__c =: entityId';
        }
                           
        If (entityType == 'Product')
        {
            Product2 prod = [SELECT Id , MarsProdCd__c FROM Product2 WHERE Id =: entityId];
            String prodCd = prod.MarsProdCd__c;
            System.debug('Product Code'+prodCd);
            query += namespaceval + 'MarsTeamRep__c = null and ' + namespaceval + 'MarsProdCd__c =: prodCd';
        }
                
        querywhere = querywhere.replaceFirst('or', 'and (');
        query += querywhere + ')';
        If (entityType == 'Product')
        {
             if(rollupfields==null||rollupfields=='')
             {
                 rollupfields=namespaceprefix[0].NamespacePrefix+'__MarsProdTitle__c';
             }
             else
             {
                 rollupfields += rollupfields + ', ' + namespaceprefix[0].NamespacePrefix+'__MarsProdTitle__c';
             }
             query += ' group by ' + rollupfields;
        }
        else
        {
           query += ' group by rollup ('+ rollupfields+')' ;
        }
        System.debug('\n Query Value:'+query);
       
        list<AggregateResult> lstfundSummary = Database.query(query);
        System.debug('\n lstfundSummary'+lstfundSummary); 
        
        return lstfundSummary;
    }
}