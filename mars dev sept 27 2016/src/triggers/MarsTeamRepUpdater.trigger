trigger MarsTeamRepUpdater on MarsRepTeam__c (before insert,before update,after insert,after update,before delete) 
{    
    MARSDefaults__c marsDefaults = MarsUtility.MARS_DEFAULTS;
    
    if(MarsUtility.BYPASS_ALL_TRIGGER || (marsDefaults.IntegrationType__c == 0))
        return;        
        
    if(!(Trigger.isDelete))
    {
        for(MarsRepTeam__c repteams: Trigger.new)
        {
            if(Trigger.isInsert)
            {
                if(repteams.RecordTypeId == MarsUtility.RepTeamRecordType)
                {
                    repteams.addError('MARS Team Reps Cannot be Created from SFDC.');
                }
            }
            else
            {
                MarsRepTeam__c oldRepteam = Trigger.oldMap.get(repteams.Id);
                if(repteams.RecordTypeId == MarsUtility.RepTeamRecordType||oldRepteam.RecordTypeId == MarsUtility.RepTeamRecordType)
                {
                    repteams.addError('MARS Team Reps Cannot be Updated from SFDC.');
                }
            }
            return;
        }
    }
    else if(Trigger.isDelete)
    {
        for(MarsRepTeam__c repteams: Trigger.old)
        {
            if(repteams.RecordTypeId == MarsUtility.RepTeamRecordType)
            {
                repteams.addError('MARS Team Reps Cannot be Deleted from SFDC.');
            }            
            return;
        }    
    }
}