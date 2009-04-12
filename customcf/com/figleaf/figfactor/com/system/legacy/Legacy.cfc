<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			Legacy.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am an Adaptor for legacy code
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		27/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Legacy" output="false"
	hint="I am an Adaptor for legacy code">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Legacy" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfset variables.instance = structNew() />

	<cfreturn this />
</cffunction>



<!--- configure --->
<cffunction name="configure" returntype="any" access="public" output="false"	
	displayname="Configure" hint="I configure myself."
	description="I configure myself.">
    
	<cfargument name="framework" type="component" required="true" 
		hint="I am the FigFactor framework component. I am required" />

	<!--- 
		Make refrences for old code to use.
	--->
	<cfset Application.BeanFactory = arguments.framework.getFactory() />
	<cfset Application.ViewFramework = arguments.framework />
	<cfset Application.VF = arguments.Framework />
	
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	<cfargument name="duplicate" type="boolean" required="false" 
		hint="Should I return a duplicate of my data? I default to false, a shalow copy. I am requried." />
	
	<cfif arguments.duplicate eq true>
		<cfreturn duplicate(variables.instance) />
	<cfelse>
		<cfreturn variables.instance />
	</cfif>
</cffunction>
<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>