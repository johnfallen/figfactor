<cfcomponent output="false" extends="ModelGlue.gesture.eventrequest.phase.ModuleLoadingRequestPhase"
						 hint="Runs the user's requested event."
>

<cfset this.name = "Invocation" />

<cffunction name="execute" returntype="void" output="false" hint="Executes the request phase.">
	<cfargument name="eventContext" hint="I am the event context to act upon.  Duck typed for speed.  Should have no queued events when execute() is called, but this isn't checked (to save time)." />

	<cfset var modelglue = arguments.eventContext.getModelGlue() />
	<cfset var initialEventHandlerName = arguments.eventContext.getValue(arguments.eventContext.getValue("eventValue"), modelglue.getConfigSetting("defaultEvent")) />
	<cfset var initialEventHandler = "" />
	<cfset var event = "" />

	<cfset loadModules(modelglue) />
	
	<!--- onApplicationStart --->
	<cfif request._modelglue.bootstrap.initializationRequest>
		<cfset event =  modelglue.getEventHandler("modelglue.onApplicationStart") />
		<cfset arguments.eventContext.addEventHandler(event) />
	</cfif>

	<!--- onSessionStart --->
	<cfif structKeyExists(request._modelglue.bootstrap, "sessionStart")>
		<cfset event =  modelglue.getEventHandler("modelglue.onSessionStart") />
		<cfset arguments.eventContext.addEventHandler(event) />
	</cfif>
	
	<!--- onRequestStart --->
	<cfset event =  modelglue.getEventHandler("modelglue.onRequestStart") />
	<cfset arguments.eventContext.addEventHandler(event) />

	<!--- Tell the context to run its queue. --->
	<cfset arguments.eventContext.executeEventQueue() />
	
	<!--- 
	Prepare for invocation _after_ queuing onRequestStart
	
	I don't really like having to put this here, but it works. 
	--->
	<cfset arguments.eventContext.prepareForInvocation() />

	<cfif structKeyExists(modelglue.eventHandlers, initialEventHandlerName)>
		<cfset initialEventHandler = modelglue.getEventHandler(initialEventHandlerName) />

		<!--- Initial user-requested event must be marked public. --->
		<cfif not initialEventHandler.access eq "public">
				<cfthrow message="This event-handler is private." />
		</cfif>		

		<cfset arguments.eventContext.addEventHandler(initialEventHandler) />
	<cfelseif structKeyExists(modelglue.eventHandlers, modelglue.configuration.missingEvent)>
		<cfset arguments.eventContext.setValue("missingEvent", initialEventHandlerName) />
		<cfset arguments.eventContext.addEventHandler(modelglue.eventHandlers[modelglue.configuration.missingEvent]) />
	<cfelse>
		<cfthrow message="Model-Glue:  There is no known event handler for ""#initialEventHandlerName#""." />
	</cfif>	
	
	<!--- Tell the context to run its queue. --->
	<cfset arguments.eventContext.executeEventQueue(true) />

	<!--- onRequestEnd --->
	<cfset event =  modelglue.getEventHandler("modelglue.onRequestEnd") />
	<cfset arguments.eventContext.addEventHandler(event) />

	<cfset arguments.eventContext.executeEventQueue() />
</cffunction>

</cfcomponent>