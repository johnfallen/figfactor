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


<cfcomponent extends="org.cfcunit.framework.TestCase">

<cffunction name="createStrategy">
	<cfreturn createObject("component", "com.firemoss.beanutils.properties.DefaultInspectionStrategy").init() />
</cffunction>

<cffunction name="createExplicitBean">
	<cfreturn createObject("component", "com.firemoss.beanutils.properties.test.ExplicitBean") />
</cffunction>

<cffunction name="createExplicitBeanOneByteDifferent">
	<cfreturn createObject("component", "com.firemoss.beanutils.properties.test.ExplicitBeanOneByteDifferent") />
</cffunction>

<cffunction name="createImplicitBean">
	<cfreturn createObject("component", "com.firemoss.beanutils.properties.test.ImplicitBean") />
</cffunction>

<cffunction name="testCreateDefaultPropertyInformation" returntype="void" access="public">
	<cfset var strategy = createStrategy() />
	<cfset var propInfo = strategy.createDefaultPropertyInformation() />
	
	<cfset assertTrue(structKeyExists(propInfo, "type") and propInfo.type eq "string", "default type failed") />
	<cfset assertTrue(structKeyExists(propInfo, "collection") and propInfo.collection eq false, "default collection failed") />
	<cfset assertTrue(structKeyExists(propInfo, "component") and propInfo.component eq false, "default component failed") />
	<cfset assertTrue(structKeyExists(propInfo, "explicit") and propInfo.explicit eq true, "default explicit failed") />
</cffunction>

<cffunction name="testExplicitSimpleInspection" returntype="void" access="public">
	<cfset var strategy = createStrategy() />
	<cfset var bean = createExplicitBean() />
	<cfset var properties = strategy.inspect(bean).properties />
	
	<cfset assertTrue(structKeyExists(properties, "explicitProperty"), "explicitProperty not found") />
	<cfset assertTrue(properties.explicitProperty.explicit, "exp property not marked as explicit") />
	<cfset assertTrue(properties.explicitProperty.name eq "explicitProperty", "exp property name failed") />
	<cfset assertTrue(properties.explicitProperty.type eq "string", "exp property type failed") />
	<cfset assertTrue(properties.explicitProperty.arbitraryMetadata eq "wakkaWakka", "exp arbitrary metadata failed") />

	<cfset assertTrue(structKeyExists(properties, "explicitPropertyWithoutType"), "explicitPropertyWithoutType not found") />
	<cfset assertTrue(properties.explicitPropertyWithoutType.name eq "explicitPropertyWithoutType", "exp property name failed") />
	<cfset assertTrue(properties.explicitPropertyWithoutType.type eq "string", "exp property type failed") />

</cffunction>

<cffunction name="testExplicitCollectionInspection" returntype="void" access="public">
	<cfset var strategy = createStrategy() />
	<cfset var bean = createExplicitBean() />
	<cfset var properties = strategy.inspect(bean).properties />
	
	<cfset assertTrue(structKeyExists(properties, "explicitCollection"), "explicitCollection not found") />
	<cfset assertTrue(structKeyExists(properties.explicitCollection, "collection"), "collection attribute not enumerated") />
	<cfset assertTrue(properties.explicitCollection.collection, "exp collection type failed") />
	<cfset assertFalse(properties.explicitProperty.collection, "exp non-collection type failed") />

</cffunction>

<cffunction name="testExplicitComponentInspection" returntype="void" access="public">
	<cfset var strategy = createStrategy() />
	<cfset var bean = createExplicitBean() />
	<cfset var properties = strategy.inspect(bean).properties />
	
	<cfset assertTrue(structKeyExists(properties, "explicitComponent"), "explicitComponent not found") />
	<cfset assertTrue(structKeyExists(properties.explicitComponent, "component"), "component attribute not enumerated") />
	<cfset assertTrue(properties.explicitComponent.component, "exp component type failed") />
	<cfset assertFalse(properties.explicitProperty.component, "exp non-component type failed") />

</cffunction>

<cffunction name="testImplicitSimpleInspection" returntype="void" access="public">
	<cfset var strategy = createStrategy() />
	<cfset var bean = createImplicitBean() />
	<cfset var properties = strategy.inspect(bean).properties />
	
	<cfset assertTrue(structKeyExists(properties, "implicitProperty"), "implicitProperty not found") />
	<cfset assertFalse(properties.implicitProperty.explicit, "imp property not marked as implicit") />
	<cfset assertTrue(properties.implicitProperty.name eq "implicitProperty", "imp property name failed") />
	<cfset assertTrue(properties.implicitProperty.type eq "string", "imp property type failed") />
	<cfset assertTrue(properties.implicitProperty.arbitraryMetadata eq "wakkaWakka", "imp arbitrary metadata failed") />

	<cfset assertTrue(structKeyExists(properties, "implicitPropertyWithoutType"), "implicitPropertyWithoutType not found") />
	<cfset assertTrue(properties.implicitPropertyWithoutType.name eq "implicitPropertyWithoutType", "imp property name failed") />
	<cfset assertTrue(properties.implicitPropertyWithoutType.type eq "string", "imp property type failed") />
	
</cffunction>

<cffunction name="testImplicitCollectionInspection" returntype="void" access="public">
	<cfset var strategy = createStrategy() />
	<cfset var bean = createImplicitBean() />
	<cfset var properties = strategy.inspect(bean).properties />
	
	<cfset assertTrue(structKeyExists(properties, "implicitCollection"), "implicitCollection not found") />
	<cfset assertTrue(structKeyExists(properties.implicitCollection, "collection"), "collection attribute not enumerated") />
	<cfset assertTrue(properties.implicitCollection.collection, "exp collection type failed") />
	<cfset assertFalse(properties.implicitProperty.collection, "exp non-collection type failed") />

</cffunction>

<cffunction name="testImplicitComponentInspection" returntype="void" access="public">
	<cfset var strategy = createStrategy() />
	<cfset var bean = createImplicitBean() />
	<cfset var properties = strategy.inspect(bean).properties />
	
	<cfset assertTrue(structKeyExists(properties, "implicitComponent"), "implicitComponent not found") />
	<cfset assertTrue(structKeyExists(properties.implicitComponent, "component"), "component attribute not enumerated") />
	<cfset assertTrue(properties.implicitComponent.component, "exp component type failed") />
	<cfset assertFalse(properties.implicitProperty.component, "exp non-component type failed") />

</cffunction>

<cffunction name="testToXml" returntype="void">
	<cfset var strategy = createStrategy() />
	<cfset var bean = createExplicitBean() />
	<cfset var props = strategy.inspect(bean).properties />
	<cfset var prop = "" />
	<cfset var xml = strategy.inspectAsXML(bean).xmlRoot />
	<cfset var i = "" />
	<cfset var j = "" />
	
	<cfloop collection="#xml#" item="i">
		<cfset prop = props[xml[i].name.xmlText] />
		<cfloop collection="#xml[i]#" item="j">
			<cfset assertTrue(prop[j] eq xml[i][j].xmlText, "XML property attribute #j# didn't match struct value for property #xml[i].name.xmlText#") />
		</cfloop>
	</cfloop>
</cffunction>

<cffunction name="testHash" returntype="void">
	<cfset var strategy = createStrategy() />
	<cfset var bean = createExplicitBean() />
	<cfset var bean2 = createExplicitBeanOneByteDifferent() />
	
	<cfset assertTrue(strategy.getHash(bean) eq strategy.getHash(bean), "Same bean should have same hash!") />
	<cfset assertTrue(strategy.getHash(bean) neq strategy.getHash(bean2), "Diff bean should have diff hash!") />
</cffunction>

</cfcomponent>