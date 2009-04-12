<cfset myself = event.getValue("myself") />
<cfset xe.log.reader = event.getValue("xe.log.reader") />
<cfset logs = event.getValue("logs") />
<cfset logType = event.getValue("logType") />
<cfset pagination = event.getValue("pagination") />

<cfset pagination.setQueryToPaginate(logs) />
<cfset pagination.setItemsPerPage(10) />
<cfset pagination.setShowNumericLinks(true) />
<cfset pagination.setNumericDistanceFromCurrentPageVisible(5) />
<cfset pagination.setNumericEndBufferCount(0) />
<cfset pagination.setShowMissingNumbersHTML(true) />
<cfset pagination.setURLPageIndicator("first") />
<cfset pagination.setShowPrevNextDisabledHTML(false) />
<cfset pagination.setPreviousLinkHTML("&laquo; Prev") />
<cfset pagination.setNextLinkHTML("Next &raquo;") />
<cfset pagination.setClassName("live") />

<cfoutput>
<h3>Choose Log to view</h3>
<table class="dataTable">
		<tr valign="top">
			<td>#pagination.getRenderedHTML()#</td>
		</td>
		<cfloop query="logs" startrow="#pagination.getStartRow()#"  endrow="#pagination.getEndRow()#">
		<tr valign="top">
			<td><a href="#myself##xe.log.reader#&logFileName=#name#&logType=#logType#">#name#</a></td>
		</td>
		</cfloop>
		<tr valign="top">
			<td>#pagination.getRenderedHTML()#</td>
		</td>
	</table>
</cfoutput>