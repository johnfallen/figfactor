<cfset google = createObject("component", "Google").init() />
<cfset test = google.getSearch("science") />

<cfoutput>
<html>
<head>
<title>Google Test</title>
<style>
body {
	font-family:verdana; 
	font-size:.90em;
}
##devoutput {
	float:right; 
	margin:0px 0px 40px 20px; 
	border:solid 1px black; 
	font-size:.90em;
	width:50%;
	padding:10px;
}
</style>
</head>
<body>



<!--- <div id="devoutput">
	<!---  <cfloop array="#test.getSearchParams()#" index="x">
		<cfif x.name eq "partialfields">
			<strong>PARTIAL FIELD:</strong><br />
			<strong>Sent:</strong><br />#x.original_value#<br />
			<strong>Saw :</strong> <em class="smallBold">URLDecoded 2'x</em><br />#URLDecode(URLDecode(x.original_value))#
		<cfelse>
			<strong>Name:</strong> #x.name#<br />
			<strong>Sent Value:</strong><br />#x.original_value#<br />
			<strong>Google Used:</strong><br />#x.value#<br />
		</cfif>
		<hr />
	</cfloop> --->
	<cfdump var="#test.getSearchResultXMLNode("PARAM")#"> 
</div> --->
#google.getSearchForm(formMethod = "post")#

<hr />

#google.getSearchForm(
	formMethod = "post",
	includePropertyFields = true, 
	propertyPackageName="publications")#
<hr />
#test.getResults()#
<cfdump var="#test.getSearchResultXML()#">
</body>
</html>
</cfoutput>

