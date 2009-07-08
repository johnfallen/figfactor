<cfcomponent displayname="FigFactorTest" extends="mxunit.framework.TestCase">

<cfset variables.FigFactor = Application.FigFactor />
<cfset variables.config = variables.FigFactor.getBean("config") />
<cfset variables.FigFactor.setMockCommonSpotPageRequestVariables() />

<!--- testGetEvent --->
<cffunction name="testGetEvent" output="false" returntype="void" hint="I get an event and should fail">
	
	<cfset var ff = variables.FigFactor />
	<cfset assertIsTypeOf(ff.getEvent(),"Figfactor.com.system.event.Event") />
	
</cffunction>



<!--- testGetBeanGoodValuePassed --->
<cffunction name="testGetBeanGoodValuePassed" output="false">
	
	<cfset var ff = variables.FigFactor />
	<cfset var config = ff.getBean("config") />	

	<cfset assertIsTypeOf(config, "viewframework.customcf.com.figleaf.figfactor.com.system.config.SystemConfigBean", "The config object is not the correct type.") />
	
</cffunction>



<!--- testGetBeanBadValuePassed --->
<cffunction name="testGetBeanBadValuePassed" output="false">
	
	<cfset var ff = variables.FigFactor />
	<cfset var config = 0 />
	<cfset var test = false />

	<!--- fail and catch, then we know its bunk which is a pass --->
	<cftry>
		<cfset test = ff.getBean("foo") />	
		<cfcatch>
			<cfset test = cfcatch />
		</cfcatch>
	</cftry>
	
	<!--- NOTE: always check what CS or the underlying IOCs string return is if this fails --->
	<cfif test.Detail eq "Bean definition for bean named: foo could not be found.">
		<cfset test = false />
	</cfif>
	
	<cfset assertFalse(test, "The result fron the cfcatch is NOT a structure, and that is weird.") />
	
</cffunction>



<!--- testMultipuleGetEventCallsAndMakeSureTheSameObjectIsAlwaysReturned --->
<cffunction name="testMultipuleGetEventCallsAndMakeSureTheSameObjectIsAlwaysReturned" output="false">
	
	<cfset var ff = variables.FigFactor />
	<cfset var e = ff.getEvent() />
	<cfset var x = 0 />
	<cfset var memento = duplicate(e) />
	<cfset var stack = arrayNew(1) />
	
	<cfloop from="1" to="3" index="x">
		<cfset arrayAppend(stack, ff.getEvent()) />
		<cfif x eq 2>
			<cfset stack[x].setValue("Super", "DuperDuper") />
		</cfif>
	</cfloop>
	
	<cfset assertSame(stack[1], e, "These are not pointing to the same memory space! YIKES!") />
	<cfset assertEquals(stack[2], memento, "Should be equal values dude!") />
	<cfset assertEquals(stack[3], memento, "after the change in the stack was forced, so something is wrong, they should be different!!") />
	
</cffunction>



<!--- testGetEvent1000Times --->
<cffunction name="testGetEvent1000Times" output="false">
	
	<cfset var ff = variables.FigFactor />
	<cfset var x = 0 />
	
	<cfloop from="1" to="1000" index="x">
		<cfset ff.getEvent() />
	</cfloop>

	<cfset assertEquals(x, 1001, "Did we do 100 calls to getEvent()?? Appears not! whast wrong?") />
			
</cffunction>



<!--- testGetBeanDefinitionList --->
<cffunction name="testGetBeanDefinitionList" output="false">
	<cfset var ff = variables.FigFactor />
	<cfset assertIsStruct(ff.GetBeanDefinitionList(), "Something is terrably wrong with the framework.") />
</cffunction>



<!--- testGetConfiguration --->
<cffunction name="testGetConfiguration" output="false">
	<cfset var ff = variables.FigFactor />
	<cfset assertIsStruct(ff.GetConfiguration(), "Something is terrably wrong with the framework.") />    </cffunction>



<!--- testGetDIProperties --->
<cffunction name="testGetDIProperties" output="false">
	<cfset var ff = variables.FigFactor />
	<cfset assertIsStruct(ff.GetDIProperties(), "Something is terrably wrong with the framework.") />    
</cffunction>



<!--- testGetFactory --->
<cffunction name="testGetFactory" output="false">

	<cfset var ff = variables.FigFactor />

	<cfset assertIsTypeOf(
			ff.GetFactory(), 
			"coldspring.beans.DefaultXMLBeanFactory", 
			"Wow! Coldspring isnt loaded! Ist all bunk!") />
			
</cffunction>



<!--- testGetFrameworkPath --->
<cffunction name="testGetFrameworkPath" output="false">
	
	<cfset var ff = variables.FigFactor />
	<cfset var test = false />
	
	<cfif len(ff.GetFrameworkPath())>
		<cfset test = true />
	</cfif>
	
	<cfset assertTrue(test, "The lenght of the framework path is null!") />
	
</cffunction>



<!--- testGetInstance --->
<cffunction name="testGetInstance" output="false">
	<cfset var ff = variables.FigFactor />
	<cfset assertIsStruct(ff.getInstance(), "Something is terrably wrong with the framework.") />
</cffunction>



<!--- testGetDIConfiguration --->
<cffunction name="testGetDIConfiguration" output="false">
	<cfset var ff = variables.FigFactor />
	<cfset assertIsStruct(ff.GetDIConfiguration(), "Something is terrably wrong with the framework.") />
</cffunction>



<!--- testGetBootstrapper --->
<cffunction name="testGetBootstrapper" output="false">
	<cfset var obj = variables.FigFactor.getBean("BootStrapper") />
	<cfset assertIsTypeOf(obj, "viewframework.customcf.com.figleaf.FigFactor.com.system.bootstrapper.BootStrapper") />
</cffunction>



<!--- testGetListService --->
<cffunction name="testGetListService" output="false">
	<cfset var obj = variables.FigFactor.getBean("ListService") />
	<cfset assertIsTypeOf(obj, "viewframework.customcf.com.figleaf.FigFactor.com.system.listservice.ListService") />
</cffunction>



<!--- testGetConfig --->
<cffunction name="testGetConfig" output="false">
	<cfset var obj = variables.FigFactor.getBean("Config") />
	<cfset assertIsTypeOf(obj, "viewframework.customcf.com.figleaf.FigFactor.com.system.config.SystemConfigBean") />
</cffunction>



<!--- testGetFileMapper --->
<cffunction name="testGetFileMapper" output="false">
	<cfset var obj = variables.FigFactor.getBean("FileMapper") />
	<cfset assertIsTypeOf(obj, "viewframework.customcf.com.figleaf.figfactor.com.system.bootstrapper.com.filemapper.FileMapper") />
</cffunction>



<!--- testGetRenderHandlerService --->
<cffunction name="testGetRenderHandlerService" output="false">	
	<cfset var obj = variables.FigFactor.getBean("RenderHandlerService") />
	<cfset assertIsTypeOf(obj, "viewframework.customcf.com.figleaf.figfactor.com.system.util.renderhandlerservice.RenderHandlerService") />
</cffunction>



<!--- testGetLogger --->
<cffunction name="testGetLogger" output="false">	
	<cfset var obj = variables.FigFactor.getBean("Logger") />
	<cfset assertIsTypeOf(obj, "viewframework.customcf.com.figleaf.figfactor.com.system.util.logger.LoggerAdapter") />
</cffunction>



<!--- testGetGoogle --->
<cffunction name="testGetGoogle" output="false">	
	<cfset var obj = variables.FigFactor.getBean("Google") />
	<cfset assertIsTypeOf(obj, "viewframework.customcf.com.figleaf.figfactor.com.applications.google.search.Google") />
</cffunction>



<!--- testGetDataService --->
<cffunction name="testGetDataService" output="false">	
	<cfset var obj = variables.FigFactor.getBean("DataService") />
	<cfset assertIsTypeOf(obj, "viewframework.customcf.com.figleaf.figfactor.com.system.dataservice.DataService") />
</cffunction>



<!--- testGetAuthentication --->
<cffunction name="testGetAuthentication" output="false">	
	<cfset var obj = variables.FigFactor.getBean("Authentication") />
	<cfset assertIsTypeOf(obj, "viewframework.customcf.com.figleaf.figfactor.com.applications.authentication.Authentication") />
</cffunction>



<!--- testGetObjectStore --->
<cffunction name="testGetObjectStore" output="false">	
	<cfset var obj = variables.FigFactor.getBean("ObjectStore") />
	<cfset assertIsTypeOf(obj, "viewframework.customcf.com.figleaf.figfactor.com.applications.objectstore.ObjectStore") />
</cffunction>



<!--- testGetSecurity --->
<cffunction name="testGetSecurity" output="false">	
	<cfset var obj = variables.FigFactor.getBean("Security") />
	<cfset assertIsTypeOf(obj, "viewframework.customcf.com.figleaf.figfactor.com.applications.security.Security") />
</cffunction>



<!--- testGetValidator --->
<cffunction name="testGetValidator" output="false">
	<cfset var obj = variables.FigFactor.getBean("Validator") />
	<cfset assertIsTypeOf(obj, "viewframework.customcf.com.figleaf.figfactor.com.applications.validator.Validator") />
</cffunction>



<!--- testGetElementFactory --->
<cffunction name="testGetElementFactory" output="false">	
	<cfset var obj = variables.FigFactor.getBean("ElementFactory") />
	<cfset assertIsTypeOf(obj, "viewframework.customcf.com.figleaf.figfactor.com.system.elementfactory.ElementFactory") />
</cffunction>



<!--- testGetEventService --->
<cffunction name="testGetEventService" output="false">	
	<cfset var obj = variables.FigFactor.getBean("EventService") />
	<cfset assertIsTypeOf(obj, "viewframework.customcf.com.figleaf.figfactor.com.system.event.EventService") />
</cffunction>


<!--- testGetFileSystem --->
<cffunction name="testGetFileSystem" output="false">	
	<cfset var obj = variables.FigFactor.getBean("FileSystem") />
	<cfset assertIsTypeOf(obj, "Figfactor.com.system.util.filesystem.FileSystem") />
</cffunction>



<!--- testGetUDF --->
<cffunction name="testGetUDF" output="false">	
	<cfset var obj = variables.FigFactor.getBean("UDF") />
	<cfset assertIsTypeOf(obj, "viewframework.customcf.com.figleaf.figfactor.com.system.util.udf.UDFLib") />
</cffunction>



<!--- testGetLegacy --->
<cffunction name="testGetLegacy" output="false">	
	<cfset var obj = variables.FigFactor.getBean("Legacy") />
	<cfset assertIsTypeOf(obj, "viewframework.customcf.com.figleaf.figfactor.com.system.legacy.Legacy") />
</cffunction>
</cfcomponent>