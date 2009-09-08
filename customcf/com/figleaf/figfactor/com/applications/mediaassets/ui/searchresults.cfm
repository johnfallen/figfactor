<!--- -------------------------------------------------------------------------------------------------------------------

Filename: /mediaAssets/searchResults.cfm

Creation Date: May 2004

Author: Steve Drucker (sdrucker@figleaf.com)
Fig Leaf Software (www.figleaf.com)

Purpose:
Search results UI from QBE

Call Syntax:
Invoked by the search.cfm file in an IFRAME

Other:
Uses IFRAME "linksave"  to invoke server-side logic for linking asset to article

Modification Log:
=====================================
01/05/2005 sdrucker	updated documentation, migrated search query into fileasset CFC

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
<cfparam name="form.pageid" type="numeric">
<cfparam name="form.thesiteid" type="numeric">
<cfparam name="form.formid" type="numeric">


<cfscript>
function mediaAssetPath(sitename,uploadDate,filetype,filename) {
	var thebaseurl = "";
	var thedir = replace(sitename," ","_","ALL");
	thedir = replace(thedir,"-","_","ALL");
	thebaseurl = application.fileassets.url & thedir;
	thebaseurl = thebaseurl & "/" & dateformat(uploadDate,"yyyy_mm");
	thebaseurl = thebaseurl & "/" & filetype;
	thebaseurl = thebaseurl & "/" & listgetat(filename,2,".") & "/" & filename;

	return thebaseurl;
}
</cfscript>
<cfset qsearchresults = _fileAssets.search (description = form.description, startdate = form.date1, enddate = form.date2, fileassetcategoryid = form.fileassetcategoryid, fileext = form.fileext, filetype = form.filetype, siteid = form.siteid)>

<cfoutput>
<html>
<head>
<style>
TD {
  border-right: 1px solid black;
  border-bottom: 1px solid black;
  font-family: arial;
  font-size: 8pt;
}
TH {
  border-right: 1px solid black;
  border-bottom: 1px solid black;
  font-family: arial;
  font-size: 8pt;
  font-weight: bold;
}
.normal {
  font-family: arial;
  font-size: 8pt;
}
FORM {
  margin-top: 0px;
}
.abutton {
	font-family: Arial;
        font-size: 10px;
}
</style>
<script language="JavaScript">
  parent.document.all.sresultscaption.innerText = "Your query returned #qsearchresults.recordcount# results";
  function fnURL(u,c) {
    parent.document.all.pcaption.innerText = c;
    parent.spreview.location.href = u;
  }
</script>
</head>
<body leftmargin="1" topmargin="1" scroll="no" class="normal">
<cfif qsearchresults.recordcount gt 0>
<form action="#request.scoperedirect#" method="post" target="linksave">
<input type="hidden" name="url" value="#application.figleaf.url#mediaAssets/linkassets.cfm">
<input type="hidden" name="pageid" value="#form.pageid#">
<input type="hidden" name="siteid" value="#form.thesiteid#">
<input type="hidden" name="formid" value="#form.formid#">
<input type="hidden" name="callback" value="#form.callback#">
<div style="width:100%; height:245px; overflow:auto">
  <table border="0" cellpadding="1" cellspacing="1" width="100%">
  <tr><th></th><th>Description</th><th>Type</th><th>Ext</th></tr>
  <cfloop query="qsearchresults">
    <tr>
        <td><input type="checkbox" name="fileid" value="#qsearchresults.fileassetid#"></td>
	<td>#qsearchresults.filedescription#</td>
	<td>#qsearchresults.filetype#</td>
	<td>#qsearchresults.fileext#</td>
    </tr>
  </cfloop>
  </table>
</div>

<div align="center"><input type="submit" value="Add to Article" class="abutton"></div>
</form>
<iframe src="#application.figleaf.url#mediaAssets/empty.cfm" name="linksave" style="display:none"></iframe>
</cfif>

</body>
</html>
</cfoutput>
<cfcatch type="any">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>