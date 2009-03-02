<!--- Document Information -----------------------------------------------------
Build:		@@@revision-number@@@

Title:		EmailBean.cfc

Author:		John Allen
Email:		jallen@figleaf.com

Company:	@@@company-name@@@
Website:	@@@web-site@@@

Purpose:	I am an Email Bean. Use me to send Emails

Usage:	

Modification Log:

Name			Date			Description
================================================================================
Joe Rienhert	??/??/???		Created
John Allen		18/04/2008		Changed Name to EmailBean. Added ColdSpring
								setter for the Email Service.

------------------------------------------------------------------------------->
<cfcomponent displayname="Email Bean" output="false" name="EmailBean" hint="I am a Email.">

<!--- 
TODO: must totally rewrite this cfc by myself. I like the idea of the object being smarter, and 
losing the service.
 --->

<!--- init --->
<cffunction name="init" returnType="Email" access="public" output="false" hint="I build a new EmailBean">
	
	<cfargument name="ConfigBean" type="any" required="true" hint="I am the GatewayConfigBean.<br />I am required." />
	
	<cfset variables.ConfigBean = arguments.ConfigBean />
	
	<!--- Instance Variables --->
	<cfset variables._instance = structNew() />
	<cfset variables._instance.To = "" />
	<cfset variables._instance.From = "" />
	<cfset variables._instance.ReplyTo = "" />
	<cfset variables._instance.CC = "" />
	<cfset variables._instance.BCC = "" />
	<cfset variables._instance.Subject = "" />
	<cfset variables._instance.Body = "" />
	<cfset variables._instance.Type = "" />

	<cfreturn this />
</cffunction>



<!--- sendEmail --->
<cffunction name="sendEmail" access="public" returntype="void" output="false">
	
	<cfargument name="email" required="true" />
	
	<cfset var to = arguments.email.getTo() />
	<cfset var bcc = arguments.email.getBcc() />
	<cfset var cc = arguments.email.getCC() />
	<cfset var attachments = arguments.email.getAttachments() />
	<cfset var headers = arguments.email.getHeaders() />
	
	<!--- TODO --->
	<cfif dev neq "">
		<cfset bcc = "" />
		<cfset cc = "" />
		<cfset to = devto />
	</cfif>
	
	<cfmail 
	   to = "#to#"
	   from = "#arguments.email.getFrom()#"
	   cc = "#cc#"
	   bcc = "#bcc#"
	   subject = "#arguments.email.getSubject()#"
	   replyto = "#arguments.email.getReplyTo()#"
	   type = "#arguments.email.getType()#">
	   #arguments.email.getBody()#
	</cfmail>
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false" hint="I return the instance data for this instance via a duplicate().">
	<cfreturn duplicate(variables._instance) />
</cffunction>


<!--- to --->
<cffunction name="SetTo" returntype="void" access="public" output="false" hint="Sets the To property">
	<cfargument name="To" type="string" required="true" />
	<cfset variables._instance.To = arguments.To />
</cffunction>
<cffunction name="GetTo" returntype="string" access="public" output="false" hint="Gets the To property">
	<cfreturn variables._instance.To  />
</cffunction>

<!--- From --->
<cffunction name="SetFrom" returntype="void" access="public" output="false" hint="Sets the From property">
	<cfargument name="From" type="string" required="true" />
	<cfset variables._instance.From = arguments.From />
</cffunction>
<cffunction name="GetFrom" returntype="string" access="public" output="false" hint="Gets the From property">
	<cfreturn variables._instance.From  />
</cffunction>

<!--- ReplyTo --->
<cffunction name="SetReplyTo" returntype="void" access="public" output="false" hint="Sets the ReplyTo property">
	<cfargument name="ReplyTo" type="string" required="true" />
	<cfset variables._instance.ReplyTo = arguments.ReplyTo />
</cffunction>
<cffunction name="GetReplyTo" returntype="string" access="public" output="false" hint="Gets the ReplyTo property">
	<cfreturn variables._instance.ReplyTo  />
</cffunction>

<!--- CC --->
<cffunction name="SetCC" returntype="void" access="public" output="false" hint="Sets the CC property">
	<cfargument name="CC" type="string" required="true" />
	<cfset variables._instance.CC = arguments.CC />
</cffunction>
<cffunction name="GetCC" returntype="string" access="public" output="false" hint="Gets the CC property">
	<cfreturn variables._instance.CC  />
</cffunction>

<!--- BCC --->
<cffunction name="SetBCC" returntype="void" access="public" output="false" hint="Sets the BCC property">
	<cfargument name="BCC" type="string" required="true" />
	<cfset variables._instance.BCC = arguments.BCC />
</cffunction>
<cffunction name="GetBCC" returntype="string" access="public" output="false" hint="Gets the BCC property">
	<cfreturn variables._instance.BCC  />
</cffunction>

<!--- Subject --->
<cffunction name="SetSubject" returntype="void" access="public" output="false" hint="Sets the Subject property">
	<cfargument name="Subject" type="string" required="true" />
	<cfset variables._instance.Subject = arguments.Subject />
</cffunction>
<cffunction name="GetSubject" returntype="string" access="public" output="false" hint="Gets the Subject property">
	<cfreturn variables._instance.Subject  />
</cffunction>

<!--- Body --->
<cffunction name="SetBody" returntype="void" access="public" output="false" hint="Sets the Body property">
	<cfargument name="Body" type="string" required="true" />
	<cfset variables._instance.Body = arguments.Body />
</cffunction>
<cffunction name="GetBody" returntype="string" access="public" output="false" hint="Gets the Body property">
	<cfreturn variables._instance.Body  />
</cffunction>

<!--- Type --->
<cffunction name="SetType" returntype="void" access="public" output="false" hint="Sets the Type property">
	<cfargument name="Type" type="string" required="true" />
	<cfset variables._instance.Type = arguments.Type />
</cffunction>
<cffunction name="GetType" returntype="string" access="public" output="false" hint="Gets the Type property">
	<cfreturn variables._instance.Type  />
</cffunction>
</cfcomponent>