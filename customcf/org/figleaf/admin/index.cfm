<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title: 				index.cfm
Author:				John Allen
Email:					jallen@figleaf.com
Company:			Figleaf Software
Purpose:			I manage the display of the admin section.
================================================================================
John Allen		30/08/2008		Created
------------------------------------------------------------------------------->
<cfparam name="url.viewDirectory" default="home" type="string" />

<cfif not structkeyexists(Application, "FigLeafSystem") or structkeyexists(url, "init")>
	<cfinclude template="../index.cfm" />
</cfif>
<cfset factory = Application.BeanFactory.getBean("BeanFactory") />
<cfset config = factory.getBean("ConfigBean") />

<!--- ************* Display ************* --->

<!--- headers and menu --->
<cfinclude template="includes/header.cfm" />
<cfinclude template="includes/menu.cfm" />
<cfoutput><div id="page-wrapper"></cfoutput>
<!--- configuration is a selfsubmiting form so forward to the page --->

<cfif url.viewDirectory eq "configuration">
	<cflocation url="configuration/index.cfm" />
<cfelseif url.viewDirectory eq "deploymentservice">
	<cflocation url="cffm/cffm.cfm">
<cfelse>
	<cfinclude template="#url.viewDirectory#/index.cfm" />	
</cfif>

<cfoutput></div></cfoutput>
<cfinclude template="includes/footer.cfm" />