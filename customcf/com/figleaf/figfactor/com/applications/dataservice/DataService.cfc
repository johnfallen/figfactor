<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			DataService.cfc
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:			@@@company-name@@@
Website:			@@@web-site@@@
Purpose:    		I am the API of the DataService, a "tool kit" for getting 
						queries from CommonSpot. I add structures of queries 
						to the PageEvents EventCollection.

Usage:				setPageEventQueries(
							PageEvent : requried
							recache : defaults to 'false')

Modification Log:
Name	 		Date	 			Description
================================================================================
John Allen	 07/06/2008	 Created
John Allen	 04/06/2009	 Refactored for v2 exactly one year later!
------------------------------------------------------------------------------->
<cfcomponent displayname="Data Service"  output="false"
	hint="I am the API of the DataService, a toolkit for getting queries from CommonSpot.">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="DataService" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo-constructor for this CFC. I return an instance of myself.">

	<cfargument name="ElementFactory" type="any" required="true" 
		hint="I am the Element Factory object. I am requried." />
	<cfargument name="Config" type="any" required="true" 
		hint="I am the framework Config object. I am requried." />
	<cfargument name="CacheService" type="any" required="true" 
		hint="I am the framework Cache Service object. I am requried." />
	<cfargument name="UDF" type="any" required="true" 
		hint="I am the framework UDF object. I am requried." />
	<cfargument name="FLEET" type="any" required="false" 
		hint="I am the FLEET component. I am requried." />
	<cfargument name="MessageService" type="any" required="false" 
		hint="I am the MessageService component. I am requried." />
	<cfargument name="ListService" type="any" required="false" 
		hint="I am the ListService any. I am requried." />
	<cfargument name="Security" type="any" required="false" 
		hint="I am the Security component. I am requried." />

	<cfset variables.ConfigBean = arguments.Config />
	<cfset variables.cache = arguments.CacheService.getCache() />
	<cfset variables.UDFs = arguments.udf />
	<cfset variables.writeXMLFileData = variables.ConfigBean.getStoreXMLDiskCache() />
	<cfset variables.version = variables.ConfigBean.getDataserviceVersion() />
	<cfset variables.notFound = variables.ConfigBean.getConstants().DATANOTFOUND />

	<cfset variables.FileIO = createObject("component", "com.xmldata.FileIO").init() />
	<cfset variables.Gateway = createObject("component", "com.gateway.AbstractGateway").init(argumentCollection = arguments) />

	<cfreturn this />
</cffunction>



<!--- setPageEventQueries --->
<cffunction name="setPageEventQueries" access="public" output="false" 
	displayname="Set Page EventQueries " hint="I add values to the Page Event." 
	description="
		I add values to the PageEvent EventCollection. The query data 
		that I add is always pulled from the cache.<br /><br />
		The values I add are:<br />
		CacheKey = the Pages unique key.<br />
		Queries = a struct of queries i return<br />
		CacheStatus = wheather or not the data was retrieved from the cache.">
	
	<cfargument name="PageEvent" required="true" 
		hint="I am the frameworks Event object. I am required." />
	<cfargument name="recache" default="false" 
		hint="I am a flag. I tell the method to run the PageEvent queries regardless of any other logic. I default to false." />
	
	<cfset var query = 0 />
	<cfset var queryStruct = structNew() />
	<cfset var CacheKey = 0 />
	<cfset var cacheCheck = 0 />
	<cfset var methods = arguments.PageEvent.getPageTypeDefinitions().methods />
	<cfset var x = 0 />
	<cfset var args = structNew() />

	<!--- create and add the Event objects cachKey --->
	<cfset CacheKey = 
		replace(arguments.PageEvent.getCustomElementName(), " ", "", "all")
		& "_" & 
		replace(PageEvent.getSubSiteDefinition("#pageEvent.getParentSite()#").name, " ", "", "all")
		& "_" &
		arguments.PageEvent.getPageID() />
	<cfset arguments.PageEvent.setValue(name = "cacheKey", value = CacheKey) />

	<!--- 
	If the query data is not in the cache, get it from the gateway and then 
	put it in the cache. At the end of the method get the cached data and set it
	using the PageEvent's EventCollention with setValue(). This way data is always 
	pulled from the cache.
	
	The check below creates 2 different senerios: 
		1. the event is configured to never cache anything
		2. the data is not in the cache
	--->
	
	<cfset cacheCheck = variables.cache.get(key = arguments.PageEvent.getValue("cacheKey"), KeyExistsCheck = 1) />
	<cfif arguments.PageEvent.getPageTypeDefinitions().useCache eq false 
		or 
		(
			isSimpleValue(cacheCheck) and (not comparenocase(cacheCheck, variables.notFound))
			or 
			(comparenocase(arguments.recache, "false"))
		)>
		
		<!--- arguments for the dynamic method call--->
		<cfset args.pageEvent = arguments.pageEvent />
		<cfset args.BeanFactory = application.FigFactor.getFactory() />

		<cfloop from="1" to="#arraylen(methods)#" index="x">
			<cfinvoke 
				component="#variables.Gateway#" 
				method="#methods[x].method#" 
				returnvariable="query" 
				argumentcollection="#args#" />
			
			<!--- Add each query to the cach if it has any records --->
			<cfif isQuery(query) and query.recordcount>
				<cfset queryStruct[methods[x].resultName] = duplicate(query) />
				<cfset variables.cache.put(key = arguments.PageEvent.getValue("cacheKey"), value = queryStruct) />
			</cfif>
		</cfloop>
	
		<!--- add the cached data to event and set its status --->
		<cfset arguments.PageEvent.setValue(name = "queries", value = variables.cache.get(arguments.PageEvent.getValue("cacheKey"))) />
		<cfset arguments.PageEvent.setValue(name="cacheStatus", value = 0) />
		<cfset arguments.PageEvent.setValue(name="ranQueries", value = "YES") />
		
		<!--- if configured, write the xml file --->
		<cfif variables.writeXMLFileData eq true>
			<cfset variables.FileIO.writeXMLFile(key = arguments.PageEvent.getValue("cacheKey"), value = arguments.PageEvent.getValue("queries")) />
		</cfif>

	<cfelse>
	
		<!--- pull from the cache, add to the event, and set its status --->
		<cfset arguments.PageEvent.setValue(name = "queries", value = variables.cache.get(arguments.PageEvent.getValue("cacheKey"))) />
		<cfset arguments.PageEvent.setValue(name="cacheStatus", value = 1) />
		<cfset arguments.PageEvent.setValue(name="ranQueries", value = "NO") />
	</cfif>
	
	<!--- Normalize the EventCollecitons 'queries' value to always return a structure --->
	<cfif not isStruct(arguments.PageEvent.getValue("queries"))>
		<cfset arguments.PageEvent.setValue(name = "queries", value = structNew()) />
		<cfset arguments.PageEvent.setValue(name= "cacheStatus", value = 2) />
		<cfset arguments.PageEvent.setValue(name="ranQueries", value = "NOT CONFIGURED FOR CACHING") />
	</cfif>
	
	<cfreturn arguments.PageEvent />
</cffunction>


<!--- getCache --->
<cffunction name="getCache" returntype="any" access="public" output="false"	
	displayname="Get Cache" hint="I return my internal cache object."
	description="I return my internal cache object. Used for development and debugging.">
    
	<cfreturn variables.cache />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" access="public" output="false" 
	displayname="Get Instance" hint="I return my self. Used for development.<br />Return Type: |DataService|" 
	description="I return my self. Currently not used by the DataService system and only used for development.">

	<cfreturn variables />
</cffunction>



<!--- getVersion --->
<cffunction name="getVersion" access="public" output="false"
	hint="I return the version number of the DataService Tool Kit.">

	<cfreturn variables.version  />
</cffunction>

<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>