<!---<cfinclude template="/Application.cfm">
<cfif not isDefined("session.user.id") OR session.user.id eq 0>
	<cfoutput>
	<h1>Unauthorized Access</h1>
	<p>Please <a href="/login.cfm">login</a> to access.</p>
	</cfoutput>
	<cfabort/>
</cfif>
--->