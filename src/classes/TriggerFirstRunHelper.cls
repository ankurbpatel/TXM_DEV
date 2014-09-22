public class TriggerFirstRunHelper {
    public static boolean firstRun = true;
    
    public static boolean firstRunAfter = true;

    public static boolean firstRunTimeZone = true;

    public static boolean firstRunAssignmentInsert = true;

    public static boolean firstRunAssignmentUpdate = true;

    public static boolean firstRunDeDupe = true;

    public static boolean firstRunDeDupeInsert = true;

    public static boolean firstRunConvertLeads = true;

    public static boolean firstRunTaskDueDateStamping = true;

    public static boolean firstRunParentStatusUpdate = true;

    public static boolean firstRunTaskContactAttemptsStamping = true;

    public static boolean firstRunCompletedTaskDeleteAndUpdate = true;

    public static boolean firstRunTaskUpdateFromParent = false;
    
    public static void resetAllValues(){
        TriggerFirstRunHelper.firstRun = true;
    
        TriggerFirstRunHelper.firstRunAfter = true;

        TriggerFirstRunHelper.firstRunTimeZone = true;

        TriggerFirstRunHelper.firstRunAssignmentInsert = true;

        TriggerFirstRunHelper.firstRunAssignmentUpdate = true;

        TriggerFirstRunHelper.firstRunDeDupe = true;

        TriggerFirstRunHelper.firstRunDeDupeInsert = true;

        TriggerFirstRunHelper.firstRunConvertLeads = true;

        TriggerFirstRunHelper.firstRunTaskDueDateStamping = true;

        TriggerFirstRunHelper.firstRunParentStatusUpdate = true;

        TriggerFirstRunHelper.firstRunTaskContactAttemptsStamping = true;

        TriggerFirstRunHelper.firstRunCompletedTaskDeleteAndUpdate = true;

        TriggerFirstRunHelper.firstRunTaskUpdateFromParent = true;
    }

}