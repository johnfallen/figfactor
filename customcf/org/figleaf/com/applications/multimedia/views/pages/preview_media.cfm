<cfsilent>
	<!--- objects/data --->
	<cfset user = event.getValue("user") />
	<cfset userSession = event.getValue("userSessionObject") />
	<cfset page = event.getValue("page") />
	<cfset rb = event.getValue("rb") />
	<cfset config = event.getValue("config") />
	<cfset layouts = event.getValue("layouts") />
	<cfset GalleryIndex = event.getValue("GalleryIndex") />
	<cfset gallery = page.getGallery(GalleryIndex) />
	<cfset layout = gallery.getLayout() />
	<cfset IDPage = page.getIDPage() />
	
	<cftry>
	
		<!--- figure out what the medias parent type is or if it even has any --->
		<cfif gallery.getLayout().getIsMixedMedia()>
			<cfset currentIDType = "" />
		<cfelse>
			<cfif arrayLen(gallery.getItemArray()) gt 0>
				<cfset currentIDType = gallery.getItem(1).getMedia().getParentType().getIDType() />
			<cfelse>
				<cfset currentIDType = config.getDefaultIDType() />
			</cfif>
		</cfif>
	
		<cfcatch>
			<cfset currentIDType = config.getDefaultIDType() />
		</cfcatch>
	</cftry>
		
	<!--- links --->
	<cfset myself = event.getValue("myself") />
	<cfset xe.browseMedia = event.getValue("xe.borwseMedia") />
	<cfset xe.savePage = event.getValue("xe.savePage") />
	
	<!--- required by the custom tag --->
	<cfset AjaxFacadePath = config.getApplicationComponentPath() />
</cfsilent>
<cfoutput>


<!--- save page form --->
<cfform 
	action="#myself##xe.savePage#" 
	method="post" 
	name="savePageFrom"
	class="public-form">

	<input type="hidden" name="IDPage" id="IDPage" value="#IDPage#" />
	<input type="hidden" name="IDType" id="IDType" value="#currentIDType#" />
	<input type="hidden" name="IDGallery" id="IDGallery" value="#gallery.getIDGallery()#" />
	<input type="hidden" name="GalleryIndex" id="GalleryIndex" value="#GalleryIndex#" />

	<table width="100%">
		<tr valign="top">
			<td width="45%">
				
				#rb.getResource("GalleryName")#:<br />
				<input type="text" name="name" value="#gallery.getName()#" /><br />
				
				#rb.getResource("Layout")#:
				<select name="IDLayout" id="IDLayout">
					<cfloop query="layouts">
						<cfif layouts.Avaiable eq 1
								or userSession.getUserType() eq "manager">
						<option value="#layouts.IDLayout#"<cfif layouts.IDLayout eq gallery.getLayOut().getIDLayout()>
								selected 
								class="select-list-current"</cfif> >#name#
						</option>
						</cfif>
					</cfloop>
				</select>
				
				<center>
					<input 
						type="submit" 
						name="savePageButton" 
						id="savePageButton" 
						value="#rb.getResource('Save')#" />
				</center>
				
			</td>
			<td>

				#rb.getResource("description")#:
				<cftextarea 
					name="description" 
					id="description" 
					richtext="true" 
					height="100"
					width="380">

					#gallery.getDescription()#
				</cftextarea>
				
				<!--- I make the FCKeditor super small --->
				<script type="text/javascript">
					function FCKeditor_OnComplete(editorInstance){
					 	editorInstance.Config["ToolbarSets"]["BasicMin"] = [
						 ['Bold','Italic','Underline']
						 ];
						editorInstance.EditorWindow.parent.FCK.ToolbarSet.Load('BasicMin' ) ;
					}
				</script>
			</td>
		</tr>
	</table>
</cfform>
<hr />

<center>
	<cf_custom_tag_mediaoutput 
		IDPage = "#IDPage#" 
		GalleryIndex = "#GalleryIndex#"
		facadePath = "#AjaxFacadePath#"/>
</center>
</cfoutput>