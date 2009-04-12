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
<cffunction name="init" returntype="test" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfset var properties = arguments />

	<cfset configure(properties = properties) />
	
	<cfreturn this />
</cffunction>



<!--- configure --->
<cffunction name="configure" returntype="any" access="public" output="false"
    displayname="configure" hint="I configure myself."
    description="I configure myself.">
    
	<cfargument name="properties" type="struct" required="true" 
		hint="I am the properties structure. I am requried." />

	<cfloop collection ="#arguments.properties#" item="x">
		
		<cfif isStruct(arguments.properties[x])>
		
			<cfset variables._instance[x] = structNew()>
		<cfelse>
			<cfset variables._instance[x] = arguments.properties[x]>
		</cfif>
	
	</cfloop>

    <cfreturn  />
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

	<cfset childContainer.id = replace(createUUID(), "-", "", "all") />
	<cfset childContainer.bean = arguments.bean />
	
	<cfif structKeyExists(variables._instance.children, arguments.type)>
		<cfset structAppend(variables._instance.children[arguments.type], childContainer) />
	<cfelse>
		<cfset variables._instance.children[arguments.type] = childContainer />
	</cfif>

</cffunction>



<!--- addChild --->
<cffunction name="addEmptyChild" returntype="any" access="public" output="false"
    displayname="Add Child" hint="I add a child to my internal object graph."
    description="I add a child to my internal object graph.">
    
 	<cfargument name="type" type="string" required="true" 
		hint="I am the name of the children objects to return. I am requried." />
	<cfargument name="bean" type="component" required="true" 
		hint="I am the child object to add. I am required.">
	
	<cfset var emptyBean = structNew() />

	<cfif not structKeyExists(variables._instance, "emptyChildren")>
		<cfset variables._instance.emptyChildren = structNew() />
	</cfif>

	<cfset emptyBean.bean = arguments.bean />
	
	<cfset structAppend(variables._instance.emptyChildren[arguments.type], emptyBean) />

</cffunction>



<!--- getAccessors --->
<cffunction name="getAccessors" returntype="any" access="public" output="false"
    displayname="Get Accessors" hint="I return a string of my accsors."
    description="I return a string of my accsors.">

	<cfreturn structKeyList(variables._instance) />
</cffunction>



<!--- listChildObjectTypes --->
<cffunction name="listChildObjectTypes" returntype="any" access="public" output="false"
    displayname="List Child Object Types" hint="I return a list of the children objects I manage."
    description="I return a list of the children objects I manage.">
    
	<cfif isDefined("variables._instance.emptyChildren")>
		<cfreturn structKeyList(variables._instance.emptyChildren, ",") />
	<cfelse>
		<cfreturn "" />
	</cfif>
</cffunction>



<!--- listChildrenByType --->
<cffunction name="listChildrenByType" returntype="any" access="public" output="false"
    displayname="List Children By Type" hint="I return structure of children objects by type."
    description="I return structure of children objects by type.">

	<cfargument name="type" type="string" required="true" 
		hint="I am the name of the children objects to return. I am requried." />
    
    <cfreturn structFind(variables._instance.childrenObjectMap, arguments.type) />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="any" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
	<cfreturn variables._instance />
</cffunction>



<!--- getConfigXML --->
<cffunction name="getConfigXML" access="public" output="false" returntype="any"
	displayname="Get ConfigXML" hint="I return the ConfigXML property." 
	description="I return the ConfigXML property to my internal instance structure.">

	<cfreturn variables.config.ConfigXML />
</cffunction>



<!--- setConfigXML --->
<cffunction name="setConfigXML" access="public" output="false" returntype="void"
	displayname="Set ConfigXML" hint="I set the ConfigXML property." 
	description="I set the ConfigXML property to my internal instance structure.">
	
	<cfargument name="ConfigXML" type="xml" required="true"
		hint="I am the ConfigXML property. I am required."/>
	
	<cfset variables.config.ConfigXML = arguments.ConfigXML />
	
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
		
		<cfset property = replaceNoCase(arguments.missingMethodName,"get","")>
		
		<cfif NOT StructIsEmpty(Arguments.missingMethodArguments)>
			<cfset value = arguments.missingMethodArguments[listFirst(structKeyList(arguments.missingMethodArguments))] />
		</cfif>
		
		<cfreturn get(property, value) />
	
	<cfelseif findNoCase("set",arguments.missingMethodName) is 1>
		
		<cfset property = replaceNoCase(arguments.missingMethodName,"set","")>
		
		<!--- assume only arg is value --->
		<cfset value = arguments.missingMethodArguments[listFirst(structKeyList(arguments.missingMethodArguments))]>
		<cfset set(property,value)>
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