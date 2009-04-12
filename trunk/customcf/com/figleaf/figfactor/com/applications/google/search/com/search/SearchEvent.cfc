<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			Event.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I model a search event
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		11/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Search Event" output="false"
	hint="I model a search event">

<!--- the list of fields that we will never have the encoding or decoding happen, keep uper case --->
<cfset variables.CONSTANTS.EXCLUDED_FIELDS = "PARTIALFIELDS,REQUIREDFIELDS,SEARCHSERVER,OUTPUT,DEFAULTXSLTFILENAME" />
<cfset variables.CONSTANTS.PARTIAL_FIELDS_KEY = "PARTIALFIELDS_" />
<cfset variables.CONSTANTS.REQUIRED_FIELDS_KEY = "REQUIREDFIELDS_" />

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="SearchEvent" access="public" output="false" 
	displayname="Init" hint="I am the constructor. I send the search directive, save, render, and populate myself" 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="configData" type="struct" required="true" 
		hint="I am the configuration structure. I am requried." />
	<cfargument name="input" type="struct" required="true" 
		hint="I am the FORM and URL input values. I am requried." />

	<!--- populate the inital instance of this search request with default configured values --->
	<cfset setInstanceVariables(arguments.configData) />
		
	<!--- set the origional input values, usefull for debugging--->
	<cfset setOrigionalInput(duplicate(arguments.input))>
	
	<!--- parse out the required and partial fields (this adds them to my instance) --->
	<cfset parsePartialAndRequiredFields(getOrigionalInput()) />
		
	<!--- now overwright any instance values with the input data --->
	<cfset mergeInput(getOrigionalInput()) />

	<!--- encode my instance data, were about to send --->
	<cfset encoding(type = "encode") />
	
	<!--- real or fake search? --->
	<cfif getMode() neq "development">
		<cfset sendSearchDirective() />
	<cfelse>
		<cfset mockSearchDirective() />
	</cfif>
	
	<cfreturn this />
</cffunction>



<!--- getSearchResultXMLNode --->
<cffunction name="getSearchResultXMLNode" returntype="array" access="public" output="false"
    displayname="Get Search Result XML Node" hint="I retun a node from the search result by name."
    description="I retun a node from the search result by name.">
	
	<cfargument name="node" type="string" required="true" 
		hint="I am the name of the node. I am requried." />
	
	<cfreturn xmlSearch(getSearchResultXML(), "//#arguments.node#") />
</cffunction>



<!--- getSearchParams --->
<cffunction name="getSearchParams" returntype="array" access="public" output="false"
    displayname="Get Search Params" hint="I return the search paramaters that were sent to google."
    description="I return the search paramaters that were sent to google. I am a helper function for developers.">
    
	<cfset var xmlArray = xmlSearch(getSearchResultXML(), "//PARAM") />
	<cfset var result = arrayNew(1) />
	<cfset var x = 0 />
	<cfloop array="#xmlArray#" index="x">
		<cfset arrayAppend(result, x.XmlAttributes) />
	</cfloop>
    <cfreturn result />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- SearchResultXML --->
<cffunction name="setSearchResultXML" access="public" output="false" returntype="void">
	<cfargument name="SearchResultXML" type="xml" required="true"/>
	<cfset variables.instance.SearchResultXML = arguments.SearchResultXML />
</cffunction>
<cffunction name="getSearchResultXML" access="public" output="false" returntype="xml">
	<cfreturn variables.instance.SearchResultXML />
</cffunction>
<!--- Access --->
<cffunction name="setAccess" access="private" output="false" returntype="void">
	<cfargument name="Access" type="string" required="true"/>
	<cfset variables.instance.Access = arguments.Access />
</cffunction>
<cffunction name="getAccess" access="public" output="false" returntype="string">
	<cfreturn variables.instance.Access />
</cffunction>
<!--- AS_DT --->
<cffunction name="setAS_DT" access="private" output="false" returntype="void">
	<cfargument name="AS_DT" type="string" required="true"/>
	<cfset variables.instance.AS_DT = arguments.AS_DT />
</cffunction>
<cffunction name="getAS_DT" access="public" output="false" returntype="string">
	<cfreturn variables.instance.AS_DT />
</cffunction>
<!--- AS_EPQ --->
<cffunction name="setAS_EPQ" access="private" output="false" returntype="void">
	<cfargument name="AS_EPQ" type="string" required="true"/>
	<cfset variables.instance.AS_EPQ = arguments.AS_EPQ />
</cffunction>
<cffunction name="getAS_EPQ" access="public" output="false" returntype="string">
	<cfreturn variables.instance.AS_EPQ />
</cffunction>
<!--- AS_EQ --->
<cffunction name="setAS_EQ" access="private" output="false" returntype="void">
	<cfargument name="AS_EQ" type="string" required="true"/>
	<cfset variables.instance.AS_EQ = arguments.AS_EQ />
</cffunction>
<cffunction name="getAS_EQ" access="public" output="false" returntype="string">
	<cfreturn variables.instance.AS_EQ />
</cffunction>
<!--- AS_LQ --->
<cffunction name="setAS_LQ" access="private" output="false" returntype="void">
	<cfargument name="AS_LQ" type="string" required="true"/>
	<cfset variables.instance.AS_LQ = arguments.AS_LQ />
</cffunction>
<cffunction name="getAS_LQ" access="public" output="false" returntype="string">
	<cfreturn variables.instance.AS_LQ />
</cffunction>
<!--- AS_OCCT --->
<cffunction name="setAS_OCCT" access="private" output="false" returntype="void">
	<cfargument name="AS_OCCT" type="string" required="true"/>
	<cfset variables.instance.AS_OCCT = arguments.AS_OCCT />
</cffunction>
<cffunction name="getAS_OCCT" access="public" output="false" returntype="string">
	<cfreturn variables.instance.AS_OCCT />
</cffunction>
<!--- AS_OQ --->
<cffunction name="setAS_OQ" access="private" output="false" returntype="void">
	<cfargument name="AS_OQ" type="string" required="true"/>
	<cfset variables.instance.AS_OQ = arguments.AS_OQ />
</cffunction>
<cffunction name="getAS_OQ" access="public" output="false" returntype="string">
	<cfreturn variables.instance.AS_OQ />
</cffunction>
<!--- AS_Q --->
<cffunction name="setAS_Q" access="private" output="false" returntype="void">
	<cfargument name="AS_Q" type="string" required="true"/>
	<cfset variables.instance.AS_Q = arguments.AS_Q />
</cffunction>
<cffunction name="getAS_Q" access="public" output="false" returntype="string">
	<cfreturn variables.instance.AS_Q />
</cffunction>
<!--- AS_SiteSearch --->
<cffunction name="setAS_SiteSearch" access="private" output="false" returntype="void">
	<cfargument name="AS_SiteSearch" type="string" required="true"/>
	<cfset variables.instance.AS_SiteSearch = arguments.AS_SiteSearch />
</cffunction>
<cffunction name="getAS_SiteSearch" access="public" output="false" returntype="string">
	<cfreturn variables.instance.AS_SiteSearch />
</cffunction>
<!--- Client --->
<cffunction name="setClient" access="private" output="false" returntype="void">
	<cfargument name="Client" type="string" required="true"/>
	<cfset variables.instance.Client = arguments.Client />
</cffunction>
<cffunction name="getClient" access="public" output="false" returntype="string">
	<cfreturn variables.instance.Client />
</cffunction>
<!--- Entqr --->
<cffunction name="setEntqr" access="private" output="false" returntype="void">
	<cfargument name="Entqr" type="numeric" required="true"/>
	<cfset variables.instance.Entqr = arguments.Entqr />
</cffunction>
<cffunction name="getEntqr" access="public" output="false" returntype="numeric">
	<cfreturn variables.instance.Entqr />
</cffunction>
<!--- Entsp --->
<cffunction name="setEntsp" access="private" output="false" returntype="void">
	<cfargument name="Entsp" type="string" required="true"/>
	<cfset variables.instance.Entsp = arguments.Entsp />
</cffunction>
<cffunction name="getEntsp" access="public" output="false" returntype="string">
	<cfreturn variables.instance.Entsp />
</cffunction>
<!--- Filter --->
<cffunction name="setFilter" access="private" output="false" returntype="void">
	<cfargument name="Filter" type="numeric" required="true"/>
	<cfset variables.instance.Filter = arguments.Filter />
</cffunction>
<cffunction name="getFilter" access="public" output="false" returntype="numeric">
	<cfreturn variables.instance.Filter />
</cffunction>
<!--- GetFields --->
<cffunction name="setGetFields" access="private" output="false" returntype="void">
	<cfargument name="GetFields" type="string" required="true"/>
	<cfset variables.instance.GetFields = arguments.GetFields />
</cffunction>
<cffunction name="getGetFields" access="public" output="false" returntype="string">
	<cfreturn variables.instance.GetFields />
</cffunction>
<!--- IE --->
<cffunction name="setIE" access="private" output="false" returntype="void">
	<cfargument name="IE" type="string" required="true"/>
	<cfset variables.instance.IE = arguments.IE />
</cffunction>
<cffunction name="getIE" access="public" output="false" returntype="string">
	<cfreturn variables.instance.IE />
</cffunction>
<!--- LR --->
<cffunction name="setLR" access="private" output="false" returntype="void">
	<cfargument name="LR" type="string" required="true"/>
	<cfset variables.instance.LR = arguments.LR />
</cffunction>
<cffunction name="getLR" access="public" output="false" returntype="string">
	<cfreturn variables.instance.LR />
</cffunction>
<!--- Num --->
<cffunction name="setNum" access="private" output="false" returntype="void">
	<cfargument name="Num" type="numeric" required="true"/>
	<cfset variables.instance.Num = arguments.Num />
</cffunction>
<cffunction name="getNum" access="public" output="false" returntype="numeric">
	<cfreturn variables.instance.Num />
</cffunction>
<!--- Numgm --->
<cffunction name="setNumgm" access="private" output="false" returntype="void">
	<cfargument name="Numgm" type="numeric" required="true"/>
	<cfset variables.instance.Numgm = arguments.Numgm />
</cffunction>
<cffunction name="getNumgm" access="public" output="false" returntype="numeric">
	<cfreturn variables.instance.Numgm />
</cffunction>
<!--- OE --->
<cffunction name="setOE" access="private" output="false" returntype="void">
	<cfargument name="OE" type="string" required="true"/>
	<cfset variables.instance.OE = arguments.OE />
</cffunction>
<cffunction name="getOE" access="public" output="false" returntype="string">
	<cfreturn variables.instance.OE />
</cffunction>
<!--- Output --->
<cffunction name="setOutput" access="private" output="false" returntype="void">
	<cfargument name="Output" type="string" required="true"/>
	<cfset variables.instance.Output = arguments.Output />
</cffunction>
<cffunction name="getOutput" access="public" output="false" returntype="string">
	<cfreturn variables.instance.Output />
</cffunction>
<!--- Partialfields --->
<cffunction name="setPartialfields" access="private" output="false" returntype="void">
	<cfargument name="Partialfields" type="string" required="true"/>
	<cfset variables.instance.Partialfields = arguments.Partialfields />
</cffunction>
<cffunction name="getPartialfields" access="public" output="false" returntype="string">
	<cfreturn variables.instance.Partialfields />
</cffunction>
<!--- ProxyCustom --->
<cffunction name="setProxyCustom" access="private" output="false" returntype="void">
	<cfargument name="ProxyCustom" type="string" required="true"/>
	<cfset variables.instance.ProxyCustom = arguments.ProxyCustom />
</cffunction>
<cffunction name="getProxyCustom" access="public" output="false" returntype="string">
	<cfreturn variables.instance.ProxyCustom />
</cffunction>
<!--- ProxyReload --->
<cffunction name="setProxyReload" access="private" output="false" returntype="void">
	<cfargument name="ProxyReload" type="string" required="true"/>
	<cfset variables.instance.ProxyReload = arguments.ProxyReload />
</cffunction>
<cffunction name="getProxyReload" access="public" output="false" returntype="string">
	<cfreturn variables.instance.ProxyReload />
</cffunction>
<!--- ProxyStylesheet --->
<cffunction name="setProxyStylesheet" access="private" output="false" returntype="void">
	<cfargument name="ProxyStylesheet" type="string" required="true"/>
	<cfset variables.instance.ProxyStylesheet = arguments.ProxyStylesheet />
</cffunction>
<cffunction name="getProxyStylesheet" access="public" output="false" returntype="string">
	<cfreturn variables.instance.ProxyStylesheet />
</cffunction>
<!--- Q --->
<cffunction name="setQ" access="private" output="false" returntype="void">
	<cfargument name="Q" type="string" required="true"/>
	<cfset variables.instance.Q = arguments.Q />
</cffunction>
<cffunction name="getQ" access="public" output="false" returntype="string">
	<cfreturn variables.instance.Q />
</cffunction>
<!--- RequiredFields --->
<cffunction name="setRequiredFields" access="private" output="false" returntype="void">
	<cfargument name="RequiredFields" type="string" required="true"/>
	<cfset variables.instance.RequiredFields = arguments.RequiredFields />
</cffunction>
<cffunction name="getRequiredFields" access="public" output="false" returntype="string">
	<cfreturn variables.instance.RequiredFields />
</cffunction>
<!--- Site --->
<cffunction name="setSite" access="private" output="false" returntype="void">
	<cfargument name="Site" type="string" required="true"/>
	<cfset variables.instance.Site = arguments.Site />
</cffunction>
<cffunction name="getSite" access="public" output="false" returntype="string">
	<cfreturn variables.instance.Site />
</cffunction>
<!--- SiteSearch --->
<cffunction name="setSiteSearch" access="private" output="false" returntype="void">
	<cfargument name="SiteSearch" type="string" required="true"/>
	<cfset variables.instance.SiteSearch = arguments.SiteSearch />
</cffunction>
<cffunction name="getSiteSearch" access="public" output="false" returntype="string">
	<cfreturn variables.instance.SiteSearch />
</cffunction>
<!--- Sort --->
<cffunction name="setSort" access="private" output="false" returntype="void">
	<cfargument name="Sort" type="string" required="true"/>
	<cfset variables.instance.Sort = arguments.Sort />
</cffunction>
<cffunction name="getSort" access="public" output="false" returntype="string">
	<cfreturn variables.instance.Sort />
</cffunction>
<!--- Start --->
<cffunction name="setStart" access="private" output="false" returntype="void">
	<cfargument name="Start" type="numeric" required="true"/>
	<cfset variables.instance.Start = arguments.Start />
</cffunction>
<cffunction name="getStart" access="public" output="false" returntype="numeric">
	<cfreturn variables.instance.Start />
</cffunction>
<!--- UD --->
<cffunction name="setUD" access="private" output="false" returntype="void">
	<cfargument name="UD" type="string" required="true"/>
	<cfset variables.instance.UD = arguments.UD />
</cffunction>
<cffunction name="getUD" access="public" output="false" returntype="string">
	<cfreturn variables.instance.UD />
</cffunction>
<!--- SearchServer --->
<cffunction name="setSearchServer" access="private" output="false" returntype="void">
	<cfargument name="SearchServer" type="string" required="true"/>
	<cfset variables.instance.SearchServer = arguments.SearchServer />
</cffunction>
<cffunction name="getSearchServer" access="public" output="false" returntype="string">
	<cfreturn variables.instance.SearchServer />
</cffunction>
<!--- Btng --->
<cffunction name="setBtng" access="private" output="false" returntype="void">
	<cfargument name="Btng" type="string" required="true"/>
	<cfset variables.instance.Btng = arguments.Btng />
</cffunction>
<cffunction name="getBtng" access="public" output="false" returntype="string">
	<cfreturn variables.instance.Btng />
</cffunction>
<!--- DefaultReturnFormat --->
<cffunction name="setDefaultReturnFormat" access="private" output="false" returntype="void">
	<cfargument name="DefaultReturnFormat" type="string" required="true"/>
	<cfset variables.instance.DefaultReturnFormat = arguments.DefaultReturnFormat />
</cffunction>
<cffunction name="getDefaultReturnFormat" access="public" output="false" returntype="string">
	<cfreturn variables.instance.DefaultReturnFormat />
</cffunction>
<!--- Mode --->
<cffunction name="setMode" access="private" output="false" returntype="void">
	<cfargument name="Mode" type="string" required="true"/>
	<cfset variables.instance.Mode = arguments.Mode />
</cffunction>
<cffunction name="getMode" access="public" output="false" returntype="string">
	<cfreturn variables.instance.Mode />
</cffunction>
<!--- DefaultXSLTFileName --->
<cffunction name="setDefaultXSLTFileName" access="private" output="false" returntype="void">
	<cfargument name="DefaultXSLTFileName" type="string" required="true"/>
	<cfset variables.instance.DefaultXSLTFileName = arguments.DefaultXSLTFileName />
</cffunction>
<cffunction name="getDefaultXSLTFileName" access="public" output="false" returntype="string">
	<cfreturn variables.instance.DefaultXSLTFileName />
</cffunction>
<!--- OrigionalInput --->
<cffunction name="setOrigionalInput" access="private" output="false" returntype="void">
	<cfargument name="OrigionalInput" type="struct" required="true"/>
	<cfset variables.instance.OrigionalInput = arguments.OrigionalInput />
</cffunction>
<cffunction name="getOrigionalInput" access="public" output="false" returntype="struct">
	<cfreturn variables.instance.OrigionalInput />
</cffunction>
<!--- Results --->
<cffunction name="setResults" access="public" output="false" returntype="void">
	<cfargument name="Results" type="any" required="true"/>
	<cfset variables.instance.Results = arguments.Results />
</cffunction>
<cffunction name="getResults" access="public" output="false" returntype="any">
	<cfreturn variables.instance.Results />
</cffunction>
<!--- getLoggedSearchDirectives --->
<cffunction name="getLoggedSearchDirectives" access="public" output="false" returntype="struct"
	displayname="Get LoggedSearchDirectives" hint="I return the LoggedSearchDirectives property." 
	description="I return the LoggedSearchDirectives property to my internal instance structure.">
	<cfif structKeyExists(variables.instance, "LoggedSearchDirectives")>
		<cfreturn variables.instance.LoggedSearchDirectives />
	<cfelse>
		<cfreturn structNew() />
	</cfif>
</cffunction>
<!--- setLoggedSearchDirectives --->
<cffunction name="setLoggedSearchDirectives" access="public" output="false" returntype="void"
	displayname="Set LoggedSearchDirectives" hint="I set the LoggedSearchDirectives property." 
	description="I set the LoggedSearchDirectives property to my internal instance structure.">
	<cfargument name="LoggedSearchDirectives" type="struct" required="true"
		hint="I am the LoggedSearchDirectives property. I am required."/>
	<cfset variables.instance.LoggedSearchDirectives = arguments.LoggedSearchDirectives />
</cffunction>
<!--- getLoggedCFHTTPReturn --->
<cffunction name="getLoggedCFHTTPReturn" access="public" output="false" returntype="any"
	displayname="Get LoggedCFHTTPReturn" hint="I return the LoggedCFHTTPReturn property." 
	description="I return the LoggedCFHTTPReturn property to my internal instance structure.">
	<cfif structKeyExists(variables.instance, "LoggedCFHTTPReturn")>
		<cfreturn variables.instance.LoggedCFHTTPReturn />
	<cfelse>
		<cfreturn structNew() />
	</cfif>
</cffunction>
<!--- setLoggedCFHTTPReturn --->
<cffunction name="setLoggedCFHTTPReturn" access="public" output="false" returntype="void"
	displayname="Set LoggedCFHTTPReturn" hint="I set the LoggedCFHTTPReturn property." 
	description="I set the LoggedCFHTTPReturn property to my internal instance structure.">
	<cfargument name="LoggedCFHTTPReturn" type="any" required="true"
		hint="I am the LoggedCFHTTPReturn property. I am required."/>
	<cfset variables.instance.LoggedCFHTTPReturn = arguments.LoggedCFHTTPReturn />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- encoding --->
<cffunction name="encoding" returntype="void" access="private" output="false"
    displayname="Encode" hint="I handle the URL deconding and encoding of my internal instance variables."
    description="I handle the URL deconding and encoding of my internal instance variables based on the arguments and life cycle.">
    
	<cfargument name="type" type="string" required="false" default="" 
		hint="I am the type of encoding to do. I default to an empty string." />
	
	<cfset var i = 0 />
	<cfset var excludeFields = variables.CONSTANTS.EXCLUDED_FIELDS />
	
	<!--- encode --->
	<cfif arguments.type eq "encode">
		
		<cfloop collection="#variables.instance#" item="i">
			
			<cfif isSimpleValue(variables.instance[i]) and not ListContains(excludeFields, i)>
				<cfset variables.instance[i] = URLEncodedFormat(variables.instance[i]) />
			</cfif>	
		</cfloop>
	</cfif>

	<!--- Decode --->
	<cfif arguments.type eq "decode">
		
		<cfloop collection="#variables.instance#" item="i">
			
			<!--- the instance struct has some non simple values so handle --->
			<cfif isSimpleValue(variables.instance[i]) and not ListContains(excludeFields, i)>
				<cfset variables.instance[i] = URLDecode(variables.instance[i]) />
			</cfif>
		</cfloop>
	</cfif>

</cffunction>



<!--- sendSearchDirective --->
<cffunction name="sendSearchDirective" returntype="void" access="private" output="false"
	displayname="Send Search Directive" hint="I send a search directive to a Google appliance an retrun the XML."
	description="I send a search directive to a Google appliance an retrun the XML or formatted HTML.">
	
	<!--- 
		Capture the sent values in this structure. Very helpfull for a variatey 
		of situations when developing and one easily wants to introspect the
		_EXACT_ values that were sent to the GSA.
	--->
	<cfset var sent = structNew() />

	<!--- send the search directive to GSA --->
	<cfhttp method="get" url="#getSearchServer()#">
		
		<cfset sent._searchServerURL = getSearchServer() />
		
		<!--- access --->
		<cfif len(getAccess())>
			<cfhttpparam type="url" name="access" value="#getAccess()#" />
			<cfset sent._access = getAccess() />
		</cfif>
		
		<!--- btng --->
		<cfif len(getBtnG())>
			<cfhttpparam type="url" name="btnG" value="#getBtnG()#" />
			<cfset sent._btng = getBtnG() />
		</cfif>

		<!--- client --->
		<cfif len(getClient())>
			<cfhttpparam type="url" name="client" value="default_frontend" />
			<cfset sent._Client = getClient() />
`		</cfif>
		
		<!--- filter --->
		<cfif len(getFilter())>
			<cfhttpparam type="url" name="filter" value="#getFilter()#" />
			<cfset sent._Filter = getFilter() />
		</cfif>
		
		<!--- getFields --->
		<cfif len(getGetFields())>
			<cfhttpparam type="url" name="getfields" value="*" />
			<cfset sent._GetFields = getGetFields() />
		</cfif>
		
		<!--- ie --->
		<cfif len(getIE())>
			<cfhttpparam type="url" name="ie" value="#getIE()#" />
			<cfset sent._IE = getIE() />
		</cfif>
		
		<!--- num --->
		<cfif len(getNum())>
			<cfhttpparam type="url" name="num" value="#getNum()#" />
			<cfset sent._Num = getNum() />
		</cfif>
		
		<!--- oe --->
		<cfif len(getOE())>
			<cfhttpparam type="url" name="oe"  value="#URLDecode(getOE())#" />
			<cfset sent._OE = getOE() />
		</cfif>
		
		<!--- output  --->
		<cfif len(getOutput())>
			<cfhttpparam type="url" name="output" value="xml_no_dtd" />
			<cfset sent._Output = getOutput() />
		</cfif>
		
		<!--- proxyreload --->
		<cfif len(getProxyreload())>
			<cfhttpparam type="url" name="proxyreload" value="#getProxyreload()#"/>
			<cfset sent._Proxyreload = getProxyreload() />
		</cfif>
		
		<!--- q --->
		<cfif len(getQ())>
			<cfhttpparam type="url" name="q" value="#getQ()#" />
			<cfset sent._q = getQ() />
		<cfelse><!--- we need to send something --->
			<cfhttpparam type="url" name="q" value=" " />
		</cfif>
		
		<!--- getSite--->
		<cfif len(getSite())>
			<cfhttpparam type="url" name="site" value="#getSite()#" />
			<cfset sent._Site = getSite() />
		</cfif>
		 
		<!--- getStart --->
		<cfif len(getStart())>
			<cfhttpparam type="url" name="start" value="#getStart()#" />
			<cfset sent._start = getStart() />
		<cfelse><!--- send 0 as a default --->
			<cfhttpparam type="url" name="start" value="0" />
		</cfif>
		
		<!--- sort --->
		<cfif getSort() eq "L"><!--- relevance --->
			<cfhttpparam type="url" name="sort" value="date:D:L:d1" encoded="true" />
			<cfset sent._sort = "#URLEncodedFormat('date:D:L:d1')#" />
		<cfelse><!--- date --->
			<cfhttpparam type="url" name="sort" value="date:D:R:d1" encoded="true" />
			<cfset sent._sort = "#URLEncodedFormat('date:D:R:d1')#" />
		</cfif>
		
		<!--- partialfields --->
		<cfif len(getPartialfields())>
			<cfhttpparam type="url" name="partialfields" value="#getPartialfields()#" encoded="false" />
			<cfset sent._partialFields = getPartialfields() />
		</cfif>
		
		<!--- required fields --->
		<cfif len(getRequiredfields())>
			<cfhttpparam type="url" name="requiredfields" value="#getRequiredfields()#" encoded="false" />
			<cfset sent._requiredFields = getRequiredfields() />
		</cfif>
	</cfhttp>
	
	<!--- stuff usefull for development and debugging --->
	<cfset setLoggedSearchDirectives(sent) />
	<cfset setLoggedCFHTTPReturn(cfhttp) />

	<cftry>
		<cfset setSearchResultXML(xmlParse(cfhttp.FileContent)) />
		<cfcatch>
			<cfset throw(
				error = cfcatch, 
				args = sent, 
				developerNote = "These arguments are what has been sent to the GSA and the CFHTTP responce content.") />
		</cfcatch>
	</cftry>
	
</cffunction>



<!--- mockSearchDirective --->
<cffunction name="mockSearchDirective" returntype="void" access="private" output="false"
    displayname="Mock Search Directive" hint="I act like a real search, but only return local XML."
    description="I act like a real search, but only return local XML.">
    
	<cfset var xmlFile = 0 />
	
	<cffile action="read" file ="#getDirectoryFromPath(getCurrentTemplatePath())#mockdata/mocksesearchresultXML.xml" variable="xmlFile" />
	
   <cfset setSearchResultXML(xmlParse(xmlFile)) />

</cffunction>



<!--- parsePartialAndRequiredFields --->
<cffunction name="parsePartialAndRequiredFields" returntype="struct" access="private" output="false"
	displayName="Parse Partial and Required Fields" hint="I encode google formatted required and partial field URL paramaters."
	Description="I encode google formatted required and partial field URL paramaters.">
	
	<cfargument name="input" type="struct" required="true" default=""
		hint="I am the string to double URL encode.<br />I am required." />
	
	<cfset var newPartialFields = "" />
	<cfset var newRequiredFields = "" />
	<cfset var x = 0 />
	<cfset var key = "" />
	<cfset var value = "" />
	<cfset var keyValueString = "" />
	<cfset var partialFieldsKey = variables.CONSTANTS.PARTIAL_FIELDS_KEY />
	<cfset var requiredFieldsKey = variables.CONSTANTS.REQUIRED_FIELDS_KEY />
	
	<cfloop collection="#arguments.input#" item="x">

		<cfif lcase(x) contains partialFieldsKey>	
			<cfset key = lcase( replaceNoCase( x, partialFieldsKey, "", "all") ) />
			<cfset value = trim(input[x]) />
			<cfif len(value)>
				<cfset keyValueString = URLEncodedFormat(key) & ":" & URLEncodedFormat(value) />
				<cfset newPartialFields = listAppend(newPartialFields, "#keyValueString#", "|") />
			</cfif>
		</cfif>
		
		<cfif x contains requiredFieldsKey>	
			<cfset key = lcase( replaceNoCase(x, requiredFieldsKey, "", "all") ) />
			<cfset value = trim(input[x]) />
			<cfif len(value)>
				<cfset keyValueString = URLEncodedFormat(URLEncodedFormat(key)) & ":" & URLEncodedFormat(URLEncodedFormat(value)) />
				<cfset newRequiredFields = listAppend(newRequiredFields, "#keyValueString#", "|") />
			</cfif>
		</cfif>
	</cfloop>

	<!--- overwrite the inputs values if needed --->
	<cfif len(newPartialFields)>
		<cfset setPartialfields(newPartialFields) />
	</cfif>
	<cfif len(newRequiredFields)>
		<cfset setRequiredFields(newRequiredFields) />
	</cfif>

	<cfreturn arguments.input />
</cffunction>



<!--- mergeInput --->
<cffunction name="mergeInput" returntype="void" access="public" output="false"
    displayname="Merge Input" hint="I merge the input and instance data."
    description="I merge the input and instance data.">

	<cfset var y = 0 />
	<cfset var z = 0 />
	<cfset var inputData = getOrigionalInput() />

	<cfloop collection="#inputData#" item="y">		
		<cfloop collection="#variables.instance#" item="z">
			<cfif z eq y>
				<cfset variables.instance[z] = inputData[y] />
			</cfif>
		</cfloop>
	</cfloop>
</cffunction>



<!--- setInstanceVariables --->
<cffunction name="setInstanceVariables" returntype="void" access="private" output="false"
    displayname="Set Instance Variables" hint="I set the internal variable scope data."
    description="I set the internal variable scope data. Pass me a structure with any keys that match the API's properties (getters/setters) and I will populate my internal variables.instance scope with the value.">
    
	<cfargument name="data" type="struct" required="false" default="#variables.instance#" 
		hint="I am a structure to populate my internals with. I defalut to another internaly stored structure." />
	
	<cfset var x = 0 />
	<cfset var y = 0 />
	<cfset var functionCall = 0 />
	
	<!--- loop over the collection, then the array of functions --->
	<cfloop collection="#arguments.data#" item="y">
		<cfloop array="#getMetaData(this).functions#" index="x">

			<cfif 
				y eq right( x.name, ( len(x.name)-3) ) 
				and 
				left(x.name, 3) eq "set">
				
				<cfset functionCall = evaluate(#x.name#) />
				<cftry>
					<cfset functionCall(arguments.data[y]) />
				<cfcatch></cfcatch>
				</cftry>
				<cfbreak />
			</cfif>
		</cfloop>
	</cfloop>

</cffunction>



<!--- throw --->
<cffunction name="throw" returntype="void" access="private" output="false"
    displayname="Throw Error" hint="I execute the cfthrow tag."
    description="I execute the cfthrow tag. Use me as a wrapper for the real CFML tag.">
	
	<cfargument name="error" type="any" required="true" 
		hint="I am the Error Result. I am requried." />
	<cfargument name="args" type="struct" required="false" default="#structNew()#"
		hint="I am the argumets passed to the method being executed. I default to an empty struct." />
	<cfargument name="developerNote" type="string" required="false" default="" 
		hint="I am a note to add to the CFMESSAGE text. I default to an empty string." />

	<cfset var note = "" />
	<cfset var mesage = "" />
	<cfset var _error = arguments.error />
	<cfset var _args = arguments.args>
	<cfset var argumentList = "" />
	<cfset var arg = structNew() />

<!--- developer note --->
<cfif len(arguments.developerNote)>
	<cfsavecontent variable="note">
		<cfoutput>
			<hr />
			<strong>Developer Note:</strong><br />
			#arguments.developerNote#
		</cfoutput>
	</cfsavecontent>
</cfif>

<!--- make the display of the arguments --->
<cfif StructCount(args)>
	<cfsavecontent variable="argumentList">
		<cfoutput>
			<hr />
			<strong>Arguments:</strong>
			<table border="0" style="font-size:.80em;margin-top:5px;" cellpadding="0" cellspacing="0">
			<tr style="background-color:##000000; color:##ffffff;">
				<th align="left" style="border:solid 1px black; padding-bottom:3px;border-right:none;padding:5px;">Key</th>
				<th align="left" style="border:solid 1px black; padding-bottom:3px;padding:5px;">Value</th>
			</tr>
			<cfloop collection="#_args#" item="arg">
				<cfif isSimpleValue(_args[arg])>
					<tr bgcolor="##efefef">
						<td style="background-color:##ffddff;border:solid 1px black; padding:5px; margin-bottom:5px; border-right:none;border-top:none;"><strong>#arg#</strong></td>
						<td style="border:solid 1px black; padding:5px; margin-bottom:5px; border-left:solid 1px black;margin-left:-3px;border-top:none;">#_args[arg]#&nbsp;</td>
					</tr>
				</cfif>
			</cfloop>
			</table>
		</cfoutput>
	</cfsavecontent>
</cfif>

<!--- make the message to display --->
<cfsavecontent variable="message">
<cfoutput>
<strong>Message:</strong> #_error.Message#<br />
<strong>Detail:</strong> #_error.Detail#<br />
<strong>Component:</strong> #listFirst(replace(ListLast(_error.TagContext[1].RAW_TRACE, "\"), ")", ""), ":")#<br />
<strong>Function:</strong> #replace(listFirst(listGetAt(_error.TagContext[1].RAW_TRACE, 2, "$"), "."), "func", "")#<br />
<strong>Line Number:</strong> #listLast(replace(ListLast(_error.TagContext[1].RAW_TRACE, "\"), ")", ""), ":")#<br />
<cfif len(note)>#note#</cfif>
<cfif len(argumentList)>#argumentList#</cfif>
</cfoutput>
</cfsavecontent>

	<!--- ERROR MESSAGE --->
	<cfthrow  detail="#message#" />
</cffunction>
</cfcomponent>