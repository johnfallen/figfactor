<!--- Document Information -----------------------------------------------------
Build:					@@@revision-number@@@
Title:					ViewFramework.cfc
Author: 				John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am the API of ViewFramework.

		This framework is very simple. It encapsulates 
		a few variables from the CommonSpot request 'monster' 
		and sets them to the PageEvent object, and reads xml 
		file data to determine a few things such as CSS classes.

		Hows it work? Very simple. 

		1. 	The template-basepage.cfm file calls 
			buildPageEvent() for every request. This populates 
			the PageEvent.cfc to persist a requests data.

		2. 	Render Handlers then call getPageEvent() to 
			get the PageEvent data.

		3. 	Code in the current request that is outside the context
			of the render handler can call getElementData() to
			get back a structure or array of a CommonSpot "out-of-the-box"
			elements data.

Usage: 	Dump this CFC, all the Description attributes are highly commented.

Modification Log:

Name				Date				Description
================================================================================
John Allen		21/03/2008		Created
John Allen		18/09/2008		Reached Beta Status
John Allen		23/09/2008		Released
John Allen		24/09/2008		Cleaned up how the PageEvent interacts with dataservice.
										Removed recach and getFullCustomElement args from the
										getPageEvent() method.
										Optimized some string compairison code to use 
										compareNoCase().
------------------------------------------------------------------------------->
<cfcomponent displayname="View Framework" output="false" 
	hint="I am the API for ViewFramework. A framework that implements a 'view pattern' for CommonSpot.">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" access="public" output="false" 
	displayname="Init" hint="I am the constructor for this CFC." 
	description="I initalize all the child components and return and instance of the framework.">

	<cfargument name="BeanFactory" default="#application.BeanFactory#" 
		hint="I am FigFactor's BeanFactory object.<br />I default to 'Application.BeanFactory'." />

	<cfset variables.BeanFactory = arguments.BeanFactory />
	<cfset variables.ConfigBean = variables.BeanFactory.getBean("ConfigBean") />
	<cfset variables.Logger = variables.BeanFactory.getBean("Logger") />
	<cfset variables.EmergencyService = variables.BeanFactory.getBean("Emergency") />
	<cfset variables.UDFLibrary = variables.BeanFactory.getBean("udf")  />
	<cfset variables.Input = variables.BeanFactory.getBean("Input")  />
	<cfset variables.DataService = variables.BeanFactory.getBean("DataService") />
	<cfset variables.ElementFactory = variables.BeanFactory.getBean("ElementFactory")  />
	<cfset variables.noPageType =  variables.ConfigBean.getConstants().DATANOTFOUND />
	
	<!--- internal --->
	<cfset variables.XMLConfigurationService = 0 />
	<cfset variables.PageEventProxy = 0 />
	<cfset variables.RenderHandlerService = 0/>

	<cfset variables.XMLConfigurationService = 
		createObject("component", "com.xmlconfigurationloader.XMLConfigurationLoader").init(variables.BeanFactory) />
	<cfset variables.PageEventProxy = createObject("component", "com.event.PageEventProxy").init() />
	<cfset variables.RenderHandlerService = createObject("component", "com.util.RenderHandlerService") />
	
	<cfreturn this />
</cffunction>



<!--- buildPageEvent --->
<cffunction name="buildPageEvent" access="public" output="false" 
	displayname="Build Page Event" hint="I do the heavy lifting for the framework. I am the 'builder' pattern." 
	description="I do the heavy lifting when rendering a page. I encapsulate
		values from the request scope, make a few desicisions about
		values to add from configuration and query the database
		for my custom elements data.
		<br /><br />
		I am normaly called with a  CommonSpot 'invoke-dynamic-cfml' 
		module from the template-basepage.cfm.
		<br /><br />
		If no render handlers use the CommonSpot 'invoke-dynamic-cfml' 
		module buildPageEvent() should be called directly from 
		template-basepage.cfm so it gets cached by CommonSpot at the 
		template level for optimal performance.">

	<cfargument name="CommonSpotData" default="#request#" 
		hint="I am ColdFusions Request Scope.<br />I default to the request scope." />
	<cfargument name="PageEvent" default="#variables.PageEventProxy.getPageEvent()#" 
		hint="I am the PageEvent.<br />I am required.
		<br /><br />
		I am here, poluting the API becasue we also need to be able to pass the 
		MockPageEvent through the framework to test it." />

	<cfset var test = "" />
	<cfset var metaDataFieldName = "" />
	
	<!--- The meta data FORM name that contains the select list of custom elements/pageTypes --->
	<cfset var formName = variables.ConfigBean.getPageTypeMetaDataFromName() />
	
	<!--- The meta data select list FIELD name that contains the configured custom elements/pageTypes --->
	<cfset var fieldName = variables.ConfigBean.getPageTypeMetaDataFormFieldName() />
	
	<!--- Set CommonSpots request scope variables to the PageEvent object --->
	<cfset arguments.PageEvent.setPageID(arguments.CommonSpotData.page.id) />	
	<cfset arguments.PageEvent.setPageName(arguments.CommonSpotData.page.Title) />
	<cfset arguments.PageEvent.setPageCreateDate(arguments.CommonSpotData.page.dateAdded) />
	<cfset arguments.PageEvent.setPageLastModifyDate(arguments.CommonSpotData.page.DateContentLastModified) />
	
	<cftry>
		<cfset arguments.PageEvent.setCustomElementName(arguments.CommonSpotData.page.metadata[formname][fieldName]) />
		<cfcatch></cfcatch>
	</cftry>
	
	<cfset arguments.PageEvent.setSiteURL(arguments.CommonSpotData.site.url) />
	<cfset arguments.PageEvent.setSiteName(arguments.CommonSpotData.site.name) />
	<cfset arguments.PageEvent.setChildSubSites(arguments.CommonSpotData.subsite.childList) />
	<cfset arguments.PageEvent.setSubSiteName(arguments.CommonSpotData.subsite.name) />
	<cfset arguments.PageEvent.setSubSiteURL(arguments.CommonSpotData.subsite.url) />
	<cfset arguments.PageEvent.setSubSiteID(arguments.CommonSpotData.subsite.id) />

	<!--- Configuration variables --->
	<cfset arguments.PageEvent.setSiteContext(variables.ConfigBean.getWebSiteContext()) />
	<cfset arguments.PageEvent.setImageDirectory(variables.ConfigBean.getImageDirectory()) />
	<cfset arguments.PageEvent.setRederHandlerDirectory(variables.ConfigBean.getRederHandlerDirectory()) />

	<!--- pages not in the customelements.xml files won't have this hence the silent cftry --->
	<cftry>
		<!--- Set the "Page Type Definitions" structure. It determines which custom element to use --->
		<cfif  len(arguments.CommonSpotData.page.metadata[formname][fieldName])>
			<cfset arguments.PageEvent.setPageTypeDefinitions
				(variables.elementFactory.getElement
					(name = arguments.CommonSpotData.page.metadata[formname][fieldName]).getInstance()) />
		<cfelse>
			<!--- Else add an empty structure --->
			<cfset arguments.PageEvent.setPageTypeDefinitions
				(variables.elementFactory.getElement().getInstance()) />
			</cfif>
		<cfcatch>
		<!--- Else add an empty structure --->
		<cfset arguments.PageEvent.setPageTypeDefinitions
			(variables.elementFactory.getElement().getInstance()) />
		</cfcatch>
	</cftry>

	<!--- pages not in the customelements.xml files won't have this, hence the try --->
	<cftry>
		<!--- Reverse compatability, for code that wants to refrence the value customElementName --->
		<cfset arguments.PageEvent.getInstance().PAGETYPEDEFINITIONS.customElementName = arguments.CommonSpotData.page.metadata[formname][fieldName] />
		<cfcatch>
			<cfset arguments.PageEvent.getInstance().PAGETYPEDEFINITIONS.customElementName = "search" />
		</cfcatch>
	</cftry>

	<!--- 
	Configure the pageEvent, add the URL and FORM scopes and its custom element data
	to the pageEvent's EventColleciton.
	 --->
	<cfset arguments.pageEvent.configure() />

	<!--- This lets us run root or non-root relative and still set the correct top level CSS selector --->
	<cfif len(variables.ConfigBean.getWebSiteContext()) gt 3>
		<cfset test = replace(
			arguments.CommonSpotData.subsite.url, 
			arguments.PageEvent.getSiteContext(), "") />
	<cfelse>
		<!--- else running under the root, or could be a sub site  --->
		<cfif isDefined("arguments.CommonSpotData.subsite.url")>
			<cfset test =  arguments.CommonSpotData.subsite.url />
		<cfelse>
			<!--- it failed, set the default --->
			<cfset test = "/" />
		</cfif>
	</cfif>
	<cfif listLen(test, "/") GTE 1 AND test neq "/">
		<cfset arguments.PageEvent.setParentSite(replace(listGetAt(test, 1, "/"), "/", "", "all")) />
	<cfelse>
		<!--- else this is the home page or a page not in a sub-site --->
		<cfset arguments.PageEvent.setParentSite(variables.ConfigBean.getDefaultCSSClass()) />
	</cfif>

	<!--- Email --->
	<cfif isStruct(arguments.CommonSpotData.subsite) 
		AND  
		len(arguments.CommonSpotData.subsite.webMasterEmail) GT 3>
		<cfset arguments.PageEvent.setFooterEmail(arguments.CommonSpotData.subsite.webMasterEmail) />
	<cfelse><!--- else use the main web sites administrator email --->
		<cfset arguments.PageEvent.setFooterEmail(arguments.CommonSpotData.cp.adminEmailAddr) />
	</cfif>
	
	<!--- Top Level CSS Class, Sub-Site CSS Class, Parent Display Name, SubSite Definitions and UDF's --->
	<cfset arguments.PageEvent.setCSSClass(arguments.PageEvent.getParentSite()) />
	<cfset arguments.PageEvent.setSubSiteCSSClass(arguments.PageEvent.getSubSiteName()) />
	<cfset arguments.PageEvent.setParentSiteDisplayName(
		getSubSiteDefinition(SubSiteName = arguments.PageEvent.getParentSite()).displayName) />
	<cfset arguments.PageEvent.setSubSiteDefinition(
		getSubSiteDefinition(SubSiteName = arguments.PageEvent.getSubSiteName())) />
	<cfset arguments.PageEvent.setUDFs(variables.UDFLibrary)  />

	<!--- pages not in the customelements.xml files won't have this, hence the try --->
	<cftry>
		<!---  Add the pages meta data values to the eventCollection if Fleet is enabled --->
		<cfif variables.ConfigBean.getEnableFleet() eq true>
			<cfset metaDataFieldName = replaceNoCase(variables.ConfigBean.getFleetMetaDataFieldName(), "fic_", "") />
			<cfif structKeyExists(arguments.CommonSpotData.page.metadata[formname], metaDataFieldName)>
				<cfset arguments.PageEvent.setValue(name = "pageMetaDataIDs", 
					value = arguments.CommonSpotData.page.metadata[formname][metaDataFieldName]) />
			</cfif>
		</cfif>
		<cfcatch></cfcatch>
	</cftry>

	<!--- If DataService is active, run queries and add them to the PageEvent's EventCollection. --->
	<cfif variables.ConfigBean.getImplementDataService() eq true AND
		arguments.PageEvent.getPageTypeDefinitions().useDataService eq true>
		
		<!--- if the URL wants to us to re-cache the query, pass it with the recach flag to true --->
		<cfif structKeyExists(url, configBean.getURLCacheReloadKey()) and
			(not comparenocase(url[configBean.getURLCacheReloadKey()], configBean.getURLCacheRelaodValue()))>

			<cfset variables.DataService.setPageEventQueries(
				PageEvent = arguments.PageEvent,
				recache = true) />
		<cfelse>
			<!--- 
				The custom element type is configured to use DataService, so 
				pass the object as normal, DataService will determine whether 
				or not to give us a cached or fresh, hot, and new query.
			--->
			<cfset variables.DataService.setPageEventQueries(arguments.PageEvent) />
		</cfif>
	</cfif>
	
</cffunction>



<!--- getElementData --->
<cffunction name="getElementData" access="public" output="false" 
	displayname="Get Element Data" hint="I return a a CommonSpot elements data." 
	description="Returns an easy to use array or structure, depending on element 
		type, of the elements data. This method is provided so other render 
		handlers inside the Page Type render handler, or code outside the 
		context of the Page Type render handler can conveniently use 
		ViewFramework.">
	
	<cfargument name="elementInfo" type="struct" required="true" 
		hint="I am the CommonSpot elements elementInfo structure.<br />I am required." />
	<cfargument name="elementType" type="string" required="true" 
		hint="I am a string that should match a CommonSpots element type.<br />I am required." />

	<cfset var elementData = 0 />
	<cfset var RenderHandlerService = variables.RenderHandlerService.init(arguments.elementInfo) />
	
	<!--- get the element from the RenderHandlerService --->	
	<cfset var test = RenderHandlerService.getElementData(arguments.elementType) />
	
	<!--- always return an array if a linkBar --->
	<cfif elementType neq "linkBar">
		<!--- check if the service return is a single row array, and if so, just return the structure --->
		<cfif isArray(test) AND arrayLen(test) eq 1>
			<cfset elementData = test[1] />
		<cfelse>
			<cfset elementData = test />
		</cfif>
	<cfelse>
		<cfset elementData = test />
	</cfif>

	<cfreturn elementData />
</cffunction>



<!--- getPageEvent --->
<cffunction name="getPageEvent" access="public" output="false" 
	displayname="Get Page Event"  hint="I return the PageEvent object.<br />Return Type = PageEvent" 
	description="
		I return an object populated with the correct data to render a page. 
		This method can be called from inside or outside the context of a  
		render handler.
		<br /><br />
		When I am called from within the context of the configured render handler
		pass me the elementInfo structure and I will return it all nice and pretty
		ready for display. If I am called from outside the context of the PageType 
		render handler I can still do some heavy lifting and transform any of CommonSpots
		elements into arrays and structurs that are easer to work with.">

	<!--- keep this as a passed argument, so we can test with the MockPagEvent --->
	<cfargument name="PageEvent" default="#variables.PageEventProxy.getPageEvent()#"
		hint="I am the PageEvent.<br />I default to a return from the PageEventProxie.
		<br /><br />
		I am here, poluting the API becasue we also need to be able to pass the 
		MockPageEvent through the framework to test it." />
	<cfargument name="elementInfo" required="false" default=""
		hint="I am the CommonSpots elementInfo data structure." />
	<cfargument name="elementType" default="custom" 
		hint="I am a string that should match a CommonSpot element type.<br />I default to 'custom'." />

	<cfset var customElementData = structNew() />
	<cfset var x = 1 />

	<cfif isStruct(arguments.elementInfo)>
	
		<cfset customElementData = getElementData(
			elementInfo = arguments.elementInfo,
			elementType  = arguments.elementType) />
		<!---  
		Make the return from the RenderHadlerService easer to work with for the views.
		Lets views refrence foo.database_column_name instead of foo.fields.database_column_name.value.
		--->
		<cfif arguments.elementType eq "custom">
			<cfset customElementData = customElementData.fields />
			<cfloop collection="#customElementData#" item="x">
				<cfset customElementData[x] = customElementData[x].value />
			</cfloop>
			<cfset arguments.pageEvent.setCustomElementData(customElementData) />
		</cfif>
	</cfif>
		
	<cfreturn arguments.pageEvent />
</cffunction>



<!--- getMockPageEvent --->
<cffunction name="getMockPageEvent" access="public" output="false" 
	displayname="Get Mock Page Event Object" hint="I return a Mock Page Event Object.<br />Return Type = MockPageEventType" 
	description="
		Returns a 'mock' Page Event object populated so a developer can 
		send a request through the framework without being tied to a 
		CommonSpot server.">
	
	<cfargument name="setRequestScopeDefautls" default="0" 
		hint="I will tell the object to set the necessary request variables that CommonSpot would normally provide." />

	<cfreturn createObject("component", "com.event.MockPageEvent").init(arguments.setRequestScopeDefautls) />
</cffunction>



<!--- getAllLists --->
<cffunction name="getAllLists" returntype="any" access="public" output="false"
	displayname="Get Config List" hint="I return a list of values."
	description="I return all of the XMLConfigurationServices installed lists. Values for the lists are set in the .XML Configuration files ">
	
	<cfreturn variables.XMLConfigurationService.getAllLists() />
</cffunction>



<!--- getList --->
<cffunction name="getList" returntype="any" access="public" output="false"
	displayname="Get Config List" hint="I return a list of values."
	description="I return lists by 'name' which are used to populate CommonSpot form element select list or any lists the views might need.">
	
	<cfargument name="name" type="string" required="true" hint="I am the name of the list.<br />I am required." />
	
	<cfreturn variables.XMLConfigurationService.getList(name = arguments.name) />
</cffunction>



<!--- getAllConfigLists --->
<cffunction name="getAllConfigLists" returntype="any" access="public" output="false"
	displayname="Get Config List" hint="I return a list of values.  I will be depreciated."
	description="I return all of the XMLConfigurationServices installed lists. I will be depreciated.">
	
	<cfreturn getAllLists() />
</cffunction>



<!--- getConfigList --->
<cffunction name="getConfigList" returntype="any" access="public" output="false"
	displayname="Get Config List" hint="I return a list of values. I will be depreciated."
	description="I return a list of values. I will be depreciated.">
	
	<cfargument name="name" type="string" required="true" hint="I am the name of the list.<br />I am required." />
	
	<cfreturn getList(name = arguments.name) />
</cffunction>



<!--- getViewFrameworkVersion --->
<cffunction name="getViewFrameworkVersion" access="public" output="false" 
	displayname="Get ViewFramework Version" hint="I return the ViewFrameworks Version number." 
	description="I return the frameworks version number that is set in the Configuration.ini.cfm file.">

	<cfreturn variables.ConfigBean.getViewFrameworkVersion() />
</cffunction>



<!--- *********** Private ************ --->

<!--- getSubSiteDefinition --->
<cffunction name="getSubSiteDefinition" access="private"  output="false"
	displayname="GetSubSiteDefinition" hint="I return a structure of information about the main Sub Site/OU.<br />Returntype:Structure"
	description="I return a structure of configuration xml data, based on a what 'Top Level' sub-site the page is in.">

	<cfargument name="SubSiteName" type="string" required="false" 
		hint="I am the name of the sub-site to get." />
	<cfargument name="subsiteDefinitions" default="#variables.XMLConfigurationService.getConfigArray(name = 'SubSiteDefinitions')#" 
		hint="I am the array of Sub Definitions as set in configuration XML.<br />I call the XMLConfigurationService to get my value."/>
	
	<cfset var x = 0 />
	<cfset var subSiteData = structNew() />
	
	<cfloop from="1" to="#arrayLen(arguments.subsiteDefinitions)#" index="x">
		<cfif not comparenocase(arguments.SubSiteName, arguments.subsiteDefinitions[x].name)>
			<cfset subSiteData = arguments.subsiteDefinitions[x] />
			<cfbreak />
		</cfif>
	</cfloop>
	
	<cfif structIsEmpty(subSiteData)>
		<cfset subsiteData.name = "" />
		<cfset subsiteData.CSSClassName = variables.ConfigBean.getDefaultCSSClass() />
		<cfset subsiteData.displayName = "" />
		<cfset subsiteData.parentName = getPageEvent().getParentSite() />
	</cfif>

	<cfreturn subSiteData />
</cffunction>
</cfcomponent>