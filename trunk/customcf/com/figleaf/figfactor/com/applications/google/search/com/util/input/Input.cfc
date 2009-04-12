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
		hint="Should I put presidence on the FORM or URL scope.<br />I default to 'FORM'." />

	<cfset variables.Precedence = arguments.presidence />

	<cfreturn this />
</cffunction>



<!--- getAllValues --->
<cffunction name="getAllValues" returntype="any" access="public" output="false"
	displayname="Get All Values" hint="I return all of the FORM and URL variables."
	description="I return all of the FORM and URL variables.">
	
	<cfreturn load() />
</cffunction>



<!--- getValue --->
<cffunction name="getValue" access="public" output="false"
	displayname="Get Value" hint="I return a value from the FROM or URL scope by name."
	description="I return a value from the FORM or URL scope by name. The form scope has presidence over the URL.">
	
	<cfargument name="name" type="string" hint="I am the name of the FORM or URL value.<br />I am requried." />
	
	<cfset var value = "" />
	
	<cfif structKeyExists(load(), arguments.name)>
		<cfset value = request._googleSearchInputContainer[arguments.name] />
	</cfif>
	
	<cfreturn value />
</cffunction>



<!--- load --->
<cffunction name="load" access="public" output="false"
	displayname="Load" hint="I merge the form and URL scopes."
	description="I merge the form and URL scopes into a single structure set to the reqest scope.">
	
	<cfargument name="Precedence" default="#variables.Precedence#" type="string"
		hint="I am the presidence to load FORM or URL variables. I default to a configured variable" />
	
	<cfset var field = "" />
	
	<cfif not structKeyExists(request, "_googleSearchInputContainer")>
		
		<!--- kill HTML in the form scope --->
		<cfloop collection="#form#" item="field">
			<cfif isSimpleValue(form[field])>
				<cfset form[field] = trim(ReReplaceNoCase(form[field], "<[^>]*>", "", "ALL")) />
			</cfif>
		</cfloop>
		
		<!--- make the request scoped container struct --->
		<cfset request._googleSearchInputContainer = structNew() />
		
		<cfif arguments.Precedence eq "URL">
			<cfset structAppend(request._googleSearchInputContainer, form) />
			<cfset structAppend(request._googleSearchInputContainer, URL) />
		<cfelse>
			<cfset structAppend(request._googleSearchInputContainer, URL) />
			<cfset structAppend(request._googleSearchInputContainer, form) />
		</cfif>
	</cfif>
	
	<cfreturn request._googleSearchInputContainer />
</cffunction>

<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>