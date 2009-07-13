<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			ListService.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I manage lists used by the framework
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		28/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="List Service" output="false"
	hint="I manage lists used by the framework">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="ListService" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="MapCollection" type="component" required="true" 
		hint="I am the MapCollection component. I am requried." />
	<cfargument name="ElementFactory" type="component" required="true" 
		hint="I am the MapCollection component. I am requried." />
	<cfargument name="Config" type="component" required="true" 
		hint="I am the Config component. I am requried." />
	
	<cfset variables.instance = structNew() />
	<cfset variables.collection = arguments.MapCollection />
	<cfset variables.ElementFactory = arguments.ElementFactory />
	<cfset variables.Config  = arguments.Config />
	
	<cfset variables.filelocation = "#getDirectoryFromPath(GetCurrentTemplatePath())#/data" />
	
	<!--- set the requried lists needed by Viewframework --->
	<cfset configureRequiredLists() />

	<cfreturn this />
</cffunction>



<!--- setList --->
<cffunction name="setList" returntype="void" access="public" output="false"	
	displayname="Set List" hint="I set a list to my collection of lists. THROWS ERROR if a list with the same name already exists."
	description="I set a list to my collection of lists. THROWS ERROR if a list with the same name already exists.">
	
	<cfargument name="name" type="string" required="true" 
		hint="I am the name of the list. I am requried." />
	<cfargument name="list" type="string" required="true" 
		hint="I am the list. I am requried." />
    <cfargument name="overwrite" type="boolean" required="false" default="false" 
		hint="Should I overwrite the current list by name? I default to 'false'." />
	
	<cfif not variables.collection.exists(arguments.name) or arguments.overwrite eq true>
		<cfset variables.collection.setValue(name = arguments.name, value = arguments.list) />
	<cfelse>
		<cfthrow message="A list already exists in the collection with the same name. Please chose a seperate name." />
	</cfif>
	
</cffunction>



<!--- getList --->
<cffunction name="getList" returntype="string" access="public" output="false"	
	displayname="Get List" hint="I return a list by name."
	description="I return a list by name. I will return an empty string if not found.">

	<cfargument name="name" type="string" required="true" 
		hint="I am the name of the list. I am requried." />
	
	<cfreturn variables.collection.getValue(argumentCollection = arguments) />
</cffunction>



<!--- getAllLists --->
<cffunction name="getAllLists" returntype="struct" access="public" output="false"
	displayname="Get All Lists" hint="I return a struct of all configured lists."
	description="I return a struct of all configured lists.">
	
	<cfreturn variables.collection.getAll()  />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	<cfargument name="duplicate" type="boolean" required="false" default="false" 
		hint="Should I return a duplicate of my data? I default to false, a shalow copy. I am requried." />
	
	<cfif arguments.duplicate eq true>
		<cfreturn duplicate(variables.instance) />
	<cfelse>
		<cfreturn variables.instance />
	</cfif>
</cffunction>



<cffunction name="removeList" returntype="boolean" access="public" output="false"
	displayname="Remove List" hint="I remove a list from my collection"
	description="I remove a list by name from my collection of strored lists.">
	<cfargument name="name" type="string" required="false" default=""
		hint="I am the name of the list to remove from my collection. I default to an empty string" />
	
	<cfset result = true>
	<cftry>	
		<cfset variables.collection.removeValue(arguments.name) />
		<cfcatch>
			<cfset result = false />
		</cfcatch>
	</cftry>	

	<cfreturn result />
</cffunction>


<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- configureRequiredLists --->
<cffunction name="configureRequiredLists" returntype="any" access="private" output="false"
	displayname="Configure Required Lists" hint="I configure lists required by the framework and CommonSpot."
	description="I configure lists required by the framework and CommonSpot.">
	
	<cfset setCustomElements() />
	<cfset setAvaiableSubSites(FileLocation = variables.filelocation) />
	<cfset setAvailableStates(FileLocation = variables.filelocation) />

	<!--- For reverse compatability --->
	<cfset setList(name = "avaiablePageTypes", list = getList("CustomElements")) />
	<cfset setList(name = "pageTypes", list = getList("CustomElements")) />
	<cfset setList(name = "listOfPageTypes", list = getList("CustomElements")) />
	<cfset setList(name = "listOfSubSites", list = getList("subsites")) />
</cffunction>



<!--- setCustomElements --->
<cffunction name="setCustomElements" access="private"  output="false"
	displayname="Set Custom Elements" hint="I set a list of configured custom elements.<br />Returntype:void" 
	description="I use the ElementFactory to create a comma delimitated list of custom elements.">
	
	<cfset var x = 0 />
	<cfset var customElementList = "" />

	<cfloop collection="#variables.ElementFactory.getAll()#" item="x">
		<cfset customElementList = listAppend(customElementList, x)>
	</cfloop>
	<cfset customElementList = listSort(customElementList, "textNoCase", "asc", ",")>
	
	
	<cfset setList(name="CustomElements", list = customElementList) />

</cffunction>



<!--- setAvaiableSubSites --->
<cffunction name="setAvaiableSubSites" access="private"  output="false"
	displayname="Set Available Sub-Sites" hint="I set a lits of Sub Sites I know about to the variabes scope." 
	description="I take the ViewFrameworkPageTypeDefinitions.xml data an set a comma deliminated list of Page Types.">
	
	<cfargument name="FileLocation" type="string" required="true" 
		hint="I am the path to configuration files.<br />I am required." />

	<cfset var fileData = "" />
	<cfset var subSiteXML = 0 />
	<cfset var x = 0 />
	<cfset var y = 0 />
	<cfset var listOfSubsites = "" />
	<cfset var subSiteDefinitions = Config.getSubSiteDefinitions() />

	<cfloop from="1" to="#arrayLen(subSiteDefinitions)#" index="x">
		<cfset listOfSubsites = listAppend(listOfSubsites, subSiteDefinitions[x].name) />
	</cfloop>

	<cfset setList(name = "subsites", list = listOfSubsites) />

</cffunction>



<!--- setAvailableStates --->
<cffunction name="setAvailableStates" access="private"  output="false" 
	displayname="Set Available Campus" hint="I set a list of States to my variables scope." 
	description="I take the ViewFrameworkCampusDefinitions.xml data an set a comma delimitated list of Campuses.">
	
	<cfargument name="FileLocation" type="string" required="true" 
		hint="I am the path to configuration files.<br />I am required." />

	<cfset var fileData = "" />
	<cfset var _stateXML = 0 />
	<cfset var x = 0 />
	<cfset var States = "" />
	
	<cffile 
		action="read" 
		file="#arguments.FileLocation#/States.xml" 
		variable="fileData" />
	<cfset _stateXML = XmlParse(fileData) />
	
	<cfloop from="1" to="#arrayLen(_stateXML.ViewFrameworkStates.XMLChildren)#" index="x">
		<cfset States = listAppend(States, 
			_stateXML.ViewFrameworkStates.XMLChildren[x].XMLAttributes.displayName) />
	</cfloop>

	<cfset setList(name = "states", list = States) />

</cffunction>
</cfcomponent>