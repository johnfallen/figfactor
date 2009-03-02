\<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			ConfigBean.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I persist configuration data
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		03/01/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Config Bean" output="false"
	hint="I persist configuration data">

<!--- 
	HARD CODED CONSTANTS 
	These are used when a page is first created. It's pretty much only
	used in the browse_media.cfm and a couple of other views. I guess
	that since I need these the design is clugy?? I don't think so. I really
	wanted the display of the browse media grid to change based on what
	type of gallery the user selected and didn't want to write two views.
--->
<cfset variables.DEFAULT_ID_LAYOUT = 4 />
<cfset variables.DEFAULT_ID_TYPE = 2 />
<cfset variables.DEFAULT_UI_DIRECTORY = "/ui/multimedia/js/jquery" />

<!--- 
	The ui support directory, where files for both public and admin live 
	realitive to the root of the application.
--->
<cfset variables.DEFAULT_UI_SUPPORT_PATH = "/uisupport/images" />
<cfset variables.DEFAULT_FLASH_VIDEO_PLAYER_PATH = "/uisupport/flash/flowplayer/FlowPlayerDark.swf" />

<!--- 
	The media properties xml defintions. Each sub classed meida object has properties.
	What defines each sub classed media properties are these xml files.
 --->
<cfset variables.MEDIA_PROPERTIES_XML_FILE_NAME = "mediaproperties.xml" />
<cfset variables.MEDIA_PROPERTIES_FILE_PATH = "model/com/config" />



<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="ConfigBean" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="ParentConfig" type="component" required="true" 
		hint="I am the ModelGlue Configuration object.<br />I am required." />
	<cfargument name="FileSystem" type="component" required="true" 
		hint="I am the FileSystem utiltiy object.<br />I am required." />

	<cfset var length = 0 />
	<cfset var applicationComponentPath = "" />

	<!--- regex up 4 directories and delete the '/ '--->
	<cfset var thePath = 
		GetDirectoryFromPath(
			GetCurrentTemplatePath()
			).ReplaceFirst(
					"([^\\\/]+[\\\/]){3}$", ""
			) />
	
	<cfset var audioDir = "/audio" />
	<cfset var imageDir = "/image" />
	<cfset var videoDir = "/video" />

	<cfset variables.FileSystem = arguments.FileSystem />
	<cfset setURLEventKey(arguments.ParentConfig.getEventValue()) />
	
	<!--- system root directory path, not well named should be theDirectoryRoot --->
	<cfset setThePath(thePath) />
	
	<!--- Shared UI support images for public and admin. --->
	<cfset setUISupportImagePath(
			arguments.ParentConfig.getApplicationPath() 
			& 
			variables.DEFAULT_UI_SUPPORT_PATH) />
	
	<!--- Shared UI flash player for public and admin --->
	<cfset setDefaultFlashVideoPlayerPath(
			arguments.ParentConfig.getApplicationPath() 
			& 
			variables.DEFAULT_FLASH_VIDEO_PLAYER_PATH) />
	
	<!--- system paths --->
	<cfset setAudioStorageDirectory(thePath & "media" & audioDir) />
	<cfset setImageStorageDirectory(thePath & "media" & imageDir) />
	<cfset setVideoStorageDirectory(thePath & "media" & videoDir) />
	<cfset setJavaScriptDirectory(arguments.ParentConfig.getApplicationPath() & "/js") />
	
	<!--- the default layout --->
	<cfset setDefaultGalleryIDLayout(variables.DEFAULT_ID_LAYOUT) />
	<!--- the default type --->
	<cfset setDefaultIDType(variables.DEFAULT_ID_TYPE) />
	<!--- get this so the application dose not need to refrence modelGlue directly --->
	<cfset setReload(arguments.ParentConfig.getReload()) />
	
	<!--- where the javascript for the gallery displays --->
	<cfset setDefaultUIPath(variables.DEFAULT_UI_DIRECTORY) />
	
	<!--- the root realitive path --->
	<cfset setMediaStoragePath(arguments.ParentConfig.getApplicationPath() & "/media") />
	
	<!--- the realitive paths for audio,images, and videos --->
	<cfset setAudioStoragePath(getMediaStoragePath() & audioDir) />
	<cfset setImageStoragePath(getMediaStoragePath()  & imageDir & "/origional") />
	<cfset setImageStorageIconPath(getMediaStoragePath() & imageDir) />
	<cfset setImageStoragePreviewPath(getMediaStoragePath() & imageDir) />	
	<cfset setVideoStoragePath(getMediaStoragePath() & videoDir) />

	<!--- create the component path then set it--->
	<cfset length = len(arguments.ParentConfig.getApplicationPath()) />
	<cfset applicationComponentPath = right(replace(arguments.ParentConfig.getApplicationPath(), "/", ".", "all"), length - 1) & "." />
	<cfset setApplicationComponentPath(applicationComponentPath & "model.MultiMediaAjaxFacade") />

	<!--- make sure the directories exsist --->
	<cfset arguments.FileSystem.fixDestination(getAudioStorageDirectory()) />
	<cfset arguments.FileSystem.fixDestination(getImageStorageDirectory()) />
	<cfset arguments.FileSystem.fixDestination(getVideoStorageDirectory()) />
	
	<!--- the configurable media properties XML --->
	<cfset temp =  variables.FileSystem.read(
			destination = getThePath() & variables.MEDIA_PROPERTIES_FILE_PATH & "/",
			fileName = variables.MEDIA_PROPERTIES_XML_FILE_NAME) />
	<cfset temp = XMLParse(temp)>
	<cfset setMediaPropertiesXML(temp) />

	<cfreturn this />
</cffunction>


<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- DefaultFlashVideoPlayerPath --->
<cffunction name="setDefaultFlashVideoPlayerPath" output="false" access="private"
	hint="I set the DefaultFlashVideoPlayerPath property.">
	<cfargument name="DefaultFlashVideoPlayerPath" type="string" />
	<cfset variables.instance.DefaultFlashVideoPlayerPath = arguments.DefaultFlashVideoPlayerPath />
</cffunction>
<cffunction name="getDefaultFlashVideoPlayerPath" output="false" access="public"
	hint="I return the DefaultFlashVideoPlayerPath property.">
	<cfreturn variables.instance.DefaultFlashVideoPlayerPath />
</cffunction>

<!--- UISupportImagePath --->
<cffunction name="setUISupportImagePath" access="public" output="false" 
	hint="I set the UISupportImagePath property.">
	<cfargument name="UISupportImagePath" hint="I am the UISupportImagePath." />
	<cfset variables.instance.UISupportImagePath = arguments.UISupportImagePath />
</cffunction>
<cffunction name="getUISupportImagePath" access="public" output="false" 
	hint="I return the UISupportImagePath property.">
	<cfreturn variables.instance.UISupportImagePath  />
</cffunction>


<!--- ApplicationComponentPath --->
<cffunction name="setApplicationComponentPath" output="false" access="private"
	hint="I set the ApplicationComponentPath property.">
	<cfargument name="ApplicationComponentPath" type="string" />
	<cfset variables.instance.ApplicationComponentPath = arguments.ApplicationComponentPath />
</cffunction>
<cffunction name="getApplicationComponentPath" output="false" access="public"
	hint="I return the ApplicationComponentPath property.">
	<cfreturn variables.instance.ApplicationComponentPath />
</cffunction>

<!--- DefaultUIPath --->
<cffunction name="setDefaultUIPath" output="false" access="private"
	hint="I set the DefaultUIPath property.">
	<cfargument name="DefaultUIPath" type="string" />
	<cfset variables.instance.DefaultUIPath = arguments.DefaultUIPath />
</cffunction>
<cffunction name="getDefaultUIPath" output="false" access="public"
	hint="I return the DefaultUIPath property.">
	<cfreturn variables.instance.DefaultUIPath />
</cffunction>

<!--- AudioStoragePath --->
<cffunction name="setAudioStoragePath" output="false" access="private"
	hint="I set the AudioStoragePath property.">
	<cfargument name="AudioStoragePath" type="string" />
	<cfset variables.instance.AudioStoragePath = arguments.AudioStoragePath />
</cffunction>
<cffunction name="getAudioStoragePath" output="false" access="public"
	hint="I return the AudioStoragePath property.">
	<cfreturn variables.instance.AudioStoragePath />
</cffunction>

<!--- ImageStoragePath --->
<cffunction name="setImageStoragePath" output="false" access="private"
	hint="I set the ImageStoragePath property.">
	<cfargument name="ImageStoragePath" type="string" />
	<cfset variables.instance.ImageStoragePath = arguments.ImageStoragePath />
</cffunction>
<cffunction name="getImageStoragePath" output="false" access="public"
	hint="I return the ImageStoragePath property.">
	<cfreturn variables.instance.ImageStoragePath />
</cffunction>

<!--- ImageStorageIconPath --->
<cffunction name="setImageStorageIconPath" output="false" access="private"
	hint="I set the ImageStorageIconPath property.">
	<cfargument name="ImageStorageIconPath" type="string" />
	<cfset variables.instance.ImageStorageIconPath = arguments.ImageStorageIconPath />
</cffunction>
<cffunction name="getImageStorageIconPath" output="false" access="public"
	hint="I return the ImageStorageIconPath property.">
	<cfreturn variables.instance.ImageStorageIconPath />
</cffunction>

<!--- ImageStoragePreviewPath --->
<cffunction name="setImageStoragePreviewPath" output="false" access="private"
	hint="I set the ImageStoragePreviewPath property.">
	<cfargument name="ImageStoragePreviewPath" type="string" />
	<cfset variables.instance.ImageStoragePreviewPath = arguments.ImageStoragePreviewPath />
</cffunction>
<cffunction name="getImageStoragePreviewPath" output="false" access="public"
	hint="I return the ImageStoragePreviewPath property.">
	<cfreturn variables.instance.ImageStoragePreviewPath />
</cffunction>


<!--- VideoStoragePath --->
<cffunction name="setVideoStoragePath" output="false" access="private"
	hint="I set the VideoStoragePath property.">
	<cfargument name="VideoStoragePath" type="string" />
	<cfset variables.instance.VideoStoragePath = arguments.VideoStoragePath />
</cffunction>
<cffunction name="getVideoStoragePath" output="false" access="public"
	hint="I return the VideoStoragePath property.">
	<cfreturn variables.instance.VideoStoragePath />
</cffunction>

<!--- DefaultIDType --->
<cffunction name="setDefaultIDType" output="false" access="private"
	hint="I set the DefaultIDType property.">
	<cfargument name="DefaultIDType" type="numeric" />
	<cfset variables.instance.DefaultIDType = arguments.DefaultIDType />
</cffunction>
<cffunction name="getDefaultIDType" output="false" access="public"
	hint="I return the DefaultIDType property.">
	<cfreturn variables.instance.DefaultIDType />
</cffunction>

<!--- DefaultGalleryIDLayout --->
<cffunction name="setDefaultGalleryIDLayout" output="false" access="private"
	hint="I set the DefaultGalleryIDLayout property.">
	<cfargument name="DefaultGalleryIDLayout" type="numeric" />
	<cfset variables.instance.DefaultGalleryIDLayout = arguments.DefaultGalleryIDLayout />
</cffunction>
<cffunction name="getDefaultGalleryIDLayout" output="false" access="public"
	hint="I return the DefaultGalleryIDLayout property.">
	<cfreturn variables.instance.DefaultGalleryIDLayout />
</cffunction>

<!--- URLEventKey --->
<cffunction name="setURLEventKey" output="false" access="private"
	hint="I set the URLEventKey property.">
	<cfargument name="URLEventKey" type="string" />
	<cfset variables.instance.URLEventKey = arguments.URLEventKey />
</cffunction>
<cffunction name="getURLEventKey" output="false" access="public"
	hint="I return the URLEventKey property.">
	<cfreturn variables.instance.URLEventKey />
</cffunction>


<!--- MediaStoragePath --->
<cffunction name="setMediaStoragePath" output="false" access="private"
	hint="I set the MediaStoragePath property.">
	<cfargument name="MediaStoragePath" type="string" />
	<cfset variables.instance.MediaStoragePath = arguments.MediaStoragePath />
</cffunction>
<cffunction name="getMediaStoragePath" output="false" access="public"
	hint="I return the MediaStoragePath property.">
	<cfreturn variables.instance.MediaStoragePath />
</cffunction>


<!--- AudioStorageDirectory --->
<cffunction name="setAudioStorageDirectory" output="false" access="private"
	hint="I set the AudioStorageDirectory property.">
	<cfargument name="AudioStorageDirectory" type="string" />
	<cfset variables.instance.AudioStorageDirectory = arguments.AudioStorageDirectory />
</cffunction>
<cffunction name="getAudioStorageDirectory" output="false" access="public"
	hint="I return the AudioStorageDirectory property.">
	<cfreturn variables.instance.AudioStorageDirectory />
</cffunction>

<!--- ImageStorageDirectory --->
<cffunction name="setImageStorageDirectory" output="false" access="private"
	hint="I set the ImageStorageDirectory property.">
	<cfargument name="ImageStorageDirectory" type="string" />
	<cfset variables.instance.ImageStorageDirectory = arguments.ImageStorageDirectory />
</cffunction>
<cffunction name="getImageStorageDirectory" output="false" access="public"
	hint="I return the ImageStorageDirectory property.">
	<cfreturn variables.instance.ImageStorageDirectory />
</cffunction>

<!--- JavaScriptDirectory --->
<cffunction name="setJavaScriptDirectory" output="false" access="private"
	hint="I set the JavaScriptDirectory property.">
	<cfargument name="JavaScriptDirectory" type="string" />
	<cfset variables.instance.JavaScriptDirectory = arguments.JavaScriptDirectory />
</cffunction>
<cffunction name="getJavaScriptDirectory" output="false" access="public"
	hint="I return the JavaScriptDirectory property.">
	<cfreturn variables.instance.JavaScriptDirectory />
</cffunction>

<!--- Reload --->
<cffunction name="setReload" output="false" access="private"
	hint="I set the Reload property.">
	<cfargument name="Reload" type="boolean" />
	<cfset variables.instance.Reload = arguments.Reload />
</cffunction>
<cffunction name="getReload" output="false" access="public"
	hint="I return the Reload property.">
	<cfreturn variables.instance.Reload />
</cffunction>

<!--- ThePath --->
<cffunction name="setThePath" output="false" access="private"
	hint="I set the ThePath property.">
	<cfargument name="ThePath" type="string" />
	<cfset variables.instance.ThePath = arguments.ThePath />
</cffunction>
<cffunction name="getThePath" output="false" access="public"
	hint="I return the ThePath property.">
	<cfreturn variables.instance.ThePath />
</cffunction>

<!--- VideoStorageDirectory --->
<cffunction name="setVideoStorageDirectory" output="false" access="private"
	hint="I set the VideoStorageDirectory property.">
	<cfargument name="VideoStorageDirectory" type="string" />
	<cfset variables.instance.VideoStorageDirectory = arguments.VideoStorageDirectory />
</cffunction>
<cffunction name="getVideoStorageDirectory" output="false" access="public"
	hint="I return the VideoStorageDirectory property.">
	<cfreturn variables.instance.VideoStorageDirectory />
</cffunction>



<!--- MediaPropertiesXML --->
<cffunction name="setMediaPropertiesXML" access="public" output="false" returntype="void">
	<cfargument name="MediaPropertiesXML" type="xml" required="true"/>
	<cfset variables.instance.MediaPropertiesXML = arguments.MediaPropertiesXML />
</cffunction>
<cffunction name="getMediaPropertiesXML" access="public" output="false" returntype="xml">
	<cfreturn variables.instance.MediaPropertiesXML />
</cffunction>




<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>