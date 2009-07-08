<cfset myself = event.getValue("myself") />
<cfset siteSync = event.getValue("siteSync") />
<cfset servers = event.getValue("servers") />



<cfoutput>
<h3>CommonSpot DB Insight</h3>
<h4>Servers</h4>
<ul>
<cfloop query="servers">
	<li>
		#servername#
	</li>
</cfloop>
</ul>
<cfdump var="#servers#" expand="false" label="Servers" />

<h4>SiteSync</h4>
<ul>
<cfdump var="#siteSync#" expand="false" label="SiteSync" />
</cfoutput>
</ul>