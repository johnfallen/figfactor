<!--- Document Information -----------------------------------------------------
Build:      				@@@revision-number@@@
Title:      				RemoteGateway.cfc
Author:     				John Allen
Email:						jallen@figleaf.com
Company:    			@@@company-name@@@
Website:    			@@@web-site@@@
Usage:      
Modification Log:
Name			Date	 			Description
================================================================================
John Allen	 07/06/2008	 Created

------------------------------------------------------------------------------->
<cfcomponent displayname="" hint="I am the Remote Gateway" output="false">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="RemoteGateway" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfreturn this />
</cffunction>



<!--- getRemoteData --->
<cffunction name="getRemoteData" access="public" output="false" 
	displayname="Get Releated Publications" hint="I return a query of releated publications." 
	description="I query a remote datasouce to get releated publications.">	
	
	<cfreturn this.buildQueryFromTextFile() />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- buildQueryFromTextFile --->
<cffunction name="buildQueryFromTextFile" access="public" output="false" 
	displayname="Build Query From Text File" hint="I return a query of releated publications" 
	description="I query a query of releated publications built from and XML file.">
	
	<cfset var path = "#getDirectoryFromPath(GetCurrentTemplatePath())#/util" />
	<cfset var fileData1 = 0 />
	<cfset var pubXML = 0 />
	<cfset var pubsArray = arrayNew(1) />
	<cfset var publicationsQuery = 0 />
	<cfset var x = 0 />
	<cfset var newRow = 0 />
	<cfset var thisRow = 0 />
	<cfset var Temp = 0 />
	
	
	<cfif not isDefined("variables.fakePublicationsQuery")>
	
	
		<!--- make the level xml object --->
		<cffile 
			action="read" 
			file="#path#/publications.xml.txt" 
			variable="fileData1" />
		
		<cfset pubXML = XmlParse(fileData1) />
		
		<cfset pubsArray = XMLSearch(pubXML, "/query/row")>
		
		<cfset publicationsQuery = QueryNew(
		"abstract, date_published, last_modified, pub_id, r, title", 
		"varChar, date, date, Integer , Integer , varchar") />
		
		<cfloop from="2" to="4" index="x">
									
			<cfset newRow = QueryAddRow(publicationsQuery) />

			<cfset thisRow = pubsArray[x] />
			
			<cfset Temp = QuerySetCell(publicationsQuery, "abstract", pubsArray[x].abstract.XMLText) />
			<cfset Temp = QuerySetCell(publicationsQuery, "date_published", pubsArray[x].date_published.XMLText) />
			<cfset Temp = QuerySetCell(publicationsQuery, "last_modified", pubsArray[x].last_modified.XMLText) />
			<cfset Temp = QuerySetCell(publicationsQuery, "pub_id", pubsArray[x].pub_id.XMLText) />
			<cfset Temp = QuerySetCell(publicationsQuery, "r", pubsArray[x].r.XMLText) />
			<cfset Temp = QuerySetCell(publicationsQuery, "title", pubsArray[x].title.XMLText) />
		</cfloop>
	
		<cfset variables.fakePublicationsQuery = publicationsQuery />
	</cfif>
	<cfreturn variables.fakePublicationsQuery />
</cffunction>
</cfcomponent>