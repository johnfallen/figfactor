<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			UserService.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am the User Service. I manage and persist a User
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		02/01/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="User Service" output="false"
	hint="I am the User Service. I manage and persist a User">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="UserService" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="gateway" type="component" required="true" 
		hint="I am the Gateway.<br />I am required." />	
	
	<cfset variables.gateway = arguments.gateway />

	<cfreturn this />
</cffunction>



<!--- createSession --->
<cffunction name="createSession" returntype="void" access="public" output="false"
	displayname="Create Session" hint="I create a users session."
	description="I create a users session object and store it in the 'session' scope..">

	<cfargument name="IDUser" type="string" required="true" 
		hint="I am the CommonSpot User ID.<br />I am required." />
	<cfargument name="IDPage" type="numeric" default="0" 
		hint="I am the CommonSpot User ID.<br />I default to '0'." />
	<cfargument name="GalleryIndex" type="numeric" default="1" 
		hint="I am the Gallery index if a page has more than one Gallery.<br />I default to '1'." />
	<cfargument name="userType" type="string" default="" 
		hint="I am the 'type' of user to create a session for.<br />I default to an empty string." />

	<!--- 
	Create and populate the applications "user" object (not an ORM object), then
	update the user, this will create a new user if they have never visited the
	application before, then persist the users session object.
	--->
	<cfset var user = createObject("component", "User").init(
		IDUser = arguments.IDUser,
		CurrentIDPage = arguments.IDPage,
		CurrentGalleryIndex = arguments.galleryIndex,
		UserType = arguments.UserType,
		gateway = variables.gateway) />
	
	<cfset variables.gateway.updateUser(user) />
	
	<!--- always kill their session if they have one --->
	<cfif structKeyExists(session, "userSessionObject")>
		<cflock type="exclusive" name="killUserSessionLock1#createUUID()#" timeout="20">
			<cfif structKeyExists(session, "userSessionObject")>
				<cflock type="exclusive" name="killUserSessionLock2#createUUID()#" timeout="20">
					<cfset session.userSessionObject = 0 />
				</cflock>
			</cfif>
		</cflock>
	</cfif>

	
	<!--- set them into the session scope --->
	<cfset setUserSession(user) />

</cffunction>



<!--- getUser --->
<cffunction name="getUser" returntype="any" access="public" output="false"
	displayname="Get User" hint="I return the applications 'user' object."
	description="I return the applications 'user' object, persisted in the session scope.">
	
	<cfset var user = 0 />
	
	<!--- this app will be huge and successfull, so double lock every thing for the heck of it --->
	<cfif structKeyExists(session, "userSessionObject")>
		<cflock type="exclusive" name="multMediaGetSessionLock1#createUUID()#" timeout="20">
			<cfif structKeyExists(session, "userSessionObject")>
				<cflock type="exclusive" name="multMediaGetSessionLock2#createUUID()#" timeout="20">
					<cfset user = session.userSessionObject />
				</cflock>
			</cfif>
		</cflock>
	</cfif>
	
	<cfreturn user>
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- setUserSession --->
<cffunction name="setUserSession" returntype="void" access="private" output="false"
	displayname="Set User Session Object" hint="I set a user object into the session scope."
	description="I set a user object into the session scope, this is how a user is persisted for interaction with the application.">
	
	<cfargument name="user" type="component" required="true" 
		hint="I am the user object.<br />I am required.">
	
	<cfset var i = 0 />
	
	<!--- this app will be huge and successfull, so double lock every thing for the heck of it --->
	<cfif i eq 0>
		<cflock type="exclusive" name="multiMediaSetSessionLock1#createUUID()#" timeout="20">
			<cfif i eq 0>
				<cflock type="exclusive" name="multiMediaSetSessionLock2#createUUID()#" timeout="20">
					
					<!--- set the session object --->
					<cfset session.userSessionObject = arguments.user />
				</cflock>
			</cfif>
		</cflock>
	</cfif>
	
</cffunction>
</cfcomponent>