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

<cffunction name="testIsColdFusionType" returntype="void" access="public">
	<cfset var cfTypes = createObject("component", "com.firemoss.beanutils.type.ColdFusionTypes").init() />
	
	<cfset assertTrue(cfTypes.isColdFusionType("array")) />
	<cfset assertTrue(cfTypes.isColdFusionType("binary")) />
	<cfset assertTrue(cfTypes.isColdFusionType("boolean")) />
	<cfset assertTrue(cfTypes.isColdFusionType("date")) />
	<cfset assertTrue(cfTypes.isColdFusionType("guid")) />
	<cfset assertTrue(cfTypes.isColdFusionType("numeric")) />
	<cfset assertTrue(cfTypes.isColdFusionType("query")) />
	<cfset assertTrue(cfTypes.isColdFusionType("string")) />
	<cfset assertTrue(cfTypes.isColdFusionType("struct")) />
	<cfset assertTrue(cfTypes.isColdFusionType("uuid")) />
</cffunction>

<cffunction name="testIsCollectionType" returntype="void" access="public">
	<cfset var cfTypes = createObject("component", "com.firemoss.beanutils.type.ColdFusionTypes").init() />
	
	<cfset assertTrue(cfTypes.isCollectionType("array")) />
	<cfset assertFalse(cfTypes.isCollectionType("binary")) />
	<cfset assertFalse(cfTypes.isCollectionType("boolean")) />
	<cfset assertFalse(cfTypes.isCollectionType("date")) />
	<cfset assertFalse(cfTypes.isCollectionType("guid")) />
	<cfset assertFalse(cfTypes.isCollectionType("numeric")) />
	<cfset assertFalse(cfTypes.isCollectionType("query")) />
	<cfset assertFalse(cfTypes.isCollectionType("string")) />
	<cfset assertTrue(cfTypes.isCollectionType("struct")) />
	<cfset assertFalse(cfTypes.isCollectionType("uuid")) />
</cffunction>

<cffunction name="testIsComponentType" returntype="void" access="public">
	<cfset var cfTypes = createObject("component", "com.firemoss.beanutils.type.ColdFusionTypes").init() />
	
	<cfset assertFalse(cfTypes.isComponentType("array")) />
	<cfset assertFalse(cfTypes.isComponentType("binary")) />
	<cfset assertFalse(cfTypes.isComponentType("boolean")) />
	<cfset assertFalse(cfTypes.isComponentType("date")) />
	<cfset assertFalse(cfTypes.isComponentType("guid")) />
	<cfset assertFalse(cfTypes.isComponentType("numeric")) />
	<cfset assertFalse(cfTypes.isComponentType("query")) />
	<cfset assertFalse(cfTypes.isComponentType("string")) />
	<cfset assertFalse(cfTypes.isComponentType("struct")) />
	<cfset assertFalse(cfTypes.isComponentType("uuid")) />
	<cfset assertTrue(cfTypes.isComponentType("some.component.path")) />
</cffunction>

</cfcomponent>