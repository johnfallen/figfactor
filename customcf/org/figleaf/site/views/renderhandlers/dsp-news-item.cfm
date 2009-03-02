<!--- Document Information -----------------------------------------------------
Title:      	ce_dspNewsItem.cfm
Author:     John Allen
Email:      	jallen@figleaf.com
company:   Figleaf Software
Website:    http://www.nist.gov
Purpose:   I am the render handler, the "view", for an News Item. 
Modification Log:
Name				Date				Description
================================================================================
John Allen		22/03/2008		Created
------------------------------------------------------------------------------->
<cftry>
<!--- set the pageEvent and custom element data --->
<cfset event = Application.vf.getPageEvent(elementInfo = attributes.elementInfo) />
<cfset News = event.getCustomElementData() />

<cfoutput>
<div id="render-handler-wrapper">
<cfdump var="#News#" label="News Item Custom Element Data" />
</div>

</cfoutput>
<cfcatch></cfcatch>
</cftry>