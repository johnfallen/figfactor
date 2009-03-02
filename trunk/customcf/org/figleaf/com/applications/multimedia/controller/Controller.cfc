<cfcomponent output="false" hint="I am a Model-Glue controller."
	extends="ModelGlue.gesture.controller.Controller" beans="MultiMedia,Config">

<!--- init --->
<cffunction name="init" access="public" output="false" hint="Constructor">
	
	<cfreturn this />
</cffunction>



<!--- onRequestStart --->
<cffunction name="onRequestStart" access="public" returnType="void" output="false">
	<cfargument name="event" type="any" />
	
	<!--- check if the user has a session, if not create it --->
	<cfif isSimpleValue(beans.MultiMedia.getUserSession())>
		<cfset createSession(arguments.event) />
	</cfif>

</cffunction>



<!---  addMediaToGallery --->
<cffunction name="addMediaToGallery" output="false">
	<cfargument name="event" type="any" />
	
	<cfset var newIDMedia = arguments.event.getValue("newIDMedia") />
	<cfset var IDGallery = arguments.event.getValue("IDGallery")>

	<cfset beans.MultiMedia.addMediaToGallery(
		IDMedia = newIDMedia,
		IDGallery = IDGallery)>
</cffunction>



<!---  createSession --->
<cffunction name="createSession" output="false">
	<cfargument name="event" type="any" />

	<cfset var IDPage = arguments.event.getValue("IDPage") />
	<cfset var IDUser = arguments.event.getValue("IDUser") />
	<cfset var galleryindex = arguments.event.getValue("galleryIndex") />
	<cfset var userType = arguments.event.getValue("userType") />
	
	<cfif not len(userType)>
		<cfset userType = "user" />
	</cfif>
	
	<!--- if the values are present, then its real, else in development --->
	<cfif isNumeric(IDPage) and len(IDUser)>
		
		<cfif not isNumeric(galleryIndex)>
			<cfset galleryIndex =1 />
		</cfif>
		
		<cfset beans.MultiMedia.createSession(
			IDUser = IDUser, 
			IDPage = IDPage, 
			galleryIndex = galleryIndex,
			userType = userType) />
		<!--- <cfelse>development user 
		<cfset beans.MultiMedia.createSession(IDUser = "johnallen", IDPage = 1526, galleryIndex = 1) />
		<!--- test pageids --->
		<!--- 5644, 1234, 69, 2 --->	
		--->
	</cfif>
</cffunction>



<!---  deleteMedia --->
<cffunction name="deleteMedia" output="false">
	<cfargument name="event" type="any" />
	
	<cfset beans.multiMedia.deleteMedia(arguments.event.getValue("IDMedia")) />
	
</cffunction>



<!---  editMedia --->
<cffunction name="editMedia" output="false">
	<cfargument name="event" type="any" />
	
	<!--- deal with a data grid request --->
	<cfif len(arguments.event.getValue("CFGridKey"))>
		<!--- the IDMedia is the fist list item, IDType is the second --->
		<cfset arguments.event.setValue("IDMedia", listGetAt(arguments.event.getValue("CFGridKey"), 1)) />
		<cfset arguments.event.setValue("IDType", listGetAt(arguments.event.getValue("CFGridKey"), 2)) />
	</cfif>
	
	<!--- if they passed a IDType add it to the event object --->
	<cfif len(arguments.event.getValue("IDType"))>
		<cfset arguments.event.setValue("type", beans.MultiMedia.getType(arguments.event.getValue("IDType"))) />
	</cfif>
	<cfset arguments.event.setValue("media", beans.MultiMedia.getMedia(arguments.event.getValue("IDMedia"))) />
</cffunction>



<!---  getMedia --->
<cffunction name="getMedia" output="false">
	<cfargument name="event" type="any" />

	<cfset arguments.event.setValue("media", beans.MultiMedia.getMedia(
		IDMedia = arguments.event.getValue("IDMedia"))) />
</cffunction>



<!--- updateGallery --->
<cffunction name="updateGallery" output="false">
	<cfargument name="event" type="any" />
	
	<cfset var gallery = beans.Multimedia.getGalleryBean() />
	
	<cfset gallery = arguments.event.makeEventBean(gallery) />
	
	<cfset beans.Multimedia.updateGallery(gallery)>

</cffunction>



<!---  updateMedia --->
<cffunction name="updateMedia" output="false">
	<cfargument name="event" type="any" />

	<cfset var x = "" />
	<cfset var input = structNew() />
	<cfset var media = beans.multiMedia.getMedia(arguments.event.getValue("IDMedia")) />
	<cfset var properties = event.getAllValues() />
	
	<!--- populate the media object --->
	<cfset media = arguments.event.makeEventBean(media) />
	
	<!--- find and set the properties form the view into a struct called input --->
	<cfloop collection="#properties#" item="x">
		<cfif x contains "property_">
			<!--- create the key value pairs and add them to the values struct --->	
			<cfset key = replace(x, "PROPERTY_", "")>
			<cfset key = replace(key, "property_", "")>
			<cfset value = form[x] />
			<cfset input[key] = XMLFormat(value) />
		</cfif>
	</cfloop>
	
	<!--- set the media objects xml property with the input --->
	<cfset media.setMediaPropertyXML(input)>
	
	<cfset beans.MultiMedia.updateMedia(media) />

</cffunction>



<!---  updatePageChildren - maybe should be updatePage??? --->
<cffunction name="updatePageChildren" output="false">
	<cfargument name="event" type="any" />
	
	<cfset var page = beans.Multimedia.getPage(IDPage = arguments.event.getValue("IDPage")) />
	<cfset var gallery = page.getGallery(arguments.event.getValue("GalleryIndex")).getLoadedObject() />
	<cfset var IDLayout = arguments.event.getValue("IDLayout") />	
	
	<cfset gallery = arguments.event.makeEventBean(gallery) />

	<cfset beans.Multimedia.updatePageChildren(
		gallery = gallery, 
		IDLayout = IDLayout) />
	
</cffunction>



<!--- onQueueComplete --->
<cffunction name="onQueueComplete" access="public" returnType="void" output="false">
	<cfargument name="event" type="any" />
	
	<!--- set all this data for each event --->
	<cfset arguments.event.setValue("user", beans.multimedia.getUser(IDUser = beans.multimedia.getUserSession().getIDUser())) />
	<cfset arguments.event.setValue("userSessionObject", beans.multimedia.getUserSession()) />
	<cfset arguments.event.setValue("parentConfig", application.beanfactory.getBean("config")) />
	<cfset arguments.event.setValue("page", beans.multimedia.getPage(IDPage = beans.multimedia.getUserSession().getCurrentIDPage())) />
	<cfset arguments.event.setValue("GalleryIndex", beans.multimedia.getUserSession().getCurrentGalleryIndex()) />
	<cfset arguments.event.setValue("rb", beans.multimedia.getUserSession().getRB()) />
	<cfset arguments.event.setValue("types", beans.multimedia.listType()) />
	<cfset arguments.event.setValue("layouts", beans.multimedia.listLayout()) />
	<cfset arguments.event.setValue("config", beans.config) />
</cffunction>



<!--- onRequestEnd --->
<cffunction name="onRequestEnd" access="public" returnType="void" output="false">
	<cfargument name="event" type="any" />
</cffunction>
</cfcomponent>