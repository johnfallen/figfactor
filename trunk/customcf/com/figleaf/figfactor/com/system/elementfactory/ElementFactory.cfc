<!--- Document Information -----------------------------------------------------
Build:      				@@@revision-number@@@
Title:      				ElementFactory.cfc
Author:     				John Allen
Email:      				jallen@figleaf.com
Company:    			@@@company-name@@@
Website:    			@@@web-site@@@
Purpose:    			I am the manager for Custom Element objects.

							FigFactor needs a common contract of what a CommonSpots
							custom element is.

Usage:      		
Modification Log:
Name 			Date 					Description
================================================================================
John Allen 		11/10/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Element Factory" output="false"
	hint="I am the manager for Custom Element objects.">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="ElementFactory" access="public" output="false" 
	displayname="Init" hint="I am the constructor." description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="Logger" />
	<cfargument name="Config" />
	<cfargument name="MapCollection" />

	<cfset variables.instance = structNew() />

	<cfset variables.logger = arguments.Logger />
	<cfset variables.config = arguments.config />
	<cfset variables.instance.elementCollection = arguments.MapCollection />

	<cfset variables.DATANOTFOUND = variables.config.getConstants().DATANOTFOUND />

	<!--- internal --->
	<cfset variables.instance.filelocation = 
		"#getDirectoryFromPath(GetCurrentTemplatePath())#config/customelements.xml" />

	<!--- load the configured xml data --->
	<cfset load() />

	<cfreturn this />
</cffunction>



<!--- getAll --->
<cffunction name="getAll" returntype="any" access="public" output="false"
	displayname="Get All" hint="I return an array of configured custom element objects."
	description="I return an array of configured custom element objects">
	
	<cfreturn variables.instance.elementCollection.getAll() />
</cffunction>



<!--- getElement --->
<cffunction name="getElement" returntype="any" access="public" output="false"
	displayname="Get Element" hint="I return a Custom Element object." 
	description="I return a custom element object by name or an empty one named the CONSTANT: dataNotFound.">

	<cfargument name="name" default=""	hint="I am the name of the element.<br />I default to an empty string." />
	
	<!---  We will always return something for any application in the framework --->
	<cfif not IsSimpleValue(variables.instance.elementCollection.getValue(arguments.name))>
		<cfreturn variables.instance.elementCollection.getValue(arguments.name) />
	<cfelse>
		<cfset variables.logger.setMessage(
			type = "WARN",
			message = "ELEMENT NOT FOUND!! The Element requested element name: '#arguments.name#'") />
		<cfreturn createObject("component", "com.Element").init(name = variables.DATANOTFOUND) />
	</cfif>
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="any" access="public" output="false"
	displayname="Get Instance" hint="I return my instance data."
	description="I return a structure with all the data that makes this particular instace of this CFC.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- load --->
<cffunction name="load" access="public" output="false"
	displayname="Load" hint="I load the configured custom elements."
	description="I create and set the configured custom elements by reading an XML file.">
	
	<cfargument name="path" default="#variables.instance.fileLocation#"
		hint="I am the path to the configuration file.<br />I default to a instance variable.">

	<cfset var fileXML = 0 />
	<cfset var ceXML = 0 />
	<cfset var x = 0 />
	
	<!--- 
	Read from disk, seach to the customelements array, 
	loop and pass the element node so the element
	can be created and set to the element collection.
	--->
	<cffile action="read" file="#arguments.path#" variable="fileXML" />
	<cfset ceXML = XmlSearch(fileXML, "/definitions/customelements/customelement") />
	<cfloop from="1" to="#arrayLen(ceXML)#" index="x">
		<cfset setElement(ceXML[x]) />
	</cfloop>
	
</cffunction>



<!--- setElement --->
<cffunction name="setElement" access="public" output="false"
	displayname="Set Element" hint="I create and set an element."
	description="I create and set an element object to the instance.elementCollection.">

	<cfargument name="xml" type="XML" required="true"
		hint="I am the XML of the custom element." />

	<cfset var newElement = createObject("component", "com.Element").init(xml = arguments.xml) />
	<cfset variables.instance.elementCollection.setValue(name = newElement.getName(), value = newElement) />
	<cfset variables.logger.setMessage(message = "ELEMENT CREATED: Name - #newElement.getName()#") />

</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>