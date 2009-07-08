=<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		SimpleTimedCache.cfc
Author:     		John Allen
Email:      		jallen@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@

Purpose:    	A simple timed cache. Inspired by Model Glue
Usage:      		

Modification Log:
Name 			Date 					Description

================================================================================
John Allen 		24/09/2008			Created
------------------------------------------------------------------------------->
<cfcomponent 
	displayname="Simple Timed Cache" 
	output="false" 
	implements="ICache"
	hint="I am a simple time-based content cache.  Reaps the cache based on the 'reapInterval' constructor argument, checking for reaps necessity on each write to the cache.">

<!--- *********** Public ************ --->

<cffunction name="init" access="public" hint="Constructor">
	<cfargument name="dataNotFound" type="any" hint="A system CONSTANT to return when data is not found."	/>
	<cfargument name="cacheTimeSpan" type="numeric"
		hint="Number of configured CachTimeValues an item should live in a cache unless explicitly stated.">
	<cfargument name="cacheReapTime" type="numeric" hint="Number of seconds to wait between cache sweeps." />
	<cfargument name="cacheTimeValue" type="any"  default="s" 
		hint="Number of seconds an item should live in a cache unless explicitly stated." />
	
	<cfset variables.content = structNew() />
	<cfset variables.cacheTimeSpan = arguments.cacheTimeSpan />
	<cfset variables.cacheTimeValue = arguments.cacheTimeValue />
	<cfset variables.reapInterval = arguments.cacheReapTime />
	<cfset variables.lastReap = now() />
	<cfset variables.lockName = createUUID() />
	<cfset variables.dataNotFound = arguments.DataNotFound />
	<cfset variables.hits = 0 />
	<cfset variables.misses = 0 />
	
	<cfreturn this />
</cffunction>



<!--- put --->
<cffunction name="put" hint="Puts content into the cache.">
	<cfargument name="key" hint="Key for the content." />
	<cfargument name="Value" hint="The content to cache." />
	
	<cfset arguments.timeout = variables.cacheTimeSpan />
	
	<cfset arguments.created = now() />
	<cfset variables.content[arguments.key] = arguments/>

</cffunction>



<!--- get --->
<cffunction name="get" output="false" 
	description="Returns the value for the specified key, or the string specified by configureation if unavailable.">
	
	<cfargument name="key" hint="Key for the content." />
	<cfargument name="KeyExistsCheck" default="0" hint="I am a flag. If I am not '0' I will track the hit."/>

	<cfif dateDiff("#variables.cacheTimeValue#", variables.lastReap, now()) gt variables.reapInterval>
		<cflock name="#variables.lockName#" type="exclusive" timeout="30">
			<cfif dateDiff("#variables.cacheTimeValue#", variables.lastReap, now()) gt variables.reapInterval>
				<cfset reap() />
			</cfif>
		</cflock>
	</cfif>

	<cftry>
		<cfif structKeyExists(variables.content, arguments.key)>
			
			<cfif arguments.KeyExistsCheck neq 0>
				<cfset variables.hits = variables.hits + 1 />
			</cfif>
			
			<cfreturn variables.content[arguments.key].value />
		<cfelse>
			<cfset variables.misses = variables.misses + 1 />
			<cfreturn variables.dataNotFound />
		</cfif>
		<cfcatch>
			<cfset variables.misses = variables.misses + 1 />
			<cfreturn variables.dataNotFound />
		</cfcatch>
	</cftry>
</cffunction>



<!--- reap --->
<cffunction name="reap" output="false" hint="Instructs implementation to reap stale items.">
	
	<cfset var key = "" />
	<cfset var item = "" />
	<cfset var sinceLastSweep = dateDiff("#variables.cacheTimeValue#", variables.lastReap, now()) />
	
	<cfloop collection="#variables.content#" item="key">
		<cfset item = variables.content[key] />
		
		<cfif sinceLastSweep gt item.timeout>
			<cfset delete(key) />
		</cfif>
	</cfloop>
	
	<cfset variables.lastReap = now() />
</cffunction>



<!--- delete --->
<cffunction name="delete" access="public" returntype="void" hint="Purges content from the cache.">
	<cfargument name="key" />
	
	<cfset structDelete(variables.content, key) />
</cffunction>



<!--- getHitRatio --->
<cffunction name="getHitRatio" output="false" description="Returns the hit ratio for the cache.">
	
	<cfset var requests = variables.hits + variables.misses />
	
	<cfif requests eq 0>
		<cfreturn 0 />
	<cfelse>
		<cfreturn (variables.hits/requests) />
	</cfif>
</cffunction>



<!--- getSize --->
<cffunction name="getSize" output="false" description="Returns the size of the cache.">
	
	<!--- Sweep first so we get dead keys out of the cache --->
	<cfset reap() />
	
	<cfreturn StructCount(variables.content) />
</cffunction>



<!--- viewCache --->
<cffunction name="viewCache" output="false" access="public" 
	displayname="View Cache" hint="Returns cache information." 
	description="Returns all of the information in the cache. Size, Hit/Miss Ratio and even the cach data itself.">
	
	<cfset var cacheInfo = structNew() />
	<cfset cacheInfo.size = getSize() />
	<cfset cacheInfo.HitRatio = getHitRatio() />
	<cfset cacheInfo.cache = variables.content />
	<cfset cacheInfo.hits = variables.hits />
	<cfset cacheInfo.misses = variables.misses />
	<cfset cacheInfo.cacheTimeValue = variables.cacheTimeValue />
	<cfset cacheInfo.cacheTimeSpan = variables.cacheTimeSpan />
	<cfset cacheInfo.reapInterval = variables.reapInterval />

	<cfreturn cacheInfo />
</cffunction>

<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>