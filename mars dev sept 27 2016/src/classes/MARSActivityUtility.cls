public class MARSActivityUtility {

    public static Boolean BYPASS_ALL_TRIGGER = false;
    public static Map<Decimal,String> mapSFDCActivityId=new Map<Decimal,String>();

    public static Set<String> setRecurrenceId=new Set<String>();
     
    public static MARSDefaults__c MARS_DEFAULTS
    {
        get {
    
            //Get MARS Defaults values
            MARSDefaults__c marsDefaults = MARSDefaults__c.getOrgDefaults();
            
            //Check if MARS Defaults is already there or not
            if(marsDefaults == null) {
                marsDefaults = new MARSDefaults__c();
            }
            
            //Return MARS Defaults
            return marsDefaults;
            }
    }
    
  /*  public static void updateRecurrence()
    {
        List<Event> lstupdReccurEvent=new List<Event>();
        for(Event evt:[Select Id,MarsReccurenceId__c from Event Where MarsReccurenceId__c IN : MARSActivityUtility.mapSFDCActivityId.keySet() and IsRecurrence =true])
        {
            Event evnt=new Event(Id=evt.Id);
            String entityId=MARSActivityUtility.mapSFDCActivityId.get(evt.MarsReccurenceId__c);
            if(entityId.startsWith('003'))
            {
                evnt.WhoId =entityId;
            }else{
                evnt.WhatId =entityId;
            }
            lstupdReccurEvent.add(evnt);
        }
        update lstupdReccurEvent;
    }*/
     
     public static apiPhxaComMarsisActivitiesservice.ActivitiesServiceSoap populatedAuthServiceForActivities() {
        
        //Variable to hold the MARS Defaults paramters configuration setting
        MARSDefaults__c marsDefaults = MarsActivityUtility.MARS_DEFAULTS;

        //Instantiating ActivitiesService object
        apiPhxaComMarsisActivitiesservice.ActivitiesServiceSoap service = new apiPhxaComMarsisActivitiesservice.ActivitiesServiceSoap();

        //Create Authrization header
        apiPhxaComMarsisActivitiesservice.AuthHeader authHeader = new apiPhxaComMarsisActivitiesservice.AuthHeader();

        //Populating Authrization Header with valid Credentials with the help of custom setting. By doing this it will remove's our dependencies over
        //environments.
        authHeader.Username = marsDefaults.MARSUser__c;
        authHeader.Password = marsDefaults.MARSPassword__c;
        
        //Setting authorization for ActivitiesServiceSoap Object
        service.AuthHeader = authHeader;

        //Setting service timeout time
        service.timeout_x = 60000;
        
        //Return Populated service
        return service;
    }
    
    public static Sobject updateObjByMARSResponse(Sobject lstobj, String marsResponse, Boolean isInsert, String Entity)
    {
        MARSDefaults__c defaults=MarsUtility.MARS_DEFAULTS;
        
        //Document class
        Dom.document doc = new Dom.document();

        //Load the response string into dom class
        doc.load(marsResponse);
        
        if(Entity == 'Call' || Entity == 'Email')
        {
                Task responseTask=new Task(Id=lstobj.Id);
                for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
                {                   
                    if(Entity == 'Call')
                    {    
                        
                        Dom.XMLNode activityId= elementsList.getChildElement('ACTIVITY_ID', 'http://tempuri.org/MarsCall.xsd');
                        if(activityId.getText().length() >0)
                        {
                            responseTask.MarsActivityId__c=Decimal.valueOf(activityId.getText());
                        }
                        
                        Dom.XMLNode recurrenceId= elementsList.getChildElement('RECURRING_ID', 'http://tempuri.org/MarsCall.xsd');
                        if(recurrenceId.getText().length() >0)
                        {
                            responseTask.MarsReccurenceId__c=Decimal.valueOf(recurrenceId.getText());
                        }
                        
                        Dom.XMLNode marsactivityType = elementsList.getChildElement('ACT_TYPE', 'http://tempuri.org/MarsCall.xsd');
                        responseTask.MARSActivitytype__c =marsactivityType.getText();
                        if(responseTask.MARSActivitytype__c != 'CL')
                        {
                           responseTask.MARSActivitytype__c ='TK'; 
                        }
                    }else if(Entity == 'Email')
                    {
                        Dom.XMLNode externalIdField =elementsList.getChildElement('EXTERNAL_ID' , 'http://tempuri.org/MarsEmail.xsd');
                        if(lstobj.Id == externalIdField.getText())
                        {
                            Dom.XMLNode activityId= elementsList.getChildElement('ACTIVITY_ID', 'http://tempuri.org/MarsEmail.xsd');
                            responseTask.MarsActivityId__c=Decimal.valueOf(activityId.getText());
                        }
                        
                        responseTask.MARSActivitytype__c ='EM';
                    }
                    responseTask.MARSChkUpdDesc__c =false;
                }
            return responseTask;
        } else if(Entity == 'Meeting' || Entity == 'FirmEvent')
        {
            
            Event responseEvent=new Event(Id=lstobj.Id);
            for(dom.XmlNode elementsList: doc.getRootElement().getChildElements())
            {                   
                if(Entity == 'Meeting')
                {
                    if(doc.getRootElement().getNamespace() == 'http://tempuri.org/MarsMeeting.xsd')
                    {
                        Dom.XMLNode activityId= elementsList.getChildElement('ACTIVITY_ID', doc.getRootElement().getNamespace());                
                        if(activityId.getText().length() >0)
                        {
                            responseEvent.MarsActivityId__c=Decimal.valueOf(activityId.getText());
                        }
                    }
                    
                    if(doc.getRootElement().getNamespace() == 'http://tempuri.org/MarsMeeting.xsd')
                    {
                        Dom.XMLNode recurrenceId= elementsList.getChildElement('RECURRING_ID', doc.getRootElement().getNamespace());
                        if(recurrenceId.getText().length() >0)
                        {
                            responseEvent.MarsReccurenceId__c=Decimal.valueOf(recurrenceId.getText());
                        }
                    }
                    responseEvent.MARSActivitytype__c='MT';
                    responseEvent.MARSChkUpdDesc__c =false;
                }
               /* if(Entity == 'FirmEvent')
                {
                    //Dom.XMLNode externalIdField =elementsList.getChildElement('EXTERNAL_ID' , doc.getRootElement().getNamespace());
                    //Dom.XMLNode externalRecurrenceId =elementsList.getChildElement('EXTERNAL_ID' , doc.getRootElement().getNamespace());
                    
                    Dom.XMLNode eventId= elementsList.getChildElement('EVENT_ID', doc.getRootElement().getNamespace());                
                    if(eventId.getText().length() >0)
                    {
                        responseEvent.MarsActivityId__c=Decimal.valueOf(eventId.getText());
                    }
                    
                    Dom.XMLNode recurrenceId= elementsList.getChildElement('RECURRING_ID', doc.getRootElement().getNamespace());
                    if(recurrenceId.getText().length() >0)
                    {
                        responseEvent.MarsReccurenceId__c=Decimal.valueOf(recurrenceId.getText());
                    }    
                    responseEvent.MARSActivitytype__c='EV';
                }*/
            }

            return responseEvent;
        }
        return null;
    }
    
}