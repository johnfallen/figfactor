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

Title:      CFLog4j.cfc

Author:     Qasim Rasheed
Email:      qasimrasheed@gmail.com

Purpose:    Utlitity class which gives an Interface to log4j.

Usage:      1. Creates an instance of this class as a singelton as setting a configuration is an expensive process and should be done only once.
			<cfif not structkeyexists( application, 'init' )>
				<cfset CFLog4jConfig = createobject( 'component', 'com.cflog4j.CFLog4jConfig' ).init()>
				<cfset application.CFLog4J = createobject( 'component', 'com.cflog4j.CFLog4j' ).init( CFLog4jConfig ) />
 				<cfset application.init = true />
			</cfif>
			<cfset logger = application.CFLog4J.getCategoryInstance()>
			<cfset logger.info( "It's hard enough to find an error in your code when you're looking for it; it's even harder when you've assumed your code is error-free (Steve McConnell)." )>
			
			2. Using ColdSpring
				<bean id="CFLog4j" class="com.cflog4j.CFLog4j" init-method="configure">
					<constructor-arg name="cflog4jconfig">
						<bean class="com.cflog4j.CFLog4jConfig">
							<constructor-arg name="configFile">
								<value>/com/cflog4j/cflog4j.xml</value>
							</constructor-arg>
						</bean>
		  			</constructor-arg>	
				</bean>
				
Modification Log:

Name			Date			Description
================================================================================

------------------------------------------------------------------------------->

<cfcomponent output="false" displayname="Logger" hint="I am a CF interface to Log4J API.">

<cfset variables._configurator = listlast( getMetaData(this).name, '.' ) />

<cffunction name="init" returntype="CFLog4j" output="false" access="public" hint="Constructor">
	<cfargument name="cflog4jconfig" type="CFLog4jConfig" required="true" hint="configuration object." />
	<cfset setCFLog4jConfig( arguments.cflog4jconfig ) />
	<cfset configure() />
	<cfreturn this />
</cffunction>

<cffunction name="configure" returntype="void" access="public" output="false" 
	hint="I am a method that does all initialization for this CFC. This can be used as init-method, if you are planning on using this CFC with ColdSpring.">
	<cfset setLog4jarLoader( getCFLog4jConfig().getLog4JarFile() ) />
	<cfset setConfigurator( getCFLog4jConfig().getLog4jProperties(), getCFLog4jConfig().getReloadConfigAfterMinutes() ) />
</cffunction>

<!--- Public Methods --->
<cffunction name="getVersion" returntype="string" access="public" output="false" hint="Retrieves the version you are using" >
	<cfreturn "0.1">
</cffunction>

<cffunction name="getCategoryInstance" returntype="any" access="public" output="false" 
	hint="I return a category instance. If no cat arguments is passed to me, I will return the default Category CFLog4j whose appender is defined in log4j.properties file.">
	<cfargument name="cat" type="string" required="false" hint="Name of the log4j Category which will de defined in log4j.properties file." />
	<cfset var category = createClassFromLog4jarLoader( 'org.apache.log4j.Category' )>
	<cfset var logger =  "" />
	<cfif structkeyexists( arguments, 'cat' )>
		<cfset logger = category.getInstance( arguments.cat )>
	<cfelse>
		<cfset logger =  category.getInstance( variables._configurator )>
	</cfif>	
	<cfset logger.setAdditivity(false)>
	<cfreturn logger />
</cffunction>

<cffunction name="info" returntype="void" access="public" output="false" hint="">
	<cfargument name="logger" type="any" required="true" hint="Logger" />
	<cfargument name="message" type="string" required="true" hint="message to be logged." />
	<cfset logMessage( arguments.logger, 'info', arguments.message ) />
</cffunction>

<cffunction name="debug" returntype="void" access="public" output="false" hint="">
	<cfargument name="logger" type="any" required="true" hint="Logger" />
	<cfargument name="message" type="string" required="true" hint="message to be logged." />
	<cfset logMessage( arguments.logger, 'debug', arguments.message ) />
</cffunction>

<cffunction name="warn" returntype="void" access="public" output="false" hint="">
	<cfargument name="logger" type="any" required="true" hint="Logger" />
	<cfargument name="message" type="string" required="true" hint="message to be logged." />
	<cfset logMessage( arguments.logger, 'warn', arguments.message ) />
</cffunction>

<cffunction name="error" returntype="void" access="public" output="false" hint="">
	<cfargument name="logger" type="any" required="true" hint="Logger" />
	<cfargument name="message" type="string" required="true" hint="message to be logged." />
	<cfset logMessage( arguments.logger, 'error', arguments.message ) />
</cffunction>

<!--- Private Methods --->
<cffunction name="logMessage" returntype="void" access="private" output="false" hint="">
	<cfargument name="logger" type="any" required="true" hint="Logger" />
	<cfargument name="type" type="string" required="true" hint="" />
	<cfargument name="message" type="string" required="true" hint="message to be logged." />
	<cfset var priority = createClassFromLog4jarLoader( 'org.apache.log4j.Priority' ).toPriority( arguments.type )>
	<cfif canLog( arguments.logger, priority, arguments.type )>
		<cfset arguments.logger.log( priority, arguments.message ) />
	</cfif>
</cffunction>

<cffunction name="canLog" returntype="boolean" access="private" output="false" hint="">
	<cfargument name="logger" type="any" required="true" hint="Logger" />
	<cfargument name="priority" type="any" required="true" hint="" />
	<cfargument name="type" type="string" required="true" hint="" />
	<cfif arguments.type eq 'info'>	
		<cfreturn arguments.logger.isInfoEnabled() />
	<cfelseif arguments.type eq 'debug'>
		<cfreturn arguments.logger.isDebugEnabled() />
	<cfelse>
		<cfreturn arguments.logger.isEnabledFor( arguments.priority ) />
	</cfif>
</cffunction>

<cffunction name="createClassFromLog4jarLoader" access="private" returntype="any" output="false" hint="Getter for Log4jarLoader">
	<cfargument name="className" type="string" required="true" hint="name of class" />
	<cfscript>
	var class = variables._Log4jarLoader.loadClass( arguments.className );
	return createObject( 'java', 'coldfusion.runtime.java.JavaProxy' ).init(class); 
	</cfscript>
</cffunction>

<cffunction name="setLog4jarLoader" access="private" returntype="void" output="false" hint="Setter for Log4jarLoader">
	<cfargument name="log4jarFile" type="string" required="true" hint="log4j jar file with full path" />
	<cfscript>
	var Array = createObject( "java", "java.lang.reflect.Array" );
	var Class = createObject( "java", "java.lang.Class" );
	var URLs = Array.newInstance( Class.forName( 'java.net.URL' ), JavaCast( 'int', 1 ) );
	var file = createobject( 'java', 'java.io.File' ).init( arguments.log4jarFile );
	Array.set( URLs, JavaCast( 'int', 0 ), file.toURL() );
	variables._Log4jarLoader = createObject( 'java', 'java.net.URLClassLoader' ).init( URLs, getClass().getClassLoader() );
	</cfscript>
</cffunction>

<cffunction name="setConfigurator" returntype="void" access="private" output="false" hint="">
	<cfargument name="propertyFile" type="string" required="true" hint="file and location of log4j properties file." />
	<cfargument name="reloadConfigAfterMinutes" type="string" required="true" hint="" />
	<cfset var configurator = createClassFromLog4jarLoader( 'org.apache.log4j.PropertyConfigurator' ).init()>
	<cfif trim( arguments.reloadConfigAfterMinutes ) neq ''>
		<cfset configurator.configureAndWatch( arguments.propertyFile, javacast( 'long', arguments.reloadConfigAfterMinutes ) ) />
	<cfelse>
		<cfset configurator.configure( arguments.propertyFile )>
	</cfif>
</cffunction>

<!--- Getters & Setters --->
<cffunction name="getCFLog4jConfig" access="private" returntype="CFLog4jConfig" output="false" hint="Getter for CFLog4jConfig">
	<cfreturn variables._cflog4jConfig />
</cffunction>

<cffunction name="setCFLog4jConfig" access="private" returntype="void" output="false" hint="Setter for CFLog4jConfig">
	<cfargument name="cflog4jconfig" type="CFLog4jConfig" required="true" hint="configuration object." />
	<cfset variables._cflog4jConfig = arguments.cflog4jConfig>
</cffunction>

</cfcomponent>