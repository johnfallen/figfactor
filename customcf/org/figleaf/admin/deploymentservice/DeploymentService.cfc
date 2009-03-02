<!--- Document Information -----------------------------------------------------
Build:      @@@revision-number@@@

Title:      DeploymentService.cfc

Author:     John Allen
Email:      jallen@figleaf.com

Company:    @@@company-name@@@
Website:    @@@web-site@@@

Purpose:    I deploy files to the correct site.

Usage:      

Modification Log:

Name	 Date	 Description
================================================================================
John Allen	 04/08/2008	 Created

------------------------------------------------------------------------------->
<cfcomponent displayname="Deployment Service" hint="I deploy files to the correct site." output="false">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" access="public" output="false" 
	displayname="Init" hint="I am the pseudo-constructor." 
	description="I am the pseudo-constructor for this CFC.">
	
	<cfargument name="ConfigurationBean" hint="I am the frameworks Configuration Bean.<br />I am required." />
	<cfargument name="Logger" hint="I am the LoggerService.<br />I am required." />
	
	<cfset variables.ConfigBean = arguments.ConfigurationBean />
	<cfset variables.Logger = arguments.Logger />

	<cfreturn this />
</cffunction>


<!--- deployFiles --->
<cffunction name="deployFiles" access="public" output="false" 
	displayname="Deploy Files" hint="I deploy files to the correct sub-site." 
	description="I deploy files from the deploymentpackages directory to the correct sub-site. I will deploy the root directory by defalut.">

	<cfargument name="packageDirectoryName" required="true" default="root" 
		hint="I am the name of the directory to deploy." />
	<cfargument name="deploymentDirectories" type="string" default=""
		hint="I am a list of default directories to deploy.<br />I default to an empty string." />
	<cfargument name="subSitePath" required="false" default="/"
		hint="I am the path of the sub-site to deploy files to." />
	<cfargument name="sourceDirectory" default="#variables.ConfigBean.getFrameworkDeploymentSourceDirectory()#/#arguments.packageDirectoryName#"
		hint="I am the source directory to deploy to.<br />I defalut a configuration setting concantinated with the argument.packageDirectoryName." />
	<cfargument name="destiniationDirectory" default="#variables.ConfigBean.getWebSiteServerContext()#" 
		hint="I am the destiniation directory to deploy to.<br />I defalut a configuration setting." />
	
	<cfset var x = 0 />
	<cfset var source = 0 />
	
	<cfif len(arguments.deploymentDirectories)>
	
		<!--- append the destiniation if it is NOT root --->
		<cfif arguments.subSitePath neq "/">
			<cfset arguments.deploymentDirectories = arguments.destiniationDirectory & arguments.SubSitePath />
		</cfif>
	
		<cfloop list="#arguments.deploymentDirectories#" index="x">
		
			<cfdirectory action="list" directory="#arguments.sourceDirectory#/#x#" name="source" />	
	
			<cfif source.recordcount>
				<cfset directoryCopy(
					source = "#arguments.sourceDirectory#/#x#",
					destination = "#arguments.destiniationDirectory#/#x#",
					nameconflict = "overwrite") />
					
				<cfset variables.logger.setMessage(message = "Directory Deployed: #arguments.destiniationDirectory#/#x#")>
			</cfif>
		</cfloop>
	</cfif>
</cffunction>


<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<cffunction name="directoryCopy" output="true" access="private">
    <cfargument name="source" required="true" type="string">
    <cfargument name="destination" required="true" type="string">
    <cfargument name="nameconflict" required="true" default="overwrite">

    <cfset var contents = "" />
    <cfset var dirDelim = "/">

    <cfif not(directoryExists(arguments.destination))>
        <cfdirectory action="create" directory="#arguments.destination#">
    </cfif>

    <cfdirectory action="list" directory="#arguments.source#" name="contents">

    <cfloop query="contents">
        <cfif contents.type eq "file" and contents.name neq ".DS_Store">
            <cffile action="copy" source="#arguments.source#/#name#" destination="#arguments.destination#/#name#" nameconflict="#arguments.nameConflict#" mode="777">
        <cfelseif contents.type eq "dir">
            <cfset directoryCopy(arguments.source & dirDelim & name, arguments.destination & dirDelim & name) />
        </cfif>
    </cfloop>

</cffunction>
</cfcomponent>