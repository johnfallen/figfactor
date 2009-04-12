<!--- Document Information -----------------------------------------------------
Title:			developer_insight.cfm
Author:		John Allen
Email:			jallen@figleaf.com
company:	Figleaf Software
Website:	http://www.nist.gov
Purpose:	I dump several object.
Modification Log:
Name				Date				Description
================================================================================
John Allen		09/17/2008		Created
------------------------------------------------------------------------------->
<!---  
Dump the developer insight template if configured to do so.
--->
<cfif Application.BeanFactory.getBean("ConfigBean").getSystemMode() contains "dev">
<cfoutput>
<style>
##developer-insight {
border-top:solid 1px gray;	
border-right:solid 2px black;	
border-bottom:solid 2px black;	
border-left:solid 1px gray;	
padding:10px;
margin-top:50px;
margin-left:10px;
width:1000px;
}
</style>
<div id="developer-insight">
<table cellpadding="10">
	<tr valign="top">
		<td>
			<h3>The PageEvents Event Collection<br />
			<em>Application.ViewFramework.getPageEvent().getAllValues()</em>
			</h3>
			<cfdump var="#Application.ViewFramework.getPageEvent().getAllValues()#" label="EventCollection" expand="false" />
			
			
			<h3>The PageEvents Instance Data<br />
			<em>Application.ViewFramework.getPageEvent().getInstance()</em>
			</h3>
			<cfdump var="#Application.ViewFramework.getPageEvent().getInstance()#" label="Page Event Instance Data" expand="false" />

			
			<h3>The Configured Cache<br />
			<em>Application.BeanFactory.getBean("cache").getCache().viewCache()</em>
			</h3>
			<cfdump var="#Application.BeanFactory.getBean('CacheService').getCache().viewCache()#" label="The Configured Cache" expand="true" /></td>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td>
			
			<h3>The Current Configuration<br />
			<em>Application.BeanFactory.getBean("ConfigBean").getInstance()</em>
			</h3>
			<cfdump var="#Application.BeanFactory.getBean("ConfigBean").getInstance()#" label="Config" expand="false" />
			
			<h3>Dataservice</h3><br />
			<em>Application.BeanFactory.getBean("DataService")</em>
			</h3>
			<cfdump var="#Application.BeanFactory.getBean("DataService").getInstance()#" label="Config" expand="false" />
			
		</td>
	</tr>
</table>
</div>
</cfoutput>
</cfif>