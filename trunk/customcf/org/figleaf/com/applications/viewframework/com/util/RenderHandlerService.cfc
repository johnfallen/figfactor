<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:     		RenderHandlerService.cfc 	
					Old name: rh_obj.cfc
Author:     		Unknown, Ron West?
Email:      	
Purpose:    	Utility for Render Handlers

Usage:      		getElementData()
					getCustomElementData()
					getRenderHandlerMetadata()
					standardRender()
Modification Log:
Name				Date				Description
================================================================================
Unknown		00/00/2000		Created
John Allen		03/22/2008		Renamed.
John Allen		03/22/2008		Added Document Information header comments.
John Allen		03/22/2008		Var scoped several local variables that needed it.
										Both indexes for loops in getCustomElementData(), and 
										the return variables for getElementData() and standardRender().
------------------------------------------------------------------------------->
<cfcomponent displayname="Common Render Handler Utilites" name="RHUtils">

<!--- init --->
<cffunction name="init" access="public" hint="I initalize this CFC. Element Infomations is a required argument." displayname="Initialize" output="true" returntype="any">
	<cfargument name="elementInfo" required="true" type="struct" hint="I am a structure of an elements information.<br />I am required.">
	<!--- place the element infor into the requst scope for ease of use --->
	<cfset request.elementInfo = arguments.elementInfo />
	<cfreturn this />
</cffunction>


<!--- getElementData --->
<cffunction name="getElementData" access="public" displayname="Get Element Data" output="false">
	<cfargument name="type" required="true" type="string" default="Render Handler Type.<br />I am required.">
	
	<!--- Added by John Allen 03-22-2008 --->
	<cfset var rtnData = 0 />
	
	<cfscript>
		// Render handler type differences
		switch (arguments.type)
		{
			// page index
			case "pageIndex":
			{
				// get the items data
				rtnData = request.elementInfo.elementData.items;
				break;
			}
			case "custom":
			{
				// call the getCustomElementData function
				rtnData = getCustomElementData();
				break;
			}
			case "searchResults":
			{
				// searchResults have more data than just items
				rtnData = request.elementInfo.elementData;
				break;
			}
			case "breadcrumb":
			{
				// get the items data
				rtnData = request.elementInfo.elementData.items;
				break;
			}
			case "image":
			{
				// get the image data
				rtnData = request.elementInfo.elementParams;
				break;
			}
			case "textblock":
			{
				// get the textblock data
				rtnData = request.elementInfo.elementData;
				break;
			}
			case "linkbar":
			{
				// get the items data
				rtnData = request.elementInfo.elementData.items;
				break;
			}
		}
	</cfscript>
	<cfreturn rtnData>
</cffunction>



<!--- getCustomElementData --->
<cffunction name="getCustomElementData" displayname="SimpleElementData" output="false" access="public">
	
	<!--- added by John Allen 03-22-2008 --->
	<cfset var i = 0 />
	<cfset var pName = "" />
	<cfset var thisFieldID = 0 />
	<cfset var thisFieldname = 0 />
	<cfset var data = request.elementInfo.elementData />
	<cfset var params = request.elementInfo.elementParams />
	<cfset var formId = params.properties.formId[1] />
	<cfset var items = data.propertyValues />
	<cfset var elementContent = arrayNew(1) />

	<cfloop index="i" from="1" to="#arrayLen(items)#">

		<cfset elementContent[i] = structNew()>

		<cfloop index="pName" list="#structKeyList(items[i])#">
			<cfswitch expression="#pName#">

				<cfcase value="authorID,controlID,dateAdded,dateApproved,pageID">
					<cfset elementContent[i][pName] = items[i][pName]>
				</cfcase>

				<cfdefaultcase>
					<cfif pName contains "fic_#formId#">

						<cfset thisFieldID = listLast(pName, "_")>
						<cfif isNumeric(thisFieldID)>
							<cfset thisFieldname = replace(params.fieldParams[thisFieldID].fieldname, "FIC_", "", "ONE")>
							<cfset elementContent[i].fields[thisFieldname] = StructNew()>
							<cfset elementContent[i].fields[thisFieldname].value = items[i][pName]>
							<cfset elementContent[i].fields[thisFieldname].id = thisFieldID>
						</cfif>

					</cfif>
				</cfdefaultcase>
			</cfswitch>
		</cfloop>

		<cfset elementContent[i].formID = formId />
		<cfset elementContent[i].fieldnames = structKeyList(elementContent[i].fields) />
	</cfloop>

	<cfreturn elementContent />
</cffunction>


<!--- getRenderHandlerMetadata --->
<cffunction name="getRenderHandlerMetadata" access="public" output="false" 
	hint="I return the renderHandler Metadata.">
	<cfreturn request.elementInfo.renderHandlerMetadata>
</cffunction>


<!--- standardRender --->
<cffunction name="standardRender" access="public" output="true">
	<cfargument name="type" required="true" type="string" default="Render Handler Type" hint="I am the call back to the CommonSpot Standard Rendering.<br />I am requied.">
	
	<!--- added by John Allen 03-22-2008 --->
	<cfset var standard_module =  ""/>
	<cfset var attributes = structNew() />
	
	<cfscript>
		// Render handler type differences
		switch (arguments.type)
		{
			// page index
			case "pageIndex":
			{
				// get the items data
				standard_module = "pageIndex/pageindex-standard-render.cfm";
				// for some reason we are looking in caller scope
				caller.what = "pageindex";
				break;
			}
			case "custom":
			{
				// call the getCustomElementData function
				standard_module = "custom/standard-render.cfm";
				break;
			}
			case "breadcrumb":
			{
				// get the standard module for breadcrumb
				standard_module = "linkbar/lbar-standard-render.cfm";
				break;
			}
			case "image":
			{
				// get the standard render module for images
				standard_module = "image/sic-standard-render.cfm";
				break;
			}
			case "textblock":
			{
				// get the standard module for a textblock
				standard_module = "textblock/tb-standard-render.cfm";
				break;
			}
			case "linkbar":
			{
				// get the standard module for linkbar
				standard_module = "linkbar/lbar-standard-render.cfm";
				break;
			}
		}
	</cfscript>
	
	<!---  set the elementinfo data --->
	<cfset attributes.elementInfo = request.elementInfo />
	
	<!--- include the CS Standard Render --->
	<cfinclude template="/commonspot/controls/#standard_module#" />
</cffunction>
</cfcomponent>