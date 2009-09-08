
<!--- -------------------------------------------------------------------------------------------------------------------
Filename: /mediaAssets/Edit.cfm
Creation Date: May 2004
Author: Steve Drucker (sdrucker@figleaf.com)
Fig Leaf Software (www.figleaf.com)
Purpose:
Edit the properties of a file asset
Call Syntax:
Invoked into a new dialog box
Notes: Passes form data back to the original calling window through JavaScript
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
<cfset request.scoperedirect = "/customcf/scoperedirect.cfm" /> --->

<cfset dsn = config.getCommonSpotSupportDSN() />


<!--- retrieve the file asset --->
<cfset qfileasset = _fileAssets.get(url.fileassetid)>

<!--- get file asset category list --->
<cfstoredproc datasource="#dsn#" procedure="fileassetcategory_get">
	<cfprocresult name="qcategories" resultset="1">
</cfstoredproc>

<!--- get specific file information related to the article --->
<cfstoredproc datasource="#dsn#" procedure="articlefileasset_getbyids">
	<cfprocparam type="in" cfsqltype="cf_sql_integer" dbvarname="pageid" value="#url.pageid#">
	<cfprocparam type="in" cfsqltype="cf_sql_integer" dbvarname="fileassetid" value="#url.fileassetid#">
	<cfprocresult name="qarticlefileasset" resultset="1">
</cfstoredproc>
<cfoutput>
<html>
<head>
<title>Edit Media Asset</title>
<script language="javascript">
	if (window.dialogArguments) {
    	window.opener = window.dialogArguments;
  	}
	var win=window.opener;
	var thetype = '#qfileasset.filetype#';
	var thequality = '#qfileasset.quality#';

	function fnSubmit() {
		if (_CF_checkCFForm_1(document.forms[0])) {

			win.alinks_#fqfieldname#[win.iLink_#url.fqfieldname#].title = document.forms[0].langfiledescription.value;
			win.alinks_#fqfieldname#[win.iLink_#url.fqfieldname#].quality = thequality;
			win.alinks_#fqfieldname#[win.iLink_#url.fqfieldname#].filetype = thetype;
			win.fileasset_#fqfieldname#.location.href='#request.scoperedirect#?url=#application.figleaf.url#mediaAssets/update.cfm&fqfieldname=#url.fqfieldname#&articlefileassetid=#qarticlefileasset.articlefileassetid#&pageid=#url.pageid#&siteid=#url.siteid#&id=#url.fileassetid#&filetype=' + thetype + '&fileassetcategoryid=' + document.forms[0].fileassetcategoryid[document.forms[0].fileassetcategoryid.selectedIndex].value + '&filedescription=' + document.forms[0].filedescription.value + '&langfiledescription=' + document.forms[0].langfiledescription.value + '&quality=' + thequality;
			win.fnDrawLinks_#url.fqfieldname#();
			window.close();
		}
	 }

	function fnCopyDesc() {
		document.forms[0].langfiledescription.value = document.forms[0].filedescription.value;
	}
</script>
<style>
	td {
		font-family: verdana;
		font-size: 10px;
	}
	.clsFinishButton { font-family:Verdana,Arial;font-size:xx-small; }

	input {
		font-family: Verdana;
		font-size: 10px;
	}

</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>

<body leftmargin="0" topmargin="0" scroll="no">


<cfform action="#request.scoperedirect#?url=#application.figleaf.url#mediaassets/update.cfm">
<br>

	<table align="center">
		<tr>
			<td><strong>Description:</strong></td>
			<td><cfinput type="text" name="filedescription" size="40" required="Yes"  maxlength="2048" message="You must enter a description" value="#qfileasset.filedescription#">
			<img src="/commonspot/images/copydown.gif" border="0" onClick="fnCopyDesc()">
			</td>
		</tr>
		<tr>
			<td><strong>Description:<br>(in language)</strong></td>
			<td><cfinput type="text" name="langfiledescription" size="40" required="Yes"  maxlength="2048" message="You must enter a description in language" value="#qarticlefileasset.filedescription#"></td>
		</tr>
		<tr>
			<td><strong>Category:</strong></td>
			<td><select name="fileassetcategoryid">
				<cfloop query="qcategories">
				   <option value="#fileassetcategoryid#" <cfif qcategories.fileassetcategoryid is qfileasset.fileassetcategoryid>selected</cfif>>#fileassetcategoryname#</option>
				</cfloop>
				 </select>
			</td>
		</tr>
		<tr>
			<td><strong>Type:</strong></td>
			<td>
			<input type="radio" name="filetype" value="Audio" required="yes"  <cfif qfileasset.filetype is "Audio">checked</cfif> onClick="thetype=this.value">Audio
			<input type="radio" name="filetype" value="Video" required="yes"  <cfif qfileasset.filetype is "Video">checked</cfif> onClick="thetype=this.value">Video
			<input type="radio" name="filetype" value="Other" required="yes"  <cfif qfileasset.filetype is "Other">checked</cfif> onClick="thetype=this.value">Other
			</td>
		</tr>

		<tr>
		<td><strong>Quality:</strong></td>
			<td>
			<input type="radio" name="quality" value="1" required="yes"  <cfif qfileasset.quality is "1">checked</cfif> onClick="thequality=this.value">Dialup
			<input type="radio" name="quality" value="2" required="yes"  <cfif qfileasset.quality is "2">checked</cfif> onClick="thequality=this.value">Broadband
		</td>
		</tr>


		<td colspan="2" align="right">
			<input type="button"
				name="btnSubmit"
				onClick="fnSubmit()"
				value="Update" class="clsFinishButton">
		</td>
		</tr>
	</table>
	<input type="hidden" name="fqfieldname" value="#url.fqfieldname#">
</cfform>

</body>
</html>
</cfoutput>
<cfcatch type="any">
	<cfdump var="#cfcatch#">
	<cfabort />
</cfcatch>
</cftry>