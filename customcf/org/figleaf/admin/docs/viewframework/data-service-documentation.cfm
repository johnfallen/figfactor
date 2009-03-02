<!--- Document Information -----------------------------------------------------
Build:     @@@revision-number@@@

Title:     index.cfm

Author:	   John Allen
Email:	   jallen@figleaf.com

Company:   @@@company-name@@@
Website:   @@@web-site@@@

Purpose:   I am the documentation and configuration page.

Usage:	   

Modification Log:

Name	 Date	 Description
================================================================================
John Allen	 22/06/2008	 Created

------------------------------------------------------------------------------->
<cfsilent>
<cfset factory = Application.BeanFactory.getBean("BeanFactory") />
<cfset config = factory.getBean("ConfigBean") />	

<!--- TODO: delete this file for production --->
<cfif isDefined("form.type")>
	<!--- change the Mock objects type --->
	<cfset PageEventObject = Application.BeanFactory.getBean("ViewFramework").getMockPageEvent(setRequestScopeDefautls = 1) />
	<cfset PageEventObject.setPageTypeDeinitions("#form.type#") />
<cfelse>
	<!--- make a fake pageObject (for testing) --->
	<cfset PageEventObject = Application.BeanFactory.getBean("ViewFramework").getMockPageEvent(setRequestScopeDefautls = 1) />
</cfif>

<cfset DataService = Application.BeanFactory.getBean("Dataservice") />

<!--- pass the PageEventObject to the Service --->
<cfset PageEvent = DataService.setPageEventQueries(PageEvent = PageEventObject)>


</cfsilent><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>DataService Documentation</title>
	<style>
body,div,ul,ol,table,tr,td,input,form {margin:0; padding:0; font-family:verdana;}
ol li {margin-left:40px;}
ul, ol {margin-bottom:20px;}
body {margin:10px;}
li {margin-left:35px; line-height:1.5em;}
h1 {padding-top:0; margin-top:0;}
h2 {padding-top:0; margin-top:0;}
hr {margin-top:30px;}
.code {font-family:times; color:#990000; font-weight:bold; letter-spacing:2px;}
.small {letter-spacing:normal;}
#documentation {border:solid 1px gray; padding:0px 30px 30px 30px; margin:0px 40px 40px 40px;}
.top {float:right; clear:none; width:90px; display:block; margin-top:-20px;}
#meta-nav {
	float:right; clear:both;
	border-top:solid 1px silver; 
	border-right:solid 2px black; 
	border-bottom:solid 2px black; 
	border-left:solid 1px silver;
	padding:10px 10px 10px 10px;
	margin:0px 0px 20px 40px;
	font-size:.80em;
	background-color:black;
	color:white;
	font-weight:bold;
	}
#meta-nav a:link {color:#fff}
#meta-nav a:visited {color:#fff}
#meta-nav a:hover {color:#f0f}
	</style>
</head>
<body><a id="top" name="top"></a>
<cfoutput><div id="meta-nav">
	<a href="#config.getFigLeafFileContext()#/admin/index.cfm?viewDirectory=docs">&raquo; Docs Homepage</a><br />
</div></cfoutput>
<h1>DataService System</h1>
<cfdump var="#DataService#" expand="false" />
<cfdump var="#PageEvent.getInstance()#" expand="false" />
<div class="top"><a href="#top">top</a></div>
<a id="doument-history" name="doument-history"></a>
<div class="box">
	<div id="documentation">
		<h2>Document History</h2>
		<table border="1">
			<tr valign="top">
				<th>Author</th>
				<th>Date</th>
				<th>Comments</th>
			</tr>
			<tr valign="top">
				<td>John Allen</td>
				<td>June 7th 2008</td>
				<td>Created</td>
			</tr>
		</table> 
	</div>
</div>

<br /><br />
</body>
</html>