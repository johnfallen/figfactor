<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			MediaConverter.cfc
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		Converter
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		01/11/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Media Manager" output="false"
	hint="I manage media files. I convert them and delete them.">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="MediaManager" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="Config" type="component" required="true" 
		hint="I am the Config object.<br />I a requried." />
	<cfargument name="FileSystem" type="component" required="true" 
		hint="I am the component object.<br />I a requried." />
	
	<cfset variables.fileSystem = arguments.FileSystem />
	<cfset variables.audioStorageDirectory = arguments.config.getAudioStorageDirectory() />
	<cfset variables.imageStorageDirectory = arguments.config.getImageStorageDirectory() />
	<cfset variables.videoStorageDirectory = arguments.config.getVideoStorageDirectory() />
	<cfset variables.videoConverter = "#replace(getCurrentTemplatePath(), 'MediaManager.cfc', '')#executables/ffmpeg-15625/ffmpeg.exe" />
	<cfset variables.videoPresetsDirectory = '#replace(variables.videoConverter, '/ffmpeg.exe', '/ffpresets')#' />
	<cfset variables.encoderPreset = "libx264-normal.ffpreset" />

	<cfreturn this />
</cffunction>



<!--- convertMedia --->
<cffunction name="convertMedia" returntype="any" access="public" output="false"
	displayname="Convert Video" hint="I convert video into the configured format."
	description="I convert video into the configured format.">
		
	<cfargument name="media" type="any" required="true" 
		hint="I am the media object.<br />I am required." />
	
	<!--- do something if there is a file to proscess --->
	<cfif len(arguments.media.getMediaFile())>
		<cfswitch expression="#arguments.media.getTypeName()#">
			<cfcase value="Audio">
				<cfset convertAudio(arguments.media) />
			</cfcase>
			<cfcase value="Image">
				<cfset convertImage(arguments.media) />
			</cfcase>
			<cfcase value="Video">
				<cfset convertVideo(arguments.media) />
			</cfcase>
		</cfswitch>
	</cfif>

	<cfreturn arguments.media />
</cffunction>



<!--- deleteMedia --->
<cffunction name="deleteMedia" returntype="void" access="public" output="false"
	displayname="deleteMedia" hint="I delete a media objects associated files."
	description="I delete a media objects associated files.">
	
	<cfargument name="media" type="any" required="true" 
		hint="I am the media object.<br />I a requried." />
		
	<cfset var videoQuery = 0 />
	<cfset var origionalVideoFile = "" />
	
	<!---  
		Audio
	--->
	<cfset variables.fileSystem.delete(
		Destination = variables.audioStorageDirectory & "/",
		FileName = arguments.media.getFileName()) />
	
	<!--- 
		Images
	 --->
	<!--- icon files --->
	<cfset variables.fileSystem.delete(
		Destination = variables.imageStorageDirectory & "/",
		FileName = arguments.media.getIconFileName()) />
	
	<!--- delete the web ready files --->
	<cfset variables.fileSystem.delete(
		Destination = variables.imageStorageDirectory & "/",
		FileName = arguments.media.getPreviewFileName()) />
	
	<!--- delete the source image --->
	<cfset variables.fileSystem.delete(
		Destination = variables.imageStorageDirectory & "/origional/",
		FileName = arguments.media.getFileName()) />
	
	<!---  
		Video
	--->
	<cfset variables.fileSystem.delete(
		Destination = variables.videoStorageDirectory & "/",
		FileName = arguments.media.getFileName()) />
	
	<!--- 
	TODO:  finish up the delete origional video logic
	--->	
	<!--- query the origional video directory --->
	<cfset videoQuery = variables.FileSystem.listDirectory(
		Destination = variables.videoStorageDirectory & "/origional/") />

</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- convertAudio --->
<cffunction name="convertAudio" returntype="any" access="private" output="false"
	displayname="Convert Audio" hint="I convert audo files to the mp3 formate if nessary."
	description="I convert audo files to the mp3 formate if nessary.">
	
	<cfargument name="media" type="any" required="true" 
		hint="I am the media object.<br />I a requried." />
	<cfargument name="storageDirectory" type="any" required="true" 
		default="#variables.audioStorageDirectory#"
		hint="I am full path to the the storage directory.<br />I a requried." />

	<cfset var newName = "" />
	
	<!--- make sure the directories are there --->
	<cfset variables.fileSystem.fixDestination(arguments.storageDirectory) />

	<!--- upload the file ---> 
    <cffile 
        action="upload" 
        destination = "#arguments.storageDirectory#" 
        nameconflict="overwrite" 
        filefield="MediaFile" />

	<cfset newName = replace(cffile.SERVERFILE, " ", "_", "all")  />
	
	<!--- rename the file --->
	<cffile 
		action="rename" 
		source="#arguments.storageDirectory#/#cffile.serverFile#" 
		destination="#arguments.storageDirectory#/#newName#" />

	<!--- set the name in the object --->
	<cfset arguments.media.setFileName(newName) />

	<cfreturn arguments.media />
</cffunction>



<!--- convertImage --->
<cffunction name="convertImage" returntype="any" access="private" output="false"
	displayname="Convert Image" hint="I convert image files to the correct sizes."
	description="I convert image files to the correct sizes.">
	
	<cfargument name="media" type="any" required="true" 
		hint="I am the media object.<br />I a requried." />
	<cfargument name="storageDirectory" type="any" required="true" 
		default="#variables.imageStorageDirectory#/origional"
		hint="I am full path to the the storage directory.<br />I a requried." />
	<cfargument name="destinationDirectory" type="any" required="true" 
		default="#variables.imageStorageDirectory#"
		hint="I am full path to the the storage directory.<br />I a requried." />
	
	<cfset var newName = "" />
	<cfset var imageInfo = structNew() />
	<cfset var newImages = 0 />

	<!--- make sure the directories are there --->
	<cfset variables.fileSystem.fixDestination(arguments.destinationDirectory) />
	<cfset variables.fileSystem.fixDestination(arguments.storageDirectory) />

	<!--- upload the file ---> 
    <cffile 
        action="upload" 
        destination = "#arguments.storageDirectory#" 
        nameconflict="overwrite" 
        filefield="MediaFile" />

	<cfset newName = replace(cffile.SERVERFILE, " ", "_", "all")  />
	
	<!--- rename the file --->
	<cffile 
		action="rename" 
		source="#arguments.storageDirectory#/#cffile.SERVERFILE#" 
		destination="#arguments.storageDirectory#/#lcase(newName)#" />
	
	<!--- get the info to pass to the ImageHelper object --->
	<cfimage 
		action="info" 
		source="#arguments.storageDirectory#/#newName#" 
		structName="imageInfo" />

	<cfset newImages = makeWebImages(
		imageInfo = imageInfo,
		destinationDirectory = arguments.destinationDirectory,
		sourceFileName = newName) />

	<!--- set the names of the new image files into the object --->
	<cfset arguments.media.setFileName(lcase(newName)) />
	<cfset arguments.media.setPreviewFileName(newImages.webReadyName) />
	<cfset arguments.media.setIconFileName(newImages.thumbnailName) />

	<cfreturn arguments.media />
</cffunction>



<!--- convertVideo --->
<cffunction name="convertVideo" returntype="component" access="private" output="false"
	displayname="Convert Video" hint="I convert video files into FLV format."
	description="I accecept video files and use FFMPEG to convert them to FLV format.">
		
	<cfargument name="media" type="any" required="true" 
		hint="I am the media object.<br />I a requried." />
	<cfargument name="convertedDirectory" type="any" required="true" default="#variables.videoStorageDirectory#"
		hint="I am full path to the the storage directory.<br />I a requried." />
	<cfargument name="origionalDirectory" type="any" required="true" default="#variables.videoStorageDirectory#/origional"
		hint="I am the storage directory for uploaded video files.<br />I a requried." />
	<cfargument name="presetsDirectory" type="string" default="#variables.videoPresetsDirectory#">
	<cfargument name="encoderPreset" type="string" default="#variables.encoderPreset#">

	<cfset var newName = "" />
	<cfset var newFLVName = "" />
	
	<!--- make sure the directories are there --->
	<cfset variables.fileSystem.fixDestination(arguments.origionalDirectory) />
	
	<!--- upload the file ---> 
    <cffile 
        action="upload" 
        destination = "#arguments.origionalDirectory#" 
        nameconflict="overwrite" 
        filefield="MediaFile" />

	<cfset newName = replace(cffile.SERVERFILE, " ", "_", "all")  />
	<cfset newFLVName = replace(newName, ".", "") & ".flv" />
	
	<!--- rename the file --->
	<cffile 
		action="rename" 
		source="#arguments.origionalDirectory#/#cffile.serverFile#" 
		destination="#arguments.origionalDirectory#/#newName#" />

    <!--- convert the video ---> 
    <cfexecute 
		name = "#variables.videoConverter#" 
		arguments = '-i #arguments.origionalDirectory#/#newName# -vcodec libx264 -vpre "#arguments.presetsDirectory#/#arguments.encoderPreset#" #arguments.convertedDirectory#/#newFLVName#'
		outputFile = "#arguments.convertedDirectory#" 
		timeout = "90000000">
    </cfexecute>
   
	<!--- create the correct file name, then set it on the object ---> 
    <cfset newName = "#replace(newName, ".", "")#.flv" />
	<cfset arguments.media.setFileName(newName) />
	
    <cfreturn arguments.media /> 
</cffunction>



<!--- makeWebImages --->
<cffunction name="makeWebImages" returntype="any" access="private" output="false"
	displayname="Make Web Images" hint="I take an image and create thumbnails and a small web images."
	description="I take an image and create thumbnails and return a structure of the new image objects.">
	
	<cfargument name="imageInfo" type="struct" required="true" 
		hint="I am an images information structure (currently as created by ColdFusion).<br />I a requried." />
	<cfargument name="destinationDirectory" type="string" default="" 
		hint="I am the destination to save files to. I default to an empty string." />
	<cfargument name="sourceFileName" type="string" default="" 
		hint="I am the name of the source file. I default to an empty string." />
	
	<cfset var thumbNailImage = structNew() />
	<cfset var webReadyImage = structNew() />
	<cfset var thumbnailName = replace(lcase(arguments.sourceFileName), ".jpg", "_thumbnail.jpg") />
	<cfset var webReadyName = replace(lcase(arguments.sourceFileName), ".jpg", "_webready.jpg")/>
	<cfset var result = structNew() />
	
	<!--- icon --->
	<cfimage 
		action="read" 
		source="#arguments.imageInfo.source#" 
		name="thumbNailImage" />
	
	<cfset ImageScaleToFit(thumbNailImage, "50", "", "highQuality") />
	
	<cfif arguments.imageInfo.width lt 1000>
		<cfset ImageSharpen(thumbNailImage, 2) />
	</cfif>
	
	<cfset ImageWrite(thumbNailImage, "#arguments.destinationDirectory#/#thumbnailName#") />
	
	<!--- web ready --->	
	<cfimage 
		action="read" 
		source="#arguments.imageInfo.source#" 
		name="webReadyImage" />
	
	<cfset ImageScaleToFit(webReadyImage, "250", "", "highestQuality") />
	<cfset ImageWrite(webReadyImage, "#arguments.destinationDirectory#/#webReadyName#") />

	<cfset result.thumbnailName = thumbnailName />
	<cfset result.webReadyName = webReadyName />

	<cfreturn result />
</cffunction>
</cfcomponent>