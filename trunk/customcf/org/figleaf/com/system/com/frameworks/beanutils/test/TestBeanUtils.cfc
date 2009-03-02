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

<cffunction name="testBeanIsDirtyWithCaching" returntype="void" access="public">
	<cfset var bean = createObject("component", "com.firemoss.beanutils.properties.test.ExplicitBean") />
	<cfset var bu = createObject("component", "com.firemoss.beanutils.BeanUtils").init() />
	
	<cfset assertTrue(bu.propertiesAreDirty(bean), "failed first check") />
	
	<cfset bu.inspect(bean) />
	
	<cfset assertFalse(bu.propertiesAreDirty(bean), "failed second check") />
</cffunction>	

<cffunction name="testBeanIsDirtyWithoutCaching" returntype="void" access="public">
	<cfset var bean = createObject("component", "com.firemoss.beanutils.properties.test.ExplicitBean") />
	<cfset var bu = createObject("component", "com.firemoss.beanutils.BeanUtils").init(false) />
	
	<cfset assertTrue(bu.propertiesAreDirty(bean), "failed first check") />
	
	<cfset bu.inspect(bean) />
	
	<cfset assertTrue(bu.propertiesAreDirty(bean), "failed second check") />
</cffunction>	

<!--- 
	The following tests of prop manip functions are simplistic.  See the tests in converter/test
	to see full tests of all types, nested structures, etc.
--->
<cffunction name="testExtract" returntype="void" access="public">
	<cfset var bean = createObject("component", "com.firemoss.beanutils.properties.test.ComponentBean") />
	<cfset var bu = createObject("component", "com.firemoss.beanutils.BeanUtils").init() />
	<cfset var struct = bu.extract(bean) />
	
	<cfset assertTrue(struct.explicitProperty eq "explicitPropertyValue", "Bean was not extracted.") />
</cffunction>

<cffunction name="testInject" returntype="void" access="public">
	<cfset var bean = createObject("component", "com.firemoss.beanutils.properties.test.ComponentBean") />
	<cfset var bu = createObject("component", "com.firemoss.beanutils.BeanUtils").init() />
	<cfset var struct = structNew() />
	
	<cfset struct.explicitProperty = "foo" />
	<cfset bu.inject(struct, bean) />
	
	<cfset assertTrue(bean.explicitProperty eq "foo", "Bean was not injected.") />
</cffunction>

<cffunction name="testGetProperty" returntype="void" access="public">
	<cfset var bean = createObject("component", "com.firemoss.beanutils.properties.test.ComponentBean") />
	<cfset var bu = createObject("component", "com.firemoss.beanutils.BeanUtils").init() />
	<cfset var prop = bu.getProperty(bean, "explicitProperty") />
	
	<cfset assertTrue(prop eq "explicitPropertyValue", "Property not gotten.") />
</cffunction>

<cffunction name="testSetProperty" returntype="void" access="public">
	<cfset var bean = createObject("component", "com.firemoss.beanutils.properties.test.ComponentBean") />
	<cfset var bu = createObject("component", "com.firemoss.beanutils.BeanUtils").init() />
	
	<cfset bu.setProperty(bean, "explicitProperty", "foo") />
	
	<cfset assertTrue(bean.explicitProperty eq "foo", "Property not set.") />
</cffunction>

</cfcomponent>