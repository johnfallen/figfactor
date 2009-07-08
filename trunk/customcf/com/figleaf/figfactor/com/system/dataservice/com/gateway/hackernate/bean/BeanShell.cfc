<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		BeanShell.cfc
Author:     		John Allen
Email:      		jallen@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@

Purpose:    	I am an empty Bean Shell to inject data into.
					A encapsulated scope.

Usage:      		

Modification Log:
Name 			Date 					Description

================================================================================
John Allen 		25/09/2008			Created

------------------------------------------------------------------------------->
<cfcomponent displayname="Bean Shell" output="false"
	hint="I am an empty Bean Shell to inject data into.">

<cfset variables.instance = structNew() />

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="BeanShell" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="properties" hint="I can be a ColdFusion Query or Structure." />
	
	<cfset var x = 0 />

	<cfif isStruct(arguments.properties)>
		<cfloop collection="#arguments.properties#" item="x">
			<cfset set(
				name = x,
				value = arguments.properties[x]) />
		</cfloop>
	</cfif>

	<cfif isQuery(arguments.properties) and arguments.properties.recordcount>
		<cfloop query="arguments.properties">
			<cfset set(
				name = arguments.properties.fieldname, 
				value = arguments.properties.fieldValue) />
		</cfloop>
	<cfelse>
		<cfthrow message="Oops! You have tried to add a query with more than one row to the BeanShell. Only accecpt single row queries to convert to a bean." />
	</cfif>

	<cfreturn this />
</cffunction>



<!--- get --->
<cffunction name="get" output="false" access="public" displayname="Get" hint="I return a value by name." 
	description="I return a value by name.<br />I return an empty string if not found.<br />I do this to conform to ColdFusions nulls as [empty string].">
	
	<cfargument name="name" default="" 
		hint="I am the name of the property.<br />I default to an empty string." />
	
	<cfset var complyWithColdFusionsNullConceptOfEmptyStringsFailString___WhatIsNullWhatIsNull = "" />

	<cfif structKeyExists(variables.instance, arguments.name)>
		<cfreturn variables.instance[arguments.name] />
	<cfelse>
		<cfreturn complyWithColdFusionsNullConceptOfEmptyStringsFailString___WhatIsNullWhatIsNull />
	</cfif>
</cffunction>



<!--- getAll --->
<cffunction name="getAll" returntype="any" access="public" output="false"
	displayname="Get All" hint="I return all of my properties."
	Description="I return all of my properties as a structure.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!---set --->
<cffunction name="set" output="false" access="private"
	hint="I set set a property by name.">

	<cfargument name="name" />	
	<cfargument name="value" />
	
	<cfset variables.instance[arguments.name] = arguments.value />
</cffunction>
</cfcomponent>