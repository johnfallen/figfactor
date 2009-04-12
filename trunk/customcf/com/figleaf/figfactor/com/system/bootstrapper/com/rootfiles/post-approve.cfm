<!--- Document Information -----------------------------------------------------
Title: 				post-approve.cfm
Author:				John Allen
Email:					jallen@figleaf.com
Company:			Figleaf Software
Website:			http://www.nist.gov
Purpose:			I include the Fig Leaf post-approve.cfm file.
Usage:				
================================================================================
John Allen		30/09/2008		Created
------------------------------------------------------------------------------->
<cfset config = Application.FigFactor.getBean("ConfigBean") />
<cfinclude 
	template="#config.getFigLeafIncludeDirectory()#/custom-authentication.cfm" />