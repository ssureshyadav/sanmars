/**
 *  Description     :   MarsActivityDatabaseUtiltiy class for database operations
 *
 *  Created By      :
 *
 *  Created Date    :   08/08/2016
 *
 *  Revision Logs   :   V_1.0 - Created
 *
 **/
public with sharing class MARSActivityDatabaseUtiltiy {
    
    //Get Event record by eventId
    public static Event getEventById(Id eventId) {

        //throw exception if Rep Id is null
        if(eventId == null)
            throw new MarsException('Event Id is null');

        //Fetch data from database   
       Event events = [SELECT AccountId,ActivityDate,ActivityDateTime,CreatedById,CreatedDate,Description,
                                   DurationInMinutes,EndDateTime,GroupEventType,Id,IsAllDayEvent,IsArchived,
                                   IsChild,IsDeleted,IsGroupEvent,IsPrivate,IsRecurrence,IsReminderSet,LastModifiedById,
                                   LastModifiedDate,Location,OwnerId,RecurrenceActivityId,RecurrenceDayOfMonth,RecurrenceDayOfWeekMask,
                                   RecurrenceEndDateOnly,RecurrenceInstance,RecurrenceInterval,RecurrenceMonthOfYear,
                                   RecurrenceStartDateTime,RecurrenceTimeZoneSidKey,RecurrenceType,ReminderDateTime,
                                   ShowAs,StartDateTime,Subject,SystemModstamp,WhatId,WhoId,MarsActivityId__c,MarsReccurenceId__c FROM Event
                                    WHERE ID = : eventId];
                                    

        if(events == null)
            throw new MarsException('Events not found');

        return events;

    } 
    
    public static Task getTaskById(Id taskId) {

        //throw exception if Rep Id is null
        if(taskId == null)
            throw new MarsException('Task Id is null');

        //Fetch data from database   
       Task tasks= [SELECT AccountId,ActivityDate,CallDisposition,CallDurationInSeconds,CallObject,CallType,CreatedById,
                               CreatedDate,Description,Id,IsArchived,IsClosed,IsDeleted,IsHighPriority,IsRecurrence,IsReminderSet,
                               LastModifiedById,LastModifiedDate,OwnerId,Priority,RecurrenceActivityId,RecurrenceDayOfMonth,
                               RecurrenceDayOfWeekMask,RecurrenceEndDateOnly,RecurrenceInstance,RecurrenceInterval,RecurrenceMonthOfYear,
                               RecurrenceRegeneratedType,RecurrenceStartDateOnly,RecurrenceTimeZoneSidKey,RecurrenceType,ReminderDateTime,
                               Status,Subject,SystemModstamp,TaskSubtype,WhatCount,WhatId,WhoCount,WhoId,MarsActivityId__c,MarsReccurenceId__c FROM Task
                                    WHERE ID = : taskId];
                                    

        if(tasks == null)
            throw new MarsException('Tasks not found');

        return tasks;

    }
}