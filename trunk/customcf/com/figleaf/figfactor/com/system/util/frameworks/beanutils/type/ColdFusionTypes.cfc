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


<cfcomponent output="false" hint="I enumerate ColdFusion types.">

<cfset this.cftypes = structNew() />
<cfset this.cftypes.array = "array" />
<cfset this.cftypes.binary = "binary" />
<cfset this.cftypes.boolean = "boolean" />
<cfset this.cftypes.date = "date" />
<cfset this.cftypes.guid = "guid" />
<cfset this.cftypes.numeric = "numeric" />
<cfset this.cftypes.query = "query" />
<cfset this.cftypes.string = "string" />
<cfset this.cftypes.struct = "struct" />
<cfset this.cftypes.uuid = "uuid" />

<cffunction name="init" output="false" hint="Constructor">
	<cfreturn this />
</cffunction>
 
<cffunction name="isColdFusionType" returntype="boolean">
	<cfargument name="typeName" type="string" />
	
	<cfreturn structKeyExists(this.cftypes, arguments.typeName) />
</cffunction>

<cffunction name="isCollectionType" returntype="boolean">
	<cfargument name="typeName" type="string" />
	
	<cfreturn arguments.typeName eq "array" or arguments.typeName eq "struct" />
</cffunction>

<cffunction name="isComponentType" returntype="boolean">
	<cfargument name="typeName" type="string" />
	
	<cfreturn not isColdFusionType(arguments.typeName) />
</cffunction>

</cfcomponent>