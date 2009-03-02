<cfset config = Application.BeanFactory.getBean("ConfigBean")  />
<cfset constants = config.getConstants() />
<cfset udf = Application.BeanFactory.getBean("udf")>
<cfset path = "#constants.FRAMEWORK_FILE_PATH#/logs/cflog4j.log"/>
<cfoutput>
<h1>Log Reader</h1>
<p>Log file: #path#</p>
<p><a href="../logs/cflog4j.log">Download Log File</a></p>
<div style="font-size:.75em;">
<cfif left(server.coldfusion.productVersion, 1) gt 7>
	<cfinclude template="cf8reader.cfm" />
</cfif>
</div>
</cfoutput>