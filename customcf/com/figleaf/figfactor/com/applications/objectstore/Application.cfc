<cfcomponent output="false">

<cfset this.name = "objectsStoreSecurity" />
<cfset this.applicationTimeout = createTimeSpan(10,0,0,0) />
<cfset this.clientManagement = false />
<cfset this.clientStorage = "registry" />
<cfset this.loginStorage = "session" />
<cfset this.sessionManagement = true />
<cfset this.sessionTimeout = createTimeSpan(0,0,20,0) />
<cfset this.setClientCookies = true />
<cfset this.setDomainCookies = false />




<!--- onApplicationStart --->
<cffunction name="onApplicationStart" returnType="boolean" output="false" 
	hint="Run when application starts up.">
	
	<!--- set CONSTANTS --->
	<cfset application.THE_PATH = getDirectoryFromPath(GetCurrentTemplatePath()) />
	
	<cfreturn true />
</cffunction>



<!--- onRequestStart --->
<cffunction name="onRequestStart" returnType="boolean" output="false" 
	hint="Run before the request is processed.">
	
	<cfargument name="thePage" type="string" required="true" />
	
	<cfif not structKeyExists(session, "GFUserIsLoggedIn")>
		<cfset session.GFUserIsLoggedIn = false />
	</cfif>
	
	<cfreturn true />
</cffunction>


</cfcomponent>