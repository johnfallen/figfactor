<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		Hackernate.cfc
Author:     		John Allen
Email:      		jallen@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@

Purpose:    	I am a persistance layer for CommonSpot

Usage:      		

Modification Log:
Name 			Date 					Description

================================================================================
John Allen 		25/09/2008			Created

------------------------------------------------------------------------------->
<cfcomponent displayname="Hackernate" output="false"
	hint="I am a persistance layer for CommonSpot">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Hackernate" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="Factroy" hint="I am the FigLeafSystem Bean Factory.<br />I am required." />
	<cfargument name="CommonSpotCFC" hint="I am the Fig Leaf CommonSpotCFC utility .<br />I am required." />
	<cfargument name="RelatedLinks" hint="I am the Fig Leaf Releated Links utility.<br />I am required." />

	<cfset variables.factory = arguments.factory />
	<cfset variables.config = variables.factory.getBean("Config") />
	
	<cfset variables.dsn = variables.config.getCommonSpotDSN() />
	<!--- <cfset variables.BeanUtils = variables.factory.getBean("BeanUtils") /> --->
	<cfset variables.CommonSpotCFC = arguments.CommonSpotCFC />
	<cfset variables.ReleateLinks = arguments.ReleatedLinks />
	<cfset variables.pageTypeFormName = variables.config.getPageTypeMetaDataFormName() />
	<cfset variables.pageTypeFieldName = variables.config.getPageTypeMetaDataFormFieldName() />
	<cfset variables.metadataFieldName = variables.config.getFleetMetaDataFieldName() />

	<cfreturn this />
</cffunction>



<!--- getPageList --->
<cffunction name="getPageList" returntype="any" access="public" output="false"
	displayname="Get Page List" hint="I return a query of pages by Meta-data ID and subsite."
	description="I return a query of pages by Meta-data ID and subsite.">
	
	<cfargument name="dsn" default="#variables.dsn#" 
		hint="I am the datasource. I defalut to a configuration setting.<br />I am required." />
	<cfargument name="pageTypes" default=""
		hint="I am a list of PageTypes to get.<br />I defalult to an empty string ''." />
	<cfargument name="pageEvent" 
		hint="I am the PageEvent Object.<br />I am required." />
	
	<cfset var PageID = arguments.pageEvent.getPageID() />
	<cfset var SubSiteIDs = request.subsite.id & "," & request.subsite.CHILDLIST />
	<cfset var pages = 0 />
	<cfset var theval = 0 />
	<!--- add the "fic_" back on in. :(   I hate stupid "fic_". --->
	<cfset var fieldName = "fic_" & variables.pageTypeFieldName />
	

	<!--- Get News and Event Pages for an OU --->
	<cfquery name="pages" datasource="#arguments.dsn#" result="theval">
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
		
		<cfif arguments.pageTypes neq "">
			and d.fieldValue IN (<cfqueryparam value="#arguments.pageTypes#" cfsqltype="cf_sql_varchar" list="true" />)
		</cfif>	
		
		and d.versionState = 2
		and i.FieldName = '#fieldName#'
		
		order by d.DateAdded desc
	</cfquery>
	
	<cfreturn pages />
</cffunction>



<!--- getReleatedPages 
<cffunction name="getReleatedPages" access="public" output="false"
	displayname="Get Releated Pages" hint="I return a query of related pages for a given page."
	description="I return a query of releated pages for a given page by calling several sub components to do the heavy lifting." >
		
	<cfargument name="selectedMetaData" default="none" hint="I am a list of PageID's<br />I defalut to a string 'none'." />

	<cfset var results = 0 />
	<cfset var lmetadataids = "" />
	<cfset var pageIDs = "" />
	<cfset var metaDataFieldName = replaceNoCase(variables.config.getFleetMetaDataFieldName(), "FIC_", "")>

	<cfif arguments.selectedMetaData eq "none">
		
		<cfset lmetadataids = request.page.metadata.PageType[metaDataFieldName] />
	<cfelse>
		<cfif listFirst(arguments.selectedMetaData) eq 0>
			<cfset lmetadataids = listDeleteAt(arguments.selectedMetaData, 1) />
		</cfif>
	</cfif>

	<!--- get releated pageID's from the ReleatedLinks.cfc --->
	<cfset  pageIDs = variables.ReleateLinks.getReleatedPages(
		datasource = variables.config.getCommonSpotSupportDSN(), 
		lmetadataids = "#lmetadataids#") />

	<cfset results = variables.CommonSpotCFC.pageGet(
		datasource = variables.config.getCommonSpotDSN(), 
		lpageids = pageIDs) />

	<cfif isQuery(results)>
		<cfreturn results />
	<cfelse>
		<cfreturn 0 />
	</cfif>	
</cffunction>
--->


<!--- getCustomElementData --->
<cffunction name="getCustomElementData" returntype="any" access="public" output="false"
	displayname="Get Custom Element Data" hint="I return a single row query or object populated with a custom elements data by page id."
	description="I return a single row query populated or object with a custom elements data by page id.">
	
	<cfargument name="dsn" default="#variables.dsn#" />
	<cfargument name="pageID" default="0" type="Numeric" />
	<cfargument name="returnType" default="query" />
	
	<cfset var CustomElementQuery = 0 />
	
	<cfquery name="CustomElementQuery" datasource="#arguments.dsn#">
	select
		replace(f.fieldName,'FIC_','') as fieldName, 
		
		case
			when d.memoValue is not null and ltrim(rtrim(convert(varchar(100),d.memoValue))) != '' then d.memoValue
		else 
			d.fieldValue
		end 
	as fieldValue
	
	from 
		Data_FieldValue d
	join 
		FormInputControl f on d.fieldID = f.ID
		
		where d.pageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pageID#">
		and 
		d.versionState = 2
	</cfquery>
	
	<!--- if the request want a bean returned --->
	<cfif arguments.returnType neq "query">
		<cfreturn createObject("component", "bean.BeanShell").init(CustomElementQuery) />
	<cfelse>
		<cfreturn CustomElementQuery />	
	</cfif>

</cffunction>



<!--- getMetaDataNode --->
<cffunction name="getMetaDataNode" returntype="any" access="public" output="false"
	displayname="Get Metadata Node" hint="I return a metadata term and its children."
	description="I return a metadata term and its children as an array of structurs.">
	
	<cfargument name="PageEvent" hint="I am the PageEvent Object.<br />I am required." />	
	
	<cfset var metaDataTreeID = 1 />
	<cfset var MetaDataParentID =  "" />
	<cfset var MetaDataNode = 0 />
	
	<!--- if len, this came from a form submit --->
	<cfif len(pageEvent.getValue("MetaDataKeywordID"))>
		
		<cfset MetaDataParentID = pageEvent.getValue("MetaDataKeywordID") />

	<cfelse><!--- this is a defalut display so we need the metadataID from the meta data form field --->
		<cfset MetaDataParentID = listGetAt(pageEvent.getValue("pageMetaDataIDs"), 2) />
	</cfif>

	<cfset MetaDataNode = MetaDataKeyWordService.DirectChildrenGet(
		MetaDataTreeID = MetaDataTreeID,
		MetaDataParentID = MetaDataParentID) />	
	
	<!--- add the results to the PageEvent's EventCollection --->
	<cfset arguments.PageEvent.setValue("MetaDataNode", MetaDataNode) />
	
	<!--- return, we DONT want this in the cache --->
	<cfreturn 0 />
</cffunction>

<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>

<!--- developmentQueries
<cffunction name="developmentQueries" returntype="any" access="public" output="false"
	displayname="Development Queries" hint="."
	description=".">
		
	<cfargument name="dsn" default="#variables.dsn#" />

	<cfset var result = 0 />

	<cfquery name="result" datasource="#arguments.dsn#">
	
		select 
			ds.pageid, 
			ds.fieldValue as dateStart, 
			de.fieldValue as dateEnd
	
		from FormControl f
		
		join 
			Data_FieldValue ds on ds.formID = f.id 
			and 
			ds.fieldID = 
				(
				     select 
				     	dsi.id
				     from 
				     	FormInputControlMap dsm
				     join 
				     	FormInputControl dsi on dsm.fieldID = dsi.id
				     	where 
				     		dsi.fieldName = 'FIC_Start_Display_Date'
				     	and 
				     		dsm.formID = f.id
				)
		join 
			Data_FieldValue de on ds.pageID = de.pageID 
			and 
			de.formID = f.id 
			and 
			de.fieldID = 
				(
					select 
						dei.id
					from 
						FormInputControlMap dem
					
					join 
						FormInputControl dei 
						on 
						dem.fieldID = dei.id
					
					where 
						dei.fieldName = 'FIC_End_Display_Date'
						and 
						dem.formID = f.id
				)
		where 
			f.formName = '#variables.pageTypeFormName#'
	
		and ds.versionState = 2
		and de.versionState = 2
		and (isnull(ds.fieldValue,'') != '' AND convert(datetime,ds.fieldValue) <= getdate())
		and (isnull(ds.fieldValue,'') != '' AND convert(datetime,de.fieldValue) > getdate())	
	</cfquery>

	<cfreturn  result />
</cffunction>
--->