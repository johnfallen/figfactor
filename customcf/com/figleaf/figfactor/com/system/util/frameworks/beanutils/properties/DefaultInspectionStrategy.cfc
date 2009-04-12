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

<cfcomponent output="false" 
	hint="<p>
				I am the default strategy for inspecting a bean for properties.
				</p>
				<p>
			  I consider a property as anything defined in a CFPROPERTY tag or 
			  with both a setXXX and getXXX functions.
				</p>
				<p>
				I prioritize information in CFPROPERTY tags above that discovered in 
				a getter or setter. 
				</p>
				<p>
				I'll always describe the NAME and TYPE of a property and whether the 
				property is explicit (defined with CFPROPERTY) or implicit (defined
				with a getter / setter pair).
				</p>
				<p>
				I'll additionally report the values of all attributes on the CFPROPERTY
				or getXXX CFFUNCTION tag.
				</p>
				"
>

<!--- PROPERTIES --->

<cfset this.types = 0 />

<!--- CONSTRUCTOR --->

<cffunction name="init" output="false" hint="Constructor">
	<cfargument name="types">
	
	<cfset this.types = arguments.types />
	
	<cfreturn this />
</cffunction>
 
<!--- PUBLIC --->

<cffunction name="inspect" output="false" hint="Inspects a CFC instance and returns a struct describing it and its properties.">
	<cfargument name="bean" required="true" hint="I am the bean to inspect" />
	
	<cfset var result = structNew() />
	<cfset var properties = structNew() />
	
	<cfset discoverImplicitProperties(arguments.bean, properties) />

	<cfset discoverExplicitProperties(arguments.bean, properties) />
	
	<cfset result.properties = properties />
	<cfset result.name = getMetadata(bean).name />
	
	<cfreturn result />
</cffunction>

<cffunction name="inspectAsXML" output="false" hint="Returns a CFC's property information in XML format.">
	<cfargument name="bean" required="true" hint="I am the bean to inspect" />

	<cfset var meta = inspect(bean) />
	<cfset var props = meta.properties />
	<cfset var result = "" />
	<cfset var i = "" />
	<cfset var j = "" />
	
	<cfoutput>
	<cfxml variable="result">
<bean name="#meta.name#">
	<cfloop collection="#props#" item="i">
	<property>
		<cfloop collection="#props[i]#" item="j">
			<#lCase(j)#>#props[i][j]#</#lCase(j)#>
		</cfloop>
	</property>
	</cfloop>
</bean>
	</cfxml>
	</cfoutput>
	
	<cfreturn result />
</cffunction>
 
<cffunction name="getHash" output="false" hint="Returns a hash of a CFC's property information in XML format.">
	<cfargument name="bean" required="true" hint="I am the bean to inspect" />
	
	<cfreturn hash(inspectAsXml(bean)) />
</cffunction>

<cffunction name="createDefaultPropertyInformation" output="false" access="public" returntype="struct">
	<cfset var propInfo = structNew() />
	<cfset var j = "" />

	<!--- Defaults --->
	<cfset propInfo.type = "string" />
	<cfset propInfo.collection = false />
	<cfset propInfo.component = false />
	<cfset propInfo.explicit = true />
	
	<cfreturn propInfo />
</cffunction>

<!--- PRIVATE --->

<cffunction name="discoverExplicitProperties" output="false" access="private">
	<cfargument name="bean" />
	<cfargument name="props" />
	
	<cfset var md = getMetadata(bean) />
	<cfset var properties = "" />
	<cfset var prop = "" />
	<cfset var propInfo = "" />
	<cfset var i = "" />
	
	<cfif structKeyExists(md, "properties") and arrayLen(md.properties)>
		<cfloop from="1" to="#arrayLen(md.properties)#" index="i">
			<cfset prop = md.properties[i] />
			<cfset propInfo = introspectCfProperty(prop) />
			
			<cfset arguments.props[propInfo.name] = propInfo />
			
		</cfloop>
	</cfif>
</cffunction>

<cffunction name="introspectCfProperty" output="false" access="private" returntype="struct">
	<cfargument name="cfproperty" type="struct" />

	<cfset var propInfo = createDefaultPropertyInformation() />
	<cfset var j = "" />

	<cfloop collection="#arguments.cfproperty#" item="j">
	
		<cfswitch expression="#j#">
			<!--- By default, just copy. --->
			<cfdefaultcase>
				<cfset propInfo[j] = arguments.cfproperty[j] />
			</cfdefaultcase>
		</cfswitch>
		
	</cfloop>
	
	<cfset propInfo.collection = this.types.isCollectionType(propInfo.type) />
	<cfset propInfo.component = this.types.isComponentType(propInfo.type) />

	<cfreturn propInfo />	
</cffunction>

<cffunction name="discoverImplicitProperties" output="false" access="private">
	<cfargument name="bean" />
	<cfargument name="props" />
	
	<cfset var md = getMetadata(bean) />
	<cfset var properties = "" />
	<cfset var prop = "" />
	<cfset var propInfo = "" />
	<cfset var i = "" />
	<cfset var j = "" />

	<!--- Instead of using metadata, inspect as a collection in case we've got mixins. --->
	<cfloop collection="#arguments.bean#" item="i">
		<cfif left(i, 3) eq "get">
			<cfset prop = arguments.bean[i] />
			
			<cfset propInfo = introspectGetter(arguments.bean[i]) />
			
			<cfset arguments.props[propInfo.name] = propInfo />
		</cfif>		
	</cfloop>
</cffunction>
	
<cffunction name="introspectGetter" access="private" output="false" returntype="struct">
	<cfargument name="function" />
	
	<cfset var md = getMetadata(arguments.function) />
	<cfset var propInfo = createDefaultPropertyInformation() />
	
	<cfset propInfo.explicit = false />
	
	<cfloop collection="#md#" item="j">
		<cfswitch expression="#j#">
			<!--- Name = name w/o "get" --->
			<cfcase value="name">
				<cfset propInfo[j] = right(md.name, len(md.name) - 3) />
			</cfcase>
			
			<!--- Returntype = Type --->
			<cfcase value="returnType">
				<cfset propInfo.type = md[j] />
			</cfcase>
			
			<!--- By default, just copy. --->
			<cfdefaultcase>
				<cfset propInfo[j] = md[j] />
			</cfdefaultcase>
		</cfswitch>
	</cfloop>

	<cfset propInfo.collection = this.types.isCollectionType(propInfo.type) />
	<cfset propInfo.component = this.types.isComponentType(propInfo.type) />

	<cfreturn propInfo />		
</cffunction>

</cfcomponent>