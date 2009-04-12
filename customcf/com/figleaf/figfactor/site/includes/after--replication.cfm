<cfset MessageService = Application.FigFacgtor.getFactory().getBean("MessageService") />
<cfset config = Application.FigFactor.getConfiguration() />

<cfset email = MessageService.getMessage("email") />

<!--- if replication falied, send a message --->
<cfif attributes.replicationOK eq 0>
	<cfset subject = "There was an error with replication!!!!" />
	<cfset message = "#attributes.ReplicationErrorMsg#" />
<cfelse>
	<cfset subject = "Replication happend sucessfully." />
	<cfset message = "A friendly notification that the Replcation proscess completed sucessfully." />
</cfif>

<cfset email.setTo(config.getWebMasterEmail()) />
<cfset email.setSubject(subject) />
<cfset email.setMessage(message) />
<cfset email.setType('text') />

<cfset email.send() />

