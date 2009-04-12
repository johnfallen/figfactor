<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			LoggerAdapter.cfc
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am the Logger Adapter. I handle everything to do 
						with Logging.
Usage:      			setMessage(message:string:required)
Modification Log:
Name	 Date	 Description
================================================================================
John Allen	 08/06/2008	 Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Logger Adapter" output="false" 
	hint="I am the Logger Adapter. I handle everything to do with Logging.">

<cfset variables.maskedLogger = 0 />
<cfset variables.logger = 0 />

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="LoggerAdapter" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="Config" />
	
	<cfset var CFLog4jConfig = createobject( 'component', 'cflog4j.CFLog4jConfig' ).init()>
	
	<cfset variables.config = arguments.config />
	<cfset variables.maskedLogger = createobject( 'component', 'cflog4j.CFLog4j' ).init( CFLog4jConfig ) />
	<cfset variables.logger = variables.maskedLogger.getCategoryInstance() />
	
	<cfreturn this />
</cffunction>



<!--- getMaskedLoggingMechanism --->
<cffunction name="getMaskedLoggingMechanism" returntype="any" access="public" output="false" 
	displayname="Get Masked Loggin Mechanism" hint="I return the logging mechanism that I am a Facade for." 
	description="I return the logging mechanism that I am a Facade for.">

	<cfreturn variables.maskedLogger />
</cffunction>



<!--- setMessage --->
<cffunction name="setMessage" access="public" output="false" 
	displayname="Log Message" hint="I log a message." 
	description="I log a message based on what type is passed to me.">

	<cfargument name="type" type="string" required="false" default="Info" hint="I am the type of the message to be logged. I default to 'Info'." />
	<cfargument name="message" type="string" required="true" hint="I am the message to be logged.<br />I am required." />


	<cfif variables.Config.getEnableExternalLogger() eq false>
		<cflog file="FigFactor" text="#arguments.message#" />
	<cfelse>
		<cfswitch expression="#arguments.type#">
			<cfcase value="Info">
				<cfset variables.maskedLogger.info(logger = variables.logger, message = arguments.message) />
			</cfcase>
			<cfcase value="Debug">
				<cfset variables.maskedLogger.debug(logger = variables.logger, message = arguments.message) />
			</cfcase>
			<cfcase value="Warn">
				<cfset variables.maskedLogger.Warn(logger = variables.logger, message = arguments.message) />
			</cfcase>
			<cfcase value="Error">
				<cfset variables.maskedLogger.Error(logger = variables.logger, message = arguments.message) />
			</cfcase>
			<!--- 
			Defensive. Incase they pass something weird: log something bad happened, 
			and also log the incomming message to the info log.
			--->
			<cfdefaultcase>
				<cfset variables.maskedLogger.Error(
					logger = variables.logger, 
					message = "Oops! A unreconigized value was passed to the LoggerAdapter.cfc!") />
				<cfset variables.maskedLogger.info(logger = variables.logger, message = arguments.message) />		
			</cfdefaultcase>
		</cfswitch>
	</cfif>

</cffunction>
<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>