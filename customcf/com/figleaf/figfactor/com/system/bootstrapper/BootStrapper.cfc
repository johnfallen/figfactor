<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			BootStrapper.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I prepare the FigFactor environment for initalization
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		26/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Boot Strapper" output="false"
	hint="I prepare the FigFactor environment for initalization">

<cfset variables.FILE_MAPPING_CONFIG_PATH = "com/mappings/" />
<cfset variables.FILE_MAPPING_CORE_FILE = "core_framework_mappings.xml" />
<cfset variables.FILE_MAPPING_USER_DEFINED_FILE = "filemappings.xml" />

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="BootStrapper" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="webRootPath" type="string" required="false" default="" 
		hint="I am the path to the web root. I default to an empty string." />
 	<cfargument name="frameworkPath" type="string" required="false" 
		hint="I am the absolute path to the FigFactor framework." />
	<cfargument name="Logger" type="any" required="false"  
		hint="I am the Logger component. I am required." />
	<cfargument name="FileMapper" type="any" required="false"  
		hint="I am the FileMapper component. I am required." />

	<cfset variables.instance = structNew() />
	
	<cfset variables.Logger = arguments.Logger />
	<cfset variables.FileMapper = arguments.FileMapper />
	
	<cfset setWebRootPath(arguments.webRootPath) />
	<cfset setFileMappingConfigPath() />
	<cfset setFileMappingCoreFile() />
	<cfset setFileMappingUserFile() />

	<!--- load and deploy the core file mappings --->
	<cfset loadMapsFromXMLFile(getFileMappingCoreFile()) />
	<cfset deployFileMaps() />

	<!--- we have loaded the core files, lets try the user defined file mappings --->
	<cfif FileExists(getFileMappingUserFile())>
		<cfset loadMapsFromXMLFile(getFileMappingUserFile()) />
		<cfset deployFileMaps() />
	</cfif>

	<cfreturn this />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- getMapDefinitions --->
<cffunction name="getMapDefinitions" returntype="struct" access="public" output="false"
    displayname="Get Map Definitions" hint="I return all of the registered file mapping objects."
    description="I return all of the registered file mapping objects.">
    
    <cfreturn variables.FileMapper.getMappingDefinitions() />
</cffunction>



<!--- getMap --->
<cffunction name="getMap" returntype="component" access="public" output="false"
    displayname="Get Map" hint="I return a File Mapping object by name or a new one if none are found by name or no name is passed."
    description="I return a File Mapping object by name or a new one if none are found by name or no name is passed.">
    
	<cfargument name="name" type="string" required="false" default="" 
		hint="I am the name of the mapping." />
	
	<cfreturn variables.FileMapper.getMap(argumentCollection = arguments) />
</cffunction>



<!--- registerMap --->
<cffunction name="registerMap" returntype="void" access="public" output="false"
    displayname="Register Map" hint="I register a file mapping object into my internal instance. THROWS error if the Mapping fails validation or another map exists with the same name."
    description="I register a file mapping object into my internal instance. THROWS error if the Mapping fails validation or another map exists with the same name.">
	
	<cfargument name="mapObject" type="component" required="true" 
		hint="I am the mapping object. I am requried." />
	<cfargument name="save" type="boolean" default="false" required="false" 
		hint="Should I save this configuration object?" />
	
	<cfset variables.FileMapper.registerMapping(argumentCollection = arguments) />

	<cfif arguments.save eq true>
		<!--- TODO: implement this when object store is cooler about taking external objects --->
		<!--- <cfset variables.objectStore.save(arguments.mapObject) /> --->
	</cfif>
	
</cffunction>



<!--- deployMap --->
<cffunction name="deployMap" returntype="void" access="public" output="false"
    displayname="Deploy Map" hint="I deploy a single file mapping by name or if passed a map object itself. THROWS ERROR if no map object or name is passed."
    description="I deploy a single file mapping by name or if passed a map object itself. THROWS ERROR if no map object or name is passed.">
    
	<cfargument name="map" type="component" required="false" 
		hint="I am the name of the file mapping. I am requried." />
	<cfargument name="name" type="string" required="false" >
	
	<cfset variables.FileMapper.deployMap(argumentCollection = arguments) />
</cffunction>



<!--- deployFileMaps --->
<cffunction name="deployFileMaps" returntype="void" access="public" output="false"
    displayname="Deploy File Maps" hint="I deploy all of my registered File Mappings ."
    description="I deploy all of my registered Mappings.">
    
	<cfargument name="deployAllMaps" type="boolean" default="false"
		hint="Should I deploy all of my registered maps or just maps that have not yet been deployed. I default to false and only deploy mappings that have yet to be deployed." />
	<cfargument name="namedMapList" type="string" required="false" default=""
		hint="I am a list of Map names to filter by. I default to an empty string." />
	
	<cfset variables.FileMapper.deployMappings(argumentCollection = arguments) />
	
</cffunction>



<!--- loadMapsFromXMLFile --->
<cffunction name="loadMapsFromXMLFile" returntype="void" access="public" output="false"	
	displayname="Load Maps From XML File" hint="I create and load map objects from xml configuration."
	description="I create and load map objects from xml configuration.">

	<cfargument name="pathToFile" type="string" required="true" 
		hint="I am the name of the XML mapping file to read. I am required." />
	
	<cfset var xml = 0 />
	<cffile action="read" file="#arguments.pathToFile#" variable="xml" />
	<cfset variables.FileMapper.loadMapsFromRawXML(xmlParse(xml)) />
	
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
<!--- getFileMappingCoreFile --->
<cffunction name="getFileMappingCoreFile" access="public" output="false" returntype="string"
	displayname="Get FileMappingCoreFile" hint="I return the FileMappingCoreFile property." 
	description="I return the FileMappingCoreFile property to my internal instance structure.">
	<cfreturn variables.instance.FileMappingCoreFile />
</cffunction>

<!--- setFileMappingCoreFile --->
<cffunction name="setFileMappingCoreFile" access="public" output="false" returntype="void"
	displayname="Set FileMappingCoreFile" hint="I set the FileMappingCoreFile property." 
	description="I set the FileMappingCoreFile property to my internal instance structure.">

				
	<cfset variables.instance.FileMappingCoreFile = 
		getFileMappingConfigPath() & variables.FILE_MAPPING_CORE_FILE />

</cffunction>

<!--- getFileMappingUserFile --->
<cffunction name="getFileMappingUserFile" access="public" output="false" returntype="string"
	displayname="Get FileMappingUserFile" hint="I return the FileMappingUserFile property." 
	description="I return the FileMappingUserFile property to my internal instance structure.">
	<cfreturn variables.instance.FileMappingUserFile />
</cffunction>

<!--- setFileMappingUserFile --->
<cffunction name="setFileMappingUserFile" access="public" output="false" returntype="void"
	displayname="Set FileMappingUserFile" hint="I set the FileMappingUserFile property." 
	description="I set the FileMappingUserFile property to my internal instance structure.">
	
	<cfset variables.instance.FileMappingUserFile = 
		getFileMappingConfigPath() & variables.FILE_MAPPING_USER_DEFINED_FILE />
	
</cffunction>

<!--- getFileMappingConfigPath --->
<cffunction name="getFileMappingConfigPath" access="public" output="false" returntype="string"
	displayname="Get FileMappingConfigPath" hint="I return the FileMappingConfigPath property." 
	description="I return the FileMappingConfigPath property to my internal instance structure.">
	<cfreturn variables.instance.FileMappingConfigPath />
</cffunction>

<!--- setFileMappingConfigPath --->
<cffunction name="setFileMappingConfigPath" access="public" output="false" returntype="void"
	displayname="Set FileMappingConfigPath" hint="I set the FileMappingConfigPath property." 
	description="I set the FileMappingConfigPath property to my internal instance structure.">
	
	<cfset variables.instance.FileMappingConfigPath = 
			getDirectoryFromPath(GetCurrentTemplatePath()) & variables.FILE_MAPPING_CONFIG_PATH />

	</cffunction>

<!--- getWebRootPath --->
<cffunction name="getWebRootPath" access="public" output="false" returntype="string"
	displayname="Get WebRootPath" hint="I return the WebRootPath property." 
	description="I return the WebRootPath property to my internal instance structure.">
	<cfreturn variables.instance.WebRootPath />
</cffunction>
<!--- setWebRootPath --->
<cffunction name="setWebRootPath" access="public" output="false" returntype="void"
	displayname="Set WebRootPath" hint="I set the WebRootPath property." 
	description="I set the WebRootPath property to my internal instance structure.">
	<cfargument name="WebRootPath" type="string" required="true"
		hint="I am the WebRootPath property. I am required."/>
	<cfset variables.instance.WebRootPath = arguments.WebRootPath />
</cffunction>
</cfcomponent>