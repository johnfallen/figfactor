<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			User.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I model an 'active' user of the application.
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		02/01/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="" output="false"
	hint="I model an 'active' user of the application.">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="User" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="IDUser" type="string" required="true" 
		hint="I am the users ID.<br />I am required." />
	<cfargument name="CurrentIDPage" type="numeric" default="0" 
		hint="I am the current page ID.<br />I default to '0'.">
	<cfargument name="CurrentGalleryIndex" type="numeric" default="0" 
		hint="I am the current page ID.<br />I default to '0'.">
	<cfargument name="UserType" type="string" default="user" 
		hint="I am the current page ID.<br />I default to 'user'.">
	<cfargument name="gateway" type="any" default="0" 
		hint="I am the current page ID.<br />I default to '0'.">
	
	<cfset setIDUser(arguments.IDUser) />
	<cfset setCurrentIDPage(arguments.CurrentIDPage) />
	<cfset setCurrentGalleryIndex(arguments.CurrentGalleryIndex) />
	<cfset setLastLoggedIn() />
	<cfset setCurrentPage(arguments.gateway) />
	<cfset setUserType(arguments.UserType) />
	<cfset setRB() />

	<cfreturn this />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I retrun my internal instance data."
	description="I retrun my internal instance data as a structure.">
	
	<cfreturn variables.instance />
</cffunction>


<!--- CurrentGalleryIndex --->
<cffunction name="setCurrentGalleryIndex" output="false" access="public"
	hint="I set the CurrentGalleryIndex property.">
	<cfargument name="CurrentGalleryIndex" type="numeric" />
	<cfset variables.instance.CurrentGalleryIndex = arguments.CurrentGalleryIndex />
</cffunction>
<cffunction name="getCurrentGalleryIndex" output="false" access="public"
	hint="I return the CurrentGalleryIndex property.">
	<cfreturn variables.instance.CurrentGalleryIndex />
</cffunction>

<!--- CurrentIDPage --->
<cffunction name="setCurrentIDPage" output="false" access="public"
	hint="I set the CurrentIDPage property.">
	<cfargument name="CurrentIDPage" type="numeric" />
	<cfset variables.instance.CurrentIDPage = arguments.CurrentIDPage />
</cffunction>
<cffunction name="getCurrentIDPage" output="false" access="public"
	hint="I return the CurrentIDPage property.">
	<cfreturn variables.instance.CurrentIDPage />
</cffunction>

<!--- IDUser --->
<cffunction name="setIDUser" output="false" access="public"
	hint="I set the IDUser property.">
	<cfargument name="IDUser" type="string" />
	<cfset variables.instance.IDUser = arguments.IDUser />
</cffunction>
<cffunction name="getIDUser" output="false" access="public"
	hint="I return the IDUser property.">
	<cfreturn variables.instance.IDUser />
</cffunction>

<!--- lastLoggedIn --->
<cffunction name="setlastLoggedIn" output="false" access="private"
	hint="I set the lastLoggedIn property.">
	<cfset variables.instance.lastLoggedIn = Now() />
</cffunction>
<cffunction name="getlastLoggedIn" output="false" access="public"
	hint="I return the lastLoggedIn property.">
	<cfreturn variables.instance.lastLoggedIn />
</cffunction>

<!--- CurrentPage --->
<cffunction name="setCurrentPage" output="false" access="public"
	hint="I set the CurrentPage property.">
	<cfargument name="gateway">

	<!--- set the page --->
	<cfset variables.instance.CurrentPage = arguments.gateway.getPage(
		getCurrentIDPage(), this) />
	
</cffunction>
<cffunction name="getCurrentPage" output="false" access="public"
	hint="I return the CurrentPage property.">
	<cfreturn variables.instance.CurrentPage />
</cffunction>

<!--- userType --->
<cffunction name="setuserType" access="public" output="false" returntype="void">
	<cfargument name="userType" type="string" required="false" default="user"/>
	<cfset variables.instance.userType = arguments.userType />
</cffunction>
<cffunction name="getUserType" access="public" output="false" returntype="string">
	<cfreturn variables.instance.userType />
</cffunction>


<!--- getRB --->
<cffunction name="getRB" output="false" access="public"
	hint="I return the RB property.">
	<cfreturn variables.instance.RB />
</cffunction>

<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- setRB --->
<cffunction name="setRB" output="false" access="private"
	hint="I set the RB property.">
	<cfset variables.instance.RB = createObject("component", "localization.JFAG11Service").init() />
</cffunction>
</cfcomponent>