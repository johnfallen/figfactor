<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			SystemFactory.cfc
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I initalize and persist objects for the Fig Leaf System
Modification Log:
Name 			Date 					Description

================================================================================
John Allen 		19/08/2008			Created

------------------------------------------------------------------------------->
<cfcomponent displayname="System Factory" output="false"
	hint="I initalize and persist globally used objects of the Fig Leaf System">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="SystemFactory" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.
		<br /><br />
		I throw an error if I can't find my 'systemconfiguration.ini.cfm' file">

	<cfargument name="frameworkPath" type="string" required="true"
		hint="I am the path to the customcf/org/figleaf directory.<br />I am requried." />
	<cfargument name="bootStrapTrace" type="array" required="false"
		hint="I am the trace array from the BootStrapper component." />
	
	<cfset var thetime = 0 />
	<cfset var x = 0 />

	<!---  
	These are objects that are system wide: "permant members" if you will.
	Applications are not currnetly added to the variables.instance scope, they are 
	added only if requested from the figfactorbootstrapper.cfm file.
	
	But... if any new applications are baked in, and all other applications will
	then become requred to have them, this new "theroitical application" should
	be created and set in to the instance structure.
	
	The ElementFactory is a good example. Both ViewFramework and DataService
	need to know the name and some other things about each request, so
	ElementService is now a requirement of 2 applications. So make it a 
	"permant member" of the FigFactor variables.instace structure.
	--->

	<cfset variables.instance.ConfigBean = 0 />
	<cfset variables.instance.CacheProxy = 0 />
	<cfset variables.instance.Email = 0 />
	<cfset variables.intance.Emergency = 0 />
	<cfset variables.instance.Logger =  0 />
	<cfset variables.instance.UDFLibrary = 0 />
	<cfset variables.instance.Input = 0 />
	<cfset variables.instance.BeanUtils = 0 />
	
	<!--- 
	This is an  "application" but it is set as a permanent member of the
	factory because more than one application uses it. Currently
	ViewFramework, DataServce, and the Admin.
	--->
	<cfset variables.instance.ElementFactory = 0 />
	<cfset variables.instance.installedApplications = structNew() />
	<cfset variables.logString = "SYSTEM FACTORY:" />
	<cfset variables.objectBuild = variables.logString & " SYSTEM OBJECT BUILD:">
	<cfset variables.appBuild = variables.logString & " APPLICATION BUILD:">

	<!--- make the logger first --->
	<cfset variables.instance.Logger = createObject("component", "logger.LoggerAdapter").init() />
	
	<!--- the code that logs the End Initalizing log section is in the figleafbootstrapper.cfm --->
	<cfset variables.instance.Logger.setMessage(message = "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=")>
	<cfset variables.instance.Logger.setMessage(message = "+=+=+=+=+ Start Initalizing =++=+=+=")>
	
	<!--- 
	Log the messages from the FigFactor Boot Straper 
	--->
	<cfloop from="1" to="#arrayLen(arguments.bootStrapTrace)#" index="x">
		<cfset getBean("logger").setMessage(message = "#arguments.bootStrapTrace[x]#" ) />	
	</cfloop>
	
	<!--- 
	Log the creation of each System object. 
	--->
	<cfset variables.instance.Logger.setMessage(message = "***** Start Core Component Creation *******")>
	
	<!--- Configuration Bean --->
	<cftry>
		<cfset thetime = gettickcount() />
		<cfset variables.instance.Logger.setMessage(
			message = "#variables.objectBuild# ConfigBean start up attempt... ") />

		<cfset variables.instance.ConfigBean = createObject("component", "config.SystemConfigBean").init(
			frameworkPath = "#arguments.frameworkPath#") />
		
		<cfset thetime = gettickcount() - thetime />
		<cfset getBean("logger").setMessage(
			message = "#variables.objectBuild# ConfigBean instanciated. Init Time = #thetime#. ") />
		<cfcatch>
			<cfthrow message="Oops! ERROR creating the config bean.">
		</cfcatch>
	</cftry>


	<!--- ElementFactory--->
	<cfset variables.instance.ElementFactory = getElementFactory() />
	
	
	<!---  Cache --->
	<cftry>
		<cfset thetime = gettickcount() />
		<cfset variables.instance.Logger.setMessage(
			message = "#variables.objectBuild# Cache start up attempt... ") />
		
		<cfset variables.instance.CacheProxy = createObject("component", "cache.CacheProxy").init(
			defaultCache = variables.instance.ConfigBean.getDefaultCache(),
			cacheType = variables.instance.ConfigBean.getDefaultCache(),
			cacheTimeSpan = variables.instance.ConfigBean.getCacheTimeSpan(),
			cacheTimeValue = variables.instance.ConfigBean.getCacheTimeValue(),
			cacheReapTime = variables.instance.ConfigBean.getCacheReapTime(),
			dataNotFound = variables.instance.ConfigBean.getConstants().DATANOTFOUND) />
		
		<cfset thetime = gettickcount() - thetime />
		<cfset getBean("logger").setMessage(
			message = "#variables.objectBuild# Cache instanciated. Init Time = #thetime#. Cach being used: #variables.instance.ConfigBean.getDefaultCache()#") />
		<cfcatch>
			<cfthrow message="Oops! ERROR creating the default Cache SystemFactory." />
		</cfcatch>
	</cftry>
	
	
	<!--- Email --->
	<cftry>
		<cfset thetime = gettickcount() />
		<cfset variables.instance.Logger.setMessage(
			message = "#variables.objectBuild# Email start up attempt... ") />
		
		<cfset variables.instance.Email = createObject("component", "util.Email").init(
			ConfigBean = variables.instance.ConfigBean) />
		
		<cfset thetime = gettickcount() - thetime />
		<cfset getBean("logger").setMessage(
			message = "#variables.objectBuild# Email instanciated. Init Time = #thetime#. ") />
		<cfcatch>
			<cfthrow message="Oops! ERROR creating the Email. SystemFactory." />
		</cfcatch>
	</cftry>


	<!--- Emergency --->
	<cftry>
		<cfset thetime = gettickcount() />
		<cfset variables.instance.Logger.setMessage(
			message = "#variables.objectBuild# Emergency start up attempt... ") />
		
		<cfset variables.intance.Emergency =  createObject("component", "util.EmergencyService").init(
			ConfigBean	= variables.instance.ConfigBean) />
		
		<cfset thetime = gettickcount() - thetime />
		<cfset getBean("logger").setMessage(
			message = "#variables.objectBuild# Emergency instanciated.  Init Time = #thetime#. ") />
		<cfcatch>
			<cfthrow message="Oops! ERROR creating the Emergency. SystemFactory." />
		</cfcatch>
	</cftry>


	<!--- Input --->
	<cftry>
		<cfset thetime = gettickcount() />
		<cfset variables.instance.Logger.setMessage(
			message = "#variables.objectBuild# Input start up attempt... ") />	
		
		<cfset variables.instance.Input = createObject("component", "input.Input").init(
			presidence	= variables.instance.ConfigBean.getInputPresidence()) />
		
		<cfset thetime = gettickcount() - thetime />
		<cfset getBean("logger").setMessage(
			message = "#variables.objectBuild# Input instanciated.  Init Time = #thetime#. ") />
		<cfcatch>
			<cfthrow message="Oops! ERROR creating the Input. SystemFactory." />
		</cfcatch>
	</cftry>


	<!--- UDF --->
	<cftry>
		<cfset thetime = gettickcount() />
		<cfset variables.instance.Logger.setMessage(
			message = "#variables.objectBuild# UDF start up attempt... ") />	
		
		<cfset variables.instance.UDFLibrary = createObject("component", "udf.UserDefinedFunctionsLibrary").init() />
		
		<cfset thetime = gettickcount() - thetime />
		<cfset getBean("logger").setMessage(
			message = "#variables.objectBuild# UDF instanciated.  Init Time = #thetime#. ") />
		<cfcatch>
			<cfthrow message="Oops! ERROR creating the UDF Library. SystemFactory." />
		</cfcatch>
	</cftry>


	<!--- BeanUtils --->
	<cftry>
		<cfset thetime = gettickcount() />
		<cfset variables.instance.Logger.setMessage(
			message = "#variables.objectBuild# BeanUtils start up attempt... ") />	
		
		<cfset variables.instance.BeanUtils = createObject("component", "frameworks.beanutils.BeanUtils").init() />
		
		<cfset thetime = gettickcount() - thetime />
		<cfset getBean("logger").setMessage(
			message = "#variables.objectBuild# BeanUtils instanciated.  Init Time = #thetime#. ") />
		<cfcatch>
			<cfthrow message="Oops! ERROR creating the BeanUtils. SystemFactory." />
		</cfcatch>
	</cftry>
	
	
	<!--- FileSystem --->
	<cftry>
		<cfset thetime = gettickcount() />
		<cfset variables.instance.Logger.setMessage(
			message = "#variables.objectBuild# FileSystem start up attempt... ") />	
		
		<cfset variables.instance.FileSystem = createObject("component", "util.FileSystem").init() />
		
		<cfset thetime = gettickcount() - thetime />
		<cfset getBean("logger").setMessage(
			message = "#variables.objectBuild# FileSystem instanciated.  Init Time = #thetime#. ") />
		<cfcatch>
			<cfdump var="#cfcatch#">
			<cfabort />
			<cfthrow message="Oops! ERROR creating the FileSystem. SystemFactory." />
		</cfcatch>
	</cftry>
	
	<cfset variables.instance.Logger.setMessage(message = "***** End Core Component Creation *******") />

	<cfreturn this />
</cffunction>



<!--- getAllBeans --->
<cffunction name="getAllBeans" returntype="any" access="public" output="false"
	displayname="Get All Beans" hint="I return all of my default obects and installed objects."
	description="I return all of my default obects and installed objects.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- getBean --->
<cffunction name="getBean" returntype="any" access="public" output="false"
	displayname="Get Bean" hint="I return a system object by name."
	description="I return one of the system objects by name, such as the Cache, Logger or ScopeFacade.">
	
	<cfargument name="name" type="string" required="true"
		hint="I am the name of an object to return.<br />I am required." />
	
	<cfswitch expression="#arguments.name#">
		
		<cfcase value="all">
			<cfreturn variables.instance />
		</cfcase>
		<cfcase value="BeanFactory">
			<cfreturn this />
		</cfcase>
		<cfcase value="BeanUtils">
			<cfreturn variables.instance.BeanUtils />
		</cfcase>
		<cfcase value="cache">
			<cfreturn variables.instance.CacheProxy.getCache(arguments) />
		</cfcase>
		<cfcase value="ConfigBean,Config">
			<cfreturn variables.instance.ConfigBean />
		</cfcase>
		<cfcase value="Emergency">
			<cfreturn variables.intance.Emergency />
		</cfcase>
		<cfcase value="Email">
			<cfreturn variables.instance.Email />
		</cfcase>
		<cfcase value="Input">
			<cfreturn createObject("component", "input.Input").init(argumentCollection = arguments) />
		</cfcase>
		<cfcase value="logger">
			<cfreturn variables.instance.Logger />
		</cfcase>
		<cfcase value="MapCollection">
			<cfreturn createObject("component", "collections.MapCollection").init() />
		</cfcase>	
		<cfcase value="UDFLibrary,udf">
			<cfreturn variables.instance.UDFLibrary />
		</cfcase>
		<cfcase value="ElementFactory">
			<cfreturn variables.instance.ElementFactory />
		</cfcase>
		<cfcase value="FileSystem">
			<cfreturn variables.instance.FileSystem />
		</cfcase>

		<!--- installed applications --->
		<cfcase value="Authentication">
			<cfif left(server.coldfusion.productVersion, 1) gt 7>
				<cfreturn  getAuthentication() />
			<cfelse>
				<cfreturn  getAuthentication() />
			</cfif>
		</cfcase>
		<cfcase value="ViewFactory,ViewFramework">
			<cfreturn getViewFramework() />
		</cfcase>
		<cfcase value="FLEET">
			<cfreturn  getFleet() />
		</cfcase>
		<cfcase value="Dataservice">
			<cfreturn  getDataservice() />
		</cfcase>
		<cfcase value="Validator">
			<cfreturn  getValidator() />
		</cfcase>
		<cfcase value="Multimedia">
			<cfreturn  getMultimedia() />
		</cfcase>
		<cfcase value="Google">
			<cfreturn  getGoogle() />
		</cfcase>
		
		<cfdefaultcase>
			<cfset getBean("logger").setMessage(
				type="ERROR",
				message = "A bean was requested from SystemFactory.cfc and not found. Requested Bean: '#arguments.name#'.") />
			<cfreturn "No object of  type '#arguments.name#' was found" />
		</cfdefaultcase>
	</cfswitch>
</cffunction>



<!--- getInstalledApplications --->
<cffunction name="getInstalledApplications" returntype="struct" access="public" output="false"
	displayname="Get Installed Applications" hint="I return a struct of data with the installed applications."
	description="I return a struct of data with the installed applications.">
	
	<cfreturn variables.instance.installedApplications  />
</cffunction>



<!--- setApplicationBean --->
<cffunction name="setApplicationBean" returntype="void" access="public" output="false"
    displayname="Set Applicaiton Bean" hint="I set a applicaiton bean into my internal scope."
    discription="I set a applicaiton bean into my internal scope.">
		
	<cfargument name="key" type="string" required="true" 
		hint="I am the name of the application.<br />I a requried." />
	<cfargument name="value" type="any" required="true" hint="I am the application.<br />I am required.">
    
	<!--- put the incomming data in the instace scope under the supplied key --->
	<cfset variables.instance[arguments.key] = arguments.value />
	
	<!--- also set this for reporting --->
	<cfset variables.instance.installedApplications[arguments.key] = "#arguments.key#" />
	
</cffunction>

<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- getMultimedia --->
<cffunction name="getMultimedia" returntype="any" access="private" output="false"
	displayname="Get Multimedia" hint="."
	description=".">

	<!--- set the root directory of the application --->
	<cfset var thePath = getBean("configbean").getFigleafFilePath() & "/com/applications/multimedia/config/ColdSpring.xml" />

	<cfset variables.instance.FigFactorMultiMediaFactory = createObject("component", "coldspring.beans.DefaultXMLBeanFactory").init() />
	<cfset variables.instance.FigFactorMultiMediaFactory.loadBeansFromXMLFile('#thePath#', true) />

	<cfreturn variables.instance.FigFactorMultiMediaFactory />
</cffunction>



<!--- getGoogle --->
<cffunction name="getGoogle" returntype="any" access="public" output="false"
	displayname="Get Google" hint="I return the Google helper application."
	description="I return the Google helper application object.">
	
	<cfset var thetime = 0 />
	<cfset var Google = 0 />
	<cfset var componentPath = getBean("ConfigBean").getFigLeafApplicationComponentContext() />
	<cfset var args = StructNew() />
	<cfset args.BeanFactory = getBean("BeanFactory") />
	
	<cftry>
		<cfset thetime = gettickcount() />
		<cfset getBean("logger").setMessage(message = "#variables.objectBuild# Google start up attempt... ") />
		
		<cfinvoke component="#componentPath#google.Google" method="init" 
			argumentcollection="#args#" returnvariable="Google" />

		<cfset variables.instance.installedApplications.Google = "Google" />

		<cfset thetime = gettickcount() - thetime />
		<cfset getBean("logger").setMessage(
			message = "#variables.objectBuild#  Google installed. Init Time = #thetime#. ") />
	
		<cfcatch>
			<cfset getBean("logger").setMessage(
				type = "warn",
				message = "#variables.objectBuild# WARN WARN!! Google not installed. ERROR: #cfcatch.message#") />
			<cftry>
				<cfinclude template="util/error.cfm" />
				<cfcatch></cfcatch>
			</cftry>
		</cfcatch>
	</cftry>
	
	<cfreturn Google />
</cffunction>



<!--- getValidator --->
<cffunction name="getValidator" returntype="any" access="public" output="false"
	displayname="Get Validator" hint="I return a new instance of the Validator."
	description="I return a new instance of the Validator.">
	
	<cfset var thetime = 0 />
	<cfset var Validator = 0 />
	<cfset var componentPath = getBean("ConfigBean").getFigLeafApplicationComponentContext() />
	<cfset var args = StructNew() />
	<cfset args.BeanFactory = getBean("BeanFactory") />
	
	<cftry>
		<cfset thetime = gettickcount() />
		<cfset getBean("logger").setMessage(message = "#variables.objectBuild# Validator start up attempt... ") />
		
		<cfinvoke component="#componentPath#validator.Validator" method="init" 
			argumentcollection="#args#" returnvariable="Validator" />

		<cfset variables.instance.installedApplications.Validator = "Validator" />		

		<cfset thetime = gettickcount() - thetime />
		<cfset getBean("logger").setMessage(
			message = "#variables.objectBuild#  Validator installed. Init Time = #thetime#. ") />
	
		<cfcatch>
			<cfset getBean("logger").setMessage(
				type = "warn",
				message = "#variables.objectBuild# WARN WARN!! Validator not installed. ERROR: #cfcatch.message#") />
			<cftry>
				<cfinclude template="util/error.cfm" />
				<cfcatch></cfcatch>
			</cftry>
		</cfcatch>
	</cftry>
	
	<cfreturn  Validator />
</cffunction>



<!--- getElementFactory --->
<cffunction name="getElementFactory" returntype="any" access="public" output="false"
	displayname="Get Element Factory" hint="I return a new instance of the ElementFactory."
	description="I return a new instance of the ElementFactory.">
	
	<cfset var thetime = 0 />
	<cfset var ElementFactory = 0 />
	<cfset var componentPath = getBean("ConfigBean").getFigLeafApplicationComponentContext() />
	<cfset var args = StructNew() />
	<cfset args.BeanFactory = getBean("BeanFactory") />
	
	<cftry>
		<cfset thetime = gettickcount() />
		<cfset getBean("logger").setMessage(message = "#variables.objectBuild# ELEMENTFACTORY start up attempt... ") />
		
		<cfinvoke component="#componentPath#elementfactory.ElementFactory" method="init" 
			argumentcollection="#args#" returnvariable="ElementFactory" />

		<cfset variables.instance.installedApplications.ElementFactory = "ElementFactory" />		

		<cfset thetime = gettickcount() - thetime />
		<cfset getBean("logger").setMessage(
			message = "#variables.objectBuild#  ELEMENTFACTORY installed. Init Time = #thetime#. ") />
	
		<cfcatch>
			<cfset getBean("logger").setMessage(
				type = "warn",
				message = "#variables.objectBuild# WARN WARN!! ELEMENTFACTORY not installed. ERROR: #cfcatch.message#") />
			<cftry>
				<cfinclude template="util/error.cfm" />
				<cfcatch></cfcatch>
			</cftry>
		</cfcatch>
	</cftry>
	
	<cfreturn  ElementFactory />
</cffunction>



<!--- getAuthentication --->
<cffunction name="getAuthentication" returntype="any" access="public" output="false"
	displayname="Get Authentication" hint="I return an initalized verison of Authentication."
	description="I return an initalized verison of Authentication.">
	
	<cfset var thetime = 0 />
	<cfset var Authentication = 0 />
	<cfset var componentPath = getBean("ConfigBean").getFigLeafApplicationComponentContext() />
	<cfset var args = StructNew() />
	<cfset args.BeanFactory = getBean("BeanFactory") />
	
	<cftry>
		<cfset thetime = gettickcount() />
		<cfset getBean("logger").setMessage(message = "#variables.appBuild# AUTHENTICATION start up attempt... ") />
		
		<cfinvoke component="#componentPath#authentication.Authentication" method="init" 
			argumentcollection="#args#" returnvariable="Authentication" />
	
		<cfset variables.instance.installedApplications.Authentication = "Authentication" />
		
		<cfset thetime = gettickcount() - thetime />		
		<cfset getBean("logger").setMessage(
			message = "#variables.appBuild#  AUTHENTICATION installed.  Init Time = #thetime#. ") />
	
	<cfcatch>
			<cfset getBean("logger").setMessage(
				message = "#variables.appBuild#  AUTHENTICATION not installed. ERROR: #cfcatch.message#") />
			<cftry>
				<cfinclude template="util/error.cfm" />
				<cfcatch></cfcatch>
			</cftry>
		</cfcatch>
	</cftry>
	
	<cfreturn  Authentication />
</cffunction>



<!--- getDataservice --->
<cffunction name="getDataservice" returntype="any" access="public" output="false"
	displayname="Get Dataservice" hint="I return an initalized verison of Dataservice."
	description="I return an initalized verison of Dataservice.">
	
	<cfset var thetime = 0 />
	<cfset var Dataservice = 0 />
	<cfset var componentPath = getBean("ConfigBean").getFigLeafApplicationComponentContext() />
	<cfset var args = StructNew() />
	<cfset args.BeanFactory = getBean("BeanFactory") />
	
	<cftry>
		<cfset thetime = gettickcount() />
		<cfset getBean("logger").setMessage(message = "#variables.appBuild# DATASERVICE start up attempt... ") />
		
		<cfinvoke component="#componentPath#dataservice.DataService" method="init" 
			argumentcollection="#args#" returnvariable="Dataservice" />
	
		<cfset variables.instance.installedApplications.Dataservice = "Dataservice" />
		
		<cfset thetime = gettickcount() - thetime />		
		<cfset getBean("logger").setMessage(
			message = "#variables.appBuild# DATASERVICE installed.  Init Time = #thetime#. ") />
	
	<cfcatch>
			<cfset getBean("logger").setMessage(
				type = "WARN",
				message = "#variables.appBuild# DATASERVICE not installed. ERROR: #cfcatch.message#") />
			<cftry>
				<cfinclude template="util/error.cfm" />
				<cfcatch></cfcatch>
			</cftry>
		</cfcatch>
	</cftry>
	
	<cfreturn Dataservice />
</cffunction>



<!--- getViewFramework --->
<cffunction name="getViewFramework" returntype="any" access="public" output="false"
	displayname="Get ViewFramework" hint="I return a new instance of ViewFramewrok."
	description="I create and return a new instance of ViewFramewrok.">
	
	<cfset var thetime = 0 />
	<cfset var ViewFramework = 0 />
	<cfset var componentPath = getBean("ConfigBean").getFigLeafApplicationComponentContext() />
	<cfset var args = StructNew() />
	<cfset args.BeanFactory = getBean("BeanFactory") />
	
	<cftry>
		<cfset thetime = gettickcount() />
		<cfset getBean("logger").setMessage(message = "#variables.appBuild# VIEWFRAMEWORK start up attempt... ") />
		
		<cfinvoke component="#componentPath#viewframework.ViewFramework" method="init" 
			argumentcollection="#args#" returnvariable="ViewFramework" />

		<cfset variables.instance.installedApplications.ViewFramework = "ViewFramework" />		

		<cfset thetime = gettickcount() - thetime />
		<cfset getBean("logger").setMessage(
			message = "#variables.appBuild# VIEWFRAMEWORK installed. Version: #getBean('ConfigBean').getViewFrameworkVersion()# Init Time = #thetime#. ") />
	
		<cfcatch>
			<cfset getBean("logger").setMessage(
				type = "WARN",
				message = "#variables.appBuild#  VIEWFRAMEWORK not installed. ERROR: #cfcatch.message#") />
			<cftry>
				<cfinclude template="util/error.cfm" />
				<cfcatch></cfcatch>
			</cftry>
		</cfcatch>
	</cftry>
	
	<cfreturn  ViewFramework />
</cffunction>



<!--- getFleet --->
<cffunction name="getFleet" returntype="any" access="public" output="false"
	displayname="Get FLEET" hint="I return a new instance of FLEET."
	description="I create and return a new instance of FLEET.">
	
	<cfset var thetime = 0 />
	<cfset var Fleet = 0 />
	<cfset var componentPath = getBean("ConfigBean").getFigLeafApplicationComponentContext() />
	<cfset var args = StructNew() />
	<cfset args.BeanFactory = getBean("BeanFactory") />
	
	<cftry>
		<cfset thetime = gettickcount() />
		<cfset getBean("logger").setMessage(message = "#variables.appBuild# FLEET start up attempt... ") />
		
		<cfinvoke component="#componentPath#fleet.Fleet" method="init" 
			argumentcollection="#args#" returnvariable="Fleet" />
		
		<cfset variables.instance.installedApplications.FLEET = "Fleet" />
		
		<cfset thetime = gettickcount() - thetime />
		<cfset getBean("logger").setMessage(
			message = "#variables.appBuild# FLEET installed. Version: #getBean('ConfigBean').getFleetVersion()# Init Time = #thetime#. ") />

	<cfcatch>
		<cfset getBean("logger").setMessage(
				type = "WARN",
				message = "#variables.appBuild# FLEET not installed. ERROR: #cfcatch.message#") />
			<cftry>
				<cfinclude template="util/error.cfm" />
				<cfcatch></cfcatch>
			</cftry>
	</cfcatch>
	</cftry>
	<cfreturn  Fleet />
</cffunction>
</cfcomponent>