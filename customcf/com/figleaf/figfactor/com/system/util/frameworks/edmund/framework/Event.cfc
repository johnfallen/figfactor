<cfcomponent output="false" hint="I represent an event.">

<cfset variables.eventName = "[unnamed event]" />
<cfset variables.eventValues = structNew() />
<cfset variables.bubbleUp = false />


<!--- init --->
<cffunction name="init" returntype="any" access="public" output="false" 
	hint="I am the event constructor.">
	
	<cfargument name="edmund" type="any" required="true" 
		hint="I am the Edmund framework." />
	<cfargument name="eventName" type="string" required="true" 
		hint="I am the name of this event." />
	<cfargument name="eventValues" type="struct" default="#structNew()#" 
		hint="I am the optional initial values for this event." />
	<cfargument name="bubble" type="boolean" default="false"
		hint="I indicate whether this event should bubble up after being handled." />

	<cfset variables.edmund = arguments.edmund />
	<cfset variables.eventName = arguments.eventName />
	<cfset variables.bubbleUp = arguments.bubble />
	<!--- 
	we always reuse the same struct and copy in event values 
	to prevent accidental overwriting of other event object contents 
	--->
	<cfset structClear(variables.eventValues) />
	<cfset structAppend(variables.eventValues,arguments.eventValues) />
	
	<cfset configure() />

	<cfreturn this />
</cffunction>



<!--- configure --->
<cffunction name="configure" returntype="void" access="public" output="false" hint="Override me to provide initialization logic.">

</cffunction>



<!--- all --->
<cffunction name="all" returntype="struct" access="public" output="false" 
			hint="I return a shallow copy of all the event values.">

	<cfreturn structCopy(variables.eventValues) />
</cffunction>



<!--- bubble --->
<cffunction name="bubble" returntype="any" access="public" output="false">
	<cfargument name="bubbleUp" type="string" required="false" 
				hint="I am the new bubble up setting. If omitted, this method returns the current bubble up setting." />

	<cfif structKeyExists(arguments,"bubbleUp")>
		<cfset variables.bubbleUp = arguments.bubbleUp />
		<cfreturn this />
	<cfelse>
		<cfreturn variables.bubbleUp />
	</cfif>
</cffunction>



<!--- dispatch --->
<cffunction name="dispatch" returntype="void" access="public" output="false" hint="I dispatch myself.">

	<cfset variables.edmund.dispatchEvent(this) />

</cffunction>



<!--- has --->
<cffunction name="has" returntype="boolean" access="public" output="false" 
			hint="I return true iff the specified value exists in the event.">

	<cfargument name="name" type="string" required="true" 
				hint="I am the name of the value to test for." />

	<cfreturn structKeyExists(variables.eventValues,arguments.name) />
</cffunction>



<!--- name --->
<cffunction name="name" returntype="any" access="public" output="false">
	
	<cfargument name="eventName" type="string" required="false" 
		hint="I am the new name for the event. If omitted, this method returns the current event name." />

	<cfif structKeyExists(arguments,"eventName")>
		<cfset variables.eventName = arguments.eventName />
		<cfreturn this />
	<cfelse>
		<cfreturn variables.eventName />
	</cfif>
</cffunction>



<!--- value --->
<cffunction name="value" returntype="any" access="public" output="false" 
			hint="I either return a value from the event or store a value in the event.">
	
	<cfargument name="name" type="string" required="true" 
		hint="I am the name of the value to store." />
	<cfargument name="value" type="any" required="false" 
		hint="I am the new value to store." />
		
	<cfif structKeyExists(arguments,"value")>
		<cfset variables.eventValues[arguments.name] = arguments.value />
		<cfreturn this />
	<cfelse>
		<cfreturn variables.eventValues[arguments.name] />
	</cfif>
</cffunction>



<!--- values --->
<cffunction name="values" returntype="any" access="public" output="false" 
	hint="I set event values. I take an arbitrary list of named arguments.">

	<cfset var i = 0 />
	
	<cfloop item="i" collection="#arguments#">
		<!--- only set named arguments, not positional arguments --->
		<cfif not isNumeric(i)>
			<cfset value(i,arguments[i]) />
		</cfif>
	</cfloop>
	
	<cfreturn this />

</cffunction>

</cfcomponent>