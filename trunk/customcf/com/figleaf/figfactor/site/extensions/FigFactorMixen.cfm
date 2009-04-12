<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			FigFactorFrameworkExtension.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am a file FigFactor.cfc includes (a "mixen") during FigFactors creation.
						Then my methods are called as described.
						
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		30/03/2009			Created
------------------------------------------------------------------------------->

<!--- 
	Override these if you need to, other wise they are set in FigFactor.cfc.
	By using these defaults, the framework can opperate in any customcf
	directory at any subsite level.
--->
<!--- paths 
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
--->
<!--- file names 
<cfset variables.files.DI.DIBootStrapperBeanFile = "coldspring_bootstrapper.xml" />
<cfset variables.files.DI.DICoreFrameworkBeanFile = "coldspring_framework.xml" />
<cfset variables.files.DI.DIApplicationsBeanFile = "coldspring_applications.xml" />
<cfset variables.files.iniFileName = "systemconfiguration.ini.cfm" />
--->


<!--- OnFigFactorFrameworkLoad --->
<cffunction name="OnFigFactorFrameworkLoad" access="private" output="false"	
	displayname="On FigFactor Framework Load" hint="I am called right after the web root variable has be set locally in the init method. I am the second line of code."
	description="I am called right after the web root variable has be set locally in the init method. I am the second line of code.">
</cffunction>



<!--- OnFigFactorDependencyLoad --->
<cffunction name="OnFigFactorDependencyLoad" access="private" output="false"	
	displayname="On Fig Factor Dependency Load" hint="I am fired before the framework trys to set its dependencies."
	description="I am fired before the framework trys to set its dependencies.">
</cffunction>



<!--- OnFigFactorDIFrameworkCreate --->
<cffunction name="OnFigFactorDIFrameworkCreate" returntype="any" access="public" output="false"	
	displayname="On FigFactor DI Framework Create" hint="I am fired before the IOC framework is created. The properties structure being passed to the IOC framework has been created and be added to."
	description="I am fired before the IOC framework is created. The properties structure being passed to the IOC framework has been created and be added to.">
</cffunction>



<!--- OnFigFactorBeanLoad --->
<cffunction name="OnFigFactorBeanLoad" access="private" output="false"	
	displayname="On FigFactor Bean Load" hint="I am called after the IOC framework has been created and before the beans are loaded."
	description="I am called after the IOC framework has been created and before the beans are loaded.">
</cffunction>



<!--- OnFigFactorRequestStart --->
<cffunction name="OnFigFactorRequestStart" output="false"	
	displayname="On FigFactor Request Start" hint="I am fired before the Event object is created."
	description="I am fired before the Event object is created.">
</cffunction>