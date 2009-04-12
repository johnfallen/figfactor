<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		HardCache.cfc
Author:     		John Allen
Email:      		jallen@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@
Purpose:    	I am a local variables cache. Basically
					a 'MapCollection'.
Usage:      
Modification Log:

Name	 		Date	 			Description
================================================================================
John Allen	 08/16/2008	 Created
------------------------------------------------------------------------------->
<cfcomponent displayname="HardCache" output="false"
	hint="I am the HardCache. I manage the cache via XML files and internal memory.">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="dataNotFound" required="false" default="no" 
		hint="I am the value to return if data is not found.<br />I defalut to 'no'." />
	
	<!--- 
	The internal cache 
	--->
	<cfset variables._LocalCache = structNew() />
	
	<!--- 
	A constant to indicate a key is not found. 
	--->
	<cfset variables.notFound = arguments.dataNotFound />
	
	<!---
	Stats for calculating the hit ratio.
	--->
	<cfset variables.hits = 0 />
	<cfset variables.misses = 0 />

	<cfreturn this />
</cffunction>



<!--- get --->
<cffunction name="get" access="public" output="false" 
	displayname="Get" hint="I get data from the cache." 
	description="I get data from the cache by a specific key.">

	<cfargument name="key"
		hint="I am the key of value to get from the cache.<br />I am required." />
	<cfargument name="KeyExistsCheck" default="0"
		hint="I am a flag. If NOT 0 I will log a hit or miss if the key was found." />

	<cfif StructKeyExists(variables._LocalCache, arguments.key)>
		
		<cfif arguments.KeyExistsCheck neq 0>			
			<cfset variables.hits = variables.hits + 1 />
		</cfif>
		
		<cfreturn variables._LocalCache[arguments.key].value />
	<cfelse>
		
		<cfset variables.misses = variables.misses + 1 />	
		<cfreturn variables.notFound />
	</cfif>
</cffunction>



<!--- getHitRatio --->
<cffunction name="getHitRatio" output="false" 
	displayname="Get Hit Ratio" hint="Returns the hit ratio for the cache."
	description="Returns the hit ratio for the cache.">
	
	<cfset var requests = variables.hits + variables.misses />
	
	<cfif requests eq 0>
		<cfreturn 0 />
	<cfelse>
		<cfreturn (variables.hits/requests) />
	</cfif>
</cffunction>



<!--- getSize --->
<cffunction name="getSize" output="false" access="public"
	displayname="Get Size" hint="Returns the size of the cache." 
	description="Returns the size of the cache.">
	
	<cfreturn StructCount(variables._LocalCache) />
</cffunction>



<!--- put --->
<cffunction name="put" access="public" output="false" 
	displayname="Put" hint="I add data to the cache." 
	description="I write data to the disk and then add the data to the variables scoped cache.">

	<cfargument name="key" type="string" required="true" 
		hint="I am the name of datasource to add.<br />I a required."/>
	<cfargument name="value" type="any" required="true" 
		hint="I am the value of datasource to add.<br />I am required."/>
	
	<cfset var dataStructure = StructNew() >
	
	<!--- put the data in a structure with date and time added --->
	<cfset dataStructure.value = arguments.value />
	<cfset dataStructure.timeStamp = now() />
	
	<cfset variables._LocalCache[arguments.key] = dataStructure />
</cffunction>



<!--- delete --->
<cffunction name="delete" access="public" returntype="void" 
	displayname="Delete" hint="Deletes a key/value pair from the cache." 
	description="Deletes a key/value pair from the variables scoped _LocalCache structure.">

	<cfargument name="key" hint="I am the key of the object to delete form the cache.<br />I am required" />
	
	<cfif StructKeyExists(variables._LocalCache, arguments.key)>
		<cfset structDelete(variables._LocalCache, arguments.key) />
	</cfif>

</cffunction>



<!--- keyExists --->
<cffunction name="keyExists" access="public" output="false" 
	displayname="Key Exists" hint="I check if a key exists in the cache." 
	description="I check if a key exists in the cache.">
	
	<cfargument name="key" type="string" required="true" 
		hint="I am the key of value to get from the cache.<br />I am required."/>
	
	<cfreturn StructKeyExists(variables._LocalCache, arguments.key) />
</cffunction>



<!--- reap --->
<cffunction name="reap" access="public" output="false" 
	displayname="Reap" hint="I delete cache objects." 
	description="I am a method to conform to the interface for all cache mechnisims.">
	
</cffunction>



<!--- viewCache --->
<cffunction name="viewCache" output="false" access="public" 
	displayname="View Cache" hint="Returns cache information." 
	description="Returns all of the information in the cache. Size, Hit/Miss Ratio and even the cach data itself.">
	
	<cfset var cacheInfo = structNew() />
	
	<cfset cacheInfo.size = getSize() />
	<cfset cacheInfo.HitRatio = getHitRatio() />
	<cfset cacheInfo.cache = variables._LocalCache />
	<cfset cacheInfo.hits = variables.hits />
	<cfset cacheInfo.misses = variables.misses />
	
	<cfreturn cacheInfo />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

</cfcomponent>