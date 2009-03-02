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
<cfcomponent displayname="Page Event Bean" output="false"
	hint="I am the Page Event Bean. I manage the persistance of information when rendering a page."
		extends="EventCollection">

<cfset variables.instance = structNew() />
<cfset variables.instance.eventCollection = 0 />

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" access="public" output="false" 
	displayname="Init" hint="I am the constuctor for this CFC."
	description="I return an instance of myself.">
	
	<cfset variables.instance.eventCollection = createObject("component", "EventCollection").init() />
	<cfset variables.instance.Input = Application.BeanFactory.getBean("input") />
	<cfset variables.instance.dsn = Application.BeanFactory.getBean("ConfigBean").getCommonSpotDSN() />
	
	<cfreturn this  />
</cffunction>



<!--- configure --->
<cffunction name="configure" returntype="any" access="public" output="false"
	displayname="Configure" hint="I configure several aspects of myself."
	description="I configure several aspects of myself by calling methods on myself. I load the form and URL variables and my custom elements data.">
	
	<!--- 
	Load the FORM and URL variables into the EventCollection 
	--->
	<cfset setValue(value = variables.instance.Input.load(), append = true) />
	
	<!--- 
	Load the pages "raw", unproscessed by CommonSpot, custom elements data 
	into the event collection. Need to try/catch so it runs with out being attached
	to a CommonSpot instaliation.
	--->
	<cftry>
		<cfset loadBasePageEventData(variables.instance.dsn) />
		<cfcatch></cfcatch>
	</cftry>

</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="any" access="public" output="false"
	displayname="Get Instance" hint="I return the variable scope."
	description="I return the variables scope.">

	<cfreturn  variables.instance />
</cffunction>



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
<cffunction name="getSubSiteDefinition" output="false" hint="I return the Subsite definitions structure.">
	<cfreturn variables.instance.SubSiteDefinition />
</cffunction>

<!--- UDFs --->
<cffunction name="setUDFs" output="false" hint="I set the frameworks UDF library.">
	<cfargument name="UDFs" />
	<cfset variables.instance.UDFs = arguments.UDFs />
</cffunction>
<cffunction name="getUDFs"  output="false" hint="I return the ViewFrameworks UDF Library.">
	<cfreturn variables.instance.UDFs />
</cffunction>

<!--- RederHandlerDirectory --->
<cffunction name="setRederHandlerDirectory" output="false" hint="I set the path for the render handler direcory.">
	<cfargument name="RederHandlerDirectory" />
	<cfset variables.instance.RederHandlerDirectory = arguments.RederHandlerDirectory />
</cffunction>
<cffunction name="getRederHandlerDirectory"  output="false" 
	hint="I return the ViewFrameworks render handler directory location realitive to the root.">
	<cfreturn variables.instance.RederHandlerDirectory />
</cffunction>

	
<!--- *********** Package ************ --->
<!--- *********** Private ************ --->

<!--- loadBasePageEventData --->
<cffunction name="loadBasePageEventData" access="private" output="false"
	displayname="Load Base Page Event Data" hint="I load form,url, and custom element data.."
	description="I load the form and url scopes via the Input.cfc data, and query the database for custom element data into the EventCollection.">
		
	<cfargument name="dsn" hint="I am the CommonSpot site datasource.<br />I am required." />
	
	<cfset var pageID = getPageID() />
	<cfset var CEQuery =  0 />
	<cfset var results = structNew() />
	<cfset var x = 0 />
	
	<cfquery name="CEQuery" datasource="#arguments.dsn#">
		select
			replace(f.fieldName,'FIC_','') as fieldName, 
			
			case
				when d.memoValue is not null and ltrim(rtrim(convert(varchar(100),d.memoValue))) != '' then d.memoValue
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
	</cfquery>
	
	<!--- morph the query to a structure --->
	<cfloop query="CEQuery">
		<cfset structInsert(results, CEQuery.fieldname, CEQuery.fieldvalue) />
	</cfloop>

	<cfset setValue(name = "customElement", value = results) />	
	
</cffunction>	
	
</cfcomponent>