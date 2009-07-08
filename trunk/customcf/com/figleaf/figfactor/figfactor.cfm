<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title: 			Application.cfm
Author:			John Allen
Email:				jallen@figleaf.com
company:		Figleaf Software
Website:		http://www.nist.gov
Purpose:		I am the figfactor.cfm file, I should run on every requerst to 
					commonspot.
Modification Log:
Name				Date				Description
================================================================================
John Allen		03/27/2009		Created
------------------------------------------------------------------------------->
<cfif not structKeyExists(Application, "FigFactor")
		or 
			(
				Application.FigFactor.getBean("Config").getReload() eq true
			)
				
		or	
			(	
				structKeyExists(URL, "#Application.FigFactor.getBean('Config').getURLReloadKey()#") 
				and not comparenocase
				(
					URL[Application.FigFactor.getBean('Config').getURLReloadKey()], 
					Application.FigFactor.getBean("Config").getURLReloadKeyValue()
				)
			)
	>
	
	<!--- light up FigFactor --->
	<cfset Application.FigFactor = createObject("component", "FigFactor").init() />
</cfif>