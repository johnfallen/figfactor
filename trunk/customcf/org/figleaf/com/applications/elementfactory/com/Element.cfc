<!--- Document Information -----------------------------------------------------
Build:      				@@@revision-number@@@
Title:      				Element.cfc
Author:     				John Allen
Email:      				jallen@figleaf.com
Company:    			@@@company-name@@@
Website:    			@@@web-site@@@
Purpose:    			I am a Custom Element object.
							I define what a custom element is.
Usage:      		
Modification Log:
Name 			Date 					Description
================================================================================
John Allen 		11/10/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Element" output="false"
	hint="I am a Custom Element object.">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Element" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
		
	<cfargument name="xml" type="XML" required="false"
		hint="I am the XML object of my data. If I am valid XML then I will inialize with these values, else I will return an empty object." />
	<cfargument name="name" type="string" required="false" defalut=""
		hint="I over-ride the name if passed a string." />
	
	<cfset var x = 0 />
	
	<cfset variables.instance.name = "" />
	<cfset variables.instance.CSSClass = "" />
	<cfset variables.instance.useDataService = false />
	<cfset variables.instance.useCache = false />
	<cfset variables.instance.methods = arrayNew(1) />
	
	<cfif isDefined("arguments.xml") and isXML(arguments.xml)>
		<cfset setName(arguments.xml.XmlAttributes.name) />
		<cfset setCSSClass(arguments.xml.XmlAttributes.CSSClass) />
		<cfset setUseDataService(arguments.xml.XmlAttributes.useDataService) />
		<cfset setUseCache(arguments.xml.XmlAttributes.useCache) />
		
		<cfloop from="1" to="#arrayLen(arguments.xml.XMLChildren)#" index="x">
			<cfset setMethod(data = arguments.xml.XMLChildren[x].XmlAttributes) />
		</cfloop>
	<cfelse>
		<cfset setName(arguments.name) />
	</cfif>
	
	<cfreturn this />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="any" access="public" output="false"
	displayname="Get Instace" hint="I return a structure containing my instance data."
	description="I return a structure containing my instance data.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- getMethods --->
<cffunction name="getMethods" output="false" access="public"
	hint="I return an array of method names that fire against the Gateway in DataService.">
	
	<cfreturn variables.instance.methodArray />
</cffunction>



<!--- setMethod --->
<cffunction name="setMethod" output="false" access="public"
	hint="I set a Method to my internal array of methods.">

	<cfargument name="data" type="any" required="true" />
	
	<cfset var methodAndResult = structNew() />

	<cftry>
		<cfset methodAndResult.method = arguments.data.name />
		<cfset methodAndResult.resultName = arguments.data.resultName />		
		<cfset arrayAppend(variables.instance.methods, methodAndResult) />
		<cfcatch>
			<cfthrow message="The customelement.xml file appears to be invalid! are both the 'name'  and 'resultname' defined in the '#ucase(getName())#' entry?" >
		</cfcatch>
	</cftry>
</cffunction>



<!--- Name --->
<cffunction name="setName" output="false" access="private"
	hint="I set the Name property.">
	<cfargument name="Name" type="string" />
	<cfset variables.instance.Name = arguments.Name />
</cffunction>
<cffunction name="getName" output="false" access="public"
	hint="I return the Name property.">
	<cfreturn variables.instance.Name />
</cffunction>
<!--- CSSClass --->
<cffunction name="setCSSClass" output="false" access="private"
	hint="I set the CSSClass property.">
	<cfargument name="CSSClass" type="string" />
	<cfset variables.instance.CSSClass = arguments.CSSClass />
</cffunction>
<cffunction name="getCSSClass" output="false" access="public"
	hint="I return the CSSClass property.">
	<cfreturn variables.instance.CSSClass />
</cffunction>
<!--- UseDataService --->
<cffunction name="setUseDataService" output="false" access="private"
	hint="I set the UseDataService property.">
	<cfargument name="UseDataService" type="boolean" />
	<cfset variables.instance.UseDataService = arguments.UseDataService />
</cffunction>
<cffunction name="getUseDataService" output="false" access="public"
	hint="I return the UseDataService property.">
	<cfreturn variables.instance.UseDataService />
</cffunction>
<!--- UseCache --->
<cffunction name="setUseCache" output="false" access="private"
	hint="I set the UseCache property.">
	<cfargument name="UseCache" type="boolean" />
	<cfset variables.instance.UseCache = arguments.UseCache />
</cffunction>
<cffunction name="getUseCache" output="false" access="public"
	hint="I return the UseCache property.">
	<cfreturn variables.instance.UseCache />
</cffunction>
<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>