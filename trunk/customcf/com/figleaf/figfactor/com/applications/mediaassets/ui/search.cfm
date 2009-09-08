<!--- -------------------------------------------------------------------------------------------------------------------

Filename: /mediaAssets/search.cfm

Creation Date: May 2004

Author: Steve Drucker (sdrucker@figleaf.com)
Fig Leaf Software (www.figleaf.com)

Purpose:
QBE interface to located media assets

Call Syntax:
Invoked by the mediaAssets_rendering.cfm custom field type

Other:
Uses global function to determine url path to asset
Uses IFRAME sresults to display search results
Uses IFRAME spreview to preview a selected media asset

Modification Log:
=====================================
01/05/2005 sdrucker	updated documentation

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

<!--- get file asset category list --->
<cfquery name="qcats" datasource="#dsn#">
   {call fileassetcategory_get}
</cfquery>

<!--- get distinct file extensions --->
<cfquery name="qext" datasource="#dsn#">
   select distinct fileext
   from fileasset
   order by fileext
</cfquery>

<!--- we are just dealing with one site for now --->
<!---<cfset asites = application.figleaf.asites>
<cfset stsites = structnew()>
<cfloop from="1" to="#arraylen(asites)#" index="i">
  <cfloop collection="#asites[i].stsites#" item="thissite">
    <cfset stsites[thissite] = asites[i].stsites[thissite].siteid>
  </cfloop>
</cfloop>--->
<cfoutput>
<html>
<head><title>Search Media Assets</title>
<style>
   .prompt {
    font-family: Arial;
    font-size: 12px;
    font-weight: bold;
   }
   select {
     font-family: Arial;
     font-size: 12px;
   }
   legend {
     font-family: Arial;
     font-size: 12px;
     font-weight: bold;
   }
   .abutton {
	font-family: Arial;
        font-size: 10px;
   }
</style>
<script language="javascript">
	function fnSubmit() {
		if (_CF_checkCFForm_1(document.forms[0])) {
			document.forms[0].submit();
		}
	}
</script>
</head>
<body topmargin="1" leftmargin="1">

<!--- form submits to searchresults.cfm in same directory --->
<cfform action="#request.scoperedirect#" method="post" target="sresults">
<input type="hidden" name="url" value="#application.figleaf.url#com/applications/mediaAssets/ui/searchresults.cfm">
<input type="hidden" name="pageid" value="#url.pageid#">
<input type="hidden" name="thesiteid" value="#url.siteid#">
<input type="hidden" name="formid" value="#url.formid#">
<input type="hidden" name="callback" value="#url.callback#">
<table width="100%" border="0" cellpadding="0">
<tr valign="top">
<td  width="50%">
<fieldset style="height: 100%;"><legend>Search Criteria</legend>
<div class="prompt">Select Site:</div>
<select name="siteid" style="width:90%">
  <option value="">---Please Select---</option>
<!---  <cfloop collection="#stsites#" item="thissite">--->
    <option value="#url.siteid#">Default Site</option>
<!---  </cfloop>--->
</select>
<div class="prompt">Select Category:</div>
<select name="fileassetcategoryid" style="width:90%">
  <option value="">---Please Select---</option>
  <cfloop query="qcats">
    <option value="#fileassetcategoryid#">#fileassetcategoryname#</option>
  </cfloop>
</select><br>
<div class="prompt">Select File Type:</div>
<select name="filetype" style="width:90%">
  <option value="">---Please Select---</option>
  <option value="Audio">Audio</option>
  <option value="Video">Video</option>
  <option value="Streaming">Streaming Video</option>
</select><br>
<div class="prompt">Select File Ext:</div>
<select name="fileext" style="width:90%">
  <option value="">---Please Select---</option>
  <cfloop query="qext">
    <option value="#qext.fileext#">#qext.fileext#</option>
  </cfloop>
</select><br>
<div class="prompt">Upload Date:</div>
<input type="text" name="date1" size="12"> - <input type="text" name="date2" size="12"><br>
<div class="prompt">Description:<br></div>
<input type="text" name="description" size="30" style="width:90%">
<br>
<br>
<div align="center"><input type="button" value="Search" class="abutton" onClick="fnSubmit()"></div>
</fieldset>
</td>
<td width="50%"><fieldset style="height:100%"><legend id="sresultscaption">Search Results</legend>
<iframe name="sresults" src="#application.figleaf.url#com/applications/mediaAssets/ui/empty.cfm" style="width:100%; height:265px" hspace="0" vspace="0" frameborder="No"></iframe>
</td>
</tr>
<!--- <tr valign="top">
<td colspan="2"><fieldset style="height:100%"><legend id="pcaption">Preview</legend>
<iframe name="spreview" src="#application.figleaf.url#mediaassets/empty.htm" style="width:100%; height:100px" hspace="0" vspace="0" frameborder="No"></iframe>
</fieldset>
</td>
</tr> --->
</table>
</cfform>
</body>
</html>
</cfoutput>
<cfcatch type="any">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>