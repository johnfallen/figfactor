<!--- Document Information -----------------------------------------------------
Title: 				menu.cfm
Author:				John Allen
Email:					jallen@figleaf.com
Company:			Figleaf Software
Website:			http://www.nist.gov
Purpose:			I am the Admin menu
Usage:				
History:
Name					Date				
================================================================================
John Allen			07/10/2008		Created
------------------------------------------------------------------------------->
<cfset config = Application.BeanFactory.getBean("ConfigBean") />
<cfset myself = config.getFigLeafFileContext() & "/admin/index.cfm?" />

<!--- ************ Display ************ --->
<cfoutput><div id="meta-nav">
	<a href="#myself#viewDirectory=home">&raquo; Home</a><br />
	<a href="#myself#viewDirectory=configuration">&raquo; Configure</a><br />
	<a href="#myself#viewDirectory=metadata">&raquo; FLEET Taxonomy</a><br />
	<a href="#myself#viewDirectory=deploymentservice">&raquo; Deployment Service</a><br />
	<a href="#myself#viewDirectory=logviewer">&raquo; Logs</a><br />
	<a href="#myself#viewDirectory=docs">&raquo; Docs Homepage</a><br />
	<a href="#myself#viewDirectory=home&init=true">&raquo; Reinit</a><br />
</div></cfoutput>