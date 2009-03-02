<!--- Document Information -----------------------------------------------------
Title: 				footer.cfm
Author:				John Allen
Email:					jallen@figleaf.com
Company:			Figleaf Software
Website:			http://www.nist.gov
Purpose:			I am the footer include file.
Usage:				I am cool.
History:
Name					Date				
================================================================================
John Allen			07/10/2008		Created
------------------------------------------------------------------------------->
<cfset factory = Application.BeanFactory.getBean("BeanFactory") />
<cfset logger = factory.getBean("Logger") />

<cfif isDefined("URL.ClickHere")>
	<cfset logger.setMessage(
		message = "SOMEBODY LOVES ME! Thanks to: MySuperGodBoss - BigHugeDogDaveG | CEO - SDrucker | lbHacker - Ohhhh lbHacker is a god SQL machine") 
	/>
</cfif>

<!--- ************ Display ************ --->
<cfoutput>
	<div id="footer">
		<p>click here if you like this application <a href="?ClickHere=ClickHere">&raquo; Click Here</a></p>
	</div>
</body>
</html>
</cfoutput>