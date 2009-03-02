<cfsilent>
<!--- Document Information -----------------------------------------------------
Title: 				index.cfm
Author:				John Allen
Email:					jallen@figleaf.com
Company:			Figleaf Software
Website:			http://www.nist.gov

Purpose:			I submit a button. I should be moved to the index page.
================================================================================
John Allen		17/08/2008		Created
------------------------------------------------------------------------------->
<cfparam name="results" default="false" type="boolean" />

<cfset factory = Application.BeanFactory.getBean("BeanFactory") />

<!---  
Call the Core and update the meta-data.
--->
<cfif isDefined("url.runUpdate")>
	<cfset theTime = getTickCount() />
	<cfset fleet = factory.getBean("Fleet") />
	<cfset metaDataServcice = fleet.getService("metadataservice") />
	<cfset results = metaDataServcice.getMetaDataKeywordService().BitmaskGenerate() />
</cfif>
</cfsilent><cfoutput><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<style>
body {font-family:verdana;}
##message {
background-color:##666; 
color:##f0f; 
padding:10px; 
border:solid 1px black; 
font-weight:bold;}
</style>
</head>
<body>

<h1>FLEET MetaData Bitmask Generation</h1>

<cfif results eq true>
	<cfset thetime = gettickcount() - thetime />
	<div id="message">
		UPDATE Successfull!<br />Total Time: <strong>#thetime# ms.</strong>
	</div>
</cfif>
<p><a href="../../../index.cfm?viewTemplate=taxonomy">&laquo; Back to MetaData Admin</a></p>
<p><a href="?runUpdate=true">Click here to generate bitmasks for the MetaDataKeyword table &raquo;</p>
</body>
</html>
</cfoutput>