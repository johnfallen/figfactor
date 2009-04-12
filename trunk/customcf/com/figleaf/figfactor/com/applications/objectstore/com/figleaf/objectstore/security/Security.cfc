<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			Security.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am the Security Service. I store an encrypted password
						in the 'access' directory. The 'salt' used to extra encrypt the
						password is a string stored in my meta data.
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		19/12/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Security" output="false"
	hint="I am the Security Service">

<!--- 
	Values are hard coded here. No other code needs to know about this.
	Keeps this security strategy totally encapsulated and protected if the
	directory of the web server is tight. Its also 'accectable' for sitting in a public
	folder as well, the password is not only 'SHA' encriptied but the variables.salt
	is also tacked on to the password before encryption for super duper 
	encryption.
	
	DO NOT CHANGE THE SALT VALUES. If you do, no login will work unless you 
	create NEW initial values for a login with the new salt values and then recreate
	the logins by hand.
--->
<cfset variables.PASSWORD_SALT = "5AD3EBFA-6023-1763-98AB3E4D2F756619" />
<cfset variables.USERNAME_SALT = "1F5CC29A-6023-1763-98AACB6D530CFC34" />
<cfset variables.minimumPasswordLength = 4 />
<cfset variables.securityEnabled = true />

<cfset variables.THE_PATH = getDirectoryFromPath(GetCurrentTemplatePath()) />
<cfset variables.ACCESS_INI_PATH = variables.THE_PATH &  "access/access.xml"/>



<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Security" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfset variables.accessLookUp = arrayNew(1) />
	<cfset setInternalLookUp() />
	
	<cfreturn this />
</cffunction>



<!--- securityCheck --->
<cffunction name="securityCheck" returntype="boolean" access="public" output="false"
	displayname="Security Check" hint="I check security privilages and access."
	description="I check if applicaiton security is enabled and then check if a user is logged in.">
	
	<cfif variables.securityEnabled eq false>
		<cfreturn 1 />	
	<cfelse>
		<cfif not isDefined("session.GFUserIsLoggedIn") or session.GFUserIsLoggedIn neq true>
			<cfreturn 0 />
		<cfelse>
			<cfreturn 1 />
		</cfif>
	</cfif>
</cffunction>



<!--- deleteUser --->
<cffunction name="deleteUser" returntype="boolean" access="public" output="false"
    displayname="Delete User" hint="I delete a user entry by user name."
    description="I delete a user entry by user name.">
	
	<cfargument name="username" type="string" required="true" 
		hint="I am the username to delete. I am requried." />

	<cfset var x = 0 />
	<cfset var accessPath = variables.ACCESS_INI_PATH />
	<cfset var xml = 0 />
	<cfset var index = 1 />
	
	<cfif securityCheck()>
	
		<cfset arguments.username = saltAndHash(
			string = arguments.username, 
			salt = variables.USERNAME_SALT) />

		<!--- read the access xml file --->
		<cffile action="read" file="#accessPath#" variable="xml" />	
		<cfset xml = xmlParse(xml) />
		
		<!--- loop find and delete the array position of the user --->
		<cfloop array="#xml.access.XmlChildren#" index="x">
			<cfif arguments.username eq x.XmlChildren[2].XmlText>
				<cfset arrayDeleteAt(xml.access.XmlChildren, index) />
				<cfbreak />
			<cfelse>
				<cfset index = index + 1 />
			</cfif>
		</cfloop>

		<!--- write the new xml to the access.xml file --->
		<cflock type="exclusive" name="#createUUID()#WriteSecurityObjectAccessToDiskLock" timeout="120">
			<cffile action="write" file="#accessPath#" output="#toString(xml)#" />
		</cflock>
	
		<cfset setInternalLookUp() />
		
		<cfreturn true />	
	<cfelse>
    	<cfreturn false />
	</cfif>
</cffunction>



<!--- createUser --->
<cffunction name="createUser" returntype="boolean" access="public" output="false"
	displayname="Create User" hint="I add a user to the access lookup."
	description="I add a user to the access lookup.">
	
	<cfargument name="username" type="string" required="true" 
		hint="I am the username.<br />I am required." />
	<cfargument name="username2" type="string" required="true" 
		hint="I am the username2.<br />I am required." />
	<cfargument name="password" type="string" required="true" 
		hint="I am the password.<br />I am required." />
	<cfargument name="password2" type="string" required="true" 
		hint="I am the password.<br />I am required." />
	<cfargument name="minimumPasswordLength" type="numeric" 
		default="#variables.minimumPasswordLength#" 
		hint="I am the minimum length for passwords. I default to a value in the variables scope.">
	
	<cfif securityCheck()>
		
		<!--- check if it already exists, if not go ahead and try to add them --->
		<cfif userLogin(username = arguments.username, password = arguments.password) eq 0>
		
			<cfif 
				(not len(arguments.password) lt arguments.minimumPasswordLength 
					and trim(arguments.password) eq trim(arguments.password2))
				and 
					trim(arguments.username) eq trim(arguments.username2)>
			
				<!--- update the file --->
				<cfset addAccessEntry(
					username = arguments.username, 
					password = arguments.password) />
		
				<cfreturn 1 />
			<cfelse><!--- values didnt pass the check logic --->
				<cfreturn 0 />
			</cfif>
		<cfelse><!--- entry already exists --->
			<cfreturn 0 />
		</cfif>
	<cfelse><!--- the user trying to add the entry isnt logged in --->
		<cfreturn 0 />
	</cfif>
</cffunction>



<!--- listUser --->
<cffunction name="listUser" returntype="array" access="public" output="false"
    displayname="List User" hint="I return the user access look up array."
    description="I return the user access look up array. If no entries are found I return an empty array.">
    
	<cfset var result = arrayNew(1) />
	
	<cfif securityCheck()>
		<cfset result = variables.accessLookup />
	</cfif>
    
	<cfreturn result />
</cffunction>



<!--- userLogin --->
<cffunction name="userLogin" returntype="boolean" access="public" output="false"
	displayname="User Login" hint="I check a password."
	description="I check a password then log a user into the applicaiton if sucessfull.">
	
	<cfargument name="username" type="string" required="true" 
		hint="I am the username.<br />I am username." />
	<cfargument name="password" type="string" required="true" 
		hint="I am the password.<br />I am required." />
	
	<cfset var usernameSalt = variables.USERNAME_SALT />
	<cfset var passwordSalt = variables.PASSWORD_SALT />
	<cfset var x = 0 />
	<cfset var passUserName = false />
	<cfset var passPassword = false />
	
	<cfset arguments.username = saltAndHash(string = arguments.username, salt = usernameSalt)  />
	<cfset arguments.password = saltAndHash(string = arguments.password, salt = passwordSalt) />
	
	<cfloop array="#variables.accessLookup#" index="x">
		
		<cfif arguments.username eq x.username>
			<cfset passUsername = true />
		</cfif>
		
		<cfif arguments.password eq x.password>
			<cfset passPassword = true />
		</cfif>
	</cfloop>
	
	<cfif passUsername eq true and passPassword eq true>
		
		<!--- log them in --->
		<cfset session.GFUserIsLoggedIn = true />
		<cfreturn 1 />
	<cfelse>
		<cfreturn 0 />
	</cfif>
</cffunction>



<!--- userLogOut --->
<cffunction name="userLogOut" returntype="void" access="public" output="false"
	displayname="userLogOut" hint="I log a user out of the application."
	description="I log a user out of the application.">
	
	<!--- clear there entire session --->
	<cfset StructClear(Session)>
	
	<!--- now set them to false --->
	<cfset session.GFUserIsLoggedIn = false />
	
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- addAccessEntry --->
<cffunction name="addAccessEntry" returntype="void" access="private" output="false"
    displayname="Add Access Entry" hint="I add an entry to the access xml file."
    description="I add an entry to the access xml file.">
	
	<cfargument name="username" type="string" required="true" 
		hint="I am the username. I am requried." />
	<cfargument name="password" type="string" required="true" 
		hint="I am the password. I am requried." />

	<cfset var xml = 0 />
	<cfset var newEntry = 0 />
	<cfset var usernameSalt = variables.USERNAME_SALT />
	<cfset var passwordSalt = variables.PASSWORD_SALT />
	<cfset var accessPath = variables.ACCESS_INI_PATH />
	
	<!--- salt and hash --->
	<cfset arguments.username = saltAndHash(string = arguments.username, salt = usernameSalt)  />
	<cfset arguments.password = saltAndHash(string = arguments.password, salt = passwordSalt) />
	
	<!--- read the access xml file --->
	<cffile action="read" file="#accessPath#" variable="xml" />	
	<cfset xml = xmlParse(xml) />

<!--- make the entry and encrypt the strings --->
<cfxml variable="newEntry">
<cfoutput>
<entry>
	<key>#arguments.password#</key>
	<value>#arguments.username#</value>
</entry>
</cfoutput>
</cfxml>

	<!--- append the xml --->
	<cfset xml = XmlAppend(xml.access, newEntry) />

	<!--- write the new xml to the access.xml file --->
	<cflock type="exclusive" name="#createUUID()#WriteSecurityObjectAccessToDiskLock" timeout="120">
		<cffile action="write" file="#accessPath#" output="#toString(xml)#" />
	</cflock>
	
	<cfset setInternalLookUp() />
	
</cffunction>



<!--- setInternalLookUp --->
<cffunction name="setInternalLookUp" returntype="void" access="public" output="false"
    displayname="Set Internal Look Up" hint="I set the my internal look up array of username and passwords."
    description="I set the my internal look up array of username and passwords from the access.xml file.">
    
	<cfset var xml = 0 />
	<cfset var accessFile = variables.ACCESS_INI_PATH />
	<cfset var entry = structNew() />
	
	<!--- clear out the internal look up array --->
	<cfset variables.accessLookUp = arrayNew(1) />
	
	<cffile action="read" file="#accessFile#" variable="xml" />
	<cfset xml = xmlParse(xml) />

	<cfloop array="#xml.access.XmlChildren#" index="x">
		<cfset entry.password = x.XmlChildren[1].XmlText />
		<cfset entry.username = x.XmlChildren[2].XmlText />
		<cfset arrayAppend(variables.accessLookUp, duplicate(entry)) />
	</cfloop>

</cffunction>



<!--- saltAndHash --->
<cffunction name="saltAndHash" returntype="string" access="public" output="false"
    displayname="Salt And Hash" hint="I hash a password and apply with salt applied."
    description="I hash a password and apply with salt applied.">
	
	<cfargument name="string" type="string" required="true" 
		hint="I am the string to encrypt with salt. I am requried." />
	<cfargument name="salt" type="string" required="true" 
		hint="I am the salt to add to a string when hashing. I am requried." />
	<cfargument name="hashType" type="string" defalut="SHA" 
		hint="I am one of ColdFusions hash types. I am requried." />
	
	<cfset arguments.string = arguments.string & arguments.salt />
	<cfset arguments.string = hash(arguments.string, "SHA")  />
	    
    <cfreturn arguments.string />
</cffunction>



<!--- XmlAppend --->
<cffunction name="XmlAppend" access="public" returntype="any" output="false" 
	displayname="Xml Append" hint="Copies the children of one node to the node of another document."
	description="Copies the children of one node to the node of another document. Code by Ben Nadle: www.bennadle.com.">
 
	<cfargument name="NodeA" type="any" required="true"
		hint="The node whose children will be added to." />
	<cfargument name="NodeB" type="any" required="true"
		hint="The node whose children will be copied to another document." />

	<cfset var LOCAL = StructNew() />
	
	<cfset LOCAL.ChildNodes = ARGUMENTS.NodeB.GetChildNodes() />
 
	<!--- Loop over child nodes. --->
	<cfloop index="LOCAL.ChildIndex" from="1" to="#LOCAL.ChildNodes.GetLength()#" step="1">

		<cfset LOCAL.ChildNode = LOCAL.ChildNodes.Item(
			JavaCast(
				"int",
				(LOCAL.ChildIndex - 1)
				)
			) />

		<cfset LOCAL.ChildNode = ARGUMENTS.NodeA.GetOwnerDocument().ImportNode(
			LOCAL.ChildNode,
			JavaCast( "boolean", true )
			) />
 
		<cfset ARGUMENTS.NodeA.AppendChild(
				LOCAL.ChildNode
			) />
 
	</cfloop>

	<cfreturn ARGUMENTS.NodeA />
</cffunction>
</cfcomponent>