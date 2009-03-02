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

<cfset variables.System = createObject("java", "java.lang.System") />

<cffunction name="testExplicitSetUnknownProperty" returntype="void" access="public">
	<cfset var converter = createObject("component", "com.firemoss.beanutils.converter.StructConverter").init(createObject("component", "com.firemoss.beanutils.properties.DefaultInspectionStrategy").init()) />
	<cfset var bean = createObject("component", "com.firemoss.beanutils.converter.test.ExplicitBean") />
	
	<cfset converter.setProperty(bean, "fooBarProp", "fooBarValue") />
	
	<cfset assertFalse(structKeyExists(bean, "fooBarProp"), "Arbitrary property created!") />
</cffunction>

<cffunction name="testImplicitSetUnknownProperty" returntype="void" access="public">
	<cfset var converter = createObject("component", "com.firemoss.beanutils.converter.StructConverter").init(createObject("component", "com.firemoss.beanutils.properties.DefaultInspectionStrategy").init()) />
	<cfset var bean = createObject("component", "com.firemoss.beanutils.converter.test.ImplicitBean") />
	<cfset var val = "" />
	
	<cfset converter.setProperty(bean, "fooBarProp", "fooBarValue") />
	
	<cfset val = converter.getProperty(bean, "fooBarProp") />
	
	<cfset assertFalse(isDefined("val"), "Arbitrary property created!") />
</cffunction>

<cffunction name="testExplicitExtraction" returntype="void" access="public">
	<cfset var bean = createObject("component", "com.firemoss.beanutils.converter.test.ExplicitBean") />
	<cfset var componentBean = createObject("component", "com.firemoss.beanutils.properties.test.ComponentBean") />
	<cfset var childBean = createObject("component", "com.firemoss.beanutils.converter.test.ExplicitChildBean") />
	<cfset var converter = createObject("component", "com.firemoss.beanutils.converter.StructConverter").init(createObject("component", "com.firemoss.beanutils.properties.DefaultInspectionStrategy").init()) />
	<Cfset var struct = "" />
	
	<!--- Create cyclic references --->
	<cfset bean.child = childBean />
	<cfset childBean.parent = bean />

	<!--- Add a component instance to the simple array and struct to make sure we handle varying type array members --->
	<cfset arrayAppend(bean.array, componentBean) />
	<cfset bean.struct.componentBean = componentBean />
	<!--- Create a cyclic reference in both collection types --->
	<cfset bean.struct.childBean = childBean />
	<cfset arrayAppend(bean.array, childBean) />

	<cfset struct = converter.extract(bean) />
	
	<cfset assertTrue(toString(struct.binary) eq toString(bean.binary)) />
	<cfset assertTrue(struct.boolean eq bean.boolean) />
	<cfset assertTrue(struct.date eq bean.date) />
	<cfset assertTrue(struct.guid eq bean.guid) />
	<cfset assertTrue(struct.numeric eq bean.numeric) />
	<cfset assertTrue(struct.string eq bean.string) />
	<cfset assertTrue(struct.uuid eq bean.uuid) />
	<cfset assertTrue(arrayLen(struct.array) eq arrayLen(bean.array) and arrayLen(bean.array) eq 5, "arrayLen failed on array property") />
	<cfset assertTrue(struct.array[4].explicitProperty eq "explicitPropertyValue", "multi-type array component property failed") />
	<cfset assertTrue(struct.query.columnList eq bean.query.columnList, "query column list not same") />
	<cfset assertTrue(struct.struct.key eq bean.struct.key, "struct ""key"" value not same") />
	<cfset assertTrue(struct.struct.componentBean.explicitProperty eq bean.struct.componentBean.explicitProperty, "multi-type struct component property failed") />
	
	<cfset assertTrue(isStruct(struct.componentBean) and not isObject(struct.componentBean), "component bean not raw struct") />
	<cfset assertTrue(struct.componentBean.explicitProperty eq "explicitProperty", "component bean props not extracted") />

	<cfset assertTrue(isStruct(struct.componentProperty) and not isObject(struct.componentProperty), "component prop not raw struct") />
	<cfset assertTrue(struct.componentProperty.explicitProperty eq "componentExplicitProperty", "component prop props not extracted") />
	
	<!--- Test our basic circular reference --->
	<cfset assertTrue(structKeyExists(struct, "child"), "child not extracted. keys: #structKeyList(struct)#") />
	<cfset assertTrue(structKeyExists(struct.child, "parent"), "child did not contain parent property.") />
	<cfset assertTrue(structKeyExists(struct.child.parent, "uuid") and struct.child.parent.uuid eq bean.uuid, "parent property not same as initial bean or nonexistent") />		
	
	<!--- Test our collection circular references --->
	<cfset assertTrue(struct.array[5].parent.uuid eq bean.uuid, "cyclic in array collection failed") />
	<cfset assertTrue(struct.struct.childBean.parent.uuid eq bean.uuid, "cyclic in struct collection failed") />
</cffunction>

<cffunction name="testImplicitExtraction" returntype="void" access="public">
	<cfset var bean = createObject("component", "com.firemoss.beanutils.converter.test.ImplicitBean") />
	<cfset var componentBean = createObject("component", "com.firemoss.beanutils.properties.test.ComponentBean") />
	<cfset var childBean = createObject("component", "com.firemoss.beanutils.converter.test.ImplicitChildBean") />
	<cfset var converter = createObject("component", "com.firemoss.beanutils.converter.StructConverter").init(createObject("component", "com.firemoss.beanutils.properties.DefaultInspectionStrategy").init()) />
	<cfset var arrProp = bean.getArray() />
	<cfset var structProp = bean.getStruct() />
	<cfset var struct = "" />

	<!--- Create cyclic references --->
	<cfset bean.setChild(childBean) />
	<cfset childBean.setParent(bean) />

	<!--- Add a component instance to the simple array and struct to make sure we handle varying type array members --->
	<cfset arrayAppend(arrProp, componentBean) />
	<cfset structProp.componentBean = componentBean />
	<!--- Create a cyclic reference in both collection types --->
	<cfset structProp.childBean = childBean />
	<cfset arrayAppend(arrProp, childBean) />
	
	<!--- Set by-values back in --->
	<cfset bean.setArray(arrProp) />

	<cfset struct = converter.extract(bean) />

	<cfset assertTrue(toString(struct.binary) eq toString(bean.getbinary())) />
	<cfset assertTrue(struct.boolean eq bean.getboolean()) />
	<cfset assertTrue(struct.date eq bean.getdate()) />
	<cfset assertTrue(struct.guid eq bean.getguid()) />
	<cfset assertTrue(struct.numeric eq bean.getnumeric()) />
	<cfset assertTrue(struct.string eq bean.getstring()) />
	<cfset assertTrue(struct.uuid eq bean.getuuid()) />
	<cfset assertTrue(arrayLen(struct.array) eq arrayLen(bean.getarray()) and arrayLen(bean.getarray()) eq 5, "arrayLen failed on array property") />
	<cfset assertTrue(struct.array[4].explicitProperty eq "explicitPropertyValue", "multi-type array component property failed") />
	<cfset assertTrue(struct.query.columnList eq bean.getquery().columnList, "query column list not same") />
	<cfset assertTrue(struct.struct.key eq bean.getstruct().key, "struct ""key"" value not same") />
	<cfset assertTrue(struct.struct.componentBean.explicitProperty eq bean.getstruct().componentBean.explicitProperty, "multi-type struct component property failed") />
	
	<cfset assertTrue(isStruct(struct.componentBean) and not isObject(struct.componentBean), "component bean not raw struct") />
	<cfset assertTrue(struct.componentBean.explicitProperty eq "explicitProperty", "component bean props not extracted") />

	<cfset assertTrue(isStruct(struct.componentProperty) and not isObject(struct.componentProperty), "component prop not raw struct") />
	<cfset assertTrue(struct.componentProperty.explicitProperty eq "componentExplicitProperty", "component prop props not extracted") />

	<!--- Test our basic circular reference --->
	<cfset assertTrue(structKeyExists(struct, "child"), "child not extracted. keys: #structKeyList(struct)#") />
	<cfset assertTrue(structKeyExists(struct.child, "parent"), "child did not contain parent property.") />
	<cfset assertTrue(structKeyExists(struct.child.parent, "uuid") and struct.child.parent.uuid eq bean.getuuid(), "parent property not same as initial bean or nonexistent. keys: #structKeyList(struct.child.parent)#") />		

	<!--- Test our collection circular references --->
	<cfset assertTrue(struct.array[5].parent.uuid eq bean.getuuid(), "cyclic in array collection failed") />
	<cfset assertTrue(struct.struct.childBean.parent.uuid eq bean.getuuid(), "cyclic in struct collection failed") />
</cffunction>

<cffunction name="testExplicitInjection" returntype="void" access="public">
	<cfset var bean = createObject("component", "com.firemoss.beanutils.converter.test.ExplicitBean") />
	<cfset var componentBean = createObject("component", "com.firemoss.beanutils.properties.test.ComponentBean") />
	<cfset var childBean = createObject("component", "com.firemoss.beanutils.converter.test.ExplicitChildBean") />
	<cfset var converter = createObject("component", "com.firemoss.beanutils.converter.StructConverter").init(createObject("component", "com.firemoss.beanutils.properties.DefaultInspectionStrategy").init()) />
	<cfset var struct = "" />
		
	<!--- Create cyclic references --->
	<cfset bean.child = childBean />
	<cfset childBean.parent = bean />

	<!--- Collections of components are currently not injectable:  How do we know what to inject into?  TODO:  Add "collectionOf" metadata attribute. --->
	
	<cfset struct = converter.extract(bean) />
	
	<cfset bean.empty() />
	
	<!--- Make sure we emptied something --->
	<cfset assertFalse(toString(struct.binary) eq toString(bean.binary)) />
	
	<cfset converter.inject(struct, bean) />
	
	<cfset assertTrue(toString(struct.binary) eq toString(bean.binary)) />
	<cfset assertTrue(struct.boolean eq bean.boolean) />
	<cfset assertTrue(struct.date eq bean.date) />
	<cfset assertTrue(struct.guid eq bean.guid) />
	<cfset assertTrue(struct.numeric eq bean.numeric) />
	<cfset assertTrue(struct.string eq bean.string) />
	<cfset assertTrue(struct.uuid eq bean.uuid) />
	<cfset assertTrue(arrayLen(struct.array) eq arrayLen(bean.array) and arrayLen(bean.array) eq 3, "arrayLen failed on array property") />
	<cfset assertTrue(struct.query.columnList eq bean.query.columnList, "query column list not same") />
	<cfset assertTrue(struct.struct.key eq bean.struct.key, "struct ""key"" value not same") />
	
	<cfset assertTrue(isObject(bean.componentBean), "component bean not object") />
	<cfset assertTrue(bean.componentBean.explicitProperty eq "explicitProperty", "component bean props not injected") />

	<!--- we can't inject of type "component" yet:  we don't know what CFC to instantiate w/ extra metadata!
	<cfset assertTrue(isObject(bean.componentProperty), "component bean not object") />
	<cfset assertTrue(bean.componentProperty.explicitProperty eq "componentExplicitProperty", "component prop props not injected") />
	 --->
	 
	<!--- Test our basic circular reference --->
	<cfset assertTrue(isObject(bean.child), "child not object after injection") />
	<cfset assertTrue(isObject(bean.child.parent), "child not linked to parent after injection") />
	<cfset assertTrue(System.identityHashCode(bean) eq System.identityHashCode(bean.child.parent), "child's parent not same instance as parent") />
	
</cffunction>

<cffunction name="testImplicitInjection" returntype="void" access="public">
	<cfset var bean = createObject("component", "com.firemoss.beanutils.converter.test.ImplicitBean") />
	<cfset var componentBean = createObject("component", "com.firemoss.beanutils.properties.test.ComponentBean") />
	<cfset var childBean = createObject("component", "com.firemoss.beanutils.converter.test.ImplicitChildBean") />
	<cfset var converter = createObject("component", "com.firemoss.beanutils.converter.StructConverter").init(createObject("component", "com.firemoss.beanutils.properties.DefaultInspectionStrategy").init()) />
	<cfset var struct = "" />
		
	<!--- Create cyclic references --->
	<cfset bean.setChild(childBean) />
	<cfset childBean.setParent(bean) />

	<!--- Collections of components are currently not injectable:  How do we know what to inject into?  TODO:  Add "collectionOf" metadata attribute. --->
	
	<cfset struct = converter.extract(bean) />
	
	<cfset bean.empty() />
	
	<!--- Make sure we emptied something --->
	<cfset assertFalse(toString(struct.binary) eq toString(bean.getBinary())) />
	
	<cfset converter.inject(struct, bean) />
	
	<cfset assertTrue(toString(struct.binary) eq toString(bean.getbinary())) />
	<cfset assertTrue(struct.boolean eq bean.getboolean()) />
	<cfset assertTrue(struct.date eq bean.getdate()) />
	<cfset assertTrue(struct.guid eq bean.getguid()) />
	<cfset assertTrue(struct.numeric eq bean.getnumeric()) />
	<cfset assertTrue(struct.string eq bean.getstring()) />
	<cfset assertTrue(struct.uuid eq bean.getuuid()) />
	<cfset assertTrue(arrayLen(struct.array) eq arrayLen(bean.getarray()) and arrayLen(bean.getarray()) eq 3, "arrayLen failed on array property") />
	<cfset assertTrue(struct.query.columnList eq bean.getquery().columnList, "query column list not same") />
	<cfset assertTrue(struct.struct.key eq bean.getstruct().key, "struct ""key"" value not same") />
	
	<cfset assertTrue(isObject(bean.getcomponentBean()), "component bean not object") />
	<cfset assertTrue(bean.getcomponentBean().explicitProperty eq "explicitProperty", "component bean props not injected") />

	<!--- we can't inject of type "component" yet:  we don't know what CFC to instantiate w/ extra metadata!
	<cfset assertTrue(isObject(bean.getcomponentProperty()), "component bean not object") />
	<cfset assertTrue(bean.getcomponentProperty().explicitProperty eq "componentExplicitProperty", "component prop props not injected") />
	--->

	<!--- Test our basic circular reference --->
	<cfset assertTrue(isObject(bean.getChild()), "child not object after injection") />
	<cfset assertTrue(isObject(bean.getChild().getParent()), "child not linked to parent after injection") />
	<cfset assertTrue(System.identityHashCode(bean) eq System.identityHashCode(bean.getChild().getParent()), "child's parent not same instance as parent") />
</cffunction>

</cfcomponent>