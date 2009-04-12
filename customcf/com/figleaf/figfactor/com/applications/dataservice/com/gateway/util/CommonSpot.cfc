<!--- -------------------------------------------------------------------------------------------------------------------  

Filename: /voanews_shared/figleaf/admin/cfc/CommonSpot.CFC

Creation Date: January 2005

Author: Steve Drucker (sdrucker@figleaf.com)
Fig Leaf Software (www.figleaf.com)

Purpose: 
-Access functions that manipulate various facets of the CommonSpot database

1) PageGet - returns info about selected CommonSpot pages in an array of structs
2) ImagesGetByCategory - returns images based on image category and file ext
3) ownershipTake - change ownership of a page / article
4) PageTitleSet - change the title of a page
5) SubsitesGet - returns subsite info for a specified site
6) CustomElementDefinitionsGet -returns query of custom element defs
7) ImageGet - retrieves image info based on pageid
8) ImageUpdateDB  - inserts/updates image information at database level

Call Syntax:


Notes:


Modification Log:
=====================================
01/08/2005 sdrucker	updated documentation
02/02/2005 sdrucker	added UploadFileDelete, ImageDelete methods, pagedelete function
02/16/2005 sdrucker 	added ownerid to returned values from PAGEGET method
02/17/2005 sdrucker 	added ImageGet method
03/13/2008 lbacker		allowed search to search over either Verity or Google depending on configuration in figleaf.ini file
06/30/2008 jallen 		added subsiteID as an argument to pageGet, and added supporting code to the method.
								added init() method
-------------------------------------------------------------------------------------------- --->
<cfcomponent name="CommonSpot" hint="Data Access for CommonSpot Information">

<!--- init --->
<cffunction name="init" access="public" hint="I am the pusedo-constructor." output="false">
	<cfreturn this />
</cffunction>



<!--- pageGet --->
 <cffunction name="pageGet" access="remote" output="true" returntype="any" hint="Returns page information for a set of page ids">
  	<cfargument name="datasource" type="string" required="yes" hint="CommonSpot site datasource">
	<cfargument name="lpageids" type="string" required="no" hint="Comma delimited list of CommonSpot Page IDs" default="">
	<cfargument name="subsiteID" type="any" required="no" hint="I am the ID of a sub site to filter by." defalut="no">

	<cfset var qgetpages = "">
	<cfset var aResults = arraynew(1)>
	<cfset var stData = "">
	<cfset var stresult = structnew()>
	<cfset var listitem = "">
	
	<cfquery name="qgetpages" datasource="#datasource#" maxrows="200">
		select 	sitepages.filename,
					sitepages.datecontentlastmodified,
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
		from sitepages,subsites
		
		<cfif isDefined("arguments.subsiteID")>
			where sitepages.subsiteid = <cfqueryparam value="#arguments.subsiteID#" cfsqltype="cf_sql_integer">
		<cfelse>
			where sitepages.subsiteid = subsites.id
		</cfif>	
		
		<cfif lpageids is not "">
			and sitepages.id in (<cfqueryparam value="#lpageids#" cfsqltype="cf_sql_integer" list="true">)
		</cfif>
		
		<cfif lpageids is not "">
			order by sitepages.datecontentlastmodified desc
		</cfif>
	</cfquery>
	
	<cfreturn qgetpages>
</cffunction>



<cffunction name="ImagesGetByCategory" access="public" output="false" returntype="query" hint="Returns query containing image information">
	<cfargument name="datasource" type="string" required="yes" hint="CommonSpot Site Datasource">
	<cfargument name="categoryname" type="string" required="yes" hint="CommonSpot Image Category Name">
	<cfargument name="filetype" type="string" required="no" hint="Image File Type (GIF/JPG)" default="">

	<cfset var qJoinImgDir = "">
	
	<cfquery name="qJoinImgDir" datasource="#arguments.datasource#"> 
		SELECT		Imagegallery.filename, subsites.imagesURL, subsites.ImagesDir, sitepages.id as pageid, ImageGallery.description
		FROM 		ImageGallery  , subsites, imagecategories, sitepages  
		WHERE 		
					sitepages.subsiteid = subsites.id
					and sitepages.id = imagegallery.pageid
					and ImageGallery.SUBSITEID = subsites.ID
					and imagegallery.categoryid = imagecategories.id
					and imagecategories.category = '#arguments.categoryname#'
					<cfif arguments.filetype is not "">
					and right(imagegallery.filename,3) = '#arguments.filetype#'
					</cfif>
					and imagegallery.versionstate = 2
		ORDER BY 	sitepages.DateAdded 			
	</cfquery>
	
	<cfreturn qJoinImgDir>

</cffunction>



<cffunction name="ImageGet" access="public" output="false" returntype="struct" hint="Returns query containing image information">
	<cfargument name="datasource" type="string" required="yes" hint="CommonSpot Site Datasource" />
	<cfargument name="pageid" type="numeric" required="Yes" hint="CommonSpot Image ID" />

	<cfset var imgdata = "">
	<cfset var stData = structnew()>

	<cfquery name="imgdata" datasource="#arguments.datasource#"> 
		SELECT		Imagegallery.filename,
					subsites.imagesURL, 
					subsites.ImagesDir, 
					subsites.id as subsiteid,
					sitepages.id as pageid, 
					ImageGallery.description,
					imagecategories.category,
					imagecategories.id as categoryid,
					imagegallery.ownerid

		FROM 		ImageGallery  , subsites, imagecategories, sitepages  
		WHERE 		
					sitepages.subsiteid = subsites.id
					and sitepages.id = imagegallery.pageid
					and ImageGallery.SUBSITEID = subsites.ID
					and imagegallery.categoryid = imagecategories.id
					and imagegallery.versionstate = 2
					and imagegallery.pageid = #pageid#			
	</cfquery>

	<cfscript>
		stData.filename = imgdata.filename;
		stdata.imagesurl = imgdata.imagesurl;
		stdata.imagesdir = imgdata.imagesdir;
		stdata.pageid = imgdata.pageid;
		stdata.description = imgdata.description;
		stdata.category = imgdata.category;
		stdata.categoryid = imgdata.categoryid;
		stdata.subsiteid = imgdata.subsiteid;
		stdata.ownerid = imgdata.ownerid;
	</cfscript>

	<cfreturn stData>

</cffunction>



 <cffunction name="ownershipTake" access="public" output="false" returntype="boolean" hint="Returns page information for a set of page ids">
  	<cfargument name="datasource" type="string" required="yes" hint="CommonSpot site datasource">
	<cfargument name="pageid" type="numeric" required="yes" hint="CommonSpot Page ID">
	<cfargument name="userid" type="numeric" required="yes" hint="CommonSpot User ID">
	
	<cftransaction>
	<cfquery  datasource="#arguments.datasource#">
		update data_fieldvalue
		set authorid = #userid#, versionstate = 3
		where pageid=#pageid#
		and versionstate = 5
	</cfquery>
	
	<cfquery datasource="#arguments.datasource#">
		delete from approval
		where pageid=#pageid#
	</cfquery>
	
	<cfquery datasource="#arguments.datasource#">
		update data_wddx
		set authorid = #userid#, versionstate = 3
		where pageid=#pageid#
		and versionstate = 5
	</cfquery>
	
	<cfquery  datasource="#arguments.datasource#">
		update data_textblock
		set authorid = #userid#, versionstate = 3
		where pageid=#pageid#
		and versionstate = 5
	</cfquery>
	
	<cfquery  datasource="#arguments.datasource#">
		update param_wddx
		set authorid = #userid#, versionstate = 3
		where pageid=#pageid#
		and versionstate = 5
 	</cfquery>

</cftransaction>

  <cfreturn 1>
	
</cffunction>



<cffunction name="PageTitleSet" access="public" output="false" returntype="boolean" hint="Sets page title and page caption for a CommonSpot page">
 	<cfargument name="Datasource" type="string" required="yes" hint="Datasource name">
	<cfargument name="title" type="string" required="yes"  hint="Page Title">
	<cfargument name="pageid" type="numeric" required="yes" hint="CommonSpot Page ID">
			
		<cfquery datasource="#arguments.datasource#">
			update sitepages
			set title = N'#trim(arguments.title)#', caption = N'#trim(arguments.title)#'
			where id = #arguments.pageid#
	 	</cfquery>
	
	<cfreturn 1>
</cffunction>



<cffunction name="PageDescriptionSet" access="public" output="false"
returntype="boolean" hint="Sets page description for a CommonSpot page">
       <cfargument name="Datasource" type="string" required="yes"
hint="Datasource name">
       <cfargument name="description" type="string" required="yes"
hint="Page Description">
       <cfargument name="pageid" type="numeric" required="yes"
hint="CommonSpot Page ID">

       <cfif trim(arguments.description) is not "">
        <cfquery datasource="#arguments.datasource#">
               update sitepages
               set description =
N'#trim(left(arguments.description,2000))#'
               where id = #arguments.pageid#
        </cfquery>
       </cfif>

       <cfreturn 1>
</cffunction>



<cffunction name="SubsitesGet" access="remote" output="false" returntype="Query" hint="Returns query of CommonSpot subsites">
	<cfargument name="datasource" type="string" required="yes" hint="CommonSpot DSN">
	
	<cfset var qCommonSpotSubsites = "">
	<cfquery name="qCommonSpotSubsites" datasource="#arguments.datasource#">
		select sitepages.name, subsites.id, subsites.parentid 
		from sitepages, subsites
		where subsites.securitypageid = sitepages.id
		order by subsites.parentid, sitepages.name
	</cfquery>
	
	<cfreturn qCommonSpotSubsites>
</cffunction>



<cffunction name="CustomElementDefinitionsGet" access="public" output="false" returntype="query" hint="Retuns information about custom elements and metadata forms">
	<cfargument name="datasource" type="string" required="yes" hint="CommonSpot DSN">
	
	<cfset var qobjects = "">
	<cfquery name="qobjects" datasource="#arguments.datasource#">
		select formcontrol.id, 
				 formcontrol.formname,
				 forminputcontrolmap.fieldid,
				 forminputcontrol.fieldname
		from formcontrol, forminputcontrolmap,forminputcontrol
		where 
			formcontrol.id = forminputcontrolmap.formid
			and forminputcontrolmap.fieldid = forminputcontrol.id
			and (formcontrol.method = '' or formcontrol.action = 'special')
		order by formcontrol.formname, forminputcontrol.fieldname
	</cfquery>

	<cfreturn qobjects>
</cffunction>



<cffunction name="ImageGetDetails" access="public" output="false" returntype="struct" hint="Returns image height, width, and description">
	<cfargument name="datasource" type="string" required="Yes">
	<cfargument name="url" type="string" required="yes" hint="url of image, starting with /">

	<cfset var filename = listlast(url,"/")>
	<cfset var dir = replace(url,"images/" & filename,"","ALL")>
	<cfset var stImage = structnew()>
	<cfset var qgetdata = "">

	<cfquery name="qgetdata" datasource="#arguments.datasource#">
		select imagegallery.*
		from imagegallery, subsites
		where imagegallery.subsiteid = subsites.id
		and subsites.subsiteurl = '#dir#'
		and imagegallery.filename = '#filename#'
		and imagegallery.versionstate = 2
	</cfquery>

	<cfif qgetdata.recordcount gt 0>
		<cfscript>
			stImage.height = qgetdata.origheight;
			stImage.width = qgetdata.origwidth;
			stImage.description = qgetdata.description;
		</cfscript>
	</cfif>
	
	<cfreturn stImage>

</cffunction>



<cffunction name="PageDelete" access="private" output="False" returntype = "boolean" hint="Removes entries for page from commonspot db">
	<cfargument name="datasource" type="string" required="Yes">
	<cfargument name="pageid" type="numeric" required="Yes">

	<cftransaction>
	<!--- delete from image gallery table --->
	<cfquery  datasource="#arguments.datasource#">
		delete
		from imagegallery 
		where pageid = #pageid#
	</cfquery>
	
	<!--- delete from sitepages table --->
	<cfquery datasource="#arguments.datasource#">
		delete
		from sitepages
		where id = #pageid#
	</cfquery>
	
	<!--- clean up security --->
	<cfquery datasource="#arguments.datasource#">
		delete 
		from itemsecurity
		where pageid = #pageid#
	</cfquery>
	
	<!--- remove metadata --->
	<cfquery datasource="#arguments.datasource#">
		delete
		from data_fieldvalue
		where pageid = #pageid#
	</cfquery>
	</cftransaction>

	<cfreturn true>
</cffunction>



<cffunction name="ImageDelete" access="Public" output="False" returntype="boolean" hint="Deletes an image from the image gallery">
	<cfargument name="datasource" type="string" required="Yes">
	<cfargument name="pageid" type="numeric" required="Yes">
	
	<cfset var qimage = 0 />
	
		<!--- get image info --->
		<cfquery name="qimage" datasource="#arguments.datasource#">
			select imagesdir, filename
			from subsites, sitepages
			where sitepages.subsiteid = subsites.id
			and sitepages.id = #pageid#
		</cfquery>
		
		<cfset PageDelete (arguments.datasource, pageid)>

		<!--- remove image file from disk --->
		<cfif fileExists("#qimage.imagesdir##qimage.filename#")>
			<cffile action="Delete" file="#qimage.imagesdir##qimage.filename#">
    		</cfif>
	
	<cfreturn "true">

</cffunction>



<cffunction name="UploadedFileDelete" access="Public" output="False" returntype="boolean" hint="Deletes an image from the image gallery">
	<cfargument name="datasource" type="string" required="Yes">
	<cfargument name="pageid" type="numeric" required="Yes">
	
	<cfset var retval = false>
	<cfset var qcount = "">
	<cfset var qcount2= "">
	<cfset var qimage = "">
	<cfset var reval = "" />

	<!--- validate that the image is not in use as a promo or superpromo --->
	<cfquery name="qcount" datasource="#arguments.datasource#-support">
		select count(*) as thecount
		from promo
		where pageid=#pageid#
		and endtime is null
	</cfquery>

	<cfquery name="qcount2" datasource="#arguments.datasource#-support">
		select count(*) as thecount
		from superpromo
		where pageid=#pageid#
		and endtime is null
	</cfquery>

	<!--- delete actions --->
	<cfif qcount.thecount gt 0 or qcount2.thecount gt 0>
		<cfset retval = false>
	<cfelse>	
	
		<!--- get image info --->
		<cfquery name="qimage" datasource="#arguments.datasource#">
			select uploaddir, filename
			from subsites, sitepages
			where sitepages.subsiteid = subsites.id
			and sitepages.id = #pageid#
		</cfquery>
		
		<cfset PageDelete(arguments.datasource, pageid)>
		

		<!--- remove image file from disk --->
		<cfif fileExists("#qimage.uploaddir##qimage.filename#")>
			<cffile action="Delete" file="#qimage.uploaddir##qimage.filename#">
		</cfif>
    
		<cfset retval = true>
	</cfif>
   
	<cfreturn retval>
</cffunction>


 
<cffunction name="syncfiles" access="public" output="false" returntype="boolean" hint="Queue a file to sync on slave servers">
	<cfargument name="filename" type="string" required="Yes" hint="The name of the file to transfer to the slaves">

	<cfset var qservers = "">
	<cfset var qgetid = 0 />
	<cfset var theid = 0 />
	
	<cfquery name="qservers" datasource="commonspot-sites">
		select *
		from servers
		where servertype = 1
    </cfquery>

	<cfloop query="qservers">

		<cftransaction>
		<cfquery name="qgetid" datasource="commonspot-sites">
			select max(transactionid) as nextid from fileactionqueue
		</cfquery>
		<cfif qgetid.nextid is ""><cfset qgetid.nextid = 0></cfif>
		<cfset theid = qgetid.nextid + 1>
		<cfquery datasource="commonspot-sites">
			insert into fileactionqueue (transactionid,sourceserverid, destserverid, actioncode, file1, file2, filemode, fileattrs, transactiontimestamp, reasoncode)
				values (#theid#, 1,#qservers.id#,'COPY','#replace(filename,"\","/","ALL")#','#replace(filename,"\","/","ALL")#','744','Archive,Normal','#dateformat(now(),"yyyy-mm-dd")# #timeformat(now(),"HH:mm:ss")#',0)
		</cfquery>


		</cftransaction>
	</cfloop>

	<cfreturn true>

</cffunction>



<cffunction name="ImageUpdateDB" access="public" output="false" returntype="numeric" hint="Create image reference in database">
	<cfargument name="datasource" type="string" required="yes" hint="data source for commonspot content">
	<cfargument name="pageid" type="numeric" required="Yes" hint="CommonSpot Page ID, use -1 to for new image">
	<cfargument name="authorid" type="numeric" required="Yes" hint="Commonspot User ID">
	<cfargument name="subsiteid" type="numeric" required="Yes" hint="CommonSpot Subsite ID">
	<cfargument name="filespec" type="string" required="Yes" hint="Full file path (windows)">
	<cfargument name="description" type="string" required="Yes" hint="text description (unicode)">
	<cfargument name="categoryid" type="string" required="Yes" hint="CommonSpot Category ID">
	<cfargument name="width" type="numeric" required="yes" hint="Image Width">
	<cfargument name="height" type="numeric" required="yes" hint="Image Height">
	<cfargument name="filesize" type="numeric" required="no" default="0" hint="Image file size">
	
	<cfset var logdatetime = '#dateformat(now(),"yyyy-mm-dd")# #timeformat(now(),"HH:mm:ss")#'>		
	<cfset var qins = 0 />
	<cfset var insSitePages = 0 />

	<cfif arguments.pageid lt 0 > <!--- insert --->
	
		<cfmodule template="/commonspot/utilities/getid.cfm"
				 targetvar="pageid"
				 datasource="#datasource#">

		<cftransaction>
			<cfquery name="qins" datasource="#datasource#">	
				insert into imagegallery (pageid, 
						controlid,
						versionid,
						versionstate,
						action,
						authorid,
						ownerid,
						dateadded,
						dateapproved,
						datelastcurrent,
						subsiteid,
						filename,
						localfilename,
						description,
						categoryid,
						ext,
						ispublic,
						origheight,
						origwidth,
						filesize
						)
			values (
			  #pageid#,
			  0,
			  0,
			  2,
			  0,
			  #authorid#,
			  #authorid#,
			  '#logdatetime#',
			  '#logdatetime#',
			  '#logdatetime#',
			  #subsiteid#,
			  '#listlast(filespec,"/")#',
			  NULL,
			  N'#description#',
			  #categoryid#,
			  '#right(filespec,3)#',
			  1,
			  '#height#',
			  '#width#',
			  #filesize# <!--- need to figure out size later --->
			)
		</cfquery>


		<cfquery name="insSitePages" datasource="#datasource#">
			INSERT	INTO SitePages
				(ID,
				Name,
				DateAdded,
				SubSiteID,
				FileName,
				CategoryID,
				CreatorID,
				OwnerID,
				Confidentiality,
				IsPublic,
				AudienceCategory, 
				PageType,
				DateContentLastModified, 
				DateContentLastChecked,
				DateContentLastMajorRevision,
				PublicReleaseDate)
			VALUES
			(#pageid#,
			'#listlast(filespec,"/")#',
			'#logdatetime#',
			#subsiteid#, <!--- root subsite --->
			'#listlast(filespec,"/")#',
			#categoryid#,
			#authorid#,
			#authorid#,
			0<!--- Confidentiality --->,
			1<!--- IsPublic --->,
			1,
			3<!--- PageType --->,
			'#logdatetime#',
			'#logdatetime#',  
			'#logdatetime#',
			'#logdatetime#')
		</cfquery>
	 </cftransaction>	
	<cfelse> <!--- update --->
		<cftransaction>
			<cfquery datasource="#datasource#">
				update imagegallery
				set origwidth = #width#,
					origheight = #height#,
					filesize = #filesize#
				where pageid = #pageid#
					and versionstate = 2
			</cfquery>
			<cfquery datasource="#datasource#">
				update sitepages
				set DateContentLastModified = '#logdatetime#',
					dateContentLastMajorRevision = '#logdatetime#'
				where id = #pageid#
			</cfquery>
		</cftransaction>
	</cfif>

 <cfset syncFiles(filespec)>

 <cfreturn pageid>
</cffunction>



<cffunction name="search" access="remote" output="false" returntype="query" hint="perform verity or google search across site">
	<cfargument name="datasource" type="string" required="yes" hint="data source for commonspot content">
	<cfargument name="subsite" type="String" required="Yes" hint="path of commonspot subsite to search">
	<cfargument name="startdate" type="string" required="yes" hint="create startdate">
	<cfargument name="enddate"   type="string" required="yes" hint="create enddate range">
	<cfargument name="maxrows"   type="numeric" required="no" default="50">
	<cfargument name="searchterm" type="string" required="no" hint="full text search term" default="">
	<cfargument name="lmetadataids" type="string" required="no" hint="FLEET list of metadata ids" default="">
	
	<cfif application.figleaf.searchtype is "google">
		<cfreturn searchGoogle(argumentCollection=arguments)/>
	<cfelse>
		<cfreturn searchVerity(argumentCollection=arguments)/>
	</cfif>
</cffunction>



<cffunction name="searchGoogle" access="private" output="false" returntype="query" hint="perform verity search across site">
	<cfargument name="datasource" type="string" required="yes" hint="data source for commonspot content">
	<cfargument name="subsite" type="String" required="Yes" hint="path of commonspot subsite to search">
	<cfargument name="startdate" type="string" required="yes" hint="create startdate">
	<cfargument name="enddate"   type="string" required="yes" hint="create enddate range">
	<cfargument name="maxrows"   type="numeric" required="no" default="50">
	<cfargument name="searchterm" type="string" required="no" hint="full text search term" default="">
	<cfargument name="lmetadataids" type="string" required="no" hint="FLEET list of metadata ids" default="">

	<cfset var searchParams = ''>
	<cfset var lpageids = ''>
	<cfset var search_xml = ''>
	<cfset var results = ''>
	<cfset var i = 0 />
	
	<cfscript>
		searchParams = listAppend(searchParams,'getfields=*','&');
		searchParams = listAppend(searchParams,'q=#urlencodedformat(arguments.searchterm)#','&');
		searchParams = listAppend(searchParams,'num=100','&');
		searchParams = listAppend(searchParams,'output=xml_no_dtd','&');
		searchParams = listAppend(searchParams,'site=default_collection','&');
		searchParams = listAppend(searchParams,'client=default_frontend','&');
	</cfscript>	
	
	<cfhttp url="#application.figleaf.googleurl#?#searchParams#" method="get" />

	<cfif cfhttp.StatusCode eq "200 OK">
		<cfset search_xml = xmlParse(trim(cfhttp.FileContent))>
		<cfset results=xmlSearch(search_xml,"/GSP/RES/R/MT[@N='cspageid']")>
		
		<cfloop from="1" to="#arrayLen(results)#" index="i">
			<cfset lpageids = listAppend(lpageids,results[i].xmlAttributes.V)>
		</cfloop>
		<cfif listLen(lpageids)>
			<cfset arguments.lpageids = lpageids>
		</cfif>
	</cfif>
	
	<cfreturn getSearchPageDetails(argumentCollection=arguments)/>
</cffunction>



<cffunction name="searchVerity" access="private" output="false" returntype="query" hint="perform verity search across site">
	<cfargument name="datasource" type="string" required="yes" hint="data source for commonspot content">
	<cfargument name="subsite" type="String" required="Yes" hint="path of commonspot subsite to search">
	<cfargument name="startdate" type="string" required="yes" hint="create startdate">
	<cfargument name="enddate"   type="string" required="yes" hint="create enddate range">
	<cfargument name="maxrows"   type="numeric" required="no" default="50">
	<cfargument name="searchterm" type="string" required="no" hint="full text search term" default="">
	<cfargument name="lmetadataids" type="string" required="no" hint="FLEET list of metadata ids" default="">

	<cfset var qveritycollections = "">
	<cfset var qsearchresults = "">
	<cfset var lpageids = "">

	<cfif len(trim(arguments.searchterm))>
	
	  <cfset qsearchresults = "0">
	
	  <cfquery name="qveritycollections" datasource="#arguments.datasource#">
		select distinct veritycollection
		from subsites
		where subsiteurl = <cfqueryparam value="#arguments.subsite#" cfsqltype="cf_sql_varchar">
	  </cfquery>

	  <cfsearch name="qsearchresults"
			collection="#valuelist(qveritycollections.veritycollection)#"
		    type="internet"
			criteria="#arguments.searchterm#"
			maxrows="500">
			
	  <cfloop query="qsearchresults">
		  <cfset lpageids = listappend(lpageids,listgetat(qsearchresults.custom1,3))>		
	  </cfloop>
	  
	  <cfset arguments.lpageids = lpageids>
	</cfif>		
	<cfreturn getSearchPageDetails(argumentCollection=arguments)/>
</cffunction>



<cffunction name="getSearchPageDetails" access="private" output="false" returntype="query">
	<cfargument name="datasource" type="string" required="yes" hint="data source for commonspot content">
	<cfargument name="subsite" type="String" required="Yes" hint="path of commonspot subsite to search">
	<cfargument name="startdate" type="string" required="yes" hint="create startdate">
	<cfargument name="enddate"   type="string" required="yes" hint="create enddate range">
	<cfargument name="maxrows"   type="numeric" required="no" default="50">
	<cfargument name="lmetadataids" type="string" required="no" hint="FLEET list of metadata ids" default="">
	<cfargument name="lpageids" type="string" required="false" default="" hint="List of page ids that match the search">
	
	<cfset var qsearchresults = 0 />
<!--- 	
	<cfif arguments.lmetadataids is not "">
		<cfset arguments.lpageids = application.newsArticle.relatedarticlessuggest (datasource = application.figleaf.supportdsn, lmetadataids = arguments.lmetadataids, maxrows = 200)>
	</cfif>
 --->

	<cfquery name="qsearchresults" datasource="#arguments.datasource#" maxrows="#arguments.maxrows#">
		select sitepages.filename, subsites.subsiteurl, sitepages.title, sitepages.caption, sitepages.description, sitepages.id, sitepages.datecontentlastmodified
		from sitepages, subsites
		where sitepages.subsiteid = subsites.id
		and subsites.subsiteurl like '#arguments.subsite#%'
		and sitepages.pagetype in (0)
		<cfif isDefined("arguments.startdate") AND isDate(arguments.startdate)>
			<cfset arguments.startdate = parsedatetime(arguments.startdate)>
			and sitepages.datecontentlastmodified >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#">
		</cfif>
		<cfif isDefined("arguments.enddate") AND isDate(arguments.enddate)>
			<cfset arguments.enddate = parsedatetime(arguments.enddate)>
			and sitepages.datecontentlastmodified < <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.enddate#">
		</cfif>		
		<cfif len(trim(arguments.searchterm))>
			<cfif len(trim(lpageids))>
			and sitepages.id in (<cfqueryparam  cfsqltype="cf_sql_integer" value="#arguments.lpageids#" list="true">)
			<cfelse>
			and sitepages.id = 0
			</cfif>
		</cfif>
	</cfquery>		

	<cfreturn qsearchresults/>
</cffunction>



<cffunction name="Elementsearch" access="public" output="false" returntype="query" hint="perform verity search across site">
	<cfargument name="datasource" type="string" required="yes" hint="data source for commonspot content">
	<cfargument name="subsite" type="String" required="Yes" hint="path of commonspot subsite to search">
	<cfargument name="startdate" type="string" required="yes" hint="create startdate">
	<cfargument name="enddate"   type="string" required="yes" hint="create enddate range">
	<cfargument name="maxrows"   type="numeric" required="no" default="50">
	<cfargument name="searchterm" type="string" required="no" hint="full text search term" default="">
	<cfargument name="lmetadataids" type="string" required="no" hint="FLEET list of metadata ids" default="">
	<cfargument name="formid" type="numeric" required="yes" hint="CommonSpot element form id">

	<cfset var qresults = 0 />
	<cfset var qresults2 = search (arguments.datasource, arguments.subsite, arguments.startdate, arguments.enddate, arguments.maxrows, arguments.searchterm, arguments.lmetadataids)>
	<cfset var lIds = valuelist(qresults2.id)>

	<cfset lIds = listappend(lIds,"0")>

	<cfquery name="qresults" datasource="#datasource#">
		select distinct sitepages.filename, subsites.subsiteurl, sitepages.title, sitepages.caption, sitepages.description, sitepages.id, sitepages.datecontentlastmodified
		from sitepages, subsites, data_fieldvalue
		where sitepages.subsiteid = subsites.id
			and sitepages.id = data_fieldvalue.pageid
			and data_fieldvalue.versionstate = 2
			and data_fieldvalue.formid = #arguments.formid#
			and sitepages.id in (#lIds#)
		order by sitepages.datecontentlastmodified desc
	</cfquery>

	<cfreturn qresults>
</cffunction>
</cfcomponent>
