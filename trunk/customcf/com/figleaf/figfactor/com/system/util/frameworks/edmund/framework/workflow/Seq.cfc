<cfcomponent implements="ICommand" output="false">


<!--- init --->
<cffunction name="init" returntype="any" access="public" output="false" hint="">
	
	<cfargument name="commandArray" type="array" required="true" hint="edmund.framework.workflow.ICommand[]" />
		
	<cfset variables.commandArray = arguments.commandArray />
	
	<cfreturn this />
</cffunction>



<!--- handleEvent --->
<cffunction name="handleEvent" returntype="boolean" access="public" output="false" hint="">
	<cfargument name="event" type="edmund.framework.Event" required="true" />

	<cfset var command = 0 />
	<cfset var result = true />
	
	<cfloop index="command" array="#variables.commandArray#">

		<cfset result = result and command.handleEvent(arguments.event) />
		<cfif not result>
			<cfbreak />
		</cfif>

	</cfloop>
	
	<cfreturn result />
</cffunction>
</cfcomponent>