<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			Gateway.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am the gateway. I manage persistance of the application
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		03/01/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Gateway" output="false"
	hint="I am the gateway. I manage persistance of the application">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Gateway" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="orm" type="component" required="true" 
		hint="I am the ORM.<br />I am required." />
	<cfargument name="Config" type="component" required="true" 
		hint="I am the ConfigBean object.<br />I am required." />
	
	<cfset variables.orm = arguments.orm.getTransfer() />
	<cfset variables.defaultIDLayout = config.getDefaultGalleryIDLayout() />
	
	<cfreturn this />
</cffunction>



<!--- addMediaToGallery --->
<cffunction name="addMediaToGallery" returntype="void" access="public" output="false"
	displayname="Add Media To Gallery" hint="I add an Item to a users gallery."
	description="I add an media item to a users gallery.">
	
	<cfargument name="IDMedia" type="numeric" required="true" 
		hint="I am the ID of the Gallery.<br />I am required" />	
	<cfargument name="IDGallery" type="numeric" required="true" 
		hint="I am the ID of the Gallery.<br />I am required" />	
	
	<cfset var gallery = variables.orm.get("gallery.Gallery", arguments.IDGallery) />
	<cfset var media = getMedia(arguments.IDMedia) />
	<cfset var item = variables.orm.new("gallery.Item") />
	<cfset var x = 0 />
	<cfset var allReadyExists = 0>
	<cfset var items = arrayNew(1) />	
	
	<!---  
		Items are "proxied" media objects. Why? Because transfer
		wont let any other columns exsist on a LookUp table other
		then the primary keys. This could be refactored to use a
		composite key, but with all the ordering of a galleries objects
		this strategy seems to work really well. Its simple, like the author.
		
		When working with a galleries items, to get the parent media 
		object is simple enough, just method chain up the object graph
		item.getMedia().getIDMedia(). They are proxied in the transfer
		configuration file as well, so performance shouldn''t be an issue.
	--->
	<cfset items = gallery.getItemArray() />	

	<cfloop from="1" to="#arrayLen(items)#" index="x">
		<cfif items[x].getMedia().getIDMedia() eq arguments.IDMedia>
			<cfset allReadyExists = 1 />
		</cfif>
	</cfloop>

	<cfif allReadyExists eq 0>
		<cfset item.setMedia(media) />
		<cfset item.setItemOrder(arrayLen(gallery.getItemArray()) + 1) />
		<cfset item.setParentGallery(gallery) />

		<cfset variables.orm.save(item) />
	</cfif>

</cffunction>



<!--- createPage --->
<cffunction name="createPage" returntype="component" access="public" output="false"
	displayname="Create Page" hint="I create a page object."
	description="I create a page object. I am a helper method that encapsulates all the rules for making a page, thats why I need the User ID.">
	
	<cfargument name="IDPage" type="numeric" required="true" 
		hint="I am the ID of the new page.<br />I am required.">
	<cfargument name="IDUser" type="string" required="true" 
		hint="I am the users ID.<br />I am required.">
	<cfargument name="defaultIDLayout" type="numeric" default="#variables.defaultIDLayout#" 
		hint="I am the ID of the default layout.<br />I default to a runtime variable." />
	
	<cfset var page = variables.orm.new("page.Page") />
	<cfset var gallery = variables.orm.new("gallery.Gallery") />
	<cfset var layout = getLayout(arguments.defaultIDLayout) />
	
	<!--- set the page properties and save --->
	<cfset page.setIDPage(arguments.IDPage) />
	<cfset page.setCreateDate(now()) />
	<cfset page.setParentUser(getUser(arguments.IDUser)) />
	
	<cfset variables.orm.save(page) />
	
	<!--- set the gallery's related objects, then save --->
	<cfset gallery.setParentPage(page) />
	<cfset gallery.setLayout(layout) />
	
	<cfset variables.orm.save(gallery) />
	
	<cfreturn page />
</cffunction>



<!--- deleteMedia --->
<cffunction name="deleteMedia" returntype="void" access="public" output="false"
	displayname="Delete Media" hint="I delete a media object."
	description="I delete a media object.">
	
	<cfargument name="media" type="component" required="true" 
		hint="I am the media object to delete.<br />I am required." />
	
	<!--- delete all the keywords, then the media object --->
	<cfset deleteMediaKeyWords(media) />
	<cfset variables.orm.delete(media) />
	
</cffunction>



<!--- getGallery --->
<cffunction name="getGallery" returntype="component" access="public" output="false"
	displayname="Get Gallery " hint="I return a gallery object."
description="I return a Gallery object. If not passed the ID fo the Gallery I will return the top Gallery in the Pages array of Galleries.">
	
	<cfargument name="IDPage" required="true" type="numeric" 
		hint="I am the CommonSpot page ID.<br />I am required." />
	<cfargument name="IDGallery" required="false" default="0" type="numeric" 
		hint="I am the CommonSpot page ID.<br />I default to '0'." />
	<cfargument name="galleryIndex" default="1" type="numeric" 
		hint="I am the index of a gallery to get for off a page object." />

	<cfset var page = 0 />	
	<cfset var gallery = 0 />
	<cfset var x = 0 />
	
	<cfset page = getPage(arguments.IDPage) />
	
	<!--- No ID passed so get the the top gallery from the array --->
	<cfif arguments.IDGallery eq 0>
		<cfset gallery = page.getGallery(arguments.galleryIndex) />
		
	<cfelse><!--- looop and get the top --->
		<cfloop array="#page.getGalleryArray()#" index="x">	
			<cfif x.getIDGallery() eq arguments.IDGallery>
				<cfset gallery = x />
				<cfbreak />
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn gallery />
</cffunction>



<!--- getLayout --->
<cffunction name="getLayout" returntype="component" access="public" output="false"
	displayname="Get Layout" hint="I return a Layout object by ID."
	description="I return a Layout object by ID.">
	
	<cfargument name="IDLayout" type="numeric" default="0" 
		hint="I am the ID of the Layout.<br />I default to '0'." />
	
	<cfreturn variables.orm.get("layout.Layout", arguments.IDLayout) />
</cffunction>



<!--- getMedia --->
<cffunction name="getMedia" returntype="component" access="public" output="false"
	displayname="Get Media" hint="I return a media object by ID."
	description="I return a media object by ID, or an new one if passed 0.">
	
	<cfargument name="IDMedia" type="any" required="false" default=""
		hint="I am the medias ID.<br />I default to an empty string."/>
	
	<cfset var query = 0 />
	<cfset var media = 0 />
	<cfset var _sql = 0 />
	
	<cfif isNumeric(arguments.IDMedia)>
		
		<!--- get the object --->
		<cfset media = variables.orm.get("media.Media", arguments.IDMedia) />
		
		<!--- tql query for its keywords, then set them--->
		<cfsavecontent variable="_sql">
			SELECT
				keyword.Keyword.IDMetadata as IDMetadata
			FROM
				keyword.Keyword
			JOIN
				media.Media
			WHERE 
				media.Media.IDMedia = :IDMedia
		</cfsavecontent>
		<cfset query = variables.orm.createQuery("#_sql#" ) />
		<cfset query.SetParam("IDMedia", arguments.IDMedia, "numeric") />
		<cfset query = variables.orm.listByQuery(query) />		
		
		<cfset media.setKeywordIDList(valuelist(query.IDMetadata)) />

	<cfelse><!--- give them an empty media object --->
		<cfset media = variables.orm.new("media.Media") />
		<cfset media.setKeywordIDList("") />
	</cfif>

	<cfreturn media />
</cffunction>



<!--- getPage --->
<cffunction name="getPage" returntype="component" access="public" output="false"
	displayname="Get Page" hint="I return a Page object by ID."
	description="I return a Page object by ID.<br />Throws error if the page is new and not passed a User object.">
	
	<cfargument name="IDPage" type="numeric" required="true" 
		hint="I am the page ID.<br />I am required." />
	<cfargument name="User" type="any" default="0" 
		hint="I am the user object who owns the page.<br />I default to '0'." />
	
	<cfset var page = variables.orm.get("page.Page", arguments.IDPage) />

	<!--- save it if ist new, only happens when authors are editing a page for the first time --->
	<cfif page.getIsPersisted() eq false>
		<cftry>
			<cfset page = createPage(IDPage = arguments.IDPage, IDUser = arguments.user.getIDUser()) />
			<cfcatch>
				<cfthrow message="Invlid condition to get a Page." detail="The Page object is new, and no User object was passed." />
			</cfcatch>
		</cftry>
	</cfif>
	
	<cfreturn page />
</cffunction>



<!--- getType --->
<cffunction name="getType" returntype="component" access="public" output="false"
	displayname="Get Type" hint="I return a type object by ID."
	description="I return a type object by ID.">
	
	<cfargument name="IDType" type="any" default="0" 
		hint="I am the Types ID.<br />I default to '0'."/>
	
	<cfif isNumeric(arguments.IDType)>
		<cfreturn variables.orm.get("type.Type", arguments.IDType) />
	<cfelse>
		<cfreturn variables.orm.new("type.Type") />
	</cfif>
</cffunction>



<!--- getUser --->
<cffunction name="getUser" returntype="any" access="public" output="false"
	displayname="Get User" hint="I return a user object.."
	description="I return a user object by the IDUser property..">
	
	<cfargument name="IDUser" type="string" default="" 
		hint="I am the ID of a User.<br />I default to an empty string.">
	
	<cfreturn variables.orm.get("user.User", arguments.IDUser) />
</cffunction>



<!--- listLayout --->
<cffunction name="listLayout" returntype="query" access="public" output="false"
	displayname="List Layout" hint="I return a query of avaiable layouts."
	description="I return a query of avaiable layouts.">
	
	<cfreturn variables.orm.list("layout.Layout") />
</cffunction>



<!--- listMedia --->
<cffunction name="listMedia" returntype="query" access="public" output="false"
	displayname="List Media" hint="I return a query of media."
	description="I return a query of media. I can fileter by type if pased the type.">
	
	<cfargument name="type" type="string" default="" 
		hint="I am the type to filter by. I default to an empty string." />
	<cfargument name="title" type="string" default="" 
		hint="I am the Title to filter by. I default to an empty string." />
	<cfargument name="searchString" type="string" default="" 
		hint="I am the 'search string' to fileter by. I default to an empty string." />
	
	<cfset var tql = "" />
	<cfset var query = 0 />
	
	 <!--- type --->
	<cfif len(arguments.type)>
		
		<cfsavecontent variable="tql">
			SELECT 
			media.Media.IDMedia as IDMedia,
			media.Media.FileName as fileName,
			media.Media.Title as title,
			media.Media.Avaiable as avaiable,
			
			type.Type.Name as Type
			
			FROM media.Media 
			JOIN type.Type
			
			WHERE type.Type.IDType = :IDType
		</cfsavecontent>
		<cfset query = variables.orm.createQuery("#tql#" ) />
		<cfset query.SetParam("IDType", arguments.type, "string") />
		<cfset query = variables.orm.listByQuery(query) />

	<!--- title --->
	<cfelseif len(arguments.title)>
		
		<cfsavecontent variable="tql">
			FROM media.Media	
			WHERE media.Media.Title like :filter
		</cfsavecontent>
		<cfset query = variables.orm.createQuery("#tql#" ) />
		<cfset query.SetParam("filter", "%#arguments.title#%") />
		<cfset query = variables.orm.listByQuery(query) />

	<!--- search title and description --->
	<cfelseif len(arguments.searchString)>		

		<cfsavecontent variable="tql">
			FROM media.Media
			WHERE 
			media.Media.Title like :filter 
			or 
			media.Media.description like :filter
		</cfsavecontent>
		<cfset query = variables.transfer.createQuery("#tql#" ) />
		<cfset query.SetParam("filter", "%#arguments.searchString#%") />
		<cfset query = variables.orm.listByQuery(query) />
	</cfif>
	
	<!--- last resourt! --->
	<cfif isSimpleValue(query)>
		
		<cfsavecontent variable="tql">
		SELECT 
			media.Media.IDMedia as IDMedia,
			media.Media.FileName as fileName,
			media.Media.Title as title,
			media.Media.Avaiable as avaiable,
			
			type.Type.Name as Type
			
		FROM media.Media 
		JOIN type.Type
		</cfsavecontent>
		
		<cfset query = variables.orm.createQuery("#tql#" ) />
		<cfset query = variables.orm.listByQuery(query) />
	</cfif>
	
	<cfreturn query />
</cffunction>



<!--- listType --->
<cffunction name="listType" returntype="query" access="public" output="false"
	displayname="List Type" hint="I return a query of types."
	description="I return a query of query of types.">
	
	<cfreturn variables.orm.list("type.Type") />
</cffunction>



<!--- listUserMedia --->
<cffunction name="listUserMedia" returntype="query" access="public" output="false"
	displayname="List User Media" hint="I return a query of a users media."
	description="I return a query of a users media.">
	
	<cfargument name="IDUser" type="any" default="" 
		hint="I am the user object. I default to an empty string." />
	
	<cfset var tql = "" />
	<cfset var query = 0 />
	
	<cfsavecontent variable="tql">
		SELECT 
			media.Media.IDMedia as IDMedia,
			media.Media.FileName as fileName,
			media.Media.Title as title,
			
			type.Type.Name as Type,
			type.Type.IDType as IDType
			
		FROM media.Media 
		
		JOIN user.User
		JOIN type.Type
		
		WHERE user.User.IDUser = :IDUser
	</cfsavecontent>
	
	<cfset query = variables.orm.createQuery("#tql#" ) />
	<cfset query.SetParam("IDUser", arguments.IDUser) />
	<cfset query = variables.orm.listByQuery(query) />
	
	<cfreturn query />
</cffunction>



<!--- updateGallery --->
<cffunction name="updateGallery" returntype="void" access="public" output="false"
	displayname="Update Gallery" hint="I save a Galleries Items."
	description="I save a Galleries Items.">
	
	<cfargument name="gallery" type="any" required="true"
		hint="I am the gallery bean object.<br />I am required." />
	
	<cfset var x = 0 />
	<cfset var y = 0 />
	<cfset var item = 0 />
	<cfset var count = 1 />

	<!--- delete trashed items --->
	<cfloop list="#gallery.getGalleryTrash()#" index="y">		

		<cfset item = variables.orm.get("gallery.Item", "#y#") />
		<cfset variables.orm.delete(item) />
	</cfloop>	
	
	<!--- update the order and save each item  --->
	<cfloop list="#gallery.getGalleryItems()#" index="x">		

		<cfset item = variables.orm.get("gallery.Item", "#x#") />
		<cfset item.setItemOrder(count) />
		
		<cfset orm.save(item) />
		
		<cfset count = count + 1 />
	</cfloop>	

</cffunction>



<!--- updateMedia --->
<cffunction name="updateMedia" returntype="void" access="public" output="false"
	displayname="Update Media" hint="I update or save a media object."
	description="I supdate or ave a Media object by using the orm.">
	
	<cfargument name="media" type="any" required="true" 
		hint="I am the media object.<br />I am required." />
	<cfargument name="user" type="any" required="true" 
		hint="I am the user object.<br />I am required." />

	<cfif arguments.media.getIsPersisted() eq false>
		<cfset arguments.media.setParentType(getType(arguments.Media.getIDType())) />
		<cfset arguments.media.setParentUser(getUser(arguments.user.getIDUser())) />
		<cfset arguments.media.setCreateDate(now()) />
	</cfif>
	
	<!--- set the updatedate and save --->
	<cfset arguments.media.setModifyDate(now()) />
	<cfset variables.orm.save(arguments.media) />
	
	<!--- this will persist the keywords --->
	<cfset arguments.media = updateKeywords(media = arguments.media)>
	
</cffunction>



<!--- updatePageChildren --->
<cffunction name="updatePageChildren" returntype="void" access="public" output="false"
	displayname="Update Page Children" hint="I update a Pages child object."
	description="I update a Page objects children objects.">
	
	<cfargument name="Gallery" type="component" required="true"
		hint="I am the ID of the IDGallery to assign a new Layout to.<br />I am required." />
	<cfargument name="IDLayout" type="numeric" required="true"
		hint="I am the ID of the newlly assigned Layout.<br />I am required." />

	<cfset var layout = 0 />
	
	<!--- if a new layout is being applied --->
	<cfif arguments.IDLayout neq 0>
		
		<!--- 
			TODO: we are going to need some logic that kills a the allready gallery
			items when we are going from a multi to a single element type gallery.
			
			Maybe we should create a gallery roll back object and let the user 
			roll back 1 time?
			
			Ask around about how we should handle.
			
			<cfif listContains(getSingleItemGalleryTypes(), arguments.IDLayout)>
				<cfset gallery.clearItems(???? whats the transfer method???) />
			</cfif>
			
			getSingleItemGalleryTypes() is a new method that querys and returns 
			a value list
		 --->
		
		<cfset layout = variables.getLayout(arguments.IDLayout) />
		<cfset arguments.gallery.setLayout(layout) />
	</cfif>
	
	<!--- set the update date and save --->
	<cfset arguments.gallery.setUpdateDate(now()) />
	<cfset variables.orm.save(arguments.gallery) />
	
</cffunction>



<!--- updateUser --->
<cffunction name="updateUser" returntype="void" access="public" output="false"
	displayname="Update User" hint="I update a user."
	description="I use the ORM to update/save users.">
	
	<cfargument name="user" type="component" required="true" 
		hint="I am the applications 'user' object.<br />I am required." />
	
	<cfset var userTO = getUser(IDUser = arguments.user.getIDUser()) />
	
	<!--- save if new --->
	<cfif userTO.getIsPersisted() eq false>
		<cfset userTO.setIDUser(arguments.user.getIDUser()) />
		<cfset variables.orm.save(userTO) />
	</cfif>
	
	<!--- set the last logged in, then update --->
	<cfset userTO.setLastLoggedIn(now()) />
	<cfset variables.orm.save(userTO) />
	
</cffunction>


<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- updateKeywords --->
<cffunction name="updateKeywords" returntype="any" access="private" output="false"
	displayname="Update Keywords" hint="I update a media objects keyword values."
	description="I update a media objects keyword values.">
	
	<cfargument name="media" type="any" required="true" 
		hint="I am the media object.<br />I a requried." />
	
	<cfset var keyword = 0 />
	<cfset var keywordIDList = "" />
	<cfset var x = 0 />
	
	<cfif len(arguments.media.getKeywordIDList())>
		
		<!--- delete all the keywords --->
		<cfset deleteMediaKeyWords(media)>
				
		<!--- create new ones and save --->
		<cfloop list="#arguments.media.getKeywordIDList()#" index="x">	
			<cfif x neq 0>	
				<cfset keyword = variables.orm.new("keyword.Keyword") />
				<cfset keyword.setIDMetadata(x) />
				<cfset keyword.setParentMedia(arguments.media) />
				<cfset variables.orm.save(keyword) />
			</cfif>
		</cfloop>		
	</cfif>
	
	<cfreturn arguments.media />	
</cffunction>



<!--- deleteMediaKeyWords --->
<cffunction name="deleteMediaKeyWords" returntype="void" access="private" output="false"
	displayname="Delete Media Keywords" hint="I delete a media objects keywords."
	description="I delete a media objecte keywords.">
	
	<cfargument name="media" type="any" required="true" 
		hint="I am the media object.<br />I a requried." />
	
	<cfset var oldIDList = "" />
	<cfset var keyword = 0 />
	<cfset var x = 0 />
	<cfset var y = 0 />
	
	<cfif len(arguments.media.getKeywordIDList())>
		<!--- make a list of ids to delete --->
		<cfloop from="1" to="#arrayLen(media.getKeywordArray())#" index="x">
			<cfset oldIDList = listAppend(oldIDList, media.getKeyword(x).getIDLocal()) />
		</cfloop>	
	
		<!--- delete the objects  --->
		<cfloop list="#oldIDList#" index="y">
			<cfset keyword = variables.orm.get("keyword.Keyword", y) />
			<cfset variables.orm.delete(keyword) />	
		</cfloop>
	</cfif>
</cffunction>


<!--- **************************** OLD NOT USED **************************** 
<!--- makeItemsQuery --->
<cffunction name="makeItemsQuery" returntype="query" access="public" output="false"
	displayname="Make Items Query" hint="I take an array of items and change them to a query."
	description="I take an array of items and change them to a query.">
	
	<cfargument name="gallery">
	
	<cfset var mediaQuery = queryNew("createDate,Description,FileName,IDMedia,IconFileName,ModifyDate,PreviewFileName,SystemLocation,Title,") />
	<cfset var tempItem = 0 />
	<cfset var newRow =  0 />
	<cfset var tempRow =  0 />
	<cfset var x = 0 />
	
	<cfloop array="#arguments.gallery#" index="x">
		<cfset tempItem = x.getLoadedObject().getMedia().getLoadedObject() />
		
		<cfif tempItem.getAvaiable() eq 1>
			
			<cfset newRow = QueryAddRow(mediaQuery, 1) />
		
			<cfset tempRow = QuerySetCell(mediaQuery, "createDate", tempItem.getCreateDate()) />
			<cfset tempRow = QuerySetCell(mediaQuery, "Description", tempItem.getDescription()) />
			<cfset tempRow = QuerySetCell(mediaQuery, "FileName", tempItem.getFileName()) />
			<cfset tempRow = QuerySetCell(mediaQuery, "IDMedia", tempItem.getIDMedia()) />
			<cfset tempRow = QuerySetCell(mediaQuery, "IconFileName", tempItem.getIconFileName()) />
			<cfset tempRow = QuerySetCell(mediaQuery, "IconFileName", tempItem.getModifyDate()) />
			<cfset tempRow = QuerySetCell(mediaQuery, "PreviewFileName", tempItem.getPreviewFileName()) />
			<cfset tempRow = QuerySetCell(mediaQuery, "SystemLocation", tempItem.getSystemLocation()) />
			<cfset tempRow = QuerySetCell(mediaQuery, "Title", tempItem.getTitle()) />
		</cfif>
	</cfloop>

	<cfreturn mediaQuery  />
</cffunction>


<!--- listGalleryItems --->
<cffunction name="listGalleryItems" returntype="query" access="public" output="false"
	displayname="List Gallery Items" hint="I retrurn a query of a Galley's Items."
	description="I retrurn a query of a Galley's Items.">
		
	<cfargument name="IDPage" type="numeric" required="false" 
		hint="I am the CommonSpot page ID.<br />I defalut to '0'." />
	<cfargument name="galleryIndex" type="numeric" default="1" required="false" 
		hint="I am the ID of the gallery.<br />I default to '1'." />
	
	<cfset var tql = "" />
	<cfset var query = 0 />
	<cfset var gallery = 0 />	
	
	<cfset gallery = variables.orm.get("page.Page", arguments.IDPage).getGallery(arguments.galleryIndex) />
	
	<cfsavecontent variable="tql">
		SELECT 
			gallery.Item.ItemOrder,
			gallery.Item.IDItem,
			media.Media.IDMedia,
			media.Media.Title,
			media.Media.Description,
			media.Media.IconFileName as IconFileName,
			media.Media.PreviewFileName as PreviewFileName,
			media.Media.FileName as FileName
			
		FROM gallery.Item
		
		JOIN media.Media
	
		ORDER BY gallery.Item.ItemOrder asc
		
		WHERE gallery.Gallery.IDGallery = :IDGallery
	</cfsavecontent>
	
	<cfset query = variables.orm.createQuery("#tql#" ) />
	<cfset query.SetParam("IDGallery", gallery.getIDGallery()) />
	<cfset query = variables.orm.listByQuery(query) />
	
	<cfreturn query />
</cffunction>
 --->
</cfcomponent>