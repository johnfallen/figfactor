<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			CommonSpotGateway.cfc
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:   	 	@@@company-name@@@
Website:    		@@@web-site@@@
Usage:      
Modification Log:
Name	 Date	 Description
================================================================================
John Allen	 07/06/2008	 Created
------------------------------------------------------------------------------->
<cfcomponent displayname="" hint="I am the CommonSpot Gateway" output="false">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="CommonSpotGateway" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfreturn this />
</cffunction>


 
 
<!--- getNewsAndEvents --->
<cffunction name="getNewsAndEvents" output="false">
	<cfargument name="dsn" default="#variables.GatewayConfigBean.getCommonSpotDSN()#" 
		hint="I am the datasource. I defalut to a configuration setting.<br />I am required." />
	
	<cfset var bodyArray = arrayNew(1)>
	<cfset var pageQuery = 0>
	<cfset var getNewsBody = 0>
	<cfset var SubSiteIDs = request.subsite.id & "," & request.subsite.CHILDLIST>
	
	
	<!--- Get News and Event Pages for an OU --->
	<cfquery name="pageQuery" datasource="#arguments.dsn#" result="theval">
		select  distinct
			p.filename, p.caption,  p.title,  p.description, p.ID as PageID,
			d.DateApproved,  d.FieldValue, d.FormID, d.FieldID, d.DateAdded,
			s.ID as subsiteID, s.subsiteurl, s.imagesurl, s.imagesdir

		from Data_FieldValue d
		
		join SitePages p on d.PageID = p.ID
		join SubSites s on p.SubSiteID = s.ID
		join FormControl f on d.FormID = f.ID
		join FormInputControl i on d.FieldID = i.ID
		
		where s.id in (<cfqueryparam value="#SubSiteIDs#" cfsqltype="cf_sql_integer" list="true" />)
		
		and d.versionState = 2
		and d.fieldValue = 'News Item'
		order by d.DateApproved desc
	</cfquery>
	
	<!--- add the 'body' column --->
	<cfset QueryAddColumn(pageQuery, "body", "VarChar", bodyArray)>
	
	<cfif pageQuery.recordcount>
		<cfquery name="getNewsBody" datasource="#arguments.dsn#">
				select
				
					p.ID as PageID,
				case
				      when 
				      	d.memoValue is not null 
				      	and 
				      	ltrim(rtrim( convert(varchar(100),d.memoValue) )) != '' then d.memoValue
				      else 
				      	d.fieldValue
				end 
					
				from Data_FieldValue d
				
				join SitePages p on d.PageID = p.ID
				join SubSites s on p.SubSiteID = s.ID
				join FormControl f on d.FormID = f.ID
				join FormInputControl i on d.FieldID = i.ID
				
				where 
					PageID IN (<cfqueryparam value="#valueList(pageQuery.PageID)#" cfsqltype="cf_sql_integer" list="true" />)
				and d.versionState = 2
				and i.FieldName = 'FIC_news_item_body'
				order by d.DateApproved desc
		</cfquery>
		
		
		<cfloop query="pageQuery">
			
			<cfloop query="getNewsBody">
				<cfif pageQuery.pageID eq getNewsBody.pageID>
					<cfset pageQuery.body = getNewsBody.COMPUTED_COLUMN_2 />
				</cfif>
			</cfloop>			
		</cfloop>
	
	</cfif> 

	<cfreturn pageQuery />
</cffunction>
<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>