<!---

	Filename: cfc/fileasset.cfc
	Creation Date: June 2004
	Author: Steve Drucker (sdrucker@figleaf.com) Fig Leaf Software (www.figleaf.com)
	Purpose: Support function for multimedia assets

	NOTE:  This CFC is cached from the /figleaf/initialize.cfm file as APPLICATION.FILEASSET
	Changes to this file will only become apparent after reinitialization.

	Modification Log:
	=================================================================================
	01/04/2005	sdrucker	documented


--->

	<cfcomponent name="FileAssets" hint="Data access controls for table FileAsset">
		<cfset variables.ConfigBean = 0 />
        <cfset variables.dsn = "" />
		<cfset application.fileassets.path = "C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\standards\mediaasset\" />
        <cfset application.fileassets.url  = "/mediaasset/" />

		<!--- init --->
        <cffunction name="init" returntype="FileAssets" access="public" output="false"
            displayname="Init" hint="I am the constructor."
            description="I am the pseudo constructor for this CFC. I return an instance of myself.">
            <cfargument name="ConfigBean" required="true" />

            <cfset variables.ConfigBean = arguments.ConfigBean />
            <cfset variables.dsn = variables.ConfigBean.getCommonSpotSupportDSN() />
            <cfset instance.datasource = variables.dsn>
            <cfreturn this />
        </cffunction>

<!---		<cffunction name="init" access="public" output="false" returntype="FileAsset">
			<cfargument name="datasource" type="string" required="yes">

			<cfset instance = structnew()>
			<cfset instance.datasource = arguments.datasource>
			<cfreturn this>


		</cffunction>--->


		<cffunction name="Delete" access="public" output="false" returntype="boolean" hint="Delete record from FileAsset">
			<cfargument name="FileAssetID" type="numeric" required="yes" hint="Primary Key">
			<cfargument name="updateuser" type="string" required="yes" hint="Name of user requesting delete">
			<cfargument name="HardDelete"  type="boolean" required="No"   default="false" hint="Physically remove file and records">


				<!--- remove embedded relations

				<cfset var qRelatedPages = "">
				<cfset var qgetdata = "">
				<cfset var stData = "">
				<cfset var  wdata = "">

				<cfstoredproc datasource="#instance.datasource#" procedure="ArticleFileAsset_RelatedPagesGet">
					<cfprocparam dbvarname="FileAssetID"  type="in" value="#fileassetid#" cfsqltype="cf_sql_integer">
					<cfprocresult name="qRelatedPages" resultset="1">
				</cfstoredproc>

				<cfif qRelatedPages.recordcount gt 0>
					<cfquery name="qgetdata" datasource="#request.site.datasource#">
						select fieldvalue, memovalue
						from data_fieldvalue
						where pageid in (#valuelist(qrelatedpages.pageid)#)
						and fieldid = #listgetat(application.customelements["News Article"].MediaAssets,3,"_")#
						and versionstate = 2
					</cfquery>
					<!--- deserialize --->
					<cfloop query="qgetdata">
						<cfset wdata = qgetdata.fieldvalue & qgetdata.memovalue>
						<cfoutput>#wdata#</cfoutput>
						<cfabort>
					</cfloop>
				</cfif>
				--->

				<!--- delete from "shared" database --->
				<cftransaction>
				<cfif hardDelete>
					<cfstoredproc datasource="#instance.datasource#" procedure="ArticleFileAsset_RelationDeleteByFileAssetID">
						<cfprocparam cfsqltype="cf_sql_integer" dbvarname="FileAssetID" type="numeric" value="#fileassetid#">
					</cfstoredproc>
				</cfif>

				<cfstoredproc datasource="#instance.datasource#" procedure="FileAsset_delete">
					<cfprocparam  cfsqltype="cf_sql_integer"  dbvarname="FileAssetID" value="#FileAssetID#">
					<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="updateuser" value="#updateuser#">
				</cfstoredproc>
				</cftransaction>
			<cfreturn 1>
		</cffunction>

		<cffunction name="Get" access="remote" output="false" returntype="query" hint="Get record from FileAsset">
			<cfargument name="FileAssetID" type="numeric" required="no" hint="Primary key value for FileAsset" default="-1">
			<cfstoredproc datasource="#instance.datasource#" procedure="FileAsset_get">
				<cfif FileAssetID gt 0>
					<cfprocparam cfsqltype="cf_sql_integer" dbvarname="FileAssetID" value="#FileAssetID#">
				</cfif>
				<cfprocresult name="qFileAsset" resultset="1">
			</cfstoredproc>
			<cfreturn qFileAsset>
		</cffunction>


		<cffunction name="recordInsert" access="public" output="false" returntype="numeric"  hint="Insert record into FileAsset and return primary key">
			<cfargument name="SiteID" type="numeric" required="Yes">
			<cfargument name="FileAssetCategoryID" type="numeric" required="Yes" hint="Foreign Key to FileAssetCategory table">
			<cfargument name="FileName" type="string" required="Yes" hint="File Name">
			<cfargument name="FileType" type="string" required="Yes" hint="Audio,Video,Other">
			<cfargument name="quality" type="numeric" required="Yes" hint="1=low, 2=high">
			<cfargument name="FileExt" type="string" required="Yes" hint="3 character extension">
			<cfargument name="FullPath" type="string" required="Yes" hint="Windows path to file on disk volume">
			<cfargument name="FileDescription" type="string" required="Yes" hint="Unicode text description of file">
			<cfargument name="Updateuser" type="string" required="No">

			<cfset var qresult = "">
			<cfstoredproc procedure="FileAsset_insert" datasource="#instance.datasource#">
					<cfprocparam dbvarname="SiteID" type="in" cfsqltype="cf_sql_numeric" value="#SiteID#">
					<cfprocparam dbvarname="FileAssetCategoryID" type="in" cfsqltype="cf_sql_numeric" value="#FileAssetCategoryID#">
					<cfprocparam dbvarname="FileName" type="in" cfsqltype="cf_sql_varchar" value="#FileName#">
					<cfprocparam dbvarname="FileType" type="in" cfsqltype="cf_sql_varchar" value="#FileType#">
					<cfprocparam dbvarname="Quality" type="in" cfsqltype="cf_sql_numeric" value="#quality#">
					<cfprocparam dbvarname="FileExt" type="in" cfsqltype="cf_sql_varchar" value="#FileExt#">
					<cfprocparam dbvarname="FullPath" type="in" cfsqltype="cf_sql_varchar" value="#FullPath#">
					<cfprocparam dbvarname="FileDescription" type="in" cfsqltype="cf_sql_varchar" value="#FileDescription#">
					<cfprocparam dbvarname="Updateuser" type="in" cfsqltype="cf_sql_varchar" value="#Updateuser#">

					<cfprocresult name="qresult"  resultset="1">
			</cfstoredproc>



			<cfreturn qresult.FileAssetID>
		</cffunction>

		<cffunction name="update" access="public" output="false" returntype="boolean"  hint="Update record in FileAsset">
			<cfargument name="FileAssetID" type="numeric" required="yes" hint="Primary key">
			<cfargument name="FileAssetCategoryID" type="numeric" required="Yes">
			<cfargument name="FileName" type="string" required="Yes">
			<cfargument name="FileType" type="string" required="Yes">
			<cfargument name="quality" type="numeric" required="yes">
			<cfargument name="FileExt" type="string" required="Yes">
			<cfargument name="FullPath" type="string" required="Yes">
			<cfargument name="FileDescription" type="string" required="Yes">

			<cfargument name="Updateuser" type="string" required="No">

			<cfset var qresult = "">
			<cfstoredproc procedure="FileAsset_update" datasource="#instance.datasource#">
					<cfprocparam cfsqltype="cf_sql_integer" dbvarname="FileAssetID" type="in" value="#FileAssetID#">
					<cfprocparam dbvarname="FileAssetCategoryID" type="in" cfsqltype="cf_sql_numeric" value="#FileAssetCategoryID#">
					<cfprocparam dbvarname="FileName" type="in" cfsqltype="cf_sql_varchar" value="#FileName#">
					<cfprocparam dbvarname="FileType" type="in" cfsqltype="cf_sql_varchar" value="#FileType#">
					<cfprocparam dbvarname="quality" type="in" cfsqltype="cf_sql_numeric" value="#quality#">
					<cfprocparam dbvarname="FileExt" type="in" cfsqltype="cf_sql_varchar" value="#FileExt#">
					<cfprocparam dbvarname="FullPath" type="in" cfsqltype="cf_sql_varchar" value="#FullPath#">
					<cfprocparam dbvarname="FileDescription" type="in" cfsqltype="cf_sql_varchar" value="#FileDescription#">
					<cfprocparam dbvarname="Updateuser" type="in" cfsqltype="cf_sql_varchar" value="#Updateuser#">

			</cfstoredproc>
			<cfreturn 1>
		</cffunction>


		<cffunction name="search" access="public" output="false" returntype="query"  hint="Update record in FileAsset">
			<cfargument name="description" type="string" required="no" hint="Description for full text search">
			<cfargument name="startdate" type="string" required="no" hint="Upload Date (start)">
			<cfargument name="enddate" type="string" required="no" hint="Upload Date (end)">
			<cfargument name="fileassetcategoryid" type="string" required="no" hint="FileAssetCategoryID (foreign key)">
			<cfargument name="fileext" type="string" required="no" hint="File extension, example: .RA">
			<cfargument name="filetype" type="string" required="no" hint="Audio, Video, Other">
			<cfargument name="siteid"  type="string" required="no" hint="CommonSpot Site ID">


			<cfset var qsearchresults = "">
			<cfquery name="qsearchresults" datasource="#instance.datasource#" maxrows="50">
			  select *
			  from fileasset
			  where endtime is null
			  <cfif trim(description) is not "">
				and freetext(*, '#description#')
			  </cfif>
			  <cfif trim(startdate) is not "">
					and begintime >= '#startdate#'
			  </cfif>
			  <cfif trim(enddate) is not "">
					and begintime <= '#enddate# 23:59:59'
			  </cfif>
			  <cfif trim(fileassetcategoryid) is not "">
				and fileassetcategoryid = #val(fileassetcategoryid)#
			  </cfif>
			  <cfif trim(fileext) is not "">
				and fileext = '#fileext#'
			  </cfif>
			  <cfif trim(filetype) is not "">
				and filetype = '#filetype#'
			  </cfif>
			  <cfif trim(siteid) is not "">
				and siteid = #val(siteid)#
			  </cfif>
			  order by begintime desc
			</cfquery>
			<cfreturn qsearchresults>
		</cffunction>

		<!---
			Creation Date: July 2007
			By: Mojdeh Ghafoori
			Purpose: Gets the media files list for specific page id
		--->
		<cffunction name="GetTranscript_MediaList" access="public" output="false" returntype="array">

			<cfargument name="siteid" type="numeric" required="Yes">
			<cfargument name="pageid" required="yes" type="string">

			<cfset var aMedia = arrayNew(1)>
			<cfset var stMedia = "">
			<cfset var i = 0>

			<!--- get preferred media types --->
			<cfquery name="qmedia" datasource="#instance.datasource#">
				select
					articlefileasset.pageid,
					fileasset.fileassetid,
					fileasset.filename,
					fileasset.filedescription,
					fileasset.filetype
				from
					fileasset join articlefileasset
					on (fileasset.fileassetid = articlefileasset.fileassetid)
					join fileassetrank on
					(right(fileasset.filename,3) = fileassetrank.filetype)
				where
					articlefileasset.siteid = <cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_integer">
					and articlefileasset.pageid = <cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_integer">
					and fileasset.filetype IN ('Audio', 'Video', 'Other')
				order by
					articlefileasset.pageid,
					fileassetrank.rank,
					articlefileasset.rank desc
			</cfquery>

			<!--- put in sorted order by preferred media types --->
			<cfif qmedia.recordcount gt 0>
				<cfloop query="qmedia">
					<cfscript>
						stMedia = structnew();
						stMedia.fileassetid = qmedia.fileassetid;
						stMedia.filename = qmedia.filename;
						stMedia.filedescription = qmedia.filedescription & " (" & qmedia.filetype & ")";
						stMedia.filetype= left(qmedia.filetype,1);
						arrayAppend(aMedia,stMedia);
					</cfscript>
				</cfloop>
			</cfif>

			<cfreturn aMedia>

		</cffunction>

	</cfcomponent>



