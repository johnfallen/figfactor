<!---
LICENSE INFORMATION:

Copyright 2007, Firemoss, LLC
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of BeanUtils Alpha (0.3).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->


<cfcomponent output="false" hint="I provide bean property introspection, extraction, and injection functions.">

<cffunction name="init" output="false" hint="Constructor">
	
	<cfargument name="cacheProperties" type="boolean" required="false" default="true" 
		hint="Should beans of a given type be inspected for new properties once (true) or every time they're needed (false)?">
	
	<cfargument name="ColdFusionTypes" required="false" 
		default="#createObject("component", "type.ColdFusionTypes").init()#" 
		hint="The converter implementation to use for property value extraction / injection." />
	
	<cfargument name="inspectionStrategy" required="false" 
		default="#createObject("component", "properties.DefaultInspectionStrategy").init(arguments.ColdFusionTypes)#" 
		hint="The inspection strategy to use to discover CFC properties." />
	
	<cfargument name="converter" required="false" 
		default="#createObject("component", "converter.StructConverter").init(arguments.inspectionStrategy)#" 
		hint="The converter implementation to use for property value extraction / injection." />
	
	<cfset variables._cacheProperties = arguments.cacheProperties />
	<cfset variables._propertyHashCache = structNew() />
	<cfset variables._propertyCache = structNew() />
	<cfset variables._inspector = arguments.inspectionStrategy />
	<cfset variables._converter = arguments.converter/>

	<cfreturn this />	
</cffunction>

<cffunction name="propertiesAreDirty" output="false" returntype="boolean" hint="I state if a bean's property information are dirty (need refreshing) or safely available from a cache.">
	<cfargument name="bean" required="true" />
	
	<cfset var className = 0 />
	
	<cfif not variables._cacheProperties>
		<cfreturn true />
	</cfif>
	
	<cfset className = getMetadata(bean).name />
	
	<cfif not structKeyExists(variables._propertyHashCache, className)>
		<cfreturn true />
	<cfelse>
		<cfif variables._propertyHashCache[className] neq getHash(bean)>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cfif>
</cffunction>

<cffunction name="getHash" output="false" hint="Returns a hash of a CFC's property information in XML format.">
	<cfargument name="bean" required="true" hint="I am the bean to inspect" />
	
	<cfreturn variables._inspector.getHash(bean) />
</cffunction>

<cffunction name="inspect" output="false" hint="Inspects a CFC instance and returns a struct describing properties.">
	<cfargument name="bean" required="true" hint="I am the bean to inspect" />

	<cfset var className = 0 />
	
	<cfset className = getMetadata(bean).name />

	<cfif propertiesAreDirty(arguments.bean)>
		<!--- This does double duty:  clean it up someday. --->
		<cfset variables._propertyCache[className] = variables._inspector.inspect(arguments.bean) />
		<cfset variables._propertyHashCache[className] = getHash(arguments.bean) />
	</cfif>

	
	<cfreturn variables._propertyCache[className] />
</cffunction>

<cffunction name="inspectAsXML" output="false" hint="Returns a CFC's property information in XML format.">
	<cfargument name="bean" required="true" hint="I am the bean to inspect" />

	<cfreturn variables._inspector.inspectAsXML(bean) />
</cffunction>

<cffunction name="extract" output="false" hint="I extract a bean's data into an alternate format, such as a Structure.">
	<cfargument name="bean" hint="A CFC instance whose data should be extracted."/>
	<cfargument name="extractedComponents" required="false" default="#createObject("java", "java.util.HashMap").init()#" hint="Map of components already extracted in an extraction process.  Used to prevent infinite recursion when a cyclic graph is encountered." />

	<cfreturn variables._converter.extract(argumentCollection=arguments) />
</cffunction>

<cffunction name="inject" output="false" hint="I inject a bean's data from an alternate format, such as a Structure.">
	<cfargument name="source" hint="The structure of state containing property values to inject." />
	<cfargument name="bean" hint="The CFC instance into which data should be injected." />
	<cfargument name="injectedComponents" required="false" default="#createObject("java", "java.util.HashMap").init()#" hint="Map of components already injected in an injection process.  Used to prevent infinite recursion when a cyclic graph is encountered." />

	<cfreturn variables._converter.inject(argumentCollection=arguments) />
</cffunction>

<cffunction name="getProperty" output="false" hint="I get a property from a bean, regardless of accessor style (explicit or implicit).">
	<cfargument name="bean" hint="The CFC instance from which a property value should be extracted." />
	<cfargument name="propertyName" hint="The name of the property value to extract." />
	<cfargument name="beanDescription" required="false" type="struct" default="#inspect(bean)#" hint="Bean property metadata.  Optional."/>
	<cfargument name="extractedComponents" required="false" default="#createObject("java", "java.util.HashMap").init()#" hint="Map of components already extracted in an extraction process.  Used to prevent infinite recursion when a cyclic graph is encountered." />

	<cfreturn variables._converter.getProperty(argumentCollection=arguments) />
</cffunction>

<cffunction name="setProperty" output="false" hint="I get a property from a bean, regardless of accessor style (explicit or implicit).">
	<cfargument name="bean" hint="The CFC instance into which a property value should be set." />
	<cfargument name="propertyName" hint="The name of the property to set." />
	<cfargument name="value" hint="The value of the property to set." />
	<cfargument name="beanDescription" required="false" type="struct" default="#inspect(bean)#" hint="Bean property metadata.  Optional."/>
	<cfargument name="injectedComponents" required="false" default="#createObject("java", "java.util.HashMap").init()#" hint="Map of components already extracted in an extraction process.  Used to prevent infinite recursion when a cyclic graph is encountered." />

	<cfreturn variables._converter.setProperty(argumentCollection=arguments) />
</cffunction>

</cfcomponent>