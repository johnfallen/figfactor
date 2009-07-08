<cfcomponent displayname="List ServiceTest"
	hint="I am the MXUnit testing CFC for the ListService CFC"
	output="false" 
	extends="mxunit.framework.TestCase">


<cfset variables.ls = application.FigFactor.getBean("ListService") />

<!--- testSetAndGetList --->
<cffunction name="testSetAndGetList" output="false">
	
	<cfset var ls = variables.ls />
	<cfset var testList = "this,is,a,test,list">
	
	<cfset ls.setList("testList", testList) />
	
	<cfset assertEquals(testList, ls.getList("testList"), "Nope they are not the same") />
	
</cffunction>



<!--- testGetListGoodValuePassed --->
<cffunction name="testGetListGoodValuePassed" output="false">
		
	<cfset var ls = variables.ls />
	
	<cfset assertEquals(listFirst(ls.getList("states")), "AL", "States list didnt come back correctly.") />
	
</cffunction>



<!--- testGetListBadValuePassed --->
<cffunction name="testGetListBadValuePassed" output="false">
	
	<cfset var ls = variables.ls />
	
	<cfset assertEquals(listLen(ls.getList("foo")), 0, "Something came back for a requested list called foo.")>
</cffunction>



<!--- testGetAllLists --->
<cffunction name="testGetAllLists" output="false">
	<cfset var result = variables.ls.getAllLists() />
	
	<cfset assertIsStruct(result, "GetAllLists didnt return a named struct of lists!")>
</cffunction>



<!--- testGetInstance --->
<cffunction name="testGetInstance" output="false">

	<cfset assertIsStruct(variables.ls.getInstance(), "GetAllLists didnt return a named struct of lists!") />
	
</cffunction>
</cfcomponent>