/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 12/23/2013
* @description Service Class for Queue.
* @name QueueService.cls
* @type Service Class
*/
public class QueueService {

	public static final Id unassignedQueueId;	
	static {
		unassignedQueueId =  [select Id,Name from Group where Name='Unassigned Queue' And Type = 'Queue'].Id;
	}

	public static final Id overnightQueueId;
	static {
		overnightQueueId = [select Id,Name from Group where Name = 'Overnight Lead Queue' and Type = 'Queue'].Id;
	}

	public static final Id exceptionQueueId;
	static {
		exceptionQueueId = [select Id,Name from Group where Name = 'Lead Exception Queue' and Type = 'Queue'].Id;
	}

	public static final Id recoveryQueueId;
	static{
		recoveryQueueId = [select Id,Name from Group where Name = 'Recovery Queue' and Type = 'Queue'].Id;
	}

	public static final Id webToLeadQueueId;
	static{
		webToLeadQueueId = [select Id,Name from Group where Name = 'Web to Lead' and Type = 'Queue'].Id;
	}

}