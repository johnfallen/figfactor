<!--- ************** ADDED by John Allen **************  --->
<!--- Security code --->
<cfif not isDefined("session.allowexternalapplicationmanagement") or session.allowexternalapplicationmanagement eq false>
	<cfset forward = application.FigFactor.getBean("config").getFIGFACTORWEBCONTEXT() &  "admin/index.cfm"/>
	<cflocation addtoken="false" url="#forward#" />
</cfif>
<cfoutput>
	<p><a href="../../index.cfm">&laquo; back to FigFactor Admin</a></p>
</cfoutput>

<cfmodule 
template="box-Browse.cfm"
cryptionKey="ChangeMe"
folderRoot="c:\"
showIcons="yes"
showSize="yes"
showType="yes"
showDate="yes"
tableWidth="800"
debug="none"
>