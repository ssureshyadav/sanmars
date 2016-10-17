/**
 *  Description     :   Controller class for managing Firm VF Pages 
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
    12/2/2013    Suresh     BUG73660
    12/2/2013    Suresh     BUG73668
    12/2/2013    Suresh     BUG73671
    12/2/2013    Suresh     BUG73675
    12/27/2013   Suresh     BUG73997
    11/6/2014    Rakesh     BUG79869, BUG79873    
    --------------------------------------------------------------
 **/

public class MarsFirmController
{
    public String selectedpicklistvalue {get;set;}
    
    public String selecteddropdown {get;set;}

    public Boolean ownedByMe {get;set;}

    public List<string> alphabet{get;set;}

    public String alphabetvalue {get;set;}

    private static List<Account> accountSetList{get; set;}
    private static List<MARSFirmSummary__c> firmSetList{get; set;}
    
    private transient List<MARSFirmSummary__c> firmList;

    public Id accountID;

    public Boolean showContent {get; set;}
    public Boolean firmNameEdit {get; set;}

    public Account firmrecord {get; set;}

    public ApexPages.StandardSetController standardSetCon {get;set;}

    private static string accountListQuery;

    private static string firmFilter;
    private static string firmOrderBy;
    private static integer recordLimit;
    MARSDefaults__c marsDefaults = MarsUtility.MARS_DEFAULTS;
    
    public String msg{get;set;}

    public List<selectOption> marsFirmType
    {
        get
        {
            List<selectOption> options = new List<selectOption>();
            for (MarsCd__c type : MarsCd__c.getAll().values())
            {
                if(type.MarsCdType__c == 'FTY')
                {
                    options.add(new SelectOption(type.MarsCdCd__c,type.Name));
                }
            }
            return options;
        }
        set; 
    }

    //Method used to get the firm type values in the firm_edit page
    public List<SelectOption> getfirmstatusValue()
    {
        List<selectOption> statusOptions = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription = Account.MarsFirmStatCd__c.getDescribe();
        List<Schema.PicklistEntry> firmstatus = statusFieldDescription.getPicklistValues();
        if(!firmstatus.IsEmpty())
        {
            for(Schema.Picklistentry picklistEntry:firmstatus)
            {
                statusOptions.add(new SelectOption(pickListEntry.getLabel(),pickListEntry.getValue()));
            }
        }
        return statusOptions;
    }
    
    public MarsFirmController(){
    }

    //Constructor
    public MarsFirmController(ApexPages.StandardController stdcontroller)
    {
        string officeNamingMethod = marsDefaults.MARSOfficeNamingMethod__c;
        if(officeNamingMethod == 'FA' || officeNamingMethod == 'FI' || officeNamingMethod == 'FS' || officeNamingMethod == 'SF')
        {
            firmNameEdit = False;
        }
        else
        {
            firmNameEdit = True;
        }
        accountID = System.currentPageReference().getParameters().get('Id');
        firmrecord = (Account) stdcontroller.getRecord();
        alphabet=new string[]{'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z','Other','All' };
    }

    //Method used to get the firm type values in the firm_edit page
    public string getfirmtypeValue()
    {
        if(accountID != null)
        {
            System.debug('\n Account Id'+accountID);
            String firmType = '';
            String firmtypeCd;
            List<Account> firmvalue=[select MarsFirmType__c from Account where Id = : accountID Limit 1];
            if(!firmvalue.IsEmpty())
            {
                firmtypeCd = (String) firmvalue[0].MarsFirmType__c;

                //Adding custom settings to the select list
                for(MarsCd__c codesetting: MarsCd__c.getAll().values())
                {
                    if(codesetting.MarsCdType__c == 'FTY' && codesetting.MarsCdCd__c==firmtypeCd)
                    {
                        firmType = codesetting.name;
                    }
                }
            }
            if(firmType=='')
            {
                firmType=firmtypeCd;
            }
            return firmType;
        }
        else
        {
            return null;
        }
    }

    //This method used to dispaly the name in the VF_FirmEdit section header
    public string getpageSubtitle()
    {
        String subtitle = (String) firmrecord.MarsFirmNm__c;
        if(subtitle==null)
        {
            subtitle = 'New Firm';
        }
        return subtitle;
    }

    //Method used in all the pages(List,View,Search) table
    public List<Account> getCurrentList()
    {
        accountSetList = new List<Account>();
        if(standardSetCon !=null)
        {
            for (Account account : (List<Account>)standardSetCon.getRecords())
            {
                accountSetList.add(account);
            }
        }
        return accountSetList;
    }

    public List<MARSFirmSummary__c> getCurrentFirmList()
    {
        firmSetList = new List<MARSFirmSummary__c>();
        if(standardSetCon !=null)
        {
            for (MARSFirmSummary__c firmsum : (List<MARSFirmSummary__c>)standardSetCon.getRecords())
            {
                firmSetList.add(firmsum);
            }
        }
        return firmSetList;
    }

    public Integer officerecordsvalue {get; set;}
    public Integer branchOfficRecordsCount{get;set;}
    //Method used in VF_FirmDetail for get the offices of a firm.
    public List<Account> getOfficeList()
    {
        System.debug(officerecordsvalue);
        String officeRecords;
        integer officeCount;
        String parentId= Apexpages.currentPage().getParameters().get('Id');
        branchOfficRecordsCount=[Select Count() from Account where ParentId =: parentId];
        System.debug('Branch Office Records:'+branchOfficRecordsCount);
        if(officerecordsvalue >0)
        {
            officeCount = officerecordsvalue;
        }
        else
        {
            officeCount = 5;
        }
        
        if(officerecordsvalue == null)
        {
            officerecordsvalue=5;
        }
        
        officeRecords='Select Id,Name,BillingCity,BillingState,BillingStreet,BillingCountry,Phone,MarsYtdPurch__c,MarsYtdRed__c,MarsCAssets__c from Account where ParentId = '+ '\''+parentId+'\'' + 'limit ' + officeCount;

        standardSetCon = new ApexPages.StandardSetController(Database.getQueryLocator(officeRecords));
        System.debug(officerecordsvalue);
        standardSetCon.setPageSize(officerecordsvalue);
        return standardSetCon.getRecords();
    }

    public Pagereference relatedOfficeList()
    {
        System.debug('\n In Related OfficeList');
        System.debug(officerecordsvalue);
        getOfficeList();
        System.debug(officerecordsvalue);

        return null;
    }

    //This Method used in VF_FirmList page
    public List<SelectOption> getviews()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('F','Recent Firms'));
        options.add(new SelectOption('A','Active Firms'));
        options.add(new SelectOption('I','Inactive Firms'));
        return options;
    }

    //This Method used in VF_FirmList page
    public List<SelectOption> getsideviews()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('C','Recently Created'));
        options.add(new SelectOption('M','Recently Modified'));
        options.add(new SelectOption('V','Recently Viewed'));
        return options;
    }

    public PageReference refresh()
    {
        return null;
    }

    //This Method used in VF_FirmList page
    public PageReference refreshList()
    {
        System.debug('\n In Refreshlist View');
        standardSetCon = null;
        String filterExpression = 'SfdcFirmId__r.' + sortExpression;
        String sortFullExp = sortExpression  + ' ' + sortDirection;

        if(sortExpression == 'MarsYtdPurch__c' || sortExpression == 'MarsYtdRed__c' || sortExpression == 'MarsCAssets__c')
        {
            firmOrderBy = sortFullExp;
        }
        else
        {
            firmOrderBy = 'SfdcFirmId__r.' + sortFullExp;
        }

        if(apexpages.currentpage().getparameters().get('selectedpicklist') != null)
        {
            selectedpicklistvalue = apexpages.currentpage().getparameters().get('selectedpicklist');
        }

        if(selectedpicklistvalue == null)
        {
            selectedpicklistvalue='F';
        }

        if(selectedpicklistvalue=='F')
        {
            //firmOrderBy = 'SfdcFirmId__r.CreatedDate desc,' + firmOrderBy;
            firmFilter = 'SfdcFirmId__r.MarsFirmStatCd__c = \'Active\'';
        }
        else if(selectedpicklistvalue=='A'||selectedpicklistvalue=='I')
        {   String firmStatus = (selectedpicklistvalue=='A') ? 'Active':'Inactive';
            firmFilter = 'SfdcFirmId__r.MarsFirmStatCd__c = ' + '\'' + firmStatus + '\'';
        }

        if((alphabetvalue == 'All') || (alphabetvalue == Null) ||  alphabetvalue == 'Other')
        {
            if(alphabetvalue == 'Other')
            {
                firmFilter = (firmFilter==null) ? '':(firmFilter + ' And ') + filterExpression + ' != null AND (NOT (' + filterExpression +' like \'a%\' or '+filterExpression+' like \'b%\' or '+ filterExpression+' like \'c%\' or '+ filterExpression+' like \'d%\' or '+ filterExpression+' like \'e%\' or '+ filterExpression+' like \'f%\' or '+ filterExpression+' like \'g%\' or '+ filterExpression+' like \'h%\' or '+ filterExpression+' like \'i%\' or '+ filterExpression+' like \'j%\' or '+ filterExpression+' like \'k%\' or '+ filterExpression+' like \'l%\' or '+ filterExpression+' like \'m%\' or '+ filterExpression+' like \'n%\' or '+ filterExpression+' like \'o%\' or '+ filterExpression+' like \'p%\' or '+ filterExpression+' like \'q%\' or '+ filterExpression+' like \'r%\' or '+ filterExpression+' like \'s%\' or '+ filterExpression+' like \'t%\' or '+ filterExpression+' like \'u%\' or '+ filterExpression+' like \'v%\' or '+ filterExpression+' like \'w%\' or '+ filterExpression+' like \'x%\' or '+ filterExpression+' like \'y%\' or '+ filterExpression+' like \'z%\')) ';
            }
        }
        else
        {
            firmFilter = (firmFilter==null) ? '':(firmFilter + ' And ') + filterExpression + ' != null AND ' + filterExpression + ' like \''+ alphabetvalue + '%\'';
        }
        
        System.debug('\n Firm Filter:'+firmFilter);
        recordLimit = 10000;
       // firmList=firmQuery(firmFilter,firmOrderBy,recordLimit);
        System.debug('Query Value:'+ accountListQuery);
        //standardSetCon = new ApexPages.StandardSetController(firmList);
        standardSetCon = new ApexPages.StandardSetController(Database.getQuerylocator(firmQueryvalue(firmFilter, firmOrderBy, recordLimit)));
        standardSetCon.setPageSize(200);

        return null;
    }

    public PageReference firmOfficesRefreshList()
    {
        standardSetCon = null;
        string s;
        if(apexpages.currentpage().getparameters().get('Id') != null)
        {
            String parentId= apexpages.currentpage().getparameters().get('Id');
            if((apexpages.currentpage().getparameters().get('alpha') == 'All') || (apexpages.currentpage().getparameters().get('alpha') == Null)  )
            {
                s='%';
                system.debug('#### + insideif' + apexpages.currentpage().getparameters().get('alpha'));
            }
            else
            {
                system.debug('#### + insideelse' + apexpages.currentpage().getparameters().get('alpha'));
                s= apexpages.currentpage().getparameters().get('alpha')+'%';
            }
            accountListQuery= 'Select Id,Name,MarsFirmNm__c,BillingCity,BillingState,MarsFirmType__c,Phone from  Account where ParentId = ' +'\'' + parentId +'\''+' and Name like' +'\''+s +'\''+ ' ORDER BY MarsFirmNm__c  limit 10000';               
            standardSetCon = new ApexPages.StandardSetController(Database.getQueryLocator(accountListQuery));
            standardSetCon.setPageSize(200);
        }
        return null;
    }

    public PageReference firmOffices()
    {
        standardSetCon = null;
        string s;
        if(apexpages.currentpage().getparameters().get('Id') != null)
        {
            String parentId= apexpages.currentpage().getparameters().get('Id');
            System.debug('\n Account ID'+apexpages.currentpage().getparameters().get('Id'));
            accountListQuery= 'Select Id,Name,MarsFirmNm__c,BillingCity,BillingState,MarsFirmType__c,phone from  Account where ParentId = ' +'\'' + parentId +'\''+ '  limit 9999';
        }
        standardSetCon = new ApexPages.StandardSetController(Database.getQueryLocator(accountListQuery));
        standardSetCon.setPageSize(35);
        return null;
    }

    public PageReference sidebardropdown()
    {
        standardSetCon = null;
        showContent = true;
        if(Apexpages.currentPage().getParameters().get('contIdParam') != null)
        {
            officerecordsvalue=Integer.valueOf(Apexpages.currentPage().getParameters().get('contIdParam'));
        }
        System.debug('\n:Cont Param:'+Apexpages.currentPage().getParameters().get('contIdParam'));

        if(officerecordsvalue == null)
        {
            officerecordsvalue=25;
        }
        
        System.debug('\n Dropdown Value:'+selecteddropdown);
        
        if(selecteddropdown == null)
        {
            selecteddropdown= 'M';
        }

        firmOrderBy = 'SfdcFirmId__r.MarsFirmNm__c asc';
        if(selecteddropdown == 'C')
        {
            firmOrderBy = 'SfdcFirmId__r.CreatedDate desc NULLS LAST,' + firmOrderBy;
        }
        else if(selecteddropdown == 'M')
        {
            firmOrderBy = 'SfdcFirmId__r.LastModifiedDate desc NULLS LAST,' + firmOrderBy;
        }
        else if(selecteddropdown == 'V')
        {
            firmOrderBy = 'SfdcFirmId__r.LastViewedDate desc NULLS LAST,' + firmOrderBy;
        }
        recordLimit = officerecordsvalue;
        //firmList=firmQuery(firmFilter,firmOrderBy,recordLimit);
        System.debug('Query String Value:'+accountListQuery);
        
        //standardSetCon = new ApexPages.StandardSetController(firmList);
        standardSetCon = new ApexPages.StandardSetController(Database.getQuerylocator(firmQueryvalue(firmFilter, firmOrderBy, recordLimit)));
        // sets the number of records in each page set
        standardSetCon .setPageSize(officerecordsvalue);
        return null;
    }

    public transient String query {get; set;}

    // Calling this method for search in VF_FirmList and VF_FirmView 
    public Pagereference runQuery()
    {
        if(query == null || query == '')
        {
            msg=' Error: Please enter a search string at least 2 characters long.';
        }
        else
        {
            query=EncodingUtil.urlEncode(query,'UTF-8');
        }
        PageReference detailview = new pagereference('/apex/VF_SearchFirm?searchtext='+query+'&owned='+ownedByMe);
        detailview.setRedirect(true);
        return detailview;
    }

    //This Method is calling from VF_SearchFirm
    public void searchvalue()
    {
        if(apexpages.currentpage().getparameters().get('owned') == 'true')
        {
            ownedByMe=true;
        }
        else
        {
            ownedByMe=false;
        }

        if(apexpages.currentpage().getparameters().get('searchtext') != null)
        {
            query = apexpages.currentpage().getparameters().get('searchtext');

            if(query.length() <2)
            {
                msg=' Error: Please enter a search string at least 2 characters long.';
                standardSetCon = null;
            }
            else
            {
                query=Matcher.quoteReplacement(query);
                if(query.contains('\''))
                {
                    query=String.escapeSingleQuotes(query);
                }
                firmFilter = 'SfdcFirmId__r.MarsFirmNm__c like ' + '\'%' + query + '%\'';
                if(ownedbyme)
                {
                    firmFilter = 'SfdcFirmId__r.OwnerId = '+ '\'' + UserInfo.getUserId() + '\' And ' + firmFilter;
                }
                recordLimit = 10000;
                firmOrderBy = 'SfdcFirmId__r.MarsFirmNm__c asc';
                //firmList=firmQuery(firmFilter,firmOrderBy,recordLimit);
                System.debug('\n Account List Query:'+accountListQuery);
                standardSetCon = new ApexPages.StandardSetController(Database.getQuerylocator(firmQueryvalue(firmFilter, firmOrderBy, recordLimit)));
                // sets the number of records in each page set
                standardSetCon .setPageSize(25);
            }
        }
    }

    public PageReference editfirm()
    {
        PageReference detailview = new pagereference('/apex/VF_firmedit?id='+firmrecord.id);
        detailview.setRedirect(true);
        return detailview;
    }

    public PageReference newOffice()
    {
        String prefix='';
        LIST<ApexClass> namespaceprefix=[SELECT NamespacePrefix FROM ApexClass WHERE Name = 'MarsfirmController'];
        if(!(namespaceprefix.isEmpty()))
        if(namespaceprefix[0].NamespacePrefix != null)
            prefix = namespaceprefix[0].NamespacePrefix + '__';

        PageReference detailview = new pagereference('/001/e?retURL=/apex/'+prefix+'VF_firmdetail?id='+firmrecord.id+'&acc3='+firmrecord.Name+'&ParentId='+firmrecord.id+'&acc3_lkid='+firmrecord.id+'&RecordType='+MarsUtility.AccountRecordType);
        detailview.setRedirect(true);
        return detailview;
    }

    public PageReference newOfficeRelatedList()
    {
        String prefix='';
        LIST<ApexClass> namespaceprefix=[SELECT NamespacePrefix FROM ApexClass WHERE Name = 'MarsFirmController'];
        if(namespaceprefix[0].NamespacePrefix != null)
        {
            prefix = namespaceprefix[0].NamespacePrefix + '__';
        }
        System.debug('\n Firm Record Value:'+firmrecord);
        PageReference detailview = new pagereference('/001/e?retURL=/apex/'+prefix+'VF_relatedlist?id='+firmrecord.id+'&acc3='+firmrecord.Name+'&ParentId='+firmrecord.id+'&acc3_lkid='+firmrecord.id+'&RecordType='+MarsUtility.AccountRecordType);
        detailview.setRedirect(true);
        return detailview;
    }

    public PageReference relatedListOffice()
    {
        PageReference detailview = new pagereference('/apex/VF_relatedlist?id='+firmrecord.id);
        detailview.setRedirect(true);
        return detailview;
    }

    public PageReference newaction()
    {
        System.debug('\n Apex return url value:'+apexpages.currentPage().getParameters().get('selectedpicklist'));
        PageReference detailview;
        if(apexpages.currentPage().getParameters().get('selectedpicklist') !=null)
        {
            detailview = new pagereference('/apex/VF_firmedit?retURL=/apex/VF_FirmView');
        }
        else
        {
            detailview = new pagereference('/apex/VF_firmedit?retURL=/apex/VF_FirmList');
        }
        detailview.setRedirect(true);
        return detailview;
    }

    public PageReference redirect()
    {
        //PageReference reference = new pagereference('/apex/VF_FirmView?selectedpicklist='+selectedpicklistvalue +'&alphabet=NULL');
        PageReference reference = new pagereference('/apex/VF_FirmView?selectedpicklist='+selectedpicklistvalue);
        //PageReference reference = new pagereference('/apex/TestFirmView?selectedpicklist='+selectedpicklistvalue);
        reference.setRedirect(true);
        return reference;
    }

    Public Boolean HasNext{ get{ return standardSetCon.getHasNext();} set; }
    Public Boolean HasPrevious{ get{ return standardSetCon.getHasPrevious();}set;}
    Public Void First() { standardSetCon.First(); }
    Public Void Last(){ standardSetCon.Last(); }
    Public Void Previous(){ standardSetCon.Previous(); }
    Public Void Next()
    {
        standardSetCon.Next();
    }

    private String sortDirection = 'ASC';
    private String sortExp = 'MarsFirmNm__c';

    public String sortExpression
    {
        get
        {
            return sortExp;
        }
        set
        {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
                sortExp = value;
        }
    }

    public String getSortDirection()
    {
        //if no column is selected 
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }

    public PageReference viewSearchData()
    {
        //build the full sort expression
        query = apexpages.currentpage().getparameters().get('searchtext');
        firmFilter = 'SfdcFirmId__r.MarsFirmNm__c like ' + '\'%' + query + '%\'';
        recordLimit = 10000;
        if(sortExpression == 'MarsYtdPurch__c' || sortExpression == 'MarsYtdRed__c' || sortExpression == 'MarsCAssets__c')
        {
            firmOrderBy = sortExpression  + ' ' + sortDirection;
        }
        else
        {
            firmOrderBy = 'SfdcFirmId__r.' + sortExpression  + ' ' + sortDirection;
        }

        //firmList=firmQuery(firmFilter,firmOrderBy,recordLimit);
        standardSetCon = new ApexPages.StandardSetController(Database.getQuerylocator(firmQueryvalue(firmFilter, firmOrderBy, recordLimit)));
        standardSetCon.setPageSize(25);
        return null;
    }

    public String sortExpresssionTemp;

    public PageReference ViewData()
    {
        //build the full sort expression
        System.debug('\n In ViewData');
        System.debug('\n Alphabet Value From Assign Value:'+alphabetvalue);
        transient String  sortFullExp = sortExpression  + ' ' + sortDirection;
        transient String  filterExpression = 'SfdcFirmId__r.' + sortExpression;
        showContent = false;

        System.debug('\n sortExpresssionTemp'+sortExpresssionTemp);
        if(sortExpression != sortExpresssionTemp && sortExpresssionTemp != null)
        {
            alphabetvalue=null;
        }

        sortExpresssionTemp = sortExpression;

        System.debug('\n sortExpresssionTemp'+sortExpresssionTemp);
        if(sortExpresssionTemp == 'MarsYtdPurch__c' || sortExpresssionTemp == 'MarsYtdRed__c' || sortExpresssionTemp == 'MarsCAssets__c')
        {
            showContent = true;
            firmOrderBy = sortFullExp;
            alphabetvalue=null;
        }
        else
        {
            firmOrderBy = 'SfdcFirmId__r.' + sortFullExp;
        }

        System.debug('\n Selected Picklist value in view page:'+selectedpicklistvalue);
        System.debug('\n Alphabet Value:'+alphabetvalue);

        if(selectedpicklistvalue=='F')
        {
            //firmOrderBy = 'SfdcFirmId__r.CreatedDate desc,' + firmOrderBy;
            firmFilter = 'SfdcFirmId__r.MarsFirmStatCd__c = \'Active\'';
        }
        else if(selectedpicklistvalue=='A'||selectedpicklistvalue=='I')
        {   String firmStatus = (selectedpicklistvalue=='A') ? 'Active':'Inactive';
            firmFilter = 'SfdcFirmId__r.MarsFirmStatCd__c = ' + '\'' + firmStatus + '\'';
        }

        if((alphabetvalue == 'All') || (alphabetvalue == Null) ||  alphabetvalue == 'Other')
        {
            if(alphabetvalue == 'Other')
            {
                firmFilter = (firmFilter==null) ? '':(firmFilter + ' And ') + filterExpression + ' != null AND (NOT (' + filterExpression +' like \'a%\' or '+filterExpression+' like \'b%\' or '+ filterExpression+' like \'c%\' or '+ filterExpression+' like \'d%\' or '+ filterExpression+' like \'e%\' or '+ filterExpression+' like \'f%\' or '+ filterExpression+' like \'g%\' or '+ filterExpression+' like \'h%\' or '+ filterExpression+' like \'i%\' or '+ filterExpression+' like \'j%\' or '+ filterExpression+' like \'k%\' or '+ filterExpression+' like \'l%\' or '+ filterExpression+' like \'m%\' or '+ filterExpression+' like \'n%\' or '+ filterExpression+' like \'o%\' or '+ filterExpression+' like \'p%\' or '+ filterExpression+' like \'q%\' or '+ filterExpression+' like \'r%\' or '+ filterExpression+' like \'s%\' or '+ filterExpression+' like \'t%\' or '+ filterExpression+' like \'u%\' or '+ filterExpression+' like \'v%\' or '+ filterExpression+' like \'w%\' or '+ filterExpression+' like \'x%\' or '+ filterExpression+' like \'y%\' or '+ filterExpression+' like \'z%\')) ';
            }
        }
        else
        {
            //firmFilter = (firmFilter==null) ? '':(firmFilter + ' And ') + filterExpression + ' != null AND ' + alphabetvalue + '%';
            firmFilter = (firmFilter==null) ? '':(firmFilter + ' And ') + filterExpression + ' != null AND ' + filterExpression + ' like \''+ alphabetvalue + '%\'';
        }

        recordLimit = 10000;
        //firmList=firmQuery(firmFilter,firmOrderBy,recordLimit);
        System.debug('\n Firm List'+firmList);
        //standardSetCon = new ApexPages.StandardSetController(firmList);
        standardSetCon = new ApexPages.StandardSetController(Database.getQuerylocator(firmQueryvalue(firmFilter, firmOrderBy, recordLimit)));
        standardSetCon .setPageSize(200);

        return null;
    }

    public String firmQueryvalue(String whereClause,String orderByClause,Integer rowLimit)
    {
        transient String firmSelect;

        firmSelect = 'Select MarsYtdPurch__c,MarsYtdRed__c,MarsCAssets__c, SfdcFirmId__r.Id, SfdcFirmId__r.Name, SfdcFirmId__r.MarsFirmNm__c, SfdcFirmId__r.BillingCity, SfdcFirmId__r.BillingState, SfdcFirmId__r.MarsFirmType__c';
        firmSelect = firmSelect + ' From MARSFirmSummary__c';
        firmSelect = firmSelect + ((whereClause==null)? '':(' Where ' + whereClause));
        firmSelect = firmSelect + ((orderByClause==null)? '':(' Order By ' + orderByClause));
        firmSelect = firmSelect + ((rowLimit>0)? (' Limit ' + rowLimit):'');

         //List<MARSFirmSummary__c> lstFirm = Database.query(firmSelect);
        return firmSelect;
    }
}