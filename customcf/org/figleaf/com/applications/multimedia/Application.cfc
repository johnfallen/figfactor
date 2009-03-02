<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			Application.cfc
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am the Application component. I instanciate the ColdSpring framework
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		04/01/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Application" output="false"
	hint="I am the Application component. I instanciate the ColdSpring framework">

<cfset this.name = "FigFactorMultiMedia" />
<cfset this.applicationTimeout = createTimeSpan(0,2,0,0) />
<cfset this.clientManagement = false />
<cfset this.clientStorage = "registry" />
<cfset this.loginStorage = "session" />
<cfset this.sessionManagement = true />
<cfset this.sessionTimeout = createTimeSpan(0,0,20,0) />
<cfset this.setClientCookies = true />
<cfset this.setDomainCookies = false />
<cfset this.scriptProtect = false />
<cfset this.secureJSON = false />
<cfset this.secureJSONPrefix = "" />
<cfset this.welcomeFileList = "" />
<cfset this.mappings = "" />
<cfset this.customtagpaths = "" />



<!--- onApplicationStart --->
<cffunction name="onApplicationStart" returnType="boolean" output="false" hint="Run when application starts up.">
	
	<cfinclude template="../../../Application.cfm">
	<cfinclude template="../../../index.cfm">
	<!--- create a refrence to FigFactor's system factory --->
	<cfset application.FigFactorFactory = application.beanFactory.getBean />

	<!--- ALL THIS CODE IS NOW IN THE SYSTEMFACTORY --->
	<!--- 
	<!--- set the root directory of the application --->
	<cfset variables.thePath = GetDirectoryFromPath(GetCurrentTemplatePath()) />

	<cfset variables.coldSpringXMLPath = variables.thePath & "config/ColdSpring.xml" />
	<cfset application.FigFactorMultiMediaFactory = createObject("component", "coldspring.beans.DefaultXMLBeanFactory").init() />
	<cfset application.FigFactorMultiMediaFactory.loadBeansFromXMLFile('#variables.coldSpringXMLPath#', true) />

	<!--- install the UI Files --->
	<cfif structKeyExists(url, "install") and url.install eq "true">
		<cfset installUIFiles(
			FileSystem = application.FigFactorMultiMediaFactory.getBean("FileSystem"),
			Config = application.FigFactorMultiMediaFactory.getBean("Config")) />
	</cfif>

	<!--- put the coldspring bean factory into FigFactor system factory --->
	<cfset application.FigFactorFactory.setApplicationBean(key = "multimedia", value = application.FigFactorMultiMediaFactory) />
	 --->
	<cfreturn true />
</cffunction>



<!--- onRequestStart --->
<cffunction name="onRequestStart" returnType="boolean" output="false" hint="Run before the request is processed.">
	<cfargument name="thePage" type="string" required="true" />
	

	<cfset structClear(session) />
	<cfset onApplicationStart() />
<!--- 

	<cfif not structKeyExists(application, "FigFactorMultiMediaFactory") or structKeyExists(URL, "init")>	
		<cfset structClear(session) />
		<cfset onApplicationStart() />
	</cfif>
 --->
	<cfreturn true />
</cffunction>



<!--- onSessionStart --->
<cffunction name="onSessionStart"  output="false" hint="Run when a session starts.">
	<!--- Not sure anyone'll ever need this...
	<cfset invokeSessionEvent("modelglue.onSessionStartPreRequest", session, application) />
	--->
	<!--- Set flag letting MG know it needs to broadcast onSessionStart before onRequestStart --->
	<cfset request._modelglue.bootstrap.sessionStart = true />
</cffunction>



<!--- onSessionEnd --->
<cffunction name="onSessionEnd" output="false" hint="Rus when a session ends.">
	<cfargument name="sessionScope" type="struct" required="true">
	<cfargument name="appScope" 	type="struct" required="false">

	<cfset invokeSessionEvent("modelglue.onSessionEnd", arguments.sessionScope, appScope) />
</cffunction>



<!--- invokeSessionEvent --->
<cffunction name="invokeSessionEvent" output="false" access="private" hint="ModelGlue session used for event state management.">
	<cfargument name="eventName" />
	<cfargument name="sessionScope" />
	<cfargument name="appScope" />

	<cfset var mgInstances = createObject("component", "ModelGlue.Util.ModelGlueFrameworkLocator").findInScope(appScope) />
	<cfset var values = structNew() />
	<cfset var i = "" />

	<cfset values.sessionScope = arguments.sessionScope />

	<cfloop from="1" to="#arrayLen(mgInstances)#" index="i">
		<cfset mgInstances[i].executeEvent(arguments.eventName, values) />
	</cfloop>
</cffunction>



<!--- installUIFiles --->
<cffunction name="installUIFiles" returntype="void" access="private" output="false"
	displayname="Install UI Files" hint="I install the correct files into the root of web site.."
	description="I install the correct files into the root of web site..">
	
	<cfargument name="FileSystem" type="component" required="true" 
		hint="I am the FileSystem helper utility object.<br />I am required." />
	<cfargument name="Config" type="component" required="true" 
		hint="I am the Config Bean object.<br />I am required." />
	
	<cfset var webRoot = ExpandPath( "/") />
	<cfset var customTagName = "custom_tag_mediaoutput.cfm" />
	<cfset var customTagSource = arguments.config.getThePath() & "views/pages/" & customTagName />
	<cfset var customTagDestination = webRoot  & customTagName />
	<cfset var jsSource = arguments.config.getJavaScriptDirectory() />
	<cfset var jsDestination = webRoot & arguments.config.getDefaultUIPath() />

	<!--- 
	Copy the custom tag and the JavaScript code to the web root.

	If for some reason this is impossiable, just copy the tag to the adjacent 
	display page or install it into ColdFusions custom tags directory.
	--->
	<cffile action="copy" source="#customTagSource#" destination="#customTagDestination#" />

	<cfset arguments.FileSystem.directoryCopy(
		source = jsSource,
		destination = jsDestination) />

</cffunction>
</cfcomponent>