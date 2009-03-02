<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			Mapping.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am a mapping definition
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		03/02/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Mapping" output="false"
	hint="I am a mapping definition">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Mapping" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfset setAllowedExtensions() />
	<cfset setIsDeployable() />
	<cfset setName() />
	<cfset setRecursive() />
	<cfset setType() />
	<cfset setDestination() />
	<cfset setSource() />
	
	<cfreturn this />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- IsDeployable --->
<cffunction name="setIsDeployable" access="public" output="false" returntype="void">
	<cfargument name="IsDeployable" type="boolean" required="false" default="true"/>
	<cfset variables.instance.IsDeployable = arguments.IsDeployable />
</cffunction>
<cffunction name="getIsDeployable" access="public" output="false" returntype="boolean">
	<cfreturn variables.instance.IsDeployable />
</cffunction>
<!--- AllowedExtensions --->
<cffunction name="setAllowedExtensions" access="public" output="false" returntype="void">
	<cfargument name="AllowedExtensions" type="string" required="false" default=""/>
	<cfset variables.instance.AllowedExtensions = arguments.AllowedExtensions />
</cffunction>
<cffunction name="getAllowedExtensions" access="public" output="false" returntype="string">
	<cfreturn variables.instance.AllowedExtensions />
</cffunction>
<!--- Name --->
<cffunction name="setName" access="public" output="false" returntype="void">
	<cfargument name="Name" type="string" default="" />
	<cfset variables.instance.Name = arguments.Name />
</cffunction>
<cffunction name="getName" access="public" output="false" returntype="string">
	<cfreturn variables.instance.Name />
</cffunction>
<!--- Recursive --->
<cffunction name="setRecursive" access="public" output="false" returntype="void">
	<cfargument name="Recursive" type="boolean" required="false" default="false"/>
	<cfset variables.instance.Recursive = arguments.Recursive />
</cffunction>
<cffunction name="getRecursive" access="public" output="false" returntype="boolean">
	<cfreturn variables.instance.Recursive />
</cffunction>
<!--- Type --->
<cffunction name="setType" access="public" output="false" returntype="void">
	<cfargument name="Type" type="string" required="false" default=""/>
	<cfset variables.instance.Type = arguments.Type />
</cffunction>
<cffunction name="getType" access="public" output="false" returntype="string">
	<cfreturn variables.instance.Type />
</cffunction>
<!--- Destination --->
<cffunction name="setDestination" access="public" output="false" returntype="void">
	<cfargument name="Destination" type="string" required="false" default="" />
	<cfset variables.instance.Destination = arguments.Destination />
</cffunction>
<cffunction name="getDestination" access="public" output="false" returntype="string">
	<cfreturn variables.instance.Destination />
</cffunction>
<!--- Source --->
<cffunction name="setSource" access="public" output="false" returntype="void">
	<cfargument name="Source" type="string" required="false" default=""/>
	<cfset variables.instance.Source = arguments.Source />
</cffunction>
<cffunction name="getSource" access="public" output="false" returntype="string">
	<cfreturn variables.instance.Source />
</cffunction>
<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>