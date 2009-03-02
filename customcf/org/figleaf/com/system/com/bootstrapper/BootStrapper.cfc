<!--- Document Information ----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			BootStrapper.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    			@@@company-name@@@
Website:    			@@@web-site@@@
Purpose:    			I am the FigFactor boot strapper. I copy files various files
						from the 'site' directory to the destination directories.
Modification Log:
Name 			Date 								Description
===============================================================================
John Allen 		02/02/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="BootStrapper" output="false"
	hint="I am the FigFactor boot strapper.  copy files various files from the 'site' directory to their destination directories.">

<!--- developer helper, set to false and files will not be copied but the CFC still works  --->
<cfset variables.DO_FILE_COPY = true />

<!--- regex up 7 directories. This code sets the context for the entire framework. --->
<cfset variables.THE_PATH = 
	GetDirectoryFromPath(
		GetCurrentTemplatePath()
		).ReplaceFirst(
		"([^\\\/]+[\\\/]){7}$", ""
	) />

<!--- the primary map objects defined in the XML --->
<cfset variables.TEMPLATE_NAME = "templates" />
<cfset variables.UI_NAME = "ui" />
<cfset variables.RENDER_NAME = "renderhandlers">
<cfset variables.ROOT_NAME = "root" />
<cfset variables.CONTEXT_NAME = "context" />

<!--- the names of Commonspot files that are deployed to the root level --->
<cfset variables.CUSTOM_APPLICAION_CFM = "custom-application.cfm" />
<cfset variables.CUSTOM_AUTHENTICATION_CFM = "custom-authentication.cfm" />
<cfset variables.POST_APPROVE_CFM = "post-approve.cfm">
<cfset variables.POST_DELETE_PAGE_CFM = "post-delete-page.cfm" />

<!--- some more constants --->
<cfset variables.PATH_TO_FRAMEWORK_INI = "/customcf/org/figleaf/frameworkconfig/framework.ini.cfm" />
<cfset variables.PATH_TO_SYSTEMCONFIGURATION_INI = "/customcf/org/figleaf/site/config/systemconfiguration.ini.cfm" />
<cfset variables.PATH_TO_DATASERVICE_STORAGE = "/dataservice/com/xmldata/data" />

<!--- the array of messages for the boot strap process --->
<cfset variables.instance.messageArray = arrayNew(1) />



<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="BootStrapper" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="doDeployment" default="false" type="boolean" 
		hint="Should I run the deployFrameworkFiles method?<br />I default to false." />

	<cfset var systemIniPath = variables.THE_Path & variables.PATH_TO_SYSTEMCONFIGURATION_INI />

	<cfif fileExists(systemIniPath)>
		<cfset setDeployTemplates(trim(getProfileString(systemIniPath, "site", "move_templates"))) />
		<cfset setDeployRootLevelFiles(trim(getProfileString(systemIniPath, "site", "move_root_files"))) />
		<cfset setDeployRenderHandlers(trim(getProfileString(systemIniPath, "site", "move_renderhandlers"))) />
		<cfset setDeployUI(trim(getProfileString(systemIniPath, "site", "move_ui"))) />
		<cfset setForceCustomApplicationCopy(trim(getProfileString(systemIniPath, "commonspot_root_files", "force_custom_application_copy"))) />
		<cfset setForceCustomAuthenticationCopy(trim(getProfileString(systemIniPath, "commonspot_root_files", "force_custom_authentication_copy"))) />
		<cfset setForcePostApproveCopy(trim(getProfileString(systemIniPath, "commonspot_root_files", "force_post_approve_copy"))) />
		<cfset setForcePostDeleteCopy(trim(getProfileString(systemIniPath, "commonspot_root_files", "force_post_delete_copy"))) />
		<cfset setDestroyAdmin(trim(getProfileString(systemIniPath, "framework_deployment_security", "destroy_admin"))) />
		<cfset setProductionServerIPList(trim(getProfileString(systemIniPath, "system", "production_server_ip_list"))) />
	<cfelse>
		<cfthrow type="FigFactor.noIniFile" 
			message="FigFactor: the systemconfiguration.ini file could not be found." 
			detail="Called from BootStrapper.init() line 80." />
	</cfif>
	
	<cfset setMessage("::::::BOOT STRAPPER DEPLOYMENT START::::::") />
	
	<cfif arguments.doDeployment eq true>
		
		<cfif getDeployTemplates() eq false>
			<cfset setMessage("No Root Level Files are configured to be deployed.") />
		</cfif>
		
		<cfset deployFrameworkFiles() />
		<cfset deleteFigFactorAdminFolder() />
		<cfset deleteDataServiceCachFiles() />
	</cfif>
	
	<cfset setMessage("::::::BOOT STRAPPER DEPLOYMENT END::::::") />

	<cfreturn this />
</cffunction>



<!--- deployMapping --->
<cffunction name="deployMapping" returntype="void" access="public" output="false"
    displayname="Deploy Mapping" hint="I take a mapping object and deploy its files."
    description="I take a mapping object and deploy its files.">
    
	<cfargument name="mapping" type="component" required="true" 
		hint="I am the mapping object to deploy.<br />I a requried." />
	
	<cfset doDeployMapping(arguments.mapping) />
	
</cffunction>



<!--- getBootStrapMessages --->
<cffunction name="getBootStrapMessages" returntype="array" access="public" output="false"
    displayname="Get Boot Strap Messages" hint="I return an array of messages about how I deployed files."
    description="I return an array of messages about how I deployed files.">
	
    <cfreturn variables.instance.messageArray />
</cffunction>



<!--- getFigFactorSystemPath --->
<cffunction name="getFigFactorSystemPath" returntype="string" access="public" output="false"
    displayname="Get Fig Factor System Path" hint="I return the file system path to the top FigFactor directory."
    description="I return the file system path to the top FigFactor directory as a string.">
   
	<cfargument name="traillingSlash" type="boolean" default="true" 
		hint="Should I retrun the string with a trailling slash?<br />I default to true, (reverse compatability)." />

	<cfset var stringLength = 0 />
	<cfset var result = "" />

	<cfif arguments.traillingSlash eq true>
		<cfset result = variables.instance.path />
	<cfelse>
		<cfset stringLength = len(variables.instance.path) - 1 />
		<cfset result = left(variables.instance.path, stringLength) />
	</cfif>
	
	<cfreturn result />
</cffunction>



<!--- getFileCount --->
<cffunction name="getFileCount" access="public" output="false" returntype="numeric"
	displayname="Get File Count" hint="I return the amount of files I have copied since instanciation."
	description="I return the amount of files I have copied since instanciation.">

	<cfreturn variables.instance.FileCount />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- getLogArray --->
<cffunction name="getLogArray" returntype="array" access="public" output="false"
    displayname="Get Log Array" hint="I return the messages created by the boot strapping process."
    description="I return the messages created by the boot strapping process. Here for reverse compatibility.">
    
    <cfreturn getBootStrapMessages() />
</cffunction>



<!--- getNewMapping --->
<cffunction name="getNewMapping" returntype="component" access="public" output="false"
    displayname="Get New Mapping" hint="I return a new Mapping object."
    description="I return a new Mapping object.">
    
	<cfreturn createObject("component", "com.beans.Mapping").init() />
</cffunction>



<!--- getThePath --->
<cffunction name="getThePath" returntype="string" access="public" output="false"
    displayname="Get The Path" hint="I return the file system path to the root of this Commonspot site."
    description="I return the file system path to the root of this Commonspot site.">
    
    <cfreturn variables.THE_PATH />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- deployFrameworkFiles --->
<cffunction name="deployFrameworkFiles" returntype="void" access="private" output="false"
    displayname="Deploy Framework Files" hint="I copy and deploy the nessary files for the framework."
    description="I copy and deploy the nessary files and directories for the framework based on some configuration files.">
	
	<cfset var fileXML = "" />
	<cfset var theXML = 0 />
	<cfset var mappings = arrayNew(1) />
	<cfset var map = 0 />
	<cfset var x = 0 />
	<cfset var a = 0 />
	<cfset var commonSpotRootFiles = 0 />
	
	<!--- used for logging how many files are copied --->
	<cfset setFileCount() />
	
	<cffile action="read" 
		file="#getDirectoryFromPath(GetCurrentTemplatePath())#/resource/mappings/mappings.xml" 
		variable="fileXML" />
	
	<cfset theXML = xmlParse(fileXML) />
	
	<cfset logDeploymentOptions() />

	<cfloop array="#theXML.mappings.XMLChildren#" index="x">
	
		<!--- 
		Don't make a map for the "context" xml node, just set the frameworks
		global file paths.
		--->
		<cfif x.XmlAttributes.type eq variables.CONTEXT_NAME>
			
			<cfloop array="#x.XmlChildren#" index="a">
				<cfset variables.instance[a.XmlName] = variables.THE_PATH & a.XmlText />
			</cfloop>
		<cfelse>	
		
			<cfset map  = createMap(xml = x) />
			
			<!--- should the map object be deoplyed? --->
			<cfif 
				map.getName() eq variables.TEMPLATE_NAME and getDeployTemplates() eq false
				or
				map.getName() eq variables.UI_NAME and getDeployUI() eq false
				or
				map.getName() eq variables.RENDER_NAME and getDeployRenderHandlers() eq false
				or
				map.getName() eq variables.ROOT_Name><!--- never put this in the array --->
				
				<cfset map.setIsDeployable(false) />
			</cfif>
			
			<!--- 
			Deploy root files based on configuration settings. Don't want to be
			casual when overwritting file like custom-application.cfm. 
			--->
			<cfif map.getName() eq variables.ROOT_NAME and getDeployRootLevelFiles() eq true>
				
				<cfset setMessage("COMMONSPOT _ROOT_ LEVEL FILE DEPLOYMENT START") />
				
				<cfdirectory 
					action="list" 
					directory="#map.getSource()#" 
					name="commonSpotRootFiles">
				
				<!--- should we deploy this root level file? --->
				<cfloop query="commonSpotRootFiles">
					<cfif 
						name eq CUSTOM_APPLICAION_CFM and getForceCustomApplicationCopy() eq true
						or
						name eq CUSTOM_AUTHENTICATION_CFM and getForceCustomAuthenticationCopy() eq true
						or
						name eq POST_APPROVE_CFM and getForcePostApproveCopy() eq true
						or
						name eq POST_DELETE_PAGE_CFM and getForcePostDeleteCopy() eq true>
						
						<cfset copyFile(
							source = directory & "/" & name, 
							destination = map.getDestination() & name) />

					<cfelse>	
						<cfset setMessage("SOURCE_NOT_COFIGURED_TO_BE_COPIED: 	#directory#/#name#") />
					</cfif>
				</cfloop>
				<cfset setMessage("COMMONSPOT _ROOT_ LEVEL FILE DEPLOYMENT END") />
			</cfif>

			<!--- add the map to the array of mappings that get deployed --->
			<cfif map.getIsDeployable() eq true>
				<cfset arrayAppend(mappings, duplicate(map)) />
			</cfif>
		</cfif>
	</cfloop>

	<cfset setMappings(mappings) />
	
	<cfloop array="#getMappings()#" index="x">
		<cfset doDeployMapping(x) />
	</cfloop>
	
	<cfset logDeploymentOptions(start = false) />
	
</cffunction>



<!--- createMap --->
<cffunction name="createMap" returntype="component" access="private" output="false"
    displayname="Create Map" hint="I create a map object and populate it."
    description="I create a map object and populate it with the xml values from the configuration file.">
    
	<cfargument name="xml" type="xml" required="true" 
		hint="I am the xml to populate the map with.<br />I a requried." />
	<cfargument name="path" type="string" default="#variables.THE_PATH#" 
		hint="I am the system file path to the figleaf directory.<br />I default to variables.THE_PATH." />
	
	<cfset var x = 0 />
	<cfset var map = createObject("component", "com.beans.Mapping").init() />
	
	<!--- setting here so a map object can easily be used by external applicaitons --->
	<cfset map.setType(arguments.xml.XmlAttributes.type) />
	<cfset map.setRecursive(arguments.xml.XmlAttributes.recursive) />
	<cfif structKeyExists(arguments.xml.XmlAttributes, "AllowedExtensions")>
		<cfset map.setAllowedExtensions(arguments.xml.XmlAttributes.AllowedExtensions) />
	</cfif>
	<cfif structKeyExists(arguments.xml.XmlAttributes, "name")>
		<cfset map.setName(arguments.xml.XmlAttributes.name) />
	</cfif>
	
	<!--- TODO: these are not children tags! make them attributes. --->
	<cfloop array="#arguments.xml.XmlChildren#" index="x">
		<cfif x.XmlName eq "source">
			<cfset map.setSource(arguments.path & x.XmlText) />
		</cfif>
		<cfif x.XmlName eq "destination">
			<cfset map.setDestination(arguments.path &  x.XmlText) />
		</cfif>
	</cfloop>
	
    <cfreturn map />
</cffunction>



<!--- doDeployMapping --->
<cffunction name="doDeployMapping" returntype="any" access="private" output="false"
    displayname="Do Deploy Mapping" hint="I deploy files based on the mappings object configuraiton."
    description="I deploy files based on the mappings object configuraiton.">
    
	<cfargument name="mapping" type="component" required="true" 
		hint="I am the mapping object.<br />I a requried." />

	<!--- file copy --->
	<cfif fileExists(arguments.mapping.getSource())>
		<cfset copyFile(
			source = arguments.mapping.getSource(),
			destination = arguments.mapping.getDestination()) />
	
	<!--- directory copy --->
	<cfelse>
		<cfset setMessage("******** DIRECTORY DEPLOYMENT: #arguments.mapping.getSource()#") />
		<cfset directoryCopy(
			source = arguments.mapping.getSource(),
			destination = arguments.mapping.getDestination(),
			allowedExtensions = arguments.mapping.getAllowedExtensions()) />
	</cfif>
	
</cffunction>



<!--- directoryCopy --->
<cffunction name="directoryCopy" output="true">
    <cfargument name="source" required="true" type="string">
    <cfargument name="destination" required="true" type="string">
    <cfargument name="nameconflict" required="true" default="overwrite">
	<cfargument name="allowedExtensions" required="false" default="" />

    <cfset var contents = "" />
    <cfset var dirDelim = "/">
	<cfset var x = 0 />
    
     <cfif server.OS.Name contains "Windows">
        <cfset dirDelim = "\" />
    </cfif>
    
    <cfif not(directoryExists(arguments.destination))>
        <cfdirectory action="create" directory="#arguments.destination#" />
    </cfif>
    
    <cfdirectory action="list" directory="#arguments.source#" name="contents" />
   
    <cfloop query="contents">	
		<!--- 
		Only if its a file, and if there is a list of allowed files, the files 
		extension must be in the list. 
		--->
        <cfif contents.type eq "file" and listLen(arguments.allowedExtensions) eq 0 
			or (contents.type eq "file" and ListContainsNoCase(arguments.allowedExtensions, right(name, 3), ","))>
			
			<cfset copyFile(
				source = "#arguments.source##dirDelim##name#", 
				destination = "#arguments.destination##dirDelim##name#") />
	
		<!--- call this function recursivly --->
        <cfelseif contents.type eq "dir">
            <cfset directoryCopy(
				arguments.source & dirDelim & name, 
				arguments.destination & dirDelim & name, 
				arguments.nameconflict, arguments.allowedExtensions) />
        </cfif>
    </cfloop>
	
</cffunction>



<!--- copyFile --->
<cffunction name="copyFile" returntype="void" access="private" output="false"
    displayname="Copy File" hint="I copy and log a file I copied."
    description="I copy and log a file I copied.">
	
	<cfargument name="source" type="string" required="true" 
		hint="I am the full source.<br />I a requried." />
	<cfargument name="destination" type="string" required="true" 
		hint="I am the full destination path.<br />I a requried." />
    
	<cfset setMessage("SOURCE:	#arguments.source#") />
	
	<!--- set at the top of this CFC --->
	<cfif variables.DO_FILE_COPY eq true>
		<cffile action="copy" source="#arguments.source#" destination="#arguments.destination#" nameconflict="overwrite" />
		<cfset setMessage("DEST___:	#arguments.destination#") />
		<cfset setFileCount() />
	<cfelse>
		<cfset setMessage("DEST___: DEV MODE... change the BootStrapper.cfc constructor code to 'true' for real copies.") />
	</cfif>
	
</cffunction>



<!--- deleteFigFactorAdminFolder --->
<cffunction name="deleteFigFactorAdminFolder" returntype="void" access="private" output="false"
    displayname="Delete FigFactor Admin Folder" hint="I will attempt to delete the admin helper application folder from the framework."
    description="I will attempt to delete the admin helper application folder from the framework.">
	
	<cfset var test = 0 />
	<cfset var errorMessage = "" />
	
	<cfif getDestroyAdmin() eq true and variables.DO_FILE_COPY eq true>
	
		<cftry>
			<cfdirectory action="delete" recurse="true" directory="#getFigFactorSystemPath()#/admin" />
			<cfcatch>
				<cfset test = 1 />
				<cfset errorMessage = cfcatch.message />
			</cfcatch>
		</cftry>
		
		<cfif test eq 1>
			<cfset setMessage("FAILED TO DELETE THE ADMIN FOLDER: Error Message: #errorMessage#") />
		<cfelse>
			<cfset setMessage("WARN!!! WARN!!! WARN!!!! WARN!!! DELETED THE ADMIN FOLDER") />
		</cfif>
	<cfelse>
		<cfset setMessage("WARN!!!! the '/customcf/org/figleaf/admin/' directory is on this server.") />
	</cfif>


</cffunction>



<!--- deleteDataServiceCachFiles --->
<cffunction name="deleteDataServiceCachFiles" returntype="void" access="private" output="false"
    displayname="Delete Data Service Cache Files" hint="I delete DataServices's xml cached files.."
    description="I attempt to delete DataServices's xml cached files.">
		
	<cfargument name="cacheDirectory" type="string" hint="The file system path to DataServices cache directory.<br />I defalut to a runtime variable."
		default="#variables.instance.applicationPath &  variables.PATH_TO_DATASERVICE_STORAGE#" />

	<!--- they might not have installed dataservice, so handle --->
	<cfif directoryExists(arguments.cacheDirectory)>
		<cfdirectory action="delete" recurse="true" directory="#arguments.cacheDirectory#" />
		<cfdirectory action="create" directory="#arguments.cacheDirectory#" />
		<cfset setMessage("DATASERVICE: cache files deleted and NEW data directory created.") />
	<cfelse>
		<cfset setMessage("WARN WARN WARN WARN: DataService has no cache file.  The DataService's cacheing will not be enabled.") />
	</cfif>
		
</cffunction>



<!--- logDeploymentOptions --->
<cffunction name="logDeploymentOptions" returntype="void" access="private" output="false"
    displayname="Log Deployment Options" hint="I log what will be deployed."
    description="I log what will be deployed. Developer didn't like this stuff clutering up the deployFrameworkFiles() method.">
    
	<cfargument name="start" default="true" type="boolean"
		hint="Should I log the start or the end of file deployment?<br />I defalut to true, log the start." />
	
	<cfif arguments.start eq true>
		<cfset setMessage("These things should happen:") />
		<cfset setMessage("1. Destroy Admin = #getDestroyAdmin()#") />
		<cfset setMessage("2. Deploy Templates = #getDeployTemplates()#") />
		<cfset setMessage("3. Deploy Root Level FIles = #getDeployRootLevelFiles()#") />
		<cfset setMessage("4. Deploy Renderhandlers = #getDeployRenderHandlers()#") />
		<cfset setMessage("5. Deploy UI = #getDeployUI()#") />
		<cfset setMessage("FILE COPY START----") />
	<cfelse>
		<cfset setMessage("Total Files Copied: #getFileCount()#") />
		<cfset setMessage("FILE COPY END---") />
	</cfif>

</cffunction>



<!--- setFileCount --->
<cffunction name="setFileCount" access="private" output="false" returntype="void">
	<cfargument name="FileCount" type="numeric" default="1"/>

	<cfif isDefined("variables.instance.FileCount")>	
		<cfset variables.instance.FileCount = variables.instance.FileCount + 1 />
	<cfelse>
		<cfset variables.instance.FileCount = 0 />
	</cfif>

</cffunction>



<!--- setMessage --->
<cffunction name="setMessage" returntype="void" access="private" output="false"
    displayname="Set Boot Strap Message" hint="I set a message to an array."
    description="I set a message to an array.">
		
	<cfargument name="message" type="string" required="true" 
		hint="I am the message.<br />I a requried." />
    
	<cfset arrayAppend(variables.instance.messageArray, arguments.message) />
	
</cffunction>



<!--- Mappings --->
<cffunction name="setMappings" access="private" output="false" returntype="void">
	<cfargument name="Mappings" type="array" required="true"/>
	<cfset variables.instance.Mappings = arguments.Mappings />
</cffunction>
<cffunction name="getMappings" access="private" output="false" returntype="array" hint="I retrun the array of mapping objects">
	<cfreturn variables.instance.Mappings />
</cffunction>
<!--- DeployRootLevelFiles --->
<cffunction name="setDeployRootLevelFiles" access="private" output="false" returntype="void">
	<cfargument name="DeployRootLevelFiles" type="boolean" required="false" default="false"/>
	<cfset variables.instance.DeployRootLevelFiles = arguments.DeployRootLevelFiles />
</cffunction>
<cffunction name="getDeployRootLevelFiles" access="private" output="false" returntype="boolean">
	<cfreturn variables.instance.DeployRootLevelFiles />
</cffunction>
<!--- DeployTemplates --->
<cffunction name="setDeployTemplates" access="private" output="false" returntype="void">
	<cfargument name="DeployTemplates" type="boolean" required="false" default="false"/>
	<cfset variables.instance.DeployTemplates = arguments.DeployTemplates />
</cffunction>
<cffunction name="getDeployTemplates" access="private" output="false" returntype="boolean">
	<cfreturn variables.instance.DeployTemplates />
</cffunction>
<!--- DeployRenderHandlers --->
<cffunction name="setDeployRenderHandlers" access="private" output="false" returntype="void">
	<cfargument name="DeployRenderHandlers" type="boolean" required="false" default="false"/>
	<cfset variables.instance.DeployRenderHandlers = arguments.DeployRenderHandlers />
</cffunction>
<cffunction name="getDeployRenderHandlers" access="private" output="false" returntype="boolean">
	<cfreturn variables.instance.DeployRenderHandlers />
</cffunction>
<!--- DeployUI --->
<cffunction name="setDeployUI" access="private" output="false" returntype="void">
	<cfargument name="DeployUI" type="boolean" required="true"/>
	<cfset variables.instance.DeployUI = arguments.DeployUI />
</cffunction>
<cffunction name="getDeployUI" access="private" output="false" returntype="boolean">
	<cfreturn variables.instance.DeployUI />
</cffunction>
<!--- ForceCustomApplicationCopy --->
<cffunction name="setForceCustomApplicationCopy" access="private" output="false" returntype="void">
	<cfargument name="ForceCustomApplicationCopy" type="boolean" required="true"/>
	<cfset variables.instance.ForceCustomApplicationCopy = arguments.ForceCustomApplicationCopy />
</cffunction>
<cffunction name="getForceCustomApplicationCopy" access="private" output="false" returntype="boolean">
	<cfreturn variables.instance.ForceCustomApplicationCopy />
</cffunction>
<!--- ForceCustomAuthenticationCopy --->
<cffunction name="setForceCustomAuthenticationCopy" access="private" output="false" returntype="void">
	<cfargument name="ForceCustomAuthenticationCopy" type="boolean" required="true"/>
	<cfset variables.instance.ForceCustomAuthenticationCopy = arguments.ForceCustomAuthenticationCopy />
</cffunction>
<cffunction name="getForceCustomAuthenticationCopy" access="private" output="false" returntype="boolean">
	<cfreturn variables.instance.ForceCustomAuthenticationCopy />
</cffunction>
<!--- ForcePostApproveCopy --->
<cffunction name="setForcePostApproveCopy" access="private" output="false" returntype="void">
	<cfargument name="ForcePostApproveCopy" type="boolean" required="true"/>
	<cfset variables.instance.ForcePostApproveCopy = arguments.ForcePostApproveCopy />
</cffunction>
<cffunction name="getForcePostApproveCopy" access="private" output="false" returntype="boolean">
	<cfreturn variables.instance.ForcePostApproveCopy />
</cffunction>
<!--- ForcePostDeleteCopy --->
<cffunction name="setForcePostDeleteCopy" access="private" output="false" returntype="void">
	<cfargument name="ForcePostDeleteCopy" type="boolean" required="true"/>
	<cfset variables.instance.ForcePostDeleteCopy = arguments.ForcePostDeleteCopy />
</cffunction>
<cffunction name="getForcePostDeleteCopy" access="private" output="false" returntype="boolean">
	<cfreturn variables.instance.ForcePostDeleteCopy />
</cffunction>
<!--- DestroyAdmin --->
<cffunction name="setDestroyAdmin" access="private" output="false" returntype="void">
	<cfargument name="DestroyAdmin" type="boolean" required="true"/>
	<cfset variables.instance.DestroyAdmin = arguments.DestroyAdmin />
</cffunction>
<cffunction name="getDestroyAdmin" access="private" output="false" returntype="boolean">
	<cfreturn variables.instance.DestroyAdmin />
</cffunction>
<!--- ProductionServerIPList --->
<cffunction name="setProductionServerIPList" access="public" output="false" returntype="void">
	<cfargument name="ProductionServerIPList" type="string" required="true"/>
	<cfset variables.instance.ProductionServerIPList = arguments.ProductionServerIPList />
</cffunction>
<cffunction name="getProductionServerIPList" access="public" output="false" returntype="string">
	<cfreturn variables.instance.ProductionServerIPList />
</cffunction>
</cfcomponent>