<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			FTPTransport.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am the FTP transport Service
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		18/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="" output="false"
	hint="I am the FTP transport service">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="FTPTransport" access="public" output="false" 
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