<!--- Document Information -----------------------------------------------------
Title: 					custom-authentication.cfm
Author:					John Allen
Email:						jallen@figleaf.com
Company:				Figleaf Software
Website:				http://www.nist.gov
Purpose:				I authenticate users against an external system then log 
							them into CommonSpot
Usage:					I am called by CommonSpot
================================================================================
John Allen		29/09/2008		Created
------------------------------------------------------------------------------->
<cfset Config = Application.BeanFactory.getBean("ConfigBean") />
<cfset Authentication = Application.BeanFactory.getBean("Authentication") />
<cfset logger = Application.BeanFactory.getBean("logger") />


<cfif Config.getEnableAuthentication() eq "true" and not attributes.CSAuthenticated>

	<cfset bauthenticated = 1 />

	<!--- attemt to authenticate --->
	<cfset doLogin = Authentication.login(
		login = attributes.userID,
		password = attributes.password) />
	
	<cfif doLogin neq true>
		<cfset bauthenticated = 0 />
		<cfset throwLoginError(
			message="Your login failed. Click Ok to try again or Cancel to return to the Home page.") />
	</cfif>

	<cfscript>
	  setvariable("caller.#attributes.isauthenticatedvar#", bauthenticated);
	  setvariable("caller.#attributes.defaultuseridvar#", "#attributes.userid#");
	</cfscript>
</cfif>


<!--- throwLoginError --->
<cffunction name="throwLoginError">
	
	<cfargument name="message" default="" 
		hint="I am the error message to display in a JavaScript box." />
	

	<!--- make sure they are NOT authenticated --->
	<cfset setVariable ("caller.#attributes.isAuthenticatedvar#", 0) />
	
	<!--- throw a JS confirm window with options --->
	<cfoutput>
		<script language="JavaScript">
			if (confirm("#arguments.message#")) {
				location.href='login.cfm';
			} 
			else {
				location.href='';
			}
		</script>
	</cfoutput>
	
	<!--- have to use cfabort or CS will continue --->
	<cfabort />
</cffunction>