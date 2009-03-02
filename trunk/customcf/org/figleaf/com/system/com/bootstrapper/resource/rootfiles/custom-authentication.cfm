<!--- Document Information -----------------------------------------------------
Title: 					custom-authentication.cfm
Author:					John Allen
Email:						jallen@figleaf.com
Company:				Figleaf Software
Website:				http://www.nist.gov
Purpose:				I authenticate users against an external system then log 
							them into CommonSpot
Usage:					I am called by CommonSpot
================================================================================
John Allen		29/09/2008		Created
------------------------------------------------------------------------------->
<cfset Config = Application.BeanFactory.getBean("ConfigBean") />
<cfinclude 
	template="#config.getFigLeafIncludeDirectory()#/custom-authentication.cfm" />