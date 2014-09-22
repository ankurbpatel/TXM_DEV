trigger UserTrigger on User (after update) {
    UserDeactivatedRecords.reassignLeads(trigger.new,trigger.oldMap);
}