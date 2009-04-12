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

This file is part of BeanUtils BeanUtils (0.2).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->


<cfcomponent output="false" hint="I extract/inject values from/into beans using a bean inspector.">

<cffunction name="init" output="false" hint="Constructor">
	<cfargument name="inspector" />
	<cfset variables._inspector = inspector />
	<cfset variables.System = createObject("java", "java.lang.System") />
	<cfreturn this />
</cffunction>

<!--- PUBLIC --->
<cffunction name="extract" output="false" hint="I extract a bean's data into a structure.">
	<cfargument name="bean" />
	<cfargument name="extractedComponents" required="false" default="#createObject("java", "java.util.HashMap").init()#" hint="Map of components already extracted in an extraction process.  Used to prevent infinite recursion when a cyclic graph is encountered." />

	<cfset var beanDescription = inspect(bean) />
	<cfset var properties = beanDescription.properties />
	<cfset var i = "" />
	<cfset var prop = "" />
	<cfset var result = structNew() />
	<cfset var hashcode = System.identityHashCode(bean) />
	<cfset var propertyValue = "" />
		
	<!--- If we haven't extracted this component before, extract. --->
	<cfif not extractedComponents.containsKey(hashcode)>
		<cfset extractedComponents.put(hashcode, result) />
		
		<cfloop collection="#properties#" item="i">
			<cfset prop = properties[i] />
			
			<cfset propertyValue = getProperty(bean, prop.name, beanDescription, extractedComponents) />
			
			<cfif isDefined("propertyValue")>
				<cfset result[prop.name] = propertyValue />
			</cfif>
		</cfloop>
		
		<cfreturn result />
	<!--- We've been here before, return already extracted component reference. --->
	<cfelse>
		<cfreturn extractedComponents.get(hashcode) />
	</cfif>
</cffunction>

<cffunction name="inject" output="false" hint="I inject a bean's data from a structure.">
	<cfargument name="source" />
	<cfargument name="bean" />
	<cfargument name="injectedComponents" required="false" default="#createObject("java", "java.util.HashMap").init()#" hint="Map of components already injected in an injection process.  Used to prevent infinite recursion when a cyclic graph is encountered." />

	<cfset var beanDescription = inspect(bean) />
	<cfset var properties = beanDescription.properties />
	<cfset var i = "" />
	<cfset var prop = "" />
	<cfset var hashcode = System.identityHashCode(source) />

	<!--- If we haven't injected this component before, inject. --->
	<cfif not injectedComponents.containsKey(hashcode)>
		<cfset injectedComponents.put(hashcode, bean) />

		<cfloop collection="#properties#" item="i">
			<cfset prop = properties[i] />
			
			<cfif structKeyExists(source, prop.name)>
				<cfset setProperty(bean, prop.name, source[prop.name], beanDescription, injectedComponents) />
			</cfif>
		</cfloop>
	
		<cfreturn bean />
	<cfelse>
		<cfreturn injectedComponents.get(hashcode) />
	</cfif>
</cffunction>

<cffunction name="getProperty" output="false" hint="I get a property from a bean, regardless of accessor style (explicit or implicit).">
	<cfargument name="bean" />
	<cfargument name="propertyName" />
	<cfargument name="beanDescription" required="false" type="struct" default="#inspect(bean)#" />
	<cfargument name="extractedComponents" required="false" default="#createObject("java", "java.util.HashMap").init()#" hint="Map of components already extracted in an extraction process.  Used to prevent infinite recursion when a cyclic graph is encountered." />

	<cfif structKeyExists(beanDescription.properties, propertyName)>
		<cfif beanDescription.properties[propertyName].explicit>
			<cfreturn extractExplicit(bean, beanDescription.properties[propertyName], extractedComponents) />
		<cfelse>
			<cfreturn extractImplicit(bean, beanDescription.properties[propertyName], extractedComponents) />
		</cfif>
	</cfif>		
</cffunction>

<cffunction name="setProperty" output="false" hint="I get a property from a bean, regardless of accessor style (explicit or implicit).">
	<cfargument name="bean" />
	<cfargument name="propertyName" />
	<cfargument name="value" />
	<cfargument name="beanDescription" required="false" type="struct" default="#inspect(bean)#" />
	<cfargument name="injectedComponents" required="false" default="#createObject("java", "java.util.HashMap").init()#" hint="Map of components already extracted in an extraction process.  Used to prevent infinite recursion when a cyclic graph is encountered." />

	<cfif structKeyExists(beanDescription.properties, propertyName)>
		<cfif beanDescription.properties[propertyName].explicit>
			<cfreturn injectExplicit(bean, beanDescription.properties[propertyName], value, injectedComponents) />
		<cfelse>
			<cfreturn injectImplicit(bean, beanDescription.properties[propertyName], value, injectedComponents) />
		</cfif>
	</cfif>
</cffunction>

<!--- PRIVATE --->
<cffunction name="inspect" output="false" access="private" hint="I inspect a bean for properties.">
	<cfargument name="bean" />
	
	<cfreturn variables._inspector.inspect(bean) />
</cffunction>

<cffunction name="extractExplicit" output="false" access="private" hint="I extract an explicit (key/value) property.">
	<cfargument name="bean" />
	<cfargument name="property" />
	<cfargument name="extractedComponents" required="true" />

	<cfset var val = "" />
	
	<cftry>
		<cfset val = bean[property.name] />
		<cfcatch>
			<!--- If a getter breaks, its result is considered null/undefined. --->
			<cfreturn createUndefinedValue() />
		</cfcatch>
	</cftry>
	
	<cfreturn convertPropertyValueForExtraction(val, property, extractedComponents) />
</cffunction>

<cffunction name="extractImplicit" output="false" access="private" hint="I extract an implicit (getXXX) property.">
	<cfargument name="bean" />
	<cfargument name="property" />
	<cfargument name="extractedComponents" required="true" />
	
	<cfset var val = "" />
	
	<cftry>
		<cfinvoke component="#bean#" method="get#property.name#" returnvariable="val" />
		<cfcatch>
			<cfreturn createUndefinedValue() />
			<!--- If a getter breaks, its result is considered null. --->
		</cfcatch>
	</cftry>

	<cfreturn convertPropertyValueForExtraction(val, property, extractedComponents) />
</cffunction>

<cffunction name="injectExplicit" output="false" access="private" hint="I inject an explicit (key/value) property.">
	<cfargument name="bean" />
	<cfargument name="property" />
	<cfargument name="propertyValue" />
	<cfargument name="injectedComponents" required="true" />

	<cfset bean[property.name] = convertPropertyValueForInjection(propertyValue, property, injectedComponents) />
</cffunction>

<cffunction name="injectImplicit" output="false" access="private" hint="I inject an implicit (getXXX) property.">
	<cfargument name="bean" />
	<cfargument name="property" />
	<cfargument name="propertyValue" />
	<cfargument name="injectedComponents" required="true" />
	
	<cfset var value = convertPropertyValueForInjection(propertyValue, property, injectedComponents) />
	
	<cfif structKeyExists(bean, "set#property.name#")>
		<cfset evaluate("bean.set#property.name#(value)") />
	</cfif>
</cffunction>

<cffunction name="convertPropertyValueForExtraction" output="false" access="private" hint="I convert a bean property for the purposes of structure-targeted extraction.">
	<cfargument name="value" />
	<cfargument name="property" />
	<cfargument name="extractedComponents" required="true" />
	
	<cfif property.component>
		<cfreturn extract(value, extractedComponents) />
	<cfelse>
		<cfswitch expression="#property.type#">
			<cfcase value="array">
				<cfreturn convertArrayForExtraction(value, extractedComponents) />
			</cfcase>
			<cfcase value="struct">
				<cfreturn convertStructForExtraction(value, extractedComponents) />
			</cfcase>
			<cfcase value="query">
				<cfreturn convertQueryForExtraction(value, extractedComponents) />
			</cfcase>
			<cfdefaultcase>
				<cfreturn value />
			</cfdefaultcase>
		</cfswitch>
	</cfif>
</cffunction>

<cffunction name="convertRawValueForExtraction" output="false" access="private" hint="I convert a raw value (such as one from within an array in a bean) for the purposes of structure-targeted extraction.">
	<cfargument name="value" />
	<cfargument name="extractedComponents" required="true" />

	<cfif isSimpleValue(value)>
		<cfreturn value />
	<cfelseif isObject(value)>
		<cfreturn extract(value, extractedComponents) />
	<cfelseif isArray(value)>
		<cfreturn convertArrayForExtraction(value, extractedComponents) />
	<cfelseif isStruct(value)>
		<cfreturn convertStructForExtraction(value, extractedComponents) />
	<cfelseif isQuery(value)>
		<cfreturn convertQueryForExtraction(value, extractedComponents) />
	</cfif>
</cffunction>

<cffunction name="convertArrayForExtraction" output="false" access="private" hint="I convert an array for the purposes of structure-targeted extraction.  I operate by-value where possible:  I do not return the array itself.  I go through each of its members, returning an appropriate conversion for its type through a possibly recursive call to convertValueForExtraction().  Therefore, if I encounter a component as a member of the array, I'll extract it to a struct as well.">
	<cfargument name="value" />
	<cfargument name="extractedComponents" required="true" />

	<cfset var i = "" />
	<cfset var result = arrayNew(1) />
	
	<cfloop from="1" to="#arrayLen(value)#" index="i">
		<cfset arrayAppend(result, convertRawValueForExtraction(value[i], extractedComponents)) />
	</cfloop>
	
	<cfreturn result />
</cffunction>

<cffunction name="convertStructForExtraction" output="false" access="private" hint="I convert a structure for the purposes of structure-targeted extraction.  I operate by-value where possible:  I do not return the structure itself.  I go through each of its members, returning an appropriate conversion for its type through a possibly recursive call to convertValueForExtraction().  Therefore, if I encounter a component as a member of the struct, I'll extract it to a struct as well.">
	<cfargument name="value" />
	<cfargument name="extractedComponents" required="true" />

	<cfset var i = "" />
	<cfset var result = structNew() />

	<cfloop collection="#value#" item="i">	
		<cfset result[i] = convertRawValueForExtraction(value[i], extractedComponents) />
	</cfloop>
	
	<cfreturn result />
</cffunction>
		
<cffunction name="convertQueryForExtraction" output="false" access="private" hint="I convert a query for the purposes of structure-targeted extraction.  I operate by-reference:  the query returned is the same query as the one passed.">
	<cfargument name="value" />
	<cfargument name="extractedComponents" required="true" />
	
	<cfreturn value />
</cffunction>

<cffunction name="convertPropertyValueForInjection" output="false" access="private" hint="I convert a value for the purposes of bean-targeted injection.">
	<cfargument name="value" />
	<cfargument name="property" />
	<cfargument name="injectedComponents" required="true" />
	
	<cfset var componentBean = "" />

	<cflog text="converting property for injection: #property.name#.  component: #property.component#." />

	<cfif property.component>
		<cfset componentBean = createBean(property.type) />
		
		<cfreturn inject(value, componentBean, injectedComponents) />
	<cfelse>
		<cfswitch expression="#property.type#">
			<cfcase value="array">
				<cfreturn convertArrayForInjection(value, injectedComponents) />
			</cfcase>
			<cfcase value="struct">
				<cfreturn convertStructForInjection(value, injectedComponents) />
			</cfcase>
			<cfcase value="query">
				<cfreturn convertQueryForInjection(value, injectedComponents) />
			</cfcase>
			<cfdefaultcase>
				<cfreturn value />
			</cfdefaultcase>
		</cfswitch>
	</cfif>
</cffunction>

<cffunction name="convertRawValueForInjection" output="false" access="private" hint="I convert a raw value (such as an array) for the purposes of bean-targeted injection.">
	<cfargument name="value" />
	<cfargument name="injectedComponents" required="true" />

	<cfif isSimpleValue(value)>
		<cfreturn value />
	<cfelseif isObject(value)>
		<cfreturn inject(value, injectedComponents) />
	<cfelseif isArray(value)>
		<cfreturn convertArrayForInjection(value, injectedComponents) />
	<cfelseif isStruct(value)>
		<cfreturn convertStructForInjection(value, injectedComponents) />
	<cfelseif isQuery(value)>
		<cfreturn convertQueryForInjection(value, injectedComponents) />
	</cfif>
</cffunction>

<cffunction name="convertArrayForInjection" output="false" access="private" hint="I convert an array for the purposes of bean-targeted injection.  I operate by-value where possible:  I do not return the array itself.  I go through each of its members, returning an appropriate conversion for its type through a possibly recursive call to convertValueForInjection().  Therefore, if I encounter a component as a member of the array, I'll inject it to a bean as well.">
	<cfargument name="value" />
	<cfargument name="injectedComponents" required="true" />

	<cfset var i = "" />
	<cfset var result = arrayNew(1) />
	
	<cfloop from="1" to="#arrayLen(value)#" index="i">
		<cfset arrayAppend(result, convertRawValueForInjection(value[i], injectedComponents)) />
	</cfloop>
	
	<cfreturn result />
</cffunction>

<cffunction name="convertStructForInjection" output="false" access="private" hint="I convert a structure for the purposes of bean-targeted injection.  I operate by-value where possible:  I do not return the structure itself.  I go through each of its members, returning an appropriate conversion for its type through a possibly recursive call to convertValueForInjection().  Therefore, if I encounter a component as a member of the struct, I'll inject it to a bean as well.">
	<cfargument name="value" />
	<cfargument name="injectedComponents" required="true" />

	<cfset var i = "" />
	<cfset var result = structNew() />

	<cfloop collection="#value#" item="i">	
		<cfset result[i] = convertRawValueForInjection(value[i], injectedComponents) />
	</cfloop>
	
	<cfreturn result />
</cffunction>
		
<cffunction name="convertQueryForInjection" output="false" access="private" hint="I convert a query for the purposes of bean-targeted injection.  I operate by-reference:  the query returned is the same query as the one passed.">
	<cfargument name="value" />
	<cfargument name="injectedComponents" required="true" />
	
	<cfreturn value />
</cffunction>

<cffunction name="createBean" access="private" hint="I am used to create beans from a given type name.  I'll attempt to call a construct, but fail silently if simply calling init() fails, returning whatever I did create.">
	<cfargument name="componentName" type="string" required="true" />
	
	<cfset var originalBean = createObject("component", componentName) />
	<cfset var bean = "" />
	
	<cftry>
		<cfset bean = originalBean.init() />
		<cfcatch>
			<cfset bean = originalBean />
		</cfcatch>
	</cftry>
	
	<cfreturn bean />
</cffunction>

<cffunction name="createUndefinedValue" output="false">
</cffunction>

</cfcomponent>