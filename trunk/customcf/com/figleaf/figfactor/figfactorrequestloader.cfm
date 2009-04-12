<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title: 				ViewStateController.cfm
Author:				John Allen
Email:					jallen@figleaf.com
company:			Figleaf Software
Purpose:			I am the code that creates the Event object for the request. 
Modification Log:
Name				Date				Description
================================================================================
John Allen		04/10/2008		Created
------------------------------------------------------------------------------->
<cfset Application.FigFactor.getFactory().getBean("EventService").createEvent() />
