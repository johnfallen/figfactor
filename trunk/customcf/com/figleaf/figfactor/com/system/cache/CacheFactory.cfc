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
<cfcomponent displayname="Cache Factory" output="false"
	hint="I return a configured caching object.">

<!--- **************************** Scopes **************************** --->
<cfset variables.instance = structNew() />
<cfset variables.instance.cacheProperties =  structNew() />
<cfset variables.instance.constants = structNew() />
<cfset variables.instance.caches = structNew() />



<!--- **************************** Constants **************************** --->
<cfset variables.instance.constants.DATA_NOT_FOUND = "DATA_NOT_FOUND" />



<!--- **************************** Public **************************** --->

<!--- init --->
<cffunction name="init" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo-constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="Config" hint="I am the Config object. I am required." />

	<cfset setDefaultCache(arguments.Config.getDefaultCache()) />
	<cfset setCacheTimeSpan(arguments.Config.getCacheTimeSpan()) />
	<cfset setCacheReapTime(arguments.Config.getCacheReapTime()) />
	<cfset setCacheTimeValue(arguments.Config.getCacheTimeValue()) />

	<cfset variables.instance.caches.HardCache = 0 />
	<cfset variables.instance.caches.SimpleTimedCache = 0 />
	<cfset variables.instance.caches.sofcache = 0 />
	
	<!--- 
	The 'hard' cache usefull for testing. Keeping around to calculate
	what the sites cached foot print might be.
	--->
	<cftry>
		<cfset variables.instance.caches.HardCache = createObject("component", "HardCache").init(
			dataNotFound = getNotFoundKey()) />
		<cfcatch>
			<cfoutput>Opps! Error building the HardCache in CacheProxy.</cfoutput>
			<cfdump var="#cfcatch#">
			<cfabort />
		</cfcatch>
	</cftry>

	<!---  
	Joe Rinehart's' neat little guy from ModelGlue Guesture. 
	That's some good cool code, that ModelGlue.
	--->
	<cftry>
		<cfset variables.instance.caches.simplecache = createObject("component", "SimpleTimedCache").init(
			dataNotFound = getNotFoundKey(),
			cacheReapTime = getCacheReapTime(),
			cacheTimeValue = getCacheTimeValue(),
			cacheTimeSpan = getCacheTimeSpan()) />
		<cfcatch>
			<cfoutput>Opps! Error building the SimpleTimedCache in CacheProxy</cfoutput>
			<cfdump var="#cfcatch#" />
			<cfabort />
		</cfcatch>
	</cftry>

	<!--- 
	Cool sexy softcache, a pretty neat way to 
	implement java's SoftRefrence goodness.
	--->
	<cftry>
		<cfset variables.instance.caches.softcache = createObject("component", "softcache").init(
			dataNotFound = getNotFoundKey()) />
		<cfcatch>
			<cfoutput>Opps! Error building the SoftCache in CacheProxy.</cfoutput>
			<cfdump var="#cfcatch#" />
			<cfabort />
		</cfcatch>
	</cftry>

	<cfreturn this />
</cffunction>



<!--- getCacheProperties --->
<cffunction name="getCacheProperties" returntype="struct" access="public" output="false"	
	displayname="Get Cache Properties" hint="I return the properties that all cache objects use."
	description="I return the properties that all cache objects use.">
    
	<cfreturn variables.instance.cacheProperties />
</cffunction>



<!--- getNotFoundKey --->
<cffunction name="getNotFoundKey" returntype="any" access="public" output="false"	
	displayname="Get Not Found Key" hint="I return the key that is used to signify a value is not in the cache."
	description="I return the key that is used to signify a value is not in the cache.">
    
	<cfreturn variables.instance.constants.DATA_NOT_FOUND />
</cffunction>



<!--- getCache --->
<cffunction name="getCache" access="public" output="false"
	hint="I return the Cache object."
	description="I return a Cache object. If not passed the type, I will return the default configured cache.">
	
	<cfargument name="type" default="#getDefaultCache()#"
		hint="I the type of Cache to return. If not passed I will return the default cache" />

	<cfreturn variables.instance.caches[arguments.type] />
</cffunction>



<!--- getCacheReapTime --->
<cffunction name="getCacheReapTime" access="public" output="false" returntype="string"
	displayname="Get CacheReapTime" hint="I return the CacheReapTime property." 
	description="I return the CacheReapTime property of my internal instance structure.">
	<cfreturn variables.instance.cacheProperties.CacheReapTime />
</cffunction>
<!--- setCacheReapTime --->
<cffunction name="setCacheReapTime" access="public" output="false" returntype="void"
	displayname="Set CacheReapTime" hint="I set the CacheReapTime property." 
	description="I set the CacheReapTime property to my internal instance structure.">
	<cfargument name="CacheReapTime" type="string" required="true"
		hint="I am the CacheReapTime property. I am required."/>
	<cfset variables.instance.cacheProperties.CacheReapTime = arguments.CacheReapTime />
</cffunction>
<!--- getCacheTimeSpan --->
<cffunction name="getCacheTimeSpan" access="public" output="false" returntype="string"
	displayname="Get CacheTimeSpan" hint="I return the CacheTimeSpan property." 
	description="I return the CacheTimeSpan property of my internal instance structure.">
	<cfreturn variables.instance.cacheProperties.CacheTimeSpan />
</cffunction>
<!--- setCacheTimeSpan --->
<cffunction name="setCacheTimeSpan" access="public" output="false" returntype="void"
	displayname="Set CacheTimeSpan" hint="I set the CacheTimeSpan property." 
	description="I set the CacheTimeSpan property to my internal instance structure.">
	<cfargument name="CacheTimeSpan" type="string" required="true"
		hint="I am the CacheTimeSpan property. I am required."/>
	<cfset variables.instance.cacheProperties.CacheTimeSpan = arguments.CacheTimeSpan />
</cffunction>
<!--- getCacheTimeValue --->
<cffunction name="getCacheTimeValue" access="public" output="false" returntype="string"
	displayname="Get CacheTimeValue" hint="I return the CacheTimeValue property." 
	description="I return the CacheTimeValue property of my internal instance structure.">
	<cfreturn variables.instance.cacheProperties.CacheTimeValue />
</cffunction>
<!--- setCacheTimeValue --->
<cffunction name="setCacheTimeValue" access="public" output="false" returntype="void"
	displayname="Set CacheTimeValue" hint="I set the CacheTimeValue property." 
	description="I set the CacheTimeValue property to my internal instance structure.">
	<cfargument name="CacheTimeValue" type="string" required="true"
		hint="I am the CacheTimeValue property. I am required."/>
	<cfset variables.instance.cacheProperties.CacheTimeValue = arguments.CacheTimeValue />
</cffunction>
<!--- getDefaultCache --->
<cffunction name="getDefaultCache" access="public" output="false" returntype="any"
	displayname="Get DefaultCache" hint="I return the DefaultCache property." 
	description="I return the DefaultCache property of my internal instance structure.">
	<cfreturn variables.instance.cacheProperties.DefaultCache />
</cffunction>
<!--- setDefaultCache --->
<cffunction name="setDefaultCache" access="public" output="false" returntype="void"
	displayname="Set DefaultCache" hint="I set the DefaultCache property." 
	description="I set the DefaultCache property to my internal instance structure.">
	<cfargument name="DefaultCache" type="any" required="true"
		hint="I am the DefaultCache property. I am required."/>
	<cfset variables.instance.cacheProperties.DefaultCache = arguments.DefaultCache />
</cffunction>
<!--- **************************** Package **************************** --->
<!--- **************************** Private **************************** --->
</cfcomponent>