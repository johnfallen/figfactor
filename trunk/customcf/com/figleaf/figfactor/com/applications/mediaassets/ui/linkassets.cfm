<!--- -------------------------------------------------------------------------------------------------------------------
Filename: /mediaAssets/LinkAssets.cfm
Creation Date: May 2004
Author: Steve Drucker (sdrucker@figleaf.com)
Fig Leaf Software (www.figleaf.com)
Purpose:
Business logic that establishes link between media asset and article
Call Syntax:
Invoked from an iframe in the mediaAsset_rendering custom field type
Modification Log:
=====================================
01/02/2005 sdrucker	updated documentation
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
<cfset request.scoperedirect = "/customcf/scoperedirect.cfm" />
 --->
<cfset dsn = config.getCommonSpotSupportDSN() />

<cfparam name="form.pageid" type="numeric">
<cfparam name="form.siteid" type="numeric">
<cfparam name="form.formid" type="numeric">
<!---

	write out relationships

--->
<cfset lsuccess="">
<cftransaction>
<cfloop list="#form.fileid#" index="thisfileassetid">
   <cfstoredproc datasource="#dsn#" procedure="articlefileasset_insert">
	<cfprocparam type="in" cfsqltype="cf_sql_integer"  dbvarname="fileassetid" value="#variables.thisfileassetid#">
 	<cfprocparam type="in" cfsqltype="cf_sql_integer"  dbvarname="siteid" value="#form.siteid#">
	<cfprocparam type="in" cfsqltype="cf_sql_integer"  dbvarname="pageid" value="#form.pageid#">
	<cfprocparam type="in" cfsqltype="cf_sql_integer"  dbvarname="formid" value="#form.formid#">
	<cfprocparam type="in" cfsqltype="cf_sql_varchar"  dbvarname="filedescription" value="">
	<cfprocparam type="in" cfsqltype="cf_sql_varchar"  dbvarname="updateuser" value="#session.user.name#">
	<cfprocresult resultset="1" name="articlefileasset">
   </cfstoredproc>

   <cfif articlefileasset.articlefileassetid gt -1>
      <cfset lsuccess=listappend(lsuccess,articlefileasset.articlefileassetid)>
   </cfif>
</cfloop>
</cftransaction>

<!---

Update screen

--->

<cfif trim(lsuccess) is not "">
 <cfquery name="qgetdata" datasource="#dsn#">
    select fileasset.*, articlefileasset.rank as articlerank
    from   fileasset join articlefileasset
	   on (fileasset.fileassetid = articlefileasset.fileassetid)
    where  articlefileassetid in (#variables.lsuccess#)
	and fileasset.endtime is null
	order by articlerank asc
 </cfquery>
 <cfoutput>
 <script language="JavaScript">
 thewin = parent.parent.window.opener;
 <cfloop query="qgetdata">
   thewin.#form.callback#('#jsstringformat(qgetdata.filedescription)#',#qgetdata.fileassetid#,'#qgetdata.filetype#')
 </cfloop>
 </script>
 </cfoutput>
</cfif>

<cfoutput>
<script language="JavaScript">
   alert("Function Complete");
</script>
</cfoutput>
<cfcatch type="any">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>