<!--- Document Information -----------------------------------------------------
Build:						@@@revision-number@@@
Title:						JSM.cfc 
Author:					John Allen
Email:						jallen@figleaf.com
Company:					@@@company-name@@@
Website:					@@@web-site@@@
Purpose:					I model a JSM message
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		03/04/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Jave Simple Message" output="false"
	hint="I model a Java Simple Message (JSM)">

<!--- ****************************** Public ******************************* --->

<!--- init --->
<cffunction name="init" returntype="JSM" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfset variables.instance = structNew() />

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