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

<cfparam name="url.fileassetids" default="">
<cfparam name="url.pageid" default="-1">
<cfparam name="url.siteid" default="-1">
<cfif url.pageid neq "-1" and url.siteid neq "-1" and url.fileassetids neq "">
  <cfset current_rank = 1>
  <cfloop list="#url.fileassetids#" index="current_asset">
    <cfstoredproc datasource="#dsn#" procedure="articlefileasset_updaterank">
      <cfprocparam type="in" cfsqltype="cf_sql_integer" dbvarname="fileassetid" value="#current_asset#">
      <cfprocparam type="in" cfsqltype="cf_sql_integer"  dbvarname="siteid" value="#url.siteid#">
      <cfprocparam type="in" cfsqltype="cf_sql_integer"  dbvarname="pageid" value="#url.pageid#">
      <cfprocparam type="in" cfsqltype="cf_sql_integer"  dbvarname="rank" value="#current_rank#">
    </cfstoredproc>
    <cfset current_rank = current_rank + 1>
  </cfloop>
  <cfif url.fileassetids is "">
    <cfset url.fileassetids = "0">
  </cfif>
  <cfquery datasource="#dsn#">

		delete

		from articlefileasset

		where pageid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.pageid#">

			and siteid =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.pageid#">

			and fileassetid not in (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.fileassetids#" list="yes">)

	</cfquery>
</cfif>
<cfoutput>
  <script language="JavaScript">

			var fbutton = parent.document.getElementById('idFinishButton');
			fbutton.disabled = false;
	</script>
</cfoutput>
<cfcatch type="any">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>