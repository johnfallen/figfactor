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


<cfcomponent output="false" hint="I provide sample data for tests.">

<cfset this.array = listToArray("red,green,blue") />
<cfset this.binary = binaryDecode(toBase64("binaryString"), "base64") />
<cfset this.boolean = true />
<cfset this.date = createDate(2000, 1, 1) />
<cfset this.guid = "2afe2685-5614-4985-a1e0-ad65fe65fadc" />
<cfset this.numeric = 12345 />
<cfset this.query = queryNew("col1,col2") />
<cfset this.string = "imaString" />
<cfset this.struct = structNew() />
<cfset this.struct.key = "value" />
<cfset this.uuid = createUUID() />

</cfcomponent>