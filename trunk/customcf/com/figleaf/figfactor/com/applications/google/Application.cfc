<cfcomponent output="false">


<cfset this.name = "figleafCommonSpotGoogleApplicationV2" />
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
	
	
	<cfinclude template="../../../index.cfm">
	
	<!--- set CONSTANTS --->
	<cfset application.THE_PATH = getDirectoryFromPath(GetCurrentTemplatePath()) />
	
	
	<cfreturn true />
</cffunction>

</cfcomponent>