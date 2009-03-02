<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			FileSystem.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I abstract file system interaction
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		13/12/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="File System" output="false"
	hint="I abstract file system interaction.">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="FileSystem" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfreturn this />
</cffunction>



<!--- CheckFileExists --->
<cffunction name="CheckFileExists" access="public" output="false" returntype="any">
	
	<cfargument name="Destination" required="true" type="string" hint="I am the fully system path.<br />I am required." />
	<cfargument name="FileName" required="true" type="any" hint="I am the file name.<br />I am required." />
	
	<cfreturn FileExists(arguments.Destination & arguments.FileName) />
</cffunction>



<!--- CreateFile --->
<cffunction name="CreateFile" access="public" output="false" returntype="any">
	
	<cfargument name="Destination" required="true" type="string" hint="I am the fully system path.<br />I am required." />
	<cfargument name="FileName" required="true" type="any" hint="I am the file name.<br />I am required." />
	<cfargument name="Content" required="true" type="any" hint="I am the content of the file.<br />I am required." />

	<cftry>
		
		<cflock type="exclusive" name="#createUUID()#" timeout="10">
			<cffile action="write" file="#arguments.Destination##arguments.FileName#" output="#arguments.Content#" />
		</cflock>

		<cfcatch type="any">
			<cfthrow type="FileSystem.createFile" message="#cfcatch.message#" />
		</cfcatch>
	</cftry>
</cffunction>



<!---
 Copies a directory.
 
 @param source 	 Source directory. (Required)
 @param destination 	 Destination directory. (Required)
 @param nameConflict 	 What to do when a conflict occurs (skip, overwrite, makeunique). Defaults to overwrite. (Optional)
 @return Returns nothing. 
 @author Joe Rinehart (&#106;&#111;&#101;&#46;&#114;&#105;&#110;&#101;&#104;&#97;&#114;&#116;&#64;&#103;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 @version 1, July 27, 2005 
--->
<cffunction name="directoryCopy" output="true">
	<cfargument name="source" required="true" type="string">
	<cfargument name="destination" required="true" type="string">
	<cfargument name="nameconflict" required="true" default="overwrite">

	<cfset var contents = "" />
	<cfset var dirDelim = "/">
	
	<cfif server.OS.Name contains "Windows">
		<cfset dirDelim = "\" />
	</cfif>
	
	<cfif not(directoryExists(arguments.destination))>
		<cfdirectory action="create" directory="#arguments.destination#">
	</cfif>
	
	<cfdirectory action="list" directory="#arguments.source#" name="contents">
	
	<cfloop query="contents">
		<cfif contents.type eq "file">
			<cffile action="copy" source="#arguments.source#\#name#" destination="#arguments.destination#\#name#" nameconflict="#arguments.nameConflict#">
		<cfelseif contents.type eq "dir">
			<cfset directoryCopy(arguments.source & dirDelim & name, arguments.destination & dirDelim &  name) />
		</cfif>
	</cfloop>
</cffunction>



<!--- delete --->
<cffunction name="delete" access="public" output="false" returntype="void" 
	displayname="Delete" hint="I delete a file by path and name."
	description="I attempt to delete a file by path and name.<br />Throws error if file not found.">
	
	<cfargument name="Destination" required="true" type="string" hint="I am the fully system path.<br />I am required." />
	<cfargument name="FileName" required="true" type="any" hint="I am the file name.<br />I am required." />

	<cftry>
		
		<cffile action="delete" file="#arguments.Destination##arguments.FileName#" />
		
		<cfcatch type="any">
			<cfthrow type="FileSystem.delete" message="#cfcatch.message#" />
		</cfcatch>
	</cftry>

</cffunction>



<!--- fixDestination --->
<cffunction name="fixDestination" access="public" output="false" returntype="any" 
	hint="I ensure that the destination ends with a slash, and I create the destination directory if it doesn't exist">
	
	<cfargument name="Destination" required="true" type="string" hint="I am the fully system path.<br />I am required." />
	
	<cfset var theDestination = arguments.Destination />
	
	<!--- add the trailing slash if none exists --->
	<cfif ListLast(theDestination,"") NEQ "/">
		<cfset theDestination = theDestination & "/" />
	</cfif>
	
	<cfif not directoryExists(theDestination)>
		<cfdirectory action="create" directory="#theDestination#" />
	</cfif>
	
	<cfreturn theDestination />
</cffunction>



<!--- listDirectory --->
<cffunction name="listDirectory" returntype="any" access="public" output="false"
	displayname="List Directory" hint="I return the contents of a directory as a query."
	description="I return the contents of a directory as a query.">
	
	<cfargument name="Destination" required="true" type="string" hint="I am the fully system path to the directory.<br />I am required." />
	
	<cfset var result = 0 />
	
	<cfdirectory directory="#arguments.Destination#" name="result" sort="desc" action="list" />
	
	<cfreturn result />
</cffunction>



<!--- upload --->
<cffunction name="upload" access="public" output="false" returntype="any">
	
	<cfargument name="Destination" required="true" type="string" hint="I am the fully system path.<br />I am required." />
	<cfargument name="formFieldName" required="true" type="string" hint="I am the form field name containing the file.<br />I am required." />
	<cfargument name="NewFileName" type="string" hint="I am the string to change the file name too.<br />I default to an empty string." />

	<cfset var Result = structNew() />
	<cfset var FileUpload = 0 />
	<cfset var theDestination = fixDestination(arguments.Destination) />

	<cftry>
		<cfif StructKeyExists(arguments,"NewFileName")>
			
			<cffile action="upload" filefield="#arguments.formFieldName#" destination="#theDestination#"  nameconflict="makeunique" result="FileUpload" />
			
			<cfset Result.ServerFile = FileUpload.serverFile />
			
			<cfset move(theDestination,FileUpload.serverFileName,FileUpload.serverFileExt,arguments.NewFileName) />
			
			<cfif move.Success neq true>
				<cfthrow type="fileSystem.move" message="#cfcatch.message#" detail="#cfcfatch.detail#" />
			</cfif>
		<cfelse>
			
			<cffile action="upload" filefield="#arguments.formFieldName#" destination="#theDestination#"  nameconflict="overwrite" result="FileUpload" />
			
			<cfset Result.ServerFile = FileUpload.serverFile />
			<cfset Result.IsSuccess = true />
		</cfif>
		
		<cfcatch type="any">
			<cfthrow type="FileSystem.Upload" message="#cfcatch.message#" />
		</cfcatch>
	</cftry>

	<cfreturn Result />
</cffunction>



<!--- move --->
<cffunction name="move" access="public" output="false" returntype="struct">
	<cfargument name="Destination" required="true" type="string" hint="I am the fully system path.<br />I am required." />
	<cfargument name="sourceFileName" required="true" type="string" hint="I am the source file name.<br />I am required." />
	<cfargument name="sourceFileExt" required="true" type="string" hint="I am the source file extension.<br />I am required." />
	<cfargument name="fileName" type="string" default="#uniqueFileName()#" hint="I am the file name.<br />I default to uniqueFileName()." />

	<cfset var result = structNew() />
	
	<cftry>
		
		<cffile action="move" source="#variables.basePath##arguments.sourceFileName#.#arguments.sourceFileExt#" destination="#arguments.Destination##arguments.fileName#.#arguments.sourceFileExt#" />
		
		<cfset arguments.Result.Success = true />
		<cfset arguments.Result.SourceFile = arguments.sourceFileName & "." & arguments.sourceFileExt />
		<cfset arguments.Result.DestinationFile = arguments.fileName & "." & arguments.sourceFileExt />
		
		<cfcatch type="any">
			<cfthrow type="fileSystem.move" message="#cfcatch.message#" />
		</cfcatch>
	</cftry>
	
	<cfreturn arguments.Result />
</cffunction>



<!--- read --->
<cffunction name="read" access="public" output="false" returntype="any">
	
	<cfargument name="Destination" required="true" type="string" hint="I am the fully system path.<br />I am required." />
	<cfargument name="FileName" required="true" type="any" hint="I am the file name.<br />I am required." />

	<cfset var result = "" />
	<cfset var content = 0 />
	
	<cftry>
		
		<cffile action="read" file="#arguments.Destination##arguments.FileName#" variable="content" />
		
		<cfset result = content />
		
		<cfcatch type="any">
			<cfthrow type="FileSystem.read" message="#cfcatch.message#" />
		</cfcatch>
	</cftry>
	
	<cfreturn result />
</cffunction>



<!--- uniquefilename --->
<cffunction name="uniquefilename" access="public" output="false" returntype="string">
	
	<cfargument name="prefix" type="string" default="File" hint="I am the prefix for the name<br />I default to 'File'. " />
	
	<cfreturn arguments.prefix & dateformat(now(),"mmddyy") & "_" & timeformat(now(),"HHmmss") />
</cffunction>
<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>