<cfset tests = createObject("component", "mxunit.framework.TestSuite").TestSuite() />

<cfset tests.addAll("viewframework.customcf.com.figleaf.figfactor.FigFactorTest") />
<cfset tests.addAll("viewframework.customcf.com.figleaf.figfactor.com.system.event.EventServiceTest") />
<cfset tests.addAll("viewframework.customcf.com.figleaf.figfactor.com.system.event.EventTest") />
<cfset tests.addAll("viewframework.customcf.com.figleaf.figfactor.com.system.dataservice.DataserviceTest") />
<cfset tests.addAll("viewframework.customcf.com.figleaf.figfactor.com.system.elementfactory.ElementFactoryTest") />
<cfset tests.addAll("viewframework.customcf.com.figleaf.figfactor.com.system.listservice.ListServiceTest") />
<cfset tests.addAll("viewframework.customcf.com.figleaf.figfactor.com.system.util.filesystem.FileSystemTest") />
<cfset tests.addAll("viewframework.customcf.com.figleaf.figfactor.com.system.util.collections.TestMapCollectionImplementation") />
<cfset tests.addAll("viewframework.customcf.com.figleaf.figfactor.com.applications.fleet.FleetTest") />

<cfset results = tests.run() />

<cfoutput>#results.getResultsOutput("extjs")#</cfoutput>