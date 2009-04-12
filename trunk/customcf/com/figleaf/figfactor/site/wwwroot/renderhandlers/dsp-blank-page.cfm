<!--- Document Information -----------------------------------------------------
Title: 			ce_dspBlank.cfm
Author:			John Allen
Email:				jallen@figleaf.com
company:		Figleaf Software
Website:		@@@website@@@
Purpose:		I am the render hadler for the blank page type. I include
					the correct layout files.
Modification Log:

Name				Date				Description
================================================================================
John Allen		28/07/2008		Created
------------------------------------------------------------------------------->

<!--- set the pageEvent and custom element data --->
<cfset event = Application.vf.getPageEvent(elementInfo = attributes.elementInfo) />
<cfset blankPage = event.getCustomElementData() />


<cftry>
<!--- 
Case out which include file to include, 
keeps the code easer to manage than 
having every thing on this page. 
--->
<cfoutput>
<cfif len(blankPage.blank_page_content)>
<div id="render-handler-wrapper">
<cfswitch expression="#blankPage.blank_page_column_amout#">
	<cfcase value="Full Page">	
		<cfinclude template="includes/dsp-one-column-blank.cfm">
	</cfcase>
	<cfcase value="Two Column">
		<cfinclude template="includes/dsp-two-column-blank.cfm">
	</cfcase>
	<cfcase value="Three Column">
		<cfinclude template="includes/dsp-three-column-blank.cfm">
	</cfcase>
</cfswitch>
</div>
</cfif>
</cfoutput>
	<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>