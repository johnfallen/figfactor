<!--- -------------------------------------------------------------------------------------------------------------------

Filename: /mediaAssets/Previewcfm

Creation Date: May 2004

Author: Steve Drucker (sdrucker@figleaf.com)
Fig Leaf Software (www.figleaf.com)

Purpose:
Displays a media asset

Call Syntax:
Pass in ID of file asset to display

Other:
Uses global function to determine url path to asset

Modification Log:
=====================================
01/02/2005 sdrucker	updated documentation

-------------------------------------------------------------------------------------------------------------------  --->


<cftry>
<cfset Application.mediassets = application.beanfactory.getBean("mediaassets") />

<cfset _fileAssets = Application.mediassets.getService("FileAssets") />
<cfset config = application.beanfactory.getBean("ConfigBean") />
<cfset application.figleaf.url = config.getFigLeafFileContext() & "/"/>
<cfset request.scoperedirect = "/standards-gov/customcf/scoperedirect.cfm" />

<!--- <cfset factory = Application.BeanFactory.getBean("BeanFactory") />
<cfset config = factory.getBean("ConfigBean") />
<cfset application.figleaf.url = config.getFigLeafFileContext() & "/"/>
<cfset request.scoperedirect = "/customcf/scoperedirect.cfm" /> --->
<cfset dsn = config.getCommonSpotSupportDSN() />
<!--- get file assets associated with article object --->

<cfquery name="qgetfile" datasource="#dsn#">
   {call fileasset_get (#url.id#)}
</cfquery>

<!---<cfquery name="qassetsMedia" datasource="#dsn#">
	{call FileAsset_GetByPageId (#qgetfile.siteid#,#url.id#)}
</cfquery>

<cfquery name="qgetsitename" datasource="commonspot-sites">
   select sitename
   from serversites
   where siteid=#qgetfile.siteid#
</cfquery>

<cfset theurl = application.globalfunctions.mediaAssetPath(qgetsitename.sitename,qgetfile.begintime,qgetfile.filetype,listlast(qgetfile.fullpath,"/"))>

--->

<cfoutput>
<html>
<head>
<script src="/scripts/AC_RunActiveContent.js" type="text/javascript"></script>
<link rel="stylesheet" href="/ui/css/social_networking.css" type="text/css" />
<link rel="stylesheet" href="/ui/css/photo-gallery.css" type="text/css" />
<script type="text/javascript" src="/scripts/menu_ie6.js"></script>
<SCRIPT type='text/javascript' src="/scripts/jquery-1.3.2.min.js"></SCRIPT>
<script type="text/javascript" src="/scripts/jquery-ui-1.7.custom.min.js"></script>
<script type="text/javascript" src="/scripts/aqLayer.js"></script>
<script type="text/javascript" src="/scripts/jquery.jmp3.js"></script>
<script type="text/javascript" src="/scripts/flowplayer-3.0.6.min.js"></script>
<script type="text/javascript" src="/scripts/jquery.galleriffic.js"></script>
</head>
<body>
<cfif qgetfile.recordcount GT 0 >
    	<!--- static text until we get more content --->
        <cfloop query="qgetfile" startrow="1" endrow="1">
            <cfif filetype EQ "Audio">
				<cfset fp = len(fullpath) />
                <cfset fp = fp - 41 />
            	<cfset maURL = mid(fullpath,50,40) />

				<script type="text/javascript">
                    $(document).ready(function(){
                        // custom options
                        $("##mysong").jmp3({
                            filepath: "#maURL#",
                            showfilename: "false",
                            backcolor: "D5C6A5",
                            forecolor: "330000",
                            width: 200,
                            showdownload: "true"
                        });
                    });
                </script>
                <div id="rightColCaption"><div id="mysong">#filename#</div><br /><b>#filedescription#</b>
            <cfelseif filetype EQ "Streaming">
            	<div id="rightColCaption">
                <a href="#fullpath#"
                   style="display:block;width:199px;height:152px;"
                   id="player">
                </a><br /><b>#filedescription#</b>
                <script language="JavaScript">
					flowplayer("player", "/ui/flowplayer/flowplayer-3.0.7.swf", {
						clip:  {
							autoPlay: false,
							autoBuffering: true
						}
					});
				</script>
            <cfelse>
            	<div id="rightColCaption">#filename#<br /><b>#filedescription#</b>
            </cfif>
        <!--- dynamic content --->
        <cfif qgetfile.recordcount GT 1>
        	<br /><br /><a href="/press/multimedia/index.cfm">More</a>
        </cfif>
        </div>
        </cfloop>
    </cfif>
</body>
</html>
</cfoutput>
<cfcatch type="any">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>