<!---
  suggest.cfm
  Makes suggestions about matching pages based on metadata hierarchy
--->
<cfif trim(url.metadata) is "" or trim(url.metadata) is "0">
  <cfoutput>
    <script language="JavaScript">

 		alert("Please categorize your page before selecting this option");

	</script>
  </cfoutput>
  <cfabort>
</cfif>
<!--- get related articles --->
<cfset lpageids = application.newsArticle.relatedarticlessuggest (datasource = application.figleaf.supportdsn, lmetadataids = url.metadata, maxrows = 10)>
<!--- initialize "final" results --->
<cfset aResults = arraynew(1)>
<!--- get files attached to pages --->
<cfif lpageids is not "0">
  <cfquery name="qassets" datasource="#request.site.datasource#" maxrows="5">
		select distinct fileasset.*
		from fileasset, articlefileasset
		where articlefileasset.fileassetid = fileasset.fileassetid
		and articlefileasset.pageid in (#variables.lpageids#)
		and fileasset.endtime is null
		and articlefileasset.endtime is null
		and articlefileasset.pageid not in (#url.pageid#)
		order by fileasset.fileassetid desc
	</cfquery>
</cfif>
<cfoutput>
  <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
  <html>
  <head>
  <title>Untitled Document</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <script language="javascript">

	<cfloop query="qassets">

		parent.#url.callback#('#jsstringformat(qassets.filedescription)#', #qassets.fileassetid#, '#qassets.filetype#');

	</cfloop>

</script>
  </head>
  <body>
  </body>
  </html>
</cfoutput>