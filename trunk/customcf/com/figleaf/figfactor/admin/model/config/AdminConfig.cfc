<!--- Document Information -----------------------------------------------------
Build:						@@@revision-number@@@
Title:						AdminConfig.cfc 
Author:					John Allen
Email:						jallen@figleaf.com
Company:					@@@company-name@@@
Website:					@@@web-site@@@
Purpose:					I am the Administration Configruation bean for FigFactor
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		31/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Admin Config" output="false"
	hint="I am the Administration Configruation bean for FigFactor">

<!--- ****************************** Public ******************************* --->

<!--- init --->
<cffunction name="init" returntype="AdminConfig" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="pathToCommonspot" />
	
	<cfset var x = 0 />
	
	<cfset variables.instance = structNew() />
	<cfloop collection="#arguments#" item="x">
		<cfset variables.instance[x] = arguments[x] />
	</cfloop>
	

	<cfreturn this />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	<cfargument name="duplicate" type="boolean" required="false" 
		hint="Should I return a duplicate of my data? I default to false, a shalow copy. I am requried." />
	
	<cfif arguments.duplicate eq true>
		<cfreturn duplicate(variables.instance) />
	<cfelse>
		<cfreturn variables.instance />
	</cfif>
</cffunction>
<!--- ****************************** Package ******************************* --->
<!--- ****************************** Private ******************************* --->
<!--- ************************* Accors/Mutators ************************** --->
</cfcomponent>