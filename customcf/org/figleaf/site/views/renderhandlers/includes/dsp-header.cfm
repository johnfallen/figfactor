<!--- Document Information -----------------------------------------------------
Title:			dspHeader.cfm
Author:		John Allen
Email:			jallen@figleaf.com
company:	Figleaf Software
Website:	@@@web-site@@@
Purpose:	I am the code that dynamically creates the headers.
Modification Log:
Name				Date				Description
================================================================================
John Allen		09/17/2008		Created
------------------------------------------------------------------------------->

<cfset google = Application.BeanFactory.getBean("Google") />
<cfset header = Application.ViewFramework.getPageEvent() />
<!--- 
All banners will share this HTML but will display different background colors 
based on what Override CSS is applied at the base-template.cfm file in the 
'.base-template-wrapper' class.
--->
<cfif header.getSiteContext() neq "/">
	<cfset variables.homepageLink = "#header.getSiteContext()#/index.cfm">
<cfelse>	
	<cfset variables.homepageLink = "/index.cfm">
</cfif>
<cfoutput>
<div id="meta-navigation-wrapper">	
	<div id="google-search-form-wrapper">#google.getSearchForm()#</div>
	<a href="#variables.homepageLink#">
		<span class="meta-header">ViewFramework Head Start</span>
	</a>
</div>
</cfoutput>
