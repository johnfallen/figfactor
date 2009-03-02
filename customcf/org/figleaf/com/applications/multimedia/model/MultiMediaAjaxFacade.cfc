<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			AjaxFacade.cfc
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am a facade for Ajax requests
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		29/10/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Ajax Facade" output="false"
	hint="I am a facade for Ajax requests">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="MultiMediaAjaxFacade" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	

	<cfreturn this />
</cffunction>



<!--- getConfig --->
<cffunction name="getConfig" returntype="component" access="remote" output="false"
	displayname="Get Config" hint="I return the configuration object."
	description="I return the configuration object.">
	
	<cfreturn Application.FigFactorMultiMediaFactory.getBean("Config") />
</cffunction>



<!--- getPageObject --->
<cffunction name="getPage" returntype="any" access="remote" output="false"
	displayname="Get Page Object" hint="I return a page object."
	description="I return a page object.">
	
	<cfargument name="IDPage" type="numeric" required="true" 
		hint="I am the CommonSpot page ID.<br />I am required." />
	

	<!--- hop into MultiMedia and return the page object --->	
	<cfreturn Application.FigFactorMultiMediaFactory.getBean("MultiMedia").getPage(arguments.IDPage) />
</cffunction>



<!--- getGalleryItems --->
<cffunction name="getGallery" returntype="component" access="remote" output="false"
	displayname="Get Gallery" hint="I return a gallery Object."
	description="I return a galley object by a Pages ID. If not passed the galleryIndex I will return the top Gallery object from the array of Galleries.">
	
	<cfargument name="IDPage" type="numeric" required="false" 
		hint="I am the CommonSpot page ID.<br />I defalut to '0'." />
	<cfargument name="galleryIndex" type="numeric" required="false" 
		hint="I am the ID of the gallery.<br />I default to '0'." />
	
	<cfset var result = structNew() />
	
	<!--- <cfset result.GalleryItems = Application.FigFactorMultiMediaFactory.getBean("MultiMedia").getGalleryItems(argumentCollection = arguments) />
	<cfset result.Gallery =>
	 --->
	<!--- hop into MultiMedia and return the page object --->	
	<cfreturn application.beanfactory.getBean("Multimedia").getBean("multimedia").getGallery(argumentCollection = arguments) />
</cffunction>



<!--- listGalleryItems --->
<cffunction name="listGalleryItems" returntype="any" access="remote" output="false"
	displayname="List Gallery Items" hint="I return a query of a gallery items."
	description="I return a query of gallery items.">
	
	<cfargument name="IDPage" type="numeric" required="false" 
		hint="I am the CommonSpot page ID.<br />I defalut to '0'." />
	<cfargument name="galleryIndex" type="numeric" required="false" 
		hint="I am the ID of the gallery.<br />I default to '0'." />

	<!--- hop into MultiMedia and return the page object --->	
	<cfreturn application.beanfactory.getBean("Multimedia").getBean("multimedia").listGalleryItems(argumentCollection = arguments) />
</cffunction>



<!--- listMedia --->
<cffunction name="listMedia" returntype="any" access="remote" output="false"
	displayname="List Media" hint="I retrun a query of media."
	description="I ask the ORM service  for a query of contacts.">
	
	<cfargument name="page" required="yes" />
	<cfargument name="pageSize" required="yes" />
	<cfargument name="gridsortcolumn" required="yes" />
	<cfargument name="gridsortdirection" required="yes" />	
	<cfargument name="Title" type="any" required="false" default="" />
	<cfargument name="IDType" type="string" required="false" default="" />
	
	<!--- hop into MultiMedia then get the query --->
	<cfset var mediaList = 0 />

	<cfif len(arguments.IDType) and arguments.IDType neq "pageIsMixedMedia">
		<cfset mediaList = application.beanfactory.getBean("Multimedia").getBean("multimedia").listMedia(arguments.IDType)/>
	<cfelse>
		<cfset mediaList = application.beanfactory.getBean("Multimedia").getBean("multimedia").listMedia("", arguments.Title)/>
	</cfif>
	
	<!--- sort if need be --->
	<cfif arguments.gridSortColumn neq "" or gridSortDirection neq "">
		<cfset mediaList = querySort(mediaList, arguments.gridSortColumn, gridSortDirection) />
	</cfif>
	
	<cfreturn queryConvertForGrid(mediaList, page, pagesize)>
</cffunction>



<!--- listUserMedia --->
<cffunction name="listUserMedia" returntype="any" access="remote" output="false"
	displayname="List User Media" hint="I retrun a query of a users media."
	description="I retrun a query of a users media.">

	<cfargument name="page" required="yes">
	<cfargument name="pageSize" required="yes">
	<cfargument name="gridsortcolumn" required="yes">
	<cfargument name="gridsortdirection" required="yes">
	<cfargument name="IDUser" required="false" default="0">

	<cfset var gateway = application.beanfactory.getBean("Multimedia").getBean("gateway") />
	
	<!---  get the query --->
	<cfset var result = gateway.listUserMedia(arguments.IDUser)/>
	
	<!--- sort if need be --->
	<cfif arguments.gridSortColumn neq "" or gridSortDirection neq "">
		<cfset result = querySort(result, arguments.gridSortColumn, gridSortDirection)>
	</cfif>

	<cfreturn queryconvertforgrid(result, page, pagesize)>
</cffunction>



<!--- searchMedia --->
<cffunction name="searchMedia" returntype="any" access="remote" output="false"
	displayname="Search Media" hint="I retrun list of found media."
	description="I retrun list of found media">
	
	<cfargument name="searchString" type="any" required="false" defalut="" />
	
	<cfset var gateway = Application.FigFactorMultiMediaFactory.getBean("gateway") />
	
	<!---  get the query --->
	<cfset var result = gateway.listMedia(searchString = arguments.searchString)/>
	
	<cfset application.beanfactory.getBean("logger").setMessage(message = "AutoSuggest: #arguments.searchstring#")>
	
	<cfreturn "allen,john,fun">
</cffunction>



<!--- editUserMedia --->
<cffunction name="editUserMedia" access="remote" output="false">
	<cfargument name="gridaction" />
	<cfargument name="gridrow" />
	<cfargument name="gridchanged" >

	<cfset var colname = 0 />
	<cfset var value = 0 />
	<cfset var id = 0 />

    <cfif isStruct(gridrow) and isStruct(gridchanged)>
		<cfif gridaction eq "U">

			<!--- set the values and pass the the gateway --->
			<cfset colname = structkeylist(gridchanged)>
            <cfset value = structfind(gridchanged,#colname#)>
			<cfset id = gridrow.IDContact />
			
			<cfset Application.FigFactorMultiMediaFactory.getBean("gateway").editUserMedia(
				IDMedia = ID,
				colname = colname,
				value = value) />
        <cfelse>
		
			<cfset Application.FigFactorMultiMediaFactory.getBean("gateway").deleteMedia(IDMedia = gridRow.IDMedia)/>    
        </cfif>
    </cfif>
</cffunction>

<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
<cffunction name="QuerySort" output="no" returnType="query">
	<cfargument name="query" type="query" required="true">
	<cfargument name="column" type="string" required="true">
	<cfargument name="sortDir" type="string" required="false" default="asc">

	<cfset var newQuery = "">
	
	<cfquery name="newQuery" dbType="query">
		select * from query
		order by #column# #sortDir#
	</cfquery>
	
	<cfreturn newQuery>
</cffunction>
</cfcomponent>