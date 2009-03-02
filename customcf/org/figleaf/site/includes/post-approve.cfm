<!--- Document Information -----------------------------------------------------
Title: 				post-approve.cfm
Author:				?????
Email:					jallen@figleaf.com
Company:			Figleaf Software
Website:			http://www.nist.gov
Purpose:			
Usage:				
History:
Name					Date				
================================================================================
?????					19/10/2008		Created
------------------------------------------------------------------------------->

<!--- 
only run once.  
Post-approve will execute once for every field in the page elements
This does not get called for page level metadata (control 0)
--->
<cfset factory = Application.BeanFactory.getBean("BeanFactory") />
<cfset config = factory.getBean("ConfigBean") />
<cfset dsn = config.getCommonSpotDSN() />
<cfset PageMetaData = factory.getBean("Fleet").getService("PageMetaData") />

<!--- if the controll id is correct (2 cases), and the request var hasen't been set --->
<cfif (config.getFleetControllID() eq 0 or attributes.controlid is config.getFleetControllID()) 
	and 
	not isdefined("request.bFLSMetaDataWasSaved")>

	<cfquery name="fleetForm" datasource="#dsn#">
		select 
			m.formID, m.fieldID
		from 
			FormInputControlMap m
		join 
			FormInputControl f on m.fieldID = f.id
		where 
			f.fieldname = '#config.getFleetMetaDataFieldName()#'
	</cfquery>

	<!--- get metadata field from db, currently stores data as comma delimited list --->
	<cfquery name="qgetdata" datasource="#dsn#">
		select 
			top 1 fieldvalue, versionid
		from 
			data_fieldvalue
		where  
			pageid = #attributes.pageid#
		and 
			formid = #fleetForm.formID#
		and 
			fieldid = #fleetForm.fieldID#
		order by versionid desc
	</cfquery>

	<cfif qgetdata.recordcount is 1 and qgetdata.fieldvalue is not "">
		<cfset PageMetaData.set
			(
				objectid = attributes.pageid, 
				controlid = attributes.controlid, 
				lmetadataids = qgetdata.fieldvalue,
				updateuser = session.user.name
			) />
	</cfif>
	
	<!--- set this var, its used at the top of this code --->
	<cfset request.bFLSMetaDataWasSaved = true />
</cfif>