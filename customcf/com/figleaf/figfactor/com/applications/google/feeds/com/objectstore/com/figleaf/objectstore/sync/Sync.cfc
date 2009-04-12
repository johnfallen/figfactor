<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			Sync.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I syncronize the storage file accrosse multipule servers by a configurable transport
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		18/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Sync" output="false"
	hint="I syncronize the storage file accrosse multipule servers by a configurable transport">

<cfset variables.THE_PATH = getDirectoryFromPath(GetCurrentTemplatePath()) />
<cfset variables.SERVERS_CONFIG_XML = "#variables.THE_PATH#servers.xml" />



<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Sync" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfset var xml = 0 />
	<cfset var xmlFilePath = variables.SERVERS_CONFIG_XML />

	<cfset variables.instance = structNew() />
	<cfset variables.instance.activeServers = structNew() />
	<cfset variables.instance.registeredServers = structNew() />
	
	<cffile action="read" file="#xmlFilePath#" variable="xml" />

	<cfset variables.transport = createObject("component", "transport.MockTransport").init() />
	

	<cfreturn this />
</cffunction>



<!--- ping --->
<cffunction name="ping" returntype="void" access="public" output="false"
    displayname="Ping" hint="I ping remote servers."
    description="I ping and keep track of remote servers.">
    
    <cfreturn  />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
	<cfreturn variables.instance />
</cffunction>

<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>s