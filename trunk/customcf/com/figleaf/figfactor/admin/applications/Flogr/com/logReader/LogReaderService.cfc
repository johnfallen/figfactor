<cfcomponent displayname="Log Reader Controller" hint="I am the controller for the log reader" output="false">
	<cfscript>
		variables._logDir = "";
		variables._logReader = "";
		variables._factory = "";
		variables._logService = "";
		variables._chartService= "";
		init();
	</cfscript>
	
	<cffunction name="init" access="public" output="false" returntype="void">
		<cfscript>
			setFactory();
			setLogService(getFactory().getLoggingService()); 
			setLogDir(getLogService().getLogDirectory());
			setLogReader(getLogDir());
			setChartService('flogr');
		</cfscript>
	</cffunction>
	
	<cffunction name="setfactory" access="private" returntype="void" output="false">
		<cfset variables._factory =  createObject("java","coldfusion.server.ServiceFactory") />
	</cffunction>
	
	<cffunction name="getfactory" access="private" returntype="any" output="false">
		<cfreturn variables._factory />
	</cffunction>
	
	<cffunction name="setLogService" access="private" returntype="void" output="false">
		<cfargument name="logService" type="any" required="true">
		<cfset variables._logService = arguments.logService >
	</cffunction>
	
	<cffunction name="getLogService" access="private" returntype="any" output="false">
		<cfreturn variables._logService />
	</cffunction>
	
	<cffunction name="setLogDir" access="private" returntype="void" output="false">
		<cfargument name="logDir" type="string" required="true">
		<cfset variables._logDir = arguments.logDir >
	</cffunction>
	
	<cffunction name="getLogDir" access="public" returntype="string" output="false">
		<cfreturn variables._logDir />
	</cffunction>
	
	<cffunction name="setLogReader" access="private" returntype="void" output="false">
		<cfargument name="logDir" type="string" required="true">
		<cfset variables._logReader = createObject("component","LogReader").init(logDir) />
	</cffunction>
	
	<cffunction name="getLogReader" access="private" returntype="any" output="false">
		<cfreturn variables._logReader />
	</cffunction>
	
	<cffunction name="setChartService" access="private" returntype="void" output="false">
		<cfargument name="dsn" type="string" required="true">
		<cfset variables._chartService = createObject("component","chartService").init(arguments.dsn) />
	</cffunction>
	
	<cffunction name="getChartService" access="private" returntype="any" output="false">
		<cfreturn variables._chartService />
	</cffunction>
	
	<cffunction name="getLogs" access="remote" returntype="array" output="false">
		<cfreturn getLogReader().getLogs() />
	</cffunction>
	
	<cffunction name="getlogData" access="remote" returntype="array" output="false">
		<cfargument name="logName" type="string" required="true" />
		
		<cfreturn getLogReader().getLogData(arguments.logName) />
	</cffunction>
	
	<cffunction name="archiveLogFile" output="false" access="remote" returntype="boolean" hint="">
	   <cfargument name="logName" type="string" required="true" />
	   
	   <cftry>
			<cfset getLogService().rollLog(getLogDir()&"/"&arguments.logName) />
			<cfreturn true />
			<cfcatch type="any">
				<cfreturn false />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="deleteLogFile" output="false" access="remote" returntype="boolean" hint="">
	   <cfargument name="logName" type="string" required="true" />
	   
	   <cftry>
			<cfset getLogService().deleteLog(getLogDir()&"/"&arguments.logName) />
			<cfreturn true />
			<cfcatch type="any">
				<cfreturn false />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="getAllCharts" access="remote" output="false" returntype="array">
		<cfargument name="logFile" required="false" type="numeric" default="0" />
		<cfreturn getChartService().getAllCharts(logFile=arguments.logFile) />	
	</cffunction>
</cfcomponent>