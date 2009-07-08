<cfset myself = event.getValue("myself") />
<cfset log = event.getValue("log") />
<cfset pagination = event.getValue("pagination") />
<cfset displayAmount = event.getValue("displayAmount") />
<cfset logFileName = event.getValue("logFileName") />
<cfset config = event.getValue("config") />
<cfset xe.log.reader = event.getValue("xe.log.reader") />

<cfset pagination.setBaseLink("#config.getWebPathToAdmin()##myself##xe.log.reader#") />
<cfset pagination.setArrayToPaginate(log) />
<cfset pagination.setItemsPerPage(#displayAmount#) />
<cfset pagination.setShowNumericLinks(true) />
<cfset pagination.setNumericDistanceFromCurrentPageVisible(5) />
<cfset pagination.setNumericEndBufferCount(2) />
<cfset pagination.setShowMissingNumbersHTML(true) />
<cfset pagination.setURLPageIndicator("first") />
<cfset pagination.setShowPrevNextDisabledHTML(false) />
<cfset pagination.setPreviousLinkHTML("&laquo; Prev") />
<cfset pagination.setNextLinkHTML("Next &raquo;") />
<cfset pagination.setClassName("live") />

<cfoutput>
<h3>Log: #logFileName#</h3>
	<table class="dataTable">
		<tr valign="top">
			<td>#pagination.getRenderedHTML()#</td>
		</td>
		<cfloop from="#pagination.getStartRow()#"  to="#pagination.getEndRow()#" index="x">
		<tr valign="top">
			<td class="logEntry lightBorder">#log[x]#</td>
		</td>
		</cfloop>
		<tr valign="top">
			<td>#pagination.getRenderedHTML()#</td>
		</td>
	</table>
</cfoutput>