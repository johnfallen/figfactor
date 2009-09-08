<cfcomponent displayname="navigation" output="false">


    <cffunction name="init" returntype="any" access="public" output="false"
		displayname="Init" hint="I am the constructor."
		description="I am the pseudo constructor for this CFC. I return an instance of myself.">
        <cfargument name="Logger" />

        <cffile action="read" variable="xml" file="#getDirectoryFromPath(getCurrentTemplatePath())#/navigation.xml">
        <cfset xmlDoc = xmlParse(xml)>

		<cfreturn this />
	</cffunction>

	<cffunction name="getNavigationXML" access="public" output="false" returntype="xml">
		<cfreturn xmlDoc />
	</cffunction>

	<cffunction name="getTopLevelNavigation" access="public" output="false" returntype="array">
		<cfset var aParentNav = "">
		<cfset aParentNav = XmlSearch(
            xmlDoc,
            "//subsite"
            ) />
        <cfreturn aParentNav />
	</cffunction>

	<cffunction name="getSecondaryNavigation" access="public" output="false" returntype="array">
		<cfargument name="subsite" default="e-gov" hint="I will pull all children from a particular subsite navigation" />
		<cfset var aChildNav = "">
		<cfset aChildNav = XmlSearch(
            xmlDoc,
            "//subsite[ @name = '#subsite#']"
            ) />
        <cfreturn aChildNav />
		<cfreturn />
	</cffunction>
</cfcomponent>