<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			RenderService.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am the Render Service. I manage objects that render search results XML
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		12/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Render Service" output="false"
	hint="I am the Render Service. I manage objects that render search results XML">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="RenderService" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="configData" type="struct" required="true" 
		hint="I am the configuration structure. I am requried." />

	<cfset variables.instance.HTML = createObject("component", "html.HTML").init(argumentCollection = arguments) />
	<cfset variables.instance.XSLT = createObject("component", "xslt.XSLT").init(argumentCollection = arguments) />

	<cfreturn this />
</cffunction>



<!--- render --->
<cffunction name="render" returntype="any" access="public" output="false"
    displayname="Render" hint="I render the Google search results to a format determined by configuration."
    description="I render the Google search results to a format determined by configuration.">
    
	<cfargument name="searchEvent" type="component" required="true" 
		hint="I am the search event object. I am requried." />
	
	<cfif arguments.searchEvent.getDefaultReturnFormat() eq "html">
		<cfset variables.instance.HTML.render(arguments.SearchEvent) />
	<cfelseif arguments.searchEvent.getDefaultReturnFormat() eq "xslt">
		<cfset variables.instance.XSLT.render(arguments.SearchEvent) />
	</cfif>
	
	<cfreturn arguments.searchEvent />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
	<cfreturn variables.instance />
</cffunction>
<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>