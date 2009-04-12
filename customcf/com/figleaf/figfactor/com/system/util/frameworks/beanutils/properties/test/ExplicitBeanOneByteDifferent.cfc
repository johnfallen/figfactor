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


<cfcomponent>

<cfproperty name="explicitProperty" type="string" arbitraryMetadata="qakkaWakka" />
<cfproperty name="explicitPropertyWithoutType"/>
<cfproperty name="explicitCollection" type="array" />
<cfproperty name="explicitComponent" type="com.firemoss.beanutils.properties.test.ComponentBean" />

<cffunction name="init" output="false" hint="Constructor">
	<cfreturn this />
</cffunction>

</cfcomponent>