<cfsilent>
<!---
Filename: customfields/metadata_rendering.cfm
Creation Date: 03/10/2004
Author: Steve Drucker (sdrucker@figleaf.com)
Fig Leaf Software (www.figleaf.com)

Purpose: 		Render handler for custom metadata field type.

					This module allows the content contributor to 
					classify data using a "tree of checkboxes" based 
					on the metadata classification scheme.

Notes:
					Values from selected checkboxes are stored in a 
					comma delimited list.

Call Syntax: 	Invoked by Commonspot, registered through commonspot 
					admin custom fields interface.

Modification Log:
=====================================
05/24/2004	sdrucker	documented
11/18/2004	sdrucker	modified checkbox function call name to reduce download time
01/02/2005	sdrucker	updated documentation
12/7/2005	ho				added display for categories selected

08/16/2008 jallen			Re-factored to work with new code-base. 
								Changed data refrences to point to Application.Fleet.
--->

<!--- ********************* SETUP / LOGIC  *********************  --->
<cfset _metaDataService = Application.FigFactor.getBean("Fleet").getService("MetaDataService") />
<cfset factory = Application.FigFactor.getFactory() />
<cfset config = factory.getBean("ConfigBean") />

<cfset jsDirectory = config.getMetaDataUISupportJSDirectory() />

<!--- 
Get data from properties module and use its ID (treeid) to get the correct
query object from TinyFleet to populate the js tree.
--->
<cfset treeid = parameters[fieldquery.inputID].metadatatreeid>
<cfset qGetTree = _metaDataService.getCachedMetaDataTree(1)>


<!--- ********************* OUTPUT ********************** --->
</cfsilent>


<!--- 
Store checkbox tree JS in <head> section of document.
--->
<cfsavecontent variable="headinfo">
	<cfoutput>
<style>
	td {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px;}
	 a  {text-decoration: none; color: black;}
</style>

<!--- javascript tree support functions --->
<script src="#jsDirectory#treeview/ua.js" language="javascript"></script>
<script src="#jsDirectory#metadata/ftiens4.js" language="javascript"></script>
<script src="#jsDirectory#metadata/checkboxtreesupport.js" language="javascript"></script>

<script language="javascript">
	metadatatreeid = #treeid#;
	ICONPATH="#jsDirectory#/treeview/";
	foldersTree = gFld("Please categorize this article");
	foldersTree.treeID = "checkboxTree";
	PRESERVESTATE = 1;
	
	// checkbox click handler
	function fnCheckbox(obj,idata) {
		if (obj.checked) {
			addToList('#fqfieldname#',idata)
		} else {
			delFromList('#fqfieldname#',idata);
		}
	}
	</cfoutput>
	
	<cfset thisgroup="">	
	
	<!--- output tree definitions --->
	<cfset lfound = "">
	<cfset lSelCats = "">
	<cfset lSelCatsID = "">
	<cfset lSelCatsParentID = "">
	
	<cfloop query="qgettree">
		<cfif listfind(attributes.currentValues[fqFieldName],qgettree.metadataid)>
			<cfset bchecked=1>
		<cfelse>
			<cfset bchecked=0>
		</cfif>
		
		<cfif qgettree.currentrow is not qgettree.recordcount and qgettree.metadataparentid[currentrow + 1] is qgettree.metadataid>
		
			<cfif qgettree.metadataparentid is "">
				<cfset parent="foldersTree">
			<cfelse>
				<cfset parent="aux#metadataparentid#">
			</cfif>			
			<cfif qgettree.metadataparentid is "" or listfind(lfound,qgettree.metadataparentid)>
				<cfoutput>aux#qgettree.metadataid# = gCB2(#variables.parent#,"#jsStringFormat(qgettree.metadatakeywordenglishtranslation)#","","BOX#qgettree.metadataid#",#qgettree.metadataid#,#variables.bchecked#);</cfoutput>
				
				<cfset lfound = listappend(lfound,qgetTree.metadataid)>
				
				<cfif variables.bchecked is "1"><cfset lSelCatsID = listappend(lSelCatsID,qgettree.metadataid)></cfif>
				<cfif variables.bchecked is "1"><cfset lSelCatsParentID = listappend(lSelCatsParentID,qgettree.metadataparentid)></cfif>
				<cfif variables.bchecked is "1"><cfset lSelCats = listappend(lSelCats,qgetTree.metadatakeywordenglishtranslation)></cfif>				
			</cfif>
		<cfelse>
			
			<cfif listfind(lfound,qgettree.metadataparentid)>
				<cfoutput>gCB(aux#qgettree.metadataparentid#, "#qgettree.metadatakeywordenglishtranslation#", "BOX#qgettree.metadataid#",#qgettree.metadataid#,#variables.bchecked#);</cfoutput>
		
				<cfif variables.bchecked is "1"><cfset lSelCatsID = listappend(lSelCatsID,qgettree.metadataid)></cfif>
				<cfif variables.bchecked is "1"><cfset lSelCatsParentID = listappend(lSelCatsParentID,qgettree.metadataparentid)></cfif>
		
				<cfif variables.bchecked is "1"><cfset lSelCats = listappend(lSelCats,qgetTree.metadatakeywordenglishtranslation)></cfif>
			</cfif>
		</cfif>
	</cfloop>	
	<cfoutput>
		</script>
	</cfoutput>
</cfsavecontent>

<cfhtmlhead text="#variables.headinfo#">

<cfoutput>
<table>
<tr>
	<td>
	<table border="0" align="center"><tr><td align="center">
	<!--- added to display categories already seleted. ho Wednesday, December 07, 2005 --->
	<cfif lselcats is not "">
		This content is categorized as <b>#replace(lSelCats, ",", ". ", "all")#</b>
	</cfif>
	<!--- #jsDirectory# --->
	</td></tr></table>
		<div style="position:absolute; top:0; left:0;display:none"><table border=0><tr><td><font size=-2><a style="font-size:7pt;text-decoration:none;color:silver" href="http://www.treemenu.net/" target=_blank>Javascript Tree Menu</a></font></td></tr></table></div>
		<noscript>
		A tree for site navigation will open here if you enable JavaScript in your browser.
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

<!--- register data with CommonSpot --->
<script language="javascript">
	#fqfieldname# = new Object();
	#fqfieldname#.id='#fqfieldname#'
	#fqfieldname#.validator='fnSaveMetaData()';
	#fqfieldname#.message='You must validate...';
	#fqfieldname#.tid=#rendertabindex#;
	vobjects_#attributes.formname#.push(#fqfieldname#);
	
	function fnSaveMetaData() {
		
		<cfif isdefined("caller.datacontrolid")>
			<cfset thisid = caller.datacontrolid>
		<cfelse>	
			<cfset thisid = 0>
		</cfif>
	
		return true;
	}
</script>
</cfoutput>