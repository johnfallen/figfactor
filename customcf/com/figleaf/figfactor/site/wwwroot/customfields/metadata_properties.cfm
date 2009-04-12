<cfsilent>
<!---

Filename: customfields/metadata_properties.cfm

Creation Date: 03/10/2004

Author: Steve Drucker (sdrucker@figleaf.com)
Fig Leaf Software (www.figleaf.com)

Purpose: Properties handler for custom metadata field type
This module allows the administrator to select which specific metadata tree
will be used in the render handler.

Call Syntax: Invoked by Commonspot, registered through commonspot admin custom fields interface

Modification Log:
=====================================
05/24/2004	sdrucker	documented
--->

<!--- ************************************* SETUP / LOGIC  *****************************  --->

<cfset metaDataService = Application.Fleet.getService("MetaDataService") />
<cfset factory = Application.FigFactor.getFactory() />
<cfset config = factory.getBean("ConfigBean") />


<cfset qgetTrees = metaDataService.getMetaDataTreeService().listMetaDataTree() />

<!--- ************************************* OUTPUT *************************************  ---></cfsilent>
<cfscript>
	typeid = attributes.typeid;
	prefix = attributes.prefix;
	formname = attributes.formname;
	if (not structkeyexists(attributes.currentvalues,"metadatatreeid")) {
		attributes.currentvalues.metadatatreeid = 0;
	}
</cfscript>

<cfoutput>
	<script language="javascript">
		fieldProperties['#typeid#'].paramFields='#prefix#metadatatreeid';
	</script>
	 
	<table border="0" cellpadding="3" cellspacing="0">
			<tr>
				<td><font face="#request.cp.font#" size="1">Select Metadata Hierarchy:</font></td>
				<td>
					<select name="#prefix#metadatatreeid">
						<cfloop query="qgettrees">
							<option value="#qgettrees.metadatatreeid#" <cfif attributes.currentvalues.metadatatreeid is qgettrees.metadatatreeid>selected</cfif>>#qgettrees.metadatatreename#</option>
						</cfloop>
					</select>
				</td>
			</tr>
	</table>
</cfoutput>