<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			FigFactor.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am the FigFactor framework. I am loosly typed for speed. I initalize 
						the framework and act as a thin controller, providing proxy methods 
						to my internally managed beans.
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		20/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent 
	displayname="FigFactor Framework" 
	output="false"
	hint="
		I am the FigFactor framework. I am loosly typed for speed. I initalize 
		the framework and act as a thin controller, providing proxy methods 
		to my internally managed beans." 
	version=".01"
	IOCFrameworkname = "ColdSpring">



<!--- ****************************** Scopes ****************************** --->

<!--- public --->
<cfset variables.instance = structNew() />
<!--- framework components --->
<cfset variables.private = structNew() />
<!--- user supplied beans --->
<cfset variables.private.userSuppliedApplications = structNew() />
<!--- paths --->
<cfset variables.path = structNew() />
<!--- files --->
<cfset variables.files = structNew() />
<!--- if a mixin file is sucessfully included --->
<cfset variables.hasMixen = false />



<!--- **************************** Constants **************************** --->

<!--- 
	These are all the default paths for the framework. They will work at root,
	or any sub customcf directory in a CommonSpot site. To over ride these
	add them to the FigFactorMixex.cfm file in the /site/extensions/ directory.
 --->
<!--- paths --->
<cfset variables.path.realitiveFrameworkPath = "customcf/com/figleaf/figfactor/" />
<cfset variables.path.realitivePathToDIConfigFiles = "com/system/config/coldspring/" />
<cfset variables.path.codeBaseRealitivePath = "site/">
<cfset variables.path.UIRealitivePath = "ui/" />
<cfset variables.path.CSSRealitivePath = "ui/css/" />
<cfset variables.path.ImagesRealitivePath = "ui/images/" />
<cfset variables.path.JavaScriptRealitivePath = "ui/js/" />
<cfset variables.path.FigFactorIncludesRealitivePath = "site/includes/" />
<cfset variables.path.RenderHandlersRealitivePath = "renderhandlers/" />
<cfset variables.path.RenderHandlerIncludesRealitivePath = "renderhandlers/includes/" />

<!--- file names --->
<cfset variables.files.DI.DIBootStrapperBeanFile = "coldspring_bootstrapper.xml" />
<cfset variables.files.DI.DICoreFrameworkBeanFile = "coldspring_framework.xml" />
<cfset variables.files.DI.DIApplicationsBeanFile = "coldspring_applications.xml" />
<cfset variables.files.iniFileName = "systemconfiguration.ini.cfm" />


<!--- **************************** Mixens **************************** --->
<!--- 
	Logic for how the framework will create itself. If we sucessfully include
	the users mixen file we will check what happened here and then
	make several method calles on myself in the init() and getEvent()
	methods.
--->
<cftry>
	<cfinclude template="site/extensions/FigFactorMixen.cfm" />
	<cfset variables.hasMixen = true />
	<cfcatch></cfcatch>
</cftry>



<!--- ****************************** Public ****************************** --->

<!--- init --->
<cffunction name="init" access="public" output="false" 
	displayname="Init" hint="I am the constructor. Return Type: component, this." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="realitiveFrameworkPath" default="#variables.path.realitiveFrameworkPath#" />
	<cfargument name="realitivePathToDIConfigFiles" default="#variables.path.realitivePathToDIConfigFiles#" />
	<cfargument name="DIBootStrapperBeanFile" default="#variables.files.DI.DIBootStrapperBeanFile#" />
	<cfargument name="DICoreFrameworkBeanFile" default="#variables.files.DI.DICoreFrameworkBeanFile#" />
	<cfargument name="DIApplicationsBeanFile" default="#variables.files.DI.DIApplicationsBeanFile#" />
	<cfargument name="codeBaseRealitivePath" default="#variables.path.codeBaseRealitivePath#" />
	<cfargument name="UIRealitivePath" default="#variables.path.UIRealitivePath#" />
	<cfargument name="CSSRealitivePath" default="#variables.path.CSSRealitivePath#" />
	<cfargument name="ImagesRealitivePath" default="#variables.path.ImagesRealitivePath#" />
	<cfargument name="JavaScriptRealitivePath" default="#variables.path.JavaScriptRealitivePath#" />
	<cfargument name="FigFactorIncludesRealitivePath" default="#variables.path.FigFactorIncludesRealitivePath#" />
	<cfargument name="RenderHandlersRealitivePath" default="#variables.path.RenderHandlersRealitivePath#" />
	<cfargument name="RenderHandlerIncludesRealitivePath" default="#variables.path.RenderHandlerIncludesRealitivePath#" />
	<cfargument name="iniFileName" default="#variables.files.iniFileName#" />
	<cfargument name="hasMixen" default="#variables.hasMixen#" />
	
	<!--- see note below when setting server.factory --->
	<cfset var server = structNew() />
	
	<!--- regex up 4 directories to the root of this commonspot site --->
	<cfset var webRoot = GetDirectoryFromPath(
		GetCurrentTemplatePath()
			).ReplaceFirst(
			"([^\\\/]+[\\\/]){4}$", ""
		)/>	
	
	<cfif variables.hasMixen eq true>
		<cfset OnFigFactorFrameworkLoad() />	
	</cfif>

	<cfset setWebRootPath(webRoot) />

	<cfset setFrameworkPath(argumentCollection = arguments) />
	
	<!--- 
		On Mac OS X running under TomCat the service cant be created in the
		setDependencies() method for some reason. So make it here.
	 --->
	<cfset server.factory = createObject('java','coldfusion.server.ServiceFactory') />
	

	<!---  
		This method has a real slick way to add server mappings by calling the 
		ColdFusion server via java. Heres how it works: 
		
		<cfset server.factory = createObject('java','coldfusion.server.ServiceFactory') />
		<cfset serverMappings = server.factory.runtimeService.getMappings() />
		<cfset serverMappings["/fooFramework"] = "/Users/allenj/development/fooFramework" />
		
		But I'm not 100% sure that this will run on a very locked down server and
		FigFactor HAS to have some sort of DI framework, currently ColdSpring.
		So if this fails we copy the DI framework to the web root.
	--->
	<cfif variables.hasMixen eq true>
		<cfset OnFigFactorDependencyLoad()>
	</cfif>
	
	<!--- 
		Make the server mappings or copy the needed supporting frameworks to the
		web root if it fails.
	 --->
	<cfset setDependencies(server.factory) />
	
	<cfset setDIConfigPath(argumentCollection = arguments) />

	<cfset setDIProperties(argumentCollection = arguments) />
	
	<cfif variables.hasMixen eq true>
		<cfset OnFigFactorDIFrameworkCreate() />
	</cfif>

	<cfset createDIFramework() />
	
	<cfif variables.hasMixen eq true>
		<cfset OnFigFactorBeanLoad() />
	</cfif>
	
	<!--- loads the xml bean definitions files  --->
	<cfset loadDIFramework(argumentCollection = arguments) />

	<!--- get Legacy all configured --->
	<cfset getFactory().getBean("Legacy").configure(this) />

	<!--- 
		Set the objects that the FigFactors API proxies, and other objects
		that public code uses all the time. The API's getBean() will 1st search
		private scope, 2nd the user supplied scope, 3 will request it from
		the DI container. So lets put the most commonly requested objects
		in the private scope so the getBean() funciton is super duper fast.
	--->
	<cfset variables.private.Bootstrapper = getFactory().getBean("BootStrapper") />
	<cfset variables.private.EventService = getFactory().getBean("EventService") />
	<cfset variables.private.ListService = getFactory().getBean("ListService") />
	<cfset variables.private.Config = getFactory().getBean("Config") />
	<cfset variables.private.FileMapper = getFactory().getBean("FileMapper") />
	<cfset variables.private.RenderHandlerService = getFactory().getBean("RenderHandlerService") />
	<cfset variables.private.MessageService = getFactory().getBean("MessageService") />
	<cfset variables.private.Logger = getFactory().getBean("Logger") />
	<cfset variables.private.Google = getFactory().getBean("Google") />
	<cfset variables.private.DataService = getFactory().getBean("DataService") />
	<cfset variables.private.Logger.setMessage(message = "FigFactorMixen.cfm file included? #variables.hasMixen#") />
	
	<cfreturn this />
</cffunction>



<!--- getBean --->
<cffunction name="getBean" output="false"
	displayname="Get Bean" hint="I return a component by name. Return Type: component."
	description="I return a component by name from 1st the private scope, 2nd the users scope, and 3rd the DI framework. Return Type: component.">
	
	<cfargument name="beanName" 
		hint="I am the name of the bean to retrieve. I am requried. Type: String." />

	<cfif structKeyExists(variables.private, arguments.beanName)>
		<cfreturn variables.private[arguments.beanName] />
	<cfelseif structKeyExists(variables.private.userSuppliedApplications, arguments.beanName)>
		<cfreturn variables.private.userSuppliedApplications[arguments.beanName] />
	<cfelse>
		<cfreturn variables.private.DIFramework.getBean(argumentCollection = arguments) />
	</cfif>
</cffunction>



<!--- getBeanDefinitionList --->
<cffunction name="getBeanDefinitionList" output="false"
    displayname="Get Bean Definition List" hint="I return a structure with all my avaiable beans. Return Type: Struct"
    description="I return the DI frameworks bean definitions strcuture and user scoped beans. Return Type: struct.">
    
	<cfset var beans = variables.private.DIFramework.getBeanDefinitionList() />
	
	<cfset StructAppend(beans, variables.private.userSuppliedApplications) />
	
    <cfreturn beans />
</cffunction>



<!--- getConfiguration --->
<cffunction name="getConfiguration" output="false"
	displayname="Get Configuration" hint="I return my current configuraion values. Return Type: Struct."
	description="I act as a proxy to return the SystemConfigurationBean.cfc instance data as a structure.  Return Type: Struct.">

	<cfreturn variables.private.Config.getInstance() />
</cffunction>



<!--- getDIProperties --->
<cffunction name="getDIProperties" access="public" output="false"
	displayname="Get DIProperties" hint="I return the DIProperties property. Return Type: struct." 
	description="I return the DIProperties property to my internal instance structure. Return Type: void.">

	<cfreturn variables.instance.DIProperties />
</cffunction>



<!--- getElementData --->
<cffunction name="getElementData" output="false" 
	displayname="Get Element Data" hint="I return a CommonSpot elements data. Return Type: any." 
	description="Returns an easy to use array or structure, depending on element type and or the elements data. Return Type: any.">
	
	<cfargument name="elementInfo" hint="I am the CommonSpot elements elementInfo structure. I am required. Type: Struct" />
	<cfargument name="elementType" hint="I am a string that should match a CommonSpots element type.  I am required. Type: String." />

	<cfset var RenderHandlerService = variables.private.RenderHandlerService.init(arguments.elementInfo) />
	<cfset var elementData = RenderHandlerService.getElementData(arguments.elementType) />
	
	<!--- 
		TODO: Need to add the other element types that we always want to be an array.
	--->
	<!--- 
		Always return an array if a linkBar, else check if it's just an array 
		with 1 index, and if it is, just return the data of index 1. Makes 
		things a whole lot easer for view to work with.
	--->
	<cfif elementType neq "linkBar" and isArray(elementData) and arrayLen(elementData) eq 1>
		<cfset elementData = elementData[1] />
	</cfif>

	<cfreturn elementData />
</cffunction>



<!--- getEvent --->
<cffunction name="getEvent" output="false"	
	displayname="Get Event" hint="I return the requests Event object. Return Type: component."
	description="I act as a proxy for the EventService.cfc to get an Event object. Return Type: component.">

	<cfreturn variables.private.EventService.getEvent() />
</cffunction>



<!--- getFactory --->
<cffunction name="getFactory" output="false"
    displayname="Get Factory" hint="I return FigFactors DI framework. Return Type: component."
    description="I return FigFactors DI framework - currently ColdSpring. Return Type: component">

    <cfreturn variables.private.DIFramework />
</cffunction>



<!--- getFrameworkPath --->
<cffunction name="getFrameworkPath" output="false"
	displayname="Get FrameworkPath" hint="I return the FrameworkPath property. Return type: String" 
	description="I return the FrameworkPath property of my internal instance structure. Return type: String">

	<cfreturn variables.instance.FrameworkPath />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- getDIConfiguration --->
<cffunction name="getDIConfiguration" output="false"	
	displayname="Get DI Configuration" hint="I return a struct with information about the DI framework."
	description="I return a struct with information about the DI framework.">
    
	<cfset var data = structNew() />
	
	<cfset data.DIConfigProperties = getDIProperties() />
	<cfset data.DIXML = variables.files.DI />
	<cfset data.beans = getBeanDefinitionList() />
	<cfset data.DIProperties = getFactory().getDefaultProperties() />
	
	<cfreturn data />
</cffunction>



<!--- getList --->
<cffunction name="getList" output="false"	
	displayname="Get List" hint="I return a list by name. Return Type: string."
	description="I return a list by name. Return Type: string.">
    
	<cfargument name="name" hint="I am the name of the list to return. I am required. Type: String. Required." />
	
	<cfreturn variables.private.ListService.getList(argumentCollection = arguments) />
</cffunction>



<!--- loadApplication --->
<cffunction name="loadApplication" output="false"
	displayname="Load Application" hint="I load an application into the framework. Return Type: string - a message about what happened."
	description="I load an application into the framework. Pass me a component and a name or just the path to the DI config file. Return Type: string - a message about what happened.">
	
	<cfargument name="cfc" type="component" required="false" 
		hint="I am the applications main component." />
	<cfargument name="name" type="string" required="false" 
		hint="I am the name of the application to register it by." />
	<cfargument name="beanDefinitionConfigFile" type="string" required="true" 
		hint="I am absolute path to the DI framework configuration file." />
	<cfargument name="fileMap" type="xml" required="false" 
		hint="I am absolute path to the DI framework configuration file." />
	
	<cfset var result = "" />
	
	<cfif isDefined("arguments.cfc") and isDefined("arguments.name")>
		<cfset variables.private.userSuppliedApplications[arguments.name] = arguments.cfc />
		<cfset result = "The application was sucessfully loaded under the name: #arguments.name#" />
	<cfelseif isDefined("arguments.beanDefinitionConfigFile")>
		<cfset getFactory().loadBeans(arguments.beanDefinitionConfigFile) />	
		<cfset result = "The application was sucessfully loaded into the DI framework." />
	</cfif>
	
	<cfif not len(result)>
		<cfset result = "No application was loaded. No component with a name or a DI config file was passed to me." />
	</cfif>
	
	<cfset variables.private.Logger.setMessage(message="#result#") />
	
	<cfreturn result />
</cffunction>



<!--- setConfigValues --->
<cffunction name="setConfigValues" output="false"
	displayname="Set Config Values" hint="I add configuration values to my configuration object. Return Type: void."
	description="I add configuration values to my configuration object. Used when applications need to add configuration data that other applications might find usefull..">
	
	<cfargument name="values" 
		hint="I am a structure of values to overrite or add to my internall configuration object. Type: Struct. Required." />
	
	<!--- TODO: implement when the new Config Strategy is implented --->
</cffunction>



<!--- setFileMap --->
<cffunction name="setFileMap" output="false"
	displayname="Set File Mapping" hint="I add a File Map object to the system. Return Type: string - a message about what happened."
	description="I add a File Map object to the system. Applications of the framework which need files copied from the user directory into the framework will need to register a 'file mapping'. Return Type: string - a message about what happened.">
	
	<cfargument name="allowedExtensions" type="string" required="false" default="" 
		hint="I am a list of allowed extensions to filter by. I default to an empty string." />
	<cfargument name="MapName" type="string" required="false" default="" 
		hint="I am the name of the mapping. I default to an empty string." />
	<cfargument name="FileName" type="string" required="false" default="" 
		hint="I am the name of a single file to copy. I default to an empty string." />
	<cfargument name="Source" type="string" required="false" default="" 
		hint="I am the source directory. I default to an empty string." />
	<cfargument name="Destination" type="string" required="false" default="" 
		hint="I am the Destination directory. I default to an empty string." />
	<cfargument name="Recursive" type="boolean" required="false" default="false" 
		hint="Should I recursivly copy all of a directories files? I default to 'false' ." />
	<cfargument name="nameConfilct" type="string" required="false" default="overwrite"
		hint="Should I over write single files? I default to ""overwrite"". I must be a valid attribute value for the CFML tag cffile nameconflict attribute." />
	<cfargument name="configFIle" type="string" required="false"
		hint="I am the absolute path to a valid FileMap XML config file. Use this method for the easest way to add a file mapping." />
	
	<cfset var result = "" />
	
	<cfif isDefined("arguments.Source") and isDefined("arguments.Destination") and isDefined("arguments.MapName")>
		<!--- TODO: Implement! --->	
	</cfif>
	
	<cfif isDefined("arguments.configFIle")>
		<!--- TODO: Implement! --->	
	</cfif>
		
	<cfif not len(result)>
		<cfset result = "No FileMap was set. No arguments passed to me allowed an action to take place." />
	</cfif>
	
	<cfset variables.private.Logger(message = "#result#") />
	
	<cfreturn result />
</cffunction>



<!--- setList --->
<cffunction name="setList" output="false"
	displayname="Set List" hint="I add a list to the framework. Return Type: void."
	description="I add a list to the List Service. Use this method to add lists that all applications or CommonSpot might need. Return Type: void.">
	
	<cfargument name="name" type="string" required="true" 
		hint="I am the name of the list to register. I am requried." />
	<cfargument name="list" type="string" required="true" 
		hint="I am the list to register under a name. I am requried." />

	<cfset variables.private.ListService.setList(argumentCollection = arguments) />
</cffunction>



<!--- replicate --->
<cffunction name="replicate" output="false"
	displayname="Replicate" hint="I replicate my internal data to Read Only Production Servers. Return Type: void."
	description="After replication happens, I am called to sync my internal data with any other servers registerd as Read Only Production Servers in this instance of CommonSpot. Return Type: void.">
	
	<!--- TODO: Implement --->
</cffunction>



<!--- getWebRootPath --->
<cffunction name="getWebRootPath" output="false"
	displayname="Get WebRootPath" hint="I return the WebRootPath property. Return Type: String." 
	description="I return the WebRootPath property to my internal instance structure. Return type: String">

	<cfreturn variables.instance.WebRootPath />
</cffunction>



<!--- getPageEvent --->
<cffunction name="getPageEvent" output="false"
	displayname="Get Page Event" hint="I return the getEvent() method. I AM DEPRICIATED. Return Type: component."
	description="I return the getEvent() method. I AM DEPRICIATED. Return Type: component.">
	
	<cfreturn getEvent() />
</cffunction>



<!--- ****************************** Package ****************************** --->
<!--- ****************************** Private ****************************** --->

<!--- setDependencies --->
<cffunction name="setDependencies" access="private" output="false"	
	displayname="Set Dependencies" hint="I add mappings FigFactor needs to the server. Return Type: void"
	description="I add mappings the FigFactor needs by acting onColdFusions coldfusion.server.ServiceFactory.runtimeService.getMappings() has map. Return Type: void.">
	
	
	<cfargument name="cfServerFactory" />
	
	<cfset var server = 0 />
	<cfset var serverMappings = 0 />
	<cfset var thePath = "" />
	<cfset var mappings = structNew() />
		
	<cfset thePath = getFrameworkPath() & "com/system/util/frameworks/" />


	<cfif not isDefined("arguments.cfServerFactory")>
		<cfset installRequiredFrameworks() />
	<cfelse>
		<cfset serverMappings = arguments.cfServerFactory.runtimeService.getMappings() />

	
		<cfset mappings.ModelGlue = thePath & "ModelGlue"/>
		<cfset mappings.coldspring = thePath & "coldspring"/>
		<cfset mappings.edmund = thePath & "edmund"/>
		<cfset mappings.Transfer = thePath & "transfer"/>
	
		<!--- Always add the FigFactor mapping --->
		<cfset serverMappings["/FigFactor"] = "#getFrameworkPath()#" />
		
		<!--- only add if they are not present --->
		<cfif not structKeyExists(serverMappings, "ModelGlue")>
			<cfset serverMappings["/ModelGlue"] = "#mappings.ModelGlue#" />
		</cfif>
		
		<cfif not structKeyExists(serverMappings, "coldspring")>
			<cfset serverMappings["/coldspring"] = "#mappings.coldspring#" />
		</cfif>
		
		<cfif not structKeyExists(serverMappings, "edmund")>
			<cfset serverMappings["/edmund"] = "#mappings.edmund#" />
		</cfif>
		
		<cfif not structKeyExists(serverMappings, "transfer")>
			<cfset serverMappings["/transfer"] = "#mappings.Transfer#" />
		</cfif>
	</cfif>
	
	
</cffunction>



<!--- installRequiredFrameworks --->
<cffunction name="installRequiredFrameworks" output="false"	
	displayname="Install Required Frameworks" hint="I copy the DI Framework and Admin front controller frameworks to the web root."
	description="I copy the DI Framework and Admin front controller frameworks to the web root.">

	<cfset var UDF = createObject("component", "com.system.util.udf.UDFLib").init() />
	<cfset var ColdSpringSource = getFrameworkPath() & "com/system/util/frameworks/coldspring/" />
	<cfset var ColdSpringDestination = getDirectoryFromPath(expandPath("/")) &  "coldspring/" />
	<cfset var ModelGlueSource = getFrameworkPath() & "com/system/util/frameworks/ModelGlue" />
	<cfset var ModelGlueDestination = getDirectoryFromPath(expandPath("/")) &  "ModelGlue/" />
	
	<cftry>	
		<cfdirectory action="create" directory="#ColdSpringDestination#" mode="777" />
		<cfdirectory action="create" directory="#ModelGlueDestination#" mode="777" />
		<cfcatch></cfcatch>
	</cftry>

	<cfset UDF.directoryCopy(source = ColdSpringSource, destination = ColdSpringDestination) />
   	<cfset UDF.directoryCopy(source = ModelGlueSource, destination = ModelGlueDestination) />
		
</cffunction>



<!--- getDIConfigPath --->
<cffunction name="getDIConfigPath" access="private" output="false"
	displayname="Get DIConfigPath" hint="I return the DIConfigPath property. Return Type: string." 
	description="I return the DIConfigPath property to my internal instance structure.">

	<cfreturn variables.instance.DIConfigPath />
</cffunction>



<!--- loadDIFramework --->
<cffunction name="loadDIFramework" access="private" output="false"	
	displayname="Load DI Framework" hint="I load the Inversion Of Controll Framework, currently ColdSpring. Return Type: void."
	description="I load the Inversion Of Controll Framework, currently ColdSpring. Return Type: void.">

	<cfargument name="DIBootStrapperBeanFile" 
		hint="I am the name of the BootStrapper XML bean definition file. I am requried. Type: string." />
	<cfargument name="DICoreFrameworkBeanFile" 
		hint="I am the name of the Core Framework XML bean definition file. I am requried. Type: string." />
	<cfargument name="DIApplicationsBeanFile" 
		hint="I am the name of the Applications XML bean definition file. I am requried. Type: string." />
    
	<cfset var DIFramework = getFactory() />
	
	<cfset DIFramework.loadBeans(getDIConfigPath() & arguments.DIBootStrapperBeanFile) />
	<cfset DIFramework.loadBeans(getDIConfigPath() & arguments.DICoreFrameworkBeanFile) />
	<cfset DIFramework.loadBeans(getDIConfigPath() & arguments.DIApplicationsBeanFile)  />
	
</cffunction>



<!--- setDIConfigPath --->
<cffunction name="setDIConfigPath" access="private" output="false"
	displayname="Set DIConfigPath" hint="I set the DIConfigPath property. Return Type: void." 
	description="I set the DIConfigPath property to my internal instance structure. Return Type: void.">

	<cfargument name="realitivePathToDIConfigFiles" type="string" default="com/system/config/coldspring/" 
		hint="I am the realitive path to the DI config files. I am requried." />

	<cfset variables.instance.DIConfigPath = getFrameworkPath() & arguments.realitivePathToDIConfigFiles />

</cffunction>



<!--- setFrameworkPath --->
<cffunction name="setFrameworkPath" access="private" output="false"
	displayname="Set FrameworkPath" hint="I set the FrameworkPath property. Return Type: void." 
	description="I set the FrameworkPath property to my internal instance structure. Return Type: void.">

	<cfargument name="realitiveFrameworkPath" default="customcf/com/figleaf/figfactor/" 
		hint="I am the realitive path to the DI config files. I am requried. Type: string." />

	<cfset variables.instance.FrameworkPath = getWebRootPath() & arguments.realitiveFrameworkPath />

</cffunction>



<!--- setWebRootPath --->
<cffunction name="setWebRootPath" access="private" output="false" 
	displayname="Set WebRootPath" hint="I set the WebRootPath property.  Return Type: void." 
	description="I set the WebRootPath property to my internal instance structure. Return Type: void.">
	
	<cfargument name="WebRootPath"
		hint="I am the WebRootPath property. I am required. Type String."/>
	
	<cfset variables.instance.WebRootPath = arguments.WebRootPath />
</cffunction>



<!--- setDIProperties --->
<cffunction name="setDIProperties" access="private" output="false"
	displayname="Set DIProperties" hint="I set the DIProperties property. Return Type: void." 
	description="I set the DIProperties property to my internal instance structure. Return Type: void.">

	<cfset var props = structNew() />

	<!--- the servers web root --->
	<cfset props.serverRootPath = getDirectoryFromPath(expandPath("/")) />
	<!--- all the paths in the variables scope --->
	<cfset props.frameworkPath = getFrameworkPath() />
	<cfset props.webRootPath = getWebRootPath() />
	<cfset props.realitiveFrameworkPath = arguments.realitiveFrameworkPath />
	<cfset props.realitivePathToDIConfigFiles = arguments.realitivePathToDIConfigFiles />
	<cfset props.codeBaseRealitivePath = arguments.codeBaseRealitivePath />
	<cfset props.UIRealitivePath = arguments.UIRealitivePath />
	<cfset props.CSSRealitivePath = arguments.CSSRealitivePath />
	<cfset props.ImagesRealitivePath = arguments.ImagesRealitivePath />
	<cfset props.JavaScriptRealitivePath = arguments.JavaScriptRealitivePath />
	<cfset props.FigFactorIncludesRealitivePath = arguments.FigFactorIncludesRealitivePath />
	<cfset props.RenderHandlersRealitivePath = arguments.RenderHandlersRealitivePath />
	<cfset props.RenderHandlerIncludesRealitivePath = arguments.RenderHandlerIncludesRealitivePath />
	<cfset props.iniFileName = arguments.iniFileName />
	<cfset props.hasMixen = arguments.hasMixen />
	
	<cfset variables.instance.DIProperties = props />
</cffunction>



<!--- createDIFramework --->
<cffunction name="createDIFramework" access="public" output="false"	
	displayname="Create DI Framework" hint="I create the DI framework. Return Type: void."
	description="I create the DI framework. Return Type: void.">
    
	<cfset variables.private.DIFramework = 
		createObject("component", "coldspring.beans.DefaultXMLBeanFactory").init(
			structNew(), 
			getDIProperties()
		) />

</cffunction>
</cfcomponent>