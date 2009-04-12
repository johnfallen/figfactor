<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title: 				ViewStateController.cfm
Author:				John Allen
Email:					jallen@figleaf.com
company:			Figleaf Software
Purpose:			I am the ViewStateController used render a Events custom 
						element.
Modification Log:
Name				Date				Description
================================================================================
John Allen		12/07/2008		Created
------------------------------------------------------------------------------->
<cfset event = Application.FigFactor.getEvent() />
<cfmodule template="/commonspot/utilities/ct-render-named-element.cfm"
	ElementName="#event.getCustomElementName()#CustomElement"
	ElementType="custom:#event.getCustomElementName()#">
	
	
