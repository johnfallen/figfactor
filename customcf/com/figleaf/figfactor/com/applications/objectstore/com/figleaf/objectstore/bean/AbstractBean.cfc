<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			BeanShell.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am an Empty Bean Shell
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		16/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Abstract Bean" output="false"
	hint="I am an Abstract Bean, used to model object stored in XML.">

<cfset variables._instance = structNew() />



<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="AbstractBean" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfset var properties = arguments />

	<cfset configure(properties = properties) />
	
	<cfreturn this />
</cffunction>



<!--- addChild --->
<cffunction name="addChild" returntype="any" access="public" output="false"
    displayname="Add Child" hint="I add a child to my internal object graph."
    description="I add a child to my internal object graph.">
    
	<cfargument name="type" type="string" required="true" 
		hint="I am the name of the children objects to return. I am requried." />
	<cfargument name="bean" type="component" required="true" 
		hint="I am the child object to add. I am required.">
	
	<cfset var childContainer = structNew() />
	
	<cfif not structKeyExists(variables._instance, "children")>
		<cfset variables._instance.children = structNew() />
	</cfif>

	<!--- put the object in a struct with a unique name --->
	<cfset childContainer[replace(createUUID(), "-", "", "all")] = arguments.bean />

	<cfif structKeyExists(variables._instance.children, arguments.type)>
		<cfset structAppend(variables._instance.children[arguments.type], childContainer) />
	<cfelse>
		<cfset variables._instance.children[arguments.type] = structNew() />
		<cfset structAppend(variables._instance.children[arguments.type], childContainer) />
	</cfif>

</cffunction>



<!--- configure --->
<cffunction name="configure" returntype="any" access="public" output="false"
    displayname="configure" hint="I configure myself."
    description="I configure myself.">
    
	<cfargument name="properties" type="struct" required="true" 
		hint="I am the properties structure. I am requried." />

	<cfloop collection ="#arguments.properties#" item="x">
		<cfif isStruct(arguments.properties[x])>
			<cfset variables._instance[x] = structNew() />
		<cfelse>
			<cfset variables._instance[x] = arguments.properties[x] />
		</cfif>
	</cfloop>
	
</cffunction>



<!--- getAccessors --->
<cffunction name="getAccessors" returntype="any" access="public" output="false"
    displayname="Get Accessors" hint="I return a string of my accsors."
    description="I return a string of my accsors.">

	<cfreturn structKeyList(variables._instance) />
</cffunction>



<!--- getChild --->
<cffunction name="getChild" returntype="any" access="public" output="false"
    displayname="Get Child" hint="I return one of my child objects by  id."
    description="I return one of my child objects by id. If not found I return '0'.">
    
	<cfargument name="id" type="string" required="true" 
		hint="I am the ID of the child. I am requried." />
	
	<cfset var result = StructFindKey(variables._instance.children, arguments.id) />
	
	<cfif isArray(result) and arrayLen(result) eq 1>
		<cfset result = result[1].value />	
	</cfif>

    <cfreturn result />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="any" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
	<cfreturn variables._instance />
</cffunction>



<!--- listChildren --->
<cffunction name="listChildren" returntype="struct" access="public" output="false"
    displayname="List Children" hint="I return structure of children objects by type."
    description="I return structure of children objects by type.">

	<cfargument name="type" type="string" required="true" 
		hint="I am the name of the children objects to return. I am requried." />
    
	
	<cfif structKeyExists(variables._instance.children, arguments.type)>
		<cfreturn variables._instance.children[arguments.type] />
	<cfelse>
		<cfreturn structNew() />
	</cfif>
</cffunction>



<!--- listChildrenTypes --->
<cffunction name="listChildrenTypes" returntype="any" access="public" output="false"
    displayname="List Child Object Types" hint="I return a list of the children objects I manage."
    description="I return a list of the children objects I manage.">
    
	<cfif isDefined("variables._instance.children")>
		<cfreturn structKeyList(variables._instance.children, ",") />
	<cfelse>
		<cfreturn "" />
	</cfif>
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- onMissingMethod --->
<cffunction name="onMissingMethod" output="false">
	<cfargument name="missingMethodName" type="string">
	<cfargument name="missingMethodArguments" type="struct">

	<cfset var property = "">
	<cfset var value = "">

	<cfif findNoCase("get",arguments.missingMethodName) is 1>
		
		<cfset property = replaceNoCase(arguments.missingMethodName,"get","") />
		
		<cfif NOT StructIsEmpty(Arguments.missingMethodArguments)>
			<cfset value = arguments.missingMethodArguments[listFirst(structKeyList(arguments.missingMethodArguments))] />
		</cfif>
		
		<cfreturn get(property, value) />
	
	<cfelseif findNoCase("set",arguments.missingMethodName) is 1>
		
		<cfset property = replaceNoCase(arguments.missingMethodName,"set","") />
		
		<!--- assume only arg is value --->
		<cfset value = arguments.missingMethodArguments[listFirst(structKeyList(arguments.missingMethodArguments))] />
		<cfset set(property,value) />
	</cfif>

</cffunction>



<!--- get --->
<cffunction name="get" returntype="any" access="private" output="false"
    displayname="Get" hint="I return a value from my instance by name."
    description="I return a value from my instance by name.">
    
	<cfargument name="name" type="string" required="true" 
		hint="I am the name of the value. I am requried." />
	
	<cfreturn structFind(variables._instance, arguments.name) />
</cffunction>



<!--- set --->
<cffunction name="set" returntype="void" access="private" output="false"
    displayname="Set" hint="I set a value to my internal instance by name."
    description="I set a value to my internal instance by name.">
    
	<cfargument name="name" type="string" required="true" 
		hint="I am the name of the value. I am requried." />
	<cfargument name="value" type="any" required="true" 
		hint="I am the value to store. I am requried." />
	
	<cfset variables._instance[arguments.name] = arguments.value />

</cffunction>
</cfcomponent>