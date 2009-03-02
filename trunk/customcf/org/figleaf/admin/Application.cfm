<cfapplication 
	name="figFactorAdminSecurityFramework"
	sessiontimeout="#createtimespan(0,0,2,0)#"
	sessionmanagement="true"
	scriptprotect="all" />

<cfinclude template="../Application.cfm" />

<cfif not isDefined("application.FigFactorAdminSecurityFactory")>
	<cfset application.FigFactorAdminSecurityFactory= createObject("component", "security.Security").init() />
</cfif>

<cfif not isDefined("session.figFactorAdminLogin")>
	<cfset session.figFactorAdminLogin = false />
	<cfinclude template="security/index.cfm" />
</cfif>
