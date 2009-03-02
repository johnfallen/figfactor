<cfsilent>
<!--- Document Information -----------------------------------------------------
Title: 				index.cfm
Author:				John Allen
Email:					jallen@figleaf.com
Company:			Figleaf Software
Website:			http://www.nist.gov

Purpose:			I am the homepage for the FigSystem documentation.

Usage:				

================================================================================
John Allen		24/08/2008		Created
------------------------------------------------------------------------------->
<cfset factory = Application.BeanFactory.getBean("BeanFactory") />
<cfset config = factory.getBean("ConfigBean") />
<cfset PageMetaData = factory.getBean("Fleet").getService("PageMetaData") />
</cfsilent><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>FLEET: PageMetaData Documentation</title>
<style>
body,div,ul,ol,table,tr,td,input,form {margin:0; padding:0; font-family:verdana;}
ol li {margin-left:40px;}
ul, ol {margin-bottom:20px;}
body {margin:10px;}
li {margin-left:35px; line-height:1.5em;}
.box {
	border-top:solid 1px silver; 
	border-right:solid 2px black; 
	border-bottom:solid 2px black; 
	border-left:solid 1px silver;
	padding:10px 10px 10px 10px;
	margin:10px 0px 20px 0px;
	}
h1 {padding-top:0; margin-top:0;}
h2 {padding-top:0; margin-top:0;}
hr {margin-top:30px;}
.code {font-family:"Trebuchet MS"; color:#990000; font-size:1.2em;}
#documentation {font-size:.85em;}
#documentation table {width:100%;}
#index {font-size:.90em;}
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
<cfoutput>
<body><div id="content">
<a id="top" name="top"></a>
<div id="meta-nav">
	<a href="#config.getFigLeafFileContext()#/admin/index.cfm?viewDirectory=docs">&raquo; Docs Homepage</a><br />
</div>
<h1>PageMetadata</h1>

<p>TODO: do documentation.</p>

<cfdump var="#PageMetaData#" label="PageMetaData" expand="true" />

<div class="top"><a href="##top">top</a></div>


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
				<td>August 24th 2008</td>
				<td>Created</td>
			</tr>
		</table> 
	</div>
	
</div>
</div></body>
</cfoutput>
</html>
