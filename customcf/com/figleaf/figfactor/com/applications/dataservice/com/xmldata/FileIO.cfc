<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title: 				FileIO.cfc
Author:				John Allen
Email:					jallen@figleaf.com
company:			Figleaf Software
Website:			http://www.nist.gov
Purpose:			I write XML file data to the disk, and can read and
						recreate the ColdFusion data types from the XML
						file data to repopulate one of the cache's.
Usage:			
Modification Log:
Name				Date				Description
================================================================================
John Allen		11/08/2008		Created
------------------------------------------------------------------------------->
<cfcomponent displayname="File IO" hint="I read and write XML files." output="false">
	
<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the constructor for this CFC. I return an instance of myself.">
	
	<cfset variables.sosxml = createObject("component", "sosxml.sosxml").init() />
	
	<!--- the data directory will always be relative to this CFC --->
	<cfset variables.dataDirectory = replace(getcurrenttemplatepath(), "FileIO.cfc", "") & "data" />	
	
	<!--- make sure the directory is there --->
	<cfif not directoryexists("#variables.dataDirectory#")>
		<cfdirectory action="create" directory="#variables.dataDirectory#">
	</cfif>
	
	<cfreturn this />
</cffunction>



<!--- writeXMLFile --->
<cffunction name="writeXMLFile" access="public" output="false"
	displayname="Write XML File" hint="I write queries to disk as XML files."
	description="I change a query object into a XML object, add some meta data to a structure, add the query then write it to disk.">
	
	<cfargument name="key" type="string" required="true" 
		hint="I am the name of datasource to add.<br />I a required."/>
	<cfargument name="value" type="any" required="true" 
		hint="I am the value of datasource to add.<br />I am required."/>

	<cfset var cacheFile = 0 />
	<cfset var x = "" />
	<cfset var count = 1 />

	<cfset var fileName = "" />
	
	<!--- convert the query, then write the file --->
	<cfif isStruct(arguments.value)>
		<!--- 
		Create xml files for each query in the structure, appending the key 
		with a numeric sequence so we can associate the files when rebuilding.
		File names are created by the keys. Also add attributes to the XML for
		rebuilding the cache from disk.
		--->
		<cfloop collection="#arguments.value#" item="x">
			
			<cfset cacheFile = queryToXML(arguments.value[x]) />
			<cfset fileName = arguments.key & "_" & count />
			
			<cfset variables.sosxml.attributeSet(
				xmlElement = cacheFile.query,
				attributeName = "cachekey",
				attributeValue = arguments.key) />
			
			<cfset variables.sosxml.attributeSet(
				xmlElement = cacheFile.query,
				attributeName = "queryName",
				attributeValue = x) />
			
			<cfset writeCacheFile(
				xml = cacheFile,
				fileName = fileName) />
			<cfset count = count + 1 />
		</cfloop>
	</cfif>

</cffunction>



<!--- buildCacheFromXML --->
<cffunction name="buildCacheFromXML" access="public" output="false" 
	displayname="Build Cache From XML" hint="I build the cache from my local XML files." 
	description="I read my local XML files, which should be the data I added to the cache, and add them into the cache.">

	<cfreturn XMLFiles />
</cffunction>



<!--- *********** Package ************ --->
<!--- *********** Private ************ --->

<!--- writeCacheFile --->
<cffunction name="writeCacheFile" access="private" output="false" 
	displayname="Write Cache File" hint="I write a cache file to disk." 
	description="I write a cache file to the correct data storage directory.">

	<cfargument name="xml" hint="I am the query.<br />I am required." />
	<cfargument name="fileName" hint="I am the name of the file to write.<br />I am required.">

	<cftry>
		<cffile action="delete"
			file="#variables.dataDirectory#/#arguments.fileName#.xml" />
		<cfcatch></cfcatch>
	</cftry>
	
	
	
	
	<cffile action="WRITE"
		file="#variables.dataDirectory#/#arguments.fileName#.xml"
		output="#toString(arguments.xml)#"  />

	</cffunction>



<!--- queryToXML --->
<cfscript>
function queryToXML(query){
	//the default name of the root element
	var root = "query";
	//the default name of each row
	var row = "row";
	//make an array of the columns for looping
	var cols = listToArray(query.columnList);
	//which mode will we use?
	var nodeMode = "values";
	//vars for iterating
	var ii = 1;
	var rr = 1;
	//vars for holding the values of the current column and value
	var thisColumn = "";
	var thisValue = "";
	//a new xmlDoc
	var xml = xmlNew();
	//if there are 2 arguments, the second one is name of the root element
	if(structCount(arguments) GTE 2)
		root = arguments[2];
	//if there are 3 arguments, the third one is the name each element
	if(structCount(arguments) GTE 3)
		row = arguments[3];		
	//if there is a 4th argument, it's the nodeMode
	if(structCount(arguments) GTE 4)
		nodeMode = arguments[4]; 	
	//create the root node
	xml.xmlRoot = xmlElemNew(xml,root);
	//capture basic info in attributes of the root node
	xml[root].xmlAttributes["columns"] = arrayLen(cols);
	xml[root].xmlAttributes["rows"] = query.recordCount;
	//loop over the recordcount of the query and add a row for each one
	for(rr = 1; rr LTE query.recordCount; rr = rr + 1){
		arrayAppend(xml[root].xmlChildren, xmlElemNew(xml,row));
		//loop over the columns, populating the values of this row
		for(ii = 1; ii LTE arrayLen(cols); ii = ii + 1){
			thisColumn = lcase(cols[ii]);
			thisValue = query[cols[ii]][rr];
			switch(nodeMode){
				case "rows":
					xml[root][row][rr].xmlAttributes[thisColumn] = thisValue;
					break;
				case "columns":
					arrayAppend(xml[root][row][rr].xmlChildren,xmlElemNew(xml,thisColumn));
					xml[root][row][rr][thisColumn].xmlAttributes["value"] = thisValue;
					break;
				default:
					arrayAppend(xml[root][row][rr].xmlChildren,xmlElemNew(xml,thisColumn));
					xml[root][row][rr][thisColumn].xmlText = thisValue;			
			}

		}
	}
	//return the xmlDoc
	return xml;	
}
</cfscript>



</cfcomponent>