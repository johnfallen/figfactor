<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			EventCollection.cfc
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am a simple "Collection" scope used to persist 
						values for the PageEvent. I abstract control access
						to a requst scoped variable.

Usage:      		
Modification Log:
Name 			Date 					Description
================================================================================
John Allen 		04/09/2008			Created

------------------------------------------------------------------------------->
<cfcomponent displayname="Event Collection" output="false"
	hint="I am a simple 'Collection' scope used to persist edge case values for the PageEvent.">


<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="EventCollection" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfreturn this />
</cffunction>



<!--- setValue --->
<cffunction name="setValue" returntype="any" access="public" output="false"
	displayname="Add Value" hint="I add a named value pair to the EventCollection."
	description="I add a named value pair to the EventCollection.<br />I thorw an error if the data passed to me is unnamed and NOT a structure.">
	
	<cfargument name="name" hint="I am the name of the value." />
	<cfargument name="value" hint="I am the value." />
	<cfargument name="append" default="false" type="boolean"  hint="I am the value.<br />I am required" />
		
	<cfif not structKeyExists(request, "VFPageEventEventCollection")>
		<cfset request.VFPageEventEventCollection = structNew() />
	</cfif>

	<cfif  isDefined("arguments.name")>
		<cfset request.VFPageEventEventCollection[arguments.name] = arguments.value />
	<cfelse>
		<cfif isStruct(arguments.value)>
			<cfset structAppend(request.VFPageEventEventCollection, arguments.value) />
		<cfelse>
			<cfthrow message="Oops! You have attempted to add a value to the EventCollection that is unnamed and NOT a struct. Unnamed data must always be a structure.">
		</cfif>
	</cfif>	
	
</cffunction>



<!--- getAllValues --->
<cffunction name="getAllValues" returntype="any" access="public" output="false"
	displayname="Get All Values" hint="I return all of EventCollections values."
	description="I return all of EventCollections values as a structure.">
	
	<cfif structKeyExists(request, "VFPageEventEventCollection")>
		<cfreturn request.VFPageEventEventCollection />
	<cfelse>
		<cfset request.VFPageEventEventCollection = structNew() />
		<cfreturn request.VFPageEventEventCollection />
	</cfif>
</cffunction>



<!--- getValue --->
<cffunction name="getValue" returntype="any" access="public" output="false"
	displayname="Get Value" hint="I retrun a value by name."
	description="I retrun a value by name.">
	
	<cfargument name="name" hint="I am the name of the value.<br />I am requried." />
	
	<!--- return an empty string no matter what --->
	<cfif structKeyExists(request, "VFPageEventEventCollection")>

		<cfif structKeyExists(request.VFPageEventEventCollection, arguments.name)>
			
			<cfif structKeyExists(request.VFPageEventEventCollection, arguments.name)>
				<cfreturn request.VFPageEventEventCollection[arguments.name] />
			<cfelse>
				<cfreturn "" />
			</cfif>

		<cfelse>
			<cfreturn ""/>
		</cfif>
	<cfelse>
		
		<!--- the request scope variables is has not been created yet --->
		<cfset request.VFPageEventEventCollection = structNew() />
		<cfreturn ""/>
	</cfif>
</cffunction>

<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>