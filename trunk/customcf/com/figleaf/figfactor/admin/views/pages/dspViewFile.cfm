<cfheader name="Content-Disposition"  value="filename=#url.filename#">
<cfswitch expression="#Right(url.filename,3)#">
<cfcase value="doc"><cfset MIME = "application/msword"></cfcase>
<cfcase value="xls"><cfset MIME = "application/msexcel"></cfcase>
<cfcase value="txt,cfm,log"><cfset MIME = "text/plain"></cfcase>
<cfcase value="gif"><cfset MIME = "application/msexcel"></cfcase>
<cfcase value="jpg"><cfset MIME = "image/gif"></cfcase>
<cfdefaultcase><cfset MIME = "*/*"></cfdefaultcase>
</cfswitch>
<cfcontent type="#MIME#" file="#url.filename#" deletefile="No"> 
