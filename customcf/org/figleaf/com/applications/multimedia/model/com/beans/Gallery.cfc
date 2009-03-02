<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			Gallery.cfc
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am a simple bean to transport a gallery
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		03/12/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Gallery" output="false"
	hint="I am a simple bean to transport a gallery">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Gallery" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfset variables.instance = structNew() />

	<cfreturn this />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="any" access="public" output="false"
	displayname="Get Instance" hint="I retrun my internal instace scope."
	description="I retrun my internal instace scope.">
	
	<cfreturn variables.instance />
</cffunction>


<!--- IDGallery --->
<cffunction name="setIDGallery" output="false" access="public"
	hint="I set the IDGallery property.">
	<cfargument name="IDGallery" type="string" />
	<cfset variables.instance.IDGallery = arguments.IDGallery />
</cffunction>
<cffunction name="getIDGallery" output="false" access="public"
	hint="I return the IDGallery property.">
	<cfreturn variables.instance.IDGallery />
</cffunction>


<!--- galleryTrash --->
<cffunction name="setGalleryTrash" output="false" access="public"
	hint="I set the galleryTrash property.">
	<cfargument name="galleryTrash" type="string" />
	<cfset variables.instance.galleryTrash = arguments.galleryTrash />
</cffunction>
<cffunction name="getGalleryTrash" output="false" access="public"
	hint="I return the galleryTrash property.">
	<cfreturn variables.instance.galleryTrash />
</cffunction>


<!--- galleryItems --->
<cffunction name="setGalleryItems" output="false" access="public"
	hint="I set the galleryItems property.">
	<cfargument name="galleryItems" type="string" />
	<cfset variables.instance.galleryItems = arguments.galleryItems />
</cffunction>
<cffunction name="getGalleryItems" output="false" access="public"
	hint="I return the galleryItems property.">
	<cfreturn variables.instance.galleryItems />
</cffunction>
<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>