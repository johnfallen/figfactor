<!--- -------------------------------------------------------------------------------------------------------------------  
Filename: /mediaAssets/deleteAsset.cfm

Creation Date: May 2004

Author: Steve Drucker (sdrucker@figleaf.com)
Fig Leaf Software (www.figleaf.com)

Purpose: 
Deletes a file asset from the database

Call Syntax: 
Invoked from /customfields/mediaAssets_rendering.cfm through
a hidden iframe

Modification Log:
=====================================
01/02/2005 sdrucker	updated documentation

-------------------------------------------------------------------------------------------------------------------  --->

<cfset Application.FileAsset.Delete(fileassetid = url.id, updateuser = session.user.name)>

<cfoutput>
	<script language="javascript">
		var  thewin = parent.parent.window.opener;
		
		/* hide data from search results */  
		parent.document.getElementById('mediaasset#url.id#').style.display='none';
		
		/* hide data from selections */
		var position = thewin.fnFindPosition_#fqfieldname#(#url.id#);
		if (position != -1) {
			thewin.fnDeleteRecord_#fqfieldname#(position);
		}
		
		alert("Record Deleted");
	</script>
</cfoutput>