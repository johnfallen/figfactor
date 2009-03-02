<cfsilent>
	<!--- objects/data --->
	<cfset user = event.getValue("user") />
	<cfset media = event.getValue("media") />
	<cfset type = event.getValue("type") />
	<cfset config = event.getValue("config") />
	<cfset parentConfig = event.getValue("parentConfig") />
	<cfset typeName = type.getName() />
	<cfset rb = event.getValue("rb") />
	<cfset style = event.getValue("style") />
	<cfset jspath = config.getDefaultUIPath() />
	<cfset propertyData = media.getMediaPropertyArray(typeName)>
	
	<!--- links --->
	<cfset myself = event.getValue("myself") />
	<cfset xe.saveMedia = event.getValue("xe.saveMedia") />
	<cfset xe.deleteMedia = event.getValue("xe.deleteMedia") />

	<!--- set the correct display data for new or persisted --->
	<cfif media.getIsPersisted()>
		<cfset buttonPrefixText = "#rb.getResource('Save')#" />
	<cfelse>
		<cfset buttonPrefixText = "#rb.getResource('Create')#" />	
	</cfif>
</cfsilent>

<!--- output the needed js --->
<cfsavecontent variable="headerJqueryJS"><cfoutput>
	<script type="text/javascript" language="javascript" src="#jsPath#/ui/ui.core.js"></script>
	<script type="text/javascript" language="javascript" src="#jsPath#/ui/ui.tabs.js"></script>
	<script type="text/javascript" src="#jsPath#/jmp3/jquery.jmp3.js"></script>
	<script type="text/javascript" language="javascript" src="/viewframework/ui/flowplayer/examples/js/flashembed.min.js"></script>
	<link rel="stylesheet" href="#jsPath#/themes/flora/flora.all.css" type="text/css" media="screen" title="Flora (Default)" />
</cfoutput></cfsavecontent>
<cfhtmlhead text = "#headerJqueryJS#" />

<!--- all the js to build and populate the metadata tree --->
<cfinclude template="inc_metadata_js.cfm" />
<cfif media.getIsPersisted()>
<cfoutput>
	<div id="mm_deleteMediaButton">
		<a href="#myself##xe.deleteMedia#&IDMedia=#media.getIDMedia()#">Delete</a>
	</div>
</cfoutput>
</cfif>

<!--- the tabbed form --->
<cfoutput>
<cfform 
	name="mediaForm" 
	action="#myself##xe.saveMedia#" 
	method="post" 
	enctype="multipart/form-data">

<cfinput 
	type="submit" 
	name="savePageButton" 
	id="savePageButton" 
	value="#buttonPrefixText# #typeName#" />

<cfinput 
	type="hidden" 
	name="IDUser" 
	id="IDUser" 
	value="#user.getIDUser()#" />

<div id="example" class="flora">

	<!--- tabs --->
	<ul>
		<li><a href="##mm_tab1"><span>#rb.getResource("Information")#</span></a></li>
		<li><a href="##mm_tab2"><span>#rb.getResource("MetaData")#</span></a></li>
		<li><a href="##mm_tab3"><span>#rb.getResource("Properties")#</span></a></li>
	</ul>
	
	<!--- form --->
	<div id="mm_tab1">
		<table>
			<tr valign="top">
				<td>
					<input type="hidden" name="IDMedia" value="#media.getIDMedia()#" />
					<input type="hidden" name="IDType" value="#type.getIDType()#" />
					<input type="hidden" name="TypeName" value="#type.getName()#" />
					
					<fieldset id="titleField">
						<div class="formItem">
							<label for="title">#rb.getResource("title")#:</label>
							<cfinput required="true" 
								type="text" 
								id="title" 
								name="title" 
								value="#media.getTitle()#" />
						</div>
						
						<div class="formItem">
							<label for="description">#rb.getResource("Description")#:</label>
							<cftextarea 
								richtext="true" 
								toolbar="Basic" 
								id="description" 
								name="description">
									#media.getDescription()#
							</cftextarea>
						</div>
						
						<cfif media.getIsPersisted()>
							
							<!--- only display if we are managing the video locally, or not a video media object --->
							<cfif media.getParentType().getName() neq "video"
								or (media.getParentType().getName() eq "video" 
								and parentConfig.getVideoPlatform() neq "external")>
							
								<div class="formItem">
									<label for="FileName">#rb.getResource("CurrentFile")#:</label>
									<input 
										type="text" 
										name="FileName" 
										id="FileName" 
										value="#media.getFileName()#"
										disabled="true" 
										class="disabledFormField">
								</div>
								
								<div class="formItem">
									<label for="MediaFile">#rb.getResource("File")#:</label>
									<input 
										type="file" 
										name="MediaFile" />
								</div>
							
							<cfelse><!--- display the external video link --->
							
								<div class="formItem">
									<label for="externalURL">#rb.getResource("Link")#:</label>
									<input 
										type="text" 
										name="externalURL" 
										id="externalURL" 
										value="#HTMLEditFormat(media.getExternalURL())#">
								</div>
							</cfif>
						</cfif>
					</fieldset>
					
					<fieldset id="avaiableField">
						<div class="formItem">
							<label for="">#rb.getResource("Avaiable")#:</label>
							<input 
								type="checkbox" 
								id="Avaiable" 
								name="Avaiable"
								<cfif media.getAvaiable() eq 1> checked</cfif>/>
						</div>
					</fieldset>
				</td>
				
				<!--- preview the media if it's not a new record --->
				<cfif media.getIsPersisted() eq true>
					<td><cfinclude template="inc_media_preview.cfm" /></td>
				</cfif>
			</td>
		</table>
	</div>
	
	<!--- Meta Data --->
	<div id="mm_tab2">
		<!--- used to make the form text smaller --->
		<div id="metadatatree">
			<table>
				<tr valign="top">
					<td>
						<!--- *************** js tree ouptut  ***************  --->
						<table border="0" align="center"><tr><td align="left">
						<!--- output the js tree --->
						<cfif lselcats is not "">
							<p>#rb.getResource("ThisContentIsCategorizedAs")# <b>#replace(lSelCats, ",", ". ", "all")#</b></p>
						</cfif>
						</td></tr></table>
						<div style="position:absolute; top:0; left:0;display:none"><table border=0><tr><td><font size=-2><a style="font-size:7pt;text-decoration:none;color:silver" href="http://www.treemenu.net/" target=_blank>Javascript Tree Menu</a></font></td></tr></table></div>
						<noscript>
						#rb.getResource("ATreeForSiteNavigationWillOpenHereIfYouEnableJavaScriptInYourBrowser")#
						</noscript>
						<input type="hidden" name="#fqfieldname#" value="#attributes.currentValues[fqFieldName]#">
						<script language="JavaScript">
							initializeDocument(); 
							<cfloop list="#lSelCatsparentID#" index="thisbox">
								aux#thisbox#.forceOpeningOfAncestorFolders();
								aux#thisbox#.setState(1);
							</cfloop>
						</script>
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	
	<!--- Meta Data --->
	<div id="mm_tab3">
		<!--- used to make the form text smaller --->
		<div id="properties">
			<cfloop array="#propertyData#" index="x">
				<label for="property_#x.XMLAttributes.name#">#x.XMLAttributes.resourceBundleKey#</label><br />
				<input 
					type="text" 
					name="property_#x.XMLAttributes.name#" 
					id="property_#x.XMLAttributes.name#" 
					value="#x.XMLAttributes.value#" /><br />
			</cfloop>
		</div>
	</div>
	
</div>
</cfform>

<script type="text/javascript">	

<!--- I initalize the tabs --->
$(document).ready(function(){
	$("##example > ul").tabs();
});

<!--- I make the FCKeditor super small --->
function FCKeditor_OnComplete(editorInstance){
 	editorInstance.Config["ToolbarSets"]["BasicMin"] = [
	 ['Bold','Italic','Underline']
	 ];
	editorInstance.EditorWindow.parent.FCK.ToolbarSet.Load('BasicMin' ) ;
}

<!--- I get the search string for grid searching --->
getSearchString = function() {
	var s = ColdFusion.getElementValue('searchString');
	return s;
}
</script>
</cfoutput>