<cfcomponent output="false" hint="I configure the Model-Glue framework's runtime environment.">

<cffunction name="init" output="false">
    <cfset variables._instance.defaultEvent = "Home" />
    <cfset variables._instance.missingEvent = "page.missing" />
    <cfset variables._instance.reload = "true" />
    <cfset variables._instance.debug = "true" />
    <cfset variables._instance.reloadPassword = "true" />
    <cfset variables._instance.applicationMapping = "" />
    <cfset variables._instance.viewMappings = arrayNew(1) />
    <cfset variables._instance.helperMappings = "" />
    <cfset variables._instance.primaryModule = "" />
    <cfset variables._instance.primaryModuleType = "XML.Gesture" />
    <cfset variables._instance.reloadKey = "init" />
    <cfset variables._instance.eventValue = "event" />
    <cfset variables._instance.defaultTemplate = "index.cfm" />
    <cfset variables._instance.defaultExceptionHandler = "Exception" />
    <cfset variables._instance.defaultCacheTimeout = "5" />
	<cfset variables._instance.requestFormatValue = "html" />
		
		<!--- Generation --->
		<cfset variables._instance.generationEnabled = false />
		<cfset variables._instance.generationModule = "" />
		<cfset variables._instance.generationControllerPath = "" />
		<cfset variables._instance.generationViewPath = "" />
		
    <cfreturn this />
</cffunction>

<cffunction name="getInstance" returntype="struct" output="false">
	<cfreturn structCopy(variables._instance) />
</cffunction>

<cffunction name="setDefaultEvent" returntype="void" output="false" access="public">
	<cfargument name="DefaultEvent" type="string" />
	<cfset variables._instance.DefaultEvent = arguments.Defaultevent />
</cffunction>
<cffunction name="getDefaultEvent" returntype="string" output="false">
	<cfreturn variables._instance.DefaultEvent />
</cffunction>

<cffunction name="setMissingEvent" returntype="void" output="false" access="public">
	<cfargument name="MissingEvent" type="string" />
	<cfset variables._instance.MissingEvent = arguments.Missingevent />
</cffunction>
<cffunction name="getMissingEvent" returntype="string" output="false">
	<cfreturn variables._instance.MissingEvent />
</cffunction>

<cffunction name="setReload" returntype="void" output="false" access="public">
	<cfargument name="Reload"  type="boolean" />
	<cfset variables._instance.Reload = arguments.Reload />
</cffunction>
<cffunction name="getReload" returntype="boolean" output="false">
	<cfreturn variables._instance.Reload />
</cffunction>

<cffunction name="setRescaffold" returntype="void" output="false" access="public">
	<cfargument name="Rescaffold"  type="boolean" />
	<cfset variables._instance.Rescaffold = arguments.Rescaffold />
</cffunction>
<cffunction name="getRescaffold" returntype="boolean" output="false">
	<cfreturn variables._instance.Rescaffold />
</cffunction>

<cffunction name="setRescaffoldKey" returntype="void" output="false" access="public">
	<cfargument name="RescaffoldKey"  type="string" />
	<cfset variables._instance.RescaffoldKey = arguments.RescaffoldKey />
</cffunction>
<cffunction name="getRescaffoldKey" returntype="string" output="false">
	<cfreturn variables._instance.RescaffoldKey />
</cffunction>

<cffunction name="setApplicationPath" returntype="void" output="false" access="public">
	<cfargument name="ApplicationPath"  type="string" />
	<cfset variables._instance.ApplicationPath = arguments.ApplicationPath />
	<cfif not len(getGenerationControllerPath())>
		<cfset setGenerationControllerPath(arguments.applicationPath & "/controller") />
	</cfif>
</cffunction>
<cffunction name="getApplicationPath" returntype="string" output="false">
	<cfreturn variables._instance.ApplicationPath />
</cffunction>

<cffunction name="setRescaffoldPassword" returntype="void" output="false" access="public">
	<cfargument name="RescaffoldPassword"  type="string" />
	<cfset variables._instance.RescaffoldPassword = arguments.RescaffoldPassword />
</cffunction>
<cffunction name="getRescaffoldPassword" returntype="string" output="false">
	<cfreturn variables._instance.RescaffoldPassword />
</cffunction>

<cffunction name="setDebug" returntype="void" output="false" access="public">
	<cfargument name="Debug"  type="string"/>
	
	<cfif arguments.debug eq "true">
		<cfset arguments.debug = "verbose" />
	</cfif>
	
	<cfif arguments.debug eq "false">
		<cfset arguments.debug = "none" />
	</cfif>
	
	<cfif not listFindNoCase("verbose,trace,none", arguments.debug)>
		<cfthrow message="The ""debug"" property must be set to ""verbose"", ""trace"", or ""none""." />
	</cfif>
	
	<cfset variables._instance.Debug = arguments.Debug />
</cffunction>

<cffunction name="getDebug" returntype="string" output="false">
	<cfreturn variables._instance.Debug />
</cffunction>

<cffunction name="setReloadPassword" returntype="void" output="false" access="public">
	<cfargument name="ReloadPassword" type="string" />
	<cfset variables._instance.ReloadPassword = arguments.ReloadPassword />
</cffunction>
<cffunction name="getReloadPassword" returntype="string" output="false">
	<cfreturn variables._instance.ReloadPassword />
</cffunction>

<cffunction name="setViewMappings" returntype="void" output="false" access="public">
	<cfargument name="ViewMappings" type="string" />
	<cfset variables._instance.ViewMappings = listToArray(arguments.ViewMappings) />
	<cfif not len(getGenerationViewPath())>
		<cfset setGenerationViewPath(listFirst(arguments.viewMappings)) />
	</cfif>
</cffunction>
<cffunction name="getViewMappings" returntype="array" output="false">
	<cfreturn variables._instance.ViewMappings />
</cffunction>

<cffunction name="setHelperMappings" returntype="void" output="false" access="public">
	<cfargument name="HelperMappings" type="string" />
	<cfset variables._instance.HelperMappings = arguments.HelperMappings />
</cffunction>
<cffunction name="getHelperMappings" returntype="string" output="false">
	<cfreturn variables._instance.HelperMappings />
</cffunction>

<cffunction name="setGeneratedViewMapping" returntype="void" output="false" access="public">
	<cfargument name="GeneratedViewMapping" type="string" />
	<cfset variables._instance.GeneratedViewMapping = arguments.GeneratedViewMapping />
</cffunction>
<cffunction name="getGeneratedViewMapping" returntype="string" output="false">
	<cfreturn variables._instance.GeneratedViewMapping />
</cffunction>

<cffunction name="setConfigurationPath" returntype="void" output="false" access="public" hint="Deprecated in favor of setPrimaryModule.  Included for Unity reverse compatibility.">
	<cfargument name="PrimaryModule" type="string" />
	<cfset setPrimaryModule(arguments.primaryModule) />
</cffunction>
<cffunction name="setPrimaryModule" returntype="void" output="false" access="public">
	<cfargument name="PrimaryModule" type="string" />
	<cfset variables._instance.PrimaryModule = arguments.PrimaryModule />
	<cfif not len(variables._instance.GenerationModule)>
		<cfset setGenerationModule(arguments.PrimaryModule) />
	</cfif>
</cffunction>
<cffunction name="getPrimaryModule" returntype="string" output="false">
	<cfreturn variables._instance.PrimaryModule />
</cffunction>

<cffunction name="setGenerationConfigurationPath" returntype="void" output="false" access="public">
	<cfargument name="GenerationModule" type="string" />
	<cfset setGenerationModule(arguments.GenerationModule) />
</cffunction>
<cffunction name="setGenerationModule" returntype="void" output="false" access="public">
	<cfargument name="GenerationModule" type="string" />
	<cfset variables._instance.GenerationModule = arguments.GenerationModule />
</cffunction>
<cffunction name="getGenerationModule" returntype="string" output="false">
	<cfif not len(variables._instance.generationModule)>
		<cfreturn getPrimaryModule() />
	<cfelse>
		<cfreturn variables._instance.GenerationModule />
	</cfif>
</cffunction>


<cffunction name="setPrimaryModuleType" returntype="void" output="false" access="public">
	<cfargument name="PrimaryModuleType" type="string" />
	<cfset variables._instance.PrimaryModuleType = arguments.PrimaryModuleType />
</cffunction>
<cffunction name="getPrimaryModuleType" returntype="string" output="false">
	<cfreturn variables._instance.PrimaryModuleType />
</cffunction>

<cffunction name="setScaffoldConfigurationPath" returntype="void" output="false" access="public">
	<cfargument name="ScaffoldConfigurationPath" type="string" />
	<cfset variables._instance.ScaffoldConfigurationPath = arguments.ScaffoldConfigurationPath />
</cffunction>
<cffunction name="getScaffoldConfigurationPath" returntype="string" output="false">
	<cfreturn variables._instance.ScaffoldConfigurationPath />
</cffunction>

<cffunction name="setScaffoldPath" returntype="void" output="false" access="public">
	<cfargument name="ScaffoldPath" type="string" />
	<cfset variables._instance.ScaffoldPath = arguments.ScaffoldPath />
</cffunction>
<cffunction name="getScaffoldPath" returntype="string" output="false">
	<cfreturn variables._instance.ScaffoldPath />
</cffunction>

<cffunction name="setStatePrecedence" returntype="void" output="false" access="public" hint="Deprecated: DOES NOTHING!">
	<cfargument name="StatePrecedence" type="string" />
</cffunction>

<cffunction name="setReloadKey" returntype="void" output="false" access="public">
	<cfargument name="ReloadKey" />
	<cfset variables._instance.ReloadKey = arguments.ReloadKey />
</cffunction>
<cffunction name="getReloadKey" returntype="string" output="false">
	<cfreturn variables._instance.ReloadKey />
</cffunction>

<cffunction name="setEventValue" returntype="void" output="false" access="public">
	<cfargument name="EventValue" type="string" />
	<cfset variables._instance.EventValue = arguments.EventValue />
</cffunction>
<cffunction name="getEventValue" returntype="string" output="false">
	<cfreturn variables._instance.EventValue />
</cffunction>

<cffunction name="setRequestFormatValue" returntype="void" output="false" access="public">
	<cfargument name="RequestFormatValue" type="string" />
	<cfset variables._instance.RequestFormatValue = arguments.RequestFormatValue />
</cffunction>
<cffunction name="getRequestFormatValue" returntype="string" output="false">
	<cfreturn variables._instance.RequestFormatValue />
</cffunction>


<cffunction name="setDefaultTemplate" returntype="void" output="false" access="public">
	<cfargument name="DefaultTemplate" type="string" />
	<cfset variables._instance.DefaultTemplate = arguments.DefaultTemplate />
</cffunction>
<cffunction name="getDefaultTemplate" returntype="string" output="false">
	<cfreturn variables._instance.DefaultTemplate />
</cffunction>

<cffunction name="setDefaultExceptionHandler" returntype="void" output="false" access="public">
	<cfargument name="DefaultExceptionHandler" type="string" />
	<cfset variables._instance.DefaultExceptionHandler = arguments.DefaultExceptionHandler />
</cffunction>
<cffunction name="getDefaultExceptionHandler" returntype="string" output="false">
	<cfreturn variables._instance.DefaultExceptionHandler />
</cffunction>

<cffunction name="setDefaultCacheTimeout" returntype="void" output="false" access="public">
	<cfargument name="DefaultCacheTimeout" type="numeric" />
	<cfset variables._instance.DefaultCacheTimeout = arguments.DefaultCacheTimeout />
</cffunction>
<cffunction name="getDefaultCacheTimeout" returntype="string" output="false">
	<cfreturn variables._instance.DefaultCacheTimeout />
</cffunction>

<cffunction name="setDefaultScaffolds" returntype="void" output="false" access="public">
	<cfargument name="DefaultScaffolds" type="string" />
	<cfset variables._instance.DefaultScaffolds = arguments.DefaultScaffolds />
</cffunction>
<cffunction name="getDefaultScaffolds" returntype="string" output="false">
	<cfreturn variables._instance.DefaultScaffolds />
</cffunction>

<cffunction name="setGenerationControllerPath" returntype="void" output="false" access="public">
	<cfargument name="GenerationControllerPath" type="string" />
	<cfset variables._instance.GenerationControllerPath = arguments.GenerationControllerPath />
</cffunction>
<cffunction name="getGenerationControllerPath" returntype="string" output="false">
	<cfreturn variables._instance.GenerationControllerPath />
</cffunction>

<cffunction name="setGenerationViewPath" returntype="void" output="false" access="public">
	<cfargument name="GenerationViewPath" type="string" />
	<cfset variables._instance.GenerationViewPath = arguments.GenerationViewPath />
</cffunction>
<cffunction name="getGenerationViewPath" returntype="string" output="false">
	<cfreturn variables._instance.GenerationViewPath />
</cffunction>

<cffunction name="setGenerationEnabled" returntype="void" output="false" access="public">
	<cfargument name="GenerationEnabled" type="string" />
	<cfset variables._instance.GenerationEnabled = arguments.GenerationEnabled />
</cffunction>
<cffunction name="getGenerationEnabled" returntype="boolean" output="false">
	<cfreturn variables._instance.GenerationEnabled />
</cffunction>

</cfcomponent>