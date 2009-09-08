<!--- -------------------------------------------------------------------------------------------------------------------
Filename: /mediaAssets/delete.cfm

Creation Date: May 2004

Author: Steve Drucker (sdrucker@figleaf.com)
Fig Leaf Software (www.figleaf.com)

Purpose:
Breaks the relationship between an article and a file asset

Call Syntax:
Invoked from /customfields/mediaAssets_rendering.cfm through
a hidden iframe


Modification Log:
=====================================
01/02/2005 sdrucker	updated documentation
03/12/2007 sdrucker,qsowell	fixed media asset deletion problem
-------------------------------------------------------------------------------------------------------------------  --->
<cftry>
<cfset Application.mediassets = application.beanfactory.getBean("mediaassets") />

<cfset _fileAssets = Application.mediassets.getService("FileAssets") />
<cfset config = application.beanfactory.getBean("ConfigBean") />
<cfset application.figleaf.url = config.getFigLeafFileContext() & "/"/>
<cfset request.scoperedirect = "/standards-gov/customcf/scoperedirect.cfm" />

<!--- <cfset _fileAssets = Application.mediaassets.getService("FileAssets") />
<cfset factory = Application.BeanFactory.getBean("BeanFactory") />
<cfset config = factory.getBean("ConfigBean") />

<cfset application.figleaf.url = config.getFigLeafFileContext() & "/"/>
<cfset request.scoperedirect = "/customcf/scoperedirect.cfm" /> --->

<cfset dsn = config.getCommonSpotSupportDSN() />

<cfparam name="url.id"> 		<!--- file asset id --->
<cfparam name="url.pageid">	<!---- article id --->
<cfparam name="url.closewin" default="false">

<cfstoredproc datasource="#dsn#" procedure="ArticleFileAsset_DeleteByFileAssetID">
	<cfprocparam dbvarname="fileassetid" type="in" cfsqltype="cf_sql_integer" value="#url.id#">
	<cfprocparam dbvarname="pageid" type="in" cfsqltype="cf_sql_integer" value="#url.pageid#">
	<cfprocparam dbvarname="updateuser" type="in" cfsqltype="cf_sql_varchar" value="#session.user.name#">
</cfstoredproc>

<!---
<cfif url.closewin eq true>
	<cfoutput><script language="javascript">window.close();</script></cfoutput>
</cfif>
--->

<cfoutput>
<script language="JavaScript">
	#url.callback#
</script>
</cfoutput>
<cfcatch type="any">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>