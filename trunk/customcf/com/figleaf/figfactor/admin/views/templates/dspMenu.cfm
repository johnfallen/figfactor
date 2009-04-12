<cfset myself = event.getValue("myself") />
<cfset xe.home = event.getValue("xe.home") />
<cfset xe.file.mapper = event.getValue("xe.file.mapper") />
<cfset xe.log.reader = event.getValue("xe.log.reader") />
<cfset xe.commonspot.log.reader = event.getValue("xe.commonspot.log.reader") />
<cfset xe.documentation = event.getValue("xe.documentation") />
<cfset xe.userManagement = event.getValue("xe.userManagement") />
<cfset xe.listBeans = event.getValue("xe.listBeans")>
<cfset xe.configure = event.getValue("xe.configure") />
<cfset xe.doLogout = event.getValue("xe.doLogout") />
<cfset xe.browseFileSystem = event.getValue("xe.browseFileSystem") />

<!--- 
	forgive, this is a weird HTML application... so this is cool here. its encapsulated 
	... its also a MAIN SECURITY FEATURE!
--->
<cfparam name="url.logType" default="commonspot" />
<cfparam name="url.event" default="home" />

<cfif isDefined("url.event") and url.event neq "login.form">
<cfoutput>
<ul class="sf-menu sf-navbar">
	<li<cfif url.event eq xe.home> class="current"</cfif>><a href="#myself##xe.home#">Home</a></li>
	
	<li<cfif url.event eq xe.file.mapper> class="current"</cfif>>
		<a href="##">File</a>
		<ul>
			<li><a href="#myself##xe.browseFileSystem#">File Browser</a></li>
			<li><a href="#myself##xe.file.mapper#">File Mapping Deployment</a></li>
			<li><a href="applications/cffm-1.17/cffm.cfm?allowedToAccess=1">CFFM</a></li>
			<li><a href="applications/BoxBrowse/index.cfm">BoxBrowse</a></li>
		</ul>
	</li>
	
	<li <cfif url.event eq xe.log.reader or url.event eq xe.commonspot.log.reader> class="current"</cfif>>
		<a href="##">Logs</a>
		<ul>
			<li><a href="#myself##xe.log.reader#&logType=FigFactor">FigFactor Logs</a></li>
			<li><a href="#myself##xe.commonspot.log.reader#&logType=commonspot">Commonspot Logs</a></li>
			<li><a href="#myself##xe.commonspot.log.reader#&logType=replication">Replication Logs</a></li>
			<li><a href="applications/Flogr">Server Logs</a></li>
		</ul>
	</li>
	
	<li<cfif url.event eq xe.listbeans> class="current"</cfif>><a href="#myself##xe.listbeans#">Beans</a></li>
	
	<li<cfif url.event eq xe.configure> class="current"</cfif>><a href="#myself##xe.configure#">Configuration</a></li>
	
	<li<cfif url.event eq xe.documentation> class="current"</cfif>><a href="#myself##xe.documentation#">Objects / Docs</a></li>
	<li<cfif url.event eq xe.userManagement> class="current"</cfif>><a href="#myself##xe.userManagement#">Users</a></li>
	<li><a href="#myself##xe.doLogout#">Logout</a></li>
</ul>
</cfoutput>
</cfif>