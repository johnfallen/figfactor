<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		MetaDataKeywordService.cfc
Author: 			Steve Drucker (sdrucker@figleaf.com) Fig Leaf Software (www.figleaf.com)
Email:      		jallen@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@

Purpose: 		Service Layer for Metadata Keyword Processing.

Usage:      		Dump this CFC, all attributes are commented.

Modification Log:
Name 			Date 					Description

================================================================================
sdrucker		April 2004			Created
John Allen		08/16/20008		Massive re-factoring. Changed the concept to become
											a Service layer. Added generateTree() into his CFC and 
											made modules relitive to this CFC. Added init() method.
											Scoped variables and formatted.
------------------------------------------------------------------------------->
<cfcomponent name="MetaDataKeywordService"  output="false"
	hint="Data access controls for the MetaDataKeyword table.">

<cfset variables.supportDSN = "" />

<!--- init --->
<cffunction name="init" returntype="MetaDataKeywordService" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo-constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="supportDSN" required="true" type="string" 
		hint="I am the Fleet Data Source.<br />I am required." />
	
	<cfset variables.supportDSN = arguments.supportDSN />
	
	<cfreturn this />
</cffunction>



<!--- Delete --->
<cffunction name="Delete" access="public" output="false" returntype="boolean" 
	hint="Delete record from MetaDataKeyword">
	
	<cfargument name="MetaDataID" type="numeric" required="yes" hint="Primary Key" />
	<cfargument name="updateuser" type="string" required="yes" hint="Name of user requesting delete" />
	
	<cfstoredproc datasource="#variables.supportDSN#" procedure="MetaDataKeyword_delete">
		<cfprocparam  cfsqltype="cf_sql_integer"  dbvarname="MetaDataID" value="#MetaDataID#" />
		<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="updateuser" value="#updateuser#" />
	</cfstoredproc>

	<cfreturn 1 />
</cffunction>



<!--- Get --->
<cffunction name="Get" access="remote" output="false" returntype="query" 
	hint="Get record from MetaDataKeyword">

	<cfargument name="MetaDataID" type="numeric" required="no" default="-1"
		hint="Primary key value for MetaDataKeyword"  />

	<cfset var qMetaDataKeyword = 0 />
	
	<cfstoredproc datasource="#variables.supportDSN#" procedure="MetaDataKeyword_get">
		<cfif arguments.MetaDataID gt 0>
			<cfprocparam cfsqltype="cf_sql_integer" dbvarname="MetaDataID" value="#arguments.MetaDataID#" />
		</cfif>
		<cfprocresult name="qMetaDataKeyword" resultset="1" />
	</cfstoredproc>

	<cfreturn qMetaDataKeyword />
</cffunction>



<!--- recordInsert --->
<cffunction name="recordInsert" access="public" output="false" returntype="numeric" 
	hint="Insert record into MetaDataKeyword and return primary key">
	
	<cfargument name="MetaDataKeyword" type="string" required="No" />
	<cfargument name="MetaDataTreeID" type="numeric" required="Yes" />
	<cfargument name="MetadataParentID" type="numeric" required="No" />
	<cfargument name="MetaDataBitmask" type="string" required="No" />
	<cfargument name="Weight" type="numeric" required="No" />
	<cfargument name="UpdateUser" type="string" required="No" />
	
	<cfset var qresult = "" />
	
	<cfstoredproc procedure="MetaDataKeyword_insert" datasource="#variables.supportDSN#">
		<cfprocparam dbvarname="MetaDataKeyword" type="in" cfsqltype="cf_sql_varchar" value="#arguments.MetaDataKeyword#" />
		<cfprocparam dbvarname="MetaDataTreeID" type="in" cfsqltype="cf_sql_numeric" value="#arguments.MetaDataTreeID#" />
		<cfprocparam dbvarname="MetadataParentID" type="in" cfsqltype="cf_sql_numeric" value="#arguments.MetadataParentID#" />
		<cfprocparam dbvarname="MetaDataBitmask" type="in" cfsqltype="cf_sql_varchar" value="#arguments.MetaDataBitmask#" />
		<cfprocparam dbvarname="Weight" type="in" cfsqltype="cf_sql_numeric" value="#arguments.Weight#" />
		<cfprocparam dbvarname="UpdateUser" type="in" cfsqltype="cf_sql_varchar" value="#arguments.UpdateUser#" />
		<cfprocresult name="qresult"  resultset="1" />
	</cfstoredproc>
	
	<cfreturn qresult.MetaDataID />
</cffunction>



<!--- update --->
<cffunction name="update" access="public" output="false" returntype="boolean" 
	hint="Update record in MetaDataKeyword">
	
	<cfargument name="MetaDataID" type="numeric" required="yes" hint="Primary key" />
	<cfargument name="MetaDataKeyword" type="string" required="No" />
	<cfargument name="MetaDataTreeID" type="numeric" required="Yes" />
	<cfargument name="MetadataParentID" type="numeric" required="No" />
	<cfargument name="MetaDataBitmask" type="string" required="No" />
	<cfargument name="Weight" type="numeric" required="No" />
	<cfargument name="UpdateUser" type="string" required="No" />
	
	<cfset var qresult = "" />
	
	<cfstoredproc procedure="MetaDataKeyword_update" datasource="#variables.supportDSN#">
		<cfprocparam cfsqltype="cf_sql_integer" dbvarname="MetaDataID" type="in" value="#arguments.MetaDataID#" />
		<cfprocparam dbvarname="MetaDataKeyword" type="in" cfsqltype="cf_sql_varchar" value="#arguments.MetaDataKeyword#" />
		<cfprocparam dbvarname="MetaDataTreeID" type="in" cfsqltype="cf_sql_numeric" value="#arguments.MetaDataTreeID#" />
		<cfprocparam dbvarname="MetadataParentID" type="in" cfsqltype="cf_sql_numeric" value="#arguments.MetadataParentID#" />
		<cfprocparam dbvarname="MetaDataBitmask" type="in" cfsqltype="cf_sql_varchar" value="#arguments.MetaDataBitmask#" />
		<cfprocparam dbvarname="Weight" type="in" cfsqltype="cf_sql_numeric" value="#arguments.Weight#" />
		<cfprocparam dbvarname="UpdateUser" type="in" cfsqltype="cf_sql_varchar" value="#arguments.UpdateUser#"/>
	</cfstoredproc>

	<cfreturn 1 />
</cffunction>



<!--- treeGet --->
<cffunction name="treeGet" access="remote" output="false" returntype="array" 
	hint="Returns a tree of metadata as an array of structures">
	
	<cfargument name="metadatatreeid" type="numeric" required="Yes" />

	<cfset var qresults = "" />
	<cfset var aresults = arraynew(1) />

	<cfstoredproc datasource="#variables.supportDSN#" procedure="metadatakeyword_getByMetadatatreeid">
		<cfprocparam dbvarname="MetaDataTreeID" type="in" cfsqltype="cf_sql_numeric" value="#arguments.MetaDataTreeID#" />
		<cfprocresult resultset="1" name="qresults" />
	</cfstoredproc>

	<cfloop query="qresults">
		<cfscript>
			aresults[qresults.currentrow] = structnew();
			aresults[qresults.currentrow].metadatadataid = qresults.metadataid;
			aresults[qresults.currentrow].metadatabitmask = qresults.metadatabitmask;
			aresults[qresults.currentrow].metadataparentid = qresults.metadataparentid;
			aresults[qresults.currentrow].metadatakeyword = qresults.metadatakeywordenglishtranslation;
			aresults[qresults.currentrow].url = qresults.url_link;
			aresults[qresults.currentrow].translation = qresults.metadatakeyword;
		</cfscript>
	</cfloop>

	<cfreturn aresults />
</cffunction>



<!--- BitmaskGenerate --->
<cffunction name="BitmaskGenerate" access="public" output="false" returntype="boolean">

	<cfargument name="metadatatreeid" type="numeric" required="false" default="0" />

	<cfset var getdata = "" />
	<cfset var myehdata = structnew() />
	<cfset var myehcount = structnew() />
	<cfset var myrows = structnew() />
	<cfset var mycount = 0 />
	<cfset var mycounter = 0 />
	<cfset var processedrecords = 0 />
	<cfset var i = "1" />
	<cfset var getdatapre =  ""/>
	<cfset var upd = 0 />

	<cfquery name="getdatapre" datasource="#variables.supportDSN#">
		select metadataid as itemid,metadataparentid as parentitemid, metadatakeyword
		from metadatakeyword
		
		<!--- 
		Added: 08/17/20008 by John Allen
		
		This lets us kill the supporting code that existed for the admin section.
		--->
		<cfif arguments.metadatatreeid neq 0>
			where metadatatreeid = #arguments.metadatatreeid#
		</cfif>
		order by metadataparentid,metadatakeyword
	</cfquery>

	<cfset getdata = generateTree(getdatapre) />
	
	<cfset queryaddcolumn(getdata,"Bitmask",arraynew(1)) />

	<cfloop from="1" to="5" index="i">
		<cfloop query="getdata">
			<cfif trim(getdata.bitmask) is "">
				
				<cfmodule template="modules/processvars.cfm"
					parentitemid="#getdata.parentitemid#"
					itemid="#getdata.itemid#">
				
				<cfif variables.myrc is not "">
					<cfset querysetcell(getdata,"bitmask",variables.myrc,getdata.currentrow) />
				</cfif>
			</cfif>
		</cfloop>	
	</cfloop>

	<!--- write out results to disk --->
	<cfloop query="getdata">
		<cfquery name="upd" datasource="#variables.supportDSN#">
			update metadatakeyword
			set metadatabitmask = '#getdata.bitmask#'
			where metadataid=#getdata.itemid#
		</cfquery>
	</cfloop>

	<cfif arguments.metadatatreeid eq 0>
		<cfreturn true />
	<cfelse>
		<cfreturn getdata />
	</cfif>
</cffunction>



<!--- treeSave --->
<cffunction name="treeSave" access="remote" output="false" returntype="boolean" 
	hint="Saves back a tree of metadata to a database table">
	
	<cfargument name="datasource" type="string" required="Yes" default="" />
	<cfargument name="metadatatreeid" type="numeric" required="Yes" />
	<cfargument name="aData" type="array" required="Yes" hint="Array of objects" />

	<cfset var thisobj = "" />
	<cfset var nullParent = "" />
	<cfset var i = 0 />

	<cftransaction>
		
		<cfloop from="1" to="#arraylen(arguments.aData)#" index="i">
			
			<cfset thisObj = arguments.aData[i] />
			
			<cfif thisObj.parentid is "">
				<cfset nullParent = "Yes" />
			<cfelse>
				<cfset nullParent = "No" />
			</cfif>
			
			<cfswitch expression = "#thisObj.action#">
				
				<!--- new --->
				<cfcase value="n">  
					<cfstoredproc datasource="#arguments.datasource#" procedure="metadatakeyword_insert">
						<cfprocparam dbvarname="MetaDataTreeID" type="in" cfsqltype="cf_sql_numeric" value="#arguments.metadatatreeid#" />
						<cfprocparam dbvarname="MetaDataParentID"	type="in" cfsqltype="cf_sql_numeric" value="#thisobj.parentID#" null="#nullParent#" />
						<cfprocparam dbvarname="MetaDataKeyword"	type="in" cfsqltype="cf_sql_varchar" value="#thisobj.translation#" />
						<cfprocparam dbvarname="metadatakeywordenglishtranslation" type="in" cfsqltype="cf_sql_varchar" value="#thisobj.label#" />
						<cfprocparam dbvarname="url_link" type="in" cfsqltype="cf_sql_varchar" value="#thisobj.url#" />
						<cfprocparam dbvarname="MetaDataBitmask" type="in" cfsqltype="cf_sql_varchar" value="" />
						<cfprocparam dbvarname="updateuser" type="in" cfsqltype="cf_sql_varchar" value="Flash" />
					</cfstoredproc>
				</cfcase>
				
				<!--- edited --->
				<cfcase value="e">  
					<cfstoredproc datasource="#arguments.datasource#" procedure="metadatakeyword_update">
						<cfprocparam dbvarname="MetaDataTreeID" type="in" cfsqltype="cf_sql_numeric" value="#arguments.metadatatreeid#" />
						<cfprocparam dbvarname="MetaDataID" type="in" cfsqltype="cf_sql_numeric" value="#thisobj.ID#" />
						<cfprocparam dbvarname="MetaDataParentID" type="in" cfsqltype="cf_sql_numeric" value="#thisobj.parentID#"  null="#nullParent#" />
						<cfprocparam dbvarname="MetaDataKeyword"	type="in" cfsqltype="cf_sql_varchar" value="#thisobj.translation#" />
						<cfprocparam dbvarname="MetaDataBitmask" type="in" cfsqltype="cf_sql_varchar" value="" />
						<cfprocparam dbvarname="url_link" type="in" cfsqltype="cf_sql_varchar" value="#thisobj.url#" />
						<cfprocparam dbvarname="metadatakeywordenglishtranslation" type="in" cfsqltype="cf_sql_varchar" value="#thisobj.label#" />
						<cfprocparam dbvarname="updateuser" type="in" cfsqltype="cf_sql_varchar" value="Flash" />
					</cfstoredproc>
				</cfcase>
				
				<!--- deleted --->
				<cfcase value="d"> 
					<cfstoredproc datasource="#arguments.datasource#" procedure="metadatakeyword_delete">
						<cfprocparam dbvarname="MetaDataID" type="in" cfsqltype="cf_sql_numeric" value="#thisobj.ID#" />
						<cfprocparam dbvarname="updateuser" type="in" cfsqltype="cf_sql_varchar" value="Flash" />
					</cfstoredproc>
				</cfcase>
			</cfswitch>
		</cfloop>
	</cftransaction>

	<cfset BitmaskGenerate(
		datasource = arguments.datasource,
		metadatatreeid = arguments.metadatatreeid) />
	
	<cfreturn true />
</cffunction>



<!--- DirectChildrenGet --->
<cffunction name="DirectChildrenGet" access="remote" output="false" 
	hint="Returns children of parent node as an array of structures">
	
	<cfargument name="metadatatreeid" type="numeric" required="Yes" hint="Tree ID" />
	<cfargument name="metadataparentid" type="numeric" required="Yes" hint="Parent Node" />

	<cfset var qresults = 0 />
	<cfset var aresults = arrayNew(1) />
	
	<cfstoredproc datasource="#variables.supportDSN#" procedure="MetaDataKeyword_GetDirectChildren">
		<cfprocparam dbvarname="MetaDataTreeID" type="in" cfsqltype="cf_sql_numeric" value="#arguments.MetaDataTreeID#" />
		<cfprocparam dbvarname="MetaDataParentID" type="in" cfsqltype="cf_sql_numeric" value="#arguments.MetaDataParentID#" />
		<cfprocresult resultset="1" name="qresults">
	</cfstoredproc>

	<cfloop query="qresults">
		<cfscript>
			aresults[qresults.currentrow] = structnew();
			aresults[qresults.currentrow].metadatadataid = qresults.metadataid;
			aresults[qresults.currentrow].metadatabitmask = qresults.metadatabitmask;
			aresults[qresults.currentrow].metadataparentid = qresults.metadataparentid;
			aresults[qresults.currentrow].metadatakeyword = qresults.metadatakeyword;
		</cfscript>
	</cfloop>
	
	<cfreturn aresults />
</cffunction>



<!--- generateTree --->
<cffunction name="generateTree" access="public" output="false" returntype="query"
	hint="I sort a query as  parent -> child order based on ID's.">
	
	<cfargument name="qflat" type="query" required="true" 
		hint="The flat query to convert to a tree.  Should have the column names 'itemid, parentitemid, content'" />
	<cfargument name="parentIDColumnName" type="string" required="false" default="parentitemid" 
		hint="Column name that holds the parent id" />
	<cfargument name="itemIDColumnName" type="string" required="false" default="itemid" 
		hint="Column name that holds the primary key" />
	<cfargument name="orderByColumnName" type="string" required="false">
	<!--- only required when called recursively --->
	<cfargument name="qtree" type="query" required="false" 
		hint="the returned tree query" />
	<cfargument name="parentid" type="any" required="false" 
		hint="parent id to retreive children for" />
	<cfargument name="contentColumnNames" type="string" required="false" 
		hint="A list of column names to be included" />
	
	<cfset var colNames = '' />
	<cfset var contentList = '' />
	<cfset var children = '' />
	<cfset var col = 0 />
	
	<cfif not isDefined("arguments.qtree")>
		<cfif not isDefined("arguments.contentColumnNames")>
			<!--- determine column names --->
			<cfset colNames = arguments.qflat.columnlist />
			<cfset arguments.contentColumnNames = listDeleteAt(colNames,listFindNoCase(colNames,arguments.parentIDColumnName)) />
			<cfset arguments.contentColumnNames = listDeleteAt(arguments.contentColumnNames,listFindNoCase(arguments.contentColumnNames,arguments.itemIDColumnName)) />
		</cfif>
		<cfif isDefined("arguments.orderByColumnName") AND listFindNoCase(arguments.contentColumnNames,arguments.orderByColumnName)>
			<cfset arguments.orderByColumnName = arguments.orderByColumnName />
		<cfelse>
			<cfset arguments.orderByColumnName = listFirst(arguments.contentColumnNames) />
		</cfif>
		<cfset arguments.qtree = queryNew('#arguments.parentIDColumnName#,#itemIDColumnName#,#arguments.contentColumnNames#')>
	</cfif>
	
	<cfquery name="children" dbtype="query">
		select *
		from arguments.qflat
		where 1=1
		<cfif isDefined("arguments.parentid") AND len(trim(arguments.parentid))>
			and #arguments.parentIDColumnName# = #arguments.parentid#
		<cfelse>
			and #arguments.parentIDColumnName# is null
		</cfif>
		order by #arguments.orderByColumnName#
	</cfquery>

	<cfoutput query="children">
		<cfscript>
			queryAddRow(arguments.qtree);
			querySetCell(arguments.qtree,'#arguments.parentIDColumnName#',children[arguments.parentIDColumnName][currentrow]);
			querySetCell(arguments.qtree,'#arguments.itemIDColumnName#',children[arguments.itemIDColumnName][currentrow]);
		</cfscript>
		<cfloop list="#arguments.contentColumnNames#" index="col">
			<cfset querySetCell(arguments.qtree,'#col#',children[col][currentrow]) />
		</cfloop>
		<cfset arguments.parentid = children[itemIDColumnName][currentrow] />
		<cfset generateTree(argumentCollection=arguments)>
	</cfoutput>
	
	<cfreturn arguments.qtree/>
</cffunction>
</cfcomponent>