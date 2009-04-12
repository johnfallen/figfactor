<!--- Document Information ----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			EventService.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I execute actions and manage access for a search event
Modification Log:
Name 			Date 								Description
===============================================================================
John Allen 		11/03/2009			Created
------------------------------------------------------------------------------>
<cfcomponent displayname="Search Service" output="false"
	hint="I execute actions and manage access for the search event">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="SearchService" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
		
	<cfargument name="configData" type="struct" required="true" 
		hint="I am the configuration structure. I am requried." />
	<cfargument name="Input" type="component" required="true" 
		hint="I am the Input utility component. I am requried." />
	
	<cfset variables.Input = arguments.Input />
	
	<cfset setConfigData(arguments.configData) />
	
	<cfset variables.RenderService = 
		createObject("component", "renderservice.RenderService").init(getConfigData()) />
	
	<cfreturn this />
</cffunction>



<!--- getSearch --->
<cffunction name="getSearch" returntype="component" access="public" output="false"
    displayname="Get Search" hint="I return a Search Event object."
    description="I return a  Search Event object. I manage the persisteance of the Event object for the request life cycle.">
    
	<cfargument name="input" type="struct" required="false" 
		hint="I am the FORM and URL input variables." />
	
	<cfif not isDefined("request.GoogleSearchEvent")>
	
		<cfset request.googleSearchEvent = createObject("component", "SearchEvent").init(
			configData	= getConfigData(),
			input = variables.Input.load()) />

		<cfset variables.RenderService.render(request.googleSearchEvent) />
	</cfif>
	
    <cfreturn request.googleSearchEvent />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
<!--- ConfigData --->
<cffunction name="setConfigData" access="public" output="false" returntype="void">
	<cfargument name="ConfigData" type="struct" required="true"/>
	<cfset variables.instance.ConfigData = arguments.ConfigData />
</cffunction>
<cffunction name="getConfigData" access="public" output="false" returntype="struct">
	<cfreturn variables.instance.ConfigData />
</cffunction>
</cfcomponent>