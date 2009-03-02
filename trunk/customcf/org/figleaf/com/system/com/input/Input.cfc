<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		Input.cfc
Author:     		John Allen
Email:      		jallen@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@
Purpose:    	I am a scope that merges the FORM and URL scopes.
Usage:      		getValue(
						name: string, the name of the value
					)

Modification Log:
Name 			Date 					Description
================================================================================
John Allen 		04/09/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Input" output="false"
	hint="I am a scope that merges the FORM and URL scopes.">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Input" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="presidence" default="FORM" 
		hint="I am the Fig Leaf System SystemFactory object.<br />I default to 'form'." />

	<cfset variables.Precedence = arguments.presidence />

	<cfreturn this />
</cffunction>



<!--- getAllValues --->
<cffunction name="getAllValues" returntype="any" access="public" output="false"
	displayname="Get All Values" hint="I return all of the FORM and URL variables."
	description="I return all of the FORM and URL variables.">
	
	<!--- always load, don''t know if they added any thing. Its pretty cheap. --->
	<cfreturn load() />
</cffunction>



<!--- getValue --->
<cffunction name="getValue" access="public" output="false"
	displayname="Get Value" hint="I return a value from the FROM or URL scope by name."
	description="I return a value from the FORM or URL scope by name. The form scope has presidence over the URL.">
	
	<cfargument name="name" hint="I am the name of the FORM or URL value.<br />I am requried." />
	
	<!--- always load, don't know if they added any thing. Its pretty cheap. --->
	<cfreturn structFind(load(), arguments.name) />
</cffunction>



<!--- load --->
<cffunction name="load" access="public" output="false"
	displayname="Load" hint="I merge the form and URL scopes."
	description="I merge the form and URL scopes into a single structure set to the reqest scope.">
	
	<cfargument name="Precedence" default="#variables.Precedence#" hint="I am the presidence to load FORM or URL variables." />
	
	<cfset request._figFactorInputContainer = structNew() />

	<cfif arguments.Precedence eq "URL">
		<cfset structAppend(request._figFactorInputContainer, form) />
		<cfset structAppend(request._figFactorInputContainer, URL) />
	<cfelse>
		<cfset structAppend(request._figFactorInputContainer, URL) />
		<cfset structAppend(request._figFactorInputContainer, form) />
	</cfif>

	<cfreturn request._figFactorInputContainer />
</cffunction>

<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>