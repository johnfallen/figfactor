<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			MetaDataService.cfc
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@

Purpose:    		I provide Figleafs MetaData functionality a sub component
						of FLEET but as a stand alone version. I initalize and act as
						the API for my the custom field types.

Usage:      			Dump this CFC, all attribures are commented.

Modification Log:
================================================================================
John Allen 		08/16/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Meta Data Service" output="false"
	hint="I provide Fig Leaf Softwars Meta-Data functionality from FLEET as a stand alone version.">

<cfset variables.MetaDataConfigBean = 0 />
<cfset variables.MetaDataKeywordService = 0 />
<cfset variables.MetaDataTreeService = 0 />
<cfset variables.cachedMetaDataTrees = 0 />

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="MetaDataService" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="ConfigBean" required="true" />
	
	<cfset setMetaDataConfigBean(arguments.ConfigBean) />

	<cfset setMetaDataKeywordSerivce(
		createObject("component", "com.MetaDataKeywordService").init(
			supportDSN = arguments.ConfigBean.getCommonSpotSupportDSN())) />
	
	<cfset setMetaDataTreeService(
		createObject("component", "com.MetaDataTreeService").init(
			supportDSN = arguments.ConfigBean.getCommonSpotSupportDSN())) />
	
	<cftry>
		<cfset setCachedMetaDataTree() />
		<cfcatch></cfcatch>
	</cftry>
	
	<cfreturn this />
</cffunction>



<!--- setCachedMetaDataTree --->
<cffunction name="setCachedMetaDataTree" output="false" access="public"
	displayname="Set Cached MetaDataTree" hint="I set data to my internal variables scope."
	description="I persistest a structure of all the MetaDataTrees in my internal variables scope.">
	
	<cfset variables.cachedMetaDataTrees = getMetaDataTreeService().getAllMetaDataTrees() />

</cffunction>



<!--- getCachedMetaDataTree --->
<cffunction name="getCachedMetaDataTree" access="public" output="false"
	displayname="Get Cached MetaDataTree" hint="I return a cached version of the MetaDataTree."
	description="I return a cached version of the MetaDataTree.">
	
	<cfargument name="treeid" type="numeric" required="true" 
		hint="I am the ID of the MetaDataTree.<br />I am required." />
	
	
	<cfreturn variables.cachedMetaDataTrees[arguments.treeid] />
</cffunction>



<!--- getMetaDataKeywordService --->
<cffunction name="getMetaDataKeywordService" output="false" access="public"
	hint="I return the MetaDataKeywordService object.">
	<cfreturn variables.MetaDataKeywordService />
</cffunction>

<!--- getMetaDataTreeService --->
<cffunction name="getMetaDataTreeService" output="false" access="public"
	hint="I return the MetaDataTreeService object.">
	<cfreturn variables.MetaDataTreeService />
</cffunction>

<!--- getMetaDataConfigBean --->
<cffunction name="getMetaDataConfigBean" output="false" access="public"
	hint="I return the MetaDataConfigBean object.">
	<cfreturn variables.MetaDataConfigBean />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- setMetaDataKeyword --->
<cffunction name="setMetaDataKeywordSerivce" output="false" access="private">
	<cfargument name="MetaDataKeywordService" required="true" />
	<cfset variables.MetaDataKeywordService = arguments.MetaDataKeywordService />
</cffunction>

<!--- setMetaDataTreeService --->
<cffunction name="setMetaDataTreeService" output="false" access="private">
	<cfargument name="MetaDataTreeService" required="true" />
	<cfset variables.MetaDataTreeService = arguments.MetaDataTreeService />
</cffunction>

<!--- setMetaDataConfigBean --->
<cffunction name="setMetaDataConfigBean" output="false" access="private">
	<cfargument name="MetaDataConfigBean" required="true" />
	<cfset variables.MetaDataConfigBean = arguments.MetaDataConfigBean />
</cffunction>
</cfcomponent>