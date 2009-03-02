<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		MockPageEventcfc
Author:     		John Allen
Email:      		jallen@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@
Purpose:    	I am a Mock Page Event Object used for documentation 
					and developement.
Usage:      
Modification Log:
Name	 Date	 Description
================================================================================
John Allen	 03/08/2008	 Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Mock Page Event Object"  extends="EventCollection"
	hint="I am a Mock Page Event Object used for documentation and developement" output="false">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" access="public" output="false" 
	displayname="Init" hint="I am the pseudo-constructor." 
	description="I am the pseudo-constructor for this CFC.">
	
	<cfargument name="setRequestScopeDefautls" defaut="0"
		hint="I will tell the object to set the nessary request variables that CommonSpot would normaly provide." />

	<!--- 
	Put these here so if you are modifying ViewFramework 
	you can override these if needed. These are the request scope variables 
	that ViewFramework will need for a single request.
	--->
	<cfargument name="pageID" default="1" type="numeric" />
	<cfargument name="pageTitle" default="Mock Page Event" type="string" />
	<cfargument name="dateAdded" default="#now()#" type="date" />
	<cfargument name="lastModifyed" default="#now()#" type="date" />
	<cfargument name="pageType" default="portal" type="string" />
	<cfargument name="siteName" default="Mock Web Site" type="string" />
	<cfargument name="siteURL" default="http://www.mockpageevent.com" type="string" />
	<cfargument name="subSiteID" default="1" type="numeric" />
	<cfargument name="childList" default="2,3,4,5,6" type="string" />
	<cfargument name="subSiteName" default="Mock Subsite Name" type="string" />
	<cfargument name="subsiteURL" default="/mock/sub-site/to/the/max/daddyo" type="string" />
	<cfargument name="webMasterEmail" default="mock@mockemail.com" type="string" />
	<cfargument name="mockPageEvent" default="true" type="Boolean" />
	<cfargument name="pageTypeDefinitionPageTypeKey" default="portal" type="string" />

	<cfset variables.pageType = structNew() />
	<cfset setPageTypeDeinitions(arguments.pageTypeDefinitionPageTypeKey)  />
	
	<!--- CommonSpot request vars --->
	<cfif arguments.setRequestScopeDefautls eq 1>
		<cfset request.page.id = arguments.pageID  />	
		<cfset request.page.Title = arguments.pageTitle />
		<cfset request.page.dateAdded = arguments.dateAdded />
		<cfset request.page.DateContentLastModified = arguments.lastModifyed />
		<cfset request.page.metadata.pageType.pageType = arguments.pageType />
		<cfset request.site.name = arguments.siteName />
		<cfset request.site.url = arguments.siteURL />
		<cfset request.subsite.id = arguments.subSiteID />
		<cfset request.subsite.childlist = arguments.childList />
		<cfset request.subsite.name = arguments.subSiteName  />
		<cfset request.subsite.url = arguments.subsiteURL />
		<cfset request.subsite.webmasteremail = arguments.webMasterEmail />
		<cfset request.mockPageEvent = arguments.mockPageEvent />
	</cfif>
	
	<cfset initilizeEventCollection() />
	<cfset loadBasePageEventData() />
	
	<cfreturn this />
</cffunction>

<!--- getPageID --->
<cffunction name="getPageID" output="false">
	<cfreturn 21 />
</cffunction>

<!--- getPageType --->
<cffunction name="getParentSite" output="false">
	<cfreturn "EEEL" />
</cffunction>

<cffunction name="getCustomElementName" output="false">
	<cfreturn "mock">
</cffunction>

<!--- getSiteName --->
<cffunction name="getSiteName" output="false">
	<cfreturn "time-travel-group" />
</cffunction>

<!--- getPageType --->
<cffunction name="getPageType" output="false">
	<cfreturn "portal" />
</cffunction>

<!--- getPageTypeDefinitions --->
<cffunction name="getPageTypeDefinitions" output="false">

	<cfreturn variables.pageType.getInstance() />
</cffunction>

<!--- setPageTypeDefinitions --->
<cffunction name="setPageTypeDeinitions" output="false">
	<cfargument name="type" />
	<cfset var elementFactory = application.beanFactory.getBean("elementFactory") />
	
	<cfset variables.pageType =  elementFactory.getElement(arguments.type) />
	
	<!--- add a struct to the method array for data service --->
	<cfset methodStruct.method = "getRemoteData">
	<cfset methodStruct.resultName = "RemoteData">
	<cfset arrayAppend(variables.pageType.getInstance().methods, methodStruct)>

</cffunction>

<!--- getSubSiteDefinition --->
<cffunction name="getSubSiteDefinition" output="false">
	<cfset var subsite = structNew() />
	<cfset subsite.name = "eeel">
	<cfreturn subsite />
</cffunction>


<!--- getInstance --->
<cffunction name="getInstance" returntype="any" access="public" output="false"
	displayname="Get Instance" hint="I return the variable scope."
	description="I return the variables scope.">
	
	<cfreturn  variables />
</cffunction>



<!--- initilizeEventCollection --->
<cffunction name="initilizeEventCollection" access="private" output="false"
	displayname="Iinitalize Event Collection" hint="I initialize the EventCollection object."
	description="I initialize the EventCollection object.">
	
	<cfset variables.instance.eventCollection = createObject("component", "EventCollection").init() />
	
	<cfreturn variables.instance.eventCollection />
</cffunction>



<!--- setValue --->
<cffunction name="setValue" access="public" output="false"
	displayname="Add Value" hint="I add a Value to the Event Collection."
	description="I add a Value to the Event Collection.">
	
	<cfargument name="name" hint="I am the name of the value." />
	<cfargument name="value" hint="I am the value. I am required." />
	
	<!--- 
	The EventCollection can accecpt unnamed values if they are
	structures.
	--->
	<cfif isDefined("arguments.name")>
		<cfset variables.instance.eventCollection.setValue(
			name = arguments.name,
			value = arguments.value) />
	<cfelse>
		<cfset variables.instance.eventCollection.setValue(
			value = arguments.value) />
	</cfif>
	
</cffunction>



<!--- getAllValues --->
<cffunction name="getAllValues" returntype="any" access="public" output="false"
	displayname="Get All Values" hint="I return all of EventCollections values."
	description="I return all of EventCollections values as a structure.">
	
	<cfreturn variables.instance.eventCollection.getAllValues() />
</cffunction>



<!--- getValue --->
<cffunction name="getValue" access="public" output="false"
	displayname="Get Value" hint="I return a Value from the Event Collection."
	description="I return a Value from the Event Collection.">
	
	<cfargument name="name" hint="I am the name of the value. I am required." />
	
	<cfreturn variables.instance.eventCollection.getValue(arguments.name) />
</cffunction>



<!--- loadBasePageEventData --->
<cffunction name="loadBasePageEventData" returntype="any" access="private" output="false"
	displayname="Load Base Page Event Data" hint="I load form,url, and custom element data.."
	description="I load the form and url scopes via the Input.cfc data, and query the database for custom element data into the EventCollection.">
		
	<cfargument name="dsn" hint="I am the CommonSpot site datasource.<br />I am required." />
	
	<cfset var pageID = getPageID() />
	<cfset var CEQuery =  0 />
	<cfset var CEData =  structNew() />
	<cfset var results = structNew() />
	<cfset var x = 0 />
	
	<cfset results.MockPageCustomElementName = "WhaaaaHooooo!">

	<cfset setValue(name = "customElement", value = results) />	
	
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>
