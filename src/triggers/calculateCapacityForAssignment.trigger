trigger calculateCapacityForAssignment on Lead_Assignment_Setting__c (after update) {
        calculateCapacityController.calculateForAssignment(trigger.new,trigger.oldMap); 
}