<cfset myself = event.getValue("myself") />
<cfset config = event.getValue("config") />
<cfset path = config.getSourceCodeDirectory() & "config/system/">
<cfset iniFileName = listLast(config.getINIPath(), "\") />
<!--- make it right for both flavors of os  --->
<cfset iniFileName = listLast(iniFIleName, "/") />

<cfoutput>
<h3>Configuration</h3>
<p><strong>Commonspot version:</strong> #request.cp.PRODUCTVERSION#</p>
<hr />
<h3>Important and Helpfull CommonSpot Request Values</h3>
<p>
	<cftry>
		<strong>CommonSpot DataSource:</strong> #request.site.datasource#<br /><br />
		<strong>Web Site Directory:</strong> #request.site.dir#<br />
		<strong>CommonSpot Directory:</strong> #request.cp.COMMONSPOTDIR#<br />
		<strong>CommonSpot Log Directory:</strong> #request.cp.LOGDIR#<br />
		<strong>Web Server Root Directory:</strong> #request.cp.WEBSERVERDOCDIR#<br />
		<cfcatch>There is an error in getting the request.cp values. Could be running this application outside the context of CommonSpot.</cfcatch>
	</cftry>
</p>
<hr />
<table>
	<tr valign="top">
		<td><cf_iniSetUp iniPath="#path#" iniFile="#iniFileName#" iniSection="system"/></td>
		<td>
			<cf_iniSetUp iniPath="#path#" iniFile="#iniFileName#" iniSection="fleet" />
			<cf_iniSetUp iniPath="#path#" iniFile="#iniFileName#" iniSection="framework_deployment_security"/>
		</td>
	</td>
	<tr valign="top">
		<td><cf_iniSetUp iniPath="#path#" iniFile="#iniFileName#" iniSection="ui"/></td>
		<td><cf_iniSetUp iniPath="#path#" iniFile="#iniFileName#" iniSection="logger"/></td>
	</tr>
	<tr valign="top">
		<td><cf_iniSetUp iniPath="#path#" iniFile="#iniFileName#" iniSection="cacheService"/></td>
		<td><cf_iniSetUp iniPath="#path#" iniFile="#iniFileName#" iniSection="authentication"/></td>
	</tr>
	<tr valign="top">
		<td>
			<cf_iniSetUp iniPath="#path#" iniFile="#iniFileName#" iniSection="validator"/>
			<cf_iniSetUp iniPath="#path#" iniFile="#iniFileName#" iniSection="multimedia"/>
		</td>
		<td><cf_iniSetUp iniPath="#path#" iniFile="#iniFileName#" iniSection="search"/></td>
	</tr>
</table>
</cfoutput>