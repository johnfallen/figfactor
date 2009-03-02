<!---
Filename: PageMetaData.cfm
Creation Date: 10/08/2004
Author: Steve Drucker (sdrucker@figleaf.com) Fig Leaf Software (www.figleaf.com)
Purpose: Abstraction layer for data manipulation of PageMetaData table

Run this file directly to view documentation.

Modification Log:
=================================================================================
01/04/2005	sdrucker	documented
08/13/2008	jallen			Formatted
08/24/2008	jallen			Renamed
--->
	
<cfcomponent name="PageMetaData" 
	hint="Data access controls for table ArticleMetaData" output="false">

<cfset variables.ConfigBean = 0 />
<cfset variables.dsn = "" />

<!--- init --->
<cffunction name="init" returntype="PageMetaData" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="ConfigBean" required="true" />
	
	<cfset variables.ConfigBean = arguments.ConfigBean />
	<cfset variables.dsn = variables.ConfigBean.getCommonSpotSupportDSN() />

	<cfreturn this />
</cffunction>

	
<!--- Delete --->
<cffunction name="Delete" access="public" output="false" returntype="boolean" 
	hint="Delete record from PageMetaData">
	
	<cfargument name="objectid" type="numeric" required="yes" hint="Primary Key" />
	<cfargument name="controlid" type="numeric" required="yes" hint="Primary Key" />
	<cfargument name="updateuser" type="string" required="yes" hint="Name of user requesting delete" />
	
	<cfstoredproc datasource="#variables.dsn#" procedure="ArticleMetaData_delete">
		<cfprocparam  cfsqltype="cf_sql_integer"  dbvarname="objectid" value="#objectid#" />
		<cfprocparam  cfsqltype="cf_sql_integer"  dbvarname="controlid" value="#controlid#" />
		<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="updateuser" value="#updateuser#" />
	</cfstoredproc>
	
	<cfreturn 1 />
</cffunction>



<!--- Get --->
<cffunction name="Get" access="remote" output="false" returntype="query" 
	hint="Get record from PageMetaData">
	
	<cfargument name="objectid" type="numeric" required="Yes" hint="CommonSpot Article (Page) ID" />
	
	<cfset var qArticleMetaData = 0 />
	
	<cfstoredproc datasource="#variables.dsn#" procedure="ArticleMetaData_get">
		<cfprocparam cfsqltype="cf_sql_integer" dbvarname="objectid" value="#objectid#" />
		<cfprocresult name="qArticleMetaData" resultset="1" />
	</cfstoredproc>
	
	<cfreturn qArticleMetaData />
</cffunction>



<!--- set --->
<cffunction name="set" access="public" output="false" returntype="boolean"  
	hint="Link metadata to a CommonSpot object">

	<cfargument name="objectid" type="numeric" required="yes" hint="CommonSpot page id" />
	<cfargument name="controlid" type="numeric" required="yes" hint="CommonSpot Control ID" />
	<cfargument name="lmetadataids" type="string" required="yes" hint="Comma delimited list of metadata ids" />
	<cfargument name="UpdateUser" type="string" required="Yes" hint="Name of user making request" />
	
	<cfset var thisid = "" />
	
	<cftransaction>
		<cfset delete (objectid = arguments.objectid, controlid = arguments.controlid, updateuser = arguments.updateuser) />
		
		<cfloop list="#arguments.lmetadataids#" index="thisid">
			<cfif thisid is not 0>
				<cfstoredproc procedure="ArticleMetaData_insert" datasource="#variables.dsn#">
					<cfprocparam dbvarname="objectid" type="in" cfsqltype="cf_sql_integer" value="#arguments.objectid#" />
					<cfprocparam dbvarname="metadataid" type="in" cfsqltype="cf_sql_integer" value="#thisid#" />
					<cfprocparam dbvarname="controlid" type="in" cfsqltype="cf_sql_integer" value="#arguments.controlid#" />
					<cfprocparam dbvarname="UpdateUser" type="in" cfsqltype="cf_sql_varchar" value="#UpdateUser#" />
				</cfstoredproc>
			</cfif>
		</cfloop>
	</cftransaction>
	
	<cfreturn true />
</cffunction>
</cfcomponent>