<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			JFAG11Service.cfc
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am a temporary object
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		04/11/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="JFA G11 Service" output="false"
	hint="I am a mock localization object, used for development.">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="JFAG11Service" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfset variables.instance = structNew() />

	<cfset variables.instance.Layout="Layout" /> 
	<cfset variables.instance.Color="Color" />
	<cfset variables.instance.Type="Type" />
	<cfset variables.instance.Search="Search" />
	<cfset variables.instance.Save="Save" />
	<cfset variables.instance.CurrentFile="Current File" />
	<cfset variables.instance.ClickToView="Click To View" />
	<cfset variables.instance.Preview="Preview" />
	<cfset variables.instance.Title="Title" />
	<cfset variables.instance.Description = "Description" />
	<cfset variables.instance.Avaiable = "Avaiable" />
	<cfset variables.instance.Edit = "Edit" />
	<cfset variables.instance.Add = "Add" />
	<cfset variables.instance.File = "File" />
	<cfset variables.instance.ID="ID" />
	<cfset variables.instance.NoMediaSelected="No Media Selected" />
	<cfset variables.instance.view="View" />
	<cfset variables.instance.MediaInformation = "Media Information" />
	<cfset variables.instance.CreateNewMedia = "Create New Media" />
	<cfset variables.instance.New = "New" />
	<cfset variables.instance.NewAudio = "New Audio" />
	<cfset variables.instance.NewImage = "New Image" />
	<cfset variables.instance.NewVideo = "New Video" />
	<cfset variables.instance.Information = "Information" />
	<cfset variables.instance.MetaData = "Meta Data" />
	<cfset variables.instance.ThisContentIsCategorizedAs = "This content is categorized as"  />
	<cfset variables.instance.ATreeForSiteNavigationWillOpenHereIfYouEnableJavaScriptInYourBrowser = "A tree for site navigation will open here if you enable JavaScript in your browser." />
	<cfset variables.instance.GoIntoBrowseMode = "Go Into Browse Mode" />
	<cfset variables.instance.AddToGallery = "Add to Gallery" />
	<cfset variables.instance.CurrentPageOptions = "Current Page Options" />
	<cfset variables.instance.TheItemWasAddedToTheGallery = "The item was added to the gallery" />
	<cfset variables.instance.LayoutSlashPreview = "Layout / Preview" />
	<cfset variables.instance.SelectMedia = "Select Media" />
	<cfset variables.instance.GalleryOrder = "Gallery Order" />
	<cfset variables.instance.CurrentGallery = "Current Gallery" />
	<cfset variables.instance.WillBeRemoved = "Will Be Removed." />
	<cfset variables.instance.ThePageHasNoMediaAssociatedWithIt = "The page has no media associated with it." />
	<cfset variables.instance.ClickHereToBrowseAvaiableMedia = "Click here to browse avaiable media." />
	<cfset variables.instance.ClickHereToManageThePagesMultiMedia = "Click here to manage the pages multimeida." />
	<cfset variables.instance.ClickHereToManageGallery = "ClickHereToManageGallery:" />
	<cfset variables.instance.ManageMyMedia = "Manage My Media" />
	<cfset variables.instance.ManageMedia = "Manage Media" />
	<cfset variables.instance.Create = "Create" />
	<cfset variables.instance.GallerySlashPreview = "Gallery / Preview" />
	<cfset variables.instance.GalleryName = "Gallery Name" />
	<cfset variables.instance.Layout = "Layout" />
	<cfset variables.instance.Trash = "Trash" />
	<cfset variables.instance.MultiMedia = "Multi-Media" />
	<cfset variables.instance.UpdateGallery = "Update Gallery" />
	<cfset variables.instance.Link = "Video Link" />
	<cfset variables.instance.Properties = "Properties" />
	
	<cfreturn this />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data."
	description="I return my internal instance data as a structure.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- getResource --->
<cffunction name="getResource" returntype="any" access="public" output="false"
	displayname="getResource" hint="I retrun a value."
	description="I retrun a value.">
	
	<cfargument name="resource" />

	<cfset var phrase = "Resource Not Found"/>
	
	<cfif structKeyExists(variables.instance, arguments.resource)>
		<cfset phrase = variables.instance[arguments.resource] />	
	</cfif>
	
	<cfreturn phrase />
</cffunction>

<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>