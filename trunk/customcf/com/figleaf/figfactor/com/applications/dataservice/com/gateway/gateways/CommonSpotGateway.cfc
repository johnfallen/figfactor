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



<!--- getReleatedPages --->
<cffunction name="getReleatedPages" access="public" output="false"
	displayname="Get Releated Pages" hint="I return a query of related pages for a given page."
	description="I return a query of releated pages for a given page by calling several sub components to do the heavy lifting." >
	
	<cfargument name="PageEvent" required="true" />
	<cfargument name="BeanFactory" required="false" default="" />
	<cfargument name="Helpers" required="false"  />
	<cfargument name="returnIDsOnly" required="false" default="false" hint="Should I only return teh values from getReleatedPages() value?" />

	
	<cfset var results = 0 />
	<cfset var lmetadataids = "" />
	<cfset var pageIDs = "" />

	<cfif structKeyExists(arguments.pageEvent.getAllValues(),  "pageMetaDataIDs")>
		<cfset lmetadataids = arguments.pageEvent.getAllValues().pageMetaDataIDs />
		<cfif listFirst(lmetadataids) eq 0>
			<cfset lmetadataids = listDeleteAt(lmetadataids, 1) />
		</cfif>
	</cfif>

	<!--- get releated pageID's from the ReleatedLinks.cfc --->
	<cfset  pageIDs = variables.releatedLinks.getReleatedPages(
		datasource = arguments.BeanFactory.getBean("configBean").getCommonSpotSupportDSN(), 
		lmetadataids = "#lmetadataids#") />

	<cfset results = variables.CommonSpotCFC.pageGet(
		datasource = arguments.BeanFactory.getBean("configBean").getCommonSpotDSN(), 
		lpageids = pageIDs) />

	<cfif arguments.returnIDsOnly eq true>
		<cfreturn pageIDs />
	<cfelse>
		<cfreturn results />
	</cfif>
</cffunction>



<!--- getPageList --->
<cffunction name="getPageList" returntype="any" access="public" output="false"
	displayname="Get Page List" hint="I return a query of pages by Meta-data ID and subsite."
	description="I return a query of pages by Meta-data ID and subsite.">

	<cfargument name="pageTypes" default=""
		hint="I am a list of PageTypes to get.<br />I defalult to an empty string ''." />
	<cfargument name="pageEvent" 
		hint="I am the PageEvent Object.<br />I am required." />
	
	<cfset var config = arguments.beanfactory.getBean("ConfigBean") />
	<cfset var PageID = arguments.pageEvent.getPageID() />
	<cfset var SubSiteIDs = request.subsite.id & "," & request.subsite.CHILDLIST />
	<cfset var fleetDsn = config.getCommonSpotSupportDSN() />
	<cfset var pages = 0 />
	<cfset var theval = 0 />
	<!--- add the "fic_" back on in. :(   I hate stupid "fic_". --->
	<cfset var fieldName = "fic_" & "PageType" />
	<cfset var dsn = config.getCommonSpotDSN() />

	<cfset var ceData = "" />
	<cfset var pageTypeFilter = ""/>
	<cfset var tagedIDs = "" />
	
	
	<!--- set up some vars from the custom element --->
	<cfif isStruct(arguments.pageEvent.getValue("customelement"))>
		<cfset ceData = arguments.pageEvent.getValue("customelement")>
		
		<!--- get the selecte meta data ids --->
		<cfif structKeyExists(ceData, "page_list_taged_terms")>
			<cfset tagedIDs =  ceData.page_list_taged_terms />
		</cfif>
		
		<!--- get the page type to filter by --->
		<cfif structKeyExists(ceData, "page_list_page_type")>
			<cfset pageTypeFilter =  ceData.page_list_page_type />
		</cfif>
		
		<!--- get releated pageID's from the ReleatedLinks.cfc --->
		<cfset metaDataPagesIDs = variables.releatedLinks.getReleatedPages(
			datasource = fleetDsn, 
			lmetadataids = "#tagedIDs#") />
	</cfif>
	
	<!--- when a page has not been submitted we cant run this query --->
	<cfif isStruct(ceData) and structKeyExists(ceData, "page_list_taged_terms")>
		
		<!--- Get News and Event Pages for an OU --->
		<cfquery name="pages" datasource="#dsn#" result="theval">
			select  distinct
				
				p.ID as PageID,
				p.filename, 
				p.title, 
				
				<!--- 
				p.caption,  
				p.description,  
				--->
				
				d.DateApproved,  
				<!--- 
				d.DateAdded,
				d.FieldValue, 
				d.FormID, 
				d.FieldID,  
				--->
				
				s.ID as subsiteID, 
				s.subsiteurl, 
				s.imagesurl, 
				s.imagesdir
				
				s<!---
				i.FieldName,
				
				f.FormName
				--->
			from Data_FieldValue d
			
			join SitePages p on d.PageID = p.ID
			join SubSites s on p.SubSiteID = s.ID
			join FormControl f on d.FormID = f.ID
			join FormInputControl i on d.FieldID = i.ID
			
			where s.id in (#SubSiteIDs#)
			and PageID in (#metaDataPagesIDs#)
			and d.versionState = 2
			and f.FormName in ('#pageTypeFilter#')
	
			<!--- 		
			and d.fieldValue IN ('#pageTypeName#')
			and f.FormName = 'PageType'
			and i.FieldName = 'FIC_pageType' 
			--->
			
			order by d.DateApproved desc
		</cfquery>
	</cfif>

	
	<cfreturn pages />
</cffunction>




<!--- getNewsAndEvents --->
<cffunction name="getNewsAndEvents"  output="false" access="public"
	displayname="Get OU Data" hint="I return a structure of queries with News & Event data."
	description="I return a structure of queries with News and Event data. I use the cfqueries to get my data.">
	
	<cfargument name="dsn" default="#variables.GatewayConfigBean.getCommonSpotDSN()#" 
		hint="I am the datasource. I defalut to a configuration setting.<br />I am required." />

	<cfset var bodyArray = arrayNew(1) />
	<cfset var thumbArray = arrayNew(1) />
	<cfset var eventStartDateArray = arrayNew(1) />
	<cfset var sortDateArray = arrayNew(1) />
	<cfset var newsAndEvents = "" />
	<cfset var SubSiteIDs = request.subsite.id & "," & request.subsite.CHILDLIST />
	<cfset var theval = 0 />
	<cfset var getNewsBody = 0 />
	<cfset var getNewsDate = 0 />
	<cfset var getEventBody = 0 />
	<cfset var getEventDate = 0 />
	<cfset var finalDateSortedQuery = 0 />

	<!--- Get News and Event Pages for an OU --->
	<cfquery name="newsAndEvents" datasource="#arguments.dsn#" result="theval">
		select  distinct
			p.filename, p.caption,  p.title,  p.description,  p.ID as PageID,
			
			d.DateApproved,  d.FieldValue, d.FormID, d.FieldID, d.DateAdded,
			
			s.ID as subsiteID, s.subsiteurl, s.imagesurl, s.imagesdir

		from Data_FieldValue d
		
		join SitePages p on d.PageID = p.ID
		join SubSites s on p.SubSiteID = s.ID
		join FormControl f on d.FormID = f.ID
		join FormInputControl i on d.FieldID = i.ID
		
		where s.id in (<cfqueryparam value="#SubSiteIDs#" cfsqltype="cf_sql_integer" list="true" />)
		
		and d.versionState = 2
		and d.fieldValue IN ('News Item', 'event')
		and f.FormName = 'PageType'
		and i.FieldName = 'FIC_pageType'
		
		order by d.DateApproved desc
	</cfquery>
	
	<!--- add the 'body' and thumbnail columns to the return query --->
	<cfset QueryAddColumn(newsAndEvents, "body", "VarChar", bodyArray)>
	<cfset QueryAddColumn(newsAndEvents, "thumbnail", "VarChar", thumbArray)>
	<cfset QueryAddColumn(newsAndEvents, "eventStartDate", "Integer", eventStartDateArray)>
	<cfset QueryAddColumn(newsAndEvents, "sortDate", "Integer", sortDateArray)>
	
	<!--- 
		get the body tex for events and news items, turn the "content" into an 
		array add it to the newsAndEvents qeury.
	 --->
	<cfif newsAndEvents.recordcount>
	
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
					PageID IN (<cfqueryparam value="#valueList(newsAndEvents.PageID)#" cfsqltype="cf_sql_integer" list="true" />)
				and d.versionState = 2
				and i.FieldName = 'FIC_news_item_body'
				order by d.DateApproved desc
		</cfquery>


		<!--- query for news date --->
		<cfquery name="getNewsDate" datasource="#arguments.dsn#">
				select
				
					p.ID as PageID,
				case
				      when d.memoValue is not null and ltrim(rtrim(convert(varchar(100),d.memoValue))) != '' then d.memoValue
				      else d.fieldValue
				end 
					
				from Data_FieldValue d
				
				join SitePages p on d.PageID = p.ID
				join SubSites s on p.SubSiteID = s.ID
				join FormControl f on d.FormID = f.ID
				join FormInputControl i on d.FieldID = i.ID
				
				where 
					PageID IN (<cfqueryparam value="#valueList(newsAndEvents.PageID)#" cfsqltype="cf_sql_integer" list="true" />)
				and d.versionState = 2
				and i.FieldName = 'FIC_news_item_release_date'
				order by d.DateApproved desc
		</cfquery>

		
		<!--- query for images --->
		<cfquery name="getNewsImage" datasource="#arguments.dsn#">
				select
				
					p.ID as PageID,
				case
				      when d.memoValue is not null and ltrim(rtrim(convert(varchar(100),d.memoValue))) != '' then d.memoValue
				      else d.fieldValue
				end 
					
				from Data_FieldValue d
				
				join SitePages p on d.PageID = p.ID
				join SubSites s on p.SubSiteID = s.ID
				join FormControl f on d.FormID = f.ID
				join FormInputControl i on d.FieldID = i.ID
				
				where 
					PageID IN (<cfqueryparam value="#valueList(newsAndEvents.PageID)#" cfsqltype="cf_sql_integer" list="true" />)
				and d.versionState = 2
				and i.FieldName = 'FIC_news_item_thumbnail'
				order by d.DateApproved desc
		</cfquery>


		<cfloop query="newsAndEvents">
			
			<cfloop query="getNewsBody">
				<cfif newsAndEvents.pageID eq getNewsBody.pageID>
					<cfset newsAndEvents.body = getNewsBody.COMPUTED_COLUMN_2 />
				</cfif>
			</cfloop>
			
			<cfloop query="getNewsDate">
				<cfif newsAndEvents.pageID eq getNewsDate.pageID>
					<cfset newsAndEvents.sortDate = getNewsDate.COMPUTED_COLUMN_2 />
				</cfif>
			</cfloop>
			
			<cfloop query="getNewsImage">
				<cfif newsAndEvents.pageID eq getNewsImage.pageID>
					<cfset newsAndEvents.thumbnail = getNewsImage.COMPUTED_COLUMN_2 />
				</cfif>
			</cfloop>
			
		</cfloop>
	</cfif>


	<cfquery dbtype="query" name="finalDateSortedQuery" maxrows="3">
		SELECT *
		FROM newsAndEvents
		ORDER by sortDate desc
	</cfquery>


	<cfif isDefined("url.jfa")>
		<cfdump var="#finalDateSortedQuery#">
		<cfabort />
	</cfif>

	<cfreturn finalDateSortedQuery />
</cffunction>
<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>