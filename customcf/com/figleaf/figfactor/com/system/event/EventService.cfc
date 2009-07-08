<!--- Document Information -----------------------------------------------------
Build:      				@@@revision-number@@@
Title:      				PageEventProxy.cfc
Author:     				John Allen
Email:      				jallen@figleaf.com
Company:    				@@@company-name@@@
Website:    				@@@web-site@@@
Purpose:    				I am the Event Service. I manage access to the Event
							Object.
Modification Log:
Name	 Date	 Description
================================================================================
John Allen	 07/20/2008	 Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Event Service"  output="false"
	hint="I am the Event Service, I manage the access to the Event object.">

<!--- init --->
<cffunction name="init" access="public" output="false" returntype="EventService"
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="ElementFactory" />
	<cfargument name="Config" />
	<cfargument name="UDF" />
	<cfargument name="Logger" />
	<cfargument name="hasMixen" />

	<!--- This is the name of the request variable which is the Event object --->
	<cfset variables.instance.requestHash = "#hash(getCurrentTemplatePath())#" />
	<cfset variables.ElementFactory = arguments.ElementFactory />
	<cfset variables.Config = arguments.Config />
	<cfset variables.UDF = arguments.UDF />
	<cfset variables.Logger = arguments.logger />
	<!--- did FigFactor.cfc sucessfully include its mixin file? --->
	<cfset variables.frameworkHasMixin = arguments.hasMixen />
	
	<cfreturn this  />
</cffunction>



<!--- createEvent --->
<cffunction name="createEvent" returntype="any" access="public" output="false"	
	displayname="Create Event" hint="I create an event object."
	description="I create the event object used to render a CommonSpot page.">
    
	<cfif variables.frameworkHasMixin eq true>
		<cfset Application.FigFactor.OnFigFactorRequestStart() />
	</cfif>
	
	<!--- create the Event object --->
	<cfset request.thePageEvent = 
				createObject("component", "Event").init(
					Config = variables.Config,
					ElementFactory = variables.ElementFactory,
					UDF = variables.UDF) />
	
	<!--- 
		Pass it to the frameworks applicaitions.	
		TODO: implement the CFEvent framework or Edmund here.
	--->
	<cfset passEventToApplications(request.thePageEvent) />

	<cfreturn request.thePageEvent />
</cffunction>



<!--- getEvent --->
<cffunction name="getEvent" access="public" output="false" 
	displayname="Get  Event" hint="I return the Event object for a request." 
	description="I check if the Event object is in the request scope. If not, I create it  in the request scoped and then return it.">

	<cfif structKeyExists(request, "thePageEvent")>
		<cfreturn request.thePageEvent />
	<cfelse>
		<cfreturn createEvent() />
	</cfif>
</cffunction>



<!--- getMockEvent --->
<cffunction name="getMockEvent" returntype="component" access="public" output="false"
    displayname="Get Mock Event" hint="I return a Mock Event for developers."
    description="I return a Mock Event for developers.">	
	
	<cfif not structKeyExists(request, "mockEvent")>
		
		<cfif variables.frameworkHasMixin eq true>
			<cfset Application.FigFactor.OnFigFactorRequestStart() />
		</cfif>
		
		<cfset request.mockEvent = createObject("component", "MockEvent").init(
				doRequestScopeDefautls = 0,
				Config = variables.Config,
				ElementFactory = variables.ElementFactory,
				UDF = variables.UDF) /> />
			
		<cfset passEventToApplications(request.mockEvent) />
	</cfif>
	<cfreturn request.mockEvent />
</cffunction>



<!--- passEventToApplications --->
<cffunction name="passEventToApplications" output="false"	
	displayname="Pass Event To Configured Applications" hint="I pass the Event object to the configured applicatoins."
	description="I pass the Event object to the configured applicatoins.">
    
	<cfargument name="event" />
	
	<!--- DataService --->
	<!--- If DataService is active, run queries and add them to the PageEvent's EventCollection. --->
	<cfif Config.getImplementDataService() eq true AND event.getPageTypeDefinitions().useDataService eq true>
	
		<cfset apps.DataService = Application.FigFactor.getBean("DataService") />
		
		<!--- if the URL wants to us to re-cache the query, pass it with the recach flag to true --->
		<cfif structKeyExists(url, variables.Config.getURLCacheReloadKey()) 
				and
				(
					not comparenocase(
							url[variables.Config.getURLCacheReloadKey()], 
							variables.Config.getURLCacheRelaodValue()
						)
				)>
	
			<cfset apps.DataService.setPageEventQueries(
				PageEvent = event,
				recache = true) />
		<cfelse><!--- the event is configured to use DataService --->
			<cfset apps.DataService.setEventConfiguredMethodData(event = arguments.event) />
		</cfif>
	</cfif>
</cffunction>
</cfcomponent>