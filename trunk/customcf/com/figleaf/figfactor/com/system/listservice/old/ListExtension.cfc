<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			ListExtension.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I manage xml lists provided by the developer
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		27/02/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="List Extension" output="false"
	hint="I manage xml lists provided by the developer" extends="ListSercvice">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="ListExtension" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfreturn this />
</cffunction>



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
	
	<cfset super.setList(name = "Campus", value = Campus) />

</cffunction>

<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>