<cfcomponent displayname="Element Factory Test"
	hint="I am the MXUnit testing CFC for the ElementFactory CFC"
	output="false" 
	extends="mxunit.framework.TestCase">

<cfset variables.FigFactor = Application.FigFactor />
<cfset variables.ElementFactory = variables.FigFactor.getBean("ElementFactory") />


<!--- testGetAll --->
<cffunction name="testGetAll" output="false">

	<cfset var ef = variables.ElementFactory />
	<cfset var elements = ef.getAll()/>

	<cfset assertIsStruct(elements, "The output was NOT a struct and it should be.") />

</cffunction>



<!--- testGetAllReturnsOnlyElementObjects --->
<cffunction name="testGetAllReturnsOnlyElementObjects" output="false">

	<cfset var ef = variables.ElementFactory />
	<cfset var elements = ef.getAll()/>
	<cfset var x  = 0 />	

	<cfloop collection="#elements#" item="x">
		<cfset assertIsTypeOf(elements[x],"Figfactor.com.system.elementfactory.com.Element") />
	</cfloop>

</cffunction>



<!--- testGetElementNamePassed --->
<cffunction name="testGetElementNamePassed" output="false">
	
	<cfset var ef = variables.ElementFactory />
	<cfset var element = ef.getElement(name = "Blank Page") />
	
	<cfset assertIsTypeOf(element,"Figfactor.com.system.elementfactory.com.Element") />

</cffunction>



<!--- testGetElementNameNotPassed --->
<cffunction name="testGetElementNameNotPassedElement" output="false">
	
	<cfset var ef = variables.ElementFactory />
	<cfset var element = ef.getElement(name = "") />
	
	<cfset assertIsTypeOf(element,"Figfactor.com.system.elementfactory.com.Element") />

</cffunction>



<!--- testGetElementBadNamePassedElement --->
<cffunction name="testGetElementBadNamePassedElement" output="false">
	
	<cfset var ef = variables.ElementFactory />
	<cfset var element = ef.getElement(name = "foo") />
	
	<cfset assertIsTypeOf(element,"Figfactor.com.system.elementfactory.com.Element") />

</cffunction>



<!--- testGetInstance --->
<cffunction name="testGetInstance" output="false">
	<cfset var ef = variables.ElementFactory />
	<cfset assertIsStruct(ef.getInstance(), "The output was NOT a struct and it should be.")>
</cffunction>


</cfcomponent>