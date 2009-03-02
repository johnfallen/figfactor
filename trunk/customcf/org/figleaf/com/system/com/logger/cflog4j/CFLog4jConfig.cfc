<!--- -----------------------------------------------------
Copyright: (c) 2006 The CFLog4j Author
Author: Qasim Rasheed (qasimrasheed@gmail.com)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.

Title:      CFLog4jConfig.cfc

Author:     Qasim Rasheed
Email:      qasimrasheed@gmail.com

Purpose:    Configuration Bean for CFLog4j

Usage:      1. Creates the configuration bean without passing a config.xml file. 
				<cfset CFLog4jConfig = createobject( 'component', 'com.cflog4j.CFLog4jConfig' ).init()>
			2. Creates the configuration bean with config.xml file. 
				<cfset CFLog4jConfig = createobject( 'component', 'com.cflog4j.CFLog4jConfig' ).init( expandpath( 'cflog4j.xml' ) )>
			3. Example  usage for ColdSpring is defined in CFLof4j.cfc

Modification Log:

Name			Date			Description
================================================================================

------------------------------------------------------------------------------->

<cfcomponent output="false" displayname="CFLog4jConfig" hint="">

<cfset variables._path = getdirectoryfrompath( getcurrenttemplatepath() ) />
<cfset variables._reloadConfigAfterMinutes = '' />


<cffunction name="init" returntype="CFLog4jConfig" output="false" access="public" hint="Constructor">
	<cfargument name="configFile" type="string" required="false" hint="config file with path. If nothing is sepcified I assume that cflog4j.xml in this cfc's path." />
	<cfset var configXML =  "" />
	<cfif not structkeyexists( arguments, 'configFile' )>
		<cfset arguments.configFile = variables._path & 'cflog4j.xml'>
	</cfif>
	<cfset configXML =  validateAndParseConfigXML( arguments.configFile ) />
	<cfset setLog4jProperties( configXML ) />
	<cfset setLog4JarFile( configXML ) />
	<cfset setReloadConfigAfterMinutes( configXML ) />
	<cfreturn this />
</cffunction>

<!--- Package Methods --->
<cffunction name="getLog4JarFile" access="package" returntype="string" output="false" hint="Getter for Log4JarFile">
	<cfreturn variables._log4JarFile />
</cffunction>

<cffunction name="getLog4jProperties" access="package" returntype="string" output="false" hint="Getter for Log4jProperties">
	<cfreturn variables._log4jProperties />
</cffunction>

<cffunction name="getReloadConfigAfterMinutes" access="package" returntype="string" output="false" hint="Getter for ReloadConfigAfterMinutes">
	<cfreturn variables._reloadConfigAfterMinutes />
</cffunction>

<!--- PRIVATE METHODS --->
<cffunction name="validateAndParseConfigXML" returntype="string" access="private" output="false" hint="">
	<cfargument name="configFile" type="string" required="true" hint="configuration file" />
	<cfset var configXML =  "" />
	<cfif not fileExists( arguments.configFile )>
		<cfthrow type="CFLog4JConfig.InvalidPathToConfig"
				message="Invalid Path To Config"
				detail="The path #arguments.configFile# does not exist." />
	</cfif>
	<cffile action="read" file="#arguments.configFile#" variable="configXML">
	<cftry>
		<cfset configXML = xmlparse( configXML ) />
		<cfcatch type="any">
			<cfthrow type="CFLog4JConfig.InvalidConfigXML" 
 	                 message="Invalid XML Object" 
 	                 detail="configXml is not a valid XML Object." />
		</cfcatch>
	</cftry>
	<cfreturn configXML />
</cffunction>

<cffunction name="checkFile" returntype="string" access="private" output="false" hint="">
	<cfargument name="file" type="string" required="true" hint="name of the file" />
	<cfset var filename = arguments.file />
	<cfif not FileExists( arguments.file )>
		<cfset arguments.file = variables._path & arguments.file>
		<cfif not FileExists( arguments.file)>
			<cfthrow type="CFLog4JConfig.InvalidPathToFile"
					message="Invalid Path To #filename#"
					detail="The path to #filename# file is invalid. I have also search for this file in this path #variables._path#" />
		</cfif>
	</cfif>
	<cfreturn arguments.file />
</cffunction>

<cffunction name="setLog4jProperties" access="private" returntype="void" output="false" hint="Setter for Log4jProperties">
	<cfargument name="configXML" type="string" required="true" hint="configuration file XML." />
	<cfset variables._log4jProperties = checkFile( xmlsearch( arguments.configXML, '//cflog4j/propertyFile/' ).firstElement().xmlAttributes.value ) />
</cffunction>

<cffunction name="setLog4JarFile" access="private" returntype="void" output="false" hint="Setter for Log4JarFile">
	<cfargument name="configXML" type="string" required="true" hint="configuration file XML." />
	<cfset variables._log4JarFile = checkFile( xmlsearch( arguments.configXML, '//cflog4j/log4jJar/' ).firstElement().xmlAttributes.value ) />
</cffunction>

<cffunction name="setReloadConfigAfterMinutes" access="private" returntype="void" output="false" hint="Setter for ReloadConfigAfterMinutes">
	<cfargument name="configXML" type="string" required="true" hint="configuration file XML." />
	<cfset var reload = xmlsearch( arguments.configXML, '//cflog4j/reloadConfigAfterMinutes/' ) />
	
	<cfif ArrayLen( reload )>
		<cfset reload = reload.firstElement().xmlAttributes.value>
		<cfif trim( reload ) neq '' and IsNumeric( reload )>
			<cfset variables._reloadConfigAfterMinutes = reload * 60000>		
		</cfif>
	</cfif>
</cffunction>

</cfcomponent>