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
<cfset config = Application.BeanFactory.getBean("ConfigBean") />
<cfmodule template="/commonspot/utilities/invoke-dynamic-cfml.cfm" 
	cfml="#config.getViewFrameworkDirectory()#/viewframeworkrequestloader.cfm">

<cfset PageEvent = Application.vf.getPageEvent() />
<cfset rednerHandlerDirectory = PageEvent.getRederHandlerDirectory()>
<cfoutput><div id="base-template-wrapper" class="#PageEvent.getCSSClass()#">
	<div id="header-wrapper"></cfoutput>
		<cfinclude template="#config.getIncludesDirectory()#/dsp-header.cfm" />
		<cfoutput></div>
	<div id="content-wrapper" class="#PageEvent.getCSSClass()#"></cfoutput>
			<cfmodule template="/commonspot/utilities/invoke-dynamic-cfml.cfm" 
				cfml="#rednerHandlerDirectory#/dsp_search_results.cfm"><cfoutput>
	</div>
	<div id="footer-wrapper"></cfoutput>
		<cfinclude template="#config.getIncludesDirectory()#/dsp-footer.cfm" /><cfoutput>
	</div>
</div></cfoutput>
<cftry>
	<cfinclude 
		template="#config.getFigLeafIncludeDirectory()#/developer-insight.cfm" />
	<cfcatch></cfcatch>
</cftry>
