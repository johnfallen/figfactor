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
<!--- 
Sample Usage
------------
Please read the software manual for more detailed information on the use of the application.
Below are some sample usages. To implement create an empty CFM page (with no HTML) on your webroot.
Copy either one of the <cfmodule> tags below into the CFM page.

Windows (supporting multiple directory sources): 
<cfmodule template="box-Browse.cfm"	cryptionKey="ChangeThisKey" folderRoot="c:\Documents and Settings\All Users\Shared Documents\,C:\Archived Documents\" />

Linux (using a single directory source):
<cfmodule template="box-Browse.cfm"	cryptionKey="ChangeThisKey" folderRoot="/home/" />

Change the foldRoot attribute to a valid directory on your web server and save the CFM page.
Make sure the icons folder, and all other box-Browse.* files are in the same directory as the CFM page.
Then point your web to the newly updated CFM page.

--->

<!--- APPLICATION ARGUMENTS --->
<!--- Application settings --->
<cfparam name="attributes.folderRootMask" default="Root folder">
<cfparam name="attributes.folderSort" default="name asc">
<cfparam name="attributes.title" default="BoxBrowse File Browser">
<cfparam name="attributes.debug" default="none">
<cfparam name="attributes.doctype" default="xhtml11">
<cfparam name="attributes.encode" default="utf-8">
<cfparam name="attributes.id" default="BoxBrowse">
<cfparam name="attributes.anchor" type="boolean" default="true">
<!--- Folder paths and application components attributes --->
<cfparam name="attributes.css" default="box-Browse.css">
<cfparam name="attributes.folderRoot" default="">
<cfparam name="attributes.iconFolder" default="icons/">
<!--- Folder and file exclusions --->
<cfparam name="attributes.displayHidden" type="boolean" default="false">
<cfparam name="attributes.displayZeroByte" type="boolean" default="false">
<cfparam name="attributes.hideExtensions" default="cfm,cfc,ini,sys,dll,log,bat">
<cfparam name="attributes.hideFiles" default="box-Browse.cfm,box-Browse.cfc,ntldr,ntdetect.com,Thumbs.db">
<cfparam name="attributes.hideFolders" default="c:\Windows,c:\Documents and Settings,c:\Program Files,c:\cfusionmx,c:\cfusionmx7">
<cfparam name="attributes.showOnlyExtensions" default="">
<cfparam name="attributes.showOnlyFiles" default="">
<cfparam name="attributes.showOnlyFolders" default="">
<!--- Table columns --->
<cfparam name="attributes.showIcons" type="boolean" default="true">
<cfparam name="attributes.showSize" type="boolean" default="true">
<cfparam name="attributes.showType" type="boolean" default="true">
<cfparam name="attributes.showDate" type="boolean" default="true">
<cfparam name="attributes.showExtra" type="boolean" default="false">
<cfparam name="attributes.showStatistics" type="boolean" default="true">
<!--- Table and column widths --->
<cfparam name="attributes.tableWidth" type="numeric" default="700">
<cfparam name="attributes.colIconWidth" type="numeric" default="20">
<cfparam name="attributes.colSizeWidth" type="numeric" default="100">
<cfparam name="attributes.colDateWidth" type="numeric" default="150">
<cfparam name="attributes.colExtrasWidth" type="numeric" default="70">
<cfparam name="attributes.colTypeWidth" type="numeric" default="150">
<!--- Security attributes --->
<cfparam name="attributes.fileDownloads" type="boolean" default="true">
<cfparam name="attributes.fileRemoteLinkage" type="boolean" default="false">
<cfparam name="attributes.cryptionKey" default="">
<cfparam name="attributes.cryptionAlgorithm" default="CFMX_COMPAT">
<!--- Customize the url variable names --->
<cfparam name="attributes.urlvar_id" default="bb1">
<cfparam name="attributes.urlvar_refreshid" default="bb2">
<cfparam name="attributes.urlvar_sort" default="bb3">
<cfparam name="attributes.urlvar_download" default="bb4">

<!--- APPLICATION VARIABLES --->
<!--- Save all attributes to a structure for easy use with CFC functions --->
<cfset args=structNew()>
<cfset args.css=attributes.css>
<cfset args.debug=attributes.debug>
<cfset args.doctype=attributes.doctype>
<cfset args.encode=attributes.encode>
<cfset args.title=attributes.title>
<cfset args.id=attributes.id>
<cfset args.anchor=attributes.anchor>
<cfset args.folderRoot=attributes.folderRoot>
<cfset args.folderRootMask=attributes.folderRootMask>
<cfset args.folderSort=attributes.folderSort>
<cfset args.iconFolder=attributes.iconFolder>
<cfset args.displayHidden=attributes.displayHidden>
<cfset args.displayZeroByte=attributes.displayZeroByte>
<cfset args.hideExtensions=attributes.hideExtensions>
<cfset args.hideFiles=attributes.hideFiles>
<cfset args.hideFolders=attributes.hideFolders>
<cfset args.showOnlyExtensions=attributes.showOnlyExtensions>
<cfset args.showOnlyFiles=attributes.showOnlyFiles>
<cfset args.showOnlyFolders=attributes.showOnlyFolders>
<cfset args.showIcons=attributes.showIcons>
<cfset args.showSize=attributes.showSize>
<cfset args.showType=attributes.showType>
<cfset args.showDate=attributes.showDate>
<cfset args.showExtra=attributes.showExtra>
<cfset args.showStatistics=attributes.showStatistics>
<cfset args.tableWidth=attributes.tableWidth>
<cfset args.colIconWidth=attributes.colIconWidth>
<cfset args.colSizeWidth=attributes.colSizeWidth>
<cfset args.colDateWidth=attributes.colDateWidth>
<cfset args.colExtrasWidth=attributes.colExtrasWidth>
<cfset args.colTypeWidth=attributes.colTypeWidth>
<cfset args.fileRemoteLinkage=attributes.fileRemoteLinkage>
<cfset args.fileDownloads=attributes.fileDownloads>
<cfset args.cryptionKey=attributes.cryptionKey>
<cfset args.cryptionAlgorithm=attributes.cryptionAlgorithm>
<cfset args.urlvar_id=attributes.urlvar_id>
<cfset args.urlvar_refreshid=attributes.urlvar_refreshid>
<cfset args.urlvar_sort=attributes.urlvar_sort>
<cfset args.urlvar_download=attributes.urlvar_download>

<!--- Set the CFC component file name --->
<cfset cfcName="box-Browse">
<!--- ATTRIBUTE CHECKS --->
<cfif GetFileFromPath(cgi.script_name) eq "box-Browse.cfm" or GetFileFromPath(cgi.path_info) eq "box-Browse.cfm">
<cfoutput>
<div style="font-family:Arial, Helvetica, sans-serif; font-size:14px;">
<p>Please read the software manual for more detailed information on the use of the application.
Below are some sample usages. To implement create an empty CFM page (with no HTML).
Copy either one of the &lt;cfmodule&gt; tags below into the CFM page.</p><p>
Windows (supporting multiple directory sources):<br /><span style="color:##CC3333">
&lt;cfmodule template="box-Browse.cfm"	cryptionKey="ChangeThisKey" folderRoot="c:\Documents and Settings\All Users\Shared Documents\,c:\Archived Documents\" /&gt;</span>
</p><p>
Linux (using a single directory source):<br /><span style="color:##CC3333">
&lt;cfmodule template="box-Browse.cfm"	cryptionKey="ChangeThisKey" folderRoot="/home/" /&gt;</span>
</p><p>
Change the foldRoot attribute to a valid directory on your web server and save the CFM page.
Make sure the icons folder, and all other box-Browse.* files are in the same directory as the CFM page.
Then point your web to the newly updated CFM page.</p><p><a href="http://www.civbox.com" style="font-size:10px;">www.civbox.com</a></p></div>
</cfoutput><cfabort></cfif>
<cfif args.folderRoot eq "">
	<cfinvoke component="#cfcName#" method="error" title="A required attribute is missing" detail="'FolderRoot' attribute was not provided: You must provide a directory or a list of directories to be used as the root folder">
</cfif>
<cfif args.folderRootMask eq "" or (args.folderRootMask eq "/" and server.os.name does not contain 'Windows') or (args.folderRootMask eq "\" and server.os.name contains 'Windows')><cfset args.folderRootMask="Root"></cfif>
<!--- Safely format the user supplied absolute directories --->
<cfinvoke component="#cfcName#" method="directoryFormat" returnvariable="args.hideFolders" dir="#args.hideFolders#">
<cfinvoke component="#cfcName#" method="directoryFormat" returnvariable="args.showOnlyFolders" dir="#args.showOnlyFolders#">
<cfinvoke component="#cfcName#" method="directoryFormat" returnvariable="args.folderRoot" dir="#args.folderRoot#">
<cfinvoke component="#cfcName#" method="directoryFormat" returnvariable="args.iconFolder" dir="#args.iconFolder#" mode="relative">
<!--- Set the CFC THIS. variables as usable object variables --->
<cfobject name="boxBrowseObj" component="#cfcName#">
<!--- Initialize application variables --->
<cfinvoke component="#cfcName#" method="initialization" returnvariable="iniStr" argumentcollection="#args#">
<cfset args.fileSysCase=iniStr.fileSysCase>
<cfset args.folderRoot=iniStr.folderRoot>
<cfset args.rootpath=iniStr.rootpath>
<cfset args.doctype=iniStr.doctype>
<!--- Create the url variable used for sorting the directories --->
<cfif NOT IsDefined("url.#args.urlvar_sort#")>
	<cfinvoke component="#cfcName#" method="directorySort" returnvariable="url.#args.urlvar_sort#" argumentcollection="#args#" mode="toUrl" item="#args.folderSort#">
</cfif>
<!--- Generate a unique id number for each page hit --->
<cfinvoke component="#cfcName#" method="refreshID" returnvariable="refreshID" mode="generate">
<cfparam name="url.#args.urlvar_refreshID#" default="#refreshID#">
<!--- If the cookie does not exist (because they have been erased) but URL variables do then reset the variables --->
<cfif not StructKeyExists(cookie,"#args.id#")>
	<!--- Check for each URL variable structure, delete them --->
	<cfif StructKeyExists(url,"#args.urlvar_id#")><cfset tmp=StructDelete(url,'#args.urlvar_id#')></cfif>
	<cfif StructKeyExists(url,"#args.urlvar_refreshid#")><cfset tmp=StructDelete(url,'#args.urlvar_refreshid#')></cfif>
	<cfif StructKeyExists(url,"#args.urlvar_download#")><cfset tmp=StructDelete(url,'#args.urlvar_download#')></cfif>
	<!--- Recreate a new URL structure --->
	<cfinvoke component="#cfcName#" method="urlStringVal" refreshid="#refreshID#" force="true" argumentcollection="#args#">
	<cfset cookie[args.id]="#Encrypt('#args.rootPath#','#args.cryptionKey#','#args.cryptionAlgorithm#')#">
	<cfset cookie[args.id & '_refreshid']="00000000">
<cfelse>
	<!--- Forces the creation of a url string if there is none --->
	<cfinvoke component="#cfcName#" method="urlStringVal" refreshid="#refreshID#" argumentcollection="#args#">
</cfif>
<cfparam name="url.#args.urlvar_id#" default="0">
<!--- Query from the Form Filer --->
<cfif IsDefined("form.filter") and form.filter neq "" and form.filter neq boxBrowseObj.formFilterDefaultText>
	<cfset searchItem=form.filter>
<cfelse>
	<cfset searchItem=boxBrowseObj.formFilterDefaultText>
</cfif>
<!--- Save URL variables as local variables --->
<cfset args.urlvarID=url['#args.urlvar_id#']>
<cfset args.urlvarRefreshID=url['#args.urlvar_refreshid#']>
<cfset args.urlvarSort=url['#args.urlvar_sort#']>
<cfif structKeyExists(url,"#args.urlvar_download#") is true and IsNumeric(url[args.urlvar_download]) and args.fileDownloads is true>
	<cfset args.urlvarDownload=url[args.urlvar_download]>
<cfelse>
	<cfset args.urlvarDownload="">
</cfif>
<!--- Calculate the width of the table column 'name' --->
<cfinvoke component="#cfcName#" method="calcNameWidth" returnvariable="colNameWidth" argumentcollection="#args#">
<!--- Calculate the width of the bread crumb navigation --->
<cfset DirInfoWidth=(args.tableWidth-280)>

<!--- ATTRIBUTE AND SECURITY CHECKS --->
<!--- Check that rootpath exists --->
<cfloop list="#args.rootpath#" index="i">
	<cfif DirectoryExists(i) is false>
		<cfinvoke component="#cfcName#" method="error" title="A required attribute is invalid" detail="'FolderRoot' attribute is invalid:  - The root directory provided '#i#' can not be found on the server. #IIF(server.os.name does not contain 'Windows',DE(' Note that directories and files are case-sensitive on this server.'),DE(''))#">
	</cfif>
</cfloop>
<!--- Check that the Cascading Style Sheet exists --->
<cfif FileExists(ExpandPath(args.css)) is false and args.doctype neq "none">
	<cfinvoke component="#cfcName#" method="error" title="A required attribute is invalid" detail="'CSS' attribute was not provided: The BoxBrowse cascading style sheet '#args.css#' can not be found. #IIF(server.os.name does not contain 'Windows',DE(' Note that directories and files are case-sensitive on this server.'),DE(''))#">
</cfif>
<!--- Check to make sure the encryptionKey has been provided --->
<cfif args.cryptionKey eq "">
	<cfinvoke component="#cfcName#" method="error" title="A required attribute is missing" detail="'CryptionKey' attribute was not prodived: You must provide a key or a pass-phrase to be used with the application encryption. A random string of 10 or so characters would be fine.">
</cfif>

<!--- Security check the client's cookie for tampering --->
<cfinvoke component="#cfcName#" method="cookiePath" returnvariable="args.dir1Path" argumentcollection="#args#">

<!--- APPLICATION PROCESSING --->
<!--- Debug timer initialization (used for debug mode) --->
<cfinvoke component="#cfcName#" method="debug" returnvariable="args.debugTimerValue" status="#args.debug#" mode="startTick"> 
<!--- Processes the current set of URL variables --->
<cfinvoke component="#cfcName#" method="urlVarProcessing" returnvariable="args.dir1Path" argumentcollection="#args#">

<!--- FOLDER AND FILE TABLE DISPLAY --->
<!--- Displays document type and meta information (<!doctype><head><body> etc.) --->
<cfswitch expression="#args.doctype#">
	<cfcase value="html4strict">
    	<cfset docTypeSelection="-//W3C//DTD HTML 4.01//EN">
        <cfset docTypeAddress="http://www.w3.org/TR/html4/strict.dtd">
    </cfcase>
	<cfcase value="html4loose">
    	<cfset docTypeSelection="-//W3C//DTD HTML 4.01 Transitional//EN">
        <cfset docTypeAddress="http://www.w3.org/TR/html4/loose.dtd">
    </cfcase>
	<cfcase value="xhtml1strict">
    	<cfset docTypeSelection="-//W3C//DTD XHTML 1.0 Strict//EN">
        <cfset docTypeAddress="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    </cfcase>
	<cfcase value="xhtml1loose">
    	<cfset docTypeSelection="-//W3C//DTD XHTML 1.0 Transitional//EN">
        <cfset docTypeAddress="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    </cfcase>
	<cfcase value="xhtml11">
    	<cfset docTypeSelection="-//W3C//DTD XHTML 1.1//EN">
        <cfset docTypeAddress="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
    </cfcase>
</cfswitch>
<cfif args.doctype neq "none">
<cfoutput><!DOCTYPE html PUBLIC "#docTypeSelection#" "#docTypeAddress#">
</cfoutput>
<!--- [updated 1.01] fixed incorrect usage of <html> tags for HTML pages --->
<cfswitch expression="#args.doctype#">
<cfcase value="html4strict,html4loose">
<cfoutput>	<html>
	<meta http-equiv="Content-Type" content="text/html; charset=#args.encode#">
	<title>#args.title#</title>
	<link href="#args.css#" rel="stylesheet" type="text/css"></cfoutput>
</cfcase>
<cfcase value="xhtml1strict,xhtml1loose,xhtml11">
<cfoutput>	<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=#args.encode#" />
	<title>#args.title#</title>
	<link href="#args.css#" rel="stylesheet" type="text/css" /></cfoutput>
</cfcase>
</cfswitch>
<cfoutput>
</head>
<body id="bbBody">
</cfoutput>
</cfif>

<cfinvoke component="#cfcName#" method="displayPath" returnvariable="curDir" path="#args.dir1Path#" root="#args.rootpath#" replacement="#args.folderRootMask#">
<!--- Debug information --->
<cfinvoke component="#cfcName#" method="debug" curdir="#curDir#" mode="displayHeader" layout="margin-bottom:10px;" status="#args.debug#" argumentcollection="#args#">
<cfoutput>	<div id="bb_DirBox" style="width:#(args.tableWidth)#px;">
<cfif args.id neq "" and args.anchor is true>	<a id="bb_#args.id#"></a></cfif><cfsilent>
<!--- Current directory information ---></cfsilent>
	<div id="bb_SearchBox"><cfsilent>
<!--- Filter Form name="search" ---></cfsilent>
	<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" id="search"  style="margin:0px;padding:0px;">
	<fieldset title="Filter the list of items in this directory" style="margin:0px; padding:0px; border:0px;">
	<legend style="margin:0px;padding:0px;height:0px;width:0px;"></legend>
	<input name="filter" type="text" id="bb_SearchQuery" value="#URLEncodedFormat(searchItem)#" style="text-align:center; color:gray;" onClick="if (document.search.filter.value == 'filter') {document.search.filter.value = ''};" />
	</fieldset>
	</form>
	</div>
	<div id="bb_DirInfo"></cfoutput>
<!--- Breadcrumb Navigation --->
<cfset breadcrumbCnt=ListLen(curDir,"#IIF(server.os.name contains 'Windows',DE('\'),DE('/'))#")>
<cfloop list="#curDir#" index="i" delimiters="#IIF(server.os.name contains 'Windows',DE('\'),DE('/'))#">
	<cfinvoke component="#cfcName#" method="queryStr" returnvariable="urlString" argumentcollection="#args#" mode="crumb" loopCnt="#breadcrumbCnt#" urlvar_idsign="-">
<cfoutput>
	<a href="#urlString#">#i#</a><cfif breadcrumbCnt gt 1><img src="#args.iconFolder#/#boxBrowseObj.img_arrowright#" alt="Right arrow" class="bbImage bbTHArrow" /></cfif></cfoutput>
	<cfset breadcrumbCnt=DecrementValue(breadcrumbCnt)>
</cfloop>
<cfoutput>
	</div>
	</div></cfoutput>
<!--- Checks to make sure an active link has been clicked (as oppose to a page refresh) before updating the cookie's directory path --->
	<cfif CGI.HTTP_REFERER neq "">
		<cfset cookie[args.id]="#Encrypt('#args.dir1Path#','#args.cryptionKey#','#args.cryptionAlgorithm#')#">
		<!--- Set cookie, using navigation session id --->
		<cfset cookie[args.id & '_refreshid']=refreshID>
	<cfelse>
	<cfset cookie[args.id]="#Encrypt('#args.dir1Path#','#args.cryptionKey#','#args.cryptionAlgorithm#')#">
		<cfset cookie[args.id & '_refreshid']="00000000">
	</cfif>
	
	<cfif http_cookie eq "" and IsDefined("CGI.HTTP_REFERER") and CGI.HTTP_REFERER neq "">
<cfoutput>	<div style="text-align:center;">Please note that this application requires the use of cookies, otherwise you might not be able to navigate</div></cfoutput>
	</cfif>
	<!--- Obtain the display order for the directory items using the url variable 'sort' --->
	<cfinvoke component="#cfcName#" method="directorySort" returnvariable="directorySort" argumentcollection="#args#" mode="fromUrl" item="#args.urlvarSort#">
	<!--- Generates a custom query or queries directory list --->
	<cfinvoke component="#cfcName#" method="directoryQoQ" returnvariable="dir1" argumentcollection="#args#" directorySort="#directorySort#">
	<!--- Initialise loop and statistic variables --->
	<cfset loopCnt=0>
	<cfset listCnt=0>
	<cfset directoryFileCnt=0>
	<cfset directoryDirCnt=0>
	
<!--- Table used to display directory content [there is no tabbing to help minimise white space which can become an issue with large file lists] --->
<cfoutput>
	<table cellpadding="0" cellspacing="0" border="0" class="bbTable"><tr></cfoutput>
<!--- icons column header --->
<cfoutput>
<cfif args.showIcons eq true>
	<th class="bbTH" style="width:#args.colIconWidth#px;background-image: url('#args.iconFolder#/#boxBrowseObj.img_background#');"></th></cfif><cfsilent>
<!--- name column header ---></cfsilent>
	<th class="bbTH" style="width:#(colNameWidth)#px;background-image: url('#args.iconFolder#/#boxBrowseObj.img_background#');">
<cfif args.urlvarSort eq 0>		<div id="bbTHNameHead" class="bbTHHead bbTHName"><a href="#REReplaceNoCase('#urlString#','#args.urlvar_Sort#=[0-99]','#args.urlvar_Sort#=1')#">Name<img src="#args.iconFolder#/#boxBrowseObj.img_arrowup#" alt="Up arrow" class="bbImage bbTHArrow" /></a></div></th>
<cfelse>	<div id="bbTHNameHead" class="bbTHHead bbTHName"><a href="#REReplaceNoCase('#urlString#','#args.urlvar_Sort#=[0-99]','#args.urlvar_Sort#=0')#">Name<cfif args.urlvarSort eq 1><img src="#args.iconFolder#/#boxBrowseObj.img_arrowdown#" alt="Down arrow" class="bbImage bbTHArrow" /></cfif></a></div></th></cfif><cfsilent>
<!--- size column header ---></cfsilent>
<cfif args.showSize eq true>
	<th style="width:#args.colSizeWidth#px;background-image: url('#args.iconFolder#/#boxBrowseObj.img_background#');" class="bbTHSeparator bbTH">
<cfif args.urlvarSort eq 2>		<div id="bbTHSizeHead" class="bbTHHead bbTHSize"><a href="#REReplaceNoCase('#urlString#','#args.urlvar_Sort#=[0-99]','#args.urlvar_Sort#=3')#" style="width:100%;">Size<img src="#args.iconFolder#/#boxBrowseObj.img_arrowup#" alt="Up arrow" class="bbTHArrow bbImage" /></a></div></th>
<cfelse>	<div id="bbTHSizeHead" class="bbTHHead bbTHSize"><a href="#REReplaceNoCase('#urlString#','#args.urlvar_Sort#=[0-99]','#args.urlvar_Sort#=2')#" style="width:100%;">Size<cfif args.urlvarSort eq 3><img src="#args.iconFolder#/#boxBrowseObj.img_arrowdown#" alt="Down arrow" class="bbTHArrow bbImage" /></cfif></a></div></th></cfif></cfif><cfsilent>
<!--- type column header ---></cfsilent>
<cfif args.showType eq true>
	<th style="width:#args.colTypeWidth#px;background-image: url('#args.iconFolder#/#boxBrowseObj.img_background#');" class="bbTHSeparator bbTH">
<cfif args.urlvarSort eq 4>	<div id="bbTHTypeHead" class="bbTHHead bbTHType"><a href="#REReplaceNoCase('#urlString#','#args.urlvar_Sort#=[0-99]','#args.urlvar_Sort#=5')#">Type<img src="#args.iconFolder#/#boxBrowseObj.img_arrowup#" alt="Up arrow" class="bbImage bbTHArrow" /></a></div></th>
<cfelse>	<div id="bbTHTypeHead" class="bbTHHead bbTHType"><a href="#REReplaceNoCase('#urlString#','#args.urlvar_Sort#=[0-99]','#args.urlvar_Sort#=4')#">Type<cfif args.urlvarSort eq 5><img src="#args.iconFolder#/#boxBrowseObj.img_arrowdown#" alt="Down arrow" class="bbImage bbTHArrow" /></cfif></a></div></th></cfif></cfif><cfsilent>
<!--- date column header ---></cfsilent>
<cfif args.showDate eq true>
	<th style="width:#args.colDateWidth#px;background-image: url('#args.iconFolder#/#boxBrowseObj.img_background#');" class="bbTHSeparator bbTH">
<cfif args.urlvarSort eq 6>	<div id="bbTHDateHead" class="bbTHHead bbTHDate"><a href="#REReplaceNoCase('#urlString#','#args.urlvar_Sort#=[0-99]','#args.urlvar_Sort#=7')#">Date Modified<img src="#args.iconFolder#/#boxBrowseObj.img_arrowup#" alt="Up arrow" class="bbImage bbTHArrow" /></a></div></th>
<cfelse>	<div id="bbTHDateHead" class="bbTHHead bbTHDate"><a href="#REReplaceNoCase('#urlString#','#args.urlvar_Sort#=[0-99]','#args.urlvar_Sort#=6')#">Date Modified<cfif args.urlvarSort eq 7><img src="#args.iconFolder#/#boxBrowseObj.img_arrowdown#" alt="Down arrow" class="bbImage bbTHArrow" /></cfif></a></div></th></cfif></cfif><cfsilent>
<!--- extra column header ---></cfsilent>
<cfif args.showExtra eq true>
	<th style="width:#args.colExtrasWidth#px;background-image: url('#args.iconFolder#/#boxBrowseObj.img_background#');" class="bbTHSeparator bbTH">
<cfif args.urlvarSort eq 9>	<div id="bbTHExtraHead" class="bbTHHead bbTHExtra"><a href="#REReplaceNoCase('#urlString#','#args.urlvar_Sort#=[0-99]','#args.urlvar_Sort#=8')#">Extra<img src="#args.iconFolder#/#boxBrowseObj.img_arrowup#" alt="Up arrow" class="bbImage bbTHArrow" /></a></div></th>
<cfelse>	<div id="bbTHExtraHead" class="bbTHHead bbTHExtra"><a href="#REReplaceNoCase('#urlString#','#args.urlvar_Sort#=[0-99]','#args.urlvar_Sort#=9')#">Extra<cfif args.urlvarSort eq 8><img src="#args.iconFolder#/#boxBrowseObj.img_arrowdown#" alt="Down arrow" class="bbImage bbTHArrow" /></cfif></a></div></th></cfif></cfif>
	</tr>
</cfoutput>
<!--- Table row for each item contained in the directory --->
	<cfloop query="dir1">
		<cfset loopCnt=IncrementValue(loopCnt)>		
		<!--- Filter display (FORM) --->
		<cfif (searchItem eq "" or searchItem eq boxBrowseObj.formFilterDefaultText or dir1.name contains searchItem)>
			<cfset listCnt=IncrementValue(listCnt)>
			<!--- Collect statistics on the number of directories and files in this directory --->
			<cfif  dir1.type eq "File"><cfset directoryFileCnt=IncrementValue(directoryFileCnt)></cfif>
			<cfif  dir1.type eq "Dir"><cfset directoryDirCnt=IncrementValue(directoryDirCnt)></cfif>
<cfoutput>
	<tr>
<cfif args.showIcons eq true>	<td class="bbTDIcon bbTD"><cfsilent>
<!--- icons --->
<cfif dir1.type neq "Dir"><cfinvoke component="#cfcName#" method="itemType" item="#reverse(spanExcluding(reverse('#dir1.name#'),'.'))#" iconsLocation="#args.iconfolder#" mode="icons" returnvariable="iconProperties">
<cfelseif dir1.type eq "Dir"><cfinvoke component="#cfcName#" method="itemType" item="dir" iconsLocation="#args.iconfolder#" mode="icons" returnvariable="iconProperties"></cfif>
</cfsilent><cfif ListLen(iconProperties) gt 1><div class="bbIconDiv"><img src="#args.iconfolder#/#ListGetAt(iconProperties,1)#" alt="#ListGetAt(iconProperties,2)#" class="bbImage" /></div></cfif></td></cfif>
	<td class="bbTDName bbTD"><cfsilent>
<!--- name --->
	<cfinvoke component="#cfcName#" method="link4file" argumentcollection="#args#" dir1name="#dir1.name#" dir1type="#dir1.type#" loopCnt="#loopCnt#" refreshID="#refreshID#" returnvariable="link4fileOutput">
</cfsilent>#link4fileOutput#</td>
<cfif args.showSize eq true>	<td class="<cfif listCnt MOD 2 EQ 0>bbTDA<cfelse>bbTDB</cfif> bbTD"><cfsilent>
<!--- size --->
<cfif dir1.type neq "Dir"><cfinvoke component="#cfcName#" method="boxByteCFC" returnvariable="displaySize" value="#dir1.size#" lowestValue="kB" highestValue="kB" showDecimal="no"></cfif>
</cfsilent><cfif dir1.type neq "Dir"><div class="bbTDSize bbTDSizeText">#displaySize#</div></cfif></td></cfif>
<cfif args.showType eq true>
	<td class="<cfif listCnt MOD 2 EQ 0>bbTDA<cfelse>bbTDB</cfif> bbTD"><cfsilent>
<!--- item type --->
<cfif dir1.type neq "Dir">
	<cfinvoke component="#cfcName#" method="itemType" returnvariable="itemType" item="#reverse(spanExcluding(reverse('#dir1.name#'),'.'))#" mode="ext">
<cfelseif dir1.type eq "Dir">
	<cfinvoke component="#cfcName#" method="itemType" returnvariable="itemType" item="dir" mode="ext"> 
</cfif></cfsilent><div class="bbTDType bbTDTypeText">#itemType#</div></td></cfif>
<cfif args.showDate eq true>
	<td class="<cfif listCnt MOD 2 EQ 0>bbTDA<cfelse>bbTDB</cfif> bbTD"><cfsilent>
<!--- date last modified --->
	<cfset TDDate=LSParseDateTime("#dLMDay#/#dLMMonth#/#dLMYear# #dLMHour#:#dLMMinute#")>
</cfsilent><div class="bbTDDate">#LSDateFormat(TDDate,'dd/mmm/yy')# #TimeFormat(TDDate,'hh:mm')#</div></td></cfif>
<cfif args.showExtra eq true>
	<td class="<cfif listCnt MOD 2 EQ 0>bbTDA<cfelse>bbTDB</cfif> bbTD"><cfsilent>
<!--- other information ---></cfsilent><div class="bbTDExtra">#dir1.attributes#</div></td></cfif>
	</tr></cfoutput></cfif></cfloop>
<!--- empty directosry display --->
<cfoutput><cfif (directoryFileCnt + directoryDirCnt) eq 0>	<tr>
<cfif args.showIcons eq true>	<td class="bbTDA bbTD"><div class="bbTDIcon">&nbsp;</div></td></cfif>
	<td class="bbTD"><div class="bbTDName">This directory is empty</div></td>
<cfif args.showSize eq true>	<td class="bbTDA bbTD"><div class="bbTDSize">&nbsp;</div></td></cfif>
<cfif args.showType eq true>	<td class="bbTDA bbTD"><div class="bbTDType">&nbsp;</div></td></cfif>
<cfif args.showDate eq true>	<td class="bbTDA bbTD"><div class="bbTDDate">&nbsp;</div></td></cfif>
<cfif args.showExtra eq true>	<td class="bbTDA bbTD"><div class="bbTDExtra">&nbsp;</div></td></cfif>
	</tr></cfif></table><cfsilent>
<!--- Statistics ---></cfsilent>
	<div id="bbStatsBox" style="width:#args.tableWidth#px;">
	<div id="bbCivBox"><a href="http://www.civbox.com">BoxBrowse #boxBrowseObj.version#</a></div>
<cfif args.showStatistics eq true>	<span id="bbStatsText">#(directoryDirCnt+directoryFileCnt)# item<cfif (directoryDirCnt+directoryFileCnt) neq 1>s</cfif> total, #directoryFileCnt# file<cfif directoryFileCnt neq 1>s</cfif> and #directoryDirCnt# director<cfif directoryDirCnt neq 1>ies<cfelse>y</cfif>.</span></cfif>
	</div></cfoutput>
<!--- Debug information --->
<cfinvoke component="#cfcName#" method="debug" mode="displayFooter" layout="margin-top:10px;" status="#args.debug#" argumentcollection="#args#">
<!--- Document closure tags (</body></html> etc.) --->
<cfif args.doctype neq "none">
<cfswitch expression="#args.doctype#">
<cfcase value="html4loose,html4strict,xhtml1loose,xhtml1strict,xhtml11">
<cfoutput>
	</body>
</html></cfoutput>
</cfcase>
</cfswitch>
</cfif>