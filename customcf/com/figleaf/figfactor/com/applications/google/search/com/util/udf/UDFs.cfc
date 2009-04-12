<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			UDFs.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am the User Defined Functions Library
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		13/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="UDFs (User Defined Functinos Library)" output="false"
	hint="I am the User Defined Functions Library">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="UDFs" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfreturn this />
</cffunction>



<!--- setInstance --->
<cffunction name="setInstance" returntype="void" access="public" output="false"
    displayname="Set Instance Variables" hint="I set the internal variable scope data."
    description="I set the internal variable scope data. Pass me a structure with any keys that match the API's properties (getters/setters) and I will populate my internal variables.instance scope with the value.">
    
	
	<cfargument name="component" type="component" required="true" 
		hint="I am the component to set values on. I am required." />
	<cfargument name="data" type="struct" required="true"
		hint="I am a structure to populate the component with. I am requireds." />
	
	<cfset var x = 0 />
	<cfset var y = 0 />
	<cfset var functionCall = 0 />

	<cfloop collection="#arguments.data#" item="y">
		<cfloop array="#getMetaData(arguments.component).functions#" index="x">

			<cfif 
				y eq right( x.name, ( len(x.name)-3) ) 
				and 
				left(x.name, 3) eq "set">
					
				<cfset functionCall = evaluate(#x.name#) />
				<cfset functionCall(arguments.data[y]) />
				<cfbreak />
			</cfif>
		</cfloop>
	</cfloop>

</cffunction>

<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>