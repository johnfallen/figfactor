<cfset Application.mediassets = application.beanfactory.getBean("mediaassets") />

<cfset _fileAssets = Application.mediassets.getService("FileAssets") />
<cfset config = application.beanfactory.getBean("ConfigBean") />
<cfset application.figleaf.url = config.getFigLeafFileContext() & "/"/>
<cfset request.scoperedirect = "/standards-gov/customcf/scoperedirect.cfm" />

<!--- <cfset _fileAssets = Application.mediaassets.getService("FileAssets") />
<cfset factory = Application.BeanFactory.getBean("BeanFactory") />
<cfset config = factory.getBean("ConfigBean") /> --->

<cfset dsn = config.getCommonSpotSupportDSN() />

<cfset qfileasset = _fileAssets.get(url.id)>

<cfset _fileAssets.update (fileassetid = url.id,
			fileassetcategoryid = url.fileassetcategoryid,
			filename = qfileasset.filename,
			filetype = url.filetype,
			quality = url.quality,
			fileext = qfileasset.fileext,
			fullpath = qfileasset.fullpath,
			filedescription = url.filedescription,
			updateuser = session.user.name)>
<cfif url.articlefileassetid is "">
  <cfstoredproc datasource="#dsn#" procedure="articlefileasset_insert">
    <cfprocparam type="in" cfsqltype="cf_sql_integer" dbvarname="fileassetid" value="#url.id#">
    <cfprocparam type="in" cfsqltype="cf_sql_integer"  dbvarname="siteid" value="#url.siteid#">
    <cfprocparam type="in" cfsqltype="cf_sql_integer"  dbvarname="pageid" value="#url.pageid#">
    <cfprocparam type="in" cfsqltype="cf_sql_integer"  dbvarname="formid" value="#listgetat(url.fqfieldname,2,"_")#">
    <cfprocparam type="in" cfsqltype="cf_sql_nvarchar"  dbvarname="filedescription" value="#url.langfiledescription#">
    <cfprocparam type="in" cfsqltype="cf_sql_varchar"  dbvarname="updateuser" value="#session.user.name#">
  </cfstoredproc>
  <cfelse>
  <cfstoredproc datasource="#dsn#" procedure="articlefileasset_update">
    <cfprocparam type="in" cfsqltype="cf_sql_integer"  dbvarname="articlefileassetid" value="#url.articlefileassetid#">
    <cfprocparam type="in" cfsqltype="cf_sql_varchar"  dbvarname="filedescription" value="#url.langfiledescription#">
    <cfprocparam type="in" cfsqltype="cf_sql_varchar"  dbvarname="updateuser" value="#session.user.name#">
  </cfstoredproc>
</cfif>