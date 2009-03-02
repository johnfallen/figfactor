<cfsilent>
<!--- Document Information -----------------------------------------------------
Title: 				index.cfm
Author:				John Allen
Email:					jallen@figleaf.com
Company:			Figleaf Software
Website:			http://www.nist.gov

Purpose:			I am the UI for administrating the MetaDataKeywork table.

Usage:				None. I am a self submitting page.

================================================================================
John Allen		17/08/2008		Created
------------------------------------------------------------------------------->	

<!--- ************************************* SETUP / LOGIC  *****************************  --->
<cfset config = Application.BeanFactory.getBean("ConfigBean") />
<cfset orientation = "left" />
<!--- 
set local variables 
--->
<cfset servicePath = config.getFigLeafComponentContext() & "com.applications.fleet.com.metadata.com.MetaDataKeywordService" />
<cfset dsn = config.getCommonSpotSupportDSN() />

<!--- ************************************* OUTPUT *************************************  --->
</cfsilent><cftry><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Edit Metadata Tree</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style>
body {font-family:verdana;}
</style>
</head>
<body>

<table width="100%" bgcolor="Navy">
	<tr>
		<td style="color: White; font-family: Arial; font-size: 12px; font-weight: bold;">Edit Taxonomy</td>
	</tr>
</table>
<p><a href="../../../index.cfm?viewTemplate=taxonomy">&laquo; Back to MetaData Admin</a></p>
<object 
	classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" 
	codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" 
	width="650" height="400" id="MDTree" align="middle">
<param name="allowScriptAccess" value="sameDomain" /> 
<cfoutput>
<param 
	name="movie" 
	value="MDTree.swf?servicePath=#servicePath#&gateway=http://#cgi.http_host#/flashservices/gateway&datasource=#dsn#&language=#replace(dsn,'commonspot-',"","ALL")#&orientation=#orientation#" /> 
</cfoutput>
<param name="quality" value="high" /> 
<param name="bgcolor" value="#ffffff" /> 
<cfoutput>
<embed 
	src="MDTree.swf?servicePath=#servicePath#&gateway=http://#cgi.http_host#/flashservices/gateway&datasource=#dsn#&language=#replace(dsn,'commonspot-',"","ALL")#&orientation=#orientation#" 
	quality="high" 
	bgcolor="##ffffff" 
	width="650" 
	height="400" 
	name="MDTree" 
	align="middle" 
	allowScriptAccess="sameDomain" 
	type="application/x-shockwave-flash" 
	pluginspage="http://www.macromedia.com/go/getflashplayer" />
</cfoutput>
</object> 

<div style="border: 1px solid black; width: 650px; position: relative; left: 10px;">
<div align="center" style="font-weight: bold;">Instructions</div>
Click on the keyword in the tree in order to edit it.<br>
When editing the name of a keyword, click the "Edit" button to lock it in. <br>
Click on the "Click To Save Metadata Tree" button to save all of your changes to the database.
</div>
</body>
</html>
<cfcatch type="any">
<cfdump var="#cfcatch#" />
</cfcatch>
</cftry>