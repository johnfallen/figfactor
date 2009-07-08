<cfcomponent displayname="Event Test" extends="mxunit.framework.TestCase">

<cfset variables.FigFactor = application.FigFactor />
<cfset variables.config = variables.FigFactor.getBean("config") />
<cfset variables.FigFactor.setMockCommonSpotPageRequestVariables() />

<!--- testInit --->
<cffunction name="testInit" returntype="void" hint="I check if the Event initalizes corretly.">

	<cfset var ff = variables.FigFactor />
	<cfset var event = ff.getEvent() />
	
	<cfset assertIsTypeOf(event,"Figfactor.com.system.event.Event") />
	
</cffunction>



<!--- testGetAndSetValue --->
<cffunction name="testGetAndSetValue" 
	hint="I set a value single value and check if it is returned and the same value.">

	<cfset var ff = variables.FigFactor />
	<cfset var event = ff.getEvent() />
	<cfset var testValue = "#hash(getCurrentTemplatePath())#" />

	<cfset event.setValue("testValue", testValue) />

	<cfset assertEquals(event.getValue("testValue"), testValue, "Nope! Not the same.")>		
</cffunction>



<!--- testGetAllValues --->
<cffunction name="testGetAllValues" hint="I test if getAllValues function returns a structure as it should.">
	
	<cfset var ff = variables.FigFactor />
	<cfset var event = ff.getEvent() />
	<cfset var theValues = event.getSubSiteDefinition()>
	
	<cfset assertIsStruct(theValues) />
	
</cffunction>



<!--- testGetCustomElementName --->
<cffunction name="testGetCustomElementName" output="false">

	<cfset var ff = variables.FigFactor />
	<cfset var event = ff.getEvent() />
	
	<cfset assertTrue(len(event.getCustomElementName()), 
		"The Custome Element name has not been set. This is bad. Many things look for it.") />

</cffunction>



<!--- testGetAndSetStructWithMerge --->
<cffunction name="testGetAndSetStructWithMerge" 
	hint="I add a structure using setValue and check if it overwrote the current values.">

	<cfset var ff = variables.FigFactor />
	<cfset var event = ff.getEvent() />
	<cfset var testValue = structNew() />
	<cfset var valueMemento = duplicate(event.getAllValues()) />
	
	<cfset testValue.ranQueries = "NO" />
	<cfset testValue.pageMetaDataIDs = "999" />
	<cfset testValue.superDuperJFA = "SuperDuperJFA" />
	
	<!--- test that we overwrote values --->
	<cfset event.setValue("testValue", testValue) />
	<cfset assertNotSame(event.getAllValues(), valueMemento, "Nope! They are the same.") />
	
	<!--- test we overwrite one value --->	
	<cfset event.setValue("superDuperJFA", "failThisTest") />
	<cfset assertNotSame(event.getValue("superDuperJFA"), testValue.superDuperJFA, "Nope! They are the same.") />
	
</cffunction>



<!--- testGetInstance --->
<cffunction name="testGetInstance" 
	hint="I check if the return from getInstance is a struct.">
	
	<cfset var ff = variables.FigFactor />
	<cfset var event = ff.getEvent() />
	<cfset assertIsStruct(event.getInstance()) />
	
</cffunction>



<!--- testURLAndFORMLoading --->
<cffunction name="testURLAndFORMLoading" 
	hint="I set values to the URL and FORM scopes.">
	
	<cfset var ff = variables.FigFactor />
	<cfset var event = ff.getEvent() />
	
	<!--- test values are set in the constructor section of this CFC --->
	<cfset assertNotSame(URL._eventFormInputTest2, event.getValue("_eventFormInputTest2"), "They SHould be different, the INPUT isnt overriding with the correct presidence.")/ >
	
</cffunction>



<!--- testURLAndFORMMerging --->
<cffunction name="testURLAndFORMMerging" 
	hint="I set values to the URL and FORM scopes.">
	
	<cfset var ff = variables.FigFactor />
	<cfset var event = ff.getEvent() />
	
	<!--- test values are set in the constructor section of this CFC --->
	<cfset assertEquals(URL._eventURLInputTest2, event.getValue("_eventURLInputTest2"), "They should be the same.") />
	
</cffunction>



<!--- testSubSiteDefinitionCount --->
<cffunction name="testSubSiteDefinitionCount" 
	hint="I check if the return from getSubSiteDefinition is the correct count.">
	
	<cfset var ff = variables.FigFactor />
	<cfset var event = ff.getEvent() />
	<cfset var subSiteDef = event.getSubSiteDefinition() />
	<cfset var subSiteDefLen = "4" />
	
	<cfset assertEquals(structCount(subSiteDef), subSiteDefLen, "The len is incorrect.") />

</cffunction>



<!--- testSubSiteDefinitionKeys --->
<cffunction name="testSubSiteDefinitionKeys" 
	hint="I check if the return from getSubSiteDefinition is the correct count.">
	
	<cfset var ff = variables.FigFactor />
	<cfset var event = ff.getEvent() />
	<cfset var subSiteDef = event.getSubSiteDefinition() />

	<cfset assertTrue(structKeyExists(subSiteDef, "CSSClassName"), true, "The CSSCLASSNAME is not around.") />
	<cfset assertTrue(structKeyExists(subSiteDef, "DISPLAYNAME"), true, "The DISPLAYNAME is not around.") />
	<cfset assertTrue(structKeyExists(subSiteDef, "NAME"), true, "The NAME is not around") />
	<cfset assertTrue(structKeyExists(subSiteDef, "PARENTNAME"), true, "The PARENTNAME is not around") />

</cffunction>



<!--- testGetListKnownValueRequested --->
<cffunction name="testGetListKnownValueRequested" output="false">
	
	<cfset var ff = variables.FigFactor />
	<cfset var states = ff.getList("states") />
	
	<cfset assertTrue(listLen(states), "The value returned was null and i should be a list of states") />
	
</cffunction>


<!--- testGetListUnknownValueRequested --->
<cffunction name="testGetListUnknownValueRequested" output="false">
	
	<cfset var ff = variables.FigFactor />
	<cfset var states = ff.getList("foo") />
	
	<cfset assertFalse(listLen(states), "The value returned has a len. Something wrong.") />
	
</cffunction>
</cfcomponent>