<!--- needed for the media manager --->
<cfajaximport tags="cfwindow,cfgrid,cfdiv,cfform,cfpod,cfmenu"/>
<cfset attributes.rendermode = "Value" />
<cfset config = application.FigFactor.getBean("config") />
<cfset myself = config.getFigleafFileContext() & "/com/applications/multimedia/index.cfm?event=" />
<cfset xe.commonSpotEntryPoint = "commonspot.customfield.entry.point" />
<cfset MediaManagementGroupID = application.FigFactor.getBean("ConfigBean").getMediaManagementGroupID() />

<!--- default the user to a non manager value --->
<cfset userType = "user" />

<!--- get some values from the request scope --->
<cfset dsn = request.user.USERSDATASOURCE />
<cfset IDPage = request.page.id />
<cfset IDUser = request.user.userid />

<!--- get the user by login ID --->
<cfquery name="getUser" datasource="#request.site.usersdatasource#">
	select *
	from users 
	where UserID = '#IDUser#'
</cfquery>

<!--- get the groups the user belongs to --->
<cfquery name="getUserGroups" datasource="#request.site.usersdatasource#">
	select *
	from UserGroup
	where UserID = #getUser.id#
</cfquery>

<!--- check if the user will have media management rights --->
<cfif listContains(valueList(getUserGroups.GroupID), MediaManagementGroupID)>
	<cfset userType = "manager" />
</cfif>


<!--- save this to the head of the HTML document --->
<cfsavecontent variable="htmlheadstuff">
<script>
function load() {
   ColdFusion.navigate('index.cfm','mulitMediaApplication');
}
</script>
</cfsavecontent>
<cfhtmlhead text="#htmlheadstuff#">


<cfoutput>
<div id="makeSizedForMultiMediaBrowser" style="height:550px; width:685px;">
<cfdiv 
	id="mulitMediaApplication" 
	bind="url:#myself##xe.commonSpotEntryPoint#&IDPage=#IDPage#&IDUser=#IDUser#&userType=#userType#&init=true" />
	<cfset ajaxOnLoad('load') />
</div>
</cfoutput>