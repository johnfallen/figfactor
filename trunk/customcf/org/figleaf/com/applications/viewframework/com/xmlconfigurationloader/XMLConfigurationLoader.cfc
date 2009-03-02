<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			XMLConfigurationLoader.cfc
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I manage configuration data read from XML files.
Usage:      			
Modification Log:
Name 			Date 					Description
================================================================================
John Allen 		17/09/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="XML Configuration Loader" output="false"
	hint="I read and manage configuration data read from XML files.">

<!--- try to get a developers mixen file --->
<cftry>
<cfinclude template="view-framework-list-mixen.cfm">
	<cfcatch></cfcatch>
</cftry>

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="XMLConfigurationLoader" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.
		<br /><br />
		Throws Error if the ConfigListExtension.cfm file can not be found.">	
	
	<cfargument name="BeanFactory" default="#application.BeanFactory#" 
		hint="I am FigFactor's BeanFactory object.<br />I default to 'Application.BeanFactory'." />
	
	<cfset variables.BeanFactory = arguments.BeanFactory />
	<cfset variables.ElementFactory = variables.BeanFactory.getBean("ElementFactory") />
	<cfset variables.ConfigBean = variables.BeanFactory.getBean("ConfigBean") />
	<cfset variables.UDFLibrary = variables.BeanFactory.getBean("udf") />
	<cfset variables.filelocation = "#getDirectoryFromPath(GetCurrentTemplatePath())#/data" />
	<cfset variables.instance = structNew() />
	<cfset variables.instance.ConfiguredLists = structNew() />
	<cfset variables.instance.SubSiteDefinitions = arrayNew(1) />
	<cfset variables.logger = variables.BeanFactory.getBean("logger") />
	
	<!--- set the requried lists needed by Viewframework --->
	<cfset configureRequiredLists() />
	
	<!--- this will be in the mixin file --->
	<cftry>
		<cfset configure(fileLocation = variables.filelocation) />
		<cfcatch>
			<cfset variables.BeanFactory.getBean("logger").setMessage(
				type = "WARN",
				message = "VIEWFRAMEWORK_ERROR: The mixen file can not be found. No extra lists are avaiable to CommonSpot.") />
		</cfcatch>
	</cftry>

	<cfreturn this />
</cffunction>



<!--- configureRequiredLists --->
<cffunction name="configureRequiredLists" returntype="any" access="public" output="false"
	displayname="Configure Required Lists" hint="I configure lists required by ViewFramework."
	description="I configure lists required by ViewFramework.">
	
	<cfset setCustomElements() />
	<cfset setAvaiableSubSites(FileLocation = variables.filelocation) />
	<cfset setAvailableStates(FileLocation = variables.filelocation) />

	<!--- For reverse compatability --->
	<cfset setList(name = "avaiablePageTypes", value = getList("CustomElements")) />
	<cfset setList(name = "pageTypes", value = getList("CustomElements")) />
	<cfset setList(name = "listOfPageTypes", value = getList("CustomElements")) />
	<cfset setList(name = "listOfSubSites", value = getList("subsites")) />
</cffunction>



<!--- setList --->
<cffunction name="setList" access="private" output="false"
	displayname="Add List" hint="I add a list to the struct of lists."
	description="I add a list to the struct of lists as key/value pairs.">
	
	<cfargument name ="name" type="string" required="true" 
		hint="I am the name of the list.<br />I am required." />
	<cfargument name ="value" type="string" required="true" 
		hint="I am the list.<br />I am required." />

	<cfset variables.instance.ConfiguredLists[arguments.name] =  arguments.value />
	
</cffunction>



<!--- getList --->
<cffunction name="getList" returntype="any" access="public" output="false"
	displayname="Get List" hint="I return a list of values."
	description="I return a list of values defined in XML files.">
	
	<cfargument name="name" hint="I am the name of the list.">
	
	<cfset var result = "" />
	
	<cfif structKeyExists(variables.instance.ConfiguredLists, arguments.Name)>
		<cfset result = variables.instance.ConfiguredLists[arguments.name] />
	</cfif>	
	
	<cfreturn result  />
</cffunction>



<!--- getAllLists --->
<cffunction name="getAllLists" returntype="any" access="public" output="false"
	displayname="Get All Lists" hint="I return a struct of all configured lists."
	description="I return a struct of all configured lists.">
	
	<cfreturn variables.instance.ConfiguredLists  />
</cffunction>



<!--- getConfigArray --->
<cffunction name="getConfigArray" returntype="any" access="public" output="false"
	displayname="Get Config Array" hint="I return a structure from configuration files."
	description="I return an array of structures representing XML configuration data.">
	
	<cfargument name="name" type="string" required="true" 
		hint="I am the name of the struct.<br />I am required." />
	
	<cfreturn variables.instance[arguments.name] />
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
	<cfset setList(name="CustomElements", value = customElementList) />

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
	
	<!--- set some instance variables --->
	<cfset variables.instance.SubSiteDefinitions = arrayNew(1) />
	
	<cffile 
		action="read" 
		file="#arguments.FileLocation#/SubSiteDefinitions.xml" 
		variable="fileData" />
	<cfset subSiteXML = XmlParse(fileData) />
	
	<cfloop from="1" to="#arrayLen(subSiteXML.ViewFrameworkSubSiteDefinitions.XMLChildren)#" index="y">
		<cfset arrayAppend(variables.instance.SubSiteDefinitions, subSiteXML.ViewFrameworkSubSiteDefinitions.XMLChildren[Y].XMLAttributes) />
	</cfloop>
	
	<cfloop from="1" to="#arrayLen(variables.instance.SubSiteDefinitions)#" index="x">
		<cfset listOfSubsites = listAppend(listOfSubsites, variables.instance.SubSiteDefinitions[x].name) />
	</cfloop>

	<cfset setList(name = "subsites", value = listOfSubsites) />
	
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
	
	<cfset setList(name = "states", value = States) />

</cffunction>



<!--- configureTODO --->
<cffunction name="configureTODO" returntype="any" access="public" output="false"
	displayname="Configure" hint="I read xml files and manage their data."
	description="I read xml files and set their data into my internal variables scope.">
	
	<cfset var fileLocation = replaceNoCase(GetCurrentTemplatePath(), "XMLConfigurationService.cfc", "", "all") & "" />
	<cfset var fileXML = 0 />
	<cfset var fileData = 0 />
	<cfset var fileQuery = 0 />
	<cfset var structureOfLists = structNew() />
	<cfset var XMLListData = "" />	
	<cfset var listOfNames = 0 />
	<cfset var chidArrayOfListData = "" />
	<cfset var x = 0 />
	<cfset var y = 0 />
		
	<cfdirectory action="list" directory="#fileLocation#" name="fileQuery" />

	<cfloop query="fileQuery">
		
		<!--- parse files if they end with .xml --->
		<cfif fileQuery.name contains ".xml">
			
			<!--- read into a XML object --->
			<cffile 
				action="read" 
				file="#fileLocation#/#fileQuery.name#" 
				variable="fileData" />
			
			<cfset fileXML = XmlParse(fileData) />
			
			<!--- if the XML has the "lists" attribute --->
 			<cfif isDefined("fileXML.XMLRoot.XmlAttributes.lists")>
				
				<!--- get the list attribute  --->
				<cfset listOfNames = fileXML.XMLRoot.XmlAttributes.lists />

				<cfloop list="#listOfNames#" index="x">
					
					<cfset chidArrayOfListData = fileXML.XMLRoot.XMLChildren />
					
						<!--- loop over the XML attributes to see if there is a list value we need --->
						<cfloop from="1" to="#arrayLen(chidArrayOfListData)#" index="y">
							<cfif structKeyExists(chidArrayOfListData[y].XmlAttributes, x)>
								<cfset XMLListData = listAppend(XMLListData, chidArrayOfListData[y].XmlAttributes[x]) />
							</cfif>
						</cfloop>
						
						<cfif not structKeyExists(structureOfLists, x)>
							<cfset structureOfLists[x] = XMLListData />
						<cfelse>
							<cfthrow detail="Oops! '#x#' is already a value in the list structure. Change the attribute name in the '#fileQuery.name#'">
						</cfif>

						<!--- make the list null again --->
						<cfset XMLListData = "">
				</cfloop>
			</cfif>
		</cfif>
	</cfloop>
	
	<cfdump var="#structureOfLists#">
	<cfdump var="#fileQuery#">
	<cfabort />
	
	<cfreturn  />
</cffunction>

<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>