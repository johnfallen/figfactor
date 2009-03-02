<cfsilent>
	<!--- objects/data --->
	<cfset user = event.getValue("user") />
	<cfset page = event.getValue("page") />
	<cfset rb = event.getValue("rb") />
	<cfset galleryIndex = event.getValue("galleryIndex") />
	<cfset config = application.beanFactory.getBean("config") />
	<cfset myself1 = config.getFigleafFileContext() & "/com/applications/multimedia/" />

	<!--- links --->
	<cfset myself = myself1 & event.getValue("myself") />
	<cfset xe.previewPage = event.getValue("xe.previewPage") />
	<cfset xe.browseMedia = event.getValue("xe.browseMedia") />
</cfsilent>
<cfoutput>

<!--- If there is more than one gallery on the page --->
<cfif arrayLen(page.getGalleryArray()) gt 1>
	<cfloop from="1" to="#arrayLen(page.getGalleryArray())#" index="x">
		<a href="#myself##xe.previewPage#&galleryIndex=#x#">
			#rb.getResource("ClickHereToManageGallery")#&nbsp;#page.getGallery(x).getName()#
		</a>
	</cfloop>
<cfelse>
	<!--- if there are any items in the gallery --->
	<cfif arrayLen(page.getGallery(galleryIndex).getItemArray()) gt 0>
		<a href="#myself##xe.previewPage#">#rb.getResource("ClickHereToManageThePagesMultiMedia")#</a>
	<cfelse>
		<a href="#myself##xe.browseMedia#">#rb.getResource("ClickHereToManageThePagesMultiMedia")#</a>
	</cfif>
</cfif>
<!---
TODO: code these conditions 
<h3>Conditions:</h3>
<ul>
	<li>add new gallery to page with an exsisting gallery</li>
	<li>edit single gallery for page</li>
	<li>no gallery</li>
	<li>reuse another gallery as starting point</li>
	<li>choose gallery to edit</li>
</ul>
 --->
</cfoutput>