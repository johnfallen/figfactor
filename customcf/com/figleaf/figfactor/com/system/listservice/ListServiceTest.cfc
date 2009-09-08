<cfcomponent displayname="List ServiceTest"
	hint="I am the MXUnit testing CFC for the ListService CFC"
	output="false" 
	extends="mxunit.framework.TestCase">

<cfset variables.ls = application.FigFactor.getBean("ListService") />

<!--- testSetAndGetList --->
<cffunction name="testSetAndGetList" output="false">
	
	<cfset var ls = variables.ls />
	<cfset var testList = "this,is,a,test,list" />
	
	<cfset ls.removeList("testList") />
	<cfset ls.setList("testList", testList) />
	
	<cfset assertEquals(testList, ls.getList("testList"), "Nope they are not the same") />
	
	<!--- clean up --->
	<cfset ls.removeList("testList") />
	
</cffunction>



<!--- testAddListTwiceThrowsError --->
<cffunction name="testAddListTwiceThrowsError" output="false">
	
	<cfset var ls = variables.ls />
	<cfset var testList = "this,is,a,test,list" />
	<cfset var result = false />
	
	<cfset ls.removeList("testList") />
	
	<cfset assertTrue(ls.removeList("testList"), "the list was not removed from the mapcollection") />
	
	<cfset ls.setList("testList", testList) />
	
	<cftry>
		<cfset ls.setList("testList", testList) />
		<cfcatch><cfset result = true /></cfcatch>
	</cftry>
	
	<cfset assertTrue(result, "NO! the value got set twice!") />
</cffunction>



<!--- testGetListGoodValuePassed --->
<cffunction name="testGetListGoodValuePassed" output="false">
		
	<cfset var ls = variables.ls />
	
	<cfset assertEquals(listFirst(ls.getList("states")), "AL", "States list didnt come back correctly.") />
	
</cffunction>



<!--- testGetListBadValuePassed --->
<cffunction name="testGetListBadValuePassed" output="false">
	
	<cfset assertEquals(listLen(variables.ls.getList("foo")), 0, 
		"Something came back for a requested list called foo.") />
</cffunction>



<!--- testGetAllLists --->
<cffunction name="testGetAllLists" output="false">
	<cfset assertIsStruct(variables.ls.getAllLists(), "GetAllLists didnt return a named struct of lists!")>
</cffunction>



<!--- testGetInstance --->
<cffunction name="testGetInstance" output="false">

	<cfset assertIsStruct(variables.ls.getInstance(), "GetAllLists didnt return a named struct of lists!") />
	
</cffunction>



<!--- testRemoveList --->
<cffunction name="testRemoveList" output="false">
	
	<cfset var ls = variables.ls />
	<cfset var testListName = "RandomTestListNameThatShouldBeUnique#createUUID()#" />
	<cfset var testListWhichShouldBeUnique = "this,ohhh,please,be,unique,#createUUID()#,is,a,test,list" />
	<cfset var theTest = false />
	
	<cfset ls.setList("#testListName#", testListWhichShouldBeUnique) />
	
	<cfset assertTrue(ls.removeList("#testListName#"), "The randomly added list by was NOT removed!") />

</cffunction>
</cfcomponent>