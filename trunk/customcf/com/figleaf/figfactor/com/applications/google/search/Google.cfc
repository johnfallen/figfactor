<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			Google.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am an API for interacting with a Google Search Appliance
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		22/01/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Google" output="false"
	hint="I am an API for interacting with a Google Search Appliance">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Google" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfset var xml = 0 />

	<!--- holds the XML config data if used as a stand alone application --->
	<cfset variables.init = structNew() />
	
	<!--- toggle for developement. 'development' will return fake search results --->
	<cfset variables.init.mode = "development" />
	
	<!--- this will be the final struct of config data, incomming or xml --->
	<cfset variables.configData = structNew() />
	
	<!--- CONSTANTS --->
	<cfset variables.init.sortRelavenceURLIndicator = "R" />
	<cfset variables.init.sortDateURLIndicator = "L" />
	<cfset variables.init.formMethod = "get" />
	
	<!--- use FigFactors configuration struct if passed, else the XML file --->
	<cfif structKeyExists(arguments, "BeanFactory")>
		<cfset setConfigData(variables.Beanfactory.getBean("ConfigBean").getInstance()) />
	<cfelse>
		<cfset setXMLConfig() />
		<cfset setConfigData(getXMLConfig())  />
	</cfif>
		
	<cffile 
		action="read" 
		file="#getDirectoryFromPath(GetCurrentTemplatePath())#resource/config/GoogleMetaDataProperties.xml" 
		variable="xml" />
	
	<cfset variables.instance.SearchService = 
		createObject("component", "com.search.SearchService").init(
			configData = getConfigData(),
			input = createObject("component", "com.util.input.Input").init()) />
	
	<cfset variables.instance.FormService = 
		createObject("component", "com.form.FormService").init(
			configData = getConfigData(),
			metadataProperties = xml,
			input = createObject("component", "com.util.input.Input").init()) />

	<cfreturn this />
</cffunction>



<!--- getConfigData --->
<cffunction name="getConfigData" access="public" output="false" returntype="struct" 
	displayname="Get Config Data" hint="I return the data used to configure this instace of Google.cfc." 
	description="I return the data used to configure this instance of Google.cfc. I am set at start up.">

	<cfreturn variables.instance.ConfigData />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
    displayname="Get Instance" hint="I return my internal variables instance scope data."
    description="I return my internal variables instance scope data.">
    
    <cfreturn variables.instace />
</cffunction>



<!--- getSearchForm --->
<cffunction name="getSearchForm" returntype="string" access="public" output="false"
	displayname="Get Search Form" hint="I retrun a string that is an HTML form and will format or include various fields base on the arguments passed to me."
	Description="I retrun a string that is an HTML form and will format or include various fields base on the arguments passed to me.">

	<cfargument name="breakButton" type="boolean"  default="false" 
		hint="Should the submit button be on a seperate line than the text input? I default to false." />
	<cfargument name="buttonValue" type="string"
		hint="I am the value to appear in the submit button. I default to a configured variable." />
	<cfargument name="formClass" type="string"
		hint="I am the name of the form. I default to a configured variable." />
	<cfargument name="formID" type="string" 
		hint="I am the ID of the form. I default to a configured variable." />
	<cfargument name="formName" type="string" 
		hint="I am the name of the form. I default to a configured variable." />
	<cfargument name="formAction" type="string"
		hint="I am the url to post to. I default to a configured variable. " />
	<cfargument name="formMethod" type="string"
		hint="I am the method the form uses to submit itself. I default to 'post', a configured variable." />
	<cfargument name="formContent" type="string" 
		hint="I am the content of the text input. I default to an empty string." />
	<cfargument name="formInputSize" type="numeric" 
		hint="I am the size of the text input field. I default to '25', a configured variable" />
	<cfargument name="formInputMaxLength" type="numeric" 
		hint="I am the maximum length for the text input field. I default to '255', a configured variable." />
    <cfargument name="formInputClass" type="string" 
		hint="I am the maximum length for the text input field. I default to a configured variable." />
    <cfargument name="formInputButtonClass" type="string"  
		hint="I am the maximum length for the text input field. I default to a configured variable." />
    <cfargument name="formInputButtonID" type="string" 
		hint="I am the maximum length for the text input field. I default to a configured variable." />
	<cfargument name="hiddenFieldsOnly" type="boolean"
		hint="Only return the hidden fields with the correct values? I default to 'false', a configurable variable." />
	<cfargument name="includePropertyFields" type="boolean" 
		hint="Should I return form fields that query metadata? I default to 'false', a configurable variable." />
	<cfargument name="propertyPackageName" type="string" default=""
		hint="I am the name of the XML package node to return as form fields? I default a configurable variable." />
		
	<cfreturn variables.instance.FormService.getSearchForm(argumentCollection = arguments) />
</cffunction>



<!--- getSearch --->
<cffunction name="getSearch" returntype="any" access="public" output="false"
	displayname="Get Search" hint="I return an object with the search results formatted based on a configuration setting and other data helpfull for rendering search results."
	description="I return an object with the search results formatted based on a configuration setting and other data helpfull for rendering search results.">

	<cfreturn variables.instance.SearchService.getSearch() />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- setConfigData --->
<cffunction name="setConfigData" access="private" output="false" returntype="void" 
	displayname="Set Config Data" hint="I set my internal configuration structure." 
	description="I set my internal configuration structure.">
	
	<cfargument name="ConfigData" type="struct" required="true" 
		hint="I am the configuration structure. I am required."/>
	
	<cfset variables.instance.ConfigData = arguments.ConfigData />
	
</cffunction>



<!--- getXMLConfig --->
<cffunction name="getXMLConfig" returntype="struct" access="private" output="false"
    displayname="Get XML Config" hint="I return a structre of values set in the XML configuration file."
    description="I return a structre of values set in the XML configuration file.">
    
    <cfreturn variables.init />
</cffunction>



<!--- setXMLConfig --->
<cffunction name="setXMLConfig" returntype="void" access="private" output="false"
    displayname="Set XML Config" hint="I set the inital configuration settings."
    description="I read an XML file and set an structure of its key value pairs to my interal variables scope and also configure a few CONSTANTS not in the config file.">
    
	<cfset var xml = 0 />
	<cfset var x = 0 />
	<cfset var y = 0 />
	
	<cffile 
		action="read" 
		file="#getDirectoryFromPath(GetCurrentTemplatePath())#resource/config/gcini.cfm" 
		variable="xml" />
	
	<cfloop array="#xmlSearch(xml, '/config/package')#" index="x">
		
		<cfloop array="#x.XmlChildren#" index="y">
			
			<cfset variables.init[y.XmlAttributes.name] = y.XmlAttributes.value /> 
		</cfloop>
	</cfloop>
</cffunction>
</cfcomponent>