<cfcomponent implements="ICommand" output="false">


<!--- init --->
<cffunction name="init" returntype="any" access="public" output="false" hint="">

	<cfargument name="iterator" type="string" required="true" />
	<cfargument name="it" type="string" required="true" />
	<cfargument name="body" type="edmund.framework.workflow.ICommand" required="true" />
			
	<cfset variables.iterator = arguments.iterator />
	<cfset variables.it = arguments.it />
	<cfset variables.body = arguments.body />
	
	<cfreturn this />
</cffunction>



<!--- handleEvent --->
<cffunction name="handleEvent" returntype="boolean" access="public" output="false" hint="">
	<cfargument name="event" type="edmund.framework.Event" required="true" />
	
	<cfset var result = true />

	<cfloop condition="result and arguments.event.value(variables.iterator).hasNext()">
	
		<cfset arguments.event.value( variables.it, arguments.event.value( variables.iterator ).next() ) />
		<cfset result = result and variables.body.handleEvent(arguments.event) />
	
	</cfloop>
	
	<cfreturn result />
</cffunction>
</cfcomponent>