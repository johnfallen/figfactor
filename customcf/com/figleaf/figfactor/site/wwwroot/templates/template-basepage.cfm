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

<!--- this will create the Event object, its the first call --->
<cfset Event = application.FigFactor.getEvent() />
<cfset config = Application.BeanFactory.getBean("ConfigBean") />

<!--- output the page --->
<cfoutput><div id="base-template-wrapper" class="#Event.getCSSClass()#">
	<div id="header-wrapper"></cfoutput>
		<cfinclude template="#config.getIncludesDirectory()#dsp-header.cfm" />
		<cfinclude template="#config.getIncludesDirectory()#inc-breadcrumb.cfm" />
		<cfoutput></div>
	<div id="content-wrapper" class="#Event.getCSSClass()#"></cfoutput>
		<!--- 
			this guy loads the correct render handler dynamically by name, just
			like the code below. But if you want to see the TOTAL time of the
			event creation process use this include, then look at the 
			viewstatecontroller.cfm execution time in the ColdFusion Show 
			Execution dispalay stack output.
		 --->
		<!--- <cfinclude template="#config.getFigLeafFileContext()#viewstatecontroller.cfm" /> --->
		
		<!--- 
			...or you can load the customelement right here. This is good because
			it Keeps Is Simple Stupid, and I like simple.
		--->
		<cfmodule template="/commonspot/utilities/ct-render-named-element.cfm"
			ElementName="#event.getCustomElementName()#CustomElement"
			ElementType="custom:#event.getCustomElementName()#"><cfoutput>
	</div>
	<div id="footer-wrapper"></cfoutput>
		<cfinclude template="#config.getIncludesDirectory()#dsp-footer.cfm" /><cfoutput>
	</div>
</div></cfoutput>

<!--- try to include the insight template --->
<cftry>
	<cfinclude 
		template="#config.getFigLeafIncludeDirectory()#developer-insight.cfm" />
	<cfcatch><cfoutput>Error including the insight template:<br />#cfcatch.message#</cfoutput></cfcatch>
</cftry>