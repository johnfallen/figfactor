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

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Fleet" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="Logger" />
	<cfargument name="Config" />

	<cfset variables.ConfigBean = arguments.Config />
	<cfset variables.logger = arguments.logger />
	<cfset variables.PageMetaData = createObject("component", "com.pagemetadata.PageMetaData").init(argumentCollection = arguments) />
	<cfset variables.MetaDataService = createObject("component", "com.metadata.MetaDataService").init(argumentCollection = arguments) />

	<cfreturn this />
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
</cfcomponent>