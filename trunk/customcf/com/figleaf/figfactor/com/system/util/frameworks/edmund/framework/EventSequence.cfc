<cfcomponent hint="I handle a sequence of event handling listeners." output="false">

<!--- init --->
<cffunction name="init" returntype="any" access="public" output="false" hint="I am the constructor.">
	<cfargument name="events" type="string" required="true" hint="I am a list of events to trigger" />
	<cfargument name="edmund" type="any" required="true" hint="I am the event framework." />
	
	<cfset variables.events = arguments.events />
	<cfset variables.edmund = arguments.edmund />
	
	<cfreturn this />
</cffunction>



<!-- handleEvent --->
<cffunction name="handleEvent" returntype="void" access="public" output="false" hint="I am the event listener.">
	<cfargument name="event" type="any" required="true" />
	
	<cfset var item = "" />
	
	<cfloop index="item" list="#variables.events#">
		
		<cfset variables.edmund.dispatchAliasEvent(item,arguments.event) />
		
	</cfloop>

</cffunction>
</cfcomponent>