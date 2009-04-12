<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			FileMapper.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I manage the mapping of files
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		26/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="File Mapper" output="false"
	hint="I manage the mapping of files">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="FileMapper" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="webRootPath" type="string" required="true" 
		hint="I am the web root path Constant created in the Bootstrapper.cfc. I am requried." />
	<cfargument name="frameworkPath" type="string" required="false" default="" 
		hint="I am the absolute system file path to the framework." />
	<cfargument name="Logger" type="component" required="true"  
		hint="I am the Logger component. I am required." />

	<cfset variables.instance = structNew() />
	<cfset variables.instance.maps = structNew() />
	<cfset variables.instance.rootPath = arguments.webRootPath />
	<cfset variables.Logger = arguments.Logger />

	<cfreturn this />
</cffunction>



<!--- deployMappings --->
<cffunction name="deployMappings" returntype="void" access="public" output="false"
    displayname="Deploy Mappings" hint="I conditionally deploy mappings based on my arguments."
    description="I deploy registered Map objects base on my passed arguments and if the Map object itself has been deployed or not. I can also deploy Maps filtered by a list of MapNames.">
    
	<cfargument name="deployAllMaps" type="boolean" default="false"
		hint="Should I deploy all of my registered maps or just maps that have not yet been deployed. I default to false and only deploy mappings that have yet to be deployed." />
	<cfargument name="namedMapList" type="string" required="false" 
		hint="I am a list of Map names to filter by. I default to an empty string." />
	
	<cfset var x = 0 />
	
	<cfloop collection="#variables.instance.maps#" item="x">
		
		<cfif arguments.deployAllMaps eq true>
			<cfset variables.instance.maps[x].deploy() />
		
		<cfelseif variables.instance.maps[x].getHasDeployed() eq false>
			<cfset variables.instance.maps[x].deploy() />
		
		<cfelseif len(namedMapList) and listContains(arguments.namedMapList, variables.instance.maps[x].getMapName())>
			<cfset variables.instance.maps[x].deploy() />
		</cfif>
	</cfloop>

</cffunction>



<!--- deployMap --->
<cffunction name="deployMap" returntype="void" access="public" output="false"
    displayname="Deploy Map" hint="I deploy a single file mapping by name or if passed a map object itself. THROWS ERROR if no map object or name is passed."
    description="I deploy a single file mapping by name or if passed a map object itself. THROWS ERROR if no map object or name is passed.">
    
	<cfargument name="map" type="component" required="false" 
		hint="I am the name of the file mapping. I am requried." />
	<cfargument name="name" type="string" required="false" >
	
	<cfset var theMap = 0 />
	
	<!--- set the map to deploy depending on if a name or object was passed --->
	<cfif isDefined("arguments.name")>
		<cfset variables.instance.maps[arguments.name].deploy() />
	<cfelseif isDefined("arguments.map")>
		<cfset arguments.map.deploy() />
	</cfif>

	<!--- if theMap is still a simple value throw an error --->
	<cfif isSimpleValue(theMap)>
		<cfthrow message="No map object or name of a map object was passed to me." />
	</cfif>

	<cfset theMap.deploy() />

</cffunction>



<!--- getMappingDefinitions --->
<cffunction name="getMappingDefinitions" returntype="struct" access="public" output="false"
    displayname="Get Mapping Definitions" hint="I return all of my current file mapping objects."
    description="I return all of my current file mapping objects.">
    
    <cfreturn variables.instance.maps />
</cffunction>



<!--- getMap --->
<cffunction name="getMap" returntype="component" access="public" output="false"
    displayname="Get Map" hint="I return a File Mapping object by name or a new one if none are found by name or no name is passed."
    description="I return a File Mapping object by name or a new one if none are found by name or no name is passed.">
    
	<cfargument name="name" type="string" required="false" default=""
		hint="I am the name of the mapping. I am requried." />
	
	<cfif len(arguments.name) and structKeyExists(variables.instance.maps, arguments.name)>
		<cfreturn variables.instance.maps[arguments.name] />
	<cfelse>
		<cfreturn createObject("component", "Map").init(Logger = variables.Logger) />
	</cfif>
</cffunction>



<!--- registerMapping --->
<cffunction name="registerMapping" returntype="void" access="public" output="false"
    displayname="Register Mapping" hint="I register a file mapping object into my internal instance. THROWS error if the Mapping fails validation or another map exists with the same name."
    description="I register a file mapping object into my internal instance. THROWS error if the Mapping fails validation or another map exists with the same name.">
	
	<cfargument name="mapObject" type="component" required="true" 
		hint="I am the mapping object. I am requried." />

	<cfset variables.instance.maps[arguments.mapObject.getMapName()] = arguments.mapObject />	
	
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<cffunction name="loadMapsFromRawXML" returntype="void" access="public" output="false"	
	displayname="Load Maps From Raw XML" hint="I create and load map objects from a coldfusion xml object."
	description="I create and load map objects from a coldfusion xml object.">

	<cfargument name="xml" type="string" required="true" 
		hint="I am the XML mapping configuration xml object. I am required." />
	
	<cfset var map = 0 />
	<cfset var x = 0 />
	<cfset var y = 0 />
	<cfset var root = variables.instance.rootPath />

	<cfloop array="#xmlSearch(arguments.xml, "//mapping")#" index="x">
		
		<cfset map = getMap() />
		
		<cfloop array="#x.XmlChildren#" index="y">
			<cfif lcase(y.XmlName) eq "source">
				<cfset map.setSource(root & y.XmlText) />
			<cfelseif lcase(y.XmlName) eq "destination">
				<cfset map.setDestination(root & y.XmlText) />
			<cfelseif lcase(y.XmlName) eq "name">
				<cfset map.setMapName(y.XmlText) />
			<cfelseif lcase(y.XmlName) eq "file">
				<cfset map.setFileName(y.XmlText) />
			<cfelseif lcase(y.XmlName) eq "allowedExtensions">
				<cfset map.setAllowedExtensions(y.XmlText) />
		 	<cfelseif lcase(y.XmlName) eq "recursive">
				<cfset map.setRecursive(y.XmlText) />
			</cfif>
		</cfloop>
		
		<cfset registerMapping(map) />
	</cfloop>
	
</cffunction>
</cfcomponent>