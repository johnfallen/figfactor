
<!--- Document Information -----------------------------------------------------
Title: 				generatebitmaps.cfm
Author:				John Allen
Email:					jallen@figleaf.com
Company:			Figleaf Software
Website:			http://www.nist.gov

Purpose:			I call the MetaDataKeywordService.BitmaskGenerate() funciton.

================================================================================
John Allen		17/08/2008		Created
------------------------------------------------------------------------------->

<cfset factory = Application.BeanFactory.getBean("BeanFactory") />
<cfset config = factory.getBean("ConfigBean") />

<cfinclude template="#config.getFigLeafFileContext()#/com/index.cfm" />

<cfset fleet = factory.getBean("Fleet") />
<cfset metaDataServcice = fleet.getService("metadataservice") />
<cfset results = metaDataServcice.getMetaDataKeywordService().BitmaskGenerate() />
<cflocation url="#cgi.HTTP_REFERER#?message=Bitmapgeneration sucessful.">
