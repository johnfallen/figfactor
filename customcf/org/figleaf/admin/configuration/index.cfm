<cfset factory = Application.BeanFactory.getBean("BeanFactory") />
<cfset config = factory.getBean("ConfigBean") />
<cfset constants = config.getConstants() />
<cfset path = "#constants.FRAMEWORK_FILE_PATH#/#constants.DEVELOPMENT_DIRECTORY#/config/" />
<cfoutput>
<cfinclude template="../includes/header.cfm" />
<cfinclude template="../includes/menu.cfm" />
<br /><br />
<div id="page-wrapper">
<h1>Fig Leaf System Configuration</h1>
<p>Editing this file:<br />
#path#systemconfiguration.ini.cfm
</p>
<table>
	<tr valign="top">
		<td><cf_iniSetUp iniPath="#path#" iniFile="systemconfiguration.ini.cfm" iniSection="system"/></td>
		<td><cf_iniSetUp iniPath="#path#" iniFile="systemconfiguration.ini.cfm" iniSection="fleet" /></td>
	</td>
	<tr valign="top">
		<td><cf_iniSetUp iniPath="#path#" iniFile="systemconfiguration.ini.cfm" iniSection="viewframework"/></td>
		<td><cf_iniSetUp iniPath="#path#" iniFile="systemconfiguration.ini.cfm" iniSection="dataservice"/></td>
	</tr>
	<tr valign="top">
		<td><cf_iniSetUp iniPath="#path#" iniFile="systemconfiguration.ini.cfm" iniSection="search"/></td>
		<td><cf_iniSetUp iniPath="#path#" iniFile="systemconfiguration.ini.cfm" iniSection="authentication"/></td>
	</tr>
</table>
</div>
</cfoutput>
<cfinclude template="../includes/footer.cfm" />