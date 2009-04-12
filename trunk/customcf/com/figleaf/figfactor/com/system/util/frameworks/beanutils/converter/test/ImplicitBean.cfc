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

<cfset vals = createObject("component", "com.firemoss.beanutils.test.SampleTypeValues") />

<cfloop collection="#vals#" item="i">
	<cfset variables[i] = vals[i] />
</cfloop>
<cfset variables._child = "" />
<cfset variables._componentBean = createObject("component", "com.firemoss.beanutils.properties.test.ComponentBean") />
<cfset variables._componentBean.explicitProperty = "explicitProperty" />
<cfset variables._componentProperty = createObject("component", "com.firemoss.beanutils.properties.test.ComponentBean") />
<cfset variables._componentProperty.explicitProperty = "componentExplicitProperty" />

<cffunction name="getState">
	<cfreturn variables />
</cffunction>

<cffunction name="empty">
	<cfset var i = "" />
	<cfloop collection="#vals#" item="i">
		<cfset variables[i] = "" />
	</cfloop>
</cffunction>

<cffunction name="getarray" returntype="array"> <cfreturn variables.array /> </cffunction>
<cffunction name="getbinary"><cfreturn variables.binary /> </cffunction>
<cffunction name="getboolean" returntype="boolean"> <cfreturn variables.boolean /> </cffunction>
<cffunction name="getdate" returntype="date"> <cfreturn variables.date /> </cffunction>
<cffunction name="getguid" returntype="guid"> <cfreturn variables.guid /> </cffunction>
<cffunction name="getnumeric" returntype="numeric"> <cfreturn variables.numeric /> </cffunction>
<cffunction name="getquery" returntype="query"> <cfreturn variables.query /> </cffunction>
<cffunction name="getstring" returntype="string"> <cfreturn variables.string /> </cffunction>
<cffunction name="getstruct" returntype="struct"> <cfreturn variables.struct /> </cffunction>
<cffunction name="getuuid" returntype="uuid"> <cfreturn variables.uuid /> </cffunction>

<cffunction name="setarray"><cfargument name="value"> <cfset variables.array = value /></cffunction>
<cffunction name="setbinary"><cfargument name="value"> <cfset variables.binary = value /></cffunction>
<cffunction name="setboolean"><cfargument name="value"> <cfset variables.boolean = value /></cffunction>
<cffunction name="setdate"><cfargument name="value"> <cfset variables.date = value /></cffunction>
<cffunction name="setguid"><cfargument name="value"> <cfset variables.guid = value /></cffunction>
<cffunction name="setnumeric"><cfargument name="value"> <cfset variables.numeric = value /></cffunction>
<cffunction name="setquery"><cfargument name="value"> <cfset variables.query = value /></cffunction>
<cffunction name="setstring"><cfargument name="value"> <cfset variables.string = value /></cffunction>
<cffunction name="setstruct"><cfargument name="value"> <cfset variables.struct = value /></cffunction>
<cffunction name="setuuid"><cfargument name="value"> <cfset variables.uuid = value /></cffunction>

<cffunction name="setChild"><cfargument name="value"><cfset variables._child = value /></cffunction>
<cffunction name="getChild" returnType="com.firemoss.beanutils.converter.test.ImplicitChildBean"><cfreturn variables._child /></cffunction>

<cffunction name="setComponentBean"><cfargument name="value"><cfset variables._componentBean = value /></cffunction>
<cffunction name="getComponentBean" returnType="com.firemoss.beanutils.properties.test.ComponentBean"><cfreturn variables._componentBean /></cffunction>

<cffunction name="setComponentProperty"><cfargument name="value"><cfset variables._componentProperty = value /></cffunction>
<cffunction name="getComponentProperty" returnType="component"><cfreturn variables._componentProperty /></cffunction>

</cfcomponent>