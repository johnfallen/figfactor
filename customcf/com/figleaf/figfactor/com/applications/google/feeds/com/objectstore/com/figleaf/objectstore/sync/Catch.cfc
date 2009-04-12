<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			Catch.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I catch responces from remote servers
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		20/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Catch" output="false"
	hint="I catch responces from remote servers">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Catch" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfreturn this />
</cffunction>




<!--- pingResponce --->
<cffunction name="pingResponce" returntype="any" access="remote" output="false"
    displayname="Ping Responce" hint="I respond to a ping."
    description="I respond to a ping.">
    
	<cfargument name="key" type="string" default="" 
		hint="I am the key. I default to an empty string." />
	<cfargument name="value" type="string" default="" 
		hint="I am the key. I default to an empty string." />
	
	<cfset var result = false />
	<!--- TODO: put these in the .ini xml file. --->
	<cfset var _key = "1F5CC29A-6023-1763-98AACB6D530CFC34" />
	<cfset var _value = "5AD3EBFA-6023-1763-98AB3E4D2F756619" />
	
	<cfif arguments.key eq _key and arguments.value eq _value>
		<cfset result = true />
	</cfif>
	
	<cfreturn result />
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