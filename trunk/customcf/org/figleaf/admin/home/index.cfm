<!--- Document Information -----------------------------------------------------
Title: 				index.cfm
Author:				John Allen
Email:					jallen@figleaf.com
Company:			Figleaf Software
Website:			http://www.nist.gov
Purpose:			I am the hompage for the Fig Leaf System Admin applicaiton.
Usage:				
History:
Name					Date				
================================================================================
John Allen			07/10/2008		Created
------------------------------------------------------------------------------->
<cfset config = application.BeanFactory.getBean('ConfigBean') />
<cfset constants = config.getConstants() />
<cfset settings = config.getInstance() />
<cfset path = "#constants.FRAMEWORK_FILE_PATH#/#constants.DEVELOPMENT_DIRECTORY#/model/logs/" />
<!--- ************ Display ************ --->
<cfoutput>
<h1>Fig Leaf CommonSpot System Homepage</h1>
<h2>Welcome!</h2>
<p>Click the menu options to manage different aspects of the Fig Leaf System.</p>
<hr />
<p>
	Use this string in the cflog4j properties file:<br /><br />
	<strong>#replaceNoCase(path, "\", "/", "all")#</strong>
</p>
<hr />
<h4>Current Configuration Settings:</h4>
<div style="font-size:.80em;">
<cfloop collection="#settings#" item="x">
	<cfif isSimpleValue(settings[x])>
		<strong>#x#</strong> = 	#settings[x]#<br />
	</cfif>
</cfloop>
<p><strong>Constants</strong></p>
<cfloop collection="#constants#" item="x">
	<cfif isSimpleValue(constants[x])>
		<strong>#x#</strong> = 	#constants[x]#<br />
	</cfif>
</cfloop>
</div>
</cfoutput>