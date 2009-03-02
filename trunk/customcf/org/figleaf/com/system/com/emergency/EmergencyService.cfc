<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		EmergencyService.cfc
Author:     		John Allen
Email:      		jallen@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@
Purpose:    I am the Emergency Service. I send notifications when things go wrong.
Usage:      
Modification Log:
Name	 Date	 Description
================================================================================
John Allen	 08/06/2008	 Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Emergency Service" hint="I am the Emergency Service. I send notifications when things go wrong." output="false">

<cfset variables.email = 0 />

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="EmergencyService" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the constructor for this CFC. I return an instance of myself.">

	<cfargument name="ConfigBean" type="any" required="true" hint="I am the GatewayConfigBean.<br />I am required." />
	
	<cfset setEmail(Email = createObject("component", "Email").init(ConfigBean = arguments.GatewayConfigBean)) />

	<cfreturn this />
</cffunction>

<!--- getEmail --->
<cffunction name="getEmail" access="public" output="false" returntype="any">
	<cfreturn variables.Email />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- setEmail --->
<cffunction name="setEmail" access="private" output="false" returntype="any">
	<cfargument name="Email" type="any" required="true"/>
	<cfset variables.Email = arguments.Email />
</cffunction>
</cfcomponent>