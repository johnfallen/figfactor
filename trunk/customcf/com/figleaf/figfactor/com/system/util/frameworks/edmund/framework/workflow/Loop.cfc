<cfcomponent implements="ICommand" output="false">
	
	
<!--- init --->
<cffunction name="init" returntype="any" access="public" output="false" hint="">

	<cfargument name="condition" type="edmund.framework.workflow.ICommand" required="true" />
	<cfargument name="body" type="edmund.framework.workflow.ICommand" required="true" />
			
	<cfset variables.condition = arguments.condition />
	<cfset variables.body = arguments.body />
	
	<cfreturn this />	
</cffunction>



<!--- handleEvent --->
<cffunction name="handleEvent" returntype="boolean" access="public" output="false" hint="">
	
	<cfargument name="event" type="edmund.framework.Event" required="true" />
	
	<cfset var result = true />
	
	<cfloop condition="result and variables.condition.handleEvent(arguments.event)">
	
		<cfset result = result and variables.body.handleEvent(arguments.event) />
	
	</cfloop>
	
	<cfreturn result />
</cffunction>
</cfcomponent>