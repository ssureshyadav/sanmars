/**
 *  Description    :    This class is to hold all the web-services method required for MARS for pushing data in Salesforce.
 * 
 * Created By        :  Suresh
 *
 * Created Date      :  08/25/2013
 *
 * Last Modified By  :  
 *
 * Last Modified Date:  
 *
 * Revision Log     :   V_1.0
 *
 **/ 

global class MARSApexGateway {

public class applicationException extends Exception {}
    
    global class ACK 
    {
        webservice String SFDCObjectId;
        webservice String MarsObjectId;
        webservice boolean Result;
        webservice String ErrorMessage;
    }
    
    webservice static List<ACK> SyncTerritories(String TerritoryXML)
    {
        List<ACK> lstResponse=new List<ACK>();           
        try
        {
            Map<String, List<MarsTerritory__c>> marsTerritory=MarsSyncMessageParser.parseTerritory(TerritoryXML);
            System.debug(marsTerritory);
            if(marsTerritory.containsKey('Success'))
            {
                List<MarsTerritory__c> lstTerritory=marsTerritory.get('Success');
                if(!lstTerritory.IsEmpty())
                { 
                    //Bypassing the trigger                        
                    MarsUtility.BYPASS_ALL_TRIGGER=true;
                    Schema.SObjectField externalIdField = MarsTerritory__c.MarsTerrCd__c;
                    List<Database.UpsertResult> result= Database.upsert(lstTerritory,externalIdField, false);

                    //Enable the trigger                        
                    MarsUtility.BYPASS_ALL_TRIGGER=false;                     
                    // looping the upsertcontacts results to get the salesforce ids and mars rep ids.
                    for(Integer i=0;i<result.size();i++)
                    {
                        ACK objSFDCResponse=new ACK();
                        if(result[i].isSuccess())
                        {
                            // Assigning Salesforce ids to SFDCObjectId
                            objSFDCResponse.SFDCObjectId=result[i].Id;
                            // Assigning rep ids(EXTERNAL_ID__c in salesforce) to MarsObjectId
                            objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstTerritory[i].MarsTerrCd__c)+']]>';
                            objSFDCResponse.Result=result[i].isSuccess();
                        }
                        else
                        {
                            objSFDCResponse.SFDCObjectId='';
                          
                            // Assigning rep ids(EXERNAL_ID__c in salesforce) to MarsObjectId
                            objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstTerritory[i].MarsTerrCd__c)+']]>';
                            objSFDCResponse.Result=result[i].isSuccess();
                            objSFDCResponse.ErrorMessage=result[i].errors[0].message+result[i].errors[0].fields;
                        }
                        // Adding the upsertresult object to list
                        lstResponse.add(objSFDCResponse);
                    }
                }
            }
            if(marsTerritory.containsKey('Errors'))
            {
                List<MarsTerritory__c> errorTerritory=marsTerritory.get('Errors');
                //if(errorProducts.size()>0)
                if(!errorTerritory.IsEmpty())
                {
                    for(integer i=0;i<errorTerritory.size();i++){
                    ACK objSFDCResponse=new ACK();
                    objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(errorTerritory[i].MarsTerrCd__c)+']]>';
                    objSFDCResponse.Result=false;
                    objSFDCResponse.ErrorMessage=errorTerritory[i].Name;
                    lstResponse.add(objSFDCResponse);
                    }
                }
            }
        }
        catch(exception e)
        {
            ACK objSFDCResponse=new ACK();
            objSFDCResponse.Result=false;
            objSFDCResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();    
            lstResponse.add(objSFDCResponse);
            // Creating the Errorlogging record.
        }
        System.debug('\n Response Output:'+lstResponse);
        return lstResponse;
    }
    
    webservice static List<ACK> SyncFirms(String FirmXML)
    { 
        System.debug(FirmXML);
        List<ACK> lstResponse=new List<ACK>();
        try
            {
                Map<String, List<Account>> firmAccount=MarsSyncMessageParser.ParseFirm(FirmXML);
                if(firmAccount.containsKey('Success'))
                {                    
                    List<Account> lstaccount=firmAccount.get('Success');
                    if(!lstaccount.IsEmpty())
                    {         
                        if(!MarsUtility.firmCRDId.isEmpty())
                        {
                            Map<String,Id> mapIdCRDId=new Map<String,Id>();
                            List<Account> lstupdateAccount=new List<Account>();
                            for(MARSFirmSummary__c lstFirmSum:[Select Id, SfdcFirmId__c,MarsCrdId__c,MarsFirmId__c from MARSFirmSummary__c where MarsCrdId__c IN : MarsUtility.firmCRDId])
                            {
                                if(lstFirmSum.MarsFirmId__c == null)
                                {
                                    mapIdCRDId.put(lstFirmSum.MarsCrdId__c.toUpperCase(), lstFirmSum.SfdcFirmId__c);
                                }else if(lstFirmSum.MarsFirmId__c != null)
                                {
                                    Account acc=new Account(Id=lstFirmSum.SfdcFirmId__c);
                                    acc.MarsCrdId__c =null;
                                    lstupdateAccount.add(acc);
                                }
                            }
                            
                            MarsUtility.BYPASS_ALL_TRIGGER=true;
                            if(!lstupdateAccount.isEmpty())
                            {
                                update lstupdateAccount;
                            }
                            MarsUtility.BYPASS_ALL_TRIGGER=false;
                            
                            for(Integer i=0;i<lstaccount.size();i++)
                            {
                                if(lstaccount[i].MarsCrdId__c != null)
                                {
                                    if(mapIdCRDId.containsKey(lstaccount[i].MarsCrdId__c))
                                    {
                                        lstaccount[i].Id=mapIdCRDId.get(lstaccount[i].MarsCrdId__c);
                                    }
                                }   
                            }
                        }
                        System.debug(LoggingLevel.ERROR, 'Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
                        MarsUtility.BYPASS_ALL_TRIGGER=true;
                        List<Database.Upsertresult> firmresults = Database.upsert(lstaccount, false);
                        if(!MarsUtility.firmCRDId.isEmpty())
                        {
                            List<MARSFirmSummary__c> lstupdateFirmSum=new List<MARSFirmSummary__c>();
                            for(MARSFirmSummary__c lstFirmSum:[Select Id, SfdcFirmId__c,SfdcFirmId__r.MarsFirmId__c,MarsCrdId__c,MarsFirmId__c from MARSFirmSummary__c where MarsCrdId__c IN : MarsUtility.firmCRDId])
                            {
                                MARSFirmSummary__c firmSum=new MARSFirmSummary__c();
                                firmSum.Id=lstFirmSum.Id;
                                firmSum.MarsFirmId__c=lstFirmSum.SfdcFirmId__r.MarsFirmId__c;
                                firmSum.MarsCrdId__c=null;
                                lstupdateFirmSum.add(firmSum);
                            }
                            if(!lstupdateFirmSum.isEmpty())
                            {
                                update lstupdateFirmSum;
                            }
                        }
                        
                        MarsUtility.firmCRDId.Clear();
                        List<MARSFirmSummary__c> firmSummary=new List<MARSFirmSummary__c>();    
                        List<Id> lstAccountId=new List<Id>(); 
                        for(integer i=0;i<firmresults.size();i++)
                        {
                            if(firmresults[i].isSuccess())
                            {
                                lstAccountId.add(firmresults[i].Id);
                            }
                        }
                        for(Account acc:[Select Id,MarsFirmNm__c,MarsFirmId__c,MarsCrdId__c,MarsFirmComment__c,MarsShortNm__c,MARSFirmStatCd__c,MarsFirmStatUpdDt__c,MarsFirmType__c,MarsGeoConc__c,MarsNsccFirmNbr__c,MarsNbrOfRegStates__c,MarsSalesGoalAmt__c,MarsSdrFlg__c,MarsFirmWebsite__c,SFDCFirmSumId__c from Account Where Id IN : lstAccountId])
                        {
                                System.debug(acc.SFDCFirmSumId__c);
                                System.debug(acc.MarsFirmId__c);
                                MARSFirmSummary__c firmSummaryRec=new MARSFirmSummary__c();
                                if(acc.SFDCFirmSumId__c != null)
                                {
                                   firmSummaryRec.Id= acc.SFDCFirmSumId__c;
                                }
                                firmSummaryRec.Name=acc.MarsFirmNm__c;
                                firmSummaryRec.MarsFirmId__c=acc.MarsFirmId__c;
                                firmSummaryRec.SfdcFirmId__c=acc.Id;
                                firmSummaryRec.MarsCrdId__c = acc.MarsCrdId__c;
                                firmSummaryRec.MarsFirmComment__c=acc.MarsFirmComment__c;
                                firmSummaryRec.MarsShortNm__c=acc.MarsShortNm__c;
                                firmSummaryRec.MARSFirmStatCd__c=acc.MARSFirmStatCd__c;
                                firmSummaryRec.MarsFirmStatUpdDt__c=acc.MarsFirmStatUpdDt__c;
                                firmSummaryRec.MarsFirmType__c=acc.MarsFirmType__c;
                                firmSummaryRec.MarsGeoConc__c=acc.MarsGeoConc__c;
                                firmSummaryRec.MarsNsccFirmNbr__c=acc.MarsNsccFirmNbr__c;
                                firmSummaryRec.MarsNbrOfRegStates__c=acc.MarsNbrOfRegStates__c;
                                firmSummaryRec.MarsSalesGoalAmt__c=acc.MarsSalesGoalAmt__c;
                                firmSummaryRec.MarsSdrFlg__c=acc.MarsSdrFlg__c;
                                firmSummaryRec.MarsFirmWebsite__c=acc.MarsFirmWebsite__c;
                                firmSummary.add(firmSummaryRec);
                        }
                        System.debug(LoggingLevel.ERROR, 'Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
                        if (!firmSummary.isEmpty())
                        {
                            //System.enqueueJob(new MarsUpdateRecords(firmSummary));
                            Schema.SObjectField externalIdField = MARSFirmSummary__c.MarsFirmId__c;
                            List<Database.UpsertResult> firmsummaryresult=Database.upsert(firmSummary,externalIdField, false);
                            if(!firmsummaryresult.isEmpty())
                            {
                                List<Account> lstUpdateFirmSum =new List<Account>();
                                for(integer i=0;i<firmsummaryresult.size();i++)
                                {
                                    if(!firmsummaryresult[i].isSuccess())
                                    {
                                        ACK objSFDCResponse=new ACK();
                                        objSFDCResponse.MarsObjectId=String.valueOf(lstaccount[i].MarsFirmId__c);
                                        objSFDCResponse.SFDCObjectId=firmSummary[i].Id;
                                        objSFDCResponse.Result=firmsummaryresult[i].isSuccess();
                                        objSFDCResponse.ErrorMessage=firmsummaryresult[i].errors[0].message;
                                        lstResponse.add(objSFDCResponse);
                                    }else{
                                        Account acc=new Account(Id= firmSummary[i].SfdcFirmId__c);
                                        acc.SFDCFirmSumId__c = firmsummaryresult[i].Id;
                                        lstUpdateFirmSum.add(acc);  
                                    }
                                }
                                    
                                if(!lstUpdateFirmSum.isEmpty())
                                {
                                    update lstUpdateFirmSum;
                                }
                            }
                            
                            MarsUtility.BYPASS_ALL_TRIGGER=false;
                        }
                        System.debug(LoggingLevel.ERROR, 'Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
                        for(integer i=0;i<firmresults.size();i++)
                        {
                            ACK objSFDCResponse=new ACK();
                            if(firmresults[i].isSuccess())
                            {
                                objSFDCResponse.SFDCObjectId=firmresults[i].Id;
                                objSFDCResponse.MarsObjectId=String.valueOf(lstaccount[i].MarsFirmId__c);
                                objSFDCResponse.Result=firmresults[i].isSuccess();    
                            }
                            else
                            {
                                objSFDCResponse.MarsObjectId=String.valueOf(lstaccount[i].MarsFirmId__c);
                                objSFDCResponse.SFDCObjectId=firmresults[i].Id;
                                objSFDCResponse.Result=firmresults[i].isSuccess();
                                objSFDCResponse.ErrorMessage=firmresults[i].errors[0].message;
                            }
                            lstResponse.add(objSFDCResponse);
                        }
                    }  
                }
                
                if(firmAccount.containsKey('Errors'))
                {
                    List<Account> lstaccount=firmAccount.get('Errors');
                    if(!lstaccount.IsEmpty())
                    {
                        for(integer i=0;i<lstaccount.size();i++)
                        {
                            ACK objSFDCResponse=new ACK();
                            objSFDCResponse.MarsObjectId=String.valueOf(lstaccount[i].MarsFirmId__c);
                            objSFDCResponse.Result=false;
                            objSFDCResponse.ErrorMessage=lstaccount[i].Description;
                            lstResponse.add(objSFDCResponse);
                        }
                    }
                }
            } 
            catch (exception e)
            {
                ACK objSFDCResponse=new ACK();
                objSFDCResponse.Result=false;
                objSFDCResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();    
                lstResponse.add(objSFDCResponse);
            }
            System.debug('Response:'+lstResponse);
        return lstResponse;
    }

    webservice static List<ACK> SyncOffices(String OfficeXML)
    {
        List<ACK> lstResponse=new List<ACK>();
        try
        {
            System.debug('Office XMl'+OfficeXML);
            Map<Decimal,Id> mapAccount=new Map<Decimal,Id>();
            Map<String, List<Account>> officeAccount=MarsSyncMessageParser.ParseOffice(OfficeXML);
            if(officeAccount.containsKey('Success'))
            {
                List<Account> lstaccount=officeAccount.get('Success');
                Set<Decimal> firmIDs=new Set<Decimal>();
                if(!lstaccount.IsEmpty())
                { 
                    for(Account acc:lstaccount){
                        firmIDs.add(acc.MarsFirmId__c);
                    }
                    if(!firmIDs.isEmpty())
                    {
                        for(MARSFirmSummary__c sum:[Select Id,MarsFirmId__c,SfdcFirmId__c from MARSFirmSummary__c Where MarsFirmId__c IN : firmIDs])
                        {
                            mapAccount.put(sum.MarsFirmId__c,sum.Id);
                        }   
                    }
                    
                    for(Integer i=0;i<lstaccount.size();i++)
                    {
                        if(mapAccount.containsKey(lstaccount[i].MarsFirmId__c))
                        {
                            lstaccount[i].SFDCFirmSumId__c = mapAccount.get(lstaccount[i].MarsFirmId__c);
                        }
                    }
                    //Bypassing the trigger                        
                    MarsUtility.BYPASS_ALL_TRIGGER=true;
                    List<Database.Upsertresult> officeResults= Database.upsert(lstaccount, false);
                    System.debug(LoggingLevel.ERROR, 'Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());

                    //Enable the trigger
                    MarsUtility.BYPASS_ALL_TRIGGER=false;
                    
                    for(Integer i=0;i<officeResults.size();i++)
                    {
                        ACK objSFDCResponse=new ACK();
                        if(officeResults[i].isSuccess())
                        {
                            // Assigning Salesforce ids to SFDCObjectId
                            objSFDCResponse.SFDCObjectId=officeResults[i].Id;
                            objSFDCResponse.MarsObjectId=String.valueOf(lstaccount[i].MarsOfficeId__c);
                            objSFDCResponse.Result=officeResults[i].isSuccess();
                        }
                        else
                        {
                            objSFDCResponse.SFDCObjectId=officeResults[i].Id;
                            // Assigning rep ids(EXTERNAL_ID__c in salesforce) to MarsObjectId
                            objSFDCResponse.MarsObjectId=String.valueOf(lstaccount[i].MarsOfficeId__c);
                            objSFDCResponse.Result=officeResults[i].isSuccess();
                            objSFDCResponse.ErrorMessage=lstaccount[i].Description+officeResults[i].errors[0].message;
                            System.debug('\n\n Error Message in Else Block:'+objSFDCResponse.ErrorMessage);
                        }
                        // Adding the upsertresult object to list
                        lstResponse.add(objSFDCResponse);
                    }
                }
            }
            if(officeAccount.containsKey('Errors'))
            {
                List<Account> lstaccount=officeAccount.get('Errors');
                //if(lstaccount.size()>0)
                if(!lstaccount.IsEmpty())
                {
                    for(integer i=0;i<lstaccount.size();i++)
                    {
                        ACK objSFDCResponse=new ACK();
                        objSFDCResponse.MarsObjectId=String.valueOf(lstaccount[i].MarsOfficeId__c);
                        objSFDCResponse.Result=false;
                        objSFDCResponse.ErrorMessage=lstaccount[i].Description;
                        System.debug('\n\n Error Message Office in catch Block:'+objSFDCResponse.ErrorMessage);
                        lstResponse.add(objSFDCResponse);
                    }
                }
            }
        }
        catch(exception e)
        {
            ACK objSFDCResponse=new ACK();
            objSFDCResponse.Result=false;
            objSFDCResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();    
            lstResponse.add(objSFDCResponse);
        }
        System.debug(LoggingLevel.ERROR, 'Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
        return lstResponse;
    }
    
    webservice static List<ACK> SyncReps(String RepXML)
    {
        List<ACK> lstResponse=new List<ACK>(); 
        try
        {
            Map<String, List<Contact>> repContact=MarsSyncMessageParser.ParseRep(RepXML);
            if(repContact.containsKey('Success'))
            {
                List<Contact> lstcontact=repContact.get('Success');
                //if(lstcontact.size()>0)
                if(!lstcontact.IsEmpty())
                { 
                    //Bypassing the trigger                        
                    MarsUtility.BYPASS_ALL_TRIGGER=true;
                    if(!MarsUtility.repCRDId.isEmpty())
                    {
                        List<Contact> lstqueryContact=[Select Id, MarsCrdId__c,MarsRepId__c from Contact where MarsCrdId__c IN : MarsUtility.repCRDId];
                        Map<String,Id> mapIdCRDId=new Map<String,Id>();
                        
                        if(!lstqueryContact.isEmpty())
                        {
                            List<Contact> lstUpdatecontact=new List<Contact>();
                            for(Contact lCont:lstqueryContact)
                            {
                                if(lCont.MarsRepId__c == null)
                                {
                                    mapIdCRDId.put(lCont.MarsCrdId__c.toUpperCase(),lCont.Id);
                                }else if(lCont.MarsRepId__c != null)
                                {
                                    Contact acc=new Contact(Id=lCont.Id);
                                    acc.MarsCrdId__c =null;
                                    lstUpdatecontact.add(acc);
                                } 
                            }
                            if(!lstUpdatecontact.isEmpty())
                            {
                                MarsUtility.BYPASS_ALL_TRIGGER=true;
                                update lstUpdatecontact;
                                MarsUtility.BYPASS_ALL_TRIGGER=false;
                            }
                        }
                        for(Integer i=0;i<lstcontact.size();i++)
                        {                        
                            if(lstcontact[i].MarsCrdId__c != null)
                            {
                                if(mapIdCRDId.containsKey(lstcontact[i].MarsCrdId__c))
                                {
                                    lstcontact[i].Id=mapIdCRDId.get(lstcontact[i].MarsCrdId__c);
                                }
                            }   
                        }
                    }
                    
                    Map<Decimal,Id> mapAccount=new Map<Decimal,Id>();
                    if(!lstcontact.IsEmpty())
                    {
                        Set<Decimal> lstAccountIds=new set<Decimal>();
                        for(Contact con:lstcontact){
                            lstAccountIds.add(con.MarsFirmId__c);
                        }
                        if(!lstAccountIds.isEmpty())
                        {
                            List<MARSFirmSummary__c> lstfirmSum=[Select Id,MarsFirmId__c,SfdcFirmId__c from MARSFirmSummary__c Where MarsFirmId__c IN : lstAccountIds];
                            if(!lstfirmSum.isEmpty())
                            {
                                for(MARSFirmSummary__c sum:lstfirmSum)
                                {
                                    mapAccount.put(sum.MarsFirmId__c,sum.Id);
                                }
                            }
                            //mapAccount=new Map<Id,Account>([Select Id,SFDCFirmSumId__c from Account Where Id IN : lstAccountIds]);
                        }
                        List<Contact> lstinscontact=new List<Contact>();
                        for(Contact cont:lstcontact)
                        {
                            Contact con=cont;
                            con.SFDCFirmSumId__c = mapAccount.get(cont.MarsFirmId__c);
                            lstinscontact.add(con);
                        }
                        System.debug(LoggingLevel.ERROR, 'CpuTime: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime());
                        MarsUtility.BYPASS_ALL_TRIGGER=true;
                        List<Database.UpsertResult> result= Database.upsert(lstinscontact, false);
                        
                        //Enable the trigger                        
                        MarsUtility.BYPASS_ALL_TRIGGER=false;
                        MarsUtility.repCRDId.Clear();
                        
                        // looping the upsertcontacts results to get the salesforce ids and mars rep ids.
                        for(Integer i=0;i<result.size();i++)
                        {                                
                            ACK objSFDCResponse=new ACK();
                            if(result[i].isSuccess())
                            {
                                // Assigning Salesforce ids to SFDCObjectId
                                objSFDCResponse.SFDCObjectId=result[i].Id;
                                // Assigning rep ids(EXTERNAL_ID__c in salesforce) to MarsObjectId
                                objSFDCResponse.MarsObjectId=String.valueOf(lstcontact[i].MarsRepId__c);
                                objSFDCResponse.Result=result[i].isSuccess();
                            }
                            else
                            {
                                objSFDCResponse.SFDCObjectId='';
                              
                                // Assigning rep ids(EXERNAL_ID__c in salesforce) to MarsObjectId
                                objSFDCResponse.MarsObjectId=String.valueOf(lstcontact[i].MarsRepId__c);
                                objSFDCResponse.Result=result[i].isSuccess();
                                objSFDCResponse.ErrorMessage=result[i].errors[0].message+result[i].errors[0].fields;
                                System.debug('Error Message in Rep Else Block'+objSFDCResponse.ErrorMessage);
                                System.debug(LoggingLevel.ERROR, 'Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
                                System.debug(LoggingLevel.ERROR, 'CpuTime: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime());
                            }
                            // Adding the upsertresult object to list
                            lstResponse.add(objSFDCResponse);
                        }
                    }
                }
            }
            if(repContact.containsKey('Errors'))
            {
                List<Contact> errorContacts=repContact.get('Errors');
                if(!errorContacts.IsEmpty())
                {
                    for(integer i=0;i<errorContacts.size();i++)
                    {
                        ACK objSFDCResponse=new ACK();
                        objSFDCResponse.MarsObjectId=String.valueOf(errorContacts[i].MarsRepId__c);
                        objSFDCResponse.Result=false;
                        objSFDCResponse.ErrorMessage=errorContacts[i].Description;
                        System.debug('Error Message in Rep catch Block'+objSFDCResponse.ErrorMessage);
                        lstResponse.add(objSFDCResponse);
                    }
                }
            }
        }
        catch(exception e)
        {
            ACK objSFDCResponse=new ACK();
            objSFDCResponse.Result=false;
            objSFDCResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();    
            lstResponse.add(objSFDCResponse);
            // Creating the Errorlogging record.
        }
        System.debug(LoggingLevel.ERROR, 'After insert CpuTime: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime());
        System.debug('\n Response Output:'+lstResponse);
        return lstResponse;
    }
    
    webservice static List<ACK> SyncTeamReps(String TeamRepXML)
    {
        List<ACK> lstResponse=new List<ACK>();
        try
        {
            Map<String, List<MarsRepTeam__c>> teamReps=MarsSyncMessageParser.ParseTeamRep(TeamRepXML);
            if(teamReps.containsKey('Success'))
            {
                List<MarsRepTeam__c> lstTeamRep=teamReps.get('Success');
                if(!lstTeamRep.IsEmpty())
                {                        
                    MarsUtility.BYPASS_ALL_TRIGGER=true;
                    List<Database.UpsertResult> result= Database.upsert(lstTeamRep,false);
                 
                    MarsUtility.BYPASS_ALL_TRIGGER=false;
                    for(Integer i=0;i<result.size();i++)
                    {                                
                        ACK objSFDCResponse=new ACK();
                        if(result[i].isSuccess())
                        {
                            // Assigning Salesforce ids to SFDCObjectId
                            objSFDCResponse.SFDCObjectId=result[i].Id;
                            // Assigning rep ids(EXTERNAL_ID__c in salesforce) to MarsObjectId
                            objSFDCResponse.MarsObjectId=String.valueOf(lstTeamRep[i].MarsTeamRepId__c +'-'+lstTeamRep[i].MarsRepId__c);
                            objSFDCResponse.Result=result[i].isSuccess();
                        }
                        else
                        {
                            objSFDCResponse.SFDCObjectId='';
                            objSFDCResponse.MarsObjectId=String.valueOf(lstTeamRep[i].MarsTeamRepId__c+'-'+lstTeamRep[i].MarsRepId__c);
                            objSFDCResponse.Result=result[i].isSuccess();
                            objSFDCResponse.ErrorMessage=result[i].errors[0].message+result[i].errors[0].fields;
                            System.debug('Error Message in TeamRep Else Block'+objSFDCResponse.ErrorMessage);
                        }
                        lstResponse.add(objSFDCResponse);
                    }
                }
            }
            if(teamReps.containsKey('Errors'))
            {
                List<MarsRepTeam__c> errorTeamReps=teamReps.get('Errors');
                if(!errorTeamReps.IsEmpty())
                {
                    for(integer i=0;i<errorTeamReps.size();i++)
                    {
                        ACK objSFDCResponse=new ACK();
                        objSFDCResponse.MarsObjectId=String.valueOf(errorTeamReps[i].MarsTeamRepId__c+'-'+errorTeamReps[i].MarsRepId__c);
                        objSFDCResponse.Result=false;
                        objSFDCResponse.ErrorMessage=errorTeamReps[i].Name;
                        System.debug('Error Message in TeamRep catch Block'+objSFDCResponse.ErrorMessage);
                        lstResponse.add(objSFDCResponse);
                    }
                }
            }
        }
        catch(exception e)
        {
            ACK objSFDCResponse=new ACK();
            objSFDCResponse.Result=false;
            objSFDCResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();    
            lstResponse.add(objSFDCResponse);
            // Creating the Errorlogging record.
        }
        System.debug('\n Response Output:'+lstResponse);
        return lstResponse;
    }
    
    webservice static List<ACK> SyncProducts(String ProductXML)
    {        
        List<ACK> lstResponse=new List<ACK>();           
        try
        {
            Map<String, List<Product2>> marsProducts=MarsSyncMessageParser.parseProduct(ProductXML);
            //Map<String, List<sfsmars__MarsProducts__c>> marsProducts=MarsSyncMessageParser.parseProduct(ProductXML);
            //Schema.SObjectField externalIdField = Product2.MarsProdCd__c;
            if(marsProducts.containsKey('Success'))
            {
                List<Product2> lstProducts=marsProducts.get('Success');
                //if(lstProducts.size()>0)
                if(!lstProducts.IsEmpty())
                { 
                    //Bypassing the trigger                        
                    MarsUtility.BYPASS_ALL_TRIGGER=true;
                    List<Database.UpsertResult> result= Database.upsert(lstProducts, false);

                    //Enable the trigger                        
                    MarsUtility.BYPASS_ALL_TRIGGER=false;                     
                    // looping the upsertcontacts results to get the salesforce ids and mars rep ids.
                    for(Integer i=0;i<result.size();i++)
                    {
                        ACK objSFDCResponse=new ACK();
                        if(result[i].isSuccess())
                        {
                            // Assigning Salesforce ids to SFDCObjectId
                            objSFDCResponse.SFDCObjectId=result[i].Id;
                            // Assigning rep ids(EXTERNAL_ID__c in salesforce) to MarsObjectId
                            objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstProducts[i].MarsProdId__c)+']]>';
                            objSFDCResponse.Result=result[i].isSuccess();
                        }
                        else
                        {
                            objSFDCResponse.SFDCObjectId='';
                          
                            // Assigning rep ids(EXERNAL_ID__c in salesforce) to MarsObjectId
                            objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(lstProducts[i].MarsProdId__c)+']]>';
                            objSFDCResponse.Result=result[i].isSuccess();
                            objSFDCResponse.ErrorMessage=result[i].errors[0].message+result[i].errors[0].fields;
                        }
                        // Adding the upsertresult object to list
                        lstResponse.add(objSFDCResponse);
                    }
                }
            }
            if(marsProducts.containsKey('Errors'))
            {
                List<Product2> errorProducts=marsProducts.get('Errors');
                //if(errorProducts.size()>0)
                if(!errorProducts.IsEmpty())
                {
                    for(integer i=0;i<errorProducts.size();i++){
                    ACK objSFDCResponse=new ACK();
                    objSFDCResponse.MarsObjectId='<![CDATA['+String.valueOf(errorProducts[i].MarsProdId__c)+']]>';
                    objSFDCResponse.Result=false;
                    objSFDCResponse.ErrorMessage=errorProducts[i].Name;
                    lstResponse.add(objSFDCResponse);
                    }
                }
            }
        }
        catch(exception e)
        {
            ACK objSFDCResponse=new ACK();
            objSFDCResponse.Result=false;
            objSFDCResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();    
            lstResponse.add(objSFDCResponse);
            // Creating the Errorlogging record.
        }
        System.debug('\n Response Output:'+lstResponse);
        return lstResponse;
    }
    
    webservice static ACK SyncMergeFirm(String target_firmid,String source_firmid, String targetsfdcid, String sourcesfdcid, String FirmXML)
    {        
        System.debug('Merge Firm XMl:'+FirmXML);
        System.debug(target_firmid+'-'+source_firmid+'-'+targetsfdcid+'-'+sourcesfdcid);
        ACK lstResponse=new ACK();
        Id sfdcFirmId;
        Map<String, List<Account>> firmAccount=new Map<String, List<Account>>();
        if(!String.IsBlank(FirmXML))
        {
            firmAccount=MarsSyncMessageParser.ParseFirm(FirmXML);
            if(!firmAccount.isEmpty() &&firmAccount.containsKey('Success'))
            {
                sfdcFirmId=firmAccount.get('Success')[0].Id;
            }
        }
        
        System.debug(targetsfdcid);
        if(String.IsBlank(targetsfdcid))
        {
            targetsfdcid=sfdcFirmId;
            System.debug(targetsfdcid);
            if(String.IsBlank(targetsfdcid))
            {
                System.debug(target_firmid);
                List<MARSFirmSummary__c> lstcheckTarget=[Select Id from MARSFirmSummary__c Where MarsFirmId__c = : Decimal.valueOf(target_firmid)];
                if(lstcheckTarget.isEmpty())
                {
                    List<MARSFirmSummary__c> lstcheckSource=[Select Id from MARSFirmSummary__c Where MarsFirmId__c = : Decimal.valueOf(source_firmid)];
                    if(!lstcheckSource.isEmpty())
                    {
                        lstResponse.ErrorMessage='Target not found in sfdc. Check whether target has been merged';
                        lstResponse.Result=false;
                        lstResponse.MarsObjectId=target_firmid;
                        return lstResponse;
                    }
                }
            }
        }
        
        if(!String.IsBlank(sourcesfdcid))
        {
            Savepoint sp = Database.setSavepoint(); 
            try
            {            
                MARSFirmSummary__c[] firmSummaryDel = [SELECT id FROM MARSFirmSummary__c WHERE MarsFirmId__c = :decimal.valueof(source_firmid)];
                if(firmSummaryDel.size() > 0)
                {
                    MarsUtility.BYPASS_ALL_TRIGGER=true;
                    Database.Delete(firmSummaryDel);
                    Database.emptyRecycleBin(firmSummaryDel);
                    MarsUtility.BYPASS_ALL_TRIGGER=false;
                }
            }
            catch(Exception e)
            {
                Database.rollback(sp);
                lstResponse.Result=false;
                lstResponse.MarsObjectId=target_firmid;
                lstResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();
                return lstResponse;         
            }
        }
        
        if(firmAccount.containsKey('Success')) //targetsfdcid != null
        {
            try
            {
                List<Account> lstaccount=firmAccount.get('Success');
                MarsUtility.BYPASS_ALL_TRIGGER=true;
                update lstaccount;     
                if(!lstaccount.isEmpty())
                {
                    List<MARSFirmSummary__c> lstfirmsum=[Select Id from MARSFirmSummary__c WHERE MarsFirmId__c = :decimal.valueof(target_firmid)];
                    if(!lstfirmsum.isEmpty())
                    {
                        MARSFirmSummary__c firm=new MARSFirmSummary__c(Id=lstfirmsum[0].Id);
                        firm.MarsCrdId__c=lstaccount[0].MarsCrdId__c ;
                        firm.Name=lstaccount[0].MarsFirmNm__c;
                        firm.MarsFirmComment__c=lstaccount[0].MarsFirmComment__c;
                        firm.MARSFirmStatCd__c=lstaccount[0].MARSFirmStatCd__c;
                        firm.MarsFirmStatUpdDt__c=lstaccount[0].MarsFirmStatUpdDt__c;
                        firm.MarsFirmType__c=lstaccount[0].MarsFirmType__c;
                        firm.MarsGeoConc__c=lstaccount[0].MarsGeoConc__c;
                        firm.MarsNsccFirmNbr__c=lstaccount[0].MarsNsccFirmNbr__c;
                        firm.MarsNbrOfRegStates__c=lstaccount[0].MarsNbrOfRegStates__c;
                        firm.MarsSalesGoalAmt__c=lstaccount[0].MarsSalesGoalAmt__c;
                        firm.MarsSdrFlg__c=lstaccount[0].MarsSdrFlg__c;
                        firm.MarsFirmWebsite__c=lstaccount[0].MarsFirmWebsite__c;
                        update firm;
                    }
                }                
                MarsUtility.BYPASS_ALL_TRIGGER=false;
            }
            catch(Exception e)
            {
                if(String.IsBlank(sourcesfdcid)){
                    lstResponse.Result=false;
                }
                lstResponse.MarsObjectId=target_firmid;
                lstResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();
                System.debug('\n Response:'+lstResponse);
                return lstResponse; 
            }
        }
         
        lstResponse.MarsObjectId=target_firmid;
        lstResponse.Result=true;
        System.debug('\n Response:'+lstResponse);
        return lstResponse;
    }
    
    webservice static ACK SyncMergeOffice(String target_officeid,String source_officeid,String targetsfdcid, String sourcesfdcid,String OfficeXML)
    {
        System.debug('Resp:'+target_officeid+source_officeid+targetsfdcid+sourcesfdcid);
        System.debug('Target:'+targetsfdcid);
        System.debug('Source:'+sourcesfdcid);
        System.debug('Merge Ofice XMl:'+OfficeXML);
        ACK lstResponse=new ACK();
        /* Start MARS-94664:SFDC>> Issue with Fax No and Website in Office profile after Merge Office */
        Id sfdcOfficeId;
        Map<String, List<Account>> officeAccount=new Map<String, List<Account>>();
        if(!String.IsBlank(OfficeXML))
        {
            officeAccount=MarsSyncMessageParser.ParseOffice(OfficeXML);
            System.debug('Office Id Value:'+sfdcOfficeId);
            sfdcOfficeId=officeAccount.get('Success')[0].Id;
        }
        System.debug('Office Id Value:'+sfdcOfficeId);
        
        if(String.IsBlank(targetsfdcid))
        {
            targetsfdcid =sfdcOfficeId;
            if(String.IsBlank(targetsfdcid))
            {
                List<Account> lstcheckTarget=[Select Id from Account Where MarsOfficeId__c = : Decimal.valueOf(target_officeid)];
                if(lstcheckTarget.isEmpty())
                {
                    List<Account> lstcheckSource=[Select Id from Account Where MarsOfficeId__c = : Decimal.valueOf(source_officeid)];
                    if(!lstcheckSource.isEmpty())
                    {
                        lstResponse.ErrorMessage='Target not found in sfdc. Check whether target has been merged';
                        lstResponse.Result=false;
                        lstResponse.MarsObjectId=target_officeid;
                        return lstResponse;
                    }
                }
            }
        }
        /* End MARS-94664:SFDC>> Issue with Fax No and Website in Office profile after Merge Office */

        if(!String.IsBlank(sourcesfdcid))
        {
            List<Account> sourceOffice =[Select Id from Account Where MarsOfficeId__c = : Decimal.valueOf(source_officeid)];
            if(!sourceOffice.isEmpty())
            {
                //BUG73496: Getting the Address of the office and updating reps    
                List<Account> targetOffice = [select Id,BillingCountryCode,BillingStateCode,BillingStreet,BillingState,BillingCity,BillingCountry,BillingPostalCode,Phone,Fax,MarsFirmId__c,MarsOfficeId__c,MarsOffFirmType__c,MarsFirmTypeOverrideFlg__c,SFDCFirmSumId__c from Account where ID = : targetsfdcid];
                if(!targetOffice.isEmpty())
                {
                    Savepoint sp = Database.setSavepoint(); 
                    try 
                    {
                        //Bypassing the trigger                        
                        MarsUtility.BYPASS_ALL_TRIGGER=true;
                        //Merge account(Office)
                        merge targetOffice[0] sourcesfdcid;
                        //Enabling the trigger                        
                        MarsUtility.BYPASS_ALL_TRIGGER=false; 
                    }
                    catch(Exception e)
                    {
                        Database.rollback(sp); 
                        lstResponse.Result=false;
                        lstResponse.MarsObjectId=target_officeid;
                        lstResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();
                        return lstResponse;
                    }
                }
            }
        }
        
        if(officeAccount.containsKey('Success')) //MARS-100278 Previous code targetsfdcid != null
        {
            try
            {
                List<Account> lstaccount=officeAccount.get('Success');
                MarsUtility.BYPASS_ALL_TRIGGER=true;
                update lstaccount;
                MarsUtility.BYPASS_ALL_TRIGGER=false;
            }
            catch(Exception e)
            {
                lstResponse.ErrorMessage=e.getMessage()+e.getStackTraceString();
                if(String.IsBlank(sourcesfdcid))
                {
                    lstResponse.Result=false;
                }
                lstResponse.MarsObjectId=target_officeid;
                System.debug('\n Response:'+lstResponse);
                return lstResponse;
            }
        }   
        
        lstResponse.Result=true;
        lstResponse.MarsObjectId=target_officeid;
        System.debug('\n\n Response Message: '+lstResponse);
        return lstResponse;
    }  
    
    webservice static ACK SyncMergeRep(String target_repid,String source_repid,String targetsfdcid, String sourcesfdcid, String RepXML)
    {
        System.debug('Resp:'+target_repid+source_repid+targetsfdcid+sourcesfdcid);
        System.debug('Merge Rep XMl:'+RepXML);
        ACK lstResponse=new ACK();
        Id sfdcRepId;
        Map<String, List<Contact>> repContact =new Map<String, List<Contact>>();
        if(!String.IsBlank(RepXML))
        {
            repContact=MarsSyncMessageParser.ParseRep(RepXML);
            if(repContact.containsKey('Success') && !(repContact.get('Success').isEmpty()))
            {
                sfdcRepId=repContact.get('Success')[0].Id;
            }
        }
        
        System.debug('targetsfdcid'+targetsfdcid);
        if(String.IsBlank(targetsfdcid))
        {
            targetsfdcid =sfdcRepId;
            if(String.IsBlank(targetsfdcid))
            {
                List<Contact> lstcheckTarget=[Select Id from Contact Where MarsRepId__c = : Decimal.valueOf(target_repid)];
                if(lstcheckTarget.isEmpty())
                {
                    List<Contact> lstcheckSource=[Select Id from Contact Where MarsRepId__c = : Decimal.valueOf(source_repid)];
                    if(!lstcheckTarget.isEmpty())
                    {
                        lstResponse.ErrorMessage='Target not found in sfdc. Check whether target has been merged';
                        lstResponse.Result=false;
                        lstResponse.MarsObjectId=target_repid;
                        return lstResponse;
                    }
                }
            }
        }
        
        if(!String.isEmpty(sourcesfdcid))
        {
            List<Contact> targetRep=[select Id from Contact where Id = : targetsfdcid];
            List<Contact> sourceRep=[select Id from Contact where MarsRepId__c = : Decimal.valueOf(source_repid)];
            if(!sourceRep.isEmpty())
            {
                Savepoint sp = Database.setSavepoint(); 
                try
                {
                    if(!targetRep.isEmpty())
                    {
                        //Bypassing the trigger                        
                        MarsUtility.BYPASS_ALL_TRIGGER=true;
                        //Merge Contact(Rep)
                        merge targetRep[0] sourcesfdcid;
                        MarsUtility.BYPASS_ALL_TRIGGER=false;
                    }
                }
                catch(exception e)
                {
                    Database.rollback(sp); 
                    lstResponse.Result=false;
                    lstResponse.MarsObjectId=target_repid;
                    lstResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();
                    return lstResponse;
                }
            }
        }
        
        if(repContact.containsKey('Success'))
        {
            try
            {
            
                MarsUtility.BYPASS_ALL_TRIGGER=true;
                List<Contact> lstcontact=repContact.get('Success');
                update lstcontact;
                MarsUtility.BYPASS_ALL_TRIGGER=false;
            }
            catch(exception e)
            {
                if(String.isEmpty(sourcesfdcid))
                {
                    lstResponse.Result=false;
                }
                lstResponse.MarsObjectId=target_repid;
                lstResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();
                return lstResponse;
            }
        }
        
        lstResponse.Result=true;     
        lstResponse.MarsObjectId=target_repid;  
        System.debug('\n Response:'+lstResponse);
        return lstResponse;
    }
    
    webservice static ACK SyncMoveOffice(String target_firmid,String source_officeid,String targetsfdcid, String sourcesfdcid,String OfficeXML)
    {
        ACK lstResponse=new ACK();
        Id sfdcOfficeId;
        Map<String, List<Account>> officeAccount;
        System.debug(OfficeXML);
        if(!String.IsBlank(OfficeXML))
        {
            officeAccount=MarsSyncMessageParser.ParseOffice(OfficeXML);
            sfdcOfficeId = officeAccount.get('Success')[0].Id;
        }
        
        if(String.IsBlank(targetsfdcid))
        {
            targetsfdcid =sfdcOfficeId ;
            if(String.isBlank(targetsfdcid))
            {
                lstResponse.ErrorMessage='target firm id should not be null';
                lstResponse.Result=false;
                lstResponse.MarsObjectId=source_officeid;
                System.debug('\n Response:'+lstResponse);
                return lstResponse;
            }
        }        
  
        if(!String.IsBlank(sourcesfdcid))
        {
            //Create Insatnce for Surviving and Merged records
            //Account moveOffice;
            Account targetFirm;
            Savepoint sp = Database.setSavepoint(); 
            try
            {
                //Bypassing the trigger                        
                MarsUtility.BYPASS_ALL_TRIGGER=true;
                List<Account> lstaccount=officeAccount.get('Success');
                targetFirm = [select Id, SFDCFirmSumId__c from Account where Id = : targetsfdcid];
                lstaccount[0].SFDCFirmSumId__c=targetFirm.SFDCFirmSumId__c;
                update lstaccount;
            }
            catch(Exception e)
            {
                Database.rollback(sp); 
                lstResponse.Result=false;
                lstResponse.MarsObjectId=source_officeid;
                lstResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();
                System.debug('\n Response:'+lstResponse);
                return lstResponse;
            }
        }
        
        lstResponse.Result=true;  
        lstResponse.MarsObjectId=source_officeid;
        System.debug('\n Response:'+lstResponse);
        return lstResponse;
    }
    
    webservice static ACK SyncMoveRep(String RepXML,String marsrepid)
    {
        ACK lstResponse=new ACK();
        System.debug(RepXML);
        System.debug(marsrepid);    
        //if(RepXML.length() <=0)
        if(String.IsBlank(RepXML))
        {
            //if(RepXML.length() <=0)
            if(String.IsBlank(RepXML))
            {
                lstResponse.ErrorMessage='rep xml should not be null';
                lstResponse.Result=false;
                lstResponse.MarsObjectId=marsrepid;
                System.debug('\n Response:'+lstResponse);
                return lstResponse;
            }   
            
        }            
        Map<String, List<Contact>> repContact=MarsSyncMessageParser.ParseRep(RepXML);            
        if(repContact.containsKey('Success'))
        {
            List<Contact> lstcontact=repContact.get('Success');
            Account repOffice;
            // Bypassing the trigger                        
            try
            {
                MarsUtility.BYPASS_ALL_TRIGGER=true;
                repOffice = [select Id, SFDCFirmSumId__c from Account where Id = : lstcontact[0].AccountId];
                lstcontact[0].SFDCFirmSumId__c=repOffice.SFDCFirmSumId__c;
                update lstcontact;
                MarsUtility.BYPASS_ALL_TRIGGER=false;
            }
            catch(Exception e)
            {
                lstResponse.ErrorMessage=e.getMessage()+e.getStackTraceString();
                lstResponse.Result=false;
                lstResponse.MarsObjectId=marsrepid;
                System.debug('\n Response:'+lstResponse);
                return lstResponse;
            }
        }
        lstResponse.Result=true; 
        lstResponse.MarsObjectId=marsrepid;
        System.debug('\n Response:'+lstResponse);
        return lstResponse;
    }
    
    webservice static List<ACK> SyncDelete(String deleteXML)
    {
        List<ACK> lstResponse=new List<ACK>();

        try
        {
            Map<String, List<Sobject>> deleteRecords=MarsSyncMessageParser.parseDelete(deleteXML);
            String objectType;
            List<Account> lstAccountDelete;
            List<Contact> lstContactDelete;
            List<MarsRepTeam__c> lstTeamRepDelete; 

            if(deleteRecords.containsKey('OfficeSuccess') || deleteRecords.containsKey('OfficeErrors'))
            {
               objectType = 'Office';
            }
            else if(deleteRecords.containsKey('RepSuccess') || deleteRecords.containsKey('RepErrors'))
            {
                objectType = 'Rep';
            }
            else if(deleteRecords.containsKey('TeamRepSuccess') || deleteRecords.containsKey('TeamRepErrors'))
            {
                objectType = 'TeamRep';
            }
             
            System.debug('\n Object Type:'+objectType);
            if(objectType=='Office')
            {
                if(deleteRecords.containsKey('OfficeSuccess'))
                {
                    lstAccountDelete=deleteRecords.get('OfficeSuccess');
                    System.debug('\n List Size()'+lstAccountDelete.size());
                    
                    if(!lstAccountDelete.IsEmpty())
                    {                    
                        MarsUtility.BYPASS_ALL_TRIGGER=true;
                        List<Database.DeleteResult> deleteResult = Database.Delete(lstAccountDelete);
                        MarsUtility.BYPASS_ALL_TRIGGER=false;
                        for(integer i=0;i<deleteresult.size();i++)
                        {
                            ACK objSFDCResponse=new ACK();
                            if(deleteresult[i].isSuccess())
                            {
                                objSFDCResponse.SFDCObjectId=deleteresult[i].Id;
                                objSFDCResponse.MarsObjectId=String.valueOf(lstAccountDelete[i].MarsOfficeId__c);
                                objSFDCResponse.Result=deleteresult[i].isSuccess();
                            }
                            else
                            {
                                objSFDCResponse.SFDCObjectId=deleteresult[i].Id;
                                objSFDCResponse.MarsObjectId=String.valueOf(lstAccountDelete[i].MarsOfficeId__c);
                                objSFDCResponse.Result=deleteresult[i].isSuccess();
                                objSFDCResponse.ErrorMessage=deleteresult[i].errors[0].message;
                            }
                            lstResponse.add(objSFDCResponse);
                        }
                    }
                }
                if(deleteRecords.containsKey('OfficeErrors'))
                {
                    lstAccountDelete=deleteRecords.get('OfficeErrors');
                    
                    if(!lstAccountDelete.IsEmpty())
                    {                        
                        System.debug('\n in Error Block');
                        for(integer i=0;i<lstAccountDelete.size();i++)
                        {
                            ACK objSFDCResponse=new ACK();
                            objSFDCResponse.MarsObjectId=String.valueOf(lstAccountDelete[i].MarsOfficeId__c);
                            objSFDCResponse.Result=false;
                            objSFDCResponse.ErrorMessage=lstAccountDelete[i].Description;
                            if(objSFDCResponse.ErrorMessage == 'External Id not found in SFDC')
                            {
                                List<Account> lstAccount=[SELECT Id FROM Account WHERE marssfs__MarsOfficeId__c = :lstAccountDelete[i].MarsOfficeId__c];
                                if(!lstAccount.isEmpty())
                                {
                                    delete lstAccount;
                                }
                                objSFDCResponse.Result = true; 
                            }
                            lstResponse.add(objSFDCResponse);
                        }
                    }
                }
            }
            else if(objectType=='Rep')
            {
                if(deleteRecords.containsKey('RepSuccess'))
                {
                    lstContactDelete=deleteRecords.get('RepSuccess');
                    //if(lstContactDelete.size()>0){
                    if(!lstContactDelete.IsEmpty())
                    {
                        MarsUtility.BYPASS_ALL_TRIGGER=true;
                        List<Database.DeleteResult> deleteResult = Database.Delete(lstContactDelete,false);
                        System.debug('\n Delete Result'+deleteResult);
                        MarsUtility.BYPASS_ALL_TRIGGER=false;
                        for(integer i=0;i<deleteresult.size();i++)
                        {
                            ACK objSFDCResponse=new ACK();
                            if(deleteresult[i].isSuccess())
                            {
                                objSFDCResponse.SFDCObjectId=deleteresult[i].Id;
                                objSFDCResponse.MarsObjectId=String.valueOf(lstContactDelete[i].MarsRepId__c);
                                objSFDCResponse.Result=deleteresult[i].isSuccess();
                            }
                            else
                            {
                                objSFDCResponse.SFDCObjectId=deleteresult[i].Id;
                                objSFDCResponse.MarsObjectId=String.valueOf(lstContactDelete[i].MarsRepId__c);
                                objSFDCResponse.Result=deleteresult[i].isSuccess();
                                objSFDCResponse.ErrorMessage=deleteresult[i].errors[0].message;
                            }
                            lstResponse.add(objSFDCResponse);
                        }
                    }
                }
                if(deleteRecords.containsKey('RepErrors'))
                {
                    lstContactDelete=deleteRecords.get('RepErrors');
                    if(!lstContactDelete.IsEmpty())
                    {
                        for(integer i=0;i<lstContactDelete.size();i++)
                        {
                            ACK objSFDCResponse=new ACK();
                            objSFDCResponse.MarsObjectId=String.valueOf(lstContactDelete[i].MarsRepId__c);
                            objSFDCResponse.ErrorMessage=lstContactDelete[i].Description;
                            objSFDCResponse.Result=false;
                            if(objSFDCResponse.ErrorMessage == 'External Id not found in SFDC')
                            {
                                List<Contact> lstRep=[SELECT Id FROM Contact WHERE MarsRepId__c = :lstContactDelete[i].MarsRepId__c];
                                if(!lstRep.isEmpty())
                                {
                                    delete lstRep;
                                }
                                objSFDCResponse.Result = true; 
                            }
                            lstResponse.add(objSFDCResponse);
                        }
                    }
                }
            }
            else if(objectType == 'TeamRep')
            {
                if(deleteRecords.containsKey('TeamRepSuccess'))
                {
                    lstTeamRepDelete=deleteRecords.get('TeamRepSuccess');

                    if(!lstTeamRepDelete.IsEmpty())
                    {
                        MarsUtility.BYPASS_ALL_TRIGGER=true;
                        List<Database.DeleteResult> deleteResult = Database.Delete(lstTeamRepDelete,false);
                        System.debug('\n Delete Result'+deleteResult);
                        MarsUtility.BYPASS_ALL_TRIGGER=false;
                        for(integer i=0;i<deleteresult.size();i++)
                        {
                            ACK objSFDCResponse=new ACK();
                            if(deleteresult[i].isSuccess())
                            {
                                objSFDCResponse.SFDCObjectId=deleteresult[i].Id;
                                objSFDCResponse.MarsObjectId=String.valueOf(lstTeamRepDelete[i].MarsTeamRepId__c+'-'+lstTeamRepDelete[i].MarsRepId__c);
                                objSFDCResponse.Result=deleteresult[i].isSuccess();
                            }
                            else
                            {
                                objSFDCResponse.SFDCObjectId=deleteresult[i].Id;
                                objSFDCResponse.MarsObjectId=String.valueOf(lstTeamRepDelete[i].MarsTeamRepId__c+'-'+lstTeamRepDelete[i].MarsRepId__c);
                                objSFDCResponse.Result=deleteresult[i].isSuccess();
                                objSFDCResponse.ErrorMessage=deleteresult[i].errors[0].message;
                            }
                            lstResponse.add(objSFDCResponse);
                        }
                    }
                }
                if(deleteRecords.containsKey('TeamRepErrors'))
                {
                    lstTeamRepDelete=deleteRecords.get('TeamRepErrors');
                    if(!lstTeamRepDelete.IsEmpty())
                    {
                        for(integer i=0;i<lstTeamRepDelete.size();i++)
                        {
                            ACK objSFDCResponse=new ACK();
                            objSFDCResponse.MarsObjectId=String.valueOf(lstTeamRepDelete[i].MarsTeamRepId__c+'-'+lstTeamRepDelete[i].MarsRepId__c);
                            objSFDCResponse.ErrorMessage=lstTeamRepDelete[i].Name;
                            objSFDCResponse.Result=false;
                            if(objSFDCResponse.ErrorMessage == 'External Id not found in SFDC')
                            {
                                List<MarsRepTeam__c> lstTeamRep=[SELECT Id,MarsRepId__c,MarsTeamRepId__c,SfdcRepId__c,SfdcTeamRepId__c FROM MarsRepTeam__c WHERE MarsTeamRepId__c = :lstTeamRepDelete[i].MarsTeamRepId__c AND MarsRepId__c = : lstTeamRepDelete[i].MarsRepId__c];
                                if(!lstTeamRep.isEmpty())
                                {
                                    delete lstTeamRep;
                                }
                                objSFDCResponse.Result = true;   
                            }
                            
                            lstResponse.add(objSFDCResponse);
                        }
                    }
                }
            }
        }
        catch (exception e)
        {
            ACK objSFDCResponse=new ACK();
            objSFDCResponse.Result=false;
            objSFDCResponse.MarsObjectId='';
            objSFDCResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();
            lstResponse.add(objSFDCResponse);
            System.debug(e.getStackTraceString()+'--'+e.getmessage());
        }
        System.debug('\n Output Response:'+lstResponse);
        return lstResponse;
    }
 
    webservice static List<ACK> SyncFirmType(String FirmTypeXML)
    {
        List<ACK> lstResponse=new List<ACK>();
        try
        {
            Map<String, List<MarsCd__c>> marsCodeValues=MarsSyncMessageParser.parseFirmType(FirmTypeXML);
            Schema.SObjectField externalIdField = MarsCd__c.MarsCdTypeCd__c;
            if(marsCodeValues.containsKey('Success'))
            {
                List<MarsCd__c> lstFirmType=marsCodeValues.get('Success');
                //if(lstFirmType.size()>0)
                if(!lstFirmType.IsEmpty())
                { 
                    MarsUtility.BYPASS_ALL_TRIGGER=true;
                    List<Database.UpsertResult> result= Database.upsert(lstFirmType, externalIdField,false);
                    MarsUtility.BYPASS_ALL_TRIGGER=false;
                    //looping the upsertcodevalues results to get the salesforce ids and mars ids.
                    for(Integer i=0;i<result.size();i++)
                    {                           
                        ACK objSFDCResponse=new ACK();
                        if(result[i].isSuccess())
                        {
                            // Assigning Salesforce ids to SFDCObjectId
                            objSFDCResponse.SFDCObjectId=result[i].Id;
                            // Assigning rep ids(EXTERNAL_ID__c in salesforce) to MarsObjectId
                            objSFDCResponse.MarsObjectId=String.valueOf(lstFirmType[i].MarsCdCd__c);
                            objSFDCResponse.Result=result[i].isSuccess();
                        }
                        else
                        {
                            objSFDCResponse.SFDCObjectId='';
                          
                            // Assigning ids(EXERNAL_ID__c in salesforce) to MarsObjectId
                            objSFDCResponse.MarsObjectId=String.valueOf(lstFirmType[i].MarsCdCd__c);
                            objSFDCResponse.Result=result[i].isSuccess();
                            objSFDCResponse.ErrorMessage=result[i].errors[0].message+result[i].errors[0].fields;
                        }
                        // Adding the upsertresult object to list
                        lstResponse.add(objSFDCResponse);
                    }
                }
            }
            if(marsCodeValues.containsKey('Errors'))
            {
                List<MarsCd__c> errorCodeValues=marsCodeValues.get('Errors');
                
                if(!errorCodeValues.IsEmpty())
                {
                    for(integer i=0;i<errorCodeValues.size();i++){
                        ACK objSFDCResponse=new ACK();
                        objSFDCResponse.MarsObjectId=String.valueOf(errorCodeValues[i].MarsCdCd__c);
                        objSFDCResponse.Result=false;
                        objSFDCResponse.ErrorMessage=errorCodeValues[i].Name;
                        lstResponse.add(objSFDCResponse);
                    }
                }
            }
        }
        catch(exception e)
        {
            ACK objSFDCResponse=new ACK();
            objSFDCResponse.Result=false;
            objSFDCResponse.ErrorMessage=e.getStackTraceString()+'--'+e.getmessage();    
            lstResponse.add(objSFDCResponse);
            // Creating the Errorlogging record.
        }
        System.debug('\n Response Output:'+lstResponse);
        return lstResponse;
    }
}