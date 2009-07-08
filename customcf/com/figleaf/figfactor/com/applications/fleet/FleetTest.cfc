<cfcomponent 
	displayname="Fleet Test" 
	output="false" 
	hint="I am the testing cfc for the FLEET CFC."
	extends="mxunit.framework.TestCase">

<cfset variables.Fleet = application.FigFactor.getBean("Fleet") />

<!--- testGetMetaDataService --->
<cffunction name="testGetMetaDataService" output="false">
	<cfset var mds = variables.Fleet.getService("MetaDataService") />
	
	<cfset assertIsTypeOf(mds,
		"FigFactor.com.applications.fleet.com.metadata.MetaDataService") />
</cffunction>



<!--- testGetPageMetaData --->
<cffunction name="testGetPageMetaData" output="false">
	
	<cfset var ps = variables.Fleet.getService("PageMetaData") />

	<cfset assertIsTypeOf(ps,
		"FigFactor.com.applications.fleet.com.pagemetadata.PageMetaData") />
	
</cffunction>
</cfcomponent>