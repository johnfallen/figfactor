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
</cfsilent><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>System Documentation</title>
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
<body><a id="top" name="top"></a><div id="content">
<div id="meta-nav">
	<a href="#config.getFigLeafFileContext()#/admin/index.cfm?viewDirectory=docs">&raquo; Docs Homepage</a><br />
</div>
<h1>System Documentation</h1>

<ul id="index">
	<li><a href="##overview">Overview</a></li>
	<li><a href="##tools">System Tools</a></li>
	<li><a href="##doument-history">Document History</a></li>
</ul>


<a id="overview" name="overview"></a>
<div class="box">
	<h2>Overview</h2>
	<p>The "System" is an umbrella for CommonSpot custom applications and development.</p>
	<ul>
		<li><a href="##tools"><strong>A great set of tools</strong></a> to help in application development:
			<ul>
				<li><a href="##cache">Cache</a> - 2 flavors</li>
				<li><a href="##emergency">Emergency</a> - your buddy for behind the scenes application reaction</li>
				<li><a href="##logger">Logger</a> - LOCAL LOGGING!</li>
			</ul>
		</li>
	</ul>
	
	<blockquote style="font-size:1.2em;"><blink><strong><em>&mdash; PLUS!!! &mdash;</em></strong></blink></blockquote>
	
	<ul>
		<li><strong>Drag &amp; Drop</strong> one directory installiation.</li>
		<li><a href="#config.getFigLeafFileContext()#/admin/index.cfm?viewTemplate=configuration"><strong>Central Configuration</strong></a> with easy editing</li>
		<li><a href="#config.getFigLeafFileContext()#/admin/index.cfm?viewTemplate=deployment"><strong>Deployment Service</strong></a>  - FNck The SYSTEM! Deploy what you want no matter what security prision you live in!</li>
	</ul>
	
	<div class="top"><a href="##top">top</a></div>
</div>



<a id="tools" name="tools"></a>
<div class="box">
	<h2>System Tools</h2>
	
	<a id="cache" name="cache"></a>
	<h3>Cache</h3>
	<p>The Cache is a proxy for 1 of two type of cache mechnizisms (each component has the same interface).</p>
	<ol>
		<li>A sharp implementation of a Java "soft refrence" cache, Java will GC as needed. <strong><em>(Defalut)</em></strong></li>
		<li>A "hard" cache, a component based variables scope cache with a configurable "reap time".</li>
	</ol>
	<h4>Inside the Cache</h4>
	<cfdump var="#factory.getBean("Cache").viewCache()#" label="viewCache()" expand="false" />
	<h4>The Cache API</h4>
	<cfdump var="#factory.getBean("Cache")#" label="Cache" expand="true" />
	
	<div class="top"><a href="##top">top</a></div>
	<hr />
	
	<a id="emergency" name="emergency"></a>
	<h3>Emergency</h3>
	<p>EmergencyService.cfc allows developers to add code, in an orginized way, that lets your application generate more sofisticated error reporting and application reaction for edge cases.</p>
	<p>CommonSpot is a 100% <span class="code">&lt;cfmodule&gt;</span> designed application and supresses error's. It is expected that this CFC will be extended to adapt it for your specific application.</p>
	<p>TODO: Need to get the API for this one ironed out. I''m thinking:</p>
	<span class="code">
	setEmergencyResponce<br />(<br />
		<span style="color:black;">level = numeric,<br />
		dispatchMethod = string,<br />
		sendEmails = boolen,<br />
		log = boolen,<br />
		logMessage = string</span><br />
		)
	</span>
	<cfdump var="#factory.getBean("Emergency")#" label="Emergency" expand="true" />
	
	<div class="top"><a href="##top">top</a></div>
	<hr />
	
	<a id="logger" name="logger"></a>
	<h3>Logger</h3>
	<p>I provide logging using the <strong><em>mighty</em></strong> CFLog4J so log files are stored in my local log directory!</p>
	<p><strong><em>LOCAL LOGGING! NO MORE CFADMIN!&nbsp;&nbsp;<a href="#config.getFigLeafFileContext()#/admin/index.cfm?viewTemplate=logs">Click here &raquo;</a></em></strong></p>
	<cfdump var="#Application.BeanFactory.getBean('logger')#" label="Logger" expand="true" />
	<div class="top"><a href="##top">top</a></div>
</div>



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
