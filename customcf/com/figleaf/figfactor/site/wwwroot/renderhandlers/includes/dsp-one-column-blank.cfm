<!--- Document Information -----------------------------------------------------
Title:			dspOneColumBlank.cfm
Author:		John Allen
Email:			jallen@figleaf.com
company:	Figleaf Software
Website:	@@@web-site@@@
Purpose:		I render a blank one column page. I am include.
Modification Log:
Name				Date				Description
================================================================================
John Allen		09/17/2008		Created
------------------------------------------------------------------------------->
<cfset rednerHandlerDirectory = Application.vf.getPageEvent().getRederHandlerDirectory()>


<cfoutput>
<table class="layout-table" description="I contain this pages conent.">
	<tr>
		<td>
			<!--- this value gets set in the parent page that includes this file --->
			<div class="cs-content-wrapper">
					#blankPage.blank_page_content#					 
			</div>
			<cfmodule template="/commonspot/utilities/invoke-dynamic-cfml.cfm" 
				cfml="#rednerHandlerDirectory#/includes/demo-query-ouput.cfm">
		</td>
	</tr>
</table>
</cfoutput>