<cfset config = event.getValue("Config") />
<cfset factory = event.getValue("factory") />
<cfset myself = ViewState.getValue("myself") />
<cfset configInstance = config.getInstance() />
<cfset DataService = ViewState.getValue("DataService") />
<cfset cacheInternals = dataService.getCache().ViewCache() />

<cfsavecontent variable="homeJS">
<cfoutput>
<script type="text/javascript">
	$(function() {
		$("##tabs").tabs();
	});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#homeJS#" />

<cfoutput>
	<h3>FigFactor Administration: Home</h3>
	<div class="demo">
		<div id="tabs">
			<ul>
				<li><a href="##tabs-1">Cache Internals</a></li>
				<li><a href="##tabs-2">Configuration</a></li>
			</ul>
			<div id="tabs-1">
				<cfdump var="#cacheInternals#" />
			</div>
			<div id="tabs-2">
				<cfdump var="#configInstance#" />
			</div>
		</div>
	</div>
</cfoutput>