<cfsilent>
	<cfset user = viewState.getValue("user") />
	<cfset userSessionObject = viewState.getValue("userSessionObject") />
	<cfset rb = viewState.getValue("rb") />
	<cfset myself = viewState.getValue("myself") />
	<cfset page = viewState.getValue("page") />
	<cfset IDPage = page.getIDPage() />
	<cfset IDUser = user.getIDUser() />
	<cfset xe.previewPage = viewState.getValue("xe.previewPage") />
	<cfset xe.browseMedia = viewState.getValue("xe.browseMedia") />
	<cfset xe.galleryOrder = viewState.getValue("xe.galleryOrder")/>
	<cfset xe.manageMedia = viewState.getValue("xe.manageMedia") />
</cfsilent>
<cfoutput>
<div id="mm_admin_headerLinks">
	<a href="#myself##xe.previewPage#&IDUser=#IDUser#&IDPage=#IDPage#">#rb.getResource("GallerySlashPreview")#</a>
	<cfif page.getIsPersisted()>
		<a href="#myself##xe.browseMedia#&IDUser=#IDUser#&IDPage=#IDPage#">#rb.getResource("SelectMedia")#</a>
		<cfif arrayLen(page.getGalleryArray())><a href="#myself##xe.galleryOrder#&IDUser=#IDUser#&IDPage=#IDPage#">#rb.getResource("GalleryOrder")#</a></cfif>
		<!--- only display if the session object is marked with 'manager' --->
		<cfif userSessionObject.getUserType() eq "manager">
			<a href="#myself##xe.manageMedia#&IDUser=#IDUser#&IDPage=#IDPage#">#rb.getResource("ManageMedia")#</a>
		</cfif>
	</cfif>
</div>
</cfoutput>
