<cfset application.bs = createObject("component", "BootStrapper").init() />
<cfset myBS = application.bs>

<cfloop from="1" to="4" index="x">
	<cfset map = myBS.getMap() />
	<cfset map.setMapName("#createUUID()#_yesJFAs") />
	<cfset map.setDestination("/#createUUID()#/#createUUID()#/") />
	<cfset map.setSource("/#createUUID()#/#createUUID()#/") />
	<cfset myBS.registerMap(mapObject = map, save = true) />
</cfloop>

<h1>BootStrapper.cfc</h1>
<cfdump var="#mybs#" />
<h1>Map.cfc</h1>
<cfdump var="#map#" />
<h2>The last added maps instance</h2>
<cfdump var="#map.getInstance()#" />
<h1>All the current mapping definitions</h1>
<cfdump var="#myBS.getMapDefinitions()#" />