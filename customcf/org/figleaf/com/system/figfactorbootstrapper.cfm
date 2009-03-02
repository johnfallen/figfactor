<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title: 				figleafsystembootstrapper.cfm
Author:				John Allen
Email:					jallen@figleaf.com
Company:			Figleaf Software
Website:			http://www.nist.gov
Purpose:			I create the Fig Leaf System component
History:				
================================================================================
John Allen		06/10/2008		Created
------------------------------------------------------------------------------->
<cfparam name="Application.FigFactor" default="" type="any" />
<cfparam name="Application.BeanFactory" default="" type="any" />
<cfparam name="Application.Authentication" default="" type="any" />
<cfparam name="Application.FLEET" default="" type="any" />
<cfparam name="Application.ViewFramework" default="" type="any" />
<!--- make a refrence so its easer for developers to type --->
<cfparam name="Application.VF" default="" type="any" />

<!--- set the start time of the initializiation process --->
<cfset startTime = gettickcount() />

<!---  
	Bootstrapper moves all the files we need into the framework and
	copies file up into the sites root if configured to do so. It also must
	be passed the argument doDeployment with a value of true to do
	the actual file deployments. It will retrun the correct values for the
	"context" methods so the framework will opperate, it just wont have
	the files copyied from the framework to their functional locations.
--->
<cftry>
	<cfset BootStrapper = createObject("component", "com.bootstrapper.BootStrapper").init(doDeployment = true) />
	<cfcatch>
		<cfdump var="#cfcatch#">
		<cfabort />
		<cfthrow 
			message="Error in BootStrapper" 
			detail="The error is in the BootStrap class, called from the bootstrapper.cfm file." />
	</cfcatch>
</cftry>

<!--- Light it up! --->
<cfset Application.FigFactor = createObject("component", "FigFactor").init(
	frameworkPath = BootStrapper.getFigFactorSystemPath(),
	bootStrapTrace = BootStrapper.getLogArray()) />
	
<!--- Set the bean factory and load the applications --->
<cfset Application.BeanFactory = Application.FigFactor.getBean("BeanFactory") />
<cfset Application.Authentication = Application.BeanFactory.getBean("Authentication") />
<cfset Application.FLEET = Application.BeanFactory.getBean("FLEET") />
<cfset Application.ViewFramework = Application.BeanFactory.getBean("Viewframework") />
<!--- refrence as  "VF" incase a developer hates to type "ViewFramework" --->
<cfset Application.VF = Application.ViewFramework />

<!--- set the end time of the initalization process --->
<cfset startTime = gettickcount() - startTime />

<!--- the code that writes the top of the Start Initalizing is inside the FigLeafSystem. --->
<cfset Application.BeanFactory.getBean("logger").setMessage(Message="FigFactor Framework Initalized! TOTAL INIT TIME: #startTime#") />
<cfset Application.BeanFactory.getBean("logger").setMessage(message = "+=+=+=+=+ End Initalizing =++=+=+=+") />
<cfset Application.BeanFactory.getBean("logger").setMessage(message = "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+") />