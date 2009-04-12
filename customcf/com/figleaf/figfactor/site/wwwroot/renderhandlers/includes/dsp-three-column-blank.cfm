<!--- Document Information -----------------------------------------------------
Title: 			dspThreeColumBlank.cfm
Author:			John Allen
Email:				jallen@figleaf.com
company:		Figleaf Software
Website:		http://www.nist.gov
Purpose:		I render a blank three column page. I am included.
Modification Log:
Name				Date				Description
================================================================================
John Allen		09/17/2008		Created
------------------------------------------------------------------------------->
<cfset rednerHandlerDirectory = Application.vf.getPageEvent().getRederHandlerDirectory()>


<cfoutput>
<table class="layout-table" description="I am a table and my first column contains lists of links, the second column contains the body of this web page, and the third column contains more lists of links.">
	<tr>
		<td class="borderRight">
			<div id="left-coll-wrapper">

				</cfoutput><cfmodule template="/commonspot/utilities/ct-render-named-element.cfm"
					ElementName="genericLeftColExtraText"
					ElementType="textblock-nohdr">
					
				<!--- linkbar --->
				<cfmodule template="/commonspot/utilities/ct-render-named-element.cfm"
					elementName="genericLinksLeftCol"
			        elementType="linkbar">
				
				<!--- extra text 2 --->        
				<cfmodule template="/commonspot/utilities/ct-render-named-element.cfm"
					ElementName="genericLeftColExtraText2"
					ElementType="textblock-nohdr">
					
				<!--- linkbar 2 --->
				<cfmodule template="/commonspot/utilities/ct-render-named-element.cfm"
					elementName="genericLinksLeftCol1"
			        elementType="linkbar"><cfoutput>
			</div>
		</td>
		<td>
			<div id="center-coll-wrapper">	
				<!--- this value gets set in the parent page that includes this file --->
				<div class="cs-content-wrapper">
					#blankPage.blank_page_content#
				</div>
				
				<cfmodule template="/commonspot/utilities/invoke-dynamic-cfml.cfm" 
					cfml="#rednerHandlerDirectory#/includes/demo-query-ouput.cfm">
			</div>
		</td>
		<td class="borderLeft">
			<div id="right-coll-wrapper">
				
				<!--- extra text information 1 --->
				</cfoutput><cfmodule template="/commonspot/utilities/ct-render-named-element.cfm"
					ElementName="genericRightCalExtraText"
					ElementType="textblock-nohdr">
				
				<!--- Generic links 1 --->
				<cfmodule template="/commonspot/utilities/ct-render-named-element.cfm"
					elementName="genericRightCalLinks"
			        elementType="linkbar">
			        
			    <!--- extra text information 2 --->
				<cfmodule template="/commonspot/utilities/ct-render-named-element.cfm"
					ElementName="genericRightCalExtraText2"
					ElementType="textblock-nohdr">
				
				<!--- Generic links 2 --->
				<cfmodule template="/commonspot/utilities/ct-render-named-element.cfm"
					elementName="genericRightCalLinks2"
			        elementType="linkbar"><cfoutput>
			</div>
		</td>
	</tr>
</table>
</cfoutput>
