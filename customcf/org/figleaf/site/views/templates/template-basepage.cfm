<!--- Document Information -----------------------------------------------------
Title:      	template-basepage.cfm
Author: 		John Allen
Email:      	jallen@figleaf.com
company:  	Figleaf Software
Website:    http://www.gov
Purpose:    I am the Base Template.
Modification Log:
Name			Date			Description
================================================================================
John Allen		09/17/2008		Created
------------------------------------------------------------------------------->

<!--- the CommonSpot UI module --->
<cfmodule template="/commonspot/pagemode/pagemodeui.cfm">

<!--- set a refrence to the config object --->
<cfset config = Application.BeanFactory.getBean("ConfigBean") />

<!--- 
Implementation Note:
For implementation's of ViewFramework that have dynamic elements the 
viewframeworkrequestloader.cfm should be called via an invoke-dynamic-cfml.cfm 
module:

<cfmodule template="/commonspot/utilities/invoke-dynamic-cfml.cfm" 
	cfml="#config.getViewFrameworkDirectory()#/viewframeworkrequestloader.cfm" />

Else just include the viewframeworkrequestloader.cfm file here so it's content 
is cached at the template level by CommonSpot:

<cfinclude template="#config.getViewFrameworkDirectory()#viewframeworkrequestloader.cfm" />
--->

<!--- 
We are using the DataService to add queries, so load it every time, see note above. 
--->
<cfmodule template="/commonspot/utilities/invoke-dynamic-cfml.cfm" 
	cfml="#config.getViewFrameworkDirectory()#/viewframeworkrequestloader.cfm" />

<!--- get the page event --->
<cfset PageEvent = Application.ViewFramework.getPageEvent() />

<!--- output the page --->
<cfoutput><div id="base-template-wrapper" class="#PageEvent.getCSSClass()#">
	<div id="header-wrapper"></cfoutput>
		
		<cfinclude template="#config.getIncludesDirectory()#/dsp-header.cfm" />
	
		<cfinclude template="#config.getIncludesDirectory()#/inc-breadcrumb.cfm" />
		<cfoutput></div>
	<div id="content-wrapper" class="#PageEvent.getCSSClass()#"></cfoutput>
		
		<!--- this guy dynamically loads the correct render handler dynamically by name --->	
		<cfinclude template="#config.getViewFrameworkDirectory()#/viewstatecontroller.cfm" /><cfoutput>
	</div>
	<div id="footer-wrapper"></cfoutput>
		
		<!--- footer --->
		<cfinclude template="#config.getIncludesDirectory()#/dsp-footer.cfm" /><cfoutput>
	</div>
</div></cfoutput>

<!--- try to include the insight template --->
<cftry>
	<cfinclude 
		template="#config.getFigLeafIncludeDirectory()#/developer-insight.cfm" />
	<cfcatch><cfoutput>Error including the insight template:<br />#cfcatch.message#</cfoutput></cfcatch>
</cftry>