<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			Multimedia.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am the Multimeida API
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		02/01/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Multimedia" output="false"
	hint="I am the Multimeida API.">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Multimedia" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="UserService" type="component" required="true" 
		hint="I am the UserService.<br />I am required." />
	<cfargument name="gateway" type="component" required="true" 
		hint="I am the Gateway.<br />I am required." />
	<cfargument name="MediaManager" type="component" required="true" 
		hint="I am the MediaConverter.<br />I am required." />

	<cfset variables.gateway = arguments.gateway />
	<cfset variables.UserService = arguments.UserService />
	<cfset variables.MediaManager = arguments.MediaManager />

	<cfreturn this />
</cffunction>



<!--- addMediaToGallery --->
<cffunction name="addMediaToGallery" returntype="void" access="public" output="false"
	displayname="Add Meida To Gallery" hint="I add an Item to a users gallery."
	description="I add an Item to a users gallery.">
	
	<cfargument name="IDMedia" type="string" required="true" 
		hint="I am the ID of the Gallery.<br />I am required" />
	<cfargument name="IDGallery" type="string" required="true" 
		hint="I am the ID of the Gallery.<br />I am required" />	

	<cfset variables.gateway.addMediaToGallery(argumentCollection = arguments) />

</cffunction>



<!--- createSession --->
<cffunction name="createSession" returntype="void" access="public" output="false"
	displayname="Create Session" hint="I create an 'Authors' session."
	description="I create an 'Authors' session.">
	
	<cfargument name="IDUser" type="string" required="true" 
		hint="I am the CommonSpot User ID.<br />I am required." />
	<cfargument name="IDPage" type="numeric" required="false" 
		hint="I am the ID of the page." />
	<cfargument name="GalleryIndex" type="numeric" required="false" 
		hint="I am the index of the gallery that is currently being edited." />
	<cfargument name="type" type="numeric" required="false" 
		hint="I am the type of user logging into the application.<br />Currently not used." />
	
	<cfset variables.UserService.createSession(argumentCollection = arguments) />
</cffunction>



<!--- deleteMedia --->
<cffunction name="deleteMedia" returntype="void" access="public" output="false"
	displayname="Delete Media" hint="I delete media objects."
	description="I delete media objects and all their associated files.">
	
	<cfargument name="IDMedia" type="numeric" required="true" 
		hint="I am the medias ID.<br />I default to '0'."/>
	
	<cfset var media = getMedia(arguments.IDMedia) />
	
	<!--- delete the files, then the record --->
	<cfset variables.MediaManager.deleteMedia(media) />
	<cfset variables.gateway.deleteMedia(media) />
	
</cffunction>



<!--- getGallery --->
<cffunction name="getGallery" returntype="component" access="public" output="false"
	displayname="Get Gallery" hint="I return a gallery object."
	description="I return a gallery object. Pass the IDPage Ill refrence that and try to get it by the 'galleryIndex' argument. Pass me the IDGallery and I'll return it by ID.">
	
	<cfargument name="IDPage" type="numeric" required="true" 
		hint="I am the ID of the page.<br />I am required." />
	<cfargument name="IDGallery" type="numeric" default="0" 
		hint="I am the ID of the page.<br />I default to 0." />
	<cfargument name="gallerIndex" default="1" type="numeric" 
		hint="I am the index of a gallery to get for off a page object.<br />I default to 1." />
	
	<cfreturn variables.gateway.getGallery(argumentCollection = arguments) />
</cffunction>



<!--- getGalleryBean --->
<cffunction name="getGalleryBean" returntype="any" access="public" output="false"
	displayname="Get Gallery Bean" hint="I return a simple bean for galleries."
	description="I return a simple bean for galleries.">
	
	<cfreturn  createObject("component", "com.beans.Gallery").init() />
</cffunction>



<!--- getPage --->
<cffunction name="getPage" returntype="any" access="public" output="false"
	displayname="Get Page" hint="I return a page object."
	description="I return an Page object by ID.">
	
	<cfargument name="IDPage" type="numeric" default="0" 
		hint="I am the ID of the page.<br />I default to 0." />
	<cfargument name="User" type="any" default="#getUserSession()#" 
		hint="I am the user object who owns the page.<br />I to a runtime expression getUserSession()." />
	
	<cfreturn variables.gateway.getPage(argumentCollection = arguments) />
</cffunction>



<!--- getMedia --->
<cffunction name="getMedia" returntype="any" access="public" output="false"
	displayname="Get Media" hint="I return a media object by id."
	description="I return a media object by id.">
		
	<cfargument name="IDMedia" type="any" default="0" 
		hint="I am the medias ID.<br />I default to '0'."/>
	
	<cfreturn variables.gateway.getMedia(argumentCollection = arguments) />
</cffunction>



<!--- getType --->
<cffunction name="getType" returntype="component" access="public" output="false"
	displayname="Get Type" hint="I return a type object by ID."
	description="I return a type object by ID.">
	
	<cfargument name="IDType" type="any" default="0" 
		hint="I am the Types ID.<br />I default to '0'."/>
	
	<cfreturn variables.gateway.getType(argumentCollection = arguments) />
</cffunction>



<!--- getUser --->
<cffunction name="getUser" returntype="component" access="public" output="false"
	displayname="Get User" hint="I return a User object from the Gateway."
	description="I return a User object from the Gateway.">
	
	<cfargument name="IDUser" type="string" default="0" 
		hint="I am the user ID.<br />I default to the session objects ID." />
	
	<cfreturn variables.gateway.getUser(arguments.IDUser) />
</cffunction>



<!--- getUserSession --->
<cffunction name="getUserSession" returntype="any" access="public" output="false"
	displayname="Get User" hint="I return the users session object."
	description="I return the Users session object, different from a User object from the database. Used for session persistance.">
	
	<cfreturn variables.UserService.getUser() />
</cffunction>



<!--- listMedia --->
<cffunction name="listMedia" returntype="query" access="public" output="false"
	displayname="List Media" hint="I return a result set of media."
	description="I return a result set of media. I can filter by type if passed the argument.">
	
	<cfargument name="type" type="string" default="" 
		hint="I am the Type of media to filter by. I default to an empty string."  />	
	<cfargument name="Title" type="string" required="false" default=""
		hint="I am the Title of media to filter by. I default to an empty string." />
	<cfargument name="searchString" type="string" required="false" default=""
		hint="I am the 'searchString'  to filter by. I default to an empty string." />
	
	<cfreturn variables.gateway.listMedia(argumentCollection = arguments) />
</cffunction>



<!--- listLayout --->
<cffunction name="listLayout" returntype="query" access="public" output="false"
	displayname="List Layout" hint="I return a query of avaiable Layouts."
	description="I return a query of avaiable Layouts.">
	
	<cfreturn variables.gateway.listLayout() />
</cffunction>



<!--- listType --->
<cffunction name="listType" returntype="query" access="public" output="false"
	displayname="List Type" hint="I return a record set of Types."
	description="I return a record set of Types.">
	
	<cfreturn variables.gateway.listType() />
</cffunction>



<!--- updateGallery --->
<cffunction name="updateGallery" returntype="void" access="public" output="false"
	displayname="Update Gallery" hint="I save a Galleries Items."
	description="I save a Galleries Items">
	
	<cfargument name="gallery" type="any" required="true"
		hint="I am the gallery bean object.<br />I am required." />
	
	<cfset variables.gateway.updateGallery(arguments.gallery) />
</cffunction>



<!--- updateMedia --->
<cffunction name="updateMedia" returntype="void" access="public" output="false"
	displayname="Update Media" hint="I save or update a media object."
	description="I save or update a media object.">

	<cfargument name="media" type="component" required="true" 
		hint="I am the media object to save.<br />I am required" />

	<cfset variables.MediaManager.convertMedia(arguments.media) />

	<cfset variables.gateway.updateMedia(
		media = arguments.media,
		user = getUserSession()) />
</cffunction>



<!--- updatePageChildren --->
<cffunction name="updatePageChildren" returntype="void" access="public" output="false"
	displayname="Update Page Children" hint="I update a Pages child objects."
	description="I update a Pages child objects and return the updated Page.">

	<cfargument name="gallery" type="component" required="true" 
		hint="I am the Gallery object being edited.<br />I am required." />
	<cfargument name="IDLayout" type="numeric" default="0"
		hint="I am the ID of the newlly assigned Layout.<br />I default to '0'." />
	
	<cfset variables.gateway.updatePageChildren(argumentCollection = arguments) />
</cffunction>
<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>