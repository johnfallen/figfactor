<cfsilent>
	<!--- objects/data --->
	<cfset page = event.getValue("page") />
	<cfset gallery = page.getGallery(event.getValue("GalleryIndex")) />
	<cfset rb = event.getValue("rb") />
	<cfset config = event.getValue("config") />
	<cfset iconPath = config.getImageStorageIconPath() />
	<cfset jspath = config.getDefaultUIPath() />
	
	<!--- links --->
	<cfset xe.saveGallery = event.getValue("xe.saveGallery") />
	<cfset myself = event.getValue("myself") />
</cfsilent>

<!--- output the needed js --->
<cfsavecontent variable="headerJqueryJS"><cfoutput>
	<script type="text/javascript" language="javascript" src="#jsPath#/ui/ui.core.js"></script>
	<script type="text/javascript" language="javascript" src="#jsPath#/ui/ui.sortable.js"></script>
	<script type="text/javascript" language="javascript" src="#jsPath#/jgrowl/jquery.ui.all.js"></script>
</cfoutput></cfsavecontent>
<cfhtmlhead text = "#headerJqueryJS#" />

<cfoutput>
<div id="gallerBuilderContainer">
	<div id="currentGalleryContainer">
		
		<h4>#rb.getResource("currentGallery")#</h4>
		
		<!--- gallery --->
		<ul id="currentGallery">
			<cfloop array="#gallery.getItemArray()#" index="item">
				<li id="#item.getIDItem()#">
					<span class="galleryItemTitle">#item.getMedia().getTitle()#</span>
					<p>
						<img src="#iconPath#/#item.getMedia().getIconFileName()#" align="left" width="30" height="30">
						<span class="galleryItemText">#item.getMedia().getDescription()#</span></p>
						<span class="galleryItemTextDeleteWarning">
							&nbsp;&nbsp;#rb.getResource("WillBeRemoved")#
							<br /><br /><br />
						</span>
					</p>
				</li>
			</cfloop>
		</ul>
	</div>
	
	<!--- trash --->
	<div id="mm_trashGallery">
		#rb.getResource("Trash")#
		<ul id="galleryTrash">
			<li></li>
		</ul>
	</div>
	<form action="#myself##xe.saveGallery#" method="post" id="frm-sort">
		<input type="submit" name="save" id="save" value="#rb.getResource('UpdateGallery')#" onClick="javascript:setNewOrderIDList();setTrashGalleryIDList()" class="" />
		<input type="hidden" name="galleryItems" id="newOrderIDList" value="" />
		<input type="hidden" name="galleryTrash" id="trashIDGalleryList" value="" />
		<input type="hidden" name="IDGallery" value="#Gallery.getIDGallery()#" />
	</form>
</div>
<script type="text/javascript">
	<!--- I set up the gallery --->
	$(document).ready(function(){
		$("##currentGallery").sortable({
			placeholder: "ui-selected", 
	    	revert: true, 
			opacity: 0.8,
			connectWith: ["##galleryTrash"]
		});
	});
		<!--- I am the delete/'trash' div for gallery order sorting --->
		$("##galleryTrash").sortable({
			placeholder: "ui-selected", 
	    	revert: true,
	    	opacity: 0.8, 
			connectWith: ["##currentGallery"]
		});

	<!--- I pass the new gallery order to a form field --->
	function setNewOrderIDList() {
		$('##currentGallery').sortable('refresh');
		$('##newOrderIDList').val($('##currentGallery').sortable('toArray'));
	}
	
	<!--- I pass the deleted/'trashed' gallery items to a form field --->
	function setTrashGalleryIDList() {
		$('##galleryTrash').sortable('refresh');
		$('##trashIDGalleryList').val($('##galleryTrash').sortable('toArray'));
	}
</script>
</cfoutput>