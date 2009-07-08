<cfcomponent displayname="EventServiceTest" extends="mxunit.framework.TestCase">

<cfset variables.FigFactor = application.FigFactor />
<cfset variables.config = variables.FigFactor.getBean("config") />
<cfset variables.FigFactor.setMockCommonSpotPageRequestVariables() />

<!--- testGetEvent --->
<cffunction name="testGetEvent" returntype="void" hint="I get an event and should fail">
	
	<cfset var ff = variables.FigFactor />
	<cfset var event = ff.getEvent() />
	
	<cfset assertIsTypeOf(event,"Figfactor.com.system.event.Event") />
	
</cffunction>


<!--- testGetEvent5000Times --->
<cffunction name="testGetEvent5000Times" returntype="void" hint="I get an event and should fail">
	
	<cfset var ff = variables.FigFactor />
	<cfset var event = ff.getEvent() />
	<cfset var event5000 = 0 />
	<cfset var x = 0 />
	
	<cfloop from="1" to="5000" index="x">
		<cfset event5000 = ff.getEvent() />
	</cfloop>
	
	<cfset assertIsTypeOf(event5000,"Figfactor.com.system.event.Event", 
		"The event object returned from the service is not the correct type.") />
	<cfset assertEquals(event, event5000, 
		"Event and Event5000 should be the same values, even same memory space.") />
	
</cffunction>


<!--- testGetMockEvent --->
<cffunction name="testGetMockEvent" returntype="void" hint="I check if the Event returned is of a specific type">
	<cfset var event = variables.FigFactor.getBean("EventService").getMockEvent() />
	<cfset assertIsTypeOf(event,"Figfactor.com.system.event.MockEvent") />
</cffunction>
</cfcomponent>