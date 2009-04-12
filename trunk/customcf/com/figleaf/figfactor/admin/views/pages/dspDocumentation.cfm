<cfset ff = application.figFactor />
<cfset spring = ff.getFactory() />

<cfsavecontent variable="thisJS">
<cfoutput>
<script type="text/javascript">
	$(function() {
		$("##tabs").tabs();
	});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#thisJS#" />

<cfoutput>
<h3>Documentation</h3>

<div class="demo">
	<div id="tabs">
		<ul>
			<li><a href="##tabs-1">FigFactor API</a></li>
			<li><a href="##tabs-2">Framework Objects</a></li>
			<li><a href="##tabs-3">Applications</a></li>
			<li><a href="##tabs-4">Configutation</a></li>
			<li><a href="##tabs-5">Lists</a></li>
			<li><a href="##tabs-6">Defined Elements</a></li>
		</ul>
		<div id="tabs-1">
			<h4>FigFactor</h4>
			<cfdump var="#ff#" label="FigFactor" />
		</div>
		<div id="tabs-2">
			<h4>Singletons</h4>
			<cfdump var="#spring.getBean("CacheService")#" label="Cache Service" />
			<span class="info">All caching objects returned are new instances.</span>
			<br />
			<br />
			<cfdump var="#spring#" label="Cold Spring" />
			<span class="info">The Dependency Injection (DI) Framework - ColdSpring</span>
			<br />
			<br />
			<cfdump var="#spring.getBean("Config")#" label="Config" /><br />
			<cfdump var="#spring.getBean("BootStrapper")#" label="BootStrapper" /><br />
			<cfdump var="#spring.getBean("ElementFactory")#" label="Element Factory" />
			<span class="info">The object that returns configured "custom elements" definitions.</span>
			<br />
			<br />
			<cfdump var="#spring.getBean("EventService")#" label="Event Service" />
			<span class="info">Manages access controll to the Event object for a requests life cycle.</span>
			<br />
			<br />
			<cfdump var="#spring.getBean("FileSystem")#" label="FileSystem" />
			<span class="info">Simple abstraction on top of the ColdFusion tags, includes "DirectoryCopy()".</span>
			<br />
			<br />
			<cfdump var="#spring.getBean("ListService")#" label="List Service" />
			<span class="info">List manager so views and CommonSpot can share list data.</span>
			<br />
			<br />
			<cfdump var="#spring.getBean("Logger")#" label="Logger" />
			<span class="info">Local or ColdFusion logging, configurable.</span>
			<br />
			<br />
			<cfdump var="#spring.getBean("RenderHandlerService")#" label="Render Handler Service" />
			<span class="info">Ron Wests cfc refactored.</span>
			<br />
			<br />
			<cfdump var="#spring.getBean("UDF")#" label="User Defined Functions Library" /><br />
			<h4>Non Singletons</h4>
			<cfdump var="#spring.getBean("AdobeColdFusionSessionFacade")#" label="Adobe ColdFusion SessionFacade" /><br />
			<cfdump var="#spring.getBean("MapCollection")#" label="Map Collection" /><br />
			
		</div>
		<div id="tabs-3">
			<cfdump var="#spring.getBean("Authentication")#" label="Authentication" /><br />
			<cfdump var="#spring.getBean("DataService")#" label="Data Service" /><br />
			<cfdump var="#spring.getBean("FLEET")#" label="FLEET" /><br />
			<cfdump var="#spring.getBean("Google")#" label="Google" /><br />
			<!--- <cfdump var="#spring.getBean("ObjectStore")#" label="Object Store" /><br /> --->
			<cfdump var="#spring.getBean("Security")#" label="Security" /><br />
			<cfdump var="#spring.getBean("Validator")#" label="Validator" /><br />
		</div>
		
		<div id="tabs-4">
			<cfdump var="#ff.getConfiguration()#" label="Configuration" /><br />
		</div>
		<div id="tabs-5">
			<cfdump var="#spring.getBean("ListService").getAllLists()#" label="Lists" /><br />
		</div>
		<div id="tabs-6">
			<cfdump var="#spring.getBean("ElementFactory").getAll()#" label="Elements" /><br />
		</div>
	</div>
</div>
</cfoutput>