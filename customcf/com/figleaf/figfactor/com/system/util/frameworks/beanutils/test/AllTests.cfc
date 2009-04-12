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


<cfcomponent displayname="AllTests" output="false">

<cffunction name="suite" returntype="org.cfcunit.framework.Test" access="public" output="false">
	<cfset var suite = CreateObject("component", "org.cfcunit.framework.TestSuite").init("Test Suite")>

	<cfset suite.addTestSuite(CreateObject("component", "com.firemoss.beanutils.properties.test.TestDefaultInspectionStrategy"))>
	<cfset suite.addTestSuite(CreateObject("component", "com.firemoss.beanutils.type.test.TestColdFusionTypes"))>
	<cfset suite.addTestSuite(CreateObject("component", "com.firemoss.beanutils.converter.test.TestStructConverter"))>
	<cfset suite.addTestSuite(CreateObject("component", "com.firemoss.beanutils.test.TestBeanUtils"))>

	<cfreturn suite/>
</cffunction>

</cfcomponent>