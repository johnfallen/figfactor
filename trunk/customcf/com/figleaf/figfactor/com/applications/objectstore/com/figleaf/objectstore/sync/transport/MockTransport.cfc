<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			MockTransport.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am the mock transport object used for development
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		18/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Mock Transport Object" output="false" 
	extends="BaseTransport" 
	implements="ITransport"
	hint="I am the mock transport object used for development">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="any" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfset super.init() />

	<cfreturn this />
</cffunction>


<!--- makeLove --->
<cffunction name="makeLove" returntype="any" access="public" output="false"
    displayname="I make love" hint="I am a test."
    description="I test.">
    
    <cfreturn  />
</cffunction>


<!--- checkServers --->
<cffunction name="checkServers" returntype="struct" access="public" output="false"
    displayname="Check Servers" hint="I check if configured servers are avaiable."
    description="I check if configured servers are avaiable and return a structure with key/values where the key is the IP number and the value is boolean.">
</cffunction>
<!--- push --->
<cffunction name="push" returntype="component" access="public" output="false"
    displayname="Push" hint="I push the shared_storage.xml file to the active remote servers."
    description="I push the shared_storage.xml file to the active remote servers via my transport mechanism.">
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