<cfcomponent implements="ICommand" output="false">


<!--- init -->
<cffunction name="init" returntype="any" access="public" output="false" hint="">
	
	<cfargument name="condition" type="edmund.framework.workflow.ICommand" required="true" />
	<cfargument name="ifTrue" type="edmund.framework.workflow.ICommand" required="true" />
	<cfargument name="else" type="edmund.framework.workflow.ICommand" required="false" />
			
	<cfset variables.condition = arguments.condition />
	<cfset variables.ifTrue = arguments.ifTrue />
	<cfif structKeyExists(arguments,"else")>
		<cfset variables.else = arguments.else />
	</cfif>
	
	<cfreturn this />
</cffunction>



<!--- handleEvent --->
<cffunction name="handleEvent" returntype="boolean" access="public" output="false" hint="">

	<cfargument name="event" type="edmund.framework.Event" required="true" />

	<cfif variables.condition.handleEvent(arguments.event)>
		<cfreturn variables.ifTrue.handleEvent(arguments.event) />
	<cfelseif structKeyExists(variables,"else")>
		<cfreturn variables.else.handleEvent(arguments.event) />
	<cfelse>
		<cfreturn true />
	</cfif>
</cffunction>
</cfcomponent>