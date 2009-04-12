<cfset myself = event.getValue("myself") />
<cfset xe.doLogin = event.getValue("xe.doLogin") />
<cfset message = event.getValue("message") />
<cfset session.AllowExternalApplicationManagement = false />

<cfoutput>
<h3>Login</h3>
<cfif len(message)>
	<cfoutput>#message#</cfoutput>
</cfif>
<form action="<cfoutput>#myself##xe.doLogin#</cfoutput>" method="post">
	username:<br />
	<input type="text" name="username" /><br />
	password:<br />
	<input type="password" name="password" /><br />
	<input type="submit" value="Login" />
</form>
</cfoutput>