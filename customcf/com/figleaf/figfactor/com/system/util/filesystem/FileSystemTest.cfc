<cfcomponent 
	output="false" 
	displayname="File System Test" 
	extends="mxunit.framework.TestCase">

<cfset variables.testPath = replace(getCurrentTemplatePath(), "FileSystemTest.cfc", "", "all") />
<cfset variables.testFile = "testtxt.txt" />
<cfset variables.testFilePath = variables.testPath & variables.testFile />
<cfset variables.testDir = "testdir" />
<cfset variables.testDirPath = variables.testPath & variables.testDir />
<cfset variables.testTempDir = "testtempdir" />
<cfset variables.testTempDirPath = variables.testPath & variables.testTempDir />


<!--- createFileSystemNoInit --->
<cffunction name="createFileSystemNoInit" access="private"
	hint="I create a FileSystem object with out calling the init for testing.">
	<cfreturn createObject("component", "FileSystem") />
</cffunction>



<!--- createFileSystem --->
<cffunction name="createFileSystem" access="private"
	hint="I create a FileSystem object.">
	<cfreturn createObject("component", "FileSystem").init() />
</cffunction>



<!--- testDirectoryCopyAndDirectoryDelete --->
<cffunction name="testDirectoryCopyAndDirectoryDelete" access="public" output="false">
	
	<cfset var fs = createFileSystem() />
	<cfset var args = structNew() />
	
	<cfset args.source = variables.testDirPath />
	<cfset args.destination = variables.testTempDirPath />
	
	<cfset fs.directoryCopy(argumentcollection = args) />
	
	<cfset newDir = fs.ListDirectory(variables.testTempDirPath) />
	
	<cfset assertIsQuery(newDir, "Oops! No, the new directory was not coppied") />
	<cfset assertEquals(newDir.recordcount, 3, "The correct number of files were NOT coppied.") />
	
	<!--- clean up --->
	<cfset fs.deleteDirectory(
		directory = args.destination,
		recurse = true) />
	
	<!--- reread --->
	<cfset newDir = fs.ListDirectory(variables.testTempDirPath) />
	
	<!--- check its not there --->	
	<cfset assertEquals(newDir.recordcount, 0, "The directory Delete function failed!.") />
	
</cffunction>



<!--- testInit --->
<cffunction name="testInit" access="public" output="false">
	<cfset assertIsTypeOf(createFileSystem(), "FigFactor.com.system.util.filesystem.FileSystem") />
</cffunction>



<!--- testCheckFileExists --->
<cffunction name="CheckFileExists" access="public" output="false">
	
	<cfset var fs = createFileSystem() />
	<cfset var result = fs.checkFileExists(variables.testPath,variables.testFile) />
	
	<cfset assertTrue(result, "The File read of testtxt.txt failed.") />

</cffunction>



<!--- testCreateFile --->
<cffunction name="testCreateFile" access="public" output="false">
	
	<cfset var args = structNew() />
	<cfset var fs = createFileSystem() />
	<cfset args.Destination = "#variables.testPath#" />
	<cfset args.fileName = "testFileToDelete.txt" />
	<cfset args.content = "foo" />
	
	<cfset assertTrue(fs.CreateFile(argumentCollection = args), "The file didnt write") />
	
	<!--- clean up --->
	<cfset fs.delete(args.destination, args.fileName) />

</cffunction>



<!--- testCreateAndDeleteFile --->
<cffunction name="testCreateAndDeleteFile" access="public" output="false">
	
	<cfset var args = structNew() />
	<cfset var fs = createFileSystem() />
	<cfset args.Destination = "#variables.testPath#" />
	<cfset args.fileName = "testFileToDelete.txt" />
	<cfset args.content = "foo" />
	
	<cfif not fs.CheckFileExists(variables.testPath,args.fileName)>
		<cfset fs.CreateFile(argumentCollection = args) />
	</cfif>
	
	<cfset assertTrue(fs.CreateFile(argumentCollection = args), 
		"The file didnt write") />
	<cfset assertTrue(fs.Delete(variables.testPath,args.fileName),
		"The file didnt delete.") />

</cffunction>



<!--- testReadFile --->
<cffunction name="testReadFile" access="public" output="false">

	<cfset var args = structNew() />
	<cfset var fs = createFileSystem() />
	<cfset var expectedContent = "foo" />	
	<cfset var content = fs.read(variables.testPath, variables.testFile) />
	
	<cfset assertEquals(expectedContent, trim(content), "NO! They were different. Should be FOO.") />
	
</cffunction>



<!--- testFixDestination --->
<cffunction name="testFixDestination" access="public" output="false">
	
	<cfset var fs = createFileSystem() />
	<cfset var d = variables.testPath & "theFooBarDirForTestingThisStringShouldBeUnique" />
	<cfset var fixedD = fs.fixDestination(d) />
	<cfset var dirList = fs.listDirectory(fixedD) />
	<cfset var amount = dirList.recordcount />

	<cfset assertIsQuery(dirList, "Your test code or the FileSystem is all messed up.") />
	<cfset assertTrue(amount eq 0, "For some reason the temp dir has files in it. This meas that we are ALLLL screwed up.") />
	
	<!--- clean up --->
	<cfset fs.deleteDirectory(directory = fixedD) />

</cffunction>



<!--- testListDirectory --->
<cffunction name="testListDirectory" access="public" output="false">
	
	<cfset var fs = createFileSystem() />
	<cfset var results = fs.ListDirectory(variables.testDirPath) />
	<cfset var expectedCount = 3 />
	
	<cfset assertIsQuery(results, "The directory read failed and didnt return a query.") />
	<cfset assertEquals(results.recordcount, expectedCount, "The read returned more than 3 files.") />

</cffunction>
</cfcomponent>