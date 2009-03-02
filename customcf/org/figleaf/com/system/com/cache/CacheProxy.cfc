<!--- Document Information -----------------------------------------------------
Build:      	@@@revision-number@@@
Title:      	CacheProxy.cfc
Author:     John Allen
Email:      	jallen@figleaf.com
Company:   @@@company-name@@@
Website:    @@@web-site@@@
Purpose:    I am the Cache Proxy. I will create the correct caching object
				based on configuration data. Two options: the "hard" variables
				scoped cache (HarCache.cfc) or the cool jave softcache
				(softcache.cfc).

Usage:      getCache() - returns the configured caching object.

Modification Log:
Name	 Date	 Description
================================================================================
John Allen	 08/06/2008	 Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Cache Proxy" output="false"
	hint="I return a configured caching object.">


<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo-constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="defaultCache" default="#variables.defaultCache#"
		hint="I the type of cahce to default to.<br />I default to a hard coded variables var of 'sofcache'." />
	<cfargument name="cacheTimeSpan" default="#variables.cacheTimeSpan#"
		hint="I am the unit of time to kee values by, ie: s, m, d, y as a string.<br />I default to a hard coded variables var of seconds." />
	<cfargument name="cacheTimeValue" default="#variables.cacheTimeValue#"
		hint="I am the amount of minuts cached data should be kept around for.<br />I default to a hard coded variabes var of 1000." />
	<cfargument name="cacheReapTime" default="#variables.cacheReapTime#"
		hint="I am the amount of time befor I reap.<br />I default to a hard coded variabes var." />
	<cfargument name="dataNotFound" defalut="DATANOTFOUND"
		hint="I am the Configuration bean.<br />I defalut to 'DATANOTFOUND" />

	<cfset variables.HardCache = 0 />
	<cfset variables.SimpleTimedCache = 0 />
	<cfset variables.sofcache = 0 />
	<cfset variables.defaultCache = "simplecache" />
	<cfset variables.cacheTimeSpan = "s">
	<cfset variables.cacheTimeValue = 1000 />
	<cfset variables.cacheReapTime = 1000 />
	
	<!--- 
	The 'hard' cache usefull for testing. Keeping around to calculate
	what the sites cached foot print might be.
	--->
	<cftry>
		<cfset variables.HardCache = createObject("component", "hardcache.HardCache").init(
			dataNotFound = arguments.dataNotFound) />
		<cfcatch>
			<cfoutput>Opps! Error building the HardCache in CacheProxy</cfoutput>
			<cfdump var="#cfcatch#">
		</cfcatch>
	</cftry>

	<!---  
	Joe Rinehart's' neat little guy from ModelGlue Guesture. 
	That's some good cool code, that ModelGlue.
	--->
	<cftry>
		<cfset variables.simplecache = createObject("component", "simpletimedcache.SimpleTimedCache").init(
			dataNotFound = arguments.dataNotFound,
			cacheReapTime = arguments.cacheReapTime,
			cacheTimeValue = arguments.cacheTimeValue,
			cacheTimeSpan = arguments.cacheTimeSpan) />
		<cfcatch>
			<cfoutput>Opps! Error building the SimpleTimedCache in CacheProxy</cfoutput>
			<cfdump var="#cfcatch#">
			<cfabort />
		</cfcatch>
	</cftry>

	<!--- 
	Cool sexy softcache, a pretty neat way to 
	implement java's SoftRefrence goodness.
	--->
	<cftry>
		<cfset variables.softcache = createObject("component", "softcache.softcache").init(
			dataNotFound = arguments.dataNotFound) />
		<cfcatch>
			<cfoutput>Opps! Error building the softcach in CacheProxy</cfoutput>
			<cfdump var="#cfcatch#">
		</cfcatch>
	</cftry>

	<!--- set what the default cache should be --->
	<cfset variables.defaultCache = arguments.defaultCache />

	<cfreturn this />
</cffunction>



<!--- getCache --->
<cffunction name="getCache" access="public" output="false"
	hint="I return the Cache object."
	description="I return the Cache object that was created at initilization based on a configuration value.">
	
	<cfargument name="type" default="#variables.defaultCache#"
		hint="I the type of Cache to return. By default I return the softcache." />

	<cfset var cacheType = variables.defaultCache />
	
	<cfif structKeyExists(arguments.type, "type")>
		<cfset CacheType = arguments.type.type />
	</cfif>

	<cftry>
		<cfreturn variables[cacheType] />
		<cfcatch>
			<cfreturn variables["#variables.defaultCache#"] />
		</cfcatch>
	</cftry>
</cffunction>

<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>