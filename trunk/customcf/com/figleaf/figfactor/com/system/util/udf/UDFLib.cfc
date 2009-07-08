<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title: 				UserDefinedFunctionsLibrary.cfc
Author:				John Allen
Email:					jallen@figleaf.com
company:			Figleaf Software
Website:			http://www.nist.gov
Purpose:			I am the Global User Defined Funciton Library
Modification Log:
Name				Date				Description
================================================================================
John Allen		05/04/2008		Created
------------------------------------------------------------------------------->
<cfcomponent displayname="User Defined Functions Library" hint="I am the Global User Defined Functions Library" output="false">

<!--- init --->
<cffunction name="init" access="public" hint="I am the init" displayname="Init" output="false">
	
	<cfreturn this  />
</cffunction>




<!---
Copies a directory.

@param source      Source directory. (Required)
@param destination      Destination directory. (Required)
@param nameConflict      What to do when a conflict occurs (skip, overwrite, makeunique). Defaults to overwrite. (Optional)
@return Returns nothing.
@author Joe Rinehart (joe.rinehart@gmail.com)
@version 1, July 27, 2005
--->
<cffunction name="directoryCopy" output="true">
    <cfargument name="source" required="true" type="string">
    <cfargument name="destination" required="true" type="string">
    <cfargument name="nameconflict" required="true" default="overwrite">

    <cfset var contents = "" />
    <cfset var dirDelim = "/" />
	 
	<cftry>
	    <cfif server.OS.Name contains "Windows">
	        <cfset dirDelim = "\" />
	    </cfif>
		<cfcatch></cfcatch>
	</cftry>
    
    <cfif not(directoryExists(arguments.destination))>
        <cfdirectory action="create" directory="#arguments.destination#">
    </cfif>
    
    <cfdirectory action="list" directory="#arguments.source#" name="contents">
	
    <cfloop query="contents">
        <cfif contents.type eq "file">
            <cffile action="copy" source="#arguments.source##dirDelim##name#" destination="#arguments.destination##dirDelim##name#" nameconflict="#arguments.nameConflict#">
        <cfelseif contents.type eq "dir">
            <cfset directoryCopy(arguments.source & dirDelim & name, arguments.destination & dirDelim & name) />
        </cfif>
    </cfloop>
</cffunction>



<cfscript>
/**
* Abbreviates a given string to roughly the given length, stripping any tags, making sure the ending doesn't chop a word in two, and adding an ellipsis character at the end.
* Fix by Patrick McElhaney
* v3 by Ken Fricklas kenf@accessnet.net, takes care of too many spaces in text.
*
* @param string      String to use. (Required)
* @param len      Length to use. (Required)
* @return Returns a string.
* @author Gyrus (kenf@accessnet.netgyrus@norlonto.net)
* @version 3, September 6, 2005
*/
function abbreviate(string,len) {
    var newString = REReplace(string, "<[^>]*>", " ", "ALL");
    var lastSpace = 0;
    newString = REReplace(newString, " \s*", " ", "ALL");
    if (len(newString) gt len) {
        newString = left(newString, len-2);
        lastSpace = find(" ", reverse(newString));
        lastSpace = len(newString) - lastSpace;
        newString = left(newString, lastSpace) & " &##8230;";
    }    
    return newString;
}
</cfscript>




<cfscript>
/**
* Gets the ip address of the server.
*
* @return Returns a string.
* @author Robert Everland III (reverland@reactivevision.com)
* @version 1, January 12, 2004
*/
function GetServerIP() {
var iaclass="";
var addr="";

// Init class
iaclass=CreateObject("java", "java.net.InetAddress");

//Get Local host variable
addr=iaclass.getLocalHost();

// Return ip address
return addr.getHostAddress();
}
</cfscript>


<cfscript>
/**
* Determines the root path of the application without hard-coding.
*
* @return Returns a string.
* @author Billy Cravens (billy@architechx.com)
* @version 1, October 3, 2002
*/
function GetRootPath() {
    var cNested = listLen(getBaseTemplatePath(),"\") - listLen(getCurrentTemplatePath(),"\");
    var    appRootDir = cgi.script_name;
    var i = 0;
    
    for (i=0;i lte cNested;i=incrementValue(i)) {
        appRootDir = listDeleteAt(appRootDir,listLen(appRootDir, "/"),"/");
    }
    appRootDir = appRootDir & "/";
    return appRootDir;
}
</cfscript>


<cfscript>
/**
* This function returns the current directory of your current coldfusion template.
*
* @return Returns a string.
* @author Timothy D Farrar (timothyfarrar@sosensible.com)
* @version 1, June 4, 2008
*/
function getCurrentTemplateDirectory() {
    return getDirectoryFromPath(getCurrentTemplatepath());
}
</cfscript>



<cfscript>
/**
* returns the name of the cfapplication.
*
* @return Returns a string.
* @author Steven Maglio (smaglio@graddiv.ucsb.edu)
* @version 1, September 16, 2005
*/
function getApplicationName() {
    var name = "";
    var appScopeTracker = createObject("java", "coldfusion.runtime.ApplicationScopeTracker");
    var keys = appScopeTracker.getApplicationKeys();
    var app = 0;
    var appName = 0;
    
    while(keys.hasNext()) {
        appName = keys.next();
        app = appScopeTracker.getApplicationScope(appName);
        if(app.equals( application ) ) return app.getName();
    }
    return "";
}
</cfscript>



<!--- injectDirectory --->
<cffunction name="injectDirectory" returntype="any" access="private" output="false"
	displayname="Inject Extension UDFs" hint="I inject all of the user defined functions from the gateways CFC's."
	description="I inject all of the user defined functions from the gateways CFC's.">

	<cfargument name="parentCFC" type="any" required="true" 
		hint="I am the objec to inject methods into.<br />I am required." />
	<cfargument name="filePath" type="string" required="true"
		hint="I am the file path of the directory of cfc's.<br />I am required." />
	<cfargument name="componentPath" type="string" required="true" 
		hint="I am the dot notation path to the cfc's ending with a '.' .<br />I am required." />
	
	<cfset var cfcList = 0 />
	<cfset var cfcName = "" />
	<cfset var fileLocation = "#arguments.filePath#" />
	<cfset var cfcPath = "#arguments.componentPath#" />
	<cfset var x = "" />
	<cfset var z = 0 />
	<cfset var cfc = 0 / >
	<cfset var temp = structNew() />
	
	<cfdirectory action="list" name="cfcList" directory="#fileLocation#" />
	
	<!--- loop and create each user defined component --->
	<cfloop query="cfcList">
		
		<cfset cfcName = replaceNoCase(cfcList.name, ".cfc", "") />
		
		<cfinvoke component="#cfcPath##cfcName#"
			returnvariable="temp.udfs.#cfcName#" method="init"/>
	</cfloop>
	
	<!--- loop over the object stucture and inject each method if its NOT the init() --->
	<cfloop collection="#temp.udfs#" item="x">
		
		<cfset cfc = temp.udfs[x] />
		
		<cfloop from="1" to="#arrayLen(getMetaData(cfc).functions)#" index="z">
			
			<cfif getMetaData(cfc).functions[z].name neq "init">
				<cfset injectMethod(artuments.parentCFC, evaluate("cfc" & "." &  "#getMetaData(cfc).functions[z].name#")) />
			</cfif>
		</cfloop>
	</cfloop>

</cffunction>



<cfscript>
/**
* Adds zero and negative support to the length parameter of left().
* 
* @param string      The string to modify. 
* @param length      The length to use. 
* @return Returns a string. 
* @author Jordan Clark (JordanClark@Telus.net) 
* @version 1, February 24, 2002 
*/
function left2( string, length )
{
if( length GT 0 )
return left( string, length );
else if( length LT 0 )
return left( string, len( string ) + length );
else return "";
}
</cfscript>



<cfscript>
/**
* Removes All HTML from a string removing tags, script blocks, style blocks, and replacing special character code.
*
* @param source      String to format. (Required)
* @return Returns a string.
* @author Scott Bennett (scott@coldfusionguy.com)
* @version 1, November 14, 2007
*/
function removeHTML(source){
    
    // Remove all spaces becuase browsers ignore them
    var result = ReReplace(trim(source), "[[:space:]]{2,}", " ","ALL");
    
    // Remove the header
    result = ReReplace(result, "<[[:space:]]*head.*?>.*?</head>","", "ALL");
    
    // remove all scripts
    result = ReReplace(result, "<[[:space:]]*script.*?>.*?</script>","", "ALL");
    
    // remove all styles
    result = ReReplace(result, "<[[:space:]]*style.*?>.*?</style>","", "ALL");
    
    // insert tabs in spaces of <td> tags
    result = ReReplace(result, "<[[:space:]]*td.*?>","    ", "ALL");
    
    // insert line breaks in places of <BR> and <LI> tags
    result = ReReplace(result, "<[[:space:]]*br[[:space:]]*>",chr(13), "ALL");
    result = ReReplace(result, "<[[:space:]]*li[[:space:]]*>",chr(13), "ALL");
    
    // insert line paragraphs (double line breaks) in place
    // if <P>, <DIV> and <TR> tags
    result = ReReplace(result, "<[[:space:]]*div.*?>",chr(13), "ALL");
    result = ReReplace(result, "<[[:space:]]*tr.*?>",chr(13), "ALL");
    result = ReReplace(result, "<[[:space:]]*p.*?>",chr(13), "ALL");
    
    // Remove remaining tags like <a>, links, images,
    // comments etc - anything thats enclosed inside < >
    result = ReReplace(result, "<.*?>","", "ALL");
    
    // replace special characters:
    result = ReReplace(result, "&nbsp;"," ", "ALL");
    result = ReReplace(result, "&bull;"," * ", "ALL");
    result = ReReplace(result, "&lsaquo;","<", "ALL");
    result = ReReplace(result, "&rsaquo;",">", "ALL");
    result = ReReplace(result, "&trade;","(tm)", "ALL");
    result = ReReplace(result, "&frasl;","/", "ALL");
    result = ReReplace(result, "&lt;","<", "ALL");
    result = ReReplace(result, "&gt;",">", "ALL");
    result = ReReplace(result, "&copy;","(c)", "ALL");
    result = ReReplace(result, "&reg;","(r)", "ALL");
    
    // Remove all others. More special character conversions
    // can be added above if needed
    result = ReReplace(result, "&(.{2,6});", "", "ALL");
    
    // Thats it.
    return result;

}
</cfscript>



<cfscript>
function stripHTML(str) {
return REReplaceNoCase(str,"<[^>]*>","","ALL");
}
</cfscript>



<!--- browserDetect --->
<cfscript>
/**
 * Detects 40+ browsers.
 * 
 * @return Returns a string. 
 * @author John Bartlett (jbartlett@strangejourney.net) 
 * @version 1, September 30, 2005 
 */
function browserDetect() {
	var loc=0;
	var i=0;
	var b=0;
	var tmp="";
	var browserList="";
	var currBrowser="";
	
	// Avant Browser (Not all Avant browsers contain "Avant" in the string)
	loc=findNoCase("Avant",CGI.HTTP_USER_AGENT);
	if(loc GT 0) {
		loc=listFindNoCase(CGI.HTTP_USER_AGENT,"MSIE"," ");
		if(loc GT 0) {
			tmp=listGetAt(CGI.HTTP_USER_AGENT,loc + 1," ");
			return "Avant " & left(tmp,len(tmp) - 1);
		}
	}

	// PocketPC
	if(findNoCase("Windows CE",CGI.HTTP_USER_AGENT)) return "PocketPC";

	// Misc (browser x.x)
	browserList="Acorn Browse,Check&Get,iCab,Netsurf,Opera,Oregano,SIS";
	for (b=1; b lte listLen(BrowserList); b=b+1) {
		currBrowser=listGetAt(browserList,b);
		loc=listFindNoCase(CGI.HTTP_USER_AGENT,currBrowser," ");
		if(loc GT 0) return currBrowser & " " & listGetAt(CGI.HTTP_USER_AGENT,loc + 1," ");
	}

	// Misc (browser/x.x)
	BrowserList="Amaya,AmigaVoyager,Amiga-AWeb,Camino,Chimera,Contiki,cURL,Dillo,DocZilla,edbrowse,Emacs-W3,Epiphany,Firefox,IBrowse,iCab,K-Meleon,Konqueror,Lynx,Mosaic,NetPositive,Netscape,OmniWeb,Opera,Safari,SWB,Sylera,W3CLineMode,w3m,WebTV";
	for (b=1; b LTE ListLen(BrowserList); b=b+1) {
		currBrowser=listGetAt(browserList,b);
		loc=findNoCase(currBrowser,CGI.HTTP_USER_AGENT);
		if(loc GT 0) {
			// Locate Browser version in string
			for(i=1;i lte listLen(CGI.HTTP_USER_AGENT," ");i=i+1) {
				if(lCase(left(listGetAt(CGI.HTTP_USER_AGENT,i," "),len(currBrowser) + 1)) eq "#CurrBrowser#/") return currBrowser & " " & listLast(listGetAt(CGI.HTTP_USER_AGENT,i," "),"/");
			}
		}
	}

	// Misc (browser, no version)
	browserList="BrowseX,ELinks,Links,OffByOne,BlackBerry";
	for(b=1; b lte listLen(BrowserList); b=b+1) {
		currBrowser=listGetAt(browserList,b);
		if(findNoCase(currBrowser,CGI.HTTP_USER_AGENT) gt 0) return currBrowser;
	}

	// Mozila (must be done after Firefox, Netscape, and other Mozila clones)
	loc=findNoCase("Gecko",CGI.HTTP_USER_AGENT);
	if(loc GT 0) {
		// Locate revision number in string
		for(i=1;i lte listLen(CGI.HTTP_USER_AGENT," ");i=i+1) {
			if(lCase(left(listGetAt(CGI.HTTP_USER_AGENT,i," "),3)) eq "rv:") return "Mozilla " & val(listLast(ListGetAt(CGI.HTTP_USER_AGENT,i," "),":"));
		}
	}

	// IE (Must be last due to other browsers "spoofing" it.
	loc=listFindNoCase(CGI.HTTP_USER_AGENT,"MSIE"," ");
	if(Loc GT 0) {
		tmp=listGetAt(CGI.HTTP_USER_AGENT,loc + 1," ");
		return "MSIE " & left(tmp,len(tmp) - 1);
	}

	// Unable to detect browser
	return "Unknown";
}
</cfscript>



<!--- capFirstTitle --->
<cfscript>
/**
 * Returns a string with words capitalized for a title.
 * Modified by Ray Camden to include var statements.
 * 
 * @param initText 	 String to be modified. 
 * @return Returns a string. 
 * @author Ed Hodder (ed.hodder@bowne.com) 
 * @version 2, July 27, 2001 
 */
function capFirstTitle(initText){
	
	var Words = "";
	var j = 1; var m = 1;
	var doCap = "";
	var thisWord = "";
	var excludeWords = ArrayNew(1);
	var outputString = "";
	
	initText = LCASE(initText);
	
	//Words to never capitalize
	excludeWords[1] = "an";
	excludeWords[2] = "the";
	excludeWords[3] = "at";
	excludeWords[4] = "by";
	excludeWords[5] = "for";
	excludeWords[6] = "of";
	excludeWords[7] = "in";
	excludeWords[8] = "up";
	excludeWords[9] = "on";
	excludeWords[10] = "to";
	excludeWords[11] = "and";
	excludeWords[12] = "as";
	excludeWords[13] = "but";
	excludeWords[14] = "if";
	excludeWords[15] = "or";
	excludeWords[16] = "nor";
	excludeWords[17] = "a";
	
	//Make each word in text an array variable
		
	Words = ListToArray(initText, " ");
	
	//Check words against exclude list
	for(j=1; j LTE (ArrayLen(Words)); j = j+1){
		doCap = true;
		
		//Word must be less that four characters to be in the list of excluded words
		if(LEN(Words[j]) LT 4 ){
			if(ListFind(ArrayToList(excludeWords,","),Words[j])){
				doCap = false;
			}
		}

		//Capitalize hyphenated words	
		if(ListLen(Words[j],"-") GT 1){
			for(m=2; m LTE ListLen(Words[j], "-"); m=m+1){
				thisWord = ListGetAt(Words[j], m, "-");
				thisWord = UCase(Mid(thisWord,1, 1)) & Mid(thisWord,2, LEN(thisWord)-1);
				Words[j] = ListSetAt(Words[j], m, thisWord, "-");
			}
		}
		
		//Automatically capitalize first and last words
		if(j eq 1 or j eq ArrayLen(Words)){
			doCap = true;
		}
		
		//Capitalize qualifying words
		if(doCap){
			Words[j] = UCase(Mid(Words[j],1, 1)) & Mid(Words[j],2, LEN(Words[j])-1);
		}
	}
	
	outputString = ArrayToList(Words, " ");

	return outputString;

}
</cfscript>


<cfscript>
/**
* An enhanced version of left() that doesn't cut words off in the middle.
* Minor edits by Rob Brooks-Bilson (rbils@amkor.com) and Raymond Camden (rbils@amkor.comray@camdenfamily.com)
*
* Updates for version 2 include fixes where count was very short, and when count+1 was a space. Done by RCamden.
*
* @param str      String to be checked.
* @param count      Number of characters from the left to return.
* @return Returns a string.
* @author Marc Esher (rbils@amkor.comray@camdenfamily.comjonnycattt@aol.com)
* @version 2, April 16, 2002
*/
function fullLeft(str, count) {
    if (not refind("[[:space:]]", str) or (count gte len(str)))
        return Left(str, count);
    else if(reFind("[[:space:]]",mid(str,count+1,1))) {
         return left(str,count);
    } else {
        if(count-refind("[[:space:]]", reverse(mid(str,1,count)))) return Left(str, (count-refind("[[:space:]]", reverse(mid(str,1,count)))));
        else return(left(str,1));
    }
}
</cfscript>



<cfscript>
/**
* Merge two queries.
*
* @param querysource      Source query. (Required)
* @param queryoutput      Destination query. (Required)
* @param keyColumn      Column (that exists in both queries) to merge on. (Required)
* @param mergeList      List of columns from source query to add to destination query. Defaults to all of them. (Optional)
* @return Returns a query.
* @author Alain Blais (Alain_blais@hotmail.com)
* @version 1, July 21, 2004
*/
function querymerge(querysource,queryoutput,keyColumn){
    var mergeColumn = querysource.columnlist;
    var valueArray = arrayNew(1);
    // define counters
    var i = 1;
    var iRow = 1;
    var jRow = 1;
    //if there is a 4th argument, use that as the mergeColumn
    if(arrayLen(arguments) GT 3) mergeColumn = arguments[4];    
    //loop through the merge column
    for(i=1; i lte listLen(mergeColumn,','); i=i+1) {
        if (listFindNoCase(queryoutput.columnlist,listGetAt(mergeColumn,i,','),',') eq 0) {
         // loop through each row of queryoutput and add information from querysource
            found = listGetAt(mergeColumn,i,',');
         for (iRow=1; iRow lte queryoutput.recordcount; iRow=iRow+1) {
             // find the row in querysource that matches the value in keycolumn from queryoutput
                jRow = 1;
                while (jRow lt querysource.recordcount and querysource[keyColumn][jRow] neq queryoutput[keycolumn][iRow]) {
                 jRow = jRow + 1;
                }
                if (querysource[keyColumn][jRow] eq queryoutput[keycolumn][iRow]) {
                 valueArray[iRow] = querysource[listGetAt(mergeColumn,i,',')][jRow];
                }
            }
         // add the columnm
            queryaddcolumn(queryoutput,listGetAt(mergeColumn,i,','),valueArray);
        }
    }
    return queryoutput;
}
</cfscript>



<!--- injectMethod --->
<cffunction name="injectMethod" hint="I inject a method into a CFC." access="public" output="false">
	
	<cfargument name="CFC" hint="I am the cfc to inject the method into. Type: Component" required="Yes" />
	<cfargument name="UDF" hint="I am the Method to inject. Type: Any. Such as someCFC.myFunction, NOT someCFC.myFunction()" required="Yes" />

	<cfset arguments.CFC[getMetaData(arguments.UDF).name] = arguments.UDF />
	
	<cfreturn arguments.CFC />
</cffunction>



<!--- queryTreeSort --->
<cffunction name="queryTreeSort" returntype="query" output="No">
	<cfargument name="Stuff" type="query" required="Yes">
	<cfargument name="ParentID" type="string" required="No" default="ParentID">
	<cfargument name="ItemID" type="string" required="No" default="ItemID">
	<cfargument name="BaseDepth" type="numeric" required="No" default="0">
	<cfargument name="DepthName" type="string" required="No" default="TreeDepth">
	<cfset var RowFromID=StructNew()>
	<cfset var ChildrenFromID=StructNew()>
	<cfset var RootItems=ArrayNew(1)>
	<cfset var Depth=ArrayNew(1)>
	<cfset var ThisID=0>
	<cfset var ThisDepth=0>
	<cfset var RowID=0>
	<cfset var ChildrenIDs="">
	<cfset var ColName="">
	<cfset var Ret=QueryNew(ListAppend(Stuff.ColumnList,Arguments.DepthName))>
	<cfset var i = 0 />
	<!--- Set up all of our indexing --->
	<cfloop query="Stuff">
		<cfset RowFromID[Stuff[Arguments.ItemID][Stuff.CurrentRow]]=CurrentRow>
		<cfif NOT StructKeyExists(ChildrenFromID, Stuff[Arguments.ParentID][Stuff.CurrentRow])>
			<cfset ChildrenFromID[Stuff[Arguments.ParentID][Stuff.CurrentRow]]=ArrayNew(1)>
		</cfif>
		<cfset ArrayAppend(ChildrenFromID[Stuff[Arguments.ParentID][Stuff.CurrentRow]], Stuff[Arguments.ItemID][Stuff.CurrentRow])>
	</cfloop>
	<!--- Find parents without rows --->
	<cfloop query="Stuff">
		<cfif NOT StructKeyExists(RowFromID, Stuff[Arguments.ParentID][Stuff.CurrentRow])>
			<cfset ArrayAppend(RootItems, Stuff[Arguments.ItemID][Stuff.CurrentRow])>
			<cfset ArrayAppend(Depth, Arguments.BaseDepth)>
		</cfif>
	</cfloop>
	<!--- Do the deed --->
	<cfloop condition="ArrayLen(RootItems) GT 0">
		<cfset ThisID=RootItems[1]>
		<cfset ArrayDeleteAt(RootItems, 1)>
		<cfset ThisDepth=Depth[1]>
		<cfset ArrayDeleteAt(Depth, 1)>
		<cfif StructKeyExists(RowFromID, ThisID)>
			<!--- Add this row to the query --->
			<cfset RowID=RowFromID[ThisID]>
			<cfset QueryAddRow(Ret)>
			<cfset QuerySetCell(Ret, Arguments.DepthName, ThisDepth)>
			<cfloop list="#Stuff.ColumnList#" index="ColName">
				<cfset QuerySetCell(Ret, ColName, Stuff[ColName][RowID])>
			</cfloop>
		</cfif>
		<cfif StructKeyExists(ChildrenFromID, ThisID)>
			<!--- Push children into the stack --->
			<cfset ChildrenIDs=ChildrenFromID[ThisID]>
			<cfloop from="#ArrayLen(ChildrenIDs)#" to="1" step="-1" index="i">
				<cfset ArrayPrepend(RootItems, ChildrenIDs[i])>
				<cfset ArrayPrepend(Depth, ThisDepth + 1)>
			</cfloop>
		</cfif>
	</cfloop>
	<cfreturn Ret>
</cffunction>


<!--- querySim --->
<cfscript>
function querySim(queryData) {
	var fieldsDelimiter="|";
	var colnamesDelimiter=",";
	var listOfColumns="";
	var tmpQuery="";
	var numLines="";
	var cellValue="";
	var cellValues="";
	var colName="";
	var lineDelimiter=chr(10) & chr(13);
	var lineNum=0;
	var colPosition=0;

	// the first line is the column list, eg "column1,column2,column3"
	listOfColumns = Trim(ListGetAt(queryData, 1, lineDelimiter));
	
	// create a temporary Query
	tmpQuery = QueryNew(listOfColumns);

	// the number of lines in the queryData
	numLines = ListLen(queryData, lineDelimiter);
	
	// loop though the queryData starting at the second line
	for(lineNum=2;  lineNum LTE numLines;  lineNum = lineNum + 1) {
	    cellValues = ListGetAt(queryData, lineNum, lineDelimiter);

		if (ListLen(cellValues, fieldsDelimiter) IS ListLen(listOfColumns,",")) {
			QueryAddRow(tmpQuery);
			for (colPosition=1; colPosition LTE ListLen(listOfColumns); colPosition = colPosition + 1){
				cellValue = Trim(ListGetAt(cellValues, colPosition, fieldsDelimiter));
				colName   = Trim(ListGetAt(listOfColumns,colPosition));
				QuerySetCell(tmpQuery, colName, cellValue);
			}
		} 
	}
	return( tmpQuery );	
}
</cfscript>

<cfscript>
/**
* Converts a query to a structure of structures with the primary index of the main structure auto incremented.
*
* @param theQuery      The query to transform. (Required)
* @return Returns a struct.
* @author Peter J. Farrell (pjf@maestropublishing.com)
* @version 1, September 23, 2004
*/
function queryToStructOfStructsAutoRow(theQuery){
    var theStructure = StructNew();
    var cols = ListToArray(theQuery.columnlist);
    var row = 1;
    var thisRow = "";
    var col = 1;
    
    for(row = 1; row LTE theQuery.recordcount; row = row + 1){
        thisRow = StructNew();
        for(col = 1; col LTE arraylen(cols); col = col + 1){
            thisRow[cols[col]] = theQuery[cols[col]][row];
        }
        theStructure[row] = Duplicate(thisRow);
    }
    return theStructure;
}
</cfscript>


</cfcomponent>