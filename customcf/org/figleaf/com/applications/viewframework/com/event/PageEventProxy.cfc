<!--- Document Information -----------------------------------------------------
Build:      				@@@revision-number@@@
Title:      				PageEventProxy.cfc
Author:     				John Allen
Email:      				jallen@figleaf.com
Company:    			@@@company-name@@@
Website:    			@@@web-site@@@
Purpose:    			I am the PageEventProxy. I manage the Page Event object
							used by the ViewFramework.
Usage:      				getPageEvent() - I return a request scoped PaveEvent object.
							MX 7 returns a createObject, MX 8 returns a dupclicate() of
							a object stored in the variables scope.
Modification Log:
Name	 Date	 Description
================================================================================
John Allen	 07/20/2008	 Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Page Event Proxy"  output="false"
	hint="I am the PageEventProxy, I manage the Page Event object.">

<cfset variables._pageEvent = 0 />

<!--- init --->
<cffunction name="init" access="public" output="false"
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfset variables._pageEvent = createObject("component", "PageEvent").init() />
	
	<cfreturn this  />
</cffunction>



<!--- getPageEvent --->
<cffunction name="getPageEvent" access="public" output="false" 
	displayname="Get Page Event" hint="I return a requests PageEvent object." 
	description="I check if the PageEvent is created and if not, I create one, set it to the request scope and then return it.">

	<cfif not structkeyexists(request, "VFPageEvent")>
		<!--- CF 8 can duplicate components, 7 and below... not so much --->
		<cfif left(server.coldfusion.productVersion, 1) gt 7>
			<cfset request.VFPageEvent = duplicate(variables._pageEvent) />
		<cfelse>
			<cfset request.VFPageEvent = createObject("component", "PageEvent").init() />
		</cfif>
	</cfif>
	
	<cfreturn request.VFPageEvent />
</cffunction>
</cfcomponent>