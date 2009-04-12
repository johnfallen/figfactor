<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			Feeds.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I manage xml feed files for a Google Search Appliance
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		15/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Feeds" output="false"
	hint="I manage xml feed files for a Google Search Appliance">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Feeds" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="metadataProperties" type="xml" required="false" 
		hint="I am the configuration structure. I am requried." />

	<cfset variables.objectStore = createObject("component", "com.objectstore.ObjectStore").init() />

	<cfreturn this />
</cffunction>



<!--- getObjectStore --->
<cffunction name="getObjectStore" returntype="component" access="public" output="false"
    displayname="Get Object Store" hint="I return the Object Store Framework."
    description="I return the Object Store Utility Framework.">
    
    <cfreturn variables.objectStore />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
	<cfreturn variables.instance />
</cffunction>

<!--- *********** Package *********** --->
<!--- *********** Private *********** --->


<!--- getMetadataProperties --->
<cffunction name="getMetadataProperties" access="public" output="false" returntype="xml"
	displayname="Get MetadataProperties" hint="I return the MetadataProperties property." 
	description="I return the MetadataProperties property to my internal instance structure.">

	<cfreturn variables.instance.MetadataProperties />
</cffunction>
<!--- setMetadataProperties --->
<cffunction name="setMetadataProperties" access="public" output="false" returntype="void"
	displayname="Set MetadataProperties" hint="I set the MetadataProperties property." 
	description="I set the MetadataProperties property to my internal instance structure.">
	<cfargument name="MetadataProperties" type="xml" required="true"
		hint="I am the MetadataProperties property. I am required."/>
	
	<cfset variables.instance.MetadataProperties = arguments.MetadataProperties />
	
</cffunction>
</cfcomponent>