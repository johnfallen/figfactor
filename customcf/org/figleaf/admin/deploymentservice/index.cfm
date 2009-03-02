<!--- directory list of deploymentpackages --->
<cfdirectory action="list" directory="#getDirectoryFromPath(GetCurrentTemplatePath())#/deploymentpackages" name="deploymentpackages" />


<cfdirectory action="list" directory="#deploymentpackages.DIRECTORY#/root" name="deploymentDirectories" />


<cfif isDefined("url.deploy")>
	<cfset Application.ViewFramework.deployFiles(
		packageDirectoryName = form.packageDirectoryName,
		subSitePath = form.subSitePath,
		deploymentDirectories = form.deploymentDirectories) />
	<cfset message = 
		"Deployment of package '#form.packageDirectoryName#' successfull.<br />
			Directories deployed<br />#form.deploymentDirectories#" />
</cfif>

<cfoutput>
<h1>Deployment Service</h1>

<cfif deploymentDirectories.recordcount>
<!--- full deploy --->
<div class="box">
	
	<form name="deployForm" action="index.cfm?deploy=1" method="post" enctype="multipart/form-data">
		<input type="hidden" name="packageDirectoryName" value="#deploymentpackages.name#" />
		<fieldset id="siteForm">
			
		
			Directory to deploy:
			<div class="formItem">
			<table>	
				<cfloop query="deploymentDirectories">
					<tr valign="middle">
						<td width="20"><input type="checkbox" name="deploymentDirectories" value="#name#"></td>
						<td>#name# </td>
					</tr>
				</cfloop>
			</table>
			</div>
			
			<div class="formItem">
				<label for="subSitePath">Sub Site Path:</label>
				<input type="text" id="subSitePath" name="subSitePath" value="/" />
			</div>
			
			<div class="formItem">
				<input type="submit" id="deploySubmit" value="Deploy &raquo;" />
			</div>
		</fieldset>
	</form>
</div>
<cfelse>
<h2>No files are in the deploymentpackages directory.</h2>
<cfdump var="#deploymentDirectories#">
</cfif>
</cfoutput>