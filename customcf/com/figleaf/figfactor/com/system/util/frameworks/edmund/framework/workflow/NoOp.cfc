<cfcomponent implements="ICommand" output="false">


<!--- init --->
<cffunction name="init" returntype="any" access="public" output="false" hint="">	

	<cfreturn this />
</cffunction>



<!--- handleEvent --->
<cffunction name="handleEvent" returntype="boolean" access="public" output="false" hint="">
	<cfargument name="event" type="edmund.framework.Event" required="true" />

	<cfreturn true />
</cffunction>
</cfcomponent>