<cfinterface displayName="Transport Interface"
	hint="I am the Transport Interface. The minimum contract that all transport CFC's must adhear to.">
<!--- init --->
<cffunction name="init" returntype="any" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
</cffunction>
<!--- checkServers --->
<cffunction name="checkServers" returntype="struct" access="public" output="false"
    displayname="Check Servers" hint="I check if configured servers are avaiable."
    description="I check if configured servers are avaiable and return a structure with key/values where the key is the IP number and the value is boolean.">
</cffunction>
<!--- push --->
<cffunction name="push" returntype="component" access="public" output="false"
    displayname="Push" hint="I push the shared_storage.xml file to the active remote servers."
    description="I push the shared_storage.xml file to the active remote servers via my transport mechanism.">
</cffunction>
</cfinterface>