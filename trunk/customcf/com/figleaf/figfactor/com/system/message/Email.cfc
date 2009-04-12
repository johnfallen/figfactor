<!--- Document Information -----------------------------------------------------
Build:						@@@revision-number@@@
Title:						Email.cfc 
Author:					John Allen
Email:						jallen@figleaf.com
Company:					@@@company-name@@@
Website:					@@@web-site@@@
Purpose:					I model a Email Message
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		03/04/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Email" output="false"
	hint="I model a Email Message">

<!--- ****************************** Public ******************************* --->

<!--- init --->
<cffunction name="init" returntype="Email" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="To" type="string" required="false" default="" 
		hint="Who this email will be sent to."/>
	<cfargument name="From" type="string" required="false" default="" 
		hint="Who this email is from. I default to an empty string." />
	<cfargument name="ReplyTo" type="string" required="false" default=""
		hint="Who the reply should go to. I default to an empty string." />
	<cfargument name="CC" type="string" required="false" default=""
		hint="Who should be copied on this email. I am requried." />
	<cfargument name="BCC" type="string" required="false" default="" 
		hint="Who should be Blid Copied on this email. I default to an empty string." />
	<cfargument name="Type" type="string" required="false" default="" 
		hint="What type of email is this? HTML or Plain text. I default to a configured value.." />
	<cfargument name="Attachements" type="any" required="false" default="" 
		hint="The attachements for this email." />
	<cfargument name="Config" type="component" required="true"
		hint="I am the frameworks config component. I am requireds." />
	
	<cfset variables.instance = structNew() />
	<cfset variables.config = arguments.Config />

	<cfreturn this />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
	<cfargument name="duplicate" type="boolean" required="false" 
		hint="Should I return a duplicate of my data? I default to false, a shalow copy." />
	
	<cfif arguments.duplicate eq true>
		<cfreturn duplicate(variables.instance) />
	<cfelse>
		<cfreturn variables.instance />
	</cfif>
</cffunction>



<!--- send --->
<cffunction name="send" access="public" returntype="void" output="false">
	
	<cfset var dev = variables.config.getSystemMode() />
	<cfset var server = variables.config.getMailServer() />
	<cfset var password = variables.config.getMailPassword() />
	<cfset var username = variables.config.getMailUserName() />
	
	<cfset var attachments = getAttachments() />
	<cfset var headers = getHeaders() />
	
	<cfif dev contains "development">
		<cfset bcc = "" />
		<cfset cc = "" />
		<cfset to = #variables.config.getWebMasterEmail()# />
	<cfelse>
		<cfset bcc = getBCC() />
		<cfset cc = getCC() />
		<cfset to = getTo() />
	</cfif>
	
	<cfmail 
	   to = "#to#"
	   from = "#getFrom()#"
	   cc = "#cc#"
	   bcc = "#bcc#"
	   subject = "#getSubject()#"
	   replyto = "#getReplyTo()#"
	   type = "#getType()#">
		   
		   #getMessage()#
		
		<cfloop from="1" to="#arrayLen(attachments)#" index="i">
			<cfmailparam file="#attachments[i]#" />
		</cfloop>
		<cfloop from="1" to="#arrayLen(headers)#" index="i">
			<cfmailparam name="#headers[i].name#" value="#headers[i].value#" />
		</cfloop>
	</cfmail>

</cffunction>


<!--- ****************************** Package ******************************* --->
<!--- ****************************** Private ******************************* --->
<!--- ************************* Accors/Mutators ************************** --->
<!--- getTo --->
<cffunction name="getTo" access="public" output="false" returntype="string"
	displayname="Get To" hint="I return the To property." 
	description="I return the To property to my internal instance structure.">
	<cfreturn variables.instance.To />
</cffunction>
<!--- setTo --->
<cffunction name="setTo" access="public" output="false" returntype="void"
	displayname="Set To" hint="I set the To property." 
	description="I set the To property to my internal instance structure.">
	<cfargument name="To" type="string" required="true"
		hint="I am the To property. I am required."/>
	<cfset variables.instance.To = arguments.To />
</cffunction>
<!--- getFrom --->
<cffunction name="getFrom" access="public" output="false" returntype="string"
	displayname="Get From" hint="I return the From property." 
	description="I return the From property to my internal instance structure.">
	<cfreturn variables.instance.From />
</cffunction>
<!--- setFrom --->
<cffunction name="setFrom" access="public" output="false" returntype="void"
	displayname="Set From" hint="I set the From property." 
	description="I set the From property to my internal instance structure.">
	<cfargument name="From" type="string" required="true"
		hint="I am the From property. I am required."/>
	<cfset variables.instance.From = arguments.From />
</cffunction>
<!--- getReplyTo --->
<cffunction name="getReplyTo" access="public" output="false" returntype="string"
	displayname="Get ReplyTo" hint="I return the ReplyTo property." 
	description="I return the ReplyTo property to my internal instance structure.">
	<cfreturn variables.instance.ReplyTo />
</cffunction>
<!--- setReplyTo --->
<cffunction name="setReplyTo" access="public" output="false" returntype="void"
	displayname="Set ReplyTo" hint="I set the ReplyTo property." 
	description="I set the ReplyTo property to my internal instance structure.">
	<cfargument name="ReplyTo" type="string" required="true"
		hint="I am the ReplyTo property. I am required."/>
	<cfset variables.instance.ReplyTo = arguments.ReplyTo />
</cffunction>
<!--- getCC --->
<cffunction name="getCC" access="public" output="false" returntype="string"
	displayname="Get CC" hint="I return the CC property." 
	description="I return the CC property to my internal instance structure.">
	<cfreturn variables.instance.CC />
</cffunction>
<!--- setCC --->
<cffunction name="setCC" access="public" output="false" returntype="void"
	displayname="Set CC" hint="I set the CC property." 
	description="I set the CC property to my internal instance structure.">
	<cfargument name="CC" type="string" required="true"
		hint="I am the CC property. I am required."/>
	<cfset variables.instance.CC = arguments.CC />
</cffunction>
<!--- getBCC --->
<cffunction name="getBCC" access="public" output="false" returntype="string"
	displayname="Get BCC" hint="I return the BCC property." 
	description="I return the BCC property to my internal instance structure.">
	<cfreturn variables.instance.BCC />
</cffunction>
<!--- setBCC --->
<cffunction name="setBCC" access="public" output="false" returntype="void"
	displayname="Set BCC" hint="I set the BCC property." 
	description="I set the BCC property to my internal instance structure.">
	<cfargument name="BCC" type="string" required="true"
		hint="I am the BCC property. I am required."/>
	<cfset variables.instance.BCC = arguments.BCC />
</cffunction>
<!--- getType --->
<cffunction name="getType" access="public" output="false" returntype="string"
	displayname="Get Type" hint="I return the Type property." 
	description="I return the Type property to my internal instance structure.">
	<cfreturn variables.instance.Type />
</cffunction>
<!--- setType --->
<cffunction name="setType" access="public" output="false" returntype="void"
	displayname="Set Type" hint="I set the Type property." 
	description="I set the Type property to my internal instance structure.">
	<cfargument name="Type" type="string" required="true"
		hint="I am the Type property. I am required."/>
	<cfset variables.instance.Type = arguments.Type />
</cffunction>
<!--- getSubject --->
<cffunction name="getSubject" access="public" output="false" returntype="string"
	displayname="Get Subject" hint="I return the Subject property." 
	description="I return the Subject property to my internal instance structure.">
	<cfreturn variables.instance.Subject />
</cffunction>
<!--- setSubject --->
<cffunction name="setSubject" access="public" output="false" returntype="void"
	displayname="Set Subject" hint="I set the Subject property." 
	description="I set the Subject property to my internal instance structure.">
	<cfargument name="Subject" type="string" required="true"
		hint="I am the Subject property. I am required."/>
	<cfset variables.instance.Subject = arguments.Subject />
</cffunction>
<!--- getMessage --->
<cffunction name="getMessage" access="public" output="false" returntype="string"
	displayname="Get Message" hint="I return the Message property." 
	description="I return the Message property to my internal instance structure.">
	<cfreturn variables.instance.Message />
</cffunction>
<!--- setMessage --->
<cffunction name="setMessage" access="public" output="false" returntype="void"
	displayname="Set Message" hint="I set the Message property." 
	description="I set the Message property to my internal instance structure.">
	<cfargument name="Message" type="string" required="true"
		hint="I am the Message property. I am required."/>
	<cfset variables.instance.Message = arguments.Message />
</cffunction>
<!--- getAttachements --->
<cffunction name="getAttachements" access="public" output="false" returntype="any"
	displayname="Get Attachements" hint="I return the Attachements property." 
	description="I return the Attachements property to my internal instance structure.">
	<cfreturn variables.instance.Attachements />
</cffunction>
<!--- setAttachements --->
<cffunction name="setAttachements" access="public" output="false" returntype="void"
	displayname="Set Attachements" hint="I set the Attachements property." 
	description="I set the Attachements property to my internal instance structure.">
	<cfargument name="Attachements" type="any" required="true"
		hint="I am the Attachements property. I am required."/>
	<cfset variables.instance.Attachements = arguments.Attachements />
</cffunction>
</cfcomponent>