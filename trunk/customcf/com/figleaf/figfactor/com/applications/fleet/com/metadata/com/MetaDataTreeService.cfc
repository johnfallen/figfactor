<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		MetaDataTreeService.cfc
Author: 			Steve Drucker (sdrucker@figleaf.com) Fig Leaf Software (www.figleaf.com)
Email:      		jallen@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@

Purpose: 		Service layer/Data abstraction layer for the MetaDataTree table.

Usage:      		

Modification Log:
Name 			Date 						Description

================================================================================
sdrucker		April 2004				Created
John Allen		08/16/20008			Big re-factoring. Changed the concept to become
												a Service layer. Added init() method. Scoped variables 
												and formatted. Added listMetaDataTree() for 
												metadata_properties.cfm support. Added getAllMetaDataTrees()
												for metadata_rendering.cfm support.
------------------------------------------------------------------------------->
<cfcomponent name="MetaDataTree"  output="false"
	hint="Data abstraction layer for the MetaDataTree table.">

<cfset variables.supportDSN =  "" />

<!--- init --->
<cffunction name="init" returntype="MetaDataTreeService" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo-constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="supportDSN" required="true" type="string" hint="I am the Fleet Data Source.<br />I am required." />
	
	<cfset variables.supportDSN = arguments.supportDSN />
	
	<cfreturn this />
</cffunction>



<!--- delete --->
<cffunction name="Delete" access="public" output="false" returntype="boolean" 
	hint="Delete record from MetaDataTree">

	<cfargument name="MetadataTreeID" type="numeric" required="yes" hint="Primary Key" />
	<cfargument name="updateuser" type="string" required="yes" hint="Name of user requesting delete" />
	
	<cfstoredproc datasource="#variables.supportDSN#" procedure="MetaDataTree_delete">
		<cfprocparam  cfsqltype="cf_sql_integer"  dbvarname="MetadataTreeID" value="#arguments.MetadataTreeID#" />
		<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="updateuser" value="#arguments.updateuser#" />
	</cfstoredproc>
	
	<cfreturn 1 />
</cffunction>



<!--- get --->
<cffunction name="Get" access="public" output="false" returntype="query" 
	hint="Get record from MetaDataTree">
	
	<cfargument name="MetadataTreeID" type="numeric" required="no" 
		hint="Primary key value for MetaDataTree" default="-1" />

	<cfset var qMetaDataTree = 0 />

	<cfstoredproc datasource="#variables.supportDSN#" procedure="MetaDataTree_get">
		<cfif MetadataTreeID gt 0>
			<cfprocparam cfsqltype="cf_sql_integer" dbvarname="MetadataTreeID" value="#arguments.MetadataTreeID#" />
		</cfif>
		<cfprocresult name="qMetaDataTree" resultset="1" />
	</cfstoredproc>
	
	<cfreturn qMetaDataTree />
</cffunction>



<!--- listMetaDataTree --->
<cffunction name="listMetaDataTree" access="public" output="false"
	displayname="List Meta Data Tree" hint="I return a query Meta Data Trees.<br />ReturnType: Query."
	description="I return a query object containing information about all the Meta Data Trees.">
	
	<cfset var qgetTrees = 0 />
	
	<cfquery name="qgetTrees" datasource="#variables.supportDSN#">
		select metadatatreeid,metadatatreename
		from MetaDataTree
		order by metadatatreename
	</cfquery>
	
	<cfreturn  qgetTrees />
</cffunction>



<!--- getAllMetaDataTrees --->
<cffunction name="getAllMetaDataTrees" returntype="any" access="public" output="false"
	displayname="getAllMetaDataTrees" hint="I return a structure of MetaDataTree query object."
	description="I return a structure of MetaDataTree query object by calling stored procedures.">
	
	<cfset var metaDataTrees = structNew() />
	<cfset var qtrees = 0 />
	<cfset var qgettree = 0 />

	<cfquery name="qtrees" datasource="#variables.supportDSN#">
		{call metadatatree_get}
	</cfquery>

	<cfif qtrees.recordcount gt 0>
	
		<cfloop query="qtrees">
		
			<cfquery name="qgettree" datasource="#variables.supportDSN#">
				{call MetaDataKeyword_GetByMetaDataTreeID (#qtrees.metadatatreeid#)}
			</cfquery>
			
			<cfset metaDataTrees[qgettree.metadatatreeid] = qgettree />
		</cfloop>
	</cfif>

	<cfreturn metaDataTrees />
</cffunction>



<!--- recordInsert --->
<cffunction name="recordInsert" access="public" output="false" returntype="numeric"  
	hint="Insert record into MetaDataTree and return primary key">
	
	<cfargument name="MetadataTreeName" type="string" required="No" />
	<cfargument name="Updateuser" type="string" required="No" />

	<cfset var qresult = "">
	
	<cfstoredproc procedure="MetaDataTree_insert" datasource="#variables.supportDSN#">
		<cfprocparam dbvarname="MetadataTreeName" type="in" cfsqltype="cf_sql_varchar" value="#arguments.MetadataTreeName#" />
		<cfprocparam dbvarname="Updateuser" type="in" cfsqltype="cf_sql_varchar" value="#arguments.Updateuser#" />
		<cfprocresult name="qresult"  resultset="1" />
	</cfstoredproc>
	
	<cfreturn qresult.MetadataTreeID />
</cffunction>



<!--- update --->
<cffunction name="update" access="public" output="false" returntype="boolean" 
	hint="Update record in MetaDataTree">
	
	<cfargument name="MetadataTreeID" type="numeric" required="yes" hint="Primary key" />
	<cfargument name="MetadataTreeName" type="string" required="No" />
	<cfargument name="Updateuser" type="string" required="No" />

	<cfset var qresult = "">

	<cfstoredproc procedure="MetaDataTree_update" datasource="#variables.supportDSN#">
		<cfprocparam cfsqltype="cf_sql_integer" dbvarname="MetadataTreeID" type="in" value="#arguments.MetadataTreeID#" />
		<cfprocparam dbvarname="MetadataTreeName" type="in" cfsqltype="cf_sql_varchar" value="#arguments.MetadataTreeName#" />
		<cfprocparam dbvarname="Updateuser" type="in" cfsqltype="cf_sql_varchar" value="#arguments.Updateuser#" />
	</cfstoredproc>

	<cfreturn 1 />
</cffunction>
</cfcomponent>