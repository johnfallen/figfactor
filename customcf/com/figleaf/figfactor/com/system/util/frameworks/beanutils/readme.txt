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


BeanUtils
Joe Rinehart (contact@firemoss.com)
BeanUtils Alpha (0.3).

BeanUtils isn't a library for mass use: it's intended for framework and tooling authors.

It's designed for folks building frameworks that manipulate "bean"-style CFCs, and focuses on enumerating and manipulating properties (defined by either <cfproperty> or getter functions).

Its primary APIs are the BeanUtils and StructConverter CFCs.

BeanUtils.cfc provides methods such as:

inspect(): returning all explicit (<cfproperty>) and implicit properties (getNNN) of a CFC instance

inspectAsXML: inspect()'s result as XML)

methods to allow type-based caching of property information (getHash(), propertiesAreDirty()).

extract(): extracts a bean's data to a structure. It follows collections, and elegantly handles cyclic graphs (returning a cyclic struct, so don't <cfdump> it).

inject(): a struct of data into a CFC, but doesn't yet handle injecting collections of CFCs.

setProperty(bean, propname, value): sets a property's value regardless of setter style (<cfproperty>/THIS scope or setNNN)

getProperty(bean, propname): gets a property's value regardless of getter style (<cfproperty>/THIS scope or getNNN)

** URLS TO KNOW ** 

http://beanutils.riaforge.org - The homepage for BeanUtils.
http://www.firemoss.com - Firemoss homepage.  Use it to contact the author.

** FULL DOCUMENTATION **

This is a tool for framework developers.  The API is documented with plenty of HINT attributes on the CFCs.


** WHEN THINGS BREAK **

Please add a new issue at http://beanutils.riaforge.org/index.cfm?event=page.addissue .

** LICENSE INFORMATION **

This software is licensed under the Apache Software License 2.0 (ASL2).  See LICENSE.

