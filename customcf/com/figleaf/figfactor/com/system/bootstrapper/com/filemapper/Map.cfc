<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			Map.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I model a file mapping
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		26/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Map" output="false"
	hint="I model a file mapping">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Map" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="allowedExtensions" type="string" required="false" default="" 
		hint="I am a list of allowed extensions to filter by. I default to an empty string." />
	<cfargument name="MapName" type="string" required="false" default="" 
		hint="I am the name of the mapping. I default to an empty string." />
	<cfargument name="FileName" type="string" required="false" default="" 
		hint="I am the name of a single file to copy. I default to an empty string." />
	<cfargument name="Source" type="string" required="false" default="" 
		hint="I am the source directory. I default to an empty string." />
	<cfargument name="Destination" type="string" required="false" default="" 
		hint="I am the Destination directory. I default to an empty string." />
	<cfargument name="Recursive" type="boolean" required="false" default="false" 
		hint="Should I recursivly copy all of a directories files? I default to 'false' ." />
	<cfargument name="nameConfilct" type="string" required="false" default="overwrite"
		hint="Should I over write single files? I default to ""overwrite"". I must be a valid attribute value for the CFML tag cffile nameconflict attribute . I am requried." />
	
	<cfargument name="Logger" type="component" required="true"  
		hint="I am the Logger component. I am required." />
	
	<cfset setAllowedExtensions(arguments.allowedExtensions) />
	<cfset setMapName(arguments.MapName) />
	<cfset setFileName(arguments.FileName) />
	<cfset setSource(arguments.Source) />
	<cfset setDestination(arguments.Destination) />
	<cfset setRecursive(arguments.recursive) />
	<cfset setNameConfilct(arguments.nameConfilct) />
	<cfset setHasDeployed(false) />
	
	<cfset variables.Logger = arguments.Logger />
	
	<cfreturn this />
</cffunction>


 
<!--- deploy --->
<cffunction name="deploy" returntype="boolean" access="public" output="false"	
	displayname="Deploy" hint="I attemt to deploy myself."
	description="I attemt to deploy myself.">
    
	<cfif len(getSource()) and len(getDestination())>
	
		<cfset variables.logger.setMessage(message="*************************************************") />
		<cfset variables.logger.setMessage(message="Map Deployment: #getMapName()#") />
	
		<cfif len(getFileName())>
			<cfset copyFile() />
		<cfelse>
			<cfset directoryCopy() />
		</cfif>
		
		<!--- change the state --->
		<cfset setHasDeployed(true) />
		
		<cfset variables.logger.setMessage(message="*************************************************") />
	</cfif>

	<cfreturn getHasDeployed() />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- directoryCopy --->
<cffunction name="directoryCopy" output="true" access="private">
    <cfargument name="source" required="true" type="string" default="#getSource()#" />
    <cfargument name="destination" required="true" type="string" default="#getDestination()#" />
    <cfargument name="nameconflict" required="true" default="#getNameConfilct()#" />
	<cfargument name="allowedExtensions" required="false" default="#getAllowedExtensions()#" />

    <cfset var contents = "" />
    <cfset var dirDelim = getDirDelim() />
	<cfset var x = 0 />
	
	<cfset variables.logger.setMessage(message="******DirectoryCopy*****") />
	<cfset variables.logger.setMessage(message="Source: #arguments.source#") />
	<cfset variables.logger.setMessage(message="Destina: #arguments.destination#") />

    <cfif not(directoryExists(arguments.destination))>
        <cfdirectory action="create" directory="#arguments.destination#" />
		<cfset variables.logger.setMessage(message="DIRECTORY CREATED: #arguments.destination#") />
    </cfif>
    
    <cfdirectory action="list" directory="#arguments.source#" name="contents" />
   
    <cfloop query="contents">	
		<!--- 
			Only if its a file, and if there is a list of allowed files, the files 
			extension must be in the list. 
		--->
        <cfif contents.type eq "file" and listLen(getAllowedExtensions()) eq 0 
			or 
				(contents.type eq "file" and ListContainsNoCase(
					getAllowedExtensions(), right(name, 3), ","))>
			
			<cfset copyFile(
					source = arguments.source,
					destination = arguments.destination,
					fileName = name) />

		<!--- call this function recursivly --->
        <cfelseif contents.type eq "dir">

            <cfset directoryCopy(
				source = fixDirDelim(arguments.source & name), 
				destination = fixDirDelim(arguments.destination & name)) />
       
		</cfif>
    </cfloop>
	
</cffunction>



<!--- copyFile --->
<cffunction name="copyFile" returntype="void" access="private" output="false"
    displayname="Copy File" hint="I copy and log a file I copied."
    description="I copy and log a file I copied.">

	<cfargument name="source" default="#getSource()#" />
	<cfargument name="destination" default="#getDestination()#" />
	<cfargument name="fileName" default="#getFileName()#">

	<cfset variables.logger.setMessage(message="******FileCopy*****") />
	<cfset variables.logger.setMessage(message="Source: #arguments.source##arguments.fileName#") />
	<cfset variables.logger.setMessage(message="Destina: #arguments.destination##arguments.fileName#") />

	<cffile 
		action="copy" 
		source="#arguments.source##arguments.fileName#" 
		destination="#arguments.destination##arguments.fileName#" 
		nameconflict="#getNameConfilct()#" />

</cffunction>



<!--- CheckFileExists --->
<cffunction name="CheckFileExists" access="private" output="false" returntype="any">

	<cfreturn FileExists(getDestination() & getFileName()) />
</cffunction>



<!--- getDirDelim --->
<cffunction name="getDirDelim" returntype="string" access="private" output="false"	
	displayname="getDirDelim" hint="I return ""/"" for *nix and ""\"" for windows respectivly."
	description="I return ""/"" for *nix and ""\"" for windows respectivly.">
    
	<cfif server.OS.Name contains "Windows">
        <cfreturn "\" />
	<cfelse>
		<cfreturn "/" />
    </cfif>
</cffunction>



<!--- fixDirDelim --->
<cffunction name="fixDirDelim" returntype="string" access="private" output="false"	
	displayname="Fix Dir Delim" hint="I fix the slashing for an operating system."
	description="I fix the slashing for an operating system.">
    
	<cfargument name="path" type="string" required="true" 
		hint="I am the path to fix. I am requried." />
	
	<cfif server.OS.Name contains "Windows">
		<cfset arguments.path = replace(arguments.path, "/", "\", "all") />
		<cfif right(arguments.path, 1) neq "\">
			<cfset arguments.path = arguments.path & "\" />
		</cfif>
	<cfelse>
		<cfset arguments.path = replace(arguments.path, "\", "/", "all") />
		<cfif right(arguments.path, 1) neq "\">
			<cfset arguments.path = arguments.path & "/" />
		</cfif>
	</cfif>
	<cfreturn arguments.path />
</cffunction>



<!--- ************************* Accors/Mutators ************************** --->

<!--- getHasDeployed --->
<cffunction name="getHasDeployed" access="public" output="false" returntype="boolean"
	displayname="Get HasDeployed" hint="I return the HasDeployed property." 
	description="I return the HasDeployed property to my internal instance structure.">
	<cfreturn variables.instance.HasDeployed />
</cffunction>
<!--- setHasDeployed --->
<cffunction name="setHasDeployed" access="public" output="false" returntype="void"
	displayname="Set HasDeployed" hint="I set the HasDeployed property." 
	description="I set the HasDeployed property to my internal instance structure.">
	<cfargument name="HasDeployed" type="boolean" required="true"
		hint="I am the HasDeployed property. I am required."/>
	<cfset variables.instance.HasDeployed = arguments.HasDeployed />
</cffunction>
<!--- getAllowedExtensions --->
<cffunction name="getAllowedExtensions" access="public" output="false" returntype="string"
	displayname="Get AllowedExtensions" hint="I return the AllowedExtensions property." 
	description="I return the AllowedExtensions property to my internal instance structure.">
	<cfreturn variables.instance.AllowedExtensions />
</cffunction>
<!--- setAllowedExtensions --->
<cffunction name="setAllowedExtensions" access="public" output="false" returntype="void"
	displayname="Set AllowedExtensions" hint="I set the AllowedExtensions property." 
	description="I set the AllowedExtensions property to my internal instance structure.">
	<cfargument name="AllowedExtensions" type="string" required="true"
		hint="I am the AllowedExtensions property. I am required."/>
	<cfset variables.instance.AllowedExtensions = arguments.AllowedExtensions />
</cffunction>
<!--- getFileName --->
<cffunction name="getFileName" access="public" output="false" returntype="string"
	displayname="Get FileName" hint="I return the FileName property." 
	description="I return the FileName property to my internal instance structure.">
	<cfreturn variables.instance.FileName />
</cffunction>
<!--- setFileName --->
<cffunction name="setFileName" access="public" output="false" returntype="void"
	displayname="Set FileName" hint="I set the FileName property." 
	description="I set the FileName property to my internal instance structure.">
	<cfargument name="FileName" type="string" required="true"
		hint="I am the FileName property. I am required."/>
	<cfset variables.instance.FileName = arguments.FileName />
</cffunction>
<!--- getMapName --->
<cffunction name="getMapName" access="public" output="false" returntype="string"
	displayname="Get MapName" hint="I return the MapName property." 
	description="I return the MapName property to my internal instance structure.">
	<cfreturn variables.instance.MapName />
</cffunction>
<!--- setMapName --->
<cffunction name="setMapName" access="public" output="false" returntype="void"
	displayname="Set MapName" hint="I set the MapName property." 
	description="I set the MapName property to my internal instance structure.">
	<cfargument name="MapName" type="string" required="true"
		hint="I am the MapName property. I am required."/>
	<cfset variables.instance.MapName = arguments.MapName />
</cffunction>
<!--- getSource --->
<cffunction name="getSource" access="public" output="false" returntype="string"
	displayname="Get Source" hint="I return the Source property." 
	description="I return the Source property to my internal instance structure.">
	<cfreturn variables.instance.Source />
</cffunction>
<!--- setSource --->
<cffunction name="setSource" access="public" output="false" returntype="void"
	displayname="Set Source" hint="I set the Source property." 
	description="I set the Source property to my internal instance structure.">
	<cfargument name="Source" type="string" required="true"
		hint="I am the Source property. I am required."/>

	<cfset variables.instance.Source = fixDirDelim(arguments.Source) />

</cffunction>
<!--- getDestination --->
<cffunction name="getDestination" access="public" output="false" returntype="string"
	displayname="Get Destination" hint="I return the Destination property." 
	description="I return the Destination property to my internal instance structure.">
	<cfreturn variables.instance.Destination />
</cffunction>
<!--- setDestination --->
<cffunction name="setDestination" access="public" output="false" returntype="void"
	displayname="Set Destination" hint="I set the Destination property." 
	description="I set the Destination property to my internal instance structure.">
	<cfargument name="Destination" type="string" required="true"
		hint="I am the Destination property. I am required."/>

	<cfset variables.instance.Destination = fixDirDelim(arguments.Destination) />

</cffunction>
<!--- getRecursive --->
<cffunction name="getRecursive" access="public" output="false" returntype="boolean"
	displayname="Get Recursive" hint="I return the Recursive property." 
	description="I return the Recursive property to my internal instance structure.">
	<cfreturn variables.instance.Recursive />
</cffunction>
<!--- setRecursive --->
<cffunction name="setRecursive" access="public" output="false" returntype="void"
	displayname="Set Recursive" hint="I set the Recursive property." 
	description="I set the Recursive property to my internal instance structure.">
	<cfargument name="Recursive" type="boolean" required="true"
		hint="I am the Recursive property. I am required."/>
	<cfset variables.instance.Recursive = arguments.Recursive />
</cffunction>
<!--- getnameConfilct --->
<cffunction name="getNameConfilct" access="public" output="false" returntype="string"
	displayname="Get Name Confilct" hint="I return the nameConfilct property." 
	description="I return the nameConfilct property to my internal instance structure.">
	<cfreturn variables.instance.nameConfilct />
</cffunction>
<!--- setnameConfilct --->
<cffunction name="setNameConfilct" access="public" output="false" returntype="void"
	displayname="Set Name Confilct" hint="I set the nameConfilct property." 
	description="I set the nameConfilct property to my internal instance structure.">
	<cfargument name="nameConfilct" type="string" required="true"
		hint="I am the nameConfilct property. I am required."/>
	<cfset variables.instance.nameConfilct = arguments.nameConfilct />
</cffunction>
</cfcomponent>