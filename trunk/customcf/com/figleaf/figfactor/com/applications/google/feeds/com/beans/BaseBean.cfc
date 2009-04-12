<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			BaseBean.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am a bean that has the base functions to opperate correclty
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		15/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Base Bean" output="false"
	hint="I am a bean that has the base functions to opperate correclty">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="BaseBean.cfc" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfreturn this />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
	<cfreturn variables.instance />
</cffunction>

<!--- *********** Package *********** --->
<!--- *********** Private *********** --->




</cfcomponent>