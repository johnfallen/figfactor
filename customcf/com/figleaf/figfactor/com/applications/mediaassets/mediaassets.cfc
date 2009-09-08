<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		mediaassets.cfc
Author:     		Michael Chavez III
Email:      		mchavez@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@
Purpose:    	I can manage all of the Media Assets sub applications.
Modification Log:
Name 				Date 					Description
================================================================================
Michael Chavez III 	23/03/2009				Created
------------------------------------------------------------------------------->
<cfcomponent displayname="mediaassets" output="false">
		<!--- init --->
        <cffunction name="init" returntype="any" access="public" output="false"
            displayname="Init" hint="I am the constructor."
            description="I am the pseudo constructor for this CFC. I return an instance of myself.">

			<cfargument name="Logger" />
			<cfargument name="Config" />

			<cfset variables.ConfigBean = arguments.Config />
			<cfset variables.logger = arguments.logger />

            <cfset initalizeFileAssetsServices(variables.ConfigBean) />

            <cfreturn this />
        </cffunction>



<!--- initalizeCommonSpotServices --->
<cffunction name="initalizeFileAssetsServices" returntype="any" access="public" output="false"
	displayname="Initalize File Asset Services" hint="I initalize all of my child services.."
	description="I initalize all of my child services that provide File Asset functionality, extensions for CommonSpot.">

	<cfargument name="ConfigBean" required="true" hint="I am the ConfigBean.<br />I am required." />

	<cfset setFileAssets(
		createObject("component", "com.fileassets.fileassets").init(
		ConfigBean = arguments.ConfigBean)) />
	 <cfset variables.logger.setMessage(
		message = "			Media Assets: fileAssets component initalized.") />

	<cfset setfileAssetsCategory(
		createObject("component", "com.fileassetscategory.fileassetscategory").init(
		ConfigBean = arguments.ConfigBean)) />
	 <cfset variables.logger.setMessage(
		message = "			Media Assets: fileAssetsCategory component initalized.") />

</cffunction>
<!--- getService --->
<cffunction name="getService" returntype="any" access="public" output="false"
	displayname="Get Fleet Service" hint="I return a sub component by name."
	description="I return one of File Asset sub components by name.">

	<cfargument name="name" hint="I am the name of the Service to return.<br />I am required." />

	<cfswitch expression="#arguments.name#">
		<cfcase value="FileAssets">
			<cfreturn variables.FileAssets />
		</cfcase>
		<cfcase value="fileAssetCategory">
			<cfreturn variables.fileAssetCategory />
		</cfcase>
	</cfswitch>

</cffunction>


<!--- *********** Private *********** --->
<!--- setMetaDataService --->
<cffunction name="setFileAssets" returntype="void" access="private" output="false"
	displayname="Set File Assets" hint="I set the fileAssets."
	description="I set the setFileAssets to my internal variables scope.">

	<cfargument name="FileAssets" required="true" hint="I am the FileAssets CFC.<br />I am required."  />

	<cfset variables.FileAssets = arguments.FileAssets />

</cffunction>


<!--- setPageMetaData --->
<cffunction name="setFileAssetsCategory" returntype="void" access="private" output="false"
	displayname="Set File Assets Category" hint="I set the FileAssetsCategory object."
	description="I set the FileAssetsCategory objecet to my internal variables scope.">

	<cfargument name="fileAssetCategory" required="true" hint="I am the FileAssetsCategory CFC.<br />I am required."  />

	<cfset variables.fileAssetCategory = arguments.fileAssetCategory />

</cffunction>
</cfcomponent>

