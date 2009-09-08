<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		DataService.cfc
Author:     		John Allen
Email:      		jallen@figleaf.com
Company:			@@@company-name@@@
Website:			@@@web-site@@@
Purpose:    		I am the API of the DataService, a "tool kit" for adding 
					data returned from methods in CFC's located in the 
					figfactor/site/model/gateways direcotory.

Usage:				setEventConfiguredMethodData
						(
							PageEvent : requried
							recache : defaults to 'false'
						)

Modification Log:
Name	 		Date	 Description
================================================================================
John Allen	 07/06/2008	 Created
John Allen	 04/06/2009	 Refactored for v2 exactly one year later!
John Allen	 07/32/2009	 Finally removed the requirement that injecte methods
						 only return cf query objects!
						 Updated all code comments. They still suck.
------------------------------------------------------------------------------->
<cfcomponent displayname="Data Service"  output="false"
	hint="I am the API of the DataService, a toolkit for getting queries from CommonSpot.">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="component" access="public" output="false" 
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

	<cfset variables.FileIO = 
		createObject("component", "com.xmldata.FileIO").init() />
	<cfset variables.Gateway = 
		createObject("component", "com.gateway.AbstractGateway").init(argumentCollection = arguments) />

	<cfreturn this />
</cffunction>



<!--- setEventConfiguredMethodData --->
<cffunction name="setEventConfiguredMethodData" access="public" output="false" 
	displayname="Set Event Configured Method Data" 
	hint="I call methods configured in the xml and add them to the Page Event." 
	description="
		I add a structure to the Events EventCollection called 
		'dataServiceResult' with keys called:<br /><br />
		CacheKey = the Pages unique key.<br />
		dataServiceResult = The data from the cache<br />
		CacheStatus = wheather or not the data was retrieved from the cache.">
	
	<cfargument name="Event" required="true" 
		hint="I am the frameworks Event object. I am required." />
	<cfargument name="recache" default="false" 
		hint="I am a flag to call my configured methods on the AbstractGateway. I default to false." />
	
	<cfset var dataServiceResult = 0 />
	<cfset var dynamicMethodResults = structNew() />
	<cfset var CacheKey = 0 />
	<cfset var cacheCheck = 0 />
	<cfset var methods = arguments.Event.getPageTypeDefinitions().methods />
	<cfset var x = 0 />
	<cfset var args = structNew() />

	<!--- create and add the Event objects cachKey --->
	<cfset CacheKey = 
		replace(arguments.event.getCustomElementName(), " ", "", "all")
		& "_" & 
		replace(arguments.event.getSubSiteDefinition("#arguments.event.getParentSite()#").name, " ", "", "all")
		& "_" &
		arguments.event.getPageID() />
	
	<cfset arguments.event.setValue(name = "cacheKey", value = CacheKey) />

	<!--- 
		Check if the key for the data is already in the cache. If so, say so
		by keeping cacheCheck eq to true. 
	--->
	<cfset cacheCheck = variables.cache.get(
			key = arguments.event.getValue("cacheKey"), 
			KeyExistsCheck = 1) />

	<!--- 
		Now check if its configured to run every time OR if the Input from the
		Event (for http a URL variable) explicitly requested it be run for this
		specific request.
	 --->
	<cfif arguments.event.getPageTypeDefinitions().useCache eq false 
		or 
		(
			isSimpleValue(cacheCheck) and (not comparenocase(cacheCheck, variables.notFound))
			or 
			(comparenocase(arguments.recache, "false"))
		)>
	
		<!--- arguments for the dynamic method call--->
		<cfset args.Event = arguments.Event />
		<cfset args.BeanFactory = application.FigFactor.getFactory() />
	
		<!--- 
			Loop over the configured methods and call them on the 
			AbstractGateway.cfc which will the methods from any CFC sitting in 
			the site/model/gateway directory injected into it.
		--->
		<cfloop from="1" to="#arraylen(methods)#" index="x">
			
			<cfinvoke 
				component="#variables.Gateway#" 
				method="#methods[x].method#" 
				returnvariable="dataServiceResult" 
				argumentcollection="#args#" />

			<!--- add the returned data to the results struct then to the cache --->
			<cfset dynamicMethodResults[methods[x].resultName] = duplicate(dataServiceResult) />
			<cfset variables.cache.put(
					key = arguments.Event.getValue("cacheKey"), 
					value = dynamicMethodResults) />

		</cfloop>
	
		<!--- 
			Set the data and status of how we got the data.
		--->
		<cfset arguments.Event.setValue(
				name = "dataServiceResult", 
				value = variables.cache.get(arguments.Event.getValue("cacheKey"))) />
		<cfset arguments.Event.setValue(name="cacheStatus", value = 0) />
		<cfset arguments.Event.setValue(name="ranQueries", value = "YES") />

	<cfelse>
	
		<!--- 
			Set the data and status of how we got the data.
		--->
		<cfset arguments.Event.setValue(
				name = "dataServiceResult", 
				value = variables.cache.get(arguments.Event.getValue("cacheKey"))) />
		<cfset arguments.Event.setValue(name="cacheStatus", value = 1) />
		<cfset arguments.Event.setValue(name="ranQueries", value = "NO") />
	</cfif>
	
	<!--- 
		Be cool and kind ... normalize so the event always has this structure
		in the Event objects EventCollection
	--->
	<cfif not isStruct(arguments.Event.getValue("dataServiceResult"))>
		<cfset arguments.Event.setValue(name = "dataServiceResult", value = structNew()) />
		<cfset arguments.Event.setValue(name= "cacheStatus", value = 2) />
		<cfset arguments.Event.setValue(name="ranQueries", value = "NOT CONFIGURED FOR CACHING") />
	</cfif>
	
	<cfreturn arguments.Event />
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