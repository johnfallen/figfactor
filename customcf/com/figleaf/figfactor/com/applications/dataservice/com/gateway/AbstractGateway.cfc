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
John Allen	 04/06/2009	 Refactored for v2 exactly one year later!
------------------------------------------------------------------------------->
<cfcomponent displayname="Abstract Gateway" hint="I am the Abstract Gateway." output="false">


<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="AbstractGateway" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="Config" hint="I am FigFactor's Config object. I am required." />
	<cfargument name="Fleet" hint="I am the Fleet component. I am required." />
	<cfargument name="ListService" hint="I am the ListService component. I am required." />
	<cfargument name="MessageService" hint="I am the MessageService component. I am required." />
	<cfargument name="Security" hint="I am the Security component. I am required." />
	<cfargument name="UDF" hint="I am the UDF component. I am required." />
	
	<cfset variables.userDefinedComponents = structNew() />
	<cfset variables.ConfigBean = arguments.Config />
	<cfset variables.GatewayConfigBean = variables.ConfigBean />
	<cfset variables.FLEET = arguments.Fleet />
	<cfset variables.security= arguments.security />
	<cfset variables.ListService= arguments.ListService />
	<cfset variables.MessageService= arguments.MessageService />
	<cfset variables.UDFs = arguments.UDF />
	<cfset variables.Utilities = arguments.UDF />
	
	<cfset variables.userDefinedComponents = structNew() />
	<cfset variables.ReleatedLinks = 0 />
	<cfset variables.CommonSpotCFC = 0 />	
	<cfset variables.gatewayComponentPath = "gateways." />
	
	<cfset variables.ReleatedLinks = createObject("component", "util.ReleatedLinks").init() />
	<cfset variables.CommonSpotCFC = createObject("component", "util.CommonSpot").init() />	

	<!--- inject all the methods from the user supplied components --->
	<cfset load() />

	<cfreturn this />
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