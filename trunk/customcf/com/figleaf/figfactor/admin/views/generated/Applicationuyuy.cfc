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

<cfset this.name = "#hash(getCurrentTemplatePath())#" />
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


<!--- onRequestStart --->
<cffunction name="onRequestStart" returnType="boolean" output="false" hint="Run before the request is processed.">
	<cfargument name="thePage" type="string" required="true" />
	
	<cfif not structKeyExists(session, "AllowExternalApplicationManagement")>	
		<cfset session.AllowExternalApplicationManagement = false />
	</cfif>
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
</cfcomponent>