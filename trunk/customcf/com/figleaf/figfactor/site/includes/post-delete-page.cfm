<!--- Document Information -----------------------------------------------------
Title: 				post-delete-page.cfm
Author:				?????????
Email:					jallen@figleaf.com
Company:			Figleaf Software
Website:			http://www.nist.gov
Purpose:			
Usage:				
History:
Name					Date				
================================================================================
????????????			19/10/2008		Created
------------------------------------------------------------------------------->
<!--- delete custom metadata --->
<cfloop list="#attributes.pageidlist#" index="pageid">
	<cfset delete (objectid = pageid, controlid = request.fleetControlID, updateuser = session.user.name)>
</cfloop>