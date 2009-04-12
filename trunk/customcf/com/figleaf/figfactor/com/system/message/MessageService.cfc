<!--- Document Information -----------------------------------------------------
Build:						@@@revision-number@@@
Title:						MessageService.cfc 
Author:					John Allen
Email:						jallen@figleaf.com
Company:					@@@company-name@@@
Website:					@@@web-site@@@
Purpose:					I handle all messages sent from the framework
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		03/04/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="MessageService" output="false"
	hint="I handle all messages sent from the framework">

<!--- ****************************** Public ******************************* --->

<!--- init --->
<cffunction name="init" returntype="MessageService" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="Config" />

	<cfset variables.Config = arguments.Config />

	<cfreturn this />
</cffunction>



<!--- getMessage --->
<cffunction name="getMessage" returntype="component" access="public" output="false"	
	displayname="Get Message" hint="I return a message object by type. THOWS ERROR if no type if found."
	description="I return a message object by type. THOWS ERROR if no type if found.">
    
	<cfargument name="type" type="string" required="true" 
		hint="I am the type of message to return. I am requried." />
	
	<cfset var message = 0 />
	
	<cfif lcase(arguments.type) eq "email">
		<cfset message = createObject("component", "Email").init(Config = variables.config) />
	<cfelseif lcase(arguments.type) eq "JSM">
		<cfset message = createObject("component", "JSM").init(Config = variables.config) />
	</cfif>
	
	<cfif isSimpleValue(message)>
		<cfthrow message="No message type for #arguments.type# was found." 
			detail="You tried to get a message object from the MessageService.cfc which dose not exists." />
	</cfif>
	
	<cfreturn message />
</cffunction>


<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	<cfargument name="duplicate" type="boolean" required="false" default="false"
		hint="Should I return a duplicate of my data? I default to false, a shalow copy. I am requried." />
	
	<cfif arguments.duplicate eq true>
		<cfreturn duplicate(variables.instance) />
	<cfelse>
		<cfreturn variables.instance />
	</cfif>
</cffunction>
<!--- ****************************** Package ******************************* --->
<!--- ****************************** Private ******************************* --->
<!--- ************************* Accors/Mutators ************************** --->
</cfcomponent>