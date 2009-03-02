<cfsilent>
<!--- Document Information -----------------------------------------------------
Title: 				index.cfm
Author:				John Allen
Email:					jallen@figleaf.com
Company:			Figleaf Software
Website:			http://www.nist.gov

Purpose:			I light up the MetaDataService by includiing a file.

Usage:				None. I include a file that starts MetaDataService.

================================================================================
John Allen		18/08/2008		Created
------------------------------------------------------------------------------->

<!--- ************************************* SETUP / LOGIC  *****************************  --->

<cfset factory = Application.BeanFactory.getBean("BeanFactory") />

<cfset fleet = factory.getBean("Fleet") />
<cfset config = factory.getBean("ConfigBean") />
<cfset metaDataServcice = fleet.getService("metadataservice") />


<!--- ************************************* OUTPUT *************************************  --->
</cfsilent>

<cfoutput>
<h1>MetaData Administration</h1>
<ul>
	<li><a href="#config.getMetaDataUISupportEditDirectory()#/metadata/edit/index.cfm">Edit</a></li>
	<li><a href="#config.getMetaDataUISupportEditDirectory()#/metadata/bitmapgeneration/index.cfm">Generate BitMasks</a></li>
</ul>
</body>
</cfoutput>
