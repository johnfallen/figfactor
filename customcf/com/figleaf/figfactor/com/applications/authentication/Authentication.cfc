<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			Authentication.cfc
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I authenticate users.
Usage:      			
Modification Log:
Name 			Date 					Description
================================================================================
John Allen 		19/09/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Authentication" output="false"
	hint="I authenticate users.">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Authentication" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="Config"  />

	<cfset variables.config = arguments.Config />
	
	<cfset variables.Realm = variables.config.getRealm() />
	<cfset variables._URL = variables.config.getAuthenticationURL() />
	<cfset variables.TestURL = variables.config.getAuthenticationTestURL() />
	<cfset variables.mode = variables.config.getAuthenticationMode() />
	<cfset variables.forcePass = variables.config.getForcePass() />
	
	<cfreturn this />
</cffunction>



<!--- login --->
<cffunction name="login" returntype="any" access="public" output="false"
	displayname="Login" hint="I authenticate a user by username and password."
	description="I authenticate a user by username and password.">
	
	<cfargument name="login" type="string" required="yes" hint="I am the Login Name.<br />I am required." />
	<cfargument name="password" type="string" required="yes" hint="I am the Password.<br />I am required." />
	<cfargument name="forcePass" type="string" default="#variables.forcePass#" hint="I will always let a user login if true." />
	
	<!--- prevent cross-site scripting --->
	<cfset var cleanLogin =  rereplace(trim(arguments.login),"<[^>]*>","","ALL") />
	<cfset var cleanPassword =  rereplace(trim(arguments.password),"<[^>]*>","","ALL") />
	<cfset var _URL = variables._URL />
	<cfset var authenticate = false />
	<cfset var result = false />

	<cfif arguments.forcePass neq true>
		
		<!--- default to the production mode if the configured value is not explicitly "test" --->
		<cfif variables.mode eq "test">
			<cfset _URL = variables.testURL />
		</cfif>
		
		<cfset authenticate = doAuthentication(
			login = cleanLogin, 
			password = cleanPassword,
			Realm = variables.Realm,
			URL = _URL) />

		<cfif authenticate eq true>
			<cfset result = true />
		</cfif>
	<cfelse>

		<cfset result = true />
	</cfif>
	
	<cfreturn result />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<cffunction name="doAuthentication" access="private" returntype="any" output="false">

	<cfargument name="login" type="string" required="yes" hint="I am the Login Name.<br />I am required." />
	<cfargument name="password" type="string" required="yes" hint="I am the Password.<br />I am required." />
	<cfargument name="Realm" type="string" required="false" hint="I am the LDAP Real to authenticate against." />
	<cfargument name="URL" type="string" required="false" hint="I am the URL authenticate make a web service call to." />

	<cfset var authenticateResponse = 0 />
	<cfset var wrapper = structNew() />
	<cfset var result =  "false" />
	<cfset var message = "" />
	
	<!--- default to false --->
	<cfset var login_OK = false />
	
	<cfif len(arguments.login) gt 0 and len(arguments.password) gt 0>
	
		<cfset wrapper.authenticateElement.Realm = "#arguments.Realm#" />
		<cfset wrapper.authenticateElement.username = "#arguments.login#" />
		<cfset wrapper.authenticateElement.Password = "#arguments.password#" />
		 
		<!--- Try, in case the web service is down.--->
		<cftry> 
			
			<cfinvoke 
				webservice="#arguments.url#" 
				method="authenticate" 
				argumentcollection="#wrapper#" 
				returnvariable="authenticateResponse">
			</cfinvoke>
			
			<cfcatch type="Any">
				<cfthrow message="The Remote Authentication Service is Unavaiable. Technical Support has been notified.">
			</cfcatch>
		</cftry>
		
		<!--- Pass/fail check of the web service call --->
		<cfif authenticateResponse.getResult() is "YES">
			<cfset result = true>
		<cfelse>
			<cfset result = false>
		</cfif>
		
	<cfelse>
		<cfset result = false>
	</cfif>

	<cfreturn result />
</cffunction>
</cfcomponent>