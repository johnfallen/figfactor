<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title: 			index.cfm
Author:			John Allen
Email:				jallen@figleaf.com
company:		Figleaf Software
Website:		http://www.nist.gov
Purpose:		Included for every request.
Modification Log:
Name				Date				Description
================================================================================
John Allen		09/17/2008		Created
------------------------------------------------------------------------------->
<cftry>
	<cfif not structKeyExists(Application, "BeanFactory")
		or 
			(
				Application.BeanFactory.getBean("ConfigBean").getReload() eq true
			)
				
		or	
			(	
				structKeyExists(URL, "#Application.BeanFactory.getBean('ConfigBean').getURLRelaodKey()#") 
				and not comparenocase
				(
					URL[Application.BeanFactory.getBean('ConfigBean').getURLRelaodKey()], 
					Application.BeanFactory.getBean("ConfigBean").getURLReloadKeyValue()
				)
			)
	>
		<cfinclude template="com/system/figfactorbootstrapper.cfm" />
	</cfif>
	<cfcatch>
		<cftry>
			<!--- retry, cause the config bean might be messed up --->
			<cfinclude template="com/system/figfactorbootstrapper.cfm" />
			<cfcatch>
				<cfthrow 
					message="#cfcatch.message#" 
					detail="#cfcatch.detail#" 
					extendedinfo="#cfcatch.ExtendedInfo#" />
			</cfcatch>
		</cftry>
	</cfcatch>
</cftry>

<!--- Validator, this is here so notihg get past --->
<cfif application.beanfactory.getBean("ConfigBean").getEnableValidator() eq true>
	<cfset application.beanfactory.getBean("validator").checkInput() />
</cfif>