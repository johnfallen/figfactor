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
	
	<cfargument name="Event" required="true" />
	<cfargument name="BeanFactory" required="false" default="" />
	<cfargument name="Helpers" required="false"  />
	<cfargument name="returnIDsOnly" required="false" default="false" hint="Should I only return teh values from getReleatedPages() value?" />

	
	<cfset var results = 0 />
	<cfset var lmetadataids = "" />
	<cfset var pageIDs = "" />
	<cfset arguments.PageEvent = arguments.event>

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
	<cfargument name="Event" 
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
	<cfset arguments.pageEvent = arguments.event />
	
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


<!--- getPageList
<cffunction name="getPageList" returntype="any" access="public" output="false"
	displayname="Get Page List" hint="I return a query of pages by Meta-data ID and subsite."
	description="I return a query of pages by Meta-data ID and subsite.">

	<cfargument name="pageTypes" default=""
		hint="I am a list of PageTypes to get.<br />I defalult to an empty string ''." />
	<cfargument name="pageEvent" 
		hint="I am the PageEvent Object.<br />I am required." />
	<cfargument name="beanfactory" 
		hint="I am the PageEvent Object.<br />I am required." />
	
	<cfset var PageID = arguments.pageEvent.getPageID() />
	<cfset var SubSiteIDs = request.subsite.id & "," & request.subsite.CHILDLIST />
	<cfset var pages = 0 />
	<cfset var theval = 0 />
	<cfset var metaDataPagesIDs = 0 />
	<cfset var config = arguments.beanfactory.getBean("ConfigBean") />
	<cfset var finalPages = 0 />
	<cfset var customelement = arguments.pageEvent.getValue("customelement") />
	<cfset var fleetDsn = config.getCommonSpotSupportDSN() />
	<cfset var dsn = config.getCommonSpotDSN() />
	<cfset var sortOrder = "" />
	<cfset var lastFilterQuery = "" />
	
	
	<cfdump var="#arguments.pageEvent.getAllValues()#">
	<cfabort />
	
	<cfif structKeyExists(customelement, "page_list_taged_terms") 
			and listLen(arguments.pageEvent.getValue("customelement").page_list_taged_terms) gt 0>
		
		<!--- set the metadata ids return from FLEET --->
		<cfset metaDataPagesIDs = arguments.pageEvent.getValue("customelement").page_list_taged_terms />
			
		<!--- get releated pageID's from the ReleatedLinks.cfc --->
		<cfset metaDataPagesIDs = variables.releatedLinks.getReleatedPages(
			datasource = fleetDsn, 
			lmetadataids = "#metaDataPagesIDs#") />
	</cfif>

	<!--- if we got a result with ID's query the commonspot db --->
	<cfif listLen(metaDataPagesIDs)>
		
		<!--- now query to get the releated pages ONLY from the children subsites --->
		<cfquery name="pages" datasource="#dsn#" result="theval">
			select  distinct
				p.filename, p.caption,  p.title,  p.description, p.ID as PageID,
				
				d.DateApproved,  d.FieldValue, d.FormID, d.FieldID, d.DateAdded,
				
				s.ID as subsiteID, s.subsiteurl, s.imagesurl, s.imagesdir
	
			from Data_FieldValue d
			
			join SitePages p on d.PageID = p.ID
			join SubSites s on p.SubSiteID = s.ID
			join FormControl f on d.FormID = f.ID
			join FormInputControl i on d.FieldID = i.ID
			
			where subsiteID in (<cfqueryparam value="#SubSiteIDs#" cfsqltype="cf_sql_integer" list="true" />)
			and pageID in (<cfqueryparam value="#metaDataPagesIDs#" cfsqltype="cf_sql_integer" list="true" />)
			and d.versionState = 2
			
			order by d.DateAdded desc
		</cfquery>
		
		<!--- make a filtered query --->
		<cfquery dbtype="query" name="finalPages">
			SELECT distinct pageID, filename, subsiteurl, title, dateApproved, caption
			FROM pages
			where pageID in (#metaDataPagesIDs#)
		</cfquery>
	
		<!--- now filter out by distinct again --->
		<cfquery name="lastFilterQuery" dbtype="query">
			SELECT distinct pageID, filename, subsiteurl, title
				FROM finalPages
				where pageID in (#metaDataPagesIDs#)
				
				<!--- figure out the order to return --->
				<cfif structKeyExists(arguments.pageEvent.getAllValues().customelement, "page_list_order")>
					<cfset sortOrder = arguments.pageEvent.getAllValues().customelement.page_list_order />
					<cfif sortOrder eq "alpha">
						ORDER BY title asc
						
					<cfelseif sortOrder eq "Last Modifyed">
						ORDER BY dateApproved desc
					</cfif>
				</cfif>
		</cfquery>
	</cfif>

	<cfreturn lastFilterQuery />
</cffunction>
 --->
<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>