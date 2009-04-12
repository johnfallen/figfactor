<cfinterface displayName="ICache">
<!--- delete --->
<cffunction name="delete" access="public" returntype="void" hint="Purges content from the cache.">
	<cfargument name="key" />
</cffunction>  
<!--- get --->
<cffunction name="get" output="false" 
	description="Returns the value for the specified key, or the string specified by configureation if unavailable.">
	<cfargument name="key" />
	<cfargument name="KeyExistsCheck" default="0" />
</cffunction> 
<!--- getHitRatio --->
<cffunction name="getHitRatio" output="false" description="Returns the hit ratio for the cache.">
</cffunction> 
<!--- getSize --->
<cffunction name="getSize" output="false" description="Returns the size of the cache.">
</cffunction>
<!--- put --->
<cffunction name="put" hint="Puts content into the cache.">
	<cfargument name="key" hint="Key for the content." />
	<cfargument name="Value" hint="The content to cache." />
</cffunction>
<!--- reap --->
<cffunction name="reap" output="false" hint="Instructs implementation to reap stale items.">
</cffunction> 
<!--- viewCache --->
<cffunction name="viewCache" output="false" access="public" 
	displayname="View Cache" hint="Returns cache information." 
	description="Returns all of the information in the cache. Size, Hit/Miss Ratio and even the cach data itself.">
</cffunction> 
</cfinterface>