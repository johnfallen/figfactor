<cfcomponent 
	displayname="Data Service Test" 
	output="false" 
	hint="I am the testing cfc for the Dataservice CFC."
	extends="mxunit.framework.TestCase">

<cfset variables.FigFactor = application.FigFactor />



<!--- testSetEventConfiguredMethodData --->
<cffunction name="testSetEventConfiguredMethodData" output="false">
	
	<cfset var ff = variables.FigFactor />
	<cfset var event = 0 />
	<cfset ff.setMockCommonSpotPageRequestVariables() />
	
	<cfset event = ff.getEvent()/>

	<cfset assertIsStruct(event.getValue('dataServiceResult'), 
		"The Dataservice return was not a struct added to the event object collection.") />
	<cfset assertIsQuery(event.getValue("dataServiceResult").FakeMetaData, 
		"The FakeMetaData which shold be in the Dataservice collection wasnt there.")>
	
</cffunction>



<!--- testGetInstance --->
<cffunction name="testGetInstance" output="false">
	
	<cfset var ff = variables.FigFactor />
	<cfset var ds = ff.getBean("DataService") />
	
	<cfdump var="#ds.getInstance()#">
	
	<cfset assertIsStruct(ds.getInstance(), 
		"Opps. Dataservice variables scope is hosed. did it get created properly?") />

</cffunction>



<!--- testHasAbstractGateway --->
<cffunction name="testHasAbstractGateway" output="false">
	
	<cfset var ff = variables.FigFactor />
	<cfset var ds = ff.getBean("DataService") />
	<cfset var abstractGateway = ds.getInstance().GATEWAY />
	
	<cfset assertIsTypeOf(abstractGateway,
		"Figfactor.com.system.dataservice.com.gateway.AbstractGateway") />
	
</cffunction>
</cfcomponent>