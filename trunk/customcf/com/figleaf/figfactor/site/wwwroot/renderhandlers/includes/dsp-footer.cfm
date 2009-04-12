<!--- Document Information -----------------------------------------------------
Title:			dspFooter.cfm
Author:		John Allen
Email:			jallen@figleaf.com
company:	Figleaf Software
Website:	@@@web-site@@@
Purpose:	I am the code that dynamically displays the footer.
Modification Log:
Name				Date				Description
================================================================================
John Allen		09/17/2008		Created
------------------------------------------------------------------------------->
<cfset footer = Application.ViewFramework.getPageEvent() />
<cfoutput>
<p>&copy; #dateformat(now(), "long")#</p>
<p>
	Date created: #dateformat(footer.getPageCreateDate(), "long")#   Last updated:  #dateformat(footer.getPageLastModifyDate(), "long")#&nbsp;&nbsp;&nbsp;
	Contact: <a href="mailto:#footer.getFooterEmail()#" class="bold"> #footer.getParentSite()#</span> Webmaster</a>
</p>
</cfoutput>