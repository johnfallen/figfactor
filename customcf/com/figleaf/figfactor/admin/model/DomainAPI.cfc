<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		DomainAPI.cfc
Author:     		John Allen
Email:      		jallen@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@

Purpose:    	I am the Domain API, the interface for the applicaiton

Usage:      		

Modification Log:
Name 			Date 					Description

================================================================================
John Allen 		07/10/2008			Created

------------------------------------------------------------------------------->
<cfcomponent displayname="Domain API" output="false"
	hint="I am the Domain API, the interface for the applicaiton">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="DomainAPI" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfreturn this />
</cffunction>



<!--- getCustomElementXML --->
<cffunction name="getCustomElementXML" output="false"
	hint="I read the customelementdefinitions.xml file, parst it and return it.">
	
	
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>