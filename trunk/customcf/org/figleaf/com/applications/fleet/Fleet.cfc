<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		Fleet.cfc
Author:     		John Allen
Email:      		jallen@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@
Purpose:    	I can manage all of the Fleet sub applications.
Modification Log:
Name 			Date 					Description
================================================================================
John Allen 		18/08/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Fleet" output="false"
	hint="I manage all of Fleet sub components.">

<!--- *********** Constructor ************ --->

<cfset variables.ConfigBean = 0 />
<cfset variables.MetaDataService = 0 />
<cfset variables.PageMetaData = 0 />
<cfset variables.logger = 0 />

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="any" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="BeanFactory" required="true" />
	
	<cfset variables.ConfigBean = arguments.BeanFactory.getBean("ConfigBean") />
	<cfset variables.logger = arguments.BeanFactory.getBean("logger") />
	
	<cfset initalizeCommonSpotServices(variables.ConfigBean) />

	<cfreturn this />
</cffunction>



<!--- initalizeCommonSpotServices --->
<cffunction name="initalizeCommonSpotServices" returntype="any" access="public" output="false"
	displayname="Initalize CommonSpot Services" hint="I initalize all of my child services.."
	description="I initalize all of my child services that provide FLEET functionality, extensions for CommonSpot.">
	
	<cfargument name="ConfigBean" required="true" hint="I am the ConfigBean.<br />I am required." />
	
	<cfset setMetaDataService(
		createObject("component", "com.metadata.MetaDataService").init(
		ConfigBean = arguments.ConfigBean)) />
	<cfset variables.logger.setMessage(
		message = "			FLEET: MetaDataService component initalized.") />
		
	<cfset setPageMetaData(
		createObject("component", "com.pagemetadata.PageMetaData").init(
		ConfigBean = arguments.ConfigBean)) />
	<cfset variables.logger.setMessage(
		message = "			FLEET: PageMetaData component initalized.") />
		
</cffunction>



<!--- getService --->
<cffunction name="getService" returntype="any" access="public" output="false"
	displayname="Get Fleet Service" hint="I return a sub component by name."
	description="I return one of FLEETs sub components by name.">
	
	<cfargument name="name" hint="I am the name of the Service to return.<br />I am required." />
	
	<cfswitch expression="#arguments.name#">
		<cfcase value="MetaDataService">
			<cfreturn variables.MetaDataService />
		</cfcase>
		<cfcase value="PageMetaData">
			<cfreturn variables.PageMetaData />
		</cfcase>
	</cfswitch>
	
</cffunction>


<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
<!--- setMetaDataService --->
<cffunction name="setMetaDataService" returntype="void" access="private" output="false"
	displayname="Set Meta Data Service" hint="I set the MetaDataService."
	description="I set the MetaDataService to my internal variables scope.">
	
	<cfargument name="MetaDataService" required="true" hint="I am the MetaDataService CFC.<br />I am required."  />

	<cfset variables.MetaDataService = arguments.MetaDataService />
	
</cffunction>


<!--- setPageMetaData --->
<cffunction name="setPageMetaData" returntype="void" access="private" output="false"
	displayname="Set Page Meta Data" hint="I set the PageMetaData object."
	description="I set the PageMetaData objecet to my internal variables scope.">
		
	<cfargument name="PageMetaData" required="true" hint="I am the PageMetaData CFC.<br />I am required."  />

	<cfset variables.PageMetaData = arguments.PageMetaData />
	
</cffunction>
</cfcomponent>