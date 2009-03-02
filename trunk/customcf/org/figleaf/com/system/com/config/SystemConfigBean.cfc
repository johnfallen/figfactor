<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		SystemConfigBean.cfc
Author:     		John Allen
Email:      		jallen@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@
Purpose:    	I persist configuration data for Fig Leaf sub applications
Usage:      		I provide getters and setters for all of my properties.

HERE IS AN ECLIPSE SNIPPET FOR CODE GENERATION:
-------------------------------------------------------------------------------------------

<cfset var $${Name} = trim(getProfileString(inipath, "$${INISpace}", "$${INIVariable}")) />

<cfset set$${Name}($${Name}) />

<!--- $${Name} --->
<cffunction name="set$${Name}" access="$${SetterAccess:public|private|remote}" output="false" 
	hint="I set the $${Name} property.">
	<cfargument name="$${Name}" hint="I am the $${Name}." />
	<cfset variables.instance.$${Name} = arguments.$${Name} />
</cffunction>
<cffunction name="get$${Name}" access="public" output="false" 
	hint="I return the $${Name} property.">
	<cfreturn variables.instance.$${Name}  />
</cffunction>

-------------------------------------------------------------------------------------------
Modification Log:
Name 			Date 					Description
================================================================================
John Allen 		21/08/2008			Created
John Allen 		23/09/2008			Added all the reload, urlrecach stuff and the
											CONSTANTS structure.
------------------------------------------------------------------------------->
<cfcomponent displayname="System Config Bean" output="false"
	hint="I persist configuration data for Fig Leaf sub applications">

<cfset variables.instance = structNew() />

<!--- 
SYSTEM WIDE CONSTANTS 
--->
<cfset variables.instance.CONSTANTS = structNew() />
<cfset variables.instance.CONSTANTS.DATANOTFOUND = "DATANOTFOUND" />
<cfset variables.instance.CONSTANTS.VIEW_FRAME_WORK_EXTENSION_COMPONENT_NAME = "ViewFrameworkExtension.cfc" />
<cfset variables.instance.CONSTANTS.VIEW_FRAME_WORK_LIST_EXTENSION_FILE_NAME = "view-framework-list-mixen.cfm" />
<cfset variables.instance.CONSTANTS.DEVELOPMENT_DIRECTORY = "site" />
<cfset variables.instance.CONSTANTS.INCLUDE_DIRECTORY = "includes" />
<cfset variables.instance.CONSTANTS.FRAMEWORK_FILE_PATH = "" />


<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="SystemConfigBean" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="frameworkPath" type="string" required="true" 
		hint="I am the system path customcf/org/figleaf directory.<br />I am required." />

	<cfset var thePath = arguments.frameworkPath />

	<cfset var inipath = "#getDirectoryFromPath(GetCurrentTemplatePath())#/systemconfiguration.ini.cfm" >
	
	<!--- system --->
	<cfset var Reload = trim(getProfileString(inipath, "system", "reload")) />
	<cfset var InstanceName = trim(getProfileString(inipath, "system", "instance_name")) />
	<cfset var SystemMode = trim(getProfileString(inipath, "system", "system_mode")) />
	<cfset var URLRelaodKey = trim(getProfileString(inipath, "system", "url_reload_key")) />
	<cfset var URLReloadKeyValue = trim(getProfileString(inipath, "system", "url_reload_key_value")) />
	<cfset var CommonSpotDSN = trim(getProfileString(inipath, "system", "commonspot_dsn")) />
	<cfset var DefaultCacheType = trim(getProfileString(inipath, "system", "default_cache_type")) />
	<cfset var WebSiteContext = trim(getProfileString(inipath, "system", "website_context")) />
	<cfset var FigLeafFileContext = trim(getProfileString(inipath, "system", "figleaf_file_context")) />
	<cfset var FigLeafComponentContext = trim(getProfileString(inipath, "system", "figleaf_component_context")) />
	<cfset var WebSiteServerContext = trim(getProfileString(inipath, "system", "web_site_server_context")) />
	<cfset var ProductionServerIPList = trim(getProfileString(inipath, "system", "production_server_ip_list")) />
	<cfset var AdministratorEmail = trim(getProfileString(inipath, "system", "administrator_email")) />
	<cfset var WebMasterEmail = trim(getProfileString(inipath, "system", "webmaster_email")) />
	<cfset var DeveloperEmail = trim(getProfileString(inipath, "system", "developer_email")) />
	<cfset var MailServer = trim(getProfileString(inipath, "system", "mail_server")) />
	<cfset var MailUsername = trim(getProfileString(inipath, "system", "mail_username")) />
	<cfset var MailPassword = trim(getProfileString(inipath, "system", "mail_password")) />
	<cfset var InputPresidence = trim(getProfileString(inipath, "system", "input_presidence")) />
	<cfset var FigLeafSystemVersion = trim(getProfileString(inipath, "system", "system_version")) />

	<!--- fleet --->
	<cfset var CommonSpotSupportDSN = trim(getProfileString(inipath, "fleet", "commonspot_support_dsn")) />
	<cfset var FleetMetaDataFieldName = trim(getProfileString(inipath, "fleet", "fleet_meta_data_field_name")) />
	<cfset var FleetControllID = trim(getProfileString(inipath, "fleet", "fleet_Controll_ID")) />
	<cfset var EnableFleet = trim(getProfileString(inipath, "fleet", "enable_fleet")) />
	<cfset var EnableFileAsset = trim(getProfileString(inipath, "fleet", "enable_fileasset")) />
	<cfset var EnableMetaData = trim(getProfileString(inipath, "fleet", "enable_metadata")) />
	<cfset var EnableReleatedLinks = trim(getProfileString(inipath, "fleet", "enable_releated_links")) />
	<cfset var EnableSiteRipper = trim(getProfileString(inipath, "fleet", "enable_site_ripper")) />
	<cfset var MetaDataUISupportEditDirectory = trim(getProfileString(inipath, "Fleet", "meta_data_ui_support_edit_directory")) />
	<cfset var MetaDataUISupportJSDirectory = trim(getProfileString(inipath, "fleet", "meta_data_ui_support_js_directory")) />
	<cfset var SiteRipperURL = trim(getProfileString(inipath, "fleet", "site_ripper_url")) />
	<cfset var SiteRipperCFURL = trim(getProfileString(inipath, "fleet", "site_ripper_cfurl")) />
	<cfset var FleetVersion = trim(getProfileString(inipath, "fleet", "fleet_version")) />
	
	<!--- viewframework --->
	<cfset var PageTypeMetaDataFromName = trim(getProfileString(inipath, "viewframework", "page_type_metadata_form_name")) />
	<cfset var PageTypeMetaDataFormFieldName = trim(getProfileString(inipath, "viewframework", "page_type_metadata_form_field_name")) />
	<cfset var EnableViewFramework = trim(getProfileString(inipath, "viewframework", "enable_viewframework")) />
	<cfset var DefaultCSSClass = trim(getProfileString(inipath, "viewframework", "default_css_class")) />
	<cfset var UIDirectory = trim(getProfileString(inipath, "viewframework", "ui_directory")) />
	<cfset var CSSDirectory = trim(getProfileString(inipath, "viewframework", "css_directory")) />
	<cfset var ImageDirectory = trim(getProfileString(inipath, "viewframework", "image_directory")) />
	<cfset var RederHandlerDirectory = trim(getProfileString(inipath, "viewframework", "render_handler_directory")) />
	<cfset var IncludesDirectory = trim(getProfileString(inipath, "viewframework", "includes_directory")) />
	<cfset var ImplementDataservice = trim(getProfileString(inipath, "viewframework", "implement_dataservice")) />
	<cfset var ViewFrameworkVersion = trim(getProfileString(inipath, "viewframework", "viewframework_version")) />
	
	<!--- dataservice --->
	<cfset var CacheTimeValue = trim(getProfileString(inipath, "dataservice", "cache_time_value")) />
	<cfset var CacheTimeSpan = trim(getProfileString(inipath, "dataservice", "cache_time_span")) />
	<cfset var CacheReapTime = trim(getProfileString(inipath, "dataservice", "cache_reap_time")) />
	<cfset var DefaultCache = trim(getProfileString(inipath, "dataservice", "default_cache")) />
	<cfset var URLCacheReloadKey = trim(getProfileString(inipath, "dataservice", "url_cache_reload_key")) />
	<cfset var URLCacheRelaodValue = trim(getProfileString(inipath, "dataservice", "url_cache_reload_value")) />
	<cfset var GatewayRuntimeMode = trim(getProfileString(inipath, "dataservice", "gateway_runtime_mode")) />
	<cfset var StoreXMLDiskCache = trim(getProfileString(inipath, "dataservice", "store_xml_disk_cache")) />
	<cfset var SupportDataSourceOne = trim(getProfileString(inipath, "dataservice", "support_datasource_1")) />
	<cfset var SupportDataSourceTwo = trim(getProfileString(inipath, "dataservice", "support_datasource_2")) />
	<cfset var DataserviceVersion = trim(getProfileString(inipath, "dataservice", "dataservice_version")) />
	
	<!--- authentication --->
	<cfset var EnableAuthentication = trim(getProfileString(inipath, "authentication", "enable_authentication")) />
	<cfset var Realm = trim(getProfileString(inipath, "authentication", "realm")) />
	<cfset var AuthenticationURL = trim(getProfileString(inipath, "authentication", "authentication_url")) />
	<cfset var AuthenticationTestURL = trim(getProfileString(inipath, "authentication", "authentication_test_url")) />
	<cfset var AuthenticationMode = trim(getProfileString(inipath, "authentication", "authentication_mode")) />
	<cfset var ForcePass = trim(getProfileString(inipath, "authentication", "authentication_force_pass")) />
	<cfset var AuthenticationVersion = trim(getProfileString(inipath, "authentication", "authentication_version")) />
	
	<!--- search --->
	<cfset var SearchType = trim(getProfileString(inipath, "search", "search_type")) />
	<cfset var GoogleURL = trim(getProfileString(inipath, "search", "google_url")) />
	<cfset var GoogleSiteScope = trim(getProfileString(inipath, "search", "google_site_scope")) />
	<cfset var GoogleResultsNumber = trim(getProfileString(inipath, "search", "google_results_number")) />
	<cfset var GoogleGetFields = trim(getProfileString(inipath, "search", "google_getfields")) />
	<cfset var GoogleClient = trim(getProfileString(inipath, "search", "google_client")) />
	<cfset var GoogleAccess = trim(getProfileString(inipath, "search", "google_access")) />
	<cfset var GoogleButtonText = trim(getProfileString(inipath, "search", "google_buttonText")) />
	<cfset var GoogleIe = trim(getProfileString(inipath, "search", "google_Ie")) />
	<cfset var GoogleOutput = trim(getProfileString(inipath, "search", "google_output")) />
	<cfset var GoogleFilter = trim(getProfileString(inipath, "search", "google_filter")) />
	<cfset var GoogleSortType = trim(getProfileString(inipath, "search", "google_sortType")) />
	<cfset var GoogleProxyReload = trim(getProfileString(inipath, "search", "google_proxyreload")) />
	<cfset var GoogleOutputFormat = trim(getProfileString(inipath, "search", "google_output_format")) />
	<cfset var GoogleDisplaySortOptions = trim(getProfileString(inipath, "search", "google_display_sort_options")) />
	<cfset var GoogleDisplayNumbers = trim(getProfileString(inipath, "search", "google_display_numbers")) />
	<cfset var SearchFormAction = trim(getProfileString(inipath, "search", "search_form_action")) />
	<cfset var SearchFormBreakButton = trim(getProfileString(inipath, "search", "search_form_break_button")) />
	<cfset var SearchFormClass = trim(getProfileString(inipath, "search", "search_form_class")) />
	<cfset var SearchFormID = trim(getProfileString(inipath, "search", "search_form_id")) />
	<cfset var SearchFormName = trim(getProfileString(inipath, "search", "search_form_name")) />
	<cfset var SearchMode = trim(getProfileString(inipath, "search", "search_mode")) />
	
	<!--- multimedia --->
	<cfset var EnableMultimedia = trim(getProfileString(inipath, "multimedia", "enable_multimedia")) />
	<cfset var MediaManagementGroupID = trim(getProfileString(inipath, "multimedia", "media_management_group_id")) />
	<cfset var VideoPlatform = trim(getProfileString(inipath, "multimedia", "video_platfrom")) />
	<cfset var VideoPlatformService  = trim(getProfileString(inipath, "multimedia", "video_platform_service")) />
	
	<!--- validator --->
	<cfset var enableValidator = trim(getProfileString(inipath, "validator", "enable_validator")) />
	
	<!--- nist-specific, if you see this, just delete unless you at NIST! :P --->
	<cfset var FleetRemoteDatasource = trim(getProfileString(inipath, "nist-specific", "FLEET_Remote_Datasource")) />
	<cfset var PublicationsDatasource = trim(getProfileString(inipath, "nist-specific", "Publications_Datasouce")) />
		
	<!--- system --->
	<cfset setReload(Reload) />
	<cfset setInstanceName(InstanceName) />
	<cfset setSystemMode(SystemMode) />
	<cfset setURLRelaodKey(URLRelaodKey) />
	<cfset setURLReloadKeyValue(URLReloadKeyValue) />
	<cfset setCommonSpotDSN(CommonSpotDSN) />
	<cfset setDefaultCacheType(DefaultCacheType) />
	<cfset setWebSiteContext(WebSiteContext) />
	<cfset setFigLeafFileContext(FigLeafFileContext) />
	
	<!--- not read from ini file --->
	<cfset setFigLeafFilePath(thePath) />
	<!--- not read from ini file --->
	<cfset setExtensionsPath(thePath & variables.instance.CONSTANTS.DEVELOPMENT_DIRECTORY) />
	
	<!--- not read from ini file --->
	<cfset setFigLeafIncludeDirectory(
		getFIGLEAFFILECONTEXT() &  "/" & 
		variables.instance.CONSTANTS.DEVELOPMENT_DIRECTORY 
		&  "/" & 
		variables.instance.CONSTANTS.INCLUDE_DIRECTORY) />
	
	
	<cfset setFigLeafComponentContext(FigLeafComponentContext) />
	<cfset setWebSiteServerContext(WebSiteServerContext) />
	<!--- not read from ini file --->
	<cfset setFigLeafApplicationComponentContext() />
	<!--- not read from ini file --->
	<cfset setFigLeafServerContext() />
	<cfset setProductionServerIPList(ProductionServerIPList) />
	<cfset setAdministratorEmail(AdministratorEmail) />
	<cfset setWebMasterEmail(WebMasterEmail) />
	<cfset setDeveloperEmail(DeveloperEmail) />
	<cfset setMailServer(MailServer) />
	<cfset setMailUsername(MailUsername) />
	<cfset setMailPassword(MailPassword) />
	<cfset setInputPresidence(InputPresidence) />
	<cfset setFigLeafSystemVersion(FigLeafSystemVersion) />
	
	<!--- fleet --->
	<cfset setCommonSpotSupportDSN(CommonSpotSupportDSN) />
	<cfset setFleetMetaDataFieldName(FleetMetaDataFieldName) />
	<cfset setFleetControllID(FleetControllID) />
	<cfset setEnableFleet(EnableFleet) />
	<cfset setEnableFileAsset(EnableFileAsset) />
	<cfset setEnableMetaData(EnableMetaData) />
	<cfset setEnableReleatedLinks(EnableReleatedLinks) />
	<cfset setEnableSiteRipper(EnableSiteRipper) />
	<cfset setMetaDataUISupportEditDirectory(MetaDataUISupportEditDirectory) />
	<cfset setMetaDataUISupportJSDirectory(MetaDataUISupportJSDirectory) />
	<cfset setSiteRipperURL(SiteRipperURL) />
	<cfset setSiteRipperCFURL(SiteRipperCFURL) />
	<cfset setFleetVersion(FleetVersion) />

	<!--- viewframework --->
	<cfset setPageTypeMetaDataFormFieldName(PageTypeMetaDataFormFieldName) />
	<cfset setPageTypeMetaDataFromName(PageTypeMetaDataFromName) />
	<cfset setEnableViewFramework(EnableViewFramework) />
	<cfset setDefaultCSSClass(DefaultCSSClass) />
	<cfset setUIDirectory(UIDirectory) />
	<cfset setCSSDirectory(CSSDirectory) />
	<cfset setImageDirectory(ImageDirectory) />
	<cfset setIncludesDirectory(IncludesDirectory) />
	<cfset setImplementDataservice(ImplementDataservice) />
	<cfset setViewFrameworkVersion(ViewFrameworkVersion) />
	<!--- not read from ini file --->
	<cfset setViewFrameworkDirectory() />
	<cfset setRederHandlerDirectory(RederHandlerDirectory) />

	<!--- dataservice --->
	<cfset setCacheTimeValue(CacheTimeValue) />
	<cfset setCacheTimeSpan(CacheTimeSpan) />
	<cfset setCacheReapTime(CacheReapTime) />
	<cfset setDefaultCache(DefaultCache) />
	<cfset seturlCacheReloadKey(urlCacheReloadKey) />
	<cfset setURLCacheRelaodValue(URLCacheRelaodValue) />
	<cfset setGatewayRuntimeMode(GatewayRuntimeMode) />
	<cfset setStoreXMLDiskCache(StoreXMLDiskCache) />
	<cfset setSupportDataSourceOne(SupportDataSourceOne) />
	<cfset setSupportDataSourceTwo(SupportDataSourceTwo) />
	<cfset setDataserviceVersion(DataserviceVersion) />
	
	<!--- authentication --->
	<cfset setEnableAuthentication(EnableAuthentication) />
	<cfset setRealm(Realm) />
	<cfset setAuthenticationURL(AuthenticationURL) />
	<cfset setAuthenticationTestURL(AuthenticationTestURL) />
	<cfset setAuthenticationMode(AuthenticationMode) />
	<cfset setForcePass(ForcePass) />
	<cfset setAuthenticationVersion(AuthenticationVersion) />
	
	<!--- search --->
	<cfset setSearchType(SearchType) />
	<cfset setGoogleURL(GoogleURL) />
	<cfset setGoogleSiteScope(GoogleSiteScope) />
	<cfset setGoogleResultsNumber(GoogleResultsNumber) />
	<cfset setGoogleGetFields(GoogleGetFields) />
	<cfset setGoogleClient(GoogleClient) />
	<cfset setGoogleAccess(GoogleAccess) />
	<cfset setGoogleButtonText(GoogleButtonText) />
	<cfset setGoogleIe(GoogleIe) />
	<cfset setGoogleOutput(GoogleOutput) />
	<cfset setGoogleFilter(GoogleFilter) />
	<cfset setGoogleSortType(GoogleSortType) />
	<cfset setGoogleProxyReload(GoogleProxyReload) />
	<cfset setGoogleOutputFormat(GoogleOutputFormat) />
	<cfset setGoogleDisplaySortOptions(GoogleDisplaySortOptions) />
	<cfset setGoogleDisplayNumbers(GoogleDisplayNumbers) />
	<cfset setSearchFormAction(SearchFormAction) />
	<cfset setSearchFormBreakButton(SearchFormBreakButton) />
	<cfset setSearchFormClass(SearchFormClass) />
	<cfset setSearchFormID(SearchFormID) />
	<cfset setSearchFormName(SearchFormName) />
	<cfset setSearchMode(SearchMode) />
	
	<!--- multimedia --->	
	<cfset setEnableMultimedia(EnableMultimedia) />
	<cfset setMediaManagementGroupID(MediaManagementGroupID) >
	<cfset setVideoPlatform(VideoPlatform) />
	<cfset setVideoPlatformService(VideoPlatformService) />
	
	<!--- validator --->
	<cfset setenableValidator(enableValidator) />
	
	<!--- set the framework file constant, the admin application files use this --->
	<cfset variables.instance.CONSTANTS.FRAMEWORK_FILE_PATH = arguments.frameworkPath />
	
	<cfreturn this />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="any" access="public" output="false"
	displayname="Get Instance" hint="I return my instance data."
	description="I return my internal variables scope.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- getConstants --->
<cffunction name="getConstants" returntype="any" access="public" output="false"
	displayname="Get Constants" hint="I return a structre with system wide constant variables."
	description="I return a structre with system wide constant variables.">
	
	<cfreturn variables.instance.CONSTANTS />
</cffunction>




<!--- FigLeafIncludeDirectory --->
<cffunction name="setFigLeafIncludeDirectory" access="private" output="false" 
	hint="I set the FigLeafIncludeDirectory property.">
	<cfargument name="FigLeafIncludeDirectory" hint="I am the FigLeafIncludeDirectory." />
	<cfset variables.instance.FigLeafIncludeDirectory = arguments.FigLeafIncludeDirectory />
</cffunction>
<cffunction name="getFigLeafIncludeDirectory" access="public" output="false" 
	hint="I return the FigLeafIncludeDirectory property.">
	<cfreturn variables.instance.FigLeafIncludeDirectory />
</cffunction>




<!--- ************** System **************  --->

<!--- Reload --->
<cffunction name="setReload" access="private" output="false" 
	hint="I set the Reload property.">
	<cfargument name="Reload" hint="I am the Reload." />
	<cfset variables.instance.Reload = arguments.Reload />
</cffunction>
<cffunction name="getReload" access="public" output="false" 
	hint="I return the Reload property.">
	<cfreturn variables.instance.Reload  />
</cffunction>
<!--- InstanceName --->
<cffunction name="setInstanceName" access="private" output="false" 
	hint="I set the InstanceName property.">
	<cfargument name="InstanceName" hint="I am the InstanceName." />
	<cfset variables.instance.InstanceName = arguments.InstanceName />
</cffunction>
<cffunction name="getInstanceName" access="public" output="false" 
	hint="I return the InstanceName property.">
	<cfreturn variables.instance.InstanceName  />
</cffunction>
<!--- URLRelaodKey --->
<cffunction name="setURLRelaodKey" access="private" output="false" 
	hint="I set the URLRelaodKey property.">
	<cfargument name="URLRelaodKey" hint="I am the URLRelaodKey." />
	<cfset variables.instance.URLRelaodKey = arguments.URLRelaodKey />
</cffunction>
<cffunction name="getURLRelaodKey" access="public" output="false" 
	hint="I return the URLRelaodKey property.">
	<cfreturn variables.instance.URLRelaodKey  />
</cffunction>
<!--- URLReloadKeyValue --->
<cffunction name="setURLReloadKeyValue" access="private" output="false" 
	hint="I set the URLReloadKeyValue property.">
	<cfargument name="URLReloadKeyValue" hint="I am the URLReloadKeyValue." />
	<cfset variables.instance.URLReloadKeyValue = arguments.URLReloadKeyValue />
</cffunction>
<cffunction name="getURLReloadKeyValue" access="public" output="false" 
	hint="I return the URLReloadKeyValue property.">
	<cfreturn variables.instance.URLReloadKeyValue  />
</cffunction>
<!--- SystemMode --->
<cffunction name="setSystemMode" access="private" output="false" 
	hint="I set the SystemMode property.">
	<cfargument name="SystemMode" hint="I am the SystemMode." />
	<cfset variables.instance.SystemMode = arguments.SystemMode />
</cffunction>
<cffunction name="getSystemMode" access="public" output="false" 
	hint="I return the SystemMode property.">
	<cfreturn variables.instance.SystemMode  />
</cffunction>
<!--- CommonSpotDSN --->
<cffunction name="setCommonSpotDSN" access="private" output="false" 
	hint="I set the CommonSpotDSN property.">
	<cfargument name="CommonSpotDSN" hint="I am the CommonSpotDSN." />
	<cfset variables.instance.CommonSpotDSN = arguments.CommonSpotDSN />
</cffunction>
<cffunction name="getCommonSpotDSN" access="public" output="false" 
	hint="I return the CommonSpotDSN property.">
	<cfreturn variables.instance.CommonSpotDSN  />
</cffunction>
<!--- DefaultCacheType --->
<cffunction name="setDefaultCacheType" access="public" output="false" 
	hint="I set the DefaultCacheType property.">
	<cfargument name="DefaultCacheType" hint="I am the DefaultCacheType." />
	<cfset variables.DefaultCacheType = arguments.DefaultCacheType />
</cffunction>
<cffunction name="getDefaultCacheType" access="public" output="false" 
	hint="I return the DefaultCacheType property.">
	<cfreturn variables.DefaultCacheType  />
</cffunction>



<!--- WebSiteContext --->
<cffunction name="setWebSiteContext" access="private" output="false" 
	hint="I set the WebSiteContext property.">
	<cfargument name="WebSiteContext" hint="I am the WebSiteContext." />
	<cfset variables.instance.WebSiteContext = arguments.WebSiteContext />
</cffunction>
<cffunction name="getWebSiteContext" access="public" output="false" 
	hint="I return the WebSiteContext property.">
	<cfreturn variables.instance.WebSiteContext  />
</cffunction>



<!--- FigLeafFileContext --->
<cffunction name="setFigLeafFileContext" access="private" output="false" 
	hint="I set the FigLeafFileContext property.">
	
	<cfargument name="FigLeafFileContext" hint="I am the FigLeafFileContext." />
	<cfargument name="WebSiteContext" hint="I am the WebSiteContext." default="#getWebSiteContext()#">
	
	<cfset variables.instance.FigLeafFileContext = 
			arguments.WebSiteContext & arguments.FigLeafFileContext 
	/>
</cffunction>
<cffunction name="getFigLeafFileContext" access="public" output="false" 
	hint="I return the FigLeafFileContext property.">
	<cfreturn variables.instance.FigLeafFileContext  />
</cffunction>



<!--- FigLeafComponentContext --->
<cffunction name="setFigLeafComponentContext" access="private" output="false" 
	hint="I set the FigLeafComponentContext property.">
	<cfargument name="FigLeafComponentContext" hint="I am the FigLeafComponentContext." />
	<cfset variables.instance.FigLeafComponentContext = arguments.FigLeafComponentContext />
</cffunction>
<cffunction name="getFigLeafComponentContext" access="public" output="false" 
	hint="I return the FigLeafComponentContext property.">
	<cfreturn variables.instance.FigLeafComponentContext  />
</cffunction>



<!--- FigLeafApplicationComponentContext --->
<cffunction name="setFigLeafApplicationComponentContext" access="private" output="false" 
	hint="I set the FigLeafApplicationComponentContext  property.">
	<cfset variables.instance.FigLeafApplicationComponentContext  = 
			"#getFigLeafComponentContext()#" & "com.applications."  />
</cffunction>
<cffunction name="getFigLeafApplicationComponentContext" access="public" output="false" 
	hint="I return the FigLeafApplicationComponentContext  property.">
	<cfreturn variables.instance.FigLeafApplicationComponentContext   />
</cffunction>



<!--- WebSiteServerContext --->
<cffunction name="setWebSiteServerContext" access="public" output="false" 
	hint="I set the WebSiteServerContext property.">
	<cfargument name="WebSiteServerContext" hint="I am the WebSiteServerContext." />
	<cfset variables.instance.WebSiteServerContext = arguments.WebSiteServerContext />
</cffunction>
<cffunction name="getWebSiteServerContext" access="public" output="false" 
	hint="I return the WebSiteServerContext property.">
	<cfreturn variables.instance.WebSiteServerContext  />
</cffunction>



<!--- FigLeafServerContext --->
<cffunction name="setFigLeafServerContext" access="public" output="false" 
	hint="I set the FigLeafServerContext property.">

	<!--- default to 8, root level, this file is 8 dirs deep --->
	<cfset var path = "" />
	<cfset var amount = 8 />
	
	<!--- else dont go all the way, and kill to the 7th dir --->
	<cfif getWebSiteContext() neq "">
		<cfset amount = 7 />
	</cfif>

	<cfset path = 
		GetDirectoryFromPath(
			GetCurrentTemplatePath()
			).ReplaceFirst(
				"([^\\\/]+[\\\/]){#amount#}$", ""
			) 
	/>
	
	<cfset variables.instance.FigLeafServerContext = left2(path, -1) />
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
<cffunction name="getFigLeafServerContext" access="public" output="false" 
	hint="I return the FigLeafServerContext property.">
	<cfreturn variables.instance.FigLeafServerContext  />
</cffunction>


<!--- ProductionServerIPList --->
<cffunction name="setProductionServerIPList" access="private" output="false" 
	hint="I set the ProductionServerIPList property.">
	<cfargument name="ProductionServerIPList" hint="I am the ProductionServerIPList." />
	<cfset variables.instance.ProductionServerIPList = arguments.ProductionServerIPList />
</cffunction>
<cffunction name="getProductionServerIPList" access="public" output="false" 
	hint="I return the ProductionServerIPList property.">
	<cfreturn variables.instance.ProductionServerIPList  />
</cffunction>
<!--- AdministratorEmail --->
<cffunction name="setAdministratorEmail" access="private" output="false" 
	hint="I set the AdministratorEmail property.">
	<cfargument name="AdministratorEmail" hint="I am the AdministratorEmail." />
	<cfset variables.instance.AdministratorEmail = arguments.AdministratorEmail />
</cffunction>
<cffunction name="getAdministratorEmail" access="public" output="false" 
	hint="I return the AdministratorEmail property.">
	<cfreturn variables.instance.AdministratorEmail  />
</cffunction>
<!--- WebMasterEmail --->
<cffunction name="setWebMasterEmail" access="private" output="false" 
	hint="I set the WebMasterEmail property.">
	<cfargument name="WebMasterEmail" hint="I am the WebMasterEmail." />
	<cfset variables.instance.WebMasterEmail = arguments.WebMasterEmail />
</cffunction>
<cffunction name="getWebMasterEmail" access="public" output="false" 
	hint="I return the WebMasterEmail property.">
	<cfreturn variables.instance.WebMasterEmail  />
</cffunction>
<!--- DeveloperEmail --->
<cffunction name="setDeveloperEmail" access="private" output="false" 
	hint="I set the DeveloperEmail property.">
	<cfargument name="DeveloperEmail" hint="I am the DeveloperEmail." />
	<cfset variables.instance.DeveloperEmail = arguments.DeveloperEmail />
</cffunction>
<cffunction name="getDeveloperEmail" access="public" output="false" 
	hint="I return the DeveloperEmail property.">
	<cfreturn variables.instance.DeveloperEmail  />
</cffunction>
<!--- MailServer --->
<cffunction name="setMailServer" access="private" output="false" 
	hint="I set the MailServer property.">
	<cfargument name="MailServer" hint="I am the MailServer." />
	<cfset variables.instance.MailServer = arguments.MailServer />
</cffunction>
<cffunction name="getMailServer" access="public" output="false" 
	hint="I return the MailServer property.">
	<cfreturn variables.instance.MailServer  />
</cffunction>
<!--- MailUsername --->
<cffunction name="setMailUsername" access="private" output="false" 
	hint="I set the MailUsername property.">
	<cfargument name="MailUsername" hint="I am the MailUsername." />
	<cfset variables.instance.MailUsername = arguments.MailUsername />
</cffunction>
<cffunction name="getMailUsername" access="public" output="false" 
	hint="I return the MailUsername property.">
	<cfreturn variables.instance.MailUsername  />
</cffunction>
<!--- MailPassword --->
<cffunction name="setMailPassword" access="private" output="false" 
	hint="I set the MailPassword property.">
	<cfargument name="MailPassword" hint="I am the MailPassword." />
	<cfset variables.instance.MailPassword = arguments.MailPassword />
</cffunction>
<cffunction name="getMailPassword" access="public" output="false" 
	hint="I return the MailPassword property.">
	<cfreturn variables.instance.MailPassword  />
</cffunction>
<!--- InputPresidence --->
<cffunction name="setInputPresidence" access="private" output="false" 
	hint="I set the InputPresidence property.">
	<cfargument name="InputPresidence" hint="I am the InputPresidence." />
	<cfset variables.instance.InputPresidence = arguments.InputPresidence />
</cffunction>
<cffunction name="getInputPresidence" access="public" output="false" 
	hint="I return the InputPresidence property.">
	<cfreturn variables.instance.InputPresidence  />
</cffunction>
<!--- FigLeafSystemVersion --->
<cffunction name="setFigLeafSystemVersion" access="private" output="false" 
	hint="I set the FigLeafSystemVersion property.">
	<cfargument name="FigLeafSystemVersion" hint="I am the FigLeafSystemVersion." />
	<cfset variables.instance.FigLeafSystemVersion = arguments.FigLeafSystemVersion />
</cffunction>
<cffunction name="getFigLeafSystemVersion" access="public" output="false" 
	hint="I return the FigLeafSystemVersion property.">
	<cfreturn variables.instance.FigLeafSystemVersion  />
</cffunction>



<!--- FigLeafFilePath --->
<cffunction name="setFigLeafFilePath" access="public" output="false" 
	hint="I set the FigLeafFilePath property.">
	<cfargument name="FigLeafFilePath" hint="I am the FigLeafFilePath." />
	<cfset variables.instance.FigLeafFilePath = arguments.FigLeafFilePath />
</cffunction>
<cffunction name="getFigLeafFilePath" access="public" output="false" 
	hint="I return the FigLeafFilePath property.">
	<cfreturn variables.instance.FigLeafFilePath  />
</cffunction>

<!--- ExtensionsPath --->
<cffunction name="setExtensionsPath" access="public" output="false" 
	hint="I set the ExtensionsPath property.">
	<cfargument name="ExtensionsPath" hint="I am the ExtensionsPath." />
	<cfset variables.instance.ExtensionsPath = arguments.ExtensionsPath />
</cffunction>
<cffunction name="getExtensionsPath" access="public" output="false" 
	hint="I return the ExtensionsPath property.">
	<cfreturn variables.instance.ExtensionsPath  />
</cffunction>


<!--- ************** FLEET **************  --->

<!--- CommonSpotSupportDSN --->
<cffunction name="setCommonSpotSupportDSN" access="private" output="false" 
	hint="I set the CommonSpotSupportDSN property.">
	<cfargument name="CommonSpotSupportDSN" hint="I am the CommonSpotSupportDSN." />
	<cfset variables.instance.CommonSpotSupportDSN = arguments.CommonSpotSupportDSN />
</cffunction>
<cffunction name="getCommonSpotSupportDSN" access="public" output="false" 
	hint="I return the CommonSpotSupportDSN property.">
	<cfreturn variables.instance.CommonSpotSupportDSN  />
</cffunction>
<!--- FleetMetaDataFieldName --->
<cffunction name="setFleetMetaDataFieldName" access="private" output="false" 
	hint="I set the FleetMetaDataFieldName property.">
	<cfargument name="FleetMetaDataFieldName" hint="I am the FleetMetaDataFieldName." />
	<cfset variables.instance.FleetMetaDataFieldName = arguments.FleetMetaDataFieldName />
</cffunction>
<cffunction name="getFleetMetaDataFieldName" access="public" output="false" 
	hint="I return the FleetMetaDataFieldName property.">
	<cfreturn variables.instance.FleetMetaDataFieldName  />
</cffunction>
<!--- FleetControllID --->
<cffunction name="setFleetControllID" access="public" output="false" 
	hint="I set the FleetControllID property.">
	<cfargument name="FleetControllID" hint="I am the FleetControllID." />
	<cfset variables.instance.FleetControllID = arguments.FleetControllID />
</cffunction>
<cffunction name="getFleetControllID" access="public" output="false" 
	hint="I return the FleetControllID property.">
	<cfreturn variables.instance.FleetControllID  />
</cffunction>
<!--- EnableFleet --->
<cffunction name="setEnableFleet" access="private" output="false" 
	hint="I set the EnableFleet property.">
	<cfargument name="EnableFleet" hint="I am the EnableFleet." />
	<cfset variables.instance.EnableFleet = arguments.EnableFleet />
</cffunction>
<cffunction name="getEnableFleet" access="public" output="false" 
	hint="I return the EnableFleet property.">
	<cfreturn variables.instance.EnableFleet  />
</cffunction>
<!--- EnableFileAsset --->
<cffunction name="setEnableFileAsset" access="private" output="false" 
	hint="I set the EnableFileAsset property.">
	<cfargument name="EnableFileAsset" hint="I am the EnableFileAsset." />
	<cfset variables.instance.EnableFileAsset = arguments.EnableFileAsset />
</cffunction>
<cffunction name="getEnableFileAsset" access="public" output="false" 
	hint="I return the EnableFileAsset property.">
	<cfreturn variables.instance.EnableFileAsset  />
</cffunction>
<!--- EnableMetaData --->
<cffunction name="setEnableMetaData" access="public" output="false" 
	hint="I set the EnableMetaData property.">
	<cfargument name="EnableMetaData" hint="I am the EnableMetaData." />
	<cfset variables.instance.EnableMetaData = arguments.EnableMetaData />
</cffunction>
<cffunction name="getEnableMetaData" access="public" output="false" 
	hint="I return the EnableMetaData property.">
	<cfreturn variables.instance.EnableMetaData  />
</cffunction>
<!--- EnableReleatedLinks --->
<cffunction name="setEnableReleatedLinks" access="private" output="false" 
	hint="I set the EnableReleatedLinks property.">
	<cfargument name="EnableReleatedLinks" hint="I am the EnableReleatedLinks." />
	<cfset variables.instance.EnableReleatedLinks = arguments.EnableReleatedLinks />
</cffunction>
<cffunction name="getEnableReleatedLinks" access="public" output="false" 
	hint="I return the EnableReleatedLinks property.">
	<cfreturn variables.instance.EnableReleatedLinks  />
</cffunction>	
<!--- EnableSiteRipper --->
<cffunction name="setEnableSiteRipper" access="private" output="false" 
	hint="I set the EnableSiteRipper property.">
	<cfargument name="EnableSiteRipper" hint="I am the EnableSiteRipper." />
	<cfset variables.instance.EnableSiteRipper = arguments.EnableSiteRipper />
</cffunction>
<cffunction name="getEnableSiteRipper" access="public" output="false" 
	hint="I return the EnableSiteRipper property.">
	<cfreturn variables.instance.EnableSiteRipper  />
</cffunction>
<!--- MetaDataUISupportEditDirectory --->
<cffunction name="setMetaDataUISupportEditDirectory" access="public" output="false" 
	hint="I set the MetaDataUISupportEditDirectory property.">
	<cfargument name="MetaDataUISupportEditDirectory" hint="I am the MetaDataUISupportEditDirectory." />
	<cfset variables.instance.MetaDataUISupportEditDirectory = 
		getFigLeafFileContext() & arguments.MetaDataUISupportEditDirectory />
</cffunction>
<cffunction name="getMetaDataUISupportEditDirectory" access="public" output="false" 
	hint="I return the MetaDataUISupportEditDirectory property.">
	<cfreturn variables.instance.MetaDataUISupportEditDirectory  />
</cffunction>
<!--- MetaDataUISupportJSDirectory --->
<cffunction name="setMetaDataUISupportJSDirectory" access="public" output="false" 
	hint="I set the MetaDataUISupportJSDirectory property.">
	<cfargument name="MetaDataUISupportJSDirectory" hint="I am the MetaDataUISupportJSDirectory." />
	<cfset variables.instance.MetaDataUISupportJSDirectory = 
		getFigLeafFileContext() & arguments.MetaDataUISupportJSDirectory />
</cffunction>
<cffunction name="getMetaDataUISupportJSDirectory" access="public" output="false" 
	hint="I return the MetaDataUISupportJSDirectory property.">
	<cfreturn variables.instance.MetaDataUISupportJSDirectory  />
</cffunction>
<!--- SiteRipperURL --->
<cffunction name="setSiteRipperURL" access="public" output="false" 
	hint="I set the SiteRipperURL property.">
	<cfargument name="SiteRipperURL" hint="I am the SiteRipperURL." />
	<cfset variables.instance.SiteRipperURL = arguments.SiteRipperURL />
</cffunction>
<cffunction name="getSiteRipperURL" access="public" output="false" 
	hint="I return the SiteRipperURL property.">
	<cfreturn variables.instance.SiteRipperURL  />
</cffunction>
<!--- SiteRipperCFURL --->
<cffunction name="setSiteRipperCFURL" access="public" output="false" 
	hint="I set the SiteRipperCFURL property.">
	<cfargument name="SiteRipperCFURL" hint="I am the SiteRipperCFURL." />
	<cfset variables.instance.SiteRipperCFURL = arguments.SiteRipperCFURL />
</cffunction>
<cffunction name="getSiteRipperCFURL" access="public" output="false" 
	hint="I return the SiteRipperCFURL property.">
	<cfreturn variables.instance.SiteRipperCFURL  />
</cffunction>
<!--- FleetVersion --->
<cffunction name="setFleetVersion" access="private" output="false" 
	hint="I set the FleetVersion property.">
	<cfargument name="FleetVersion" hint="I am the FleetVersion." />
	<cfset variables.instance.FleetVersion = arguments.FleetVersion />
</cffunction>
<cffunction name="getFleetVersion" access="public" output="false" 
	hint="I return the FleetVersion property.">
	<cfreturn variables.instance.FleetVersion  />
</cffunction>



<!--- ************** ViewFramework **************  --->

<!--- PageTypeMetaDataFromName --->
<cffunction name="setPageTypeMetaDataFromName" access="private" output="false" 
	hint="I set the PageTypeMetaDataFromName property.">
	<cfargument name="PageTypeMetaDataFromName" hint="I am the PageTypeMetaDataFromName." />
	<cfset variables.instance.PageTypeMetaDataFromName = arguments.PageTypeMetaDataFromName />
</cffunction>
<cffunction name="getPageTypeMetaDataFromName" access="public" output="false" 
	hint="I return the PageTypeMetaDataFromName property.">
	<cfreturn variables.instance.PageTypeMetaDataFromName  />
</cffunction>
<!--- PageTypeMetaDataFormFieldName --->
<cffunction name="setPageTypeMetaDataFormFieldName" access="private" output="false" 
	hint="I set the PageTypeMetaDataFormFieldName property.">
	<cfargument name="PageTypeMetaDataFormFieldName" hint="I am the PageTypeMetaDataFormFieldName." />
	<cfset variables.instance.PageTypeMetaDataFormFieldName = arguments.PageTypeMetaDataFormFieldName />
</cffunction>
<cffunction name="getPageTypeMetaDataFormFieldName" access="public" output="false" 
	hint="I return the PageTypeMetaDataFormFieldName property.">
	<cfreturn variables.instance.PageTypeMetaDataFormFieldName  />
</cffunction>
<!--- EnableViewFramework --->
<cffunction name="setEnableViewFramework" access="private" output="false" 
	hint="I set the EnableViewFramework property.">
	<cfargument name="EnableViewFramework" hint="I am the EnableViewFramework." />
	<cfset variables.instance.EnableViewFramework = arguments.EnableViewFramework />
</cffunction>
<cffunction name="getEnableViewFramework" access="public" output="false" 
	hint="I return the EnableViewFramework property.">
	<cfreturn variables.instance.EnableViewFramework  />
</cffunction>
<!--- DefaultCSSClass --->
<cffunction name="setDefaultCSSClass" access="public" output="false" 
	hint="I set the DefaultCSSClass property.">
	<cfargument name="DefaultCSSClass" hint="I am the DefaultCSSClass." />
	<cfset variables.instance.DefaultCSSClass = arguments.DefaultCSSClass />
</cffunction>
<cffunction name="getDefaultCSSClass" access="public" output="false" 
	hint="I return the DefaultCSSClass property.">
	<cfreturn variables.instance.DefaultCSSClass  />
</cffunction>
<!--- UIDirectory --->
<cffunction name="setUIDirectory" access="public" output="false" 
	hint="I set the UIDirectory property.">
	<cfargument name="UIDirectory" hint="I am the UIDirectory." />
	<cfset variables.instance.UIDirectory = arguments.UIDirectory />
</cffunction>
<cffunction name="getUIDirectory" access="public" output="false" 
	hint="I return the UIDirectory property.">
	<cfreturn variables.instance.UIDirectory  />
</cffunction>


<!--- CSSDirectory --->
<cffunction name="setCSSDirectory" access="private" output="false" 
	hint="I set the CSSDirectory property.">
	<cfargument name="CSSDirectory" hint="I am the CSSDirectory." />
	<cfset variables.instance.CSSDirectory = getWebSiteContext() & getUIDirectory() & arguments.CSSDirectory />
</cffunction>
<cffunction name="getCSSDirectory" access="public" output="false" 
	hint="I return the CSSDirectory property.">
	<cfreturn variables.instance.CSSDirectory  />
</cffunction>



<!--- ImageDirectory --->
<cffunction name="setImageDirectory" access="public" output="false" 
	hint="I set the ImageDirectory property.">
	<cfargument name="ImageDirectory" hint="I am the ImageDirectory." />
	<cfset variables.instance.ImageDirectory = getWebSiteContext() & getUIDirectory() & arguments.ImageDirectory />
</cffunction>
<cffunction name="getImageDirectory" access="public" output="false" 
	hint="I return the ImageDirectory property.">
	<cfreturn variables.instance.ImageDirectory  />
</cffunction>
<!--- FrameworkRederHandlerDirectory --->
<cffunction name="setRederHandlerDirectory" access="public" output="false" 
	hint="I set the RederHandlerDirectory property.">
	<cfargument name="RederHandlerDirectory" hint="I am the FrameworkRederHandlerDirectory." />
	<cfset variables.instance.RederHandlerDirectory = getWebSiteContext() & arguments.RederHandlerDirectory />
</cffunction>
<cffunction name="getRederHandlerDirectory" access="public" output="false" 
	hint="I return the RederHandlerDirectory property.">
	<cfreturn variables.instance.RederHandlerDirectory  />
</cffunction>
<!--- IncludesDirectory --->
<cffunction name="setIncludesDirectory" access="public" output="false" 
	hint="I set the IncludesDirectory property.">
	<cfargument name="IncludesDirectory" hint="I am the IncludesDirectory." />
	<cfset variables.instance.IncludesDirectory = getWebSiteContext() & arguments.IncludesDirectory />
</cffunction>
<cffunction name="getIncludesDirectory" access="public" output="false" 
	hint="I return the IncludesDirectory property.">
	<cfreturn variables.instance.IncludesDirectory  />
</cffunction>
<!--- ImplementDataservice --->
<cffunction name="setImplementDataservice" access="public" output="false" 
	hint="I set the ImplementDataservice property.">
	<cfargument name="ImplementDataservice" hint="I am the ImplementDataservice." />
	<cfset variables.instance.ImplementDataservice = arguments.ImplementDataservice />
</cffunction>
<cffunction name="getImplementDataservice" access="public" output="false" 
	hint="I return the ImplementDataservice property.">
	<cfreturn variables.instance.ImplementDataservice  />
</cffunction>
<!--- ViewFrameworkDirectory --->
<cffunction name="setViewFrameworkDirectory" access="private" output="false" 
	hint="I set the ViewFrameworkDirectory property.">
	<cfset variables.instance.ViewFrameworkDirectory = 
			getFigLeafFileContext() & "/com/applications/viewframework" />
</cffunction>
<cffunction name="getViewFrameworkDirectory" access="public" output="false" 
	hint="I return the ViewFrameworkDirectory property.">
	<cfreturn variables.instance.ViewFrameworkDirectory  />
</cffunction>
<!--- ViewFrameworkVersion --->
<cffunction name="setViewFrameworkVersion" access="public" output="false" 
	hint="I set the ViewFrameworkVersion property.">
	<cfargument name="ViewFrameworkVersion" hint="I am the ViewFrameworkVersion." />
	<cfset variables.instance.ViewFrameworkVersion = arguments.ViewFrameworkVersion />
</cffunction>
<cffunction name="getViewFrameworkVersion" access="public" output="false" 
	hint="I return the ViewFrameworkVersion property.">
	<cfreturn variables.instance.ViewFrameworkVersion  />
</cffunction>



<!--- ************** DataService **************  --->

<!--- CacheTimeValue --->
<cffunction name="setCacheTimeValue" access="private" output="false" 
	hint="I set the CacheTimeValue property.">
	<cfargument name="CacheTimeValue" hint="I am the CacheTimeValue." />
	<cfset variables.instance.CacheTimeValue = arguments.CacheTimeValue />
</cffunction>
<cffunction name="getCacheTimeValue" access="public" output="false" 
	hint="I return the CacheTimeValue property.">
	<cfreturn variables.instance.CacheTimeValue  />
</cffunction>
<!--- CacheTimeSpan --->
<cffunction name="setCacheTimeSpan" access="public" output="false" 
	hint="I set the CacheTimeSpan property.">
	<cfargument name="CacheTimeSpan" hint="I am the CacheTimeSpan." />
	<cfset variables.instance.CacheTimeSpan = arguments.CacheTimeSpan />
</cffunction>
<cffunction name="getCacheTimeSpan" access="public" output="false" 
	hint="I return the CacheTimeSpan property.">
	<cfreturn variables.instance.CacheTimeSpan  />
</cffunction>
<!--- CacheReapTime --->
<cffunction name="setCacheReapTime" access="public" output="false" 
	hint="I set the CacheReapTime property.">
	<cfargument name="CacheReapTime" hint="I am the CacheReapTime." />
	<cfset variables.instance.CacheReapTime = arguments.CacheReapTime />
</cffunction>
<cffunction name="getCacheReapTime" access="public" output="false" 
	hint="I return the CacheReapTime property.">
	<cfreturn variables.instance.CacheReapTime  />
</cffunction>
<!--- DefaultCache --->
<cffunction name="setDefaultCache" access="private" output="false" 
	hint="I set the DefaultCache property.">
	<cfargument name="DefaultCache" hint="I am the DefaultCache." />
	<cfset variables.instance.DefaultCache = arguments.DefaultCache />
</cffunction>
<cffunction name="getDefaultCache" access="public" output="false" 
	hint="I return the DefaultCache property.">
	<cfreturn variables.instance.DefaultCache  />
</cffunction>
<!--- URLCacheReloadKey --->
<cffunction name="setURLCacheReloadKey" access="private" output="false" 
	hint="I set the urlCacheReloadKey property.">
	<cfargument name="urlCacheReloadKey" hint="I am the urlCacheReloadKey." />
	<cfset variables.instance.URLCacheReloadKey = arguments.urlCacheReloadKey />
</cffunction>
<cffunction name="getURLCacheReloadKey" access="public" output="false" 
	hint="I return the urlCacheReloadKey property.">
	<cfreturn variables.instance.URLCacheReloadKey  />
</cffunction>
<!--- URLCacheRelaodValue --->
<cffunction name="setURLCacheRelaodValue" access="private" output="false" 
	hint="I set the URLCacheRelaodValue property.">
	<cfargument name="URLCacheRelaodValue" hint="I am the URLCacheRelaodValue." />
	<cfset variables.instance.URLCacheRelaodValue = arguments.URLCacheRelaodValue />
</cffunction>
<cffunction name="getURLCacheRelaodValue" access="public" output="false" 
	hint="I return the URLCacheRelaodValue property.">
	<cfreturn variables.instance.URLCacheRelaodValue  />
</cffunction>
<!--- GatewayRuntimeMode --->
<cffunction name="setGatewayRuntimeMode" access="public" output="false" 
	hint="I set the GatewayRuntimeMode property.">
	<cfargument name="GatewayRuntimeMode" hint="I am the GatewayRuntimeMode." />
	<cfset variables.instance.GatewayRuntimeMode = arguments.GatewayRuntimeMode />
</cffunction>
<cffunction name="getGatewayRuntimeMode" access="public" output="false" 
	hint="I return the GatewayRuntimeMode property.">
	<cfreturn variables.instance.GatewayRuntimeMode  />
</cffunction>
<!--- DataServiceScope --->
<cffunction name="setDataServiceScope" access="private" output="false" 
	hint="I set the DataServiceScope property.">
	<cfargument name="DataServiceScope" hint="I am the DataServiceScope." />
	<cfset variables.instance.DataServiceScope = arguments.DataServiceScope />
</cffunction>
<cffunction name="getDataServiceScope" access="public" output="false" 
	hint="I return the DataServiceScope property.">
	<cfreturn variables.instance.DataServiceScope  />
</cffunction>
<!--- StoreXMLDiskCache --->
<cffunction name="setStoreXMLDiskCache" access="private" output="false" 
	hint="I set the StoreXMLDiskCache property.">
	<cfargument name="StoreXMLDiskCache" hint="I am the StoreXMLDiskCache." />
	<cfset variables.instance.StoreXMLDiskCache = arguments.StoreXMLDiskCache />
</cffunction>
<cffunction name="getStoreXMLDiskCache" access="public" output="false" 
	hint="I return the StoreXMLDiskCache property.">
	<cfreturn variables.instance.StoreXMLDiskCache  />
</cffunction>
<!--- SupportDataSourceOne --->
<cffunction name="setSupportDataSourceOne" access="private" output="false" 
	hint="I set the SupportDataSourceOne property.">
	<cfargument name="SupportDataSourceOne" hint="I am the SupportDataSourceOne." />
	<cfset variables.instance.SupportDataSourceOne = arguments.SupportDataSourceOne />
</cffunction>
<cffunction name="getSupportDataSourceOne" access="public" output="false" 
	hint="I return the SupportDataSourceOne property.">
	<cfreturn variables.instance.SupportDataSourceOne  />
</cffunction>
<!--- SupportDataSourceTwo --->
<cffunction name="setSupportDataSourceTwo" access="private" output="false" 
	hint="I set the SupportDataSourceTwo property.">
	<cfargument name="SupportDataSourceTwo" hint="I am the SupportDataSourceTwo." />
	<cfset variables.instance.SupportDataSourceTwo = arguments.SupportDataSourceTwo />
</cffunction>
<cffunction name="getSupportDataSourceTwo" access="public" output="false" 
	hint="I return the SupportDataSourceTwo property.">
	<cfreturn variables.instance.SupportDataSourceTwo  />
</cffunction>
<!--- DataserviceVersion --->
<cffunction name="setDataserviceVersion" access="private" output="false" 
	hint="I set the DataserviceVersion property.">
	<cfargument name="DataserviceVersion" hint="I am the DataserviceVersion." />
	<cfset variables.instance.DataserviceVersion = arguments.DataserviceVersion />
</cffunction>
<cffunction name="getDataserviceVersion" access="public" output="false" 
	hint="I return the DataserviceVersion property.">
	<cfreturn variables.instance.DataserviceVersion  />
</cffunction>



<!--- ************** Authentication **************  --->

<!--- EnableAuthentication --->
<cffunction name="setEnableAuthentication" access="private" output="false" 
	hint="I set the EnableAuthentication property.">
	<cfargument name="EnableAuthentication" hint="I am the EnableAuthentication." />
	<cfset variables.instance.EnableAuthentication = arguments.EnableAuthentication />
</cffunction>
<cffunction name="getEnableAuthentication" access="public" output="false" 
	hint="I return the EnableAuthentication property.">
	<cfreturn variables.instance.EnableAuthentication  />
</cffunction>
<!--- realm --->
<cffunction name="setRealm" access="private" output="false" 
	hint="I set the realm property.">
	<cfargument name="realm" hint="I am the realm." />
	<cfset variables.instance.realm = arguments.realm />
</cffunction>
<cffunction name="getRealm" access="public" output="false" 
	hint="I return the realm property.">
	<cfreturn variables.instance.realm  />
</cffunction>
<!--- AuthenticationURL --->
<cffunction name="setAuthenticationURL" access="private" output="false" 
	hint="I set the AuthenticationURL property.">
	<cfargument name="AuthenticationURL" hint="I am the AuthenticationURL." />
	<cfset variables.instance.AuthenticationURL = arguments.AuthenticationURL />
</cffunction>
<cffunction name="getAuthenticationURL" access="public" output="false" 
	hint="I return the AuthenticationURL property.">
	<cfreturn variables.instance.AuthenticationURL  />
</cffunction>
<!--- AuthenticationTestURL --->
<cffunction name="setAuthenticationTestURL" access="private" output="false" 
	hint="I set the AuthenticationTestURL property.">
	<cfargument name="AuthenticationTestURL" hint="I am the AuthenticationTestURL." />
	<cfset variables.instance.AuthenticationTestURL = arguments.AuthenticationTestURL />
</cffunction>
<cffunction name="getAuthenticationTestURL" access="public" output="false" 
	hint="I return the AuthenticationTestURL property.">
	<cfreturn variables.instance.AuthenticationTestURL  />
</cffunction>
<!--- AuthenticationMode --->
<cffunction name="setAuthenticationMode" access="private" output="false" 
	hint="I set the AuthenticationMode property.">
	<cfargument name="AuthenticationMode" hint="I am the AuthenticationMode." />
	<cfset variables.instance.AuthenticationMode = arguments.AuthenticationMode />
</cffunction>
<cffunction name="getAuthenticationMode" access="public" output="false" 
	hint="I return the AuthenticationMode property.">
	<cfreturn variables.instance.AuthenticationMode  />
</cffunction>
<!--- ForcePass --->
<cffunction name="setForcePass" access="private" output="false" 
	hint="I set the ForcePass property.">
	<cfargument name="ForcePass" hint="I am the ForcePass." />
	<cfset variables.instance.ForcePass = arguments.ForcePass />
</cffunction>
<cffunction name="getForcePass" access="public" output="false" 
	hint="I return the ForcePass property.">
	<cfreturn variables.instance.ForcePass  />
</cffunction>
<!--- AuthenticationVersion --->
<cffunction name="setAuthenticationVersion" access="private" output="false" 
	hint="I set the AuthenticationVersion property.">
	<cfargument name="AuthenticationVersion" hint="I am the AuthenticationVersion." />
	<cfset variables.instance.AuthenticationVersion = arguments.AuthenticationVersion />
</cffunction>
<cffunction name="getAuthenticationVersion" access="public" output="false" 
	hint="I return the AuthenticationVersion property.">
	<cfreturn variables.instance.AuthenticationVersion  />
</cffunction>


<!--- ************** Search **************  --->

<!--- SearchType --->
<cffunction name="setSearchType" access="public" output="false" 
	hint="I set the SearchType property.">
	<cfargument name="SearchType" hint="I am the SearchType." />
	<cfset variables.instance.SearchType = arguments.SearchType />
</cffunction>
<cffunction name="getSearchType" access="public" output="false" 
	hint="I return the SearchType property.">
	<cfreturn variables.instance.SearchType  />
</cffunction>
<!--- GoogleURL --->
<cffunction name="setGoogleURL" access="public" output="false" 
	hint="I set the GoogleURL property.">
	<cfargument name="GoogleURL" hint="I am the GoogleURL." />
	<cfset variables.instance.GoogleURL = arguments.GoogleURL />
</cffunction>
<cffunction name="getGoogleURL" access="public" output="false" 
	hint="I return the GoogleURL property.">
	<cfreturn variables.instance.GoogleURL  />
</cffunction>
<!--- GoogleSiteScope --->
<cffunction name="setGoogleSiteScope" access="public" output="false" 
	hint="I set the GoogleSiteScope property.">
	<cfargument name="GoogleSiteScope" hint="I am the GoogleSiteScope." />
	<cfset variables.instance.GoogleSiteScope = arguments.GoogleSiteScope />
</cffunction>
<cffunction name="getGoogleSiteScope" access="public" output="false" 
	hint="I return the GoogleSiteScope property.">
	<cfreturn variables.instance.GoogleSiteScope  />
</cffunction>
<!--- GoogleResultsNumber --->
<cffunction name="setGoogleResultsNumber" access="public" output="false" 
	hint="I set the GoogleResultsNumber property.">
	<cfargument name="GoogleResultsNumber" hint="I am the GoogleResultsNumber." />
	<cfset variables.instance.GoogleResultsNumber = arguments.GoogleResultsNumber />
</cffunction>
<cffunction name="getGoogleResultsNumber" access="public" output="false" 
	hint="I return the GoogleResultsNumber property.">
	<cfreturn variables.instance.GoogleResultsNumber  />
</cffunction>
<!--- GoogleGetFields --->
<cffunction name="setGoogleGetFields" access="public" output="false" 
	hint="I set the GoogleGetFields property.">
	<cfargument name="GoogleGetFields" hint="I am the GoogleGetFields." />
	<cfset variables.instance.GoogleGetFields = arguments.GoogleGetFields />
</cffunction>
<cffunction name="getGoogleGetFields" access="public" output="false" 
	hint="I return the GoogleGetFields property.">
	<cfreturn variables.instance.GoogleGetFields  />
</cffunction>
<!--- GoogleClient --->
<cffunction name="setGoogleClient" access="public" output="false" 
	hint="I set the GoogleClient property.">
	<cfargument name="GoogleClient" hint="I am the GoogleClient." />
	<cfset variables.instance.GoogleClient = arguments.GoogleClient />
</cffunction>
<cffunction name="getGoogleClient" access="public" output="false" 
	hint="I return the GoogleClient property.">
	<cfreturn variables.instance.GoogleClient  />
</cffunction>
<!--- GoogleAccess --->
<cffunction name="setGoogleAccess" access="public" output="false" 
	hint="I set the GoogleAccess property.">
	<cfargument name="GoogleAccess" hint="I am the GoogleAccess." />
	<cfset variables.instance.GoogleAccess = arguments.GoogleAccess />
</cffunction>
<cffunction name="getGoogleAccess" access="public" output="false" 
	hint="I return the GoogleAccess property.">
	<cfreturn variables.instance.GoogleAccess  />
</cffunction>
<!--- GoogleButtonText --->
<cffunction name="setGoogleButtonText" access="public" output="false" 
	hint="I set the GoogleButtonText property.">
	<cfargument name="GoogleButtonText" hint="I am the GoogleButtonText." />
	<cfset variables.instance.GoogleButtonText = arguments.GoogleButtonText />
</cffunction>
<cffunction name="getGoogleButtonText" access="public" output="false" 
	hint="I return the GoogleButtonText property.">
	<cfreturn variables.instance.GoogleButtonText  />
</cffunction>
<!--- GoogleIe --->
<cffunction name="setGoogleIe" access="public" output="false" 
	hint="I set the GoogleIe property.">
	<cfargument name="GoogleIe" hint="I am the GoogleIe." />
	<cfset variables.instance.GoogleIe = arguments.GoogleIe />
</cffunction>
<cffunction name="getGoogleIe" access="public" output="false" 
	hint="I return the GoogleIe property.">
	<cfreturn variables.instance.GoogleIe  />
</cffunction>
<!--- GoogleOutput --->
<cffunction name="setGoogleOutput" access="public" output="false" 
	hint="I set the GoogleOutput property.">
	<cfargument name="GoogleOutput" hint="I am the GoogleOutput." />
	<cfset variables.instance.GoogleOutput = arguments.GoogleOutput />
</cffunction>
<cffunction name="getGoogleOutput" access="public" output="false" 
	hint="I return the GoogleOutput property.">
	<cfreturn variables.instance.GoogleOutput  />
</cffunction>
<!--- GoogleFilter --->
<cffunction name="setGoogleFilter" access="public" output="false" 
	hint="I set the GoogleFilter property.">
	<cfargument name="GoogleFilter" hint="I am the GoogleFilter." />
	<cfset variables.instance.GoogleFilter = arguments.GoogleFilter />
</cffunction>
<cffunction name="getGoogleFilter" access="public" output="false" 
	hint="I return the GoogleFilter property.">
	<cfreturn variables.instance.GoogleFilter  />
</cffunction>
<!--- GoogleSortType --->
<cffunction name="setGoogleSortType" access="public" output="false" 
	hint="I set the GoogleSortType property.">
	<cfargument name="GoogleSortType" hint="I am the GoogleSortType." />
	<cfset variables.instance.GoogleSortType = arguments.GoogleSortType />
</cffunction>
<cffunction name="getGoogleSortType" access="public" output="false" 
	hint="I return the GoogleSortType property.">
	<cfreturn variables.instance.GoogleSortType  />
</cffunction>
<!--- GoogleProxyReload --->
<cffunction name="setGoogleProxyReload" access="public" output="false" 
	hint="I set the GoogleProxyReload property.">
	<cfargument name="GoogleProxyReload" hint="I am the GoogleProxyReload." />
	<cfset variables.instance.GoogleProxyReload = arguments.GoogleProxyReload />
</cffunction>
<cffunction name="getGoogleProxyReload" access="public" output="false" 
	hint="I return the GoogleProxyReload property.">
	<cfreturn variables.instance.GoogleProxyReload  />
</cffunction>
<!--- GoogleOutputFormat --->
<cffunction name="setGoogleOutputFormat" access="public" output="false" 
	hint="I set the GoogleOutputFormat property.">
	<cfargument name="GoogleOutputFormat" hint="I am the GoogleOutputFormat." />
	<cfset variables.instance.GoogleOutputFormat = arguments.GoogleOutputFormat />
</cffunction>
<cffunction name="getGoogleOutputFormat" access="public" output="false" 
	hint="I return the GoogleOutputFormat property.">
	<cfreturn variables.instance.GoogleOutputFormat  />
</cffunction>
<!--- GoogleDisplaySortOptions --->
<cffunction name="setGoogleDisplaySortOptions" access="public" output="false" 
	hint="I set the GoogleDisplaySortOptions property.">
	<cfargument name="GoogleDisplaySortOptions" hint="I am the GoogleDisplaySortOptions." />
	<cfset variables.instance.GoogleDisplaySortOptions = arguments.GoogleDisplaySortOptions />
</cffunction>
<cffunction name="getGoogleDisplaySortOptions" access="public" output="false" 
	hint="I return the GoogleDisplaySortOptions property.">
	<cfreturn variables.instance.GoogleDisplaySortOptions  />
</cffunction>
<!--- GoogleDisplayNumbers --->
<cffunction name="setGoogleDisplayNumbers" access="private" output="false" 
	hint="I set the GoogleDisplayNumbers property.">
	<cfargument name="GoogleDisplayNumbers" hint="I am the GoogleDisplayNumbers." />
	<cfset variables.instance.GoogleDisplayNumbers = arguments.GoogleDisplayNumbers />
</cffunction>
<cffunction name="getGoogleDisplayNumbers" access="public" output="false" 
	hint="I return the GoogleDisplayNumbers property.">
	<cfreturn variables.instance.GoogleDisplayNumbers  />
</cffunction>
<!--- SearchFormAction --->
<cffunction name="setSearchFormAction" access="private" output="false" 
	hint="I set the SearchFormAction property.">
	<cfargument name="SearchFormAction" hint="I am the SearchFormAction." />
	<cfset variables.instance.SearchFormAction = arguments.SearchFormAction />
</cffunction>
<cffunction name="getSearchFormAction" access="public" output="false" 
	hint="I return the SearchFormAction property.">
	<cfreturn variables.instance.SearchFormAction  />
</cffunction>
<!--- SearchFormBreakButton --->
<cffunction name="setSearchFormBreakButton" access="private" output="false" 
	hint="I set the SearchFormBreakButton property.">
	<cfargument name="SearchFormBreakButton" hint="I am the SearchFormBreakButton." />
	<cfset variables.instance.SearchFormBreakButton = arguments.SearchFormBreakButton />
</cffunction>
<cffunction name="getSearchFormBreakButton" access="public" output="false" 
	hint="I return the SearchFormBreakButton property.">
	<cfreturn variables.instance.SearchFormBreakButton  />
</cffunction>
<!--- SearchFormClass --->
<cffunction name="setSearchFormClass" access="private" output="false" 
	hint="I set the SearchFormClass property.">
	<cfargument name="SearchFormClass" hint="I am the SearchFormClass." />
	<cfset variables.instance.SearchFormClass = arguments.SearchFormClass />
</cffunction>
<cffunction name="getSearchFormClass" access="public" output="false" 
	hint="I return the SearchFormClass property.">
	<cfreturn variables.instance.SearchFormClass  />
</cffunction>
<!--- SearchFormID --->
<cffunction name="setSearchFormID" access="private" output="false" 
	hint="I set the SearchFormID property.">
	<cfargument name="SearchFormID" hint="I am the SearchFormID." />
	<cfset variables.instance.SearchFormID = arguments.SearchFormID />
</cffunction>
<cffunction name="getSearchFormID" access="public" output="false" 
	hint="I return the SearchFormID property.">
	<cfreturn variables.instance.SearchFormID  />
</cffunction>
<!--- SearchFormName --->
<cffunction name="setSearchFormName" access="private" output="false" 
	hint="I set the SearchFormName property.">
	<cfargument name="SearchFormName" hint="I am the SearchFormName." />
	<cfset variables.instance.SearchFormName = arguments.SearchFormName />
</cffunction>
<cffunction name="getSearchFormName" access="public" output="false" 
	hint="I return the SearchFormName property.">
	<cfreturn variables.instance.SearchFormName  />
</cffunction>
<!--- SearchMode --->
<cffunction name="setSearchMode" access="private" output="false" 
	hint="I set the SearchMode property.">
	<cfargument name="SearchMode" hint="I am the SearchMode." />
	<cfset variables.instance.SearchMode = arguments.SearchMode />
</cffunction>
<cffunction name="getSearchMode" access="public" output="false" 
	hint="I return the SearchMode property.">
	<cfreturn variables.instance.SearchMode  />
</cffunction>


<!--- ************** Multimedia **************  --->

<!--- EnableMultimedia --->
<cffunction name="setEnableMultimedia" access="private" output="false" returntype="void">
	<cfargument name="EnableMultimedia" type="boolean" required="true"/>
	<cfset variables.instance.EnableMultimedia = arguments.EnableMultimedia />
</cffunction>
<cffunction name="getEnableMultimedia" access="public" output="false" returntype="boolean">
	<cfreturn variables.instance.EnableMultimedia />
</cffunction>
<!--- MediaManagementGroupID --->
<cffunction name="setMediaManagementGroupID" access="private" output="false" returntype="void">
	<cfargument name="MediaManagementGroupID" type="numeric" required="true"/>
	<cfset variables.instance.MediaManagementGroupID = arguments.MediaManagementGroupID />
</cffunction>
<cffunction name="getMediaManagementGroupID" access="public" output="false" returntype="numeric">
	<cfreturn variables.instance.MediaManagementGroupID />
</cffunction>
<!--- VideoPlatform --->
<cffunction name="setVideoPlatform" access="private" output="false" returntype="void">
	<cfargument name="VideoPlatform" type="string" required="true"/>
	<cfset variables.instance.VideoPlatform = arguments.VideoPlatform />
</cffunction>
<cffunction name="getVideoPlatform" access="public" output="false" returntype="string">
	<cfreturn variables.instance.VideoPlatform />
</cffunction>
<!--- VideoPlatformService --->
<cffunction name="setVideoPlatformService" access="private" output="false" returntype="void">
	<cfargument name="VideoPlatformService" type="string" required="true"/>
	<cfset variables.instance.VideoPlatformService = arguments.VideoPlatformService />
</cffunction>
<cffunction name="getVideoPlatformService" access="public" output="false" returntype="string">
	<cfreturn variables.instance.VideoPlatformService />
</cffunction>

<!--- ************** Validator **************  --->

<!--- enableValidator --->
<cffunction name="setEnableValidator" access="private" output="false" 
	hint="I set the enableValidator property.">
	<cfargument name="enableValidator" hint="I am the enableValidator." />
	<cfset variables.instance.enableValidator = arguments.enableValidator />
</cffunction>
<cffunction name="getEnableValidator" access="public" output="false" 
	hint="I return the enableValidator property.">
	<cfreturn variables.instance.enableValidator  />
</cffunction>
<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>