<cfsilent>
	<!--- objects/data --->
	<cfset media = event.getValue("media") />
	<cfset figFactorConfig = event.getValue("parentConfig") />
	<cfset config = event.getValue("config") />
	<cfset videoPlayBackPath = config.getMediaStoragePath() & "/video/" />
	<cfset imagePreviewPath = config.getMediaStoragePath() & "/image/" />
	<cfset audioPath = config.getMediaStoragePath() & "/audio/" />
	<cfset DefaultFlowPlayerPath = config.getDefaultFlashVideoPlayerPath() />

	<cfif media.getIsPersisted()>
		<cfset WhatMediaTypeToDisplay = media.getParentType().getName() />
	<cfelse>
		<cfset WhatMediaTypeToDisplay = 0 />
	</cfif>
</cfsilent>


<cfoutput>
<!--- case out which player to display --->
<cfswitch expression="#WhatMediaTypeToDisplay#">

<!--- Video player --->
<cfcase value="video">
	
	<!--- are we storing video locally? --->
	<cfif figFactorConfig.getVideoPlatform() neq "external">
		<cfset currentWindowID = "currentWindowID_#createUUID()#">
		<script>
		flashembed("#currentWindowID#", 
			{src:'#DefaultFlowPlayerPath#',
				width: 320, 
				height: 240
			},
			{config: {   
					autoPlay: false,
					autoBuffering: true,
					controlBarBackgroundColor:'0x003366',
					controlBarGloss: 'none',
					initialScale: 'scale',
					<cfoutput>videoFile: '#videoPlayBackPath##media.getFileName()#'</cfoutput>
			}} );
		</script>
		
		<div id="#currentWindowID#" style="z-index:-800;"></div>
	<cfelse>
		<!--- get the url and resize it --->
		<cfset embedTag = media.getExternalURL() />
		<cfset embedTag = replace(embedTag, 'width="425"', 'width="300"', "all") />
		<cfset embedTag = replace(embedTag, 'height="344"', 'height="220"', "all") />
		<div style="width:98%;padding:5px 5px 5px 5px; border:solid 1px black;">
			#embedTag#
		</div>
	</cfif>	
</cfcase>


<!--- Image --->	
<cfcase value="image">
	<img src="#imagePreviewPath##media.getPreviewFileName()#" border="0"/>
</cfcase>


<!--- Audio --->
<cfcase value="audio">
	<script>
		$(function() {
		 $("##previewPlayer").jmp3({
			backcolor: "50a029",
			forecolor: "000000",
			width: 240,
			showdownload: "true",
			showfilename: "false"
		});
	});
	</script>
	
	<p>Listen to #media.getFileName()#:</p>
	<span id="previewPlayer" class="mp3">
		#audioPath##media.getFileName()#
	</span>
</cfcase>

<cfdefaultcase>Select Media from the Grid</cfdefaultcase>
</cfswitch>
</cfoutput>