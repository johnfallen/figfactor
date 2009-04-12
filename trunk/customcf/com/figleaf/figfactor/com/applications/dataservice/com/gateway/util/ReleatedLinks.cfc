<!--- Document Information -----------------------------------------------------

Title: 			releatedlinks.cfc

Author:			John Allen
Email:				jallen@figleaf.com

company:		Figleaf Software
Website:		http://www.nist.gov

Purpose:		I am a utility CFC to help returen Meta Data Releated Pages.

Usage:			

Modification Log:

Name				Date				Description
================================================================================
L Baker			2008				Created - based on S Druckers origioal code from ???
j Allen			19/06/20008			Formated, added comment header.
									Added init() method.
									Changed the function names.
------------------------------------------------------------------------------->
<cfcomponent output="false" displayname="Releated Links" hint="I am a utility CFC to help returen Meta Data Releated Pages.">

<!--- init --->
<cffunction name="init" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo-constructor for this CFC. I return an instance of myself.">

	<cfreturn this  />
</cffunction>



<!--- getReleatedPages --->
<cffunction name="getReleatedPages"  hint="Returns comma delimited list of related pages based on metadata">
	<cfargument name="datasource" required="yes" type="string" hint="Datasource name for support dsn" />
	<cfargument  name="lmetadataids" required="yes" type="string" hint="Comma delimited list of metadata ids" />
	<cfargument name="maxrows" required="no" type="numeric" default="10" hint="Max number of rows to return" />
	<cfargument name="pageid" required="no" type="string" default="" hint="pageid(s) to exclude" />
	<cfargument name="searchtype" required="no" type="numeric" default="1" hint="1=exact match, 2=hierarchical match" />
	
	<cfset var qrelations = "" />
	<cfset var lpageids = "" />
	<cfset var lbitmaps = "" />
	<cfset var qbitmaps = "" />
	<cfset var lresults = "" />
	<cfset var i = "0" />
	<cfset var thisbitmap = "" />
	<cfset var qfinal = "" />
	<cfset var pageIDList = "" />
	<cfset var maxrecords = 0 />
	<cfset var qgetbitmaps = 0 />

	<cfif listfirst(arguments.lmetadataids) is "0">
		<cfset arguments.lmetadataids = listdeleteat(arguments.lmetadataids,1) />
	</cfif>

	<!--- exact match --->
	<cfif arguments.searchtype is 1> 
		<cfloop from="1" to="#listlen(lmetadataids)#" index="i">
	           
			<cfquery name="qrelations" datasource="#datasource#">
				select  		objectid
				from    		metadatakeyword , articlemetadata
				where       
					metadatakeyword.metadataid = articlemetadata.metadataid
				and 
					metadatakeyword.metadataid = 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.lmetadataids,i)#" />
				
				<cfif i gt 1>
					<cfif lresults is not "">
						and objectid in (
							<cfqueryparam value="#lresults#" cfsqltype="cf_sql_integer" list="true" />
							)
					<cfelse>
						and objectid = 0
					</cfif>
				</cfif>
				
				<cfif arguments.pageid is not "">
					and objectid NOT IN (
						<cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_integer" list="true">
						)
				</cfif>
			</cfquery>
		
			<cfset pageIDList = listAppend(pageIDList, valuelist(qrelations.objectid)) />
			<cfset lresults = ListDeleteDuplicates(pageIDList) />	
		</cfloop>
		


	<!--- fuzzy match --->
	<cfelse>
		<cfset lresults=0 />

		<cfif len(trim(arguments.lmetadataids))>
			
			<cfquery name="qgetbitmaps" datasource="#datasource#">
				select 		metadatabitmask
				from 			metadatakeyword
				where 
					metadatakeyword.metadataid in (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.lmetadataids#" list="yes">
					)
			</cfquery>
			
			<cfset lbitmaps = valuelist(qgetbitmaps.metadatabitmask) />
		<cfelse>
			<cfset lbitmaps = '' />
		</cfif>
		
		<cfif listLen(lbitmaps)>
			<cfset maxrecords=round(10/listlen(lbitmaps)) />
		</cfif>
	
		<cfloop from="1" to="#listlen(lbitmaps)#" index="i">
			
			<cfset thisbitmap = listgetat(lbitmaps,i) />
            
			<cfquery name="qrelations" datasource="#datasource#">
				select  		objectid
				from    		metadatakeyword , articlemetadata
				where
					metadatakeyword.metadataid = articlemetadata.metadataid
				and
					metadatakeyword.metadatabitmask 
				like 
					'#left(thisbitmap,find('000',thisbitmap,1))#%'
				
				<cfif i gt 1>
					<cfif lresults is not "">
						and objectid in (#lresults#)
					<cfelse>
						and objectid = 0
					</cfif>
				</cfif>
			
				<cfif arguments.pageid is not "">
					and objectid NOT IN (
						<cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_integer" list="true">
						)
				</cfif>

				order by articlemetadata.begintime desc
			</cfquery>
			
			<!--- original code --->
			<cfif qrelations.recordcount gt 0>
				<cfset lresults = lresults & "," & valuelist(qrelations.objectid) />
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn lresults />
</cffunction>



<!--- getPage --->
 <cffunction name="getPage" output="false" hint="Returns page information for a set of page ids">
  	<cfargument name="datasource" hint="CommonSpot site datasource.<br />I am required.<br />Type=string">
	<cfargument name="lpageids" type="string" required="no" hint="Comma delimited list of CommonSpot Page IDs" default="">
	<cfargument name="lcategorynames" type="string" required="no" hint="Comma delimited list of CommonSpot page categories" default="">
	<cfargument name="ldoctypes" type="string" required="no" hint="Document type (i.e. SWF)" default="">

	<cfset var qgetpages = "">
	<cfset var aResults = arraynew(1)>
	<cfset var stData = "">
	<cfset var stresult = structnew()>
	<cfset var listitem = "">
	
	<cfquery name="qgetpages" datasource="#datasource#" maxrows="200">
		select 	sitepages.filename,
					sitepages.caption,
					subsites.subsiteurl,
					sitepages.title,
					sitepages.description,
					sitepages.doctype,
					subsites.imagesurl,
					subsites.imagesdir,
					subsites.id as subsiteid,
					sitepages.id as pageid,
					sitepages.ownerid
		from sitepages,subsites <cfif lcategorynames is not "">, docCategories</cfif>
		
		where sitepages.subsiteid = subsites.id
		
		<cfif lcategorynames is not "">
			and sitepages.categoryid = docCategories.id
			and doccategories.category in (#listqualify(lcategorynames,"'")#)
		</cfif>
		
		<cfif lpageids is not "">
			and sitepages.id in (<cfqueryparam value="#arguments.lpageids#" cfsqltype="cf_sql_integer" list="true">)
		</cfif>
		
		<cfif ldoctypes is not "">
			and sitepages.doctype in (#listqualify(ldoctypes,"'")#)
		</cfif>
		
		<cfif lpageids is not "">
			order by sitepages.datecontentlastmodified
		</cfif>
	</cfquery>
	

	<cfloop query="qgetpages">
		<cfscript>
			stData = structnew();
			stData.url = qgetpages.subsiteurl & qgetpages.filename;
			stData.caption = qgetpages.caption;
			stData.Description = qgetpages.description;
			stData.title = qgetpages.title;
			stData.subsiteurl = qgetpages.subsiteurl;
			stData.imagesurl = qgetpages.imagesurl;
			stdata.imagesdir = qgetpages.imagesdir;
			stData.doctype = qgetpages.doctype;
			stData.pageid = qgetpages.pageid;
			stData.subsiteid = qgetpages.subsiteid;
			stData.filename = qgetpages.filename;
			stData.ownerid = qgetpages.ownerid;
			if (trim(lpageids) is "") {
				arrayAppend(aResults,stData);
			} else {
				stresult[qgetpages.pageid] = stdata;
			}
		</cfscript>
	</cfloop>

	
	
	<cfif lpageids is not ""> <!--- output in same order as requested --->
		<cfloop list="#lpageids#" index="listitem">
			<cfif structkeyexists(stresult,listitem)>
				<cfset arrayappend(aResults,stresult[listitem])>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfreturn aResults>
</cffunction>



<cfscript>
/**
* Case-sensitive function for removing duplicate entries in a list.
* Based on dedupe by Raymond Camden
*
* @param list      The list to be modified.
* @return Returns a list.
* @author Jeff Howden (jeff@members.evolt.org)
* @version 1, March 21, 2002
*/
function ListDeleteDuplicates(list) {
var i = 1;
var delimiter = ',';
var returnValue = '';
if(ArrayLen(arguments) GTE 2)
delimiter = arguments[2];
list = ListToArray(list, delimiter);
for(i = 1; i LTE ArrayLen(list); i = i + 1)
if(NOT ListFind(returnValue, list[i], delimiter))
returnValue = ListAppend(returnValue, list[i], delimiter);
return returnValue;
}
</cfscript>


</cfcomponent>