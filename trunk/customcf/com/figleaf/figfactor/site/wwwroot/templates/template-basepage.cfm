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

<cfmodule template="/commonspot/utilities/invoke-dynamic-cfml.cfm" 
	cfml="#config.getFigLeafFileContext()#figfactorrequestloader.cfm">

<cfset PageEvent = application.FigFactor.getEvent() />

<!--- output the page --->
<cfoutput><div id="base-template-wrapper" class="#PageEvent.getCSSClass()#">
	<div id="header-wrapper"></cfoutput>
		
		<cfinclude template="#config.getIncludesDirectory()#dsp-header.cfm" />
	
		<cfinclude template="#config.getIncludesDirectory()#inc-breadcrumb.cfm" />
		<cfoutput></div>
	<div id="content-wrapper" class="#PageEvent.getCSSClass()#"></cfoutput>
		
		<!--- this guy dynamically loads the correct render handler dynamically by name --->	
		<cfinclude template="#config.getFigLeafFileContext()#viewstatecontroller.cfm" /><cfoutput>
	</div>
	<div id="footer-wrapper"></cfoutput>
		
		<!--- footer --->
		<cfinclude template="#config.getIncludesDirectory()#dsp-footer.cfm" /><cfoutput>
	</div>
</div></cfoutput>

<!--- try to include the insight template --->
<cftry>
	<cfinclude 
		template="#config.getFigLeafIncludeDirectory()#developer-insight.cfm" />
	<cfcatch><cfoutput>Error including the insight template:<br />#cfcatch.message#</cfoutput></cfcatch>
</cftry>