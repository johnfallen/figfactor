<!--- invoke CFC --->

<!--- <cfobject component="#application.figleaf.componentpath#FileAsset"
				name="FileAsset"> --->

<!--- figleaf\MediaAssets\upload.cfm --->
<cftry>


<!--- <cfset factory = Application.BeanFactory.getBean("BeanFactory") />
<cfset config = factory.getBean("ConfigBean") /> --->
<cfset Application.mediassets = application.beanfactory.getBean("mediaassets") />

<cfset _fileAssets = Application.mediassets.getService("FileAssets") />
<cfset config = application.beanfactory.getBean("ConfigBean") />
<cfset application.figleaf.url = config.getFigLeafFileContext() & "/"/>
<cfset request.scoperedirect = "/standards-gov/customcf/scoperedirect.cfm" />

<cfset dsn = config.getCommonSpotSupportDSN() />
<cfset siteid = request.site.id />
<cfset mediapageID = url.pageid />

<cfquery name="qcategories" datasource="#dsn#">
	{call fileAssetCategory_get }
</cfquery>

<cfset arrMedia = _fileAssets.GetTranscript_MediaList(siteid=#siteid#, pageid = #mediapageID#)>

<cfset numRecords = arraylen(arrMedia)>

<cfif isdefined("form.filedescription")>

	<cfscript>
		thedir = replace(request.site.name," ","_","ALL");
		thedir = replace(variables.thedir,"-","_","ALL");
		thedir = application.fileassets.path & variables.thedir;
		thebaseurl = application.fileassets.url & variables.thedir;
	</cfscript>

	<!--- check directory structure --->
	<cfif not directoryExists(thedir)>
		<cfdirectory action="create" directory="#variables.thedir#">
	</cfif>

	<!--- assemble path - year/month --->
	<cfset thedir = thedir & "/" & dateformat(now(),"yyyy_mm")>
	<cfset thebaseurl = thebaseurl & "/" & dateformat(now(),"yyyy_mm")>
	<cfif not directoryexists(thedir)>
		<cfdirectory action="create" directory="#variables.thedir#">
	</cfif>

	<!--- assemble path - file type --->
	<cfset thedir = thedir & "/" & form.filetype>
	<cfset thebaseurl = thebaseurl & "/" & form.filetype>
	<cfif not directoryexists(thedir)>
		<cfdirectory action="create" directory="#variables.thedir#">
	</cfif>

	<!--- assemble path - file extension --->
	<cfif (form.filetype NEQ "Transcript") OR (form.filetype NEQ "Streaming")>
		<cfset thedir = thedir & "/" & form.fileext>
		<cfset thebaseurl = thebaseurl & "/" & form.fileext>
		<cfif not directoryexists(thedir)>
			<cfdirectory action="create" directory="#variables.thedir#">
		</cfif>
	</cfif>

	<!--- upload file --->
    <cfif form.filetype NEQ "Streaming">
        <cffile action="upload"
                 destination="#variables.thedir#"
                 filefield="form.thefile"
                 nameconflict="OVERWRITE">
    <cfelse>

	</cfif>
	<!--- Changing the original transcript file name by adding the fileassetid at the begining --->
	<cfif form.filetype eq "Transcript">
		<cfset newfilename = form.pagemediaid & "_" & file.serverfile>

		<!---Date/Time stamp to append to original file name--->
		<cfset AppendStamp = #DateFormat(Now(), 'mm_dd_yyyy')#>

		<cffile action="rename"
	            source="#file.serverdirectory#/#file.serverfile#"
	            destination="#file.serverdirectory#/#newfilename#">
	</cfif>

	<!--- write file to database --->
<!---	<cfif form.filetype neq "Transcript"> we may need a transcript later --->
	<cfif form.filetype neq "Streaming">

		<cfset fileassetid = _fileAssets.RecordInsert (siteid = request.site.id, fileassetcategoryid = form.fileassetcategoryid, filename = file.serverfile, filetype = form.filetype, quality = form.quality, fileext = form.fileext,  fullpath = "#file.serverdirectory#/#file.serverfile#",  filedescription = form.filedescription,  updateuser = session.user.name)>
		<cfstoredproc datasource="#dsn#" procedure="articlefileasset_insert">
			<cfprocparam type="in" dbvarname="fileassetid" cfsqltype="cf_sql_int" value="#variables.fileassetid#">
			<cfprocparam type="in" dbvarname="siteid" cfsqltype="cf_sql_int" value="#request.site.id#">
			<cfprocparam type="in" dbvarname="pageid" cfsqltype="cf_sql_int" value="#url.pageid#">
			<cfprocparam type="in" dbvarname="formid" cfsqltype="cf_sql_int" value="#url.formid#">
			<cfprocparam type="in" dbvarname="filedescription" cfsqltype="cf_sql_varchar" value="#form.filedescription#">
			<cfprocparam type="in" dbvarname="updateuser" cfsqltype="cf_sql_varchar" value="#session.user.name#">
			<cfprocresult name="articlefileasset" resultset="1">
		</cfstoredproc>

		<cfoutput>
			<script  language="javascript">
				alert("File Uploaded");
				window.opener.fnAddLink_#url.fqfieldname#('#jsStringFormat(form.filedescription)#',#variables.fileassetid#,'#form.filetype#',#form.quality#);
			</script>
		</cfoutput>

	<cfelse>
		<cfset fileassetid = _fileAssets.RecordInsert (siteid = request.site.id, fileassetcategoryid = form.fileassetcategoryid, filename = form.filename, filetype = form.filetype, quality = form.quality, fileext = form.fileext,  fullpath = form.theurl,  filedescription = form.filedescription,  updateuser = session.user.name)>
		<cfstoredproc datasource="#dsn#" procedure="articlefileasset_insert">
			<cfprocparam type="in" dbvarname="fileassetid" cfsqltype="cf_sql_int" value="#variables.fileassetid#">
			<cfprocparam type="in" dbvarname="siteid" cfsqltype="cf_sql_int" value="#request.site.id#">
			<cfprocparam type="in" dbvarname="pageid" cfsqltype="cf_sql_int" value="#url.pageid#">
			<cfprocparam type="in" dbvarname="formid" cfsqltype="cf_sql_int" value="#url.formid#">
			<cfprocparam type="in" dbvarname="filedescription" cfsqltype="cf_sql_varchar" value="#form.filedescription#">
			<cfprocparam type="in" dbvarname="updateuser" cfsqltype="cf_sql_varchar" value="#session.user.name#">
			<cfprocresult name="articlefileasset" resultset="1">
		</cfstoredproc>

		<cfoutput>
			<script  language="javascript">
				alert("File Uploaded");
				window.opener.fnAddLink_#url.fqfieldname#('#jsStringFormat(form.filedescription)#',#variables.fileassetid#,'#form.filetype#',#form.quality#);
			</script>
		</cfoutput>
<!---		<cfstoredproc datasource="#dsn#" procedure="FileAssetTranscript_Add">
			<cfprocparam type="in" dbvarname="fileassetid" cfsqltype="cf_sql_int" value="#form.pagemediaid#">
			<!--- <cfprocparam type="in" dbvarname="transcriptfilename" cfsqltype="cf_sql_varchar" value="#file.serverfile#"> --->
			<cfprocparam type="in" dbvarname="transcriptfilename" cfsqltype="cf_sql_varchar" value="#variables.newfilename#">
			<cfprocparam type="in" dbvarname="transcriptfullpath" cfsqltype="cf_sql_varchar" value="#file.serverdirectory#\#variables.newfilename#">
			<cfprocparam type="in" dbvarname="updateuser" cfsqltype="cf_sql_varchar" value="#session.user.name#">
			<cfprocresult name="fileassettranscript" resultset="1">
		</cfstoredproc>

		<cfoutput>
			<script  language="javascript">
				alert("File Uploaded");
			</script>
		</cfoutput>
--->	</cfif>

</cfif>

<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Add/Edit File Asset</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style>
	TD, INPUT, SELECT
	{
		font-family: Verdana, Arial, Helvetica, sans-serif;
		font-size: 12px;
	}

	.clsFinishButton { font-family:Verdana,Arial;font-size:xx-small; }
</style>

<script language="javascript">
	function fnValidate()
	{
		var blnTranscript = false;
		var filetypeVal = '';
		var qualityVal = '';
		var i = 0;
		var aname = '';

		for (i=0; i<document.forms[0].filetype.length; i++)
		{
			if (document.forms[0].filetype[i].checked)
			{
				filetypeVal = document.forms[0].filetype[i].value;
			}

			if (filetypeVal == 'Transcript')
			{
				blnTranscript = true;
			}
		}

		for (i=0; i<document.forms[0].quality.length; i++)
		{
			if (document.forms[0].quality[i].checked)
			{
				qualityVal = document.forms[0].quality[i].value;
			}
		}

		if (_CF_checkCFForm_1(document.forms[0]))
		{
			if (filetypeVal != 'Transcript')
			{
				if (document.forms[0].fileassetcategoryid.selectedIndex == 0)
				{
					alert("You must select a category");
					return;
				}
			}
			else
			{
				if (document.forms[0].pagemediaid.selectedIndex == 0)
				{
					alert("You must select an audio or a video to associate with your transcript");
					return;
				}
			}
		}
		else
		{
			return;
		}

		if (qualityVal == '' && !blnTranscript)
		{
			alert('You must select a quality');
			return;
		}
		if (filetypeVal == 'Streaming') {
			aname = document.forms[0].theurl.value;
		} else {
			aname = document.forms[0].thefile.value.split('.');
		}
		var strFileExt = '';

		if (aname.length < 2)
		{
			alert("You must select a file to upload");
			return;
		}
		else
		{
			document.forms[0].fileext.value = aname[aname.length - 1];
			var aURL = document.forms[0].fileext.value.split('.');
			// splitting the complete filename now
			document.forms[0].fileext.value = aURL[aURL.length - 1];
			document.forms[0].filename.value = aURL[0];
			strFileExt = document.forms[0].fileext.value.toLowerCase();
		}

		if (blnTranscript && (strFileExt != 'txt' && strFileExt != 'doc'))
		{
			alert("You must upload a transcript with .txt or .doc extensions");
			return;
		}

		if (blnTranscript)
		{
			for (i=0; i<document.forms[0].quality.length; i++)
			{
				document.forms[0].quality[i].checked = false;
			}
			document.forms[0].fileassetcategoryid.selectedIndex = 0;
		}

		document.getElementById("btnSubmit").disabled=true;
		document.getElementById("btnSubmit").value = "Please Wait.  Upload in Progress";
		document.forms[0].submit();
	}

	function showPageMediaList()
	{
		document.getElementById("pageMediaList").style.display = 'block';
		for (var i=0; i<document.forms[0].quality.length; i++)
		{
			document.forms[0].quality[i].checked = false;
		}
		document.forms[0].fileassetcategoryid.selectedIndex = 0;
	}

	function hidePageMediaList()
	{
		document.getElementById("pageMediaList").style.display = 'none';
	}
</script>
</head>

<body onload="hidePageMediaList();">

 <cfform action="#request.scoperedirect#?url=#application.figleaf.url#com/applications/mediaAssets/ui/upload.cfm&pageid=#url.pageid#&formid=#url.formid#&fqfieldname=#url.fqfieldname#" enctype="multipart/form-data">
 <table>
 	<tr>
		<td>Caption:</td>
		<td><cfinput type="text" required="yes" message="You must enter a title" name="filedescription" size="30" maxlength="255"></td>
	</tr>

	<tr>
		<td>Category:</td>
		<td>
			<select name="fileassetcategoryid">
				<!--- <option value="">--- Please Select ---</option> --->
				<cfloop query="qcategories">
				<option value="">Select One</option>
					<option value="#qcategories.fileassetcategoryid#" <cfif #qcategories.recordcount# eq 1>SELECTED</cfif>>#qcategories.fileassetcategoryname#</option>
				</cfloop>
			</select>
		</td>
	</tr>

	<tr>
		<td>Type:</td>
		<td>
			<cfinput type="radio" name="filetype" value="Audio" required="yes" message="You must select a file type" onClick="hidePageMediaList();">Audio
			<cfinput type="radio" name="filetype" value="Video" required="yes" message="You must select a file type" onClick="hidePageMediaList();">Video
			<cfif numRecords gt 0>
				<cfinput type="radio" name="filetype" value="Transcript" required="yes" message="You must select a file type" onClick="showPageMediaList();">Transcript
			</cfif>
			<cfinput type="radio" name="filetype" value="Streaming" required="yes" message="You must select a file type" onClick="hidePageMediaList();">Streaming Video
		</td>
	</tr>

	<tr>
		<td colspan="2">
		<div id="pageMediaList" style="display:none;">
			<table>
				<tr>
					<td>Media List:</td>
					<td>
						<select name="pagemediaid">
							<option value="">--- Please Select ---</option>
							<cfloop from="1" to="#numRecords#" index="i">
								<option value="#arrMedia[i].fileassetid#">#arrMedia[i].filedescription#</option>
							</cfloop>
						</select>
					</td>
				</tr>
			</table>
		</div>
		</td>
	</tr>

	<tr>
		<td>Quality:</td>
		<td>
			<cfinput type="radio" name="quality" value="1">Dialup
			<cfinput type="radio" name="quality" value="2" checked="yes">Broadband
		</td>
	</tr>


	<tr>
		<td>File:</td>
		<td><cfinput type="file" name="thefile" size="30"> &nbsp;</td>
	</tr>
    <tr>
		<td>URL to Streaming File:</td>
		<td><cfinput type="text" name="theurl" size="30"> &nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>

	<tr>
		<td colspan="2" align="center"><input type="button" value="Save" name="btnSave" class="clsFinishButton" onClick="fnValidate()" id="btnSubmit"><br><div id="uploadprompt"></div></td>
	</tr>

 </table>
 <input type="hidden" name="fileext">
 <input type="hidden" name="filename">
 </cfform>
</body>
</html>
</cfoutput>
<cfcatch type="any">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>