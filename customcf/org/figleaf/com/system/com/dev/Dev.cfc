<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		Dev.cfc
Author:     		John Allen
Email:      		jallen@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@
Purpose:    	I am the Dev component.
Usage:      		dump me
History:
Name 			Date 					Description
================================================================================
John Allen 		06/10/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Devolopment -- Dev" output="false"
	hint="I am the Dev component">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Dev" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfreturn this />
</cffunction>


<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>