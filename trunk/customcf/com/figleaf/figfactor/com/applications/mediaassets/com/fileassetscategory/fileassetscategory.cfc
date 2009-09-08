<!---

	Filename: cfc/fileassetCategory.cfc
	Creation Date: June 2004
	Author: Steve Drucker (sdrucker@figleaf.com) Fig Leaf Software (www.figleaf.com)
	Purpose: Data abstraction layer for table fileassetcategory (Category Names)

	Modification Log:
	=================================================================================
	01/04/2005	sdrucker	documented, changed dsn reference
	

--->

	<cfcomponent name="fileAssetCategory" hint="Data access controls for table fileAssetCategory">
		<cfset variables.ConfigBean = 0 />
        <cfset variables.dsn = "" />      
        
        <cffunction name="init" returntype="any" access="public" output="false" 
            displayname="Init" hint="I am the constructor." 
            description="I am the pseudo constructor for this CFC. I return an instance of myself.">
            <cfargument name="ConfigBean" required="true" />
            
            <cfset variables.ConfigBean = arguments.ConfigBean />
            <cfset variables.dsn = variables.ConfigBean.getCommonSpotSupportDSN() />
        
            <cfreturn this />
        </cffunction>
        		
		<cffunction name="Delete" access="remote" output="false" returntype="boolean" hint="Delete record from fileAssetCategory">
			<cfargument name="fileAssetCategoryid" type="numeric" required="yes" hint="Primary Key">
			<cfargument name="updateuser" type="string" required="yes" hint="Name of user requesting delete">
			<cfstoredproc datasource="#variables.dsn#" procedure="fileAssetCategory_delete">
				<cfprocparam  cfsqltype="cf_sql_integer"  dbvarname="fileAssetCategoryid" value="#fileAssetCategoryid#">
				<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="updateuser" value="#updateuser#">
			</cfstoredproc>
			<cfreturn 1>	
		</cffunction>
		
		<cffunction name="Get" access="remote" output="false" returntype="query" hint="Get record from fileAssetCategory">
			<cfargument name="fileAssetCategoryid" type="numeric" required="no" hint="Primary key value for fileAssetCategory" default="-1">
			<cfstoredproc datasource="#variables.dsn#" procedure="fileAssetCategory_get">
				<cfif fileAssetCategoryid gt -1>
					<cfprocparam cfsqltype="cf_sql_integer" dbvarname="fileAssetCategoryid" value="#fileAssetCategoryid#">
				</cfif>
				<cfprocresult name="qfileAssetCategory" resultset="1">
			</cfstoredproc>
			<cfreturn qfileAssetCategory>
		</cffunction>
		
		<cffunction name="recordInsert" access="remote" output="false" returntype="numeric"  hint="Insert record into fileAssetCategory and return primary key">
			<cfargument name="fileAssetCategoryname" type="string" required="No">
			<cfargument name="updateuser" type="string" required="No">
			
			<cfset var qresult = "">
			<cfstoredproc procedure="fileAssetCategory_insert" datasource="#variables.dsn#">
					<cfprocparam dbvarname="fileAssetCategoryname" type="in" cfsqltype="cf_sql_varchar" value="#fileAssetCategoryname#">
					<cfprocparam dbvarname="updateuser" type="in" cfsqltype="cf_sql_varchar" value="#updateuser#">
				
					<cfprocresult name="qresult"  resultset="1">
			</cfstoredproc>
			<cfreturn qresult.fileAssetCategoryid>
		</cffunction>
		
		<cffunction name="update" access="remote" output="false" returntype="boolean"  hint="Update record in fileAssetCategory">
			<cfargument name="fileAssetCategoryid" type="numeric" required="yes" hint="Primary key">
			<cfargument name="fileAssetCategoryname" type="string" required="No">
			<cfargument name="updateuser" type="string" required="No">
			
			<cfset var qresult = "">
			<cfstoredproc procedure="fileAssetCategory_update" datasource="#variables.dsn#">
					<cfprocparam cfsqltype="cf_sql_integer" dbvarname="fileAssetCategoryid" type="in" value="#fileAssetCategoryid#">
					<cfprocparam dbvarname="fileAssetCategoryname" type="in" cfsqltype="cf_sql_varchar" value="#fileAssetCategoryname#">
					<cfprocparam dbvarname="updateuser" type="in" cfsqltype="cf_sql_varchar" value="#updateuser#">
				
			</cfstoredproc>
			<cfreturn 1>
		</cffunction>
		
	</cfcomponent>
	
	
