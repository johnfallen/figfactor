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
<!--- *********** Package *********** --->
<!--- init --->
<cffunction name="init" returntype="FileSystem" access="package" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfreturn this />
</cffunction>



<!--- CheckFileExists --->
<cffunction name="CheckFileExists" access="package" output="false" returntype="any">
	
	<cfargument name="Destination" required="true" type="string" 
		hint="I am the fully system path.<br />I am required." />
	<cfargument name="FileName" required="true" type="any" 
		hint="I am the file name.<br />I am required." />
	
	<cfreturn FileExists(arguments.Destination & arguments.FileName) />
</cffunction>



<!--- CreateFile --->
<cffunction name="CreateFile" access="package" output="false" returntype="any">
	
	<cfargument name="Destination" required="true" type="string" 
		hint="I am the fully system path.<br />I am required." />
	<cfargument name="FileName" required="true" type="any" 
		hint="I am the file name.<br />I am required." />
	<cfargument name="Content" required="true" type="any" 
		hint="I am the content of the file.<br />I am required." />

	<cftry>
		
		<cflock type="exclusive" name="CreateFileLock#createUUID()#" timeout="10">
			<cffile 
				action="write" 
				file="#arguments.Destination##arguments.FileName#" 
				output="#arguments.Content#" />
		</cflock>

		<cfcatch type="any">
			<cfthrow type="FileSystem.createFile" message="#cfcatch.message#" />
		</cfcatch>
	</cftry>
</cffunction>



<!--- delete --->
<cffunction name="delete" access="package" output="false" returntype="void" 
	displayname="Delete" hint="I delete a file by path and name."
	description="I attempt to delete a file by path and name.<br />Throws error if file not found.">
	
	<cfargument name="Destination" required="true" type="string" 
		hint="I am the fully system path.<br />I am required." />
	<cfargument name="FileName" required="true" type="any" 
		hint="I am the file name.<br />I am required." />

	<cftry>
		<cffile 
			action="delete" 
			file="#arguments.Destination##arguments.FileName#" />
		
		<cfcatch type="any">
			<cfthrow type="FileSystem.delete" message="#cfcatch.message#" />
		</cfcatch>
	</cftry>

</cffunction>



<!--- read --->
<cffunction name="read" access="package" output="false" returntype="any">
	
	<cfargument name="Destination" required="true" type="string" 
		hint="I am the fully system path.<br />I am required." />
	<cfargument name="FileName" required="true" type="any" 
		hint="I am the file name.<br />I am required." />

	<cfset var result = "" />
	<cfset var content = 0 />
	
	<cftry>
		<cffile 
			action="read" 
			file="#arguments.Destination##arguments.FileName#" 
			variable="content" />
		
		<cfset result = content />
		
		<cfcatch type="any">
			<cfthrow type="FileSystem.read" message="#cfcatch.message#" />
		</cfcatch>
	</cftry>
	
	<cfreturn result />
</cffunction>
<!--- *********** Private *********** --->
</cfcomponent>