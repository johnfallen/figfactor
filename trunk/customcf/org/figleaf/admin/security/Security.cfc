<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			Security.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am the Security Service. I store an encrypted password
						in the 'access' directory. The 'salt' used to extra encrypt the
						password is a string stored in my meta data.
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		19/12/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Security" output="false"
	hint="I am the Security Service">

<!--- 
	Values are hard coded here. No other code needs to know about this.
	Keeps this security strategy totally encapsulated and protected if the
	directory of the web server is tight. Its also 'accectable' for sitting in a public
	folder as well, the password is not only 'SHA' encriptied but the variables.salt
	is also tacked on to the password before encryption for super duper 
	encryption.
--->
<cfset variables.accesPath = getDirectoryFromPath(GetCurrentTemplatePath()) &  "/access/" />
<cfset variabls.accessFileName = "access.ini.cfm" />
<cfset variables.salt = "5AD3EBFA-6023-1763-98AB3E4D2F756619" />
<cfset variables.minimumPasswordLength = 4 />
<cfset variables.securityEnabled = true />
<cfset variables.FileSystem = createObject("component", "FileSystem").init() />


<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Security" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfreturn this />
</cffunction>



<!--- checkUserLogin --->
<cffunction name="checkUserLogin" returntype="boolean" access="public" output="false"
	displayname="Check User Login" hint="I if the user is logged ins."
	description="I check if applicaiton security is enabled and then check if a user is logged in.">ss
	
	<cfif variables.securityEnabled eq false>
		<cfreturn 1 />	
	<cfelse>
		<cfif not isDefined("session.figFactorAdminLogin")>
			<cfreturn 0 />
		<cfelse>
			<cfreturn 1 />
		</cfif>
	</cfif>
</cffunction>



<!--- updatePassword --->
<cffunction name="updatePassword" returntype="boolean" access="public" output="false"
	displayname="Update Password" hint="I update the applicaiton password."
	description="I update the applicaiton password.">
		
	<cfargument name="password" type="string" required="true" 
		hint="I am the current password.<br />I am required." />
	<cfargument name="password1" type="string" required="true" 
		hint="I am the new password.<br />I am required." />
	<cfargument name="password2" type="string" required="true" 
		hint="I am the new passwords confirmation string.<br />I am required." />
	<cfargument name="minimumPasswordLength" type="numeric" 
		default="#variables.minimumPasswordLength#" 
		hint="I am the minimum length for passwords. I default to a value in the variables scope.">
	
	<cfset var salt = variables.salt />
	<cfset var content = "" />
	
	<cfset checkUserLogin() />
	
	<cfif not len(arguments.password) lt arguments.minimumPasswordLength 
		and trim(arguments.password1) eq trim(arguments.password2)>
		
		<!--- Salt and hash the password --->
		<cfset arguments.password = arguments.password & salt>
		<cfset arguments.password = hash(arguments.password, "SHA")  />
		
		<!--- create and save the file cotent --->
		<cfset content = "<cfabort/>" & arguments.password />
		<cfset variables.FileSystem.CreateFile(
				Destination = variables.accesPath,
				FileName = variabls.accessFileName,
				Content = content) />
		<cfreturn 1 />
	<cfelse>
		<cfreturn 0 />
	</cfif>
</cffunction>



<!--- userLogin --->
<cffunction name="userLogin" returntype="boolean" access="public" output="false"
	displayname="User Login" hint="I check a password."
	description="I check a password then log a user into the applicaiton if sucessfull.">
	
	<cfargument name="password" type="string" required="true" 
		hint="I am the password.<br />I am required." />
	
	<cfset var salt = variables.salt />
	<cfset var FileData =  variables.fileSystem.Read(
		Destination = variables.accesPath,
		fileName = variabls.accessFileName) />

	<!--- 
	Read the access file string, salt and hash the incoming password.
	Then check if it matches, if so set the session variable used in 
	securityCheck(). 
	--->
	<cfset FileData = replaceNoCase(fileData, "<cfabort/>", "") />
	<cfset arguments.password = arguments.password & salt />
	<cfset arguments.password = hash(arguments.password, "SHA")  />

	<cfif trim(FileData) eq trim(arguments.password)>
		<cfset session.figFactorAdminLogin = true />
		<cfreturn 1 />
	<cfelse>
		<cfreturn 0 />
	</cfif>
</cffunction>



<!--- userLogOut --->
<cffunction name="userLogOut" returntype="void" access="public" output="false"
	displayname="userLogOut" hint="I log a user out of the application."
	description="I log a user out of the application.">
	
	<cfset StructClear(Session)>
	
</cffunction>
<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>