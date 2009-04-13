<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		SystemConfigBean.cfc
Author:     		John Allen
Email:      		jallen@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@
Purpose:    	I persist configuration data for Fig Leaf sub applications
Usage:      		I provide getters and setters for all of my properties.

-------------------------------------------------------------------------------------------
Modification Log:
Name 			Date 					Description
================================================================================
John Allen 		21/08/2008			Created
John Allen 		23/09/2008			Added all the reload, urlrecach stuff and the
											CONSTANTS structure.
John Allen 		04/06/2008			Upgraded to FigFactor V2.
------------------------------------------------------------------------------->
<cfcomponent displayname="System Config Bean" output="false"
	hint="I persist configuration data for Fig Leaf sub applications">

<!--- ****************************** Scopes ****************************** --->

<cfset variables.instance = structNew() />
<cfset variables.instance.CONSTANTS = structNew() />

<!--- CONSTANTS --->
<cfset variables.instance.CONSTANTS.DATANOTFOUND = "DATANOTFOUND" />



<!--- ****************************** Public ****************************** --->

<!--- init --->
<cffunction name="init" returntype="SystemConfigBean" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="frameworkPath"  
		hint="I am the absolute file path to the figfactor directory. I am required." />
	<cfargument name="serverRootPath"  
		hint="I am the absolute file path to web servers root directory. I am required." />
	<cfargument name="webRootPath"  
		hint="I am the absolute file path to the root of this CommonSpot site. I am required." />
	<cfargument name="iniFileName"  
		hint="I am the name of the configureation file to use. I am required." />
	<cfargument name="codeBaseRealitivePath"  
		hint="I am the site realitive path to the 'site' directory. I am required." />
	<cfargument name="UIRealitivePath"  
		hint="I am the site realitive path to the 'UI' directory. I am required." />
	<cfargument name="CSSRealitivePath"  
		hint="I am the site realitive file path to the 'images' directory. I am required." />
	<cfargument name="ImagesRealitivePath"  
		hint="I am the site realitive file path to the 'images' directory. I am required." />
	<cfargument name="FigFactorIncludesRealitivePath"  
		hint="I am the site realitive path to the FigFactor includes directory. I am required." />
	<cfargument name="RenderHandlersRealitivePath"  
		hint="I am the sites realitive path to the 'reanderhandlers' directory. I am required." />
	<cfargument name="RenderHandlerIncludesRealitivePath"
		hint="I am the sites realitive path to the 'site' directory. I am required." />
	
	<!--- set all the framework paths explicitly --->
	<cfset setFrameworkPath( fixDirDelim(arguments.frameworkPath) ) />
	<cfset setServerRootPath( fixDirDelim(arguments.serverRootPath) ) />
	<cfset setWebRootPath( fixDirDelim(arguments.webRootPath) ) />
	<cfset setThePath( getWebRootPath() ) />
	
	<!--- figures out if we are running under a root or sub directry site --->
	<cfset setWebSiteContext(webRootPath = getWebRootPath(), siteRootPath = getServerRootPath()) />
	<cfset setFigFactorWebContext(getWebSiteContext() & arguments.realitiveFrameworkPath) />
	<cfset setFigLeafIncludeDirectory(getFigFactorWebContext() & arguments.FigFactorIncludesRealitivePath) />
	<cfset setSourceCodeDirectory(fixDirDelim(getFrameworkPath() & arguments.codeBaseRealitivePath)) />
	<cfset setINIPath(getFrameworkPath() & "#fixDirDelim('com/system/config/')#" & arguments.iniFileName) />
	<cfset setUIDirectory(getWebSiteContext() & arguments.UIRealitivePath) />
	<cfset setCSSDirectory(getWebSiteContext() & arguments.CSSRealitivePath) />
	<cfset setImageDirectory(getWebSiteContext() & arguments.ImagesRealitivePath) />
	<cfset setRenderHandlerDirectory(getWebSiteContext() & arguments.RenderHandlersRealitivePath) />
	<cfset setIncludesDirectory(getWebSiteContext() & arguments.RenderHandlerIncludesRealitivePath) />
	<cfset setMetaDataUISupportJSDirectory(getUIDirectory() & "js/fleetsupport/") />
	<cfset setMetaDataUISupportEditDirectory(getUIDirectory() & "js/fleetsupport/edit/") />

	<!--- reads the xml file and sets the defined top level subsites --->
	<cfset setSubSiteDefinitions() />
	
	<!--- reads the ini file --->
	<cfset configure() />
	
	<cfif get("ENABLEEXTERNALLOGGER") eq true>
		<cfset variables.instance.logsPath = getSourceCodeDirectory() & "logs/cflog4j.log"/>
	<cfelse>
		<cfset variables.instance.logsPath = ""/>
	</cfif>
	<cfreturn this />
</cffunction>



<!--- configure --->
<cffunction name="configure" output="false"	
	displayname="Configure" hint="I read the ini confiig file and set variables to my internal instance scope."
	description="I read the ini confiig file and set variables to my internal instance scope .">
	
	<cfset var ini = getINIPath() />
	<cfset var x = "" />

	<cfloop file="#ini#" index="x">
		
		<cfif left(x, 1) neq "[" and left(x, 1) neq "<" and len(left(x, 1))>
			
			<cfset variables.instance[UCASE(replace(listFirst(x, "="), "_", "", "all"))] = trim(listLast(x, "=")) />
		</cfif>
	</cfloop>
</cffunction>



<!--- setWebSiteContext --->
<cffunction name="setWebSiteContext" output="false"
	displayname="Set WebSiteContext" hint="I set the WebSiteContext property." 
	description="I set the WebSiteContext property to my internal instance structure.">
	
	<cfargument name="siteRootPath" 
		hint="I am the siteRoot Path. I am required."/>
	<cfargument name="webRootPath" 
		hint="I am the webRootPath property. I am required."/>

	<cfif not CompareNoCase(arguments.siteRootPath, arguments.webRootPath)>
		<cfset variables.instance.WebSiteContext = "/" />
	<cfelse>
		<cfset variables.instance.WebSiteContext = "/" & fixURLPathing( listLast(arguments.webRootPath, "/") ) & "/"/>
	</cfif>
	
	<cfif not CompareNoCase(arguments.siteRootPath, variables.instance.WebSiteContext)>
		<cfset variables.instance.WebSiteContext = "/" />
	<cfelse>
		<cfset variables.instance.WebSiteContext = "/" & fixURLPathing( listLast(arguments.webRootPath, "\") )  & "/"/>
	</cfif>
	
	<!--- fix how a developer might add paths --->
	<cfif left(variables.instance.WebSiteContext, 2) eq "//">
		<cfset variables.instance.WebSiteContext = 
		right(variables.instance.WebSiteContext, (len(variables.instance.WebSiteContext) - 1)) />
	</cfif>
	<cfif right(variables.instance.WebSiteContext, 2) eq "//">
		<cfset variables.instance.WebSiteContext = 
			left(variables.instance.WebSiteContext, (len(variables.instance.WebSiteContext) - 1)) />
	</cfif>
	
</cffunction>



<!--- get --->
<cffunction name="get" output="false"
    displayname="Get" hint="I return a value from my instance by name."
    description="I return a value from my instance by name.">
    
	<cfargument name="name"  
		hint="I am the name of the value. I am requried." />
	
	<cfreturn structFind(variables.instance, arguments.name) />
</cffunction>



<!--- set --->
<cffunction name="set" output="false"
    displayname="Set" hint="I set a value to my internal instance by name."
    description="I set a value to my internal instance by name.">
    
	<cfargument name="name"  
		hint="I am the name of the value. I am requried." />
	<cfargument name="value" type="any" required="true" 
		hint="I am the value to store. I am requried." />
	
	<cfset variables.instance[arguments.name] = arguments.value />

</cffunction>



<!--- onMissingMethod --->
<cffunction name="onMissingMethod" output="false">
	<cfargument name="missingMethodName" type="string">
	<cfargument name="missingMethodArguments" type="struct">

	<cfset var property = "">
	<cfset var value = "">

	<cfif findNoCase("get",arguments.missingMethodName) is 1>
		
		<cfset property = replaceNoCase(arguments.missingMethodName,"get","") />
		
		<cfif NOT StructIsEmpty(Arguments.missingMethodArguments)>
			<cfset value = arguments.missingMethodArguments[listFirst(structKeyList(arguments.missingMethodArguments))] />
		</cfif>
		
		<cfreturn get(property, value) />
	
	<cfelseif findNoCase("set",arguments.missingMethodName) is 1>
		
		<cfset property = replaceNoCase(arguments.missingMethodName,"set","") />
		
		<!--- assume only arg is value --->
		<cfset value = arguments.missingMethodArguments[listFirst(structKeyList(arguments.missingMethodArguments))] />
		<cfset set(property,value) />
	</cfif>

</cffunction>



<!--- getSubSiteDefinition --->
<cffunction name="getSubSiteDefinition"  output="false"
	displayname="GetSubSiteDefinition" hint="I return a structure of information about the main Sub Site/OU. Return Type: Struct"
	description="I return a structure of configuration xml data, based on a what 'Top Level' sub-site the page is in.  Return Type: Struct">

	<cfargument name="SubSiteName" type="string" required="false" default=""
		hint="I am the name of the sub-site to get." />
	<cfargument name="subsiteDefinitions" default="#getSubSiteDefinitions()#" 
		hint="I am the array of Sub Definitions as defined by the SubSiteDefinsitions.xml file."/>
	
	<cfset var x = 0 />
	<cfset var subSiteData = structNew() />

	<cfloop from="1" to="#arrayLen(arguments.subsiteDefinitions)#" index="x">
		<cfif not comparenocase(arguments.SubSiteName, arguments.subsiteDefinitions[x].name)>
			<cfset subSiteData = arguments.subsiteDefinitions[x] />
			<cfbreak />
		</cfif>
	</cfloop>
	
	<cfif structIsEmpty(subSiteData)>
		<cfset subsiteData.name = "" />
		<cfset subsiteData.CSSClassName = "home" />
		<cfset subsiteData.displayName = "" />
		<cfset subsiteData.parentName = "foo" />
	</cfif>

	<cfreturn subSiteData />
</cffunction>



<!--- getSubSiteDefinitions --->
<cffunction name="getSubSiteDefinitions" returntype="array" output="false"	
	displayname="Get SubSite Definitions" hint="I return my array of defined sub sites."
	description="I return my array of defined sub sites.">
    
	<cfreturn variables.instance.SubSiteDefinitions />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="any" output="false"
	displayname="Get Instance" hint="I return my instance data."
	description="I return my internal variables scope.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- getConstants --->
<cffunction name="getConstants" returntype="any" output="false"
	displayname="Get Constants" hint="I return a structre with system wide constant variables."
	description="I return a structre with system wide constant variables.">
	
	<cfreturn variables.instance.CONSTANTS />
</cffunction>



<!--- ****************************** Private ****************************** --->

<!--- setSubSiteDefinitions --->
<cffunction name="setSubSiteDefinitions" access="private" output="false"	
	displayname="Set Sub Site Definitions" hint="I set the sub site definitions xml to an array of sturcturs."
	description="I set the sub site definitions xml to an array of sturcturs.">
    
	<cfset var xml = 0 />
	<cfset var y = 0 />
	<cfset var source = "#getDirectoryFromPath(GetCurrentTemplatePath())#subsitedefinitions.xml">

	<cfset variables.instance.SubSiteDefinitions = arrayNew(1) />
	
	<cffile 
		action="read" 
		file="#source#" 
		variable="xml" />
	<cfset xml = XmlParse(xml) />
	
	<cfloop from="1" to="#arrayLen(xml.SubSiteDefinitions.XMLChildren)#" index="y">
		<cfset arrayAppend(variables.instance.SubSiteDefinitions, xml.SubSiteDefinitions.XMLChildren[Y].XMLAttributes) />
	</cfloop>
	
</cffunction>



<!--- fixDirDelim --->
<cffunction name="fixDirDelim" access="private" output="false"	
	displayname="Fix Dir Delim" hint="I fix the slashing for an operating system."
	description="I fix the slashing for an operating system.">
    
	<cfargument name="path"  
		hint="I am the path to fix. I am requried." />
	
	<cfif server.OS.Name contains "Windows">
		<cfset arguments.path = replace(arguments.path, "/", "\", "all") />
		<cfif right(arguments.path, 1) neq "\">
			<cfset arguments.path = arguments.path & "\" />
		</cfif>
	<cfelse>
		<cfset arguments.path = replace(arguments.path, "\", "/", "all") />
		<cfif right(arguments.path, 1) neq "/">
			<cfset arguments.path = arguments.path & "/" />
		</cfif>
	</cfif>
	<cfreturn arguments.path />
</cffunction>



<!--- fixURLPathing --->
<cffunction name="fixURLPathing" access="private" output="false"	
	displayname="Fix URL Pathing" hint="I noramlize slashing URLs."
	description="I noramlize for an operating system.">
    
	<cfargument name="path"  
		hint="I am the path to fix. I am requried." />

	<cfreturn replace(arguments.path, "\", "/", "all") />
</cffunction>



<!--- ************************* Accessors/Muators ************************* --->

<!--- getFrameworkPath --->
<cffunction name="getFrameworkPath" output="false"
	displayname="Get FrameworkPath" hint="I return the FrameworkPath property." 
	description="I return the FrameworkPath property of my internal instance structure.">
	<cfreturn variables.instance.FrameworkPath />
</cffunction>
<!--- setFrameworkPath --->
<cffunction name="setFrameworkPath" output="false"
	displayname="Set FrameworkPath" hint="I set the FrameworkPath property." 
	description="I set the FrameworkPath property to my internal instance structure.">
	<cfargument name="FrameworkPath" 
		hint="I am the FrameworkPath property. I am required."/>
	<cfset variables.instance.FrameworkPath = arguments.FrameworkPath />
</cffunction>
<!--- getServerRootPath --->
<cffunction name="getServerRootPath" output="false"
	displayname="Get ServerRootPath" hint="I return the ServerRootPath property." 
	description="I return the ServerRootPath property of my internal instance structure.">
	<cfreturn variables.instance.ServerRootPath />
</cffunction>
<!--- setServerRootPath --->
<cffunction name="setServerRootPath" output="false"
	displayname="Set ServerRootPath" hint="I set the ServerRootPath property." 
	description="I set the ServerRootPath property to my internal instance structure.">
	<cfargument name="ServerRootPath" 
		hint="I am the ServerRootPath property. I am required."/>
	<cfset variables.instance.ServerRootPath = arguments.ServerRootPath />
</cffunction>
<!--- getThePath --->
<cffunction name="getThePath" output="false"
	displayname="Get ThePath" hint="I return the ThePath property." 
	description="I return the ThePath property of my internal instance structure.">
	<cfreturn variables.instance.ThePath />
</cffunction>
<!--- setThePath --->
<cffunction name="setThePath" output="false"
	displayname="Set ThePath" hint="I set the ThePath property." 
	description="I set the ThePath property to my internal instance structure.">
	<cfargument name="ThePath" 
		hint="I am the ThePath property. I am required."/>
	<cfset variables.instance.ThePath = arguments.ThePath />
</cffunction>
<!--- getWebRootPath --->
<cffunction name="getWebRootPath" output="false"
	displayname="Get WebRootPath" hint="I return the WebRootPath property." 
	description="I return the WebRootPath property of my internal instance structure.">
	<cfreturn variables.instance.WebRootPath />
</cffunction>
<!--- setWebRootPath --->
<cffunction name="setWebRootPath" output="false"
	displayname="Set WebRootPath" hint="I set the WebRootPath property." 
	description="I set the WebRootPath property to my internal instance structure.">
	<cfargument name="WebRootPath" 
		hint="I am the WebRootPath property. I am required."/>
	<cfset variables.instance.WebRootPath = arguments.WebRootPath />
</cffunction>
<!--- getINIPath --->
<cffunction name="getINIPath" output="false"
	displayname="Get INIPath" hint="I return the INIPath property." 
	description="I return the INIPath property of my internal instance structure.">
	<cfreturn variables.instance.INIPath />
</cffunction>
<!--- setINIPath --->
<cffunction name="setINIPath" output="false"
	displayname="Set INIPath" hint="I set the INIPath property." 
	description="I set the INIPath property to my internal instance structure.">
	<cfargument name="INIPath" 
		hint="I am the INIPath property. I am required."/>
	<cfset variables.instance.INIPath = arguments.INIPath />
</cffunction>
<!--- getWebSiteContext --->
<cffunction name="getWebSiteContext" output="false"
	displayname="Get WebSiteContext" hint="I return the WebSiteContext property." 
	description="I return the WebSiteContext property of my internal instance structure.">
	<cfreturn variables.instance.WebSiteContext />
</cffunction>
<!--- getFigLeafIncludeDirectory --->
<cffunction name="getFigLeafIncludeDirectory" output="false"
	displayname="Get FigLeafIncludeDirectory" hint="I return the FigLeafIncludeDirectory property." 
	description="I return the FigLeafIncludeDirectory property of my internal instance structure.">
	<cfreturn variables.instance.FigLeafIncludeDirectory />
</cffunction>
<!--- setFigLeafIncludeDirectory --->
<cffunction name="setFigLeafIncludeDirectory" output="false"
	displayname="Set FigLeafIncludeDirectory" hint="I set the FigLeafIncludeDirectory property." 
	description="I set the FigLeafIncludeDirectory property to my internal instance structure.">
	<cfargument name="FigLeafIncludeDirectory" 
		hint="I am the FigLeafIncludeDirectory property. I am required."/>
	<cfset variables.instance.FigLeafIncludeDirectory = arguments.FigLeafIncludeDirectory />
</cffunction>
<!--- getSourceCodeDirectory --->
<cffunction name="getSourceCodeDirectory" output="false"
	displayname="Get SourceCodeDirectory" hint="I return the SourceCodeDirectory property." 
	description="I return the SourceCodeDirectory property of my internal instance structure.">
	<cfreturn variables.instance.SourceCodeDirectory />
</cffunction>
<!--- setSourceCodeDirectory --->
<cffunction name="setSourceCodeDirectory" output="false"
	displayname="Set SourceCodeDirectory" hint="I set the SourceCodeDirectory property." 
	description="I set the SourceCodeDirectory property to my internal instance structure.">
	<cfargument name="SourceCodeDirectory" 
		hint="I am the SourceCodeDirectory property. I am required."/>
	<cfset variables.instance.SourceCodeDirectory = arguments.SourceCodeDirectory />
</cffunction>
<!--- getUIDirectory --->
<cffunction name="getUIDirectory" output="false"
	displayname="Get UIDirectory" hint="I return the UIDirectory property." 
	description="I return the UIDirectory property of my internal instance structure.">
	<cfreturn variables.instance.UIDirectory />
</cffunction>
<!--- setUIDirectory --->
<cffunction name="setUIDirectory" output="false"
	displayname="Set UIDirectory" hint="I set the UIDirectory property." 
	description="I set the UIDirectory property to my internal instance structure.">
	<cfargument name="UIDirectory" 
		hint="I am the UIDirectory property. I am required."/>
	<cfset variables.instance.UIDirectory = arguments.UIDirectory />
</cffunction>
<!--- getCSSDirectory --->
<cffunction name="getCSSDirectory" output="false"
	displayname="Get CSSDirectory" hint="I return the CSSDirectory property." 
	description="I return the CSSDirectory property of my internal instance structure.">
	<cfreturn variables.instance.CSSDirectory />
</cffunction>
<!--- setCSSDirectory --->
<cffunction name="setCSSDirectory" output="false"
	displayname="Set CSSDirectory" hint="I set the CSSDirectory property." 
	description="I set the CSSDirectory property to my internal instance structure.">
	<cfargument name="CSSDirectory" 
		hint="I am the CSSDirectory property. I am required."/>
	<cfset variables.instance.CSSDirectory = arguments.CSSDirectory />
</cffunction>
<!--- getImageDirectory --->
<cffunction name="getImageDirectory" output="false"
	displayname="Get ImagesDirectory" hint="I return the ImagesDirectory property." 
	description="I return the ImagesDirectory property of my internal instance structure.">
	<cfreturn variables.instance.ImagesDirectory />
</cffunction>
<!--- setImageDirectory --->
<cffunction name="setImageDirectory" output="false"
	displayname="Set ImagesDirectory" hint="I set the ImagesDirectory property." 
	description="I set the ImagesDirectory property to my internal instance structure.">
	<cfargument name="ImagesDirectory" 
		hint="I am the ImagesDirectory property. I am required."/>
	<cfset variables.instance.ImagesDirectory = arguments.ImagesDirectory />
</cffunction>
<!--- getRenderHandlerDirectory --->
<cffunction name="getRenderHandlerDirectory" output="false"
	displayname="Get RenderHandlerDirectory" hint="I return the RenderHandlerDirectory property." 
	description="I return the RenderHandlerDirectory property of my internal instance structure.">
	<cfreturn variables.instance.RenderHandlerDirectory />
</cffunction>
<!--- setRenderHandlerDirectory --->
<cffunction name="setRenderHandlerDirectory" output="false"
	displayname="Set RenderHandlerDirectory" hint="I set the RenderHandlerDirectory property." 
	description="I set the RenderHandlerDirectory property to my internal instance structure.">
	<cfargument name="RenderHandlerDirectory" 
		hint="I am the RenderHandlerDirectory property. I am required."/>
	<cfset variables.instance.RenderHandlerDirectory = arguments.RenderHandlerDirectory />
</cffunction>
<!--- getIncludesDirectory --->
<cffunction name="getIncludesDirectory" output="false"
	displayname="Get IncludesDirectory" hint="I return the IncludesDirectory property." 
	description="I return the IncludesDirectory property of my internal instance structure.">
	<cfreturn variables.instance.IncludesDirectory />
</cffunction>
<!--- setIncludesDirectory --->
<cffunction name="setIncludesDirectory" output="false"
	displayname="Set IncludesDirectory" hint="I set the IncludesDirectory property." 
	description="I set the IncludesDirectory property to my internal instance structure.">
	<cfargument name="IncludesDirectory" 
		hint="I am the IncludesDirectory property. I am required."/>
	<cfset variables.instance.IncludesDirectory = arguments.IncludesDirectory />
</cffunction>
<!--- getFigFactorWebContext --->
<cffunction name="getFigFactorWebContext" output="false"
	displayname="Get FigFactorWebContext" hint="I return the FigFactorWebContext property." 
	description="I return the FigFactorWebContext property of my internal instance structure.">
	<cfreturn variables.instance.FigFactorWebContext />
</cffunction>
<!--- setFigFactorWebContext --->
<cffunction name="setFigFactorWebContext" output="false"
	displayname="Set FigFactorWebContext" hint="I set the FigFactorWebContext property." 
	description="I set the FigFactorWebContext property to my internal instance structure.">
	<cfargument name="FigFactorWebContext" 
		hint="I am the FigFactorWebContext property. I am required."/>
	<cfset variables.instance.FigFactorWebContext = arguments.FigFactorWebContext />
</cffunction>
<!--- getMetaDataUISupportJSDirectory --->
<cffunction name="getMetaDataUISupportJSDirectory" output="false"
	displayname="Get MetaDataUISupportJSDirectory" hint="I return the MetaDataUISupportJSDirectory property." 
	description="I return the MetaDataUISupportJSDirectory property of my internal instance structure.">
	<cfreturn variables.instance.MetaDataUISupportJSDirectory />
</cffunction>
<!--- setMetaDataUISupportJSDirectory --->
<cffunction name="setMetaDataUISupportJSDirectory" output="false"
	displayname="Set MetaDataUISupportJSDirectory" hint="I set the MetaDataUISupportJSDirectory property." 
	description="I set the MetaDataUISupportJSDirectory property to my internal instance structure.">
	<cfargument name="MetaDataUISupportJSDirectory"
		hint="I am the MetaDataUISupportJSDirectory property. I am required."/>
	<cfset variables.instance.MetaDataUISupportJSDirectory = arguments.MetaDataUISupportJSDirectory />
</cffunction>
<!--- getMetaDataUISupportEditDirectory --->
<cffunction name="getMetaDataUISupportEditDirectory" output="false"
	displayname="Get MetaDataUISupportEditDirectory" hint="I return the MetaDataUISupportEditDirectory property." 
	description="I return the MetaDataUISupportEditDirectory property of my internal instance structure.">
	<cfreturn variables.instance.MetaDataUISupportEditDirectory />
</cffunction>
<!--- setMetaDataUISupportEditDirectory --->
<cffunction name="setMetaDataUISupportEditDirectory" output="false"
	displayname="Set MetaDataUISupportEditDirectory" hint="I set the MetaDataUISupportEditDirectory property." 
	description="I set the MetaDataUISupportEditDirectory property to my internal instance structure.">
	<cfargument name="MetaDataUISupportEditDirectory"
		hint="I am the MetaDataUISupportEditDirectory property. I am required."/>
	<cfset variables.instance.MetaDataUISupportEditDirectory = arguments.MetaDataUISupportEditDirectory />
</cffunction>



<!--- ************************* Legacy ************************* --->

<!--- Here cause of a spelling error that leaked out of the framework --->
<!--- getRederHandlerDirectory --->
<cffunction name="getRederHandlerDirectory" output="false"
	displayname="Get RederHandlerDirectory" hint="I return the RederHandlerDirectory property." 
	description="I return the RederHandlerDirectory property of my internal instance structure.">
	<cfreturn getRenderHandlerDirectory() />
</cffunction>


<!--- Depreciating in favor of FigFactorWebContext --->
<!--- getFigLeafFileContext --->
<cffunction name="getFigLeafFileContext" output="false"
	displayname="Get FigLeafFileContext" hint="I return the FigLeafFileContext property." 
	description="I return the FigLeafFileContext property of my internal instance structure.">
	<cfreturn getFigFactorWebContext() />
</cffunction>
</cfcomponent>