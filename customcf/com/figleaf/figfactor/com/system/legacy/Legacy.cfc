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
<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>