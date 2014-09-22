/**
 * ExLog is a utility for logging exceptions in a robust manner.
 *
 * @author      Bluewolf
 */

public class ExLog {

/*
	///////////////////////////////////////////////////////
	//////			Constants
	///////////////////////////////////////////////////////
	public static final Boolean UNPACK_EXCEPTIONS = true;
	public static final Boolean DONT_UNPACK_EXCEPTIONS = !UNPACK_EXCEPTIONS;

	private static final String TRACE_PREFACE = 'EXCEPTION!!! - ';
	private static final String SINGLE_LINE_DELIM = '\n';
	private static final String DESC_LINE_DELIM = SINGLE_LINE_DELIM + SINGLE_LINE_DELIM;
	
	private static final Boolean WILL_INSERT = true;
	private static final Boolean WONT_INSERT = !WILL_INSERT;
	
	private static ExLogConfig exLogConfig = new ExLogConfig();
	private static Map<String, Id> apexClassName2Id = new Map<String, Id>();
	private static List<Logged_Exception__c> logsToFlush = new List<Logged_Exception__c>();
	private static Logged_Exception__c PARENTLESS_LOG_KEY = new Logged_Exception__c();
	
	public Enum Level { HIGH, MEDIUM, LOW }

	private static Level currentMode = Level.LOW;

	private ExLog() { }
	
	public static void log( System.Exception exceptionToLog, ExLogConfig exLogConfigParam ) {
		
		exLogConfig = exLogConfigParam;
		
		log( exceptionToLog );
	}

	public static void log( System.Exception exceptionToLog ) {
		
		List<Logged_Exception__c> exLogsToSave = loggedExceptionFactory( new List<System.Exception>{ exceptionToLog }, UserInfo.getUserId() );
		
		saveLogs( exLogsToSave );
		
	}
	
	private static List<Logged_Exception__c> loggedExceptionFactory( List<System.Exception> exceptionsToLog, Id whoCausedId ) {
		
		List<Logged_Exception__c> logs = new List<Logged_Exception__c>();
		
		for ( System.Exception anExToLog : exceptionsToLog ) {
			
			String className = ( exLogConfig.level == Level.HIGH ) ? extractClassName( anExToLog.getStackTraceString() ) : '';
			
			Logged_Exception__c exLog = new Logged_Exception__c( Who__c = whoCausedId,
																 Type__c = anExToLog.getTypeName(),
																 Line_Number__c = anExToLog.getLineNumber(),
																 Class_Name__c = className,
																 Session_Id__c = UserInfo.getSessionId(),
																 Organization_Id__c = UserInfo.getOrganizationId(),
																 Organization_Name__c = UserInfo.getOrganizationName(),
																 Exception_Description__c = createExDescription( anExToLog ) );
			
			if ( exLogConfig.level == Level.HIGH )
				exLog.Class_Id__c = resolveClassId( className );
			
			logs.add( exLog );
		
		}
		
		return logs;
		
	}
	
	private static String createExDescription( System.Exception anExToLog ) {
		
		String exDescription = anExToLog.getMessage() + DESC_LINE_DELIM + anExToLog.getStackTraceString();
		
		if ( anExToLog.getCause() != null )
			exDescription += '\n\n' + createExDescription( anExToLog.getCause() );
		
		return exDescription;
		
	}
	
	private static String extractClassName( String stackTrace ) {
		
		String className = '';
		
		List<String> stackPieces = stackTrace.split( ':' );

		if ( !stackPieces.isEmpty() )
			className = stackPieces[0];

		List<String> classNamePieces = className.split( '\\.' );
			className = classNamePieces[1];
			
		return classNamePieces[0] + '.' + classNamePieces[1];
		
	}
	
	private static Id resolveClassId( String className ) {
		
		if ( apexClassName2Id.containsKey( className ) )
			return apexClassName2Id.get( className );
		
		Id classId;
		
		List<String> namePieces = className.split('\\.');
		
		String codeType = namePieces[0];
		String name = namePieces[1];
		
		try {
			
			if ( codeType == 'Class' ) {
				
				classId = [ SELECT Id FROM ApexClass WHERE Name LIKE :name+'%' ].Id;
				
			} else if ( codeType == 'Trigger' ) {
				
				classId = [ SELECT Id FROM ApexTrigger WHERE Name LIKE :name+'%' ].Id;
			}
				
			apexClassName2Id.put( className, classId );
				
			return classId;
			
		} catch( System.Exception ex ) { }
		
		return null;
			
	}
	
	private static String createExDescription( System.Dmlexception aDmlExToLog ) {
		
		String dmlExceptionDescription = aDmlExToLog.getNumDml() + ' DML lines involved in this Exception: ' + SINGLE_LINE_DELIM;
		
		for ( Integer dmlErrIndex = 0; dmlErrIndex < aDmlExToLog.getNumDml(); dmlErrIndex++ )
			dmlExceptionDescription += createDmlExDescription( aDmlExToLog, dmlErrIndex ) + SINGLE_LINE_DELIM;
		
		return dmlExceptionDescription + DESC_LINE_DELIM + createExDescription( (System.Exception) aDmlExToLog );
		
	}
	
	private static String createDmlExDescription( System.Dmlexception aDmlExToLog, Integer dmlErrIndex ) {
		
		String dmlErrorDescription = aDmlExToLog.getDmlMessage( dmlErrIndex ) + SINGLE_LINE_DELIM;
		dmlErrorDescription += 'Status Code: ' + aDmlExToLog.getDmlStatusCode( dmlErrIndex );
		dmlErrorDescription += ', Type: ' + aDmlExToLog.getDmlType( dmlErrIndex ) + SINGLE_LINE_DELIM;
		dmlErrorDescription += 'on row with' + ( ( aDmlExToLog.getDmlId( dmlErrIndex ) == null ) ? 'out ID ' : ' ID of ' + aDmlExToLog.getDmlId( dmlErrIndex )  + ' ' ) + ', ';
		dmlErrorDescription += 'on fields ' + aDmlExToLog.getDmlFieldNames( dmlErrIndex );
		
		return dmlErrorDescription;
	}

	private static void saveLogs( List<Logged_Exception__c> logsToSave ) {
		
		if ( exLogConfig.flushable )
			logsToFlush.addAll( logsToSave );
		else
			insert logsToSave;
			
	}
	
	public static void flushLogCache() {
		
		if ( !logsToFlush.isEmpty() ) {
			
			insert logsToFlush;
			
			logsToFlush.clear();
			
		}
		
	}
	
	public class ExLogConfig {
												// Defaults
		public ExLog.Level level = 				ExLog.Level.LOW;
		public Boolean flushable =				false;
		public List<String> peopleToEmail = 	new List<String>();
		
		public ExLogConfig() { }
		
	}
	
	public class ExLogException extends System.Exception { }
*/

}