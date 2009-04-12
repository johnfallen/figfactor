<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			ULRDirector.cfc
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I manage URL redirects for CommonSpot via several
						configurable strategies.
Usage:      		
Modification Log:
Name 			Date 					Description
================================================================================
John Allen 		29/09/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="URLDirector" output="false"
	hint="I manage URL redirects in several ways.">

<!--- *********** Constructor ************ --->

<cfset variables.configuredRedirects = 0 />
<cfset variables.fileLocation = "" />
<cfset variables.ConfigBean = 0 />

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="URLDirector" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfset variables.fileLocation = replaceNoCase(GetCurrentTemplatePath(), "URLDirector.cfc", "", "all") & "/xmldata" />
	<cfset variables.ConfigBean = arguments.ConfigBean />
	
	<cfreturn this />
</cffunction>



<!--- configure --->
<cffunction name="configure" returntype="any" access="public" output="false"
	displayname="Configure" hint="I configure the URLDirector."
	description="I read XML files and set them into my variables scope.">
	
	<!--- TODO: implement init() method in Director.cfc --->
	<cfset readConfiguredRedirectXMLFile() />
	<cfset getAllRedirects() />
	
	<cfreturn  />
</cffunction>



<!--- addRedirect --->
<cffunction name="addRedirect" returntype="any" access="public" output="false"
	displayname="Add Redirect" hint="I add a old link and its new target link."
	description="I add a old link and its new target link to my internal XML storage.">
	
	<cfargument name="oldURL" type="string" required="true" hint="I am the old URL.<br />I am required." />
	<cfargument name="newURL" type="string" required="true" hint="I am the new URL.<br />I am required." />
	
	<!--- TODO: implement addRedirect() method in Director.cfc --->
	
	<cfset writeRedirect()>
	
</cffunction>



<!--- getRedirect --->
<cffunction name="getRedirect" returntype="any" access="public" output="false"
	displayname="Get Redirect" hint="I return the new URL for the old URL."
	description="I look up and return the URL for the old URL I am given.">
	
	<cfargument name="oldURL" type="string" required="true" hint="I am the old URL.<br />I am required." />
	
	<!--- TODO: implemet getRedirect method in Director.cfc --->
	
	<cfreturn  />
</cffunction>



<!--- getAllRedirects --->
<cffunction name="getAllRedirects" returntype="any" access="public" output="false"
	displayname="Get All Redirects" hint="I return all of my stored redirects as an array of structures."
	description="I return all of my stored redirects as an array of structures.">
	
	<!--- TODO: implement getAllRedirects() method in Director.cfc --->
	
	<cfreturn variables.configuredRedirects />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- readConfiguredRedirectXMLFile --->
<cffunction name="readConfiguredRedirectXMLFile" returntype="any" access="private" output="false"
	displayname="Read Configured Redirect XML File" hint="I read and prepare the XML redirect file."
	description="I read and prepare the XML redirect file.">
	
	<cfargument name="fileLocation" default="#variables.filelocation#" hint="I am the location fo the configuration XML file." />
	
	<!--- TODO: implement readConfiguredRedirectXMLFile() method in Director.cfc --->
	
	<cfset var redirectArray = arrayNew(1) />
	<cfset var redirect = structNew() />
	
	<cfset variables.configuredRedirects = redirectArray />
	<cfreturn redirectArray />
</cffunction>



<!--- writeRedirect --->
<cffunction name="writeRedirect" returntype="any" access="private" output="false"
	displayname="Write Redirect" hint="I write a redirect to my local storage."
	description="I write a redirect to my local storage.">
	
	<cfargument name="oldURL" type="string" required="true" hint="I am the old URL.<br />I am required." />
	<cfargument name="newURL" type="string" required="true" hint="I am the new URL.<br />I am required." />
	
	<!--- TODO: implement writeRedirect() method in Director.cfc --->
	
</cffunction>
</cfcomponent>