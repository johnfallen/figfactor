<cfsilent>
	<!--- values needed by the js tree --->
	<cfset factory = Application.BeanFactory.getBean("BeanFactory") />
	<cfset config = factory.getBean("ConfigBean") />
	<cfset _metaDataService = Application.Fleet.getService("MetaDataService") />
	<cfset treeid = 1 />
	<cfset qGetTree = _metaDataService.getCachedMetaDataTree(1)>
	<cfset jsDirectory = _metaDataService.getMetaDataConfigBean().getMetaDataUISupportJSDirectory() />
	<cfset fqFieldName = "KeywordIDList">
	<cfset attributes.currentValues = structNew() />
	<cfset attributes.currentValues[fqFieldName] = media.getKeywordIDList() />
</cfsilent>

<!--- make the header content a big phat string --->
<cfsavecontent variable="localJavascriptHeader">
<cfoutput>

<script type="text/javascript" language="javascript" src="#jsDirectory#/metadata/ua.js"></script>
<script type="text/javascript" language="javascript" src="#jsDirectory#/metadata/ftiens4.js"></script>
<script type="text/javascript" language="javascript" src="#jsDirectory#/metadata/checkboxtreesupport.js"></script>


<script language="javascript">
	metadatatreeid = #treeid#;
	ICONPATH="#jsDirectory#/treeview/";
	foldersTree = gFld("Please categorize this media");
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

<!--- create JavaScript Tree  --->
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
		
<cfif listfind(lfound,qgettree.metadataparentid)><cfoutput>gCB(aux#qgettree.metadataparentid#, "#qgettree.metadatakeywordenglishtranslation#", "BOX#qgettree.metadataid#",#qgettree.metadataid#,#variables.bchecked#);</cfoutput>
				<cfif variables.bchecked is "1"><cfset lSelCatsID = listappend(lSelCatsID,qgettree.metadataid)></cfif>
				<cfif variables.bchecked is "1"><cfset lSelCatsParentID = listappend(lSelCatsParentID,qgettree.metadataparentid)></cfif>
				<cfif variables.bchecked is "1"><cfset lSelCats = listappend(lSelCats,qgetTree.metadatakeywordenglishtranslation)></cfif>
			</cfif>
		</cfif></cfloop><cfoutput>
</script>
</cfoutput>
</cfsavecontent>
<!--- output the big phat string --->
<cfoutput>
#localJavascriptHeader#
</cfoutput>