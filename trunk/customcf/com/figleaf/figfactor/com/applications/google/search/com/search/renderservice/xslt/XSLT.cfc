<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			XSLT.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I apply XSLT to a google search result
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		12/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="XSLT" output="false"
	hint="I apply XSLT to a google search result">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="XSLT" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfreturn this />
</cffunction>



<!--- render --->
<cffunction name="render" returntype="any" access="public" output="false"
    displayname="Render" hint="I render the Google XML as HTML."
    description="I render the Google XML as HTML.">
	
	<cfargument name="searchEvent" type="component" required="true" 
		hint="I am the Search Event object . I am required" />
    
	<cfset var xslt = "" />

	<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#db_frontend.xslt" variable="xslt" />

	<cfset arguments.searchEvent.setResults( 
		xmlTransform( arguments.searchEvent.GetSearchResultXML(), xslt) )>

    <cfreturn arguments.searchEvent />
</cffunction>
<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>