<cfcomponent displayname="BoxBrowse Component" output="false" hint="This is the complete component package required by BoxBrowse">
	<!-------------------------------------------------------------------------------------------
		
		product:		BoxBrowse
		developer: 	CivBox Software
		www: 				www.civbox.com
		release: 		102
		date: 			28th July 2008
		license:		Apache License, Version 2.0
			
		Copyright 2008 CivBox Software
		
		Licensed under the Apache License, Version 2.0 (the "License");
		you may not use this file except in compliance with the License.
		You may obtain a copy of the License at
		
		http://www.apache.org/licenses/LICENSE-2.0
		
		Unless required by applicable law or agreed to in writing, software
		distributed under the License is distributed on an "AS IS" BASIS,
		WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
		See the License for the specific language governing permissions and
		limitations under the License.
		
	--->
	<!--- Initial Release: 100 (10/May/2007) --->
	<!--- Current Release: 101 (15/Nov/2007) --->
	<cfset THIS.version="1.02">
	<cfset THIS.appFileName=GetFileFromPath(GetTemplatePath())>
	<cfset THIS.formFilterDefaultText="filter">
	<!--- Image file names used by the application --->
	<cfset THIS.img_background="nontango-bg.png">
	<cfset THIS.img_arrowup="nontango-arrow-up.png">
	<cfset THIS.img_arrowdown="nontango-arrow-down.png">
	<cfset THIS.img_arrowright="nontango-arrow-right.png">
	<cfset THIS.img_archive="tango/package-x-generic.png">
	<cfset THIS.img_audio="tango/audio-x-generic.png">
	<cfset THIS.img_cd="tango/media-cdrom.png">
	<cfset THIS.img_document="tango/x-office-document.png">
	<cfset THIS.img_database="tango/x-office-spreadsheet.png">
	<cfset THIS.img_folder="tango/folder.png">
	<cfset THIS.img_font="tango/font-x-generic.png">
	<cfset THIS.img_image="tango/image-x-generic.png">
	<cfset THIS.img_installer="tango/system-installer.png">
	<cfset THIS.img_html="tango/text-html.png">
	<cfset THIS.img_program="tango/application-x-executable.png">
	<cfset THIS.img_script="tango/text-x-script.png">
	<cfset THIS.img_text="tango/text-x-generic.png">
	<cfset THIS.img_video="tango/video-x-generic.png">

	<cffunction name="boxByteCFC" access="package" output="false" returntype="string" hint="Converts a number into a rounded computer unit">
		<cfargument name="value" required="yes" type="numeric" hint="Byte value to be converted">
		<cfargument name="lowestValue" required="no" type="string" default="bytes" hint="Sets the smallest output measurement to be used (kB,MB,GB,TB)">
		<cfargument name="highestValue" required="no" type="string" default="TB" hint="Sets the largest output measurement to be used (kB,MB,GB,TB)">
		<cfargument name="showDecimal" required="no" type="boolean" default="yes" hint="Show a decimal place for values equaling 1 or greater">
		<cfset var result=0>
		<cfset var unit="">
		<cfset var bytes=1>
		<cfset var kB=1024>
		<cfset var MB=1048576>
		<cfset var GB=1073741824>
		<cfset var TB=1099511627776>
		<cfset var decimal="">
		<cfset var integer="">
		<!--- boxByteCFC.cfc 1.0 by civBox Software (http://www.civbox.org) : 14 August 2006 : You are free to do what you wish with this as long as you include this comment file within the code.
		Uses some code from Shawn Seley's CommaFormat UDF (http://www.cflib.org/udf.cfm?ID=710) --->
			<cfset unit="TB">
			<cfif (value LT TB AND lowestValue NEQ "TB") OR highestValue EQ "GB">
				<cfset unit="GB">
			</cfif>
			<cfif (value LT GB AND lowestValue NEQ "GB" AND lowestValue NEQ "TB") OR highestValue EQ "MB">
				<cfset unit="MB">
			</cfif>
			<cfif (value LT MB AND lowestValue NEQ "MB" AND lowestValue NEQ "GB" AND lowestValue NEQ "TB") OR highestValue EQ "kB">
				<cfset unit="kB">
			</cfif>
			<cfif value LT kB AND lowestValue NEQ "kB" AND lowestValue NEQ "MB" AND lowestValue NEQ "GB" AND lowestValue NEQ "TB">
				<cfset unit="bytes">
			</cfif>
			<cfset result=value/Evaluate(unit)>
			<cfif result LT 1 AND showDecimal IS TRUE>
				<cfset result=NumberFormat(result,".99")>
			<cfelseif result LT 1 AND showDecimal IS FALSE>
				<cfset result=NumberFormat(Ceiling(result),"0")>
			<cfelseif result LT 10 AND showDecimal IS TRUE>
				<cfset result=NumberFormat(Round(result*100)/100,"0.00")>
			<cfelseif result LT 10 AND showDecimal IS FALSE>
				<cfset result=NumberFormat(Round(result*100)/100,"0")>
			<cfelseif result LT 100 AND showDecimal IS TRUE>
				<cfset result=NumberFormat(Round(result*10)/10,"90.0")>
			<cfelseif result LT 100 AND showDecimal IS FALSE>
				<cfset result=NumberFormat(Round(result*10)/10,"90")>
			<cfelse>	
				<cfset result=Round(result)>
			</cfif>
			<!--- format the result using comma seperators --->
			<cfset decimal=ListLast(result,".")>
			<cfset integer=ListFirst(result,".")>
			<cfif decimal EQ integer><cfset decimal=0></cfif>
			<cfset integer=REReplace(Reverse(integer), "([0-9][0-9][0-9])", "\1,", "ALL")>
			<cfset integer=REReplace(integer, ",$", "")>
			<cfset integer=REReplace(integer, ",([^0-9]+)", "\1")>
			<cfif decimal EQ 0>
				<cfset result=Reverse(integer)>
			<cfelse>
				<cfset result=Reverse(integer) & '.' & decimal>
			</cfif>
			<cfset returnValue=result & ' ' & unit>
			<cfreturn returnValue>
	</cffunction>
	
	<cffunction name="calcNameWidth" access="package" output="false" returntype="numeric" hint="Automatically calculate the width for the table column 'name' ">
		<cfargument name="showIcons">
		<cfargument name="showSize">
		<cfargument name="showType">
		<cfargument name="showDate">
		<cfargument name="showExtra">
		<cfargument name="colIconWidth">
		<cfargument name="colSizeWidth">
		<cfargument name="colTypeWidth">
		<cfargument name="colDateWidth">
		<cfargument name="colExtrasWidth">
		<cfargument name="tableWidth">
		<cfset var tmp=0>
		<cfif showIcons is true><cfset tmp=tmp+colIconWidth+2></cfif>
		<cfif showSize is true><cfset tmp=tmp+colSizeWidth+1></cfif>
		<cfif showType is true><cfset tmp=tmp+colTypeWidth+1></cfif>
		<cfif showDate is true><cfset tmp=tmp+colDateWidth+1></cfif>
		<cfif showExtra is true><cfset tmp=tmp+colExtrasWidth></cfif>
		<cfreturn (tableWidth-tmp)>
	</cffunction>
	
	<cffunction name="cookiePath" access="package" output="false" returntype="string" hint="Security check to make sure the cookie can not be used if modified with malicious intent">
		<cfargument name="rootpath" type="string" required="yes">
		<cfargument name="cryptionKey" default="">
		<cfargument name="cryptionAlgorithm" default="">
		<cfargument name="hideFolders">
		<cfargument name="showOnlyFolders">
		<cfargument name="id">
		<cfset var showOnlyChk="fail">
		<cfset var cookieCmp="fail">
		<cfset var rootLength=len(rootpath)>
		<cfif not StructKeyExists(cookie,"#id#")>
			<!--- If no cookie exists, create one that defaults to folderRoot --->
			<cfreturn rootpath>
		<cfelse>
			<!--- Decrypt cookie --->
			<cfset deCryptedCookie=Decrypt('#cookie[id]#','#cryptionKey#','#cryptionAlgorithm#')>
			<!--- [anti-hacking] check to make sure cookie path is a valid directory and that folderRoot is the parent (or current) directory --->			
			<cfloop list="#deCryptedCookie#" index="i">
				<cfloop list="#rootpath#" index="i2">
					<cfif left(i,len(i2)) eq i2 and DirectoryExists(i)><cfset cookieCmp="pass"><cfbreak><cfbreak></cfif>
				</cfloop>
			</cfloop>
			<cfif cookieCmp eq "pass">
				<!--- now check that cookie path is not a child of (or currently) a directory contained in the hideFolders attribute --->
				<cfloop list="#hideFolders#" index="i" delimiters=",">		
					<cfif left(deCryptedCookie,len(i)) eq i AND (mid(deCryptedCookie,len(i)+1,1) eq "\" or mid(deCryptedCookie,len(i)+1,1) eq "/" or deCryptedCookie eq i)><cfinvoke method="cookieViolation" id="#id#"></cfif>
				</cfloop>
				<!--- if the showOnlyFolders attribute is used, then check to make sure cookie path IS a child (or currently) a directory contained in showOnlyFolders --->
				<cfloop list="#showOnlyFolders#" index="i">
					<cfloop list="#deCryptedCookie#" index="x">
						<cfif x eq Left(i,Len(x))><cfset showOnlyChk="pass"></cfif>
					</cfloop>
				</cfloop>
				<cfif showOnlyFolders neq "" and showOnlyChk eq "fail">
					<cfinvoke method="cookieViolation" id="#id#">
				<cfelse>
					<cfreturn deCryptedCookie>
				</cfif>
				<!--- everything is okay, so return the directory stored in the cookie --->
				<cfreturn deCryptedCookie>
			<cfelse>
				<!--- invalid cookie --->
				<cfinvoke method="cookieViolation" id="#id#">
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="cookieViolation" access="package" output="false" hint="Generates a cookie error message and halts the application">
		<cfargument name="id" type="string" required="yes">
		<!--- Erases the cookie --->
		<cfcookie name="#id#" value="#Now()#" expires="NOW">
		<!--- If the cookie is removed, restart the application, otherwise display an error message --->
		<cfif not StructKeyExists(cookie,"#id#")>
			<cflocation addtoken="no" url="#CGI.SCRIPT_NAME#">
		<cfelse>
<cfoutput>	<p style="font-weight:bold;">Please refresh your browser window.</p></cfoutput>
			<cfinvoke method="error" title="Cookie corruption detected, application halted" detail="If this error continues, delete the #UCase(cgi.http_host)#.#ID# cookie within your browser and then refresh this page">
			<cfabort>
		</cfif>
	</cffunction>
	
	<cffunction name="createDir1Path" access="package" output="false" returntype="string" hint="Depending on the server's operating system this creates a dir1path variable that is used by <cfdirectory>">
		<cfargument name="directory" type="string" required="no">
		<cfargument name="name" type="string" required="yes">
		<cfif directory eq "">
			<cfreturn "#name#">
		<cfelseif (left(reverse(directory),1) eq "\" and server.os.name contains "Windows") OR (left(reverse(directory),1) eq "/" and server.os.name does not contain "Windows")>
			<cfreturn "#directory##name#">
		<cfelseif server.os.name contains "Windows">
			<cfreturn "#directory#\#name#">
		<cfelseif server.os.name does not contain "Windows">
			<cfreturn "#directory#/#name#">
		</cfif>
	</cffunction>
	
	<cffunction name="directoryFiltering" access="package" output="false" returntype="string" hint="This enforces all the attribute restrictions and rules for both directories and file lists">
		<cfargument name="dir1_name">
		<cfargument name="dir1_directory">
		<cfargument name="dir1_attributes">
		<cfargument name="dir1_type">
		<cfargument name="dir1_size">
		<cfargument name="displayHidden">
		<cfargument name="displayZeroByte">
		<cfargument name="hideFiles">
		<cfargument name="hideFolders">
		<cfargument name="fileSysCase">
		<cfargument name="showOnlyExtensions">
		<cfargument name="showOnlyFiles">
		<cfargument name="showOnlyFolders">
		<cfargument name="hideExtensions">
		<cfset var fullPathCleanUp="">
		<!--- Look for a trailing forward or back slash at the end of the dir1_directory argument
		if it doesn't exist add one and then combine it with the dir1_name argument --->
		<cfif server.os.name contains "Windows">
			<cfset fullPathCleanUp="#dir1_directory##IIF(Right(dir1_directory,1) neq '\',DE('\'),DE(''))##dir1_name#">
		<cfelse>
			<cfset fullPathCleanUp="#dir1_directory##IIF(Right(dir1_directory,1) neq '/',DE('/'),DE(''))##dir1_name#">
		</cfif>
		<!--- Scan for any violation of the rules. If found abort the check and return a 'fail' value, else return a 'pass' value --->
		<cfif 
			(displayHidden eq true or (server.os.name contains "Windows" and dir1_attributes does not contain "H") or (server.os.name does not contain "Windows" and left(dir1_name,1) neq "."))
			and
			(displayZeroByte eq true or (dir1_type eq "File" and dir1_size GT 0) or dir1_type eq "Dir")
			and
			(hideFiles neq ":all" or dir1_type eq "Dir")
			and
			(hideFolders neq ":all" or dir1_type eq "File")
			and
				((fileSysCase eq "loose" and (showOnlyExtensions eq "" or dir1_type eq "Dir" or ListFindNoCase(showOnlyExtensions,reverse(spanExcluding(reverse('#dir1_name#'),'.'))) gt 0))
				or
				(fileSysCase eq "strict" and (showOnlyExtensions eq "" or dir1_type eq "Dir" or ListFind(showOnlyExtensions,reverse(spanExcluding(reverse('#dir1_name#'),'.'))) gt 0)))
			and
				((fileSysCase eq "loose" and (showOnlyFiles eq "" or dir1_type eq "Dir" or ListFindNoCase(showOnlyFiles,dir1_name) gt 0))
				or
				(fileSysCase eq "strict" and (showOnlyFiles eq "" or dir1_type eq "Dir" or ListFind(showOnlyFiles,dir1_name) gt 0)))
			and
				((fileSysCase eq "loose" and (showOnlyFolders eq "" or dir1_type eq "File" or ListFindNoCase(showOnlyFolders,fullPathCleanUp) gt 0))
				or
				(fileSysCase eq "strict" and (showOnlyFolders eq "" or dir1_type eq "File" or ListFind(showOnlyFolders,fullPathCleanUp) gt 0)))
			and
				((fileSysCase eq "loose" and (hideExtensions eq "" or dir1_type eq "Dir" or ListFindNoCase(hideExtensions,reverse(spanExcluding(reverse('#dir1_name#'),'.'))) eq 0))
				or
				(fileSysCase eq "strict" and (hideExtensions eq "" or dir1_type eq "Dir" or ListFind(hideExtensions,reverse(spanExcluding(reverse('#dir1_name#'),'.'))) eq 0)))
			and
				((fileSysCase eq "loose" and (hideFiles eq "" or dir1_type eq "Dir" or ListFindNoCase(hideFiles,dir1_name) eq 0))
				or
				(fileSysCase eq "strict" and (hideFiles eq "" or dir1_type eq "Dir" or ListFind(hideFiles,dir1_name) eq 0)))
			and
				((fileSysCase eq "loose" and (hideFolders eq "" or dir1_type eq "File" or ListFindNoCase(hideFolders,fullPathCleanUp) eq 0))
				or
				(fileSysCase eq "strict" and (hideFolders eq "" or dir1_type eq "File" or ListFind(hideFolders,fullPathCleanUp) eq 0)))>
			<cfreturn "pass">
		<cfelse>
			<cfreturn "fail">
		</cfif>		
	</cffunction>
	
	<cffunction name="directoryFormat" access="package" output="false" returntype="string" hint="Cleans up the structure of a supplied directory, this stops badly formatted directories generating application errors">
		<cfargument name="dir" required="yes" type="string" hint="Directory">
		<cfargument name="mode" default="absolute" type="string" hint="Directory type [absolute,relative]">
		<cfset var dirFmt="">
		<cfset var dirUNC=false>
		<cfswitch expression="#mode#">
			<cfcase value="absolute">
				<cfloop list="#dir#" index="i">
					<cfset dirUNC=false>
					<cfif server.os.name contains "Windows">
						<cfif left(i,2) eq "\\"><cfset dirUNC=true></cfif>
						<cfset dirFmt=ReplaceNoCase(i,"/","\","all")>
						<cfset dirFmt=ReplaceNoCase(dirFmt,"\\","\","all")>
						<cfif Right(dirFmt,1) eq "\" and Len(dirFmt) gt 1><cfset dirFmt=Left(dirFmt,Len(dirFmt)-1)></cfif>
						<cfif dirUNC is true><cfset dirFmt="\#dirFmt#"></cfif>
						<cfset dir=ListSetAt(dir,ListFind(dir,i),dirFmt)>
					<cfelse>
						<cfif left(i,6) eq "smb://"><cfset dirUNC=true></cfif>
						<cfset dirFmt=ReplaceNoCase(i,"\","/","all")>
						<cfset dirFmt=ReplaceNoCase(dirFmt,"//","/","all")>
						<cfif Right(dirFmt,1) eq "/" and Len(dirFmt) gt 1><cfset dirFmt=Left(dirFmt,Len(dirFmt)-1)></cfif>
						<cfif dirUNC is true><cfset dirFmt="#ReplaceNoCase(dirFmt,'smb:/','smb://','one')#"></cfif>
						<cfset dir=ListSetAt(dir,ListFind(dir,i),dirFmt)>
					</cfif>
				</cfloop>
			</cfcase>
			<cfcase value="relative">
				<cfset dirFrm=ReplaceNoCase(dir,"\","/","all")>
				<cfloop condition="Left(dirFrm,1) eq '/'">
					<cfset dirFrm=Reverse(Left(Reverse(dirFrm),Len(dirFrm)-1))>
				</cfloop>
				<cfif Right(dirFrm,1) neq "/"><cfset dirFrm="#dirFrm#/"></cfif>
				<cfset dir=dirFrm>
			</cfcase>
		</cfswitch>
		<cfreturn dir>
	</cffunction>
		
	<cffunction name="directoryQoQ" access="package" output="false" returntype="query" hint="Generates a custom query or queries directory list">
		<cfargument name="directorySort">
		<cfargument name="urlvarID">
		<cfargument name="urlvarRefreshID">
		<cfargument name="urlvarsort">
		<cfargument name="urlvar_sort">
		<cfargument name="dir1Path">
		<cfargument name="urlvarDownload">
		<cfargument name="fileDownloads">
		<cfargument name="fileRemoteLinkage">
		<cfargument name="displayHidden">
		<cfargument name="displayZeroByte">
		<cfargument name="hideFiles">
		<cfargument name="hideFolders">
		<cfargument name="fileSysCase">
		<cfargument name="showOnlyExtensions">
		<cfargument name="showOnlyFiles">
		<cfargument name="showOnlyFolders">
		<cfargument name="hideExtensions">
		<cfargument name="showDate">
		<cfargument name="showExtra">
		<cfset var loopCnt=0>
		<cfset var dirQoQ="">
		<cfset var tmp="">
		<!--- If dir1path contains more then one directory, obtain those directory lists and combine them (UNION) together --->
		<cfif ListLen(dir1path) gt 1>
			<cfloop list="#dir1path#" index="i">
				<cfset loopCnt=IncrementValue(loopCnt)>
				<cfdirectory action="list" directory="#i#" name="dirList#loopCnt#" sort="type ASC, #directorySort#">
			</cfloop>
			<cfquery dbtype="query" name="dirList">
				<cfloop index="i" from="1" to="#loopCnt#">
					SELECT * FROM dirList#i#
					<cfif i neq loopCnt>UNION</cfif>
				</cfloop>
				ORDER BY type ASC
			</cfquery>
		<cfelse>
		<!--- Else if dir1path is just a single directory, obtain that --->
			<cfdirectory action="list" directory="#dir1path#" name="dirList" sort="type ASC, #directorySort#">
		</cfif>		
		<cfset loopCnt=0>
		<!--- Create a new query or queries --->
		<cfset dirQoQ=QueryNew("orderName,name,directory,size,type,dateLastModified,dLMDay,dLMMonth,dLMYear,dLMHour,dLMMinute,attributes,extension","VarChar,VarChar,VarChar,BigInt,VarChar,Date,Integer,Integer,Integer,Integer,Integer,VarChar,VarChar")>
		<!--- Loop through the previous dirList query and add it's information to dirQoQ --->
		<cfloop query="dirList">
			<!--- scan each item to make sure it is allowed --->
			<cfinvoke method="directoryFiltering" returnvariable="dirItemCheck" 
				displayHidden="#displayHidden#" hideFiles="#hideFiles#" hideFolders="#hideFolders#" fileSysCase="#fileSysCase#"
				showOnlyExtensions="#showOnlyExtensions#" showOnlyFiles="#showOnlyFiles#" showOnlyFolders="#showOnlyFolders#"
				displayZeroByte="#displayZeroByte#"	hideExtensions="#hideExtensions#" dir1_name="#name#" dir1_attributes="#attributes#"
				dir1_type="#type#" dir1_size="#size#" dir1_directory="#directory#">
			<cfif dirItemCheck eq "pass">
				<cfset loopCnt=IncrementValue(loopCnt)>
				<cfif dirList.type neq "Dir">
					<cfinvoke method="itemType" returnvariable="extension" item="#reverse(spanExcluding(reverse('#dirList.name#'),'.'))#" mode="ext">
				<cfelseif dirList.type eq "Dir">
					<cfinvoke method="itemType" returnvariable="extension" item="dir" mode="ext"> 
				</cfif>
				<cfset tmp=QueryAddRow(dirQoQ,1)>
				<cfif directorySort contains "orderName"><cfset tmp=QuerySetCell(dirQoQ, "orderName", " #LCase(name)#", loopCnt)></cfif>
				<cfset tmp=QuerySetCell(dirQoQ, "name", " #name#", loopCnt)>
				<cfset tmp=QuerySetCell(dirQoQ, "directory", "#directory#", loopCnt)>
				<cfset tmp=QuerySetCell(dirQoQ, "size", "#size#", loopCnt)>
				<cfset tmp=QuerySetCell(dirQoQ, "type", "#LCase(type)#", loopCnt)>
				<cfif showDate is true>
					<cfset tmp=QuerySetCell(dirQoQ, "dateLastModified", "#dateLastModified#", loopCnt)>
					<cfset tmp=QuerySetCell(dirQoQ, "dLMDay", "#LSDateFormat(dateLastModified,'dd')#", loopCnt)>
					<cfset tmp=QuerySetCell(dirQoQ, "dLMMonth", "#LSDateFormat(dateLastModified,'mm')#", loopCnt)>
					<cfset tmp=QuerySetCell(dirQoQ, "dLMYear", "#LSDateFormat(dateLastModified,'yyyy')#", loopCnt)>
					<cfset tmp=QuerySetCell(dirQoQ, "dLMHour", "#TimeFormat(dateLastModified,'hh')#", loopCnt)>
					<cfset tmp=QuerySetCell(dirQoQ, "dLMMinute", "#TimeFormat(dateLastModified,'mm')#", loopCnt)>
				</cfif>
				<cfset tmp=QuerySetCell(dirQoQ, "attributes", "#attributes#", loopCnt)>
				<cfset tmp=QuerySetCell(dirQoQ, "extension", "#LCase(extension)#", loopCnt)>
			</cfif>
		</cfloop>
		<!--- Reorder the new custom query and return it content --->
		<cfquery dbtype="query" name="dirQoQ">
			SELECT * FROM dirQoQ ORDER BY type ASC, #directorySort#
		</cfquery>
		<cfreturn dirQoQ>
	</cffunction>
	
	<cffunction name="directoryCrumbs" access="package" output="true" returntype="string" hint="Breadcrumb directory navigation">
		<cfargument name="dir1Path" type="string" hint="The directory path">
		<cfargument name="rootpath" type="string" hint="The application root paths">
		<cfargument name="crumbID" type="numeric" hint="(URL) variable ID">
		<cfargument name="debug" type="string" hint="Debug verbose mode">
		<cfset var tmp="">
		<cfset var tmpPath="">
		<cfset var delimiter="#IIF(server.os.name contains 'Windows',DE('\'),DE('/'))#">
		<cfset var absCrumb=Abs(crumbID)>
		<cfset var rootLen="">
		<cfset var pathLen="">
		<cfset var UNCrootpath="">
		<!--- Find the length of the current root directory --->
		<cfinvoke method="debug" status="#debug#" mode="crumbID: Scanning through rootpath">
		<cfloop list="#rootpath#" index="i" delimiters=",">
			<cfif Left(dir1Path,Len(i)) eq i>
				<cfinvoke method="debug" status="#debug#" mode="#i# - Found!"><cfset tmpPath=i><cfbreak>
			</cfif>
		</cfloop>
		<cfset rootLen=ListLen(tmpPath,"#delimiter#")>
		<!--- Add a leading delimiter and filler for Linux servers --->
		<!--- *df* is used as a dummy delimiter filler, and the illegal * character makes sure that the dummy filler does not conflict with an actual directory --->
		<cfif server.os.name does not contain 'Windows' and Left(dir1Path,1) neq delimiter>
			<cfset dir1Path="*df*/#dir1Path#">
		<cfelseif server.os.name does not contain 'Windows' and Left(dir1Path,1) eq delimiter>
			<cfset dir1Path="*df*#dir1Path#">
		</cfif>
		<cfset pathLen=ListLen(dir1Path,"#delimiter#")>
		<!--- Make sure the url 'crumbID' value is with in usable range --->
		<cfif absCrumb gt pathLen><cfset absCrumb=1></cfif>
		<!--- Debug verbose --->
		<cfinvoke method="debug" status="#debug#" mode="absCrumb: #absCrumb# rootLen: #rootLen# pathLen: #pathLen# gotoListItem: #ListFindNoCase(dir1Path,Reverse(ListGetAt(Reverse(dir1Path),absCrumb,'#delimiter#')),'#delimiter#')#">
		<cfinvoke method="debug" status="#debug#" mode="crumbD: Creating new dir path variable (#ListFindNoCase(dir1Path,Reverse(ListGetAt(Reverse(dir1Path),absCrumb,'#delimiter#')),'#delimiter#')#)">
		<!--- Create a variable containing the new directory path --->
		<cfloop from="1" to="#ListFindNoCase(dir1Path,Reverse(ListGetAt(Reverse(dir1Path),absCrumb,'#delimiter#')),'#delimiter#')#" index="i">
			<cfset tmp="#tmp##ListGetAt(dir1Path,i,'#delimiter#')##IIF(server.os.name contains 'Windows',DE('\'),DE('/'))#">
			<cfinvoke method="debug" status="#debug#" mode="&gt; #tmp#">
		</cfloop>
		<cfinvoke method="debug" status="#debug#" layout="margin-bottom:10px;" mode="">
		<!--- If needed remove the trailing delimiter from the new [tmp] dir path --->
		<cfif Left(tmp,4) eq "*df*">
			<cfset tmp=Reverse(Left(Reverse(tmp),Len(tmp)-4))>
		</cfif>
		<cfif Right(tmp,1) eq delimiter and Len(tmp) gt 1>
			<cfset tmp=Left(tmp,Len(tmp)-1)>
		</cfif>
		<cfif Left(tmp,Len(tmpPath)) eq tmpPath and ListLen(rootpath) eq 1>
			<!--- If rootpath is a single directory return the tmp dir path --->
			<cfreturn tmp>
		<cfelse>
			<!--- Else if rootpath contains multiple directories, discover which one is the correct one to use --->
			<cfif Left(rootpath,2) eq '//' or Left(rootpath,2) eq '\\'>
			<!--- UNC directory paths --->
				<cfset UNCrootpath=Reverse(Left(Reverse(rootpath),Len(rootpath)-2))>
				<cfloop list="#UNCrootpath#" index="i">
					<cfif Left(tmp,Len(i)) eq i and tmp neq i and Left(rootpath,2) eq '//'>
						<cfreturn "//#tmp#">
					<cfelseif Left(tmp,Len(i)) eq i and tmp neq i and Left(rootpath,2) eq '\\'>
						<cfreturn "\\#tmp#">
					</cfif>
				</cfloop>
			<cfelse>
			<!--- Standard (non-UNC) directory paths --->
				<cfloop list="#rootpath#" index="i">
					<cfif Left(tmp,Len(i)) eq i and tmp neq i>
						<cfreturn tmp>
					</cfif>
				</cfloop>
			</cfif>		
			<!--- If the tmp directory can not be matched with a rootpath sub-folder, then default to rootpath as a security measure --->
			<cfinvoke method="debug" status="#debug#" mode="Error, tmp directory and rootpath do not match<br />Returning to rootpath as a security caution"><cfreturn rootpath>
		</cfif>
	</cffunction>
	
	<cffunction name="directorySort" access="package" output="false" returntype="string" hint="Converts or creates a numeric value used for sorting the folder items">
		<cfargument name="mode" type="string" default="toUrl" hint="Either 'toUrl' or 'fromUrl'">
		<cfargument name="item" type="string" required="yes">
		<cfargument name="urlvar_sort" type="string" required="yes">
		<cfif mode eq 'toUrl'>
			<cfswitch expression="#item#">
				<cfcase value="orderName asc"><cfreturn "0"></cfcase>
				<cfcase value="orderName desc"><cfreturn "1"></cfcase>
				<cfcase value="size asc"><cfreturn "2"></cfcase>
				<cfcase value="size desc"><cfreturn "3"></cfcase>
				<cfcase value="type asc"><cfreturn "4"></cfcase>
				<cfcase value="type desc"><cfreturn "5"></cfcase>
				<cfcase value="date asc"><cfreturn "6"></cfcase>
				<cfcase value="date desc"><cfreturn "7"></cfcase>
				<cfcase value="extra asc"><cfreturn "8"></cfcase>
				<cfcase value="extra desc"><cfreturn "9"></cfcase>
				<cfdefaultcase><cfreturn "0"></cfdefaultcase>
			</cfswitch>
		<cfelseif mode eq 'fromUrl'>
			<cfswitch expression="#item#">
				<cfcase value="0"><cfreturn "orderName asc"><cfset "#de("urlvar_sort")#"="0"></cfcase>
				<cfcase value="1"><cfreturn "orderName desc"></cfcase>
				<cfcase value="2"><cfreturn "size asc"></cfcase>
				<cfcase value="3"><cfreturn "size desc"></cfcase>
				<cfcase value="4"><cfreturn "extension asc"></cfcase>
				<cfcase value="5"><cfreturn "extension desc"></cfcase>
				<cfcase value="6"><cfreturn "dLMYear asc,dLMMonth asc,dLMDay asc,dLMHour asc,dLMMinute asc"></cfcase>
				<cfcase value="7"><cfreturn "dLMYear desc,dLMMonth desc,dLMDay desc,dLMHour desc,dLMMinute desc"></cfcase>
				<cfcase value="8"><cfreturn "attributes asc"></cfcase>
				<cfcase value="9"><cfreturn "attributes desc"></cfcase>
				<cfdefaultcase><cfreturn "name asc"></cfdefaultcase>
			</cfswitch>
		</cfif>
	</cffunction>
	
	<cffunction name="displayPath" access="package" output="false" returntype="string" hint="Creates a custom name for the breadcrumb navigation root path link">
		<cfargument name="path" type="string" required="yes">
		<cfargument name="root" type="string" required="yes">
		<cfargument name="replacement" type="string" required="yes">
		<cfloop list="#root#" index="i">
			<cfif path eq root>
				<cfreturn "#replacement##Iif(server.os.name contains 'Windows',DE('\'),DE('/'))#">
			<cfelseif Left(path,Len(i)) eq i and (Mid(path,(Len(i)+1),1) eq "\" or Mid(path,(Len(i)+1),1) eq "/")>
				<cfreturn "#ReplaceNoCase(path,i,'#replacement#','one')#">
			<cfelseif ListLen(root) eq 1 and Left(ReplaceNoCase(path,root,'','one'),1) neq "\" and server.os.name contains "Windows">
				<cfreturn "#ReplaceNoCase(path,root,'#replacement#\','one')#">
			<cfelseif ListLen(root) eq 1 and Left(ReplaceNoCase(path,root,'','one'),1) neq "/" and server.os.name does not contain "Windows">
				<cfreturn "#ReplaceNoCase(path,root,'#replacement#/','one')#">
			<cfelseif ListLen(root) eq 1>
				<cfreturn "#ReplaceNoCase(path,root,replacement,'one')#">
			</cfif>
		</cfloop>
		<cfreturn "#replacement##Iif(server.os.name contains 'Windows',DE('\'),DE('/'))#">
	</cffunction>

	<cffunction name="error" access="package" output="false" returntype="string" hint="Displays error messages to the application users">
		<cfargument name="title" default="">
		<cfargument name="detail" required="yes">
		<!--- This can be replaced with a CFThrow if needed --->
<cfoutput>	<div class="bbError">Error: #title#<br />#detail#</div></cfoutput>
		<cfabort>
	</cffunction>

	<cffunction name="getFullURL" access="package" output="false" returntype="string" hint="Obtains the current URL using server cgi variables">
		<cfargument name="nopath" type="boolean" default="no">
		<cfset var url="http">
		<cfset var page="#THIS.appFileName#">
		<!--- Check for secure sockets or secure transport layer --->
		<cfif cgi.https eq "on"><cfset url="https"></cfif>
		<cfset url="#url#://#cgi.server_name#">
		<!--- Check for a non-standard port --->
		<cfif cgi.server_port neq 80><cfset url="#url#:#cgi.server_port#"></cfif>
		<cfif nopath eq true>
			<cfreturn url>
		<cfelseif cgi.path_info neq "">
			<!--- Microsoft IIS friendly cgi.path_info cgi variable--->
			<cfset url="#url##cgi.path_info#">
			<cfif Len(cgi.query_string) gt 0><cfset url="#url#?#cgi.query_string#"></cfif>
			<cfreturn url>
		<cfelseif cgi.script_name neq "">
			<!--- Apache friendly cgi.query_string cgi variable --->
			<cfset url="#url##cgi.script_name#">
			<cfif Len(cgi.query_string) gt 0><cfset url="#url#?#cgi.query_string#"></cfif>
			<cfreturn url>
		<cfelse>
			<cfinvoke method="error" title="Server CGI Variable Error" detail="This application requires a valid server response from either the cgi.script_name or cgi.path_info variables">
		</cfif>
	</cffunction>
	
	<cffunction name="initialization" access="package" output="false" returntype="struct" hint="Initialize application variables">
		<cfargument name="folderRoot">
		<cfargument name="docType">
		<cfset var iniStr=StructNew()>
		<cfset var loopcnt=0>
		<!--- Setup folder path variables --->
		<cfif folderRoot neq "">
			<cfset iniStr.rootpath=folderRoot>
		</cfif>
		<cfset iniStr.folderroot="">
		<!--- Clean up the folder root from any error generating typos and set the file system structure (Linux case sensitive or Windows indifferent) --->
		<cfloop list="#folderRoot#" index="i">
			<cfset loopCnt=IncrementValue(loopCnt)>
			<cfif server.os.name contains "Windows">
				<cfset iniStr.fileSysCase="loose">
			<cfelse>
				<cfset iniStr.fileSysCase="strict">
			</cfif>
			<!--- Create the rootpath variable after the directory name has been checked for form --->
			<cfif i neq "">
				<cfset iniStr.folderroot="#Iif(loopCnt gt 1,DE('#iniStr.folderroot#,'),DE(''))##i#">
				<cfif (server.os.name does not contain "Windows" and DirectoryExists(i)) or (server.os.name contains "Windows" and i neq "\" and DirectoryExists(i))>
					<cfset iniStr.rootpath="#Iif(loopCnt gt 1,DE('#iniStr.rootpath#,'),DE(''))##i#">
				<cfelseif DirectoryExists(i) is false>
					<cfset iniStr.rootpath=i>
					<cfbreak>
				<cfelse>
					<cfset iniStr.rootpath="#Iif(loopCnt gt 1,DE('#iniStr.rootpath#,'),DE(''))##ExpandPath(iniStr.folderRoot)#">
				</cfif>
			</cfif>
		</cfloop>
		<!--- Default document type incase supplied value is invalid --->
		<cfswitch expression="#doctype#">
			<cfcase value="none,html4loose,html4strict,xhtml1loose,xhtml1strict,xhtml11"><cfset iniStr.doctype=doctype></cfcase>
			<cfdefaultcase><cfset iniStr.doctype eq "xhtml11"></cfdefaultcase>
		</cfswitch>
		<cfreturn iniStr>
	</cffunction>

	<cffunction name="link2file" access="package" output="false" returntype="string" hint="Sends the request file as a web download">
		<cfargument name="dir1path" default="">
		<cfargument name="dir1name" default="">
		<cfargument name="filesize" default="0">
		<cfargument name="urlvarDownload" default="">
		<cfif dir1name eq "box-Browse.cfm" or dir1name eq "box-Browse.cfc">
			<cfinvoke method="error" title="Blocked Download" detail="This file is not permitted for download">
		</cfif>
		<cfif IsNumeric(urlvarDownload) is true>
			<!--- Extract the file mime type from the web server --->
			<cfset serverMimeExtract=getPageContext().getServletContext().getMimeType('#dir1path##Iif(server.os.name contains "Windows",DE("\"),DE("/"))##dir1name#')>
			<!--- If no mime type exists on the web server then create one using the itemType function --->
			<cfif not IsDefined("serverMimeExtract") or serverMimeExtract eq "">
				<cfinvoke method="itemType" returnvariable="serverMimeExtract" item="#reverse(spanExcluding(reverse('#dir1name#'),'.'))#" mode="mime">
			</cfif>
			<!--- Sends the file to the end-user without the file source location being traceable --->
			<cfheader name="content-disposition" value="attachment;filename=#dir1name#">
			<cfheader name="content-length" value="#filesize#">
			<cfcontent type="#serverMimeExtract#" file="#dir1path##Iif(server.os.name contains 'Windows',DE('\'),DE('/'))##dir1name#">
		</cfif>
	</cffunction>
	
	<cffunction name="link4file" access="package" output="false" returntype="string" hint="Creates both directory and file links">
		<!--- [updated 1.01] localised variables, fixed <a href> XHTML validation problems --->
		<cfargument name="dir1directory" default="">
		<cfargument name="dir1name" default="">
		<cfargument name="dir1type" default="">
		<cfargument name="loopCnt" default="">
		<cfargument name="refreshID" default="">
		<cfargument name="currentPage" default="">
		<cfargument name="fileDownloads" default="">
		<cfargument name="urlvarDownload" default="">
		<cfargument name="urlvar_id" required="yes">
		<cfargument name="urlvar_refreshID" required="yes">
		<cfargument name="urlvar_sort" required="yes">
		<cfargument name="urlvar_download" required="yes">
		<cfargument name="urlvarsort" required="yes">
		<cfargument name="id" required="yes">
		<cfargument name="anchor" required="yes">
		<cfset var dir1Path = "">
		<cfset var fullURL = "">
		<cfset var returnValue = "">
		<cfset var urlCheck = "">
		<cfset var urlString = "">
		<cfif dir1type eq "Dir">
			<!--- Folder name with link --->
			<cfinvoke method="createDir1Path" returnvariable="dir1Path" directory="#dir1directory#" name="#dir1name#">
			<cfinvoke method="queryStr" returnvariable="urlString" mode="link" refreshID="#refreshID#" urlvarSort="#urlvarSort#" urlvar_Sort="#urlvar_Sort#" urlvar_id="#urlvar_id#" urlvar_RefreshID="#urlvar_RefreshID#" id="#id#" anchor="#anchor#" loopCnt="#loopCnt#">
			<cfset returnValue = "<a href='#urlString#'>#dir1name#</a><br />">
		<cfelseif dir1type eq "File" and fileDownloads is true and (cgi.path_info neq "" or cgi.script_name neq "")>
			<!--- File name with link --->
			<cfinvoke method="getFullURL" returnvariable="fullURL" nopath="no">
			<!--- check to see if url string exists --->
			<cfset urlCheck=ListFindNoCase('#fullURL#','#urlvar_id#=#evaluate(url[urlvar_id])#',"&")>
			<cfif urlCheck gt 0>
				<cfset returnValue = "<a href='#fullURL#&amp;#urlvar_download#=#loopCnt#'>#dir1name#</a><br />">
			<cfelse>
				<cfinvoke method="refreshID" returnvariable="refreshID" mode="generate">
				<cfinvoke method="queryStr" returnvariable="urlString" mode="link" refreshID="#refreshID#" urlvarSort="#urlvarSort#" urlvar_Sort="#urlvar_Sort#" urlvar_id="#urlvar_id#" urlvar_RefreshID="#urlvar_RefreshID#" urlvar_download="#urlvar_download#" id="#id#" anchor="#anchor#" loopCnt="#loopCnt#">
				<cfset returnValue = "<a href='#urlString#'>#dir1name#</a><br />">
			</cfif>
		<cfelse>
			<!--- File name (no link because either the downloads can not be linked due to server limitations or downloading has been turned off) --->
			<cfset returnValue = "#dir1name#">
		</cfif>
		<!--- Repair href so they are XHTML/HTML valid --->
		<cfset tmp = ReReplaceNoCase(returnValue,'(\&)([^amp;].*?)','&amp;\2','all')>
		<cfset returnValue = ReplaceNoCase(returnValue,'?&amp;','?','all')>
		<cfreturn tmp>
	</cffunction>
	
	<cffunction name="queryStr" access="package" output="false" returntype="string" hint="Dynamically generates links used for directory navigation">
		<cfargument name="urlvar_id">
		<cfargument name="urlvar_idsign" default="">
		<cfargument name="urlvar_RefreshID">
		<cfargument name="urlvar_Sort">
		<cfargument name="urlvar_download">
		<cfargument name="urlvarSort">
		<cfargument name="refreshID">
		<cfargument name="loopCnt">
		<cfargument name="id">
		<cfargument name="anchor">
		<cfargument name="mode" default="crumb">
		<cfset var tmp="#CGI.QUERY_STRING#">
		<cfset var query="">
		<cfset var LF1="">
		<cfset var LF2="">
		<cfset var LF3="">
		<!--- Find the number of url variables --->
		<cfset urlCnt=ListLen(StructKeyList(url,'&'),"&")>       
		<!--- Generate a link for multiple instances  --->
        <cfset LF1=ListFindNoCase('#tmp#','#urlvar_id#=#evaluate(url[urlvar_id])#',"&")>
        <cfset LF2=ListFindNoCase('#tmp#','#urlvar_RefreshID#=#evaluate(url[urlvar_RefreshID])#',"&")>
        <cfset LF3=ListFindNoCase('#tmp#','#urlvar_Sort#=#evaluate(url[urlvar_Sort])#',"&")>
        <cfif LF1 gt 0><cfset tmp=ListSetAt('#tmp#',LF1,'#urlvar_id#=#urlvar_idsign##loopCnt#','&')><cfelse><cfset tmp="#tmp#&amp;#urlvar_id#=#urlvar_idsign##loopCnt#"></cfif>
        <cfif LF2 gt 0><cfset tmp=ListSetAt('#tmp#',LF2,'#urlvar_RefreshID#=#refreshID#','&')><cfelse><cfset tmp="#tmp#&amp;#urlvar_RefreshID#=#refreshID#"></cfif>
        <cfif LF3 gt 0><cfset tmp=ListSetAt('#tmp#',LF3,'#urlvar_Sort#=#urlvarSort#','&')><cfelse><cfset tmp="#tmp#&amp;#urlvar_Sort#=#urlvarSort#"></cfif>
        <cfif tmp neq "#CGI.QUERY_STRING#">
            <cfset tmp="#THIS.appFileName#?#tmp#">
        <cfelse>
            <cfif cgi.query_string neq "" and FindNoCase("#urlvar_id#=","#cgi.query_string#") eq 0>
                <cfset query="?#cgi.query_string#&amp;">
            <cfelseif cgi.query_string neq "" and FindNoCase("#urlvar_id#=","#cgi.query_string#") gt 0>
                <cfset query="?#cgi.query_string#">
            <cfelse>
                <cfset query="?">
            </cfif>
            <cfif FindNoCase("#urlvar_id#=","#query#") GT 0>
                <!--- Updates the url variables, if they already exist --->
                <cfset tmp="#THIS.appFileName##query#">
                <cfset tmp="#ListSetAt(tmp, ListContainsNoCase(query,'#urlvar_id#=','&'),'#urlvar_id#=#urlvar_idsign##loopCnt#','&')#">
                <cfset tmp="#ListSetAt(tmp, ListContainsNoCase(query,'#urlvar_RefreshID#=','&'),'#urlvar_RefreshID#=#refreshID#','&')#">
                <cfset tmp="#ListSetAt(tmp, ListContainsNoCase(query,'#urlvar_Sort#=','&'),'#urlvar_Sort#=#urlvarSort#','&')#">
            <cfelse>
                <!--- Attaches the url variables to the existing url query string --->
                <cfset tmp="#THIS.appFileName##query##urlvar_id#=#urlvar_idsign##loopCnt#&amp;#urlvar_RefreshID#=#refreshID#&amp;#urlvar_Sort#=#urlvarSort#">
            </cfif>
        </cfif>
		<!--- If link is a file, attach the download id --->
		<cfif mode eq "link" and IsDefined("urlvar_download") and urlvar_download neq "">
			<cfset tmp="#ListSetAt(tmp, ListContainsNoCase(tmp,'#urlvar_id#=','&'),'#urlvar_id#=#urlvar_idsign#-1','&')#">
			<cfset tmp="#ListSetAt(tmp, ListContainsNoCase(tmp,'#urlvar_RefreshID#=','&'),'#urlvar_RefreshID#=x#refreshID#','&')#">
			<cfset tmp="#tmp#&amp;#urlvar_download#=#loopCnt#">
		</cfif>
		<!--- Attaches an anchor (<a></a>) to the end of the url link --->
		<cfif (id neq "" and anchor is true and mode eq "crumb") or (id neq "" and anchor is true and mode eq "link" and (not IsDefined("urlvar_download") or urlvar_download eq ""))><cfset tmp="#tmp###bb_#id#"></cfif>
		<cfreturn tmp>
	</cffunction>
	
	<cffunction name="refreshID" access="package" output="false" returntype="string" hint="Generates a random numeric value">
		<cfargument name="mode" type="string" required="yes">
		<cfif mode eq "generate">
			<cfreturn "#randRange(10000000,99999999)#">
		</cfif>
	</cffunction>
	
	<cffunction name="remoteLinkageCheck" access="package" output="false" returntype="string" hint="Checks for remote linkage of files before download">
		<cfset var compareLen="">
		<cfinvoke method="getFullURL" returnvariable="rlcServer" nopath="yes">
		<cfset compareLen=Len(rlcServer)>
		<cfif Left(cgi.referer,compareLen) NEQ rlcServer>
			<cfinvoke method="error" title="Blocked Download" detail="This site does not allow the external linking of it's hosted files">
		</cfif>
	</cffunction>
	
	<cffunction name="urlStringVal" access="package" output="false" hint="Creates missing url string structures">
		<cfargument name="urlvar_id">
		<cfargument name="urlvar_refreshid">
		<cfargument name="urlvar_sort">
		<cfargument name="refreshid">
		<cfargument name="force" type="boolean" default="false">
		<cfset var tmp="">
		<cfif (structKeyExists(url,'#urlvar_id#') eq false and not IsDefined("form.filter")) or force is true>
			<cfset tmp=StructInsert(url,'#urlvar_id#','0','yes')>
			<cfset tmp=StructInsert(url,'#urlvar_refreshid#','#refreshID#','yes')>
			<cfset tmp=StructInsert(url,'#urlvar_sort#','#url[urlvar_sort]#','yes')>
			<cfset urlvar_refreshid=refreshID>
			<cfset urlvar_sort=url[urlvar_sort]>
		</cfif>
	</cffunction>
	
	<cffunction name="urlVarProcessing" access="package" output="true" hint="Processes the application URL variables">
		<cfargument name="urlvarID">
		<cfargument name="urlvarRefreshID">
		<cfargument name="urlvarsort">
		<cfargument name="urlvar_sort">
		<cfargument name="dir1Path">
		<cfargument name="urlvarDownload">
		<cfargument name="fileDownloads">
		<cfargument name="fileRemoteLinkage">
		<cfargument name="displayHidden">
		<cfargument name="displayZeroByte">
		<cfargument name="hideFiles">
		<cfargument name="hideFolders">
		<cfargument name="fileSysCase">
		<cfargument name="showOnlyExtensions">
		<cfargument name="showOnlyFiles">
		<cfargument name="showOnlyFolders">
		<cfargument name="hideExtensions">
		<cfargument name="id">
		<cfargument name="debug">
		<cfset var loopCnt=0>
		<cfset var dirQoQ="">
		<cfset var tmp="">
		<cfset var dirQuery1="">
		<cfif IsDefined("urlvarID") and IsNumeric(urlvarID) and urlvarID gt 0 and IsDefined("urlvarRefreshID") and StructKeyExists(cookie,"#id#_refreshID") and (urlvarRefreshID eq cookie[id & '_refreshID'] or cookie[id & '_refreshID'] eq '00000000')>
		<!--- Changes the current directory (only forward not back) --->
		<!--- Uses the same techniques as the directoryQoQ method  --->
			<cfinvoke method="debug" status="#debug#" mode="urlVarProcessing:<br />Moving current directory forward">
			<cfinvoke method="directorySort" mode="fromUrl" returnvariable="directorySort" item="#urlvarsort#" urlvar_sort="#urlvar_sort#">
			<cfif ListLen(dir1path) gt 1>
				<cfloop list="#dir1path#" index="i">
					<cfset loopCnt=IncrementValue(loopCnt)>
					<cfdirectory action="list" directory="#i#" name="dirList#loopCnt#" sort="type ASC, #directorySort#">
				</cfloop>
				<cfquery dbtype="query" name="dirList">
					<cfloop index="i" from="1" to="#loopCnt#">
						SELECT * FROM dirList#i#
						<cfif i neq loopCnt>UNION</cfif>
					</cfloop>
					ORDER BY type ASC
				</cfquery>
				<cfset loopCnt=0>
			<cfelse>
				<cfdirectory action="list" directory="#dir1Path#" name="dirList" sort="type ASC, #directorySort#">
			</cfif>
			<cfset dirQoQ=QueryNew("name,orderName,directory,size,type,dateLastModified,dLMDay,dLMMonth,dLMYear,dLMHour,dLMMinute,attributes,extension","VarChar,VarChar,VarChar,BigInt,VarChar,Date,Integer,Integer,Integer,Integer,Integer,VarChar,VarChar")>
			<cfloop query="dirList">
				<cfinvoke method="directoryFiltering" returnvariable="dirItemCheck"
					displayHidden="#displayHidden#" hideFiles="#hideFiles#" hideFolders="#hideFolders#" fileSysCase="#fileSysCase#"
					showOnlyExtensions="#showOnlyExtensions#" showOnlyFiles="#showOnlyFiles#" showOnlyFolders="#showOnlyFolders#"
					displayZeroByte="#displayZeroByte#"	hideExtensions="#hideExtensions#" dir1_name="#name#" dir1_attributes="#attributes#"
					dir1_type="#type#" dir1_size="#size#" dir1_directory="#directory#">
				<cfif dirItemCheck eq "pass">
					<cfset loopCnt=IncrementValue(loopCnt)>
					<cfif dirList.type neq "Dir" and directorySort contains "extension">
						<cfinvoke method="itemType" returnvariable="extension" item="#reverse(spanExcluding(reverse('#dirList.name#'),'.'))#" mode="ext">
					<cfelseif dirList.type eq "Dir" and directorySort contains "extension">
						<cfinvoke method="itemType" returnvariable="extension" item="dir" mode="ext"> 
					</cfif>
					<cfset tmp=QueryAddRow(dirQoQ,1)>
					<cfif directorySort contains "orderName"><cfset tmp=QuerySetCell(dirQoQ, "orderName", " #LCase(name)#", loopCnt)></cfif>
					<cfset tmp=QuerySetCell(dirQoQ, "name", "#name#", loopCnt)>
					<cfset tmp=QuerySetCell(dirQoQ, "directory", "#directory#", loopCnt)>
					<cfif directorySort contains "size"><cfset tmp=QuerySetCell(dirQoQ, "size", "#size#", loopCnt)></cfif>
					<cfset tmp=QuerySetCell(dirQoQ, "type", "#LCase(type)#", loopCnt)>
					<cfif directorySort contains "dLM">
						<cfset tmp=QuerySetCell(dirQoQ, "dateLastModified", "#dateLastModified#", loopCnt)>
						<cfset tmp=QuerySetCell(dirQoQ, "dLMDay", "#LSDateFormat(dateLastModified,'dd')#", loopCnt)>
						<cfset tmp=QuerySetCell(dirQoQ, "dLMMonth", "#LSDateFormat(dateLastModified,'mm')#", loopCnt)>
						<cfset tmp=QuerySetCell(dirQoQ, "dLMYear", "#LSDateFormat(dateLastModified,'yyyy')#", loopCnt)>
						<cfset tmp=QuerySetCell(dirQoQ, "dLMHour", "#TimeFormat(dateLastModified,'hh')#", loopCnt)>
						<cfset tmp=QuerySetCell(dirQoQ, "dLMMinute", "#TimeFormat(dateLastModified,'mm')#", loopCnt)>
					</cfif>
					<cfif directorySort contains "attributes"><cfset tmp=QuerySetCell(dirQoQ, "attributes", "#attributes#", loopCnt)></cfif>
					<cfif directorySort contains "extension"><cfset tmp=QuerySetCell(dirQoQ, "extension", "#LCase(extension)#", loopCnt)></cfif>
				</cfif>
			</cfloop>
			<cfquery dbtype="query" name="dirQoQ">
				SELECT * FROM dirQoQ ORDER BY type ASC, #directorySort#
			</cfquery>
			<cfset dirQuery1=QueryNew("id,path","VarChar,VarChar")>
			<cfloop query="dirQoQ" startrow="#urlvarID#" endrow="#urlvarID#">
				<cfinvoke method="createDir1Path" returnvariable="dir1Path" directory="#dirQoQ.directory#" name="#dirQoQ.name#">
			</cfloop>
			<cfreturn dir1Path>
		<cfelseif IsDefined("urlvarID") and IsNumeric(urlvarID) and urlvarID lte 0 and IsDefined("urlvarRefreshID") and StructKeyExists(cookie,"#id#_refreshID") and urlvarRefreshID eq cookie[id & '_refreshID']>
		<!--- Moves the current directory back using breadcrumb navigation --->
			<cfinvoke method="directoryCrumbs" returnvariable="dir1Path" argumentcollection="#arguments#" crumbID="#urlvarID#">
			<cfinvoke method="debug" status="#debug#" mode="urlVarProcessing:<br />Moving current directory back to<br />#dir1Path#">
			<cfreturn dir1Path>
		<cfelseif urlvarDownload neq "" and IsNumeric(urlvarDownload) and fileDownloads is true>
		<!--- Downloads a file --->
			<cfinvoke method="debug" status="#debug#" mode="urlVarProcessing:<br />Downloading a file">
			<!--- check to make sure the file is being download via a link from the web server --->
			<cfif fileRemoteLinkage is false>
				<cfinvoke method="remoteLinkageCheck">
			</cfif>
			<!--- generates a custom query or queries (like the directoryQoQ method) directory list to obtain the file's details and location --->
			<cfinvoke method="directorySort" returnvariable="directorySort" mode="fromUrl" item="#urlvarsort#" urlvar_sort="#urlvar_sort#">
			<cfif ListLen(dir1path) gt 1>
				<cfloop list="#dir1path#" index="i">
					<cfset loopCnt=IncrementValue(loopCnt)>
					<cfdirectory action="list" directory="#i#" name="dirList#loopCnt#" sort="type ASC, #directorySort#">
				</cfloop>
				<cfquery dbtype="query" name="dirList">
					<cfloop index="i" from="1" to="#loopCnt#">
						SELECT * FROM dirList#i#
						<cfif i neq loopCnt>UNION</cfif>
					</cfloop>
					ORDER BY type ASC
				</cfquery>
				<cfset loopCnt=0>
			<cfelse>
				<cfdirectory action="list" directory="#dir1Path#" name="dirList" sort="type ASC, #directorySort#">
			</cfif>
			<cfset dirQoQ=QueryNew("orderName,name,directory,size,type,dateLastModified,dLMDay,dLMMonth,dLMYear,dLMHour,dLMMinute,attributes,extension","VarChar,VarChar,VarChar,BigInt,VarChar,Date,Integer,Integer,Integer,Integer,Integer,VarChar,VarChar")>
			<cfset loopCnt=0>
			<cfloop query="dirList">
				<cfinvoke method="directoryFiltering" returnvariable="dirItemCheck"
					displayHidden="#displayHidden#" hideFiles="#hideFiles#" hideFolders="#hideFolders#" fileSysCase="#fileSysCase#"
					showOnlyExtensions="#showOnlyExtensions#" showOnlyFiles="#showOnlyFiles#" showOnlyFolders="#showOnlyFolders#"
					displayZeroByte="#displayZeroByte#"	hideExtensions="#hideExtensions#" dir1_name="#name#" dir1_attributes="#attributes#"
					dir1_type="#type#" dir1_size="#size#" dir1_directory="#directory#">
				<cfif dirItemCheck eq "pass">
					<cfset loopCnt=IncrementValue(loopCnt)>
					<cfif dirList.type neq "Dir" and directorySort contains "extension">
						<cfinvoke method="itemType" returnvariable="extension" item="#reverse(spanExcluding(reverse('#dirList.name#'),'.'))#" mode="ext">
					<cfelseif dirList.type eq "Dir" and directorySort contains "extension">
						<cfinvoke method="itemType" returnvariable="extension" item="dir" mode="ext"> 
					</cfif>
					<cfset tmp=QueryAddRow(dirQoQ,1)>
					<cfif directorySort contains "orderName"><cfset tmp=QuerySetCell(dirQoQ, "orderName", " #LCase(name)#", loopCnt)></cfif>
					<cfset tmp=QuerySetCell(dirQoQ, "name", "#name#", loopCnt)>
					<cfset tmp=QuerySetCell(dirQoQ, "directory", "#directory#", loopCnt)>
					<cfset tmp=QuerySetCell(dirQoQ, "size", "#size#", loopCnt)>
					<cfset tmp=QuerySetCell(dirQoQ, "type", "#LCase(type)#", loopCnt)>
					<cfif directorySort contains "dLM">
						<cfset tmp=QuerySetCell(dirQoQ, "dateLastModified", "#dateLastModified#", loopCnt)>
						<cfset tmp=QuerySetCell(dirQoQ, "dLMDay", "#LSDateFormat(dateLastModified,'dd')#", loopCnt)>
						<cfset tmp=QuerySetCell(dirQoQ, "dLMMonth", "#LSDateFormat(dateLastModified,'mm')#", loopCnt)>
						<cfset tmp=QuerySetCell(dirQoQ, "dLMYear", "#LSDateFormat(dateLastModified,'yyyy')#", loopCnt)>
						<cfset tmp=QuerySetCell(dirQoQ, "dLMHour", "#TimeFormat(dateLastModified,'hh')#", loopCnt)>
						<cfset tmp=QuerySetCell(dirQoQ, "dLMMinute", "#TimeFormat(dateLastModified,'mm')#", loopCnt)>
					</cfif>
					<cfif directorySort contains "attributes"><cfset tmp=QuerySetCell(dirQoQ, "attributes", "#attributes#", loopCnt)></cfif>
					<cfif directorySort contains "extension"><cfset tmp=QuerySetCell(dirQoQ, "extension", "#LCase(extension)#", loopCnt)></cfif>
				</cfif>
			</cfloop>
			<cfquery dbtype="query" name="dirQoQ">
				SELECT * FROM dirQoQ ORDER BY type ASC, #directorySort#
			</cfquery>
			<!--- extract the file details from the query list and send those to the file download instigator (link2file) --->
			<cfloop query="dirQoQ" startrow="#urlvarDownload#" endrow="#urlvarDownload#">
				<cfinvoke method="link2file" dir1name="#dirQoQ.name#" dir1path="#dirQoQ.directory#" filesize="#dirQoQ.size#" urlvarDownload="#urlvarDownload#">
			</cfloop>	
		<cfelse>
		<!--- Do nothing and return the initial dir1path variable --->
			<cfinvoke method="debug" status="#debug#" mode="urlVarProcessing:<br />Stay in the current directory (dir1path var)">
			<cfreturn dir1Path>
		</cfif>
	</cffunction>
	
	<!--- MODIFIABLE DISPLAY OUTPUT --->
	<cffunction name="itemType" access="package" output="false" returntype="string" hint="Categorizes files by their extensions: either to display an appropriate icon, descriptive file type or to set the file MIME type">
		<cfargument name="item" type="string" required="yes" hint="Usually the file extension or if that doesn't exist the file name">
		<cfargument name="iconsLocation" type="string" required="no">
		<cfargument name="mode" type="string" default="mime" hint="Either 'ext', 'icons' or 'mime'">
		<cfswitch expression="#item#">
			<cfcase value="dir">
				<cfif mode eq "ext">
					<cfreturn "Directory">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_folder#,Folder icon"></cfif>
			</cfcase>
			<cfcase value="7z,7zip,ace,arc,arj,bz,bz2,bzip2,gzip,gz,lha,pak,sit,zoo,cab,lzh,rar,tar,zip,tgz">
				<cfif mode eq "mime">
					<cfreturn "application/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "#ucase(item)# Archive">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_archive#,Archive icon"></cfif>
			</cfcase>
			<cfcase value="msi,deb,rpm">
				<cfif mode eq "mime">
					<cfreturn "application/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "Install Application">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_installer#,Install icon"></cfif>
			</cfcase>
			<cfcase value="au,mp3,wma,wav,aiff,flac,ape,aac,mpc,ra,rm,ogg,cda">
				<cfif mode eq "mime">
					<cfreturn "audio/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "Audio Clip">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_audio#,Audio icon"></cfif>
			</cfcase>
			<cfcase value="bmp,gif,jfif,jpg,jpeg,png,tif,tiff">
				<cfif mode eq "mime">
					<cfreturn "image/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "Picture">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_image#,Picture icon"></cfif>
			</cfcase>
			<cfcase value="avi,div,divx,dvr-ms,m1v,mov,mp2,mp4,mpg,mpeg,wm,wmv,xvid">
				<cfif mode eq "mime">
					<cfreturn "video/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "Video Clip">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_video#,Video icon"></cfif>
			</cfcase>
			<cfcase value="swf,fla,flv">
				<cfif mode eq "mime">
					<cfreturn "application/x-shockwave-flash">
				<cfelseif mode eq "ext">
					<cfreturn "Flash Video or Animation">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_video#,Video icon"></cfif>
			</cfcase>
			<cfcase value="cfc,cfm,cfml">
				<cfif mode eq "mime">
					<cfreturn "text/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "ColdFusion Page">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_html#,ColdFusion icon"></cfif>
			</cfcase>
			<cfcase value="css">
				<cfif mode eq "mime">
					<cfreturn "text/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "Cascading Style Sheet">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_html#,CSS icon"></cfif>
			</cfcase>
			<cfcase value="htm,html,xhtml,xht">
				<cfif mode eq "mime">
					<cfreturn "text/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "HTML Document">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_html#,HTML icon"></cfif>
			</cfcase>
			<cfcase value="diz,txt,nfo,rtf,sdw,log">
				<cfif mode eq "mime">
					<cfreturn "text/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "Text Document">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_text#,Text icon"></cfif>
			</cfcase>
				<cfcase value="ans,asc">
				<cfif mode eq "mime">
					<cfreturn "application/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "#ucase(item)# Graphic">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_text#,Text graphic icon"></cfif>
			</cfcase>
			<cfcase value="abw,cwk,lwp,mcw,stw,sxw,wps,wri,doc,odt,pdf,xls,xlc,wpd">
				<cfif mode eq "mime">
					<cfreturn "application/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "Office Document">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_document#,Office icon"></cfif>
			</cfcase>
			<cfcase value="fon,ttf,otf,bdf,gsf,pcf,snf,spd,ttc,pfa,pfb">
				<cfif mode eq "mime">
					<cfreturn "application/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "Font">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_font#,Font icon"></cfif>
			</cfcase>
			<cfcase value="ima,img,imz,iso">
				<cfif mode eq "mime">
					<cfreturn "application/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "#ucase(item)# Image">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_cd#,Image icon"></cfif>
			</cfcase>
			<cfcase value="jar,class,ear,war">
				<cfif mode eq "mime">
					<cfreturn "application/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "Java Applet">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_program#,Java icon"></cfif>
			</cfcase>
			<cfcase value="com,exe,dll,pef,bin">
				<cfif mode eq "mime">
					<cfreturn "application/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "Program File">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_program#,Program icon"></cfif>
			</cfcase>
			<cfcase value="js,bat,mrc,php,pl,py,pyo,pyc,sh,csh,tcl,vbs,scpt,egg,rb,ruby">
				<cfif mode eq "mime">
					<cfreturn "text/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "Script File">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_script#,Script icon"></cfif>
			</cfcase>
			<cfcase value="mid,midi">
				<cfif mode eq "mime">
					<cfreturn "audio/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "MIDI Sequence">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_audio#,Audio icon"></cfif>
			</cfcase>
			<cfcase value="xml,rss,xsl,eml,atom">
				<cfif mode eq "mime">
					<cfreturn "text/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "XML Document">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_html#,XML icon"></cfif>
			</cfcase>
			<cfcase value="db,dbf,fdp,frm,mdb,nfs,sql,mda">
				<cfif mode eq "mime">
					<cfreturn "application/#item#">
				<cfelseif mode eq "ext">
					<cfreturn "Database">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_database#,Database icon"></cfif>
			</cfcase>
			<cfcase value="torrent">
				<cfif mode eq "mime">
					<cfreturn "application/x-bittorrent">
				<cfelseif mode eq "ext">
					<cfreturn "Torrent Link">
				<cfelseif mode eq "icons"><cfreturn "#THIS.img_html#,Torrent icon"></cfif>
			</cfcase>
			<cfdefaultcase>
				<cfif mode eq "mime" or mode eq "icons">
					<cfreturn item>
				<cfelse>
					<cfreturn "#UCase(item)# File">
				</cfif>
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<cffunction name="debug" access="package" output="true" returntype="string" hint="Debug information and a timer to calculate the time it takes to process the page">
		<cfargument name="mode" type="string" required="yes" hint="Either 'startTick', 'displayHeader', 'displayFooter' otherwise it can throw back text">
		<cfargument name="status" type="string" default="none" hint="timer,limited,full,none">
		<cfargument name="layout" type="string" default="">
		<cfargument name="debugTimerValue" type="numeric" default="0">
		<cfargument name="curDir" type="string" default="">
		<cfargument name="rootpath">
		<cfargument name="dir1path">
		<cfargument name="cryptionKey">
		<cfargument name="cryptionAlgorithm">
		<cfargument name="id">
		<cfswitch expression="#mode#">
			<cfcase value="startTick">
				<cfif status neq "none"><cfreturn GetTickCount()></cfif>
			</cfcase>
			<cfcase value="displayHeader"><cfif status eq "full">
<cfoutput>	<div id="bbDebug" style="#layout#">Debug Variables:<br />
	Stored Cookie (decrypted): <cfif StructKeyExists(cookie,"#id#")>#Decrypt('#cookie[id]#','#cryptionKey#','#cryptionAlgorithm#')#<cfelse>None</cfif><br />
	Current Display Directory: #curDir#<br />Dir1Path Var: #dir1Path#<br />RootPath Var: #rootpath#<p></p></div>
</cfoutput></cfif></cfcase>
			<cfcase value="displayFooter"><cfif status neq 'none'><cfoutput>
	<div id="bbDebug" style="#layout#">
	Debug Information:<br />
	Time To Process: #NumberFormat((GetTickCount() - debugTimerValue) / 1000,"___._")# seconds<br />
<cfif status eq 'full' or status eq 'limited'>	FullPath Var: #dir1path#<br />
<cfinvoke method="getFullURL" returnvariable="fullURL" nopath="yes">
	FullUrl Var: #fullURL#<br />
	Operating System: #server.OS.Name# #server.OS.Version# #server.OS.BuildNumber# #server.OS.AdditionalInformation#<br />
	Web Host &amp; Port: #cgi.http_host# (#cgi.server_port#)<br />
	Referer: #cgi.referer#</cfif>
	</div></cfoutput></cfif>
			</cfcase>
			<cfdefaultcase>
				<cfif status eq 'full'><cfoutput>	<div id="bbDebug" style="#layout#">#mode#</div></cfoutput></cfif>
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
</cfcomponent>