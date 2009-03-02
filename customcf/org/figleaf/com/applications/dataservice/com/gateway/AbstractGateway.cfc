<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		AbstractGateway.cfc
Author:     		John Allen
Email:      		jallen@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@
Purpose:  		I am the Abstract Gateway. I use method-injection to provide access
					to all of my concrete gateways.
Usage:      
Modification Log:
Name	 Date	 Description
================================================================================
John Allen	 07/06/2008	 Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Abstract Gateway" hint="I am the Abstract Gateway." output="false">


<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="AbstractGateway" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="BeanFactory" default="#application.BeanFactory#" 
		hint="I am FigFactor's BeanFactory object.<br />I default to 'Application.BeanFactory'." />

	<cfset var thetime = getTickCount() />
	
	<cfset variables.BeanFactory = arguments.BeanFactory />
	<cfset variables.userDefinedComponents = structNew() />
	<cfset variables.ConfigBean = variables.BeanFactory.getBean("ConfigBean") />
	<cfset variables.GatewayConfigBean = variables.ConfigBean />
	<!--- 
	Get MetaDataKeyword for the application scope if it there so the
	log files reflect the true configuration of how the framework is
	currently running. 
	--->
	<cfif structKeyExists(Application, "Fleet")>
		<cfset variables.MetaDataKeyWordService = Application.Fleet.getService("MetaDataService").getMetaDataKeywordService() />
	<cfelse>
		<cfset variables.MetaDataKeyWordService = variables.BeanFactory.getBean("Fleet").getService("MetaDataService").getMetaDataKeywordService() />
	</cfif>
	<cfset variables.UDFs = variables.BeanFactory.getBean("udf") />
	<cfset variables.Utilities = variables.BeanFactory.getBean("udf") />
	
	<cfset variables.userDefinedComponents = structNew() />
	<cfset variables.ReleatedLinks = 0 />
	<cfset variables.CommonSpotCFC = 0 />	
	<cfset variables.gatewayComponentPath = "gateways." />
	<cfset variables.Hackernate = 0 />
	
	
	<cfset variables.ReleatedLinks = createObject("component", "util.ReleatedLinks").init() />
	<cfset variables.CommonSpotCFC = createObject("component", "util.CommonSpot").init() />	

	<!--- inject all the methods from the user supplied components --->
	<cfset load() />
 
	<!--- light up the Hackernate persistance layer cool query helper --->
	<cfset variables.Hackernate = createObject("component", "hackernate.Hackernate").init(
		factory = variables.BeanFactory,
		CommonSpotCFC = variables.CommonSpotCFC,
		ReleatedLinks = variables.releatedlinks) />
	
	<cfset thetime = gettickcount() - thetime />
	<cfset variables.BeanFactory.getBean("logger").setMessage(message = "HACKERNATE Installed. Init time: #thetime#") />

	<cfreturn this />
</cffunction>



<!--- getHackernate --->
<cffunction name="getHackernate" returntype="any" access="public" output="false"
	displayname="Get Hackernate" hint="I return the Hackernate tool kit."
	description="I return the Hackernate tool kit.">
	
	<cfreturn variables.Hackernate />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- load --->
<cffunction name="load" returntype="any" access="private" output="false"
	displayname="Load" hint="I inject all of the user defined functions from the gateways CFC's."
	description="I inject all of the user defined functions from the gateways CFC's.">
	
	<cfset var cfcList = 0 />
	<cfset var cfcName = "" />
	<cfset var fileLocation = "#getDirectoryFromPath(GetCurrentTemplatePath())#/gateways" />
	<cfset var cfcPath = "gateways.">
	<cfset var x = "" />
	<cfset var z = 0 />
	<cfset var cfc = 0 />
	
	<cfdirectory action="list" name="cfcList" directory="#fileLocation#" />
	
	<!--- loop and create each user defined component --->
	<cfloop query="cfcList">
		
		<!--- only light up .cfc's --->
		<cfif right(name, 4) eq ".cfc">
		
			<cfset cfcName = replaceNoCase(cfcList.name, ".cfc", "") />
			
			<cfinvoke component="#cfcPath##cfcName#"
				returnvariable="variables.userDefinedComponents.#cfcName#" method="init" />
		</cfif>
	</cfloop>
	
	<!--- loop over the object stucture and inject each method if its NOT the init() --->
	<cfloop collection="#variables.userDefinedComponents#" item="x">
		
		<cfset cfc = variables.userDefinedComponents[x] />
		
		<cfloop from="1" to="#arrayLen(getMetaData(cfc).functions)#" index="z">
			
			<cfif getMetaData(cfc).functions[z].name neq "init">
				<cfset variables.UDFs.injectMethod(this, evaluate("cfc" & "." &  "#getMetaData(cfc).functions[z].name#")) />
			</cfif>
		</cfloop>
	</cfloop>

</cffunction>
</cfcomponent>