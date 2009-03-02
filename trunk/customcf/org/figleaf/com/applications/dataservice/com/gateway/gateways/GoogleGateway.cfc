<!--- Document Information -----------------------------------------------------
Build:      				@@@revision-number@@@
Title:      				GoogleGateway.cfc
Author:     				John Allen
Email:      				jallen@figleaf.com
Company:    			@@@company-name@@@
Website:    			@@@web-site@@@
Purpose:    			I am the Google Gateway
Usage:      				I search a Google Appliance
Modification Log:
Name 			Date 					Description
================================================================================
John Allen 		01/10/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Google Gateway" output="false"
	hint="I am the Google Gateway">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="GoogleGateway" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	<cfreturn this />
</cffunction>


<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>