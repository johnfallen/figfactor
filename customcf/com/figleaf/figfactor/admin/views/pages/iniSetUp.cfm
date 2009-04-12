<!---
 * iniSEtUp.cfm - COLD FUSION CTAG FOR INI FILES
 * @requires CFMX7+
 *
 * http://www.andreafm.com
 *
 * Copyright (c) 2007 Andrea Campolonghi (andreacfm.com)
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html

Modification Log:

Name				Date		Description
================================================================================
John Allen		04/08/2008		Downloaded and added the len + 5 to the input.
John Allen		06/08/2008		added the action attribute to the form.
John Allen		03/09/2009		removed the action attibue and coded HARD coded the 
										value. This version of this code is now FINNISHED! Unless
										I laugh at myslef later. DO NOT USE THIS CODE TO COPY
										AND PAST, unless you glance at it first. Its only 57 lines long.
---->
<cfif thisTag.executionMode eq "end">
<cfparam name="attributes.iniPath" type="string" default=""/>
<cfparam name="attributes.iniFile" type="string" default=""/>
<cfparam name="attributes.iniSection" type="string" default=""/>
<cfset objName = #hash(attributes.iniSection)#>
<cfset iniLocation = "#attributes.iniPath##attributes.iniFile#">  
	<cfif structKeyExists(form,"#objName#")> <!---if form is submitted--->
		<cfset iniFileStruct = getProfileSections("#iniLocation#")>
		<cfset iniFileEntries = iniFileStruct["#attributes.iniSection#"]><!----read the ini file to reduce to a llopable list---->
		<cfloop list="#iniFileEntries#" index="iniEntry" delimiters=",">
		 	<cfset currentItem = #iniEntry#>
		 	<cfset match = structFind(form,"#currentItem#")><!----if current item match the same item in request scope ( from from )--->
		   	<cfset write = setProfileString("#iniLocation#","#attributes.iniSection#",#currentItem#,#match#)> <!---rewrite the ini file---> 
		</cfloop>
		<cfoutput><p style="color:red">File Updated</p></cfoutput>
	</cfif>
<!---display the form with actual value before and after form submission--->
<cfset iniFileStruct = getProfileSections("#iniLocation#")>
<cfset iniFileEntries = iniFileStruct["#attributes.iniSection#"]>
<cfset Config= structNew()>
<cfoutput>
	<h4>IniFile: #attributes.iniFile#<br/>Section: #attributes.iniSection#</h4>
	<form action="index.cfm?event=configure" name="iniSetUp" class="ini" method="post"><!---form to display the ini file--->
	<fieldset>
	<input value="save" type="submit" name="#objName#"/>
	<cfloop list="#iniFileEntries#" index="iniEntry">
		<cfset Config[iniEntry] = getProfileString("#iniLocation#","#attributes.iniSection#",iniEntry)>
		<p>
		<label for="#iniEntry#">#iniEntry#</label>:&nbsp;<input name="#iniEntry#" value="#Config[iniEntry]#" size="#len(Config[iniEntry]) + 5#"/>
		</p>
	</cfloop>
	</fieldset>
	</form>
</cfoutput>
</cfif>