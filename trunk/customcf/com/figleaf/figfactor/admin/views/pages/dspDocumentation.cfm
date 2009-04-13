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
			<span class="info">The FigFactor API. I orchastrate the initialization of the framework and provide proxy methods <br />for my internally managed objects.</span>
			<h4>Event</h4>
			<cfset mockEvent = ff.getBean("EventService").getMockEvent() />
			<cfdump var="#mockEvent#" label="Mock Event" />
			<span class="info">A Mock Event Object passed through the framework as if a real Event Object.</span>
		</div>
		<div id="tabs-2">
			<h4>Singletons</h4>
			<cfdump var="#spring.getBean("BootStrapper")#" label="BootStrapper" />
			<span class="info">I copy files from the "site" directory to the web root and framework directory, and also load the DI framework.</span>
			<br />
			<br />
			<cfdump var="#spring.getBean("CacheService")#" label="Cache Service" />
			<span class="info">All caching objects are returned as a new instance if passed the "type" argument, else you get the default acting cache.</span>
			<br />
			<br />
			<cfdump var="#spring#" label="Cold Spring" />
			<span class="info">The Dependency Injection (DI) Framework - ColdSpring.</span>
			<br />
			<br />
			<cfdump var="#spring.getBean("Config")#" label="Config" />
			<span class="info">Persists all configuration data for the framework.</span>
			<br />
			<br />
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
			<cfdump var="#spring.getBean("AdobeColdFusionSessionFacade")#" label="Adobe ColdFusion SessionFacade" />
			<span class="info">Abstract Session Facade for ColdFusion Servers.</span>
			<br />
			<br />
			<cfdump var="#spring.getBean("MapCollection")#" label="Map Collection" />
			<span class="info">A generic "key/value" collection object.</span>
			<br />
			<br />
		</div>
		<div id="tabs-3">
			<h4>The Current Avaiable Applications</h4>
			<cfdump var="#spring.getBean("Authentication")#" label="Authentication" />
			<span class="info">A LDAP abstraction layer that uses the custom-authentication.cfm file.</span>
			<br />
			<br />
			<cfdump var="#spring.getBean("DataService")#" label="Data Service" />
			<span class="info">An "Abstract Gateway" that injects methods in CFC's from the "site/model/gateway/" directory.</span>
			<br />
			<br />
			<cfdump var="#spring.getBean("FLEET")#" label="FLEET" />
			<span class="info">An abstraction for Steve Druckers FLEET meta-data codebase. I return the underling services that power FLEET.</span>
			<br />
			<br />
			<cfdump var="#spring.getBean("Google")#" label="Google" />
			<span class="info">I am 2 applications. One that handles searching and rendering Google results based on configuration data and a<br /> Feed Manager for Google Search Appliance XML Feeds.</span>
			<br />
			<br />
			<cfdump var="#spring.getBean("ObjectStore")#" label="Object Store" />
			<span class="info">I provide a simple way to define "beans" via XML and searilze them for persistance locally or accross servers.</span>
			<br />
			<br />
			<cfdump var="#spring.getBean("Security")#" label="Security" />
			<span class="info">I am an application that provides "username/password" authentication. I store the login credentials as VERY<br />
				 encrypted XML files so there is little to worry about if I happen to be on a public facing web server.</span>
			<br />
			<br />			
			<cfdump var="#spring.getBean("Validator")#" label="Validator" />
			<span class="info">If I am enabled via configuration I will strongly inspect all input that is NOT a "page creation form" for<br /> 
				XLS attacks and other malicious data and throw and error if any is found. If enabled I will also allow <br />
				CommonSpot to pass HP's WebInspect tool in an accectable way.</span>
			<br />
			<br />
			
		</div>
		
		<div id="tabs-4">
			<h4>The Current Configuration Settings</h4>
			<cfdump var="#ff.getConfiguration()#" label="Configuration" /><br />
		</div>
		<div id="tabs-5">
			<h4>Avaiable/Registered Lists</h4>
			<cfdump var="#spring.getBean("ListService").getAllLists()#" label="Lists" /><br />
		</div>
		<div id="tabs-6">
			<h4>The Custom Elements Defined in customelements.xml</h4>
			<cfdump var="#spring.getBean("ElementFactory").getAll()#" label="Elements" /><br />
		</div>
	</div>
</div>
</cfoutput>