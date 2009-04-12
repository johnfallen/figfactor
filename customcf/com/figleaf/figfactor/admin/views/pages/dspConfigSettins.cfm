<cfset myself = event.getValue("myself") />
<cfset config = event.getValue("config") />
<cfset path = config.getSourceCodeDirectory() & "config/system/">
<cfset iniFileName = listLast(config.getINIPath(), "\") />
<!--- make it right for both flavors of os  --->
<cfset iniFileName = listLast(iniFIleName, "/") />

<cfoutput>
<h3>Configuration</h3>
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