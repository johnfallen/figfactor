<cfsilent>
	<!--- objects/data --->
	<cfset user = event.getValue("user") />
	<cfset page = event.getValue("page") />
	<cfset config = event.getValue("config") />
	<cfset layouts = event.getValue("layouts") />
	<cfset types = event.getValue("types") />
	<cfset rb = event.getValue("rb") />
	<cfset galleryIndex = event.getValue("galleryIndex") />

	<cfset IDType = 0 />
	<cfset gallery = page.getGallery(galleryIndex)>
	<cfset layout = gallery.getLayout() />
	<cfset IDPage = page.getIDPage() />

	<!--- is it a mixed media gallery? --->
	<cfif layout.getIsMixedMedia() eq 1 and layout.getIsGallery() eq 1>
		<cfset currentIDType = "pageIsMixedMedia"/>
		<cfset titleColumnWidth = 245 />
	<cfelse>
		<cfset currentIDType = layout.getIDParentType() />
		<cfset titleColumnWidth = 300 />
	</cfif>
	
	<!--- links --->
	<cfset myself = event.getValue("myself") />
	<cfset xe.savePage = event.getValue("xe.savePage") />
	<cfset xe.addToGallery = event.getValue("xe.addToGallery") />
	<cfset bindLink = event.getValue("bind.link") />
	<cfset ajaxMediaURL = "#myself##viewState.getValue('xe.ajaxLoadMedia')#" />
	<cfset ajaxCurrentMediaURL = "#myself##viewState.getValue('xe.ajaxLoadCurrentMedia')#" />
	
	<cfset jspath = config.getDefaultUIPath() />
</cfsilent>

<!--- output the needed js --->
<cfsavecontent variable="headerJqueryJS"><cfoutput>
	<script type="text/javascript" language="javascript" src="#jsPath#/jgrowl/jquery.jgrowl.js"></script>
	<script type="text/javascript" language="javascript" src="#jsPath#/jgrowl/jquery.ui.all.js"></script>
	<script type="text/javascript" src="#jsPath#/jmp3/jquery.jmp3.js"></script>
	<script type="text/javascript" language="javascript" src="/viewframework/ui/flowplayer/examples/js/flashembed.min.js"></script>
	<link rel="stylesheet" href="#jsPath#/jgrowl/jquery.jgrowl.css" type="text/css" media="screen" title="JGrowel" />
</cfoutput></cfsavecontent>
<cfhtmlhead text = "#headerJqueryJS#" />

<!--- the grid and preview cfdiv --->
<cfoutput>
<table>
	<tr valign="top">
		<td>
			<cfform name="media" id="media">
				
				<!--- used to filter the grid if not a mixed media gallery type --->
				<cfinput 
					name="currentIDType" 
					id="currentIDType"
					type="hidden" 
					value="#currentIDType#"/>

				<cfinput 
					name="searchString" 
					id="searchString"
					size="38"
					type="text"/>
	
				<cfinput type="button" 
					name="searchBtn" 
					value="#rb.getResource('Search')#" 
					onclick="ColdFusion.Grid.refresh('mediaGrid', false);" />	
				
				<cfgrid 
					format="html" 
					name="mediaGrid" 
					pagesize="10" 
					preservepageonsort="true"
					bind="cfc:#bindLink#({cfgridpage},{cfgridpagesize},{cfgridsortcolumn},{cfgridsortdirection}, getSearchString(), getIDType())">		
					
					<cfgridcolumn 
						name="IDMedia" 
						display="false" />
	
					<cfgridcolumn 
						name="Title" 
						header="#rb.getResource('Title')#" 
						width="#titleColumnWidth#" />
					
					<!--- displayed when the gallery is a mixed media --->
					<cfif currentIDType eq "pageIsMixedMedia">
						<cfgridcolumn 
							name="type" 
							header="#rb.getResource('Type')#" 
							width="40" />
					</cfif>
				</cfgrid>
			</cfform>
		</td>
		<td>
			<cfpod 
				name="newVideoContainer" 
				title="#rb.getResource('Preview')#" 
				width="343" 
				height="247">

				<cfdiv 
					id="VideoSource" 
					bindOnLoad="false" 
					bind="url:#ajaxMediaURL#&IDMedia={media:mediaGrid.IDMedia}">
				</cfdiv>
			</cfpod>
			
			<!--- adds an item to the current gallery --->
			<cfform name="addToGalleryForm" action="#myself##xe.addToGallery#">
				<cfinput type="hidden" name="IDGallery" value="#gallery.getIDGallery()#" />
				<cfinput type="hidden" name="newIDMedia" bind="{media:mediaGrid.IDMedia}" />
			</cfform>
			
			<!--- cfajax form submit --->
			<a href="javascript:submitGalleryItem()">#rb.getResource("AddToGallery")#</a>
		</td>
	</td>
</table>
<script>
	<!--- I return the search string for grid filtering --->
	getSearchString = function() {
		var s = ColdFusion.getElementValue('searchString');
		return s;
	}

	<!--- I return the user id to filter the grid with a users media --->
	getIDType = function() {
	   var IDType = ColdFusion.getElementValue('currentIDType');
	   return IDType;
	}

	<!--- submit the add item form --->
	function submitGalleryItem() {
	    ColdFusion.Ajax.submitForm('addToGalleryForm', '#myself##xe.addToGallery#', callback);
	}
  
	<!--- notify of a suceesfull submission with jGrowl --->
	 function callback(text){
	$.jGrowl('#rb.getResource("TheItemWasAddedToTheGallery")#', { 
      	speed: 1000,
      	easing: 'easeInOutExpo',
      	closer: false,
		animateOpen: { 
		height: "show",
		width: "show"
		},
			
			life: 1000
		});
	} 
</script>
</cfoutput>