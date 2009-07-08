<!--- Document Information -----------------------------------------------------
Build:      				@@@revision-number@@@
Title:						PageEvent.cfc
Author:					John Allen
Email:						jallen@figleaf.com
company:				Figleaf Software
Website:				http://www.nist.gov
Purpose:				I am the Page Event. I am the object that
							persist information for single request.
Modification Log:
Name				Date				Description
================================================================================
John Allen		03/04/2008		Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Event" output="false"
	hint="I am the Event object, a transient object used to build and persist data for a page request."
		extends="EventCollection">

<!--- ****************************** Scopes ****************************** --->
<cfset variables.instance = structNew() />


<!--- ****************************** Public ****************************** --->

<!--- init --->
<cffunction name="init" output="false" 
	displayname="Init" hint="I am the constuctor for this CFC."
	description="I return an instance of myself.">
	
	<cfargument name="ElementFactory" hint="I am the Element Factory. I am requried." />
	<cfargument name="Config" hint="I am the Config component. I am requried." />
	<cfargument name="UDF" hint="I am the UDF component. I am requried." />
	<cfargument name="RenderHandlerService" hint="I am the UDF component. I am requried." />

	<cfset variables.instance.eventCollection = createObject("component", "EventCollection").init() />
	<cfset variables.instance.Input = createObject("component", "Input").init() />
	<cfset variables.Config = arguments.Config />
	<cfset variables.ElementFactory = arguments.ElementFactory />
	
	<!--- needed, old code gets the udf from here --->
	<cfset setUDFs(arguments.UDF) />
	
	<!--- the logic to populate the event  --->
	<cfset initalizeEvent() />
	
	<cfreturn this  />
</cffunction>



<!--- getSubSiteDefinition --->
<cffunction name="getSubSiteDefinition" access="public"  output="false"
	displayname="GetSubSiteDefinition" hint="I return a structure of information about the main Sub Site/OU. Return Type: Struct"
	description="I return a structure of configuration xml data, based on a what 'Top Level' sub-site the page is in.  Return Type: Struct">

	<cfargument name="SubSiteName" type="string" required="false" default="#getSubSiteName()#"
		hint="I am the name of the sub-site to get." />
	<cfargument name="subsiteDefinitions" default="#variables.Config.getSubSiteDefinitions()#" 
		hint="I am the array of Sub Definitions as defined by the SubSiteDefinsitions.xml file."/>
	
	<cfreturn variables.Config.getSubSiteDefinition(argumentCollection = arguments) />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" output="false"
	displayname="Get Instance" hint="I return the variable scope."
	description="I return the variables scope.">

	<cfreturn  variables.instance />
</cffunction>



<!--- ****************************** Package ****************************** --->
<!--- ****************************** Private ****************************** --->


<!--- initalizeEvent --->
<cffunction name="initalizeEvent" access="private" output="false" returntype="void" 
	displayname="Initalize Event" hint="I do the heavy lifting for the framework. I am the 'builder' pattern." 
	description="I do the heavy lifting when rendering a page. I encapsulate values from the request scope, make a few desicisions about values to add from configuration and query the database for my custom elements data.">

	<cfargument name="CSData" default="#request#" 
		hint="I am ColdFusions Request Scope. I default to the request scope." />

	<cfset var test = "" />
	<cfset var metaDataFieldName = "" />
	
	<!--- The meta data form and field names --->
	<cfset var formName = variables.Config.getPageTypeMetaDataFormName() />
	<cfset var fieldName = variables.Config.getPageTypeMetaDataFormFieldName() />
	
	<!--- CommonSpot request scope variables --->
	<cfset setPageID(arguments.CSData.page.id) />	
	<cfset setPageName(arguments.CSData.page.Title) />
	<cfset setPageCreateDate(arguments.CSData.page.dateAdded) />
	<cfset setPageLastModifyDate(arguments.CSData.page.DateContentLastModified) />
	<cfset setSiteURL(arguments.CSData.site.url) />
	<cfset setSiteName(arguments.CSData.site.name) />
	<cfset setChildSubSites(arguments.CSData.subsite.childList) />
	<cfset setSubSiteName(arguments.CSData.subsite.name) />
	<cfset setSubSiteURL(arguments.CSData.subsite.url) />
	<cfset setSubSiteID(arguments.CSData.subsite.id) />
	
	<!--- Email --->
	<cfif isStruct(arguments.CSData.subsite) and  len(arguments.CSData.subsite.webMasterEmail) gt 3>
		<cfset setFooterEmail(arguments.CSData.subsite.webMasterEmail) />
	<cfelse><!--- else use the main web sites administrator email --->
		<cfset setFooterEmail(arguments.CSData.cp.adminEmailAddr) />
	</cfif>
	
	<!--- Configuration variables --->
	<cfset setSiteContext(variables.Config.getWebSiteContext()) />
	<cfset setImageDirectory(variables.Config.getImageDirectory()) />
	
	<!--- TODO: gotta search replace this spelling error. --->
	<cfset setRederHandlerDirectory(variables.Config.getRenderHandlerDirectory()) />
	<cfset setRenderHandlerDirectory(variables.Config.getRenderHandlerDirectory()) />
	
	<cfif structKeyExists(arguments.CSData.page.metadata[formname], fieldName)>
		<cfset setCustomElementName(arguments.CSData.page.metadata[formname][fieldName]) />
		
		<!--- Page Type Definitions structure. It determines which custom element to use --->
		<!--- TODO: figure out if this is used a lot and maybe kill --->
		<cfset setPageTypeDefinitions
			(variables.elementFactory.getElement
				(name = arguments.CSData.page.metadata[formname][fieldName]).getInstance()) />
		
		<!--- reverse compatability, --->
		<cfset getInstance().PAGETYPEDEFINITIONS.customElementName = arguments.CSData.page.metadata[formname][fieldName] />
	
	<cfelse><!--- else a page OUTSIDE of the framework --->
		<cfset setCustomElementName(variables.config.getInstance().CONSTANTS.DATANOTFOUND) />
		
		<!--- this will add an empty struct --->
		<cfset setPageTypeDefinitions(variables.elementFactory.getElement().getInstance()) />
		
		<cfset getInstance().PAGETYPEDEFINITIONS.customElementName = "search" />
	</cfif>
	
	<!--- query the db for the customelement data and load URL and FORM scopes --->
	<cfset configure() />

	<!--- set the correct top level CSS selector root or non-root relative --->
	<cfif len(variables.Config.getWebSiteContext()) gt 3>
		<cfset test = replace(arguments.CSData.subsite.url, getSiteContext(), "") />
	<cfelse>
		<!--- else running under the root, or could be a sub site  --->
		<cfif isDefined("arguments.CSData.subsite.url")>
			<cfset test =  arguments.CSData.subsite.url />
		<cfelse>
			<!--- it failed, set the default --->
			<cfset test = "/" />
		</cfif>
	</cfif>
	<cfif listLen(test, "/") gte 1 and test neq "/">
		<cfset setParentSite(replace(listGetAt(test, 1, "/"), "/", "", "all")) />
	<cfelse>
		<!--- top level page --->
		<cfset setParentSite(variables.Config.getDefaultCSSClass()) />
	</cfif>

	<cfset setCSSClass(getParentSite()) />
	<cfset setSubSiteCSSClass(getSubSiteName()) />
	<cfset setParentSiteDisplayName(getSubSiteDefinition(SubSiteName = getParentSite()).displayName) />
	<cfset setSubSiteDefinition(getSubSiteDefinition(SubSiteName = getSubSiteName())) />

	<!--- fail silently for pages not defined in the customelements.xml --->
	<cftry>
		<!---  Add the pages meta data values to the eventCollection if Fleet is enabled --->
		<cfif variables.Config.getEnableFleet() eq true>
			<cfset metaDataFieldName = replaceNoCase(variables.Config.getFleetMetaDataFieldName(), "fic_", "") />
			<cfif structKeyExists(arguments.CSData.page.metadata[formname], metaDataFieldName)>
				<cfset setValue(name = "pageMetaDataIDs", 
					value = arguments.CSData.page.metadata[formname][metaDataFieldName]) />
			</cfif>
		</cfif>
		<cfcatch></cfcatch>
	</cftry>

</cffunction>



<!--- configure --->
<cffunction name="configure" returntype="any" access="private" output="false"
	displayname="Configure" hint="I configure several aspects of myself."
	description="I configure several aspects of myself by calling methods on myself. I load the form and URL variables and my custom elements data.">
	
	<!--- 
	Load the FORM and URL variables into the EventCollection and add the
	custom elements data as well.
	--->
	<cfset setValue(value = variables.instance.Input.load(), append = true) />

	<cfset loadBasePageEventData() />
</cffunction>



<!--- loadBasePageEventData --->
<cffunction name="loadBasePageEventData" access="private" output="false"
	displayname="Load Base Page Event Data" hint="I load form,url, and custom element data.."
	description="I load the form and url scopes via the Input.cfc data, and query the database for custom element data into the EventCollection.">
		
	<cfargument name="dsn" default="#variables.Config.getCommonSpotDSN()#"
		hint="I am the CommonSpot site datasource. I default to variables.Config.getCommonSpotDSN()"  />
	
	<cfset var pageID = getPageID() />
	<cfset var CEQuery =  0 />
	<cfset var results = structNew() />
	<cfset var x = 0 />

	<cfquery name="CEQuery" datasource="#arguments.dsn#">
		select 
			replace(f.fieldName,'FIC_','') as fieldName, 
			
			case
				when d.memoValue is not null 
					and ltrim(rtrim(convert(varchar(100),d.memoValue))) != '' 
					then d.memoValue
				else 
					d.fieldValue
			end 
		as fieldValue
		
		from 
			Data_FieldValue d
		join 
			FormInputControl f on d.fieldID = f.ID
			
			where d.pageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#pageID#">
			and 
			d.versionState = 2
			<!--- 
				ADDED by JFA 0062009. 
				Seems to pick up the total custom element even if the page has
				NOT been approved. After FigFactor 2.0 if a page had not been
				approved the custome element form field data woulnt be picked
				up. weird. I HAVE to become a SQL master.
			 --->
			or
			(d.versionState > 2 and d.pageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#pageID#">)
	</cfquery>

	<!--- morph the query to a structure --->
	<cfloop query="CEQuery">
		<!--- ALSO ADDED WITH THE ABOVE QUERY CHANGE. THIS MIGHT SUCK.
			I could be possiable that an older of data hits here. IF so
			revisit this and maybe add a check on the pages "what ever state"
			and only modify the above query if it is in this new state.
		 --->
		<cfif not structKeyExists(results, CEQuery.fieldname)>
			<cfset structInsert(results, CEQuery.fieldname, CEQuery.fieldvalue) />
		</cfif>
	</cfloop>
	
	<cfset setCustomElementData(results) />
	<cfset setValue("customelement", getCustomElementData())>

</cffunction>







<!--- ************************* Accessors/Muators ************************* --->

<!--- SubSiteID --->
<cffunction name="setSubSiteID" output="false" access="public" hint="I set the SubSiteID property.">
	<cfargument name="SubSiteID" type="numeric" />
	<cfset variables.instance.SubSiteID = arguments.SubSiteID />
</cffunction>
<cffunction name="getSubSiteID" output="false" access="public" hint="I return the SubSiteID property.">
	<cfreturn variables.instance.SubSiteID />
</cffunction>
<!--- ChildSubSites --->
<cffunction name="setChildSubSites" output="false" hint="I set the the list of Child IDs for a subsite.">
	<cfargument name="ChildSubSites" />
	<cfset variables.instance.ChildSubSites = trim(arguments.ChildSubSites) />
</cffunction>
<cffunction name="getChildSubSites" output="false" hint="I return a list of a sub-sites child sub-sites ID's.">
	<cfreturn variables.instance.ChildSubSites />
</cffunction>
<!--- SubSiteURL --->
<cffunction name="setSubSiteURL" output="false" hint="I set the root level sub-site for a page.">
	<cfargument name="SubSiteURL" />
	<cfset variables.instance.SubSiteURL = trim(arguments.SubSiteURL) />
</cffunction>
<cffunction name="getSubSiteURL" output="false" hint="I return the root realitive sub-site path for the page.">
	<cfreturn variables.instance.SubSiteURL />
</cffunction>
<!--- CSSClass --->
<cffunction name="setCSSClass" output="false" hint="I set the main CSS ID selector that cascades the look of a pageType.">
	<cfargument name="CSSClass" />
	<cfset variables.instance.CSSClass = trim(arguments.CSSClass) />
</cffunction>
<cffunction name="getCSSClass" output="false" hint="I return main CSS ID selector for a pageType.">
	<cfreturn variables.instance.CSSClass />
</cffunction>
<!--- CustomElementData --->
<cffunction name="setCustomElementData" output="false" hint="I set and persist data for a CommonSpot Element.">
	<cfargument name="CustomElementData" />
	<cfset variables.instance.CustomElementData = arguments.CustomElementData />
</cffunction>
<cffunction name="getCustomElementData" output="false" 
	hint="I return a Array or Structure of containing a CommonSpot Element data.">
	<cfreturn variables.instance.CustomElementData />
</cffunction>
<!--- CustomElementName --->
<cffunction name="setCustomElementName" output="false" hint="I set the name of an events custom elemnet.">
	<cfargument name="CustomElementName" />
	<cfset variables.instance.CustomElementName = trim(arguments.CustomElementName) />
</cffunction>
<cffunction name="getCustomElementName" output="false" hint="I return the name of the events custom element.">
	<cfreturn variables.instance.CustomElementName />
</cffunction>
<!--- FooterEmail --->
<cffunction name="setFooterEmail" output="false" hint="I set the email for the a PageType.">
	<cfargument name="FooterEmail" />
	<cfset variables.instance.FooterEmail = trim(arguments.FooterEmail) />
</cffunction>
<cffunction name="getFooterEmail" output="false" 
	hint="I return the email address for a specific CommonSpot sub site as defined in the CommonSpot administrator.">
	<cfreturn variables.instance.FooterEmail />
</cffunction>
<!--- ImageDirectory --->
<cffunction name="setImageDirectory" output="false" hint="I set the root realitive path to the main image directory.">
	<cfargument name="ImageDirectory" />
	<cfset variables.instance.ImageDirectory = trim(arguments.ImageDirectory) />
</cffunction>
<cffunction name="getImageDirectory" output="false" 
		hint="I return a root realitive string of the images directory.">
	<cfreturn variables.instance.ImageDirectory />
</cffunction>
<!--- PageCreateDate --->
<cffunction name="setPageCreateDate" output="false" hint="I set the pages create date.">
	<cfargument name="PageCreateDate" />
	<cfset variables.instance.PageCreateDate = arguments.PageCreateDate />
</cffunction>
<cffunction name="getPageCreateDate" output="false" 
	hint="I return the pages create date.">
	<cfreturn variables.instance.PageCreateDate />
</cffunction>
<!--- PageLastModifyDate --->
<cffunction name="setPageLastModifyDate" output="false" hint="I set the date a page was last modifyed.">
	<cfargument name="PageLastModifyDate" />
	<cfset variables.instance.PageLastModifyDate = arguments.PageLastModifyDate />
</cffunction>
<cffunction name="getPageLastModifyDate" output="false" 
	hint="I return the page last modifyed date. ">
	<cfreturn variables.instance.PageLastModifyDate />
</cffunction>
<!--- PageID --->
<cffunction name="setPageID" output="false" hint="I set the CommonSpot Page ID of the page.">
	<cfargument name="PageID" />
	<cfset variables.instance.PageID = trim(arguments.PageID) />
</cffunction>
<cffunction name="getPageID" output="false" 
		hint="I return the CommonSpot Page ID .">
	<cfreturn variables.instance.PageID />
</cffunction>
<!--- PageName --->
<cffunction name="setPageName" output="false" hint="I set the pages name.">
	<cfargument name="PageName" />
	<cfset variables.instance.PageName = trim(arguments.PageName) />
</cffunction>
<cffunction name="getPageName" output="false" 
	hint="I return the pages name.">
	<cfreturn variables.instance.PageName />
</cffunction>
<!--- PageTypeDefinitions --->
<cffunction name="setPageTypeDefinitions" output="false" hint="I set the Pages 'Page-Type-Definitions.">
	<cfargument name="PageTypeDefinitions" />
	<cfset variables.instance.PageTypeDefinitions = arguments.PageTypeDefinitions />
</cffunction>
<cffunction name="getPageTypeDefinitions" output="false" 
	hint="I return a structure containing a Pages 'Page-Type-Definition'.">
	<cfreturn variables.instance.PageTypeDefinitions />
</cffunction>
<!--- ParentSite --->
<cffunction name="setParentSite" output="false" hint="I set the pages top level parent sites name.">
	<cfargument name="ParentSite" />
	<cfset variables.instance.ParentSite = trim(arguments.ParentSite) />
</cffunction>
<cffunction name="getParentSite" output="false" 
	hint="I return the top level sub that a page exsists in.">
	<cfreturn variables.instance.ParentSite />
</cffunction>
<!--- ParentSiteDisplayName --->
<cffunction name="setParentSiteDisplayName" output="false" hint="I set the pages top leve parent display name.">
	<cfargument name="ParentSiteDisplayName" />
	<cfset variables.instance.ParentSiteDisplayName = trim(arguments.ParentSiteDisplayName) />
</cffunction>
<cffunction name="getParentSiteDisplayName" output="false" 
	hint="I return the top level sub site display name for a page.">
	<cfreturn variables.instance.ParentSiteDisplayName />
</cffunction>
<!--- SiteContext --->
<cffunction name="setSiteContext"  output="false" hint="I set the sits context.">
	<cfargument  name="SiteContext" />
	<cfset variables.instance.SiteContext = trim(arguments.SiteContext) />
</cffunction>
<cffunction name="getSiteContext" output="false" hint="I return the correct site context. eg: / or /sitename">
	<cfreturn variables.instance.SiteContext />
</cffunction>
<!--- SiteName --->
<cffunction name="setSiteName"  output="false" hint="I set the sites name.">
	<cfargument name="SiteName" />
	<cfset variables.instance.SiteName = trim(arguments.SiteName) />
</cffunction>
<cffunction name="getSiteName" output="false" hint="I return the sites name.">
	<cfreturn variables.instance.SiteName />
</cffunction>
<!--- SiteURL --->
<cffunction name="setSiteURL"  output="false" hint="I set the sites URL.">
	<cfargument  name="SiteURL" />
	<cfset variables.instance.SiteURL = trim(arguments.SiteURL) />
</cffunction>
<cffunction name="getSiteURL" output="false" hint="I return the sites URL. ">
	<cfreturn variables.instance.SiteURL />
</cffunction>
<!--- SubSiteCSSClass --->
<cffunction name="setSubSiteCSSClass" output="false" hint="I set a pages parent sub sits CSS ID selector.">
	<cfargument name="SubSiteCSSClass" />
	<cfset variables.instance.SubSiteCSSClass = trim(arguments.SubSiteCSSClass) />
</cffunction>
<cffunction name="getSubSiteCSSClass" output="false" hint="I retrun a pages parent sub sites CSS ID selector.">
	<cfreturn variables.instance.SubSiteCSSClass />
</cffunction>
<!--- SubSiteName --->
<cffunction name="setSubSiteName" output="false" hint="I set the pages sub site name.">
	<cfargument name="subSiteName" />
	<cfset variables.instance.subSiteName = trim(arguments.subSiteName) />
</cffunction>
<cffunction name="getSubSiteName" output="false" hint="I return the pages sub sites name.">
	<cfreturn variables.instance.subSiteName />
</cffunction>
<!--- SubSiteDefinitions --->
<cffunction name="setSubSiteDefinition" output="false" hint="I set the Subsite definitions structure.">
	<cfargument name="SubSiteDefinition" />
	<cfset variables.instance.SubSiteDefinition = arguments.SubSiteDefinition />
</cffunction>
<!--- UDFs --->
<cffunction name="setUDFs" output="false" hint="I set the frameworks UDF library.">
	<cfargument name="UDFs" />
	<cfset variables.instance.UDFs = arguments.UDFs />
</cffunction>
<cffunction name="getUDFs"  output="false" hint="I return the ViewFrameworks UDF Library.">
	<cfreturn variables.instance.UDFs />
</cffunction>
<!--- getRenderHandlerDirectory --->
<cffunction name="getRenderHandlerDirectory" access="public" output="false" returntype="string"
	displayname="Get RenderHandlerDirectory" hint="I return the RenderHandlerDirectory property." 
	description="I return the RenderHandlerDirectory property of my internal instance structure.">
	<cfreturn variables.instance.RenderHandlerDirectory />
</cffunction>
<!--- setRenderHandlerDirectory --->
<cffunction name="setRenderHandlerDirectory" access="public" output="false" returntype="void"
	displayname="Set RenderHandlerDirectory" hint="I set the RenderHandlerDirectory property." 
	description="I set the RenderHandlerDirectory property to my internal instance structure.">
	<cfargument name="RenderHandlerDirectory" type="string" required="true"
		hint="I am the RenderHandlerDirectory property. I am required."/>
	<cfset variables.instance.RenderHandlerDirectory = arguments.RenderHandlerDirectory />
</cffunction>



<!--- ****************************** Legacy ****************************** --->
<!--- 
TODO: gotta FIX THIS SPELLING ERROR IN ALL VIEW CODE!
 --->
<!--- RederHandlerDirectory --->
<cffunction name="setRederHandlerDirectory" output="false" hint="DEPRECIATED! SPELLING ERROR">
	<cfset setRenderHandlerDirectory(argumentCollection = arguments) />
</cffunction>
<cffunction name="getRederHandlerDirectory"  output="false" 
	hint="DEPRECIATED! SPELLING ERROR">
	<cfreturn getRenderHandlerDirectory() />
</cffunction>
</cfcomponent>