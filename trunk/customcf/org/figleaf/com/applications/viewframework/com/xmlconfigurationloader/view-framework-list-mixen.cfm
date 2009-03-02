<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		ViewFrameworkListExtension.cfc
Author:     		John Allen
Email:      		jallen@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@
Purpose:    	I extend the list loaing of ViewFrameowork
Usage:      		
Modification Log:
Name 			Date 					Description
================================================================================
John Allen 		12/10/2008			Created
------------------------------------------------------------------------------->


<!---  
This method is requried! It is called in the init() after ViewFrameworks required
lists are set.
--->
<!--- configure --->
<cffunction name="configure" access="public" output="false"
	displayname="Configure" hint="I read xml files and manage their data."
	description="I read xml files and set their data into my internal variables scope.">
	
	<cfargument name="fileLocation" required="true" type="string" 
		hint="I am the path to the XML configuration files.<br />I am required." />
	
	<cfset this.setAvaiableCampuses(FileLocation = arguments.FileLocation) />

</cffunction>



<!--- setAvaiableCampuses --->
<cffunction name="setAvaiableCampuses" returntype="any" access="public" output="false"
	displayname="Set Avaiable Campuses" hint="I set a list of campuses."
	description="I read xml and set a list of campuses.">

	<cfargument name="FileLocation" type="string" required="true" 
		hint="I am the path to configuration files.<br />I am required." />

	<cfset var fileData = "" />
	<cfset var _campusXML = 0 />
	<cfset var x = 0 />
	<cfset var Campus = "" />
	
	<cffile 
		action="read" 
		file="#arguments.FileLocation#/CampusDefinitions.xml" 
		variable="fileData" />
	<cfset _campusXML = XmlParse(fileData) />
	
	<cfloop from="1" to="#arrayLen(_campusXML.ViewFrameworkCampusDefinitions.XMLChildren)#" index="x">
		<cfset Campus = listAppend(Campus, 
			_campusXML.ViewFrameworkCampusDefinitions.XMLChildren[x].XMLAttributes.displayName) />
	</cfloop>
	
	<cfset setList(name = "Campus", value = Campus) />

</cffunction>