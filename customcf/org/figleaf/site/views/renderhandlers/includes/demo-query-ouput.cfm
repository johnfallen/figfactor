<!--- Document Information -----------------------------------------------------
Title: 				demo-query-ouput.cfm
Author:				John Allen
Email:					jallen@figleaf.com
Company:			Figleaf Software
Website:			@@@web-site@@@
Purpose:			I render dynamic queries for a Blank Page
================================================================================
John Allen		18/09/2008		Created
------------------------------------------------------------------------------->
<cftry>
<cfset queries = Application.vf.getPageEvent().getValue("queries") />
<cfset releatedPages = queries.RELEATEDPAGES />
<cfset data = queries.fakemetadata />
<cfset pagination = createobject("component", "Pagination").init() />
<cfset pagination.setQueryToPaginate(data) />
<cfset pagination.setItemsPerPage(5) />
<cfset pagination.setShowNumericLinks(true) />
<cfset pagination.setNumericDistanceFromCurrentPageVisible(1) />
<cfset pagination.setNumericEndBufferCount(0) />
<cfset pagination.setShowMissingNumbersHTML(false) />
<cfset pagination.setURLPageIndicator("first") />
<cfset pagination.setShowPrevNextDisabledHTML(false) />
<cfset pagination.setPreviousLinkHTML("&laquo; Prev") />
<cfset pagination.setNextLinkHTML("Next &raquo;") />
<cfset pagination.setClassName("live") />
<cfset config = Application.BeanFactory.getBean("ConfigBean") />

<cfoutput>

<div class="cs-content-wrapper">

	<table>
		<tr valign="top">
			<td>#pagination.getRenderedHTML()#</td>
		</td>
		<cfloop query="data" startrow="#pagination.getStartRow()#" endrow="#pagination.getEndRow()#">
		<tr valign="top">
			<td>#keyword#</td>
		</td>
		</cfloop>
		<tr valign="top">
			<td>#pagination.getRenderedHTML()#</td>
		</td>
	</table>
	
	<br />
	<hr />
	<h4>Dynamic Queries</h4>
	<p>The Below are queries from the DataService </p>
	<ul><cfloop query="releatedPages">
		<li><a href="#subsiteURL##filename#">#title#</a></li></cfloop>
	</ul>
</div>
</cfoutput>
<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>