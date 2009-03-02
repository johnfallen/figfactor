<cfoutput>
<cftry>	
	<cfset request.multimedia = application.beanfactory.getBean("multimedia") />

	<cf_custom_tag_mediaoutput 
		IDPage = "#request.page.id#" 
		GalleryIndex = "1"/>
	<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>
</cfoutput>