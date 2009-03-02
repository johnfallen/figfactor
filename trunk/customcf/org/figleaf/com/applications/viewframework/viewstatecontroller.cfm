<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title: 				ViewStateController.cfm
Author:				John Allen
Email:					jallen@figleaf.com
company:			Figleaf Software
Purpose:			I am the ViewStateController used to determine what 
						custom element to render.
Modification Log:
Name				Date				Description
================================================================================
John Allen		12/07/2008		Created
------------------------------------------------------------------------------->
<cfset ContollerPageEvent = Application.ViewFramework.getPageEvent() />
<cfsavecontent variable="foo">
<cfmodule template="/commonspot/utilities/ct-render-named-element.cfm"
	ElementName="#ContollerPageEvent.getCustomElementName()#CustomElement"
	ElementType="custom:#ContollerPageEvent.getCustomElementName()#">
</cfsavecontent>
<cfoutput>
<hr />
#foo#
<hr />
</cfoutput>
<cfabort />