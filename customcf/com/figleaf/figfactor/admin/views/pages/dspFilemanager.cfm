<cfset myself = event.getValue("myself") />
<cfset xe.browseFileSystem = event.getValue("xe.browseFileSystem") />
<cfset xe.downloadFile = event.getValue("xe.downloadFile") />

<cfoutput>
<style type="text/css">

.fm TABLE {
	font-size:.65em;
	font-family:verdana;
}
.fm H1 {
	font-size : 15pt;
}
.fm TH {
	background : Black;
	color : White;
}
.fm TR {
	background : ##ECECEC;
}

.fm TR.BOLD {
	font-weight : bold;
}
.BUTTON {
	background : ##E8E8E8;
	border : 1pt solid Black;
}
.fm input {
	border : 1pt solid Gray;
	}
</style>

</cfoutput>

<cfif (isdefined("directory"))>
	<cfset session.d = directory />
</cfif>

<cfif (not isdefined("session.d"))> 
	<cfset session.d = expandPath("/") />
</cfif>

<cfif (SERVER_SOFTWARE contains "Unix")>
	<cfset slash = "/" />
<cfelse>
	<cfset slash = "\"  />
</cfif>

<cfif (ListFind(session.d,"..",slash) neq 0)>
   <cfset s=ListFind(session.d,"..",slash) />
   <cfset session.d=ListDeleteAt(session.d,s,slash) />
   <cfset session.d=ListDeleteAt(session.d,s-1,slash) />
</cfif>

<cfdirectory action="LIST" directory="#session.d#" name="get" sort = "name ASC, size DESC">
<cfoutput>
<div class="fm">
<form action="#myself##xe.browseFileSystem#" method="post">
	<input type="text" name="directory" value="#session.d#" size="50" maxlength="50" class="inbox">
	<input type="submit" value="send" class="button">
</form>
<table>
	<tr>
		<th>name</th>
		<th>size</th>
		<th>date</th>
		<th>type</th>
	</tr>
	<cfif (SERVER_SOFTWARE contains "Unix")>
		<tr class='bold'>
			<td><a href="#myself##xe.browseFileSystem#&directory=#session.d##slash#..">..</a></td>
			<td>0</td>
			<td>&nbsp;</td>
			<td>Dir</td></tr>
	</cfif>
	<cfloop query="get">
		<cfif name neq '.'>
			<tr #iif(type is "Dir",DE("class='bold'"),DE(""))#>
				<td>
					<cfif type is "Dir">
						<a href="#myself##xe.browseFileSystem#&directory=#session.d##slash##name#">
					<cfelse>
						<a href="#myself##xe.downloadFile#&filename=#session.d##slash##name#" target="_blank">
					</cfif>
						#name#
					</a>
				</td>
				<td>#size#</td>
				<td>
					#dateFormat(dateLastModified, "long")#|#TimeFormat(dateLastModified, "short")#
				</td>
				<td>#type#</td>
			</tr>
		</cfif>
	</cfloop>
</table>
</div>
</cfoutput>