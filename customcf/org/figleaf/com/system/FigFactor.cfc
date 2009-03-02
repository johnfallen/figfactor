<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		FigFactor.cfc
Author:     		John Allen
Email:      		jallen@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@
Purpose:    	I am the FigFactor Framework. I manage all of the 
					objects that are the framework, all behind the sceens.
					
					Public access 'should' be made via a refrence to the
					BeanFactory in the application scope, or what ever floats
					your boat. I personally find setting up 
					Application.Beanfactory = Application.FigFactor.getBean("Factory")
					and then having all client code use the Application.BeanFactory
					easer and also has the added benifit of calling code never knowing
					about the FigFactor. This is a good strategy for building applications
					that will become part of the FigFactor.

Modification Log:
Name 			Date 					Description

================================================================================
John Allen 		19/08/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Fig Factor" output="false"
	hint="I am the FigFactor Framework. I manage all of the objects that are the framework, all behind the sceens.">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="FigFactor" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="frameworkPath" type="string" required="true"
		hint="I am the path to the customcf/org/figleaf directory.<br />I am required." />
	<cfargument name="bootStrapTrace" type="array" required="false" defalut="#arrayNew(1)#"
		hint="I am the array of messages from the FigLeafBootStrapper.cfc.<br />I default to an empty array" />

	<cfset variables.SystemFactory = 
		createObject("component", "com.SystemFactory").init(
			frameworkPath = arguments.frameworkPath,
			bootStrapTrace = arguments.bootStrapTrace) />
	
	<cfreturn this />
</cffunction>



<!--- getBean --->
<cffunction name="getBean" returntype="any" access="public" output="false"
	displayname="Get Bean" hint="I return a system object by name.."
	description="I ask the SystemFactory for a bean by name..">
	
	<cfargument name="beanName" hint="I am the name of the object." />
	
	<cfreturn variables.SystemFactory.getBean(arguments.beanName) />
</cffunction>



<!--- getInstalledApplications --->
<cffunction name="getInstalledApplications" returntype="any" access="public" output="false"
	displayname="Get Installed Applications" hint="I return an structure of the installed applications."
	description="I return a structure of the installed application objects.">
	
	<cfreturn variables.SystemFactory.getInstalledApplications() />
</cffunction>

<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>