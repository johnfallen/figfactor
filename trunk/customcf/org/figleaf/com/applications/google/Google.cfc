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

<cfset variables.NEXT_LINK_TEXT = "Next &raquo;" />
<cfset variables.PREVIOUS_LINK_TEXT = "&laquo; Previous" />
<cfset variables.SORT_BY_DATE_TEXT = "Sort By Date" />
<cfset variables.SORT_BY_RELIVANCE_TEXT = "Sort By Relevance" />
<cfset variables.GOOGLE_SORT_RELEVANCE_URL_INDICATOR = "R" />
<cfset variables.GOOGLE_SORT_DATE_URL_INDICATOR = "L" />
<cfset variables.GOOGLE_LINK_SEPERATOR = "&nbsp;|&nbsp;">


<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Google" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="BeanFactory" default="#application.BeanFactory#" 
		hint="I am FigFactor's BeanFactory object.<br />I default to 'Application.BeanFactory'." />
	
	<cfset variables.config = arguments.beanFactory.getBean("Config") />
	<cfset variables.FileSystem = arguments.beanFactory.getBean("FileSystem") />
	
	<cfset variables.instance = structNew() />
	
	<cfset setSearchServer(variables.config.getGoogleURL()) />
	<cfset setAccess(variables.config.getGoogleAccess()) />
	<cfset setBtnG(variables.config.getGoogleButtonText()) />
	<cfset setClient(variables.config.getGoogleClient()) />
	<cfset setIe(variables.config.getGoogleIe()) />
	<cfset setProxyreload(variables.config.getGoogleProxyReload()) />
	<cfset setGetFields(variables.config.getGoogleGetFields()) />
	<cfset setOutput(variables.config.getGoogleOutput()) />
	<cfset setOe(variables.config.getGoogleIe()) />
	<cfset setSite(variables.config.getGoogleSiteScope()) />
	<cfset setNum(variables.config.getGoogleResultsNumber()) />
	<cfset setFilter(variables.config.getGoogleFilter()) />
	<cfset setSortType(variables.config.getGoogleSortType()) />
	
	<!--- these should be encapsulated? or change the above? --->
	<cfset variables.googleOutputFormat = variables.config.getGoogleOutputFormat() />
	<cfset variables.GoogleDisplaySortOptions = variables.config.getGoogleDisplaySortOptions() />
	<cfset variables.formMethod = "get" />
	<cfset variables.searchFromAction = variables.config.getSearchFormAction() />
	<cfset variables.breakButton = variables.config.getSearchFormBreakButton() />
	<cfset variables.buttonValue = getBtnG() />
	<cfset variables.formClass = variables.config.getSearchFormClass() />
	<cfset variables.formID = variables.config.getSearchFormID() />
	<cfset variables.formName = variables.config.getSearchFormName() />

	<cfreturn this />
</cffunction>



<!--- search --->
<cffunction name="search" returntype="any" access="public" output="false"
	displayname="Search" hint="I return search results from a Google Appliance."
	description="I return search results from a Google appliance in XML or formatted HTML.">
	
	<cfargument name="searchString" type="string" required="false" default="" 
		hint="I am the search string.<br />I default to an empty string." />
	<cfargument name="returnFormat" type="string" required="false" default="#variables.googleOutputFormat#" 
		hint="I decide the return format of the search result. My options are 'HTML' and 'XML'.<br />I default to 'HTML'" />
	<cfargument name="showRelevanceLinks" type="boolean" default="#variables.GoogleDisplaySortOptions#" 
		hint="Show the sort by relevance links?<br />I default to a configurable value." />
	
	<cfset var result = "" />
	<cfset var searchDirectiveArgs = structNew() />
	<cfset var input = structNew() />
	<cfset var pageEvent = application.viewFramework.getPageEvent() />
	
	<!---  
		This method 
		1. Collects all the input URL and FORM values from the input object
		2. URLDecodes the entire Input collection, 
		3. parses out the partialfields and requiredfields into required format 
		4. then sends a duplicate of the input struct to the sendSearchDirective()
			because values will be changed to double URLEncodedFormat
		5. and returns the requested format, HTML (default) or XML	
	--->
	
	<cfset input = application.BeanFactory.getBean("Input").load() />
	<cfset input = decodeInput(input) />
	<cfset input = parsePartialAndRequiredFields(input) />
	<cfset searchDirectiveArgs = duplicate(input) />

	<!--- hit the appliance, or get a mock XML object via configuration --->
	<cfset result = sendSearchDirective(argumentCollection = searchDirectiveArgs) />
	
	<!--- make the HTML if requested --->
	<cfif arguments.returnFormat eq "HTML">
		<cfset result = makeGoogleResultHTML(
			searchResults = result,
			input = input) />
	</cfif>
	
	<!--- add the search result to the page events persistance collection --->	
	<cfset pageEvent.setValue("searchResults", result) />
	
</cffunction>



<!--- getSearchForm --->
<cffunction name="getSearchForm" returntype="string" access="public" output="false"
	displayname="Get Search Form" hint="I retrun a string that is an HTML form."
	Description="I retrun a string that is an HTML form.">
	
	<cfargument name="breakButton" type="boolean"  default="#variables.breakButton#" 
		hint="Should the submit button be on a seperate line than the text input?<br />I default to false." />
	<cfargument name="buttonValue" type="string" default="#variables.buttonValue#"
		hint="I am the value to appear in the submit button.<br />I default to 'Search.'" />
	<cfargument name="formClass" type="string" default="#variables.formClass#" 
		hint="I am the name of the form.<br />I default to 'GoogleSearchFrom'." />
	<cfargument name="formID" type="string" default="#variables.formID#" 
		hint="I am the ID of the form.<br />I default to'GoogleSearchFormID'." />
	<cfargument name="formName" type="string" default="#variables.formName#" 
		hint="I am the name of the form.<br />I default to 'GoogleSearchFrom'." />
	<cfargument name="formAction" type="string" default="#variables.searchFromAction#" 
		hint="I am the url to post to.<br />I default to a configured variable. " />
	<cfargument name="formMethod" type="string" default="#variables.formMethod#" 
		hint="I am the method the form uses to submit itself.<br />I default to a 'post'." />
	<cfargument name="formContent" type="string" default="" 
		hint="I am the content of the text input.<br />I default to an empty string." />
	<cfargument name="formInputSize" type="numeric" default="25" 
		hint="I am the size of the text input field.<br />I default to '25'." />
	<cfargument name="formInputMaxLength" type="numeric" default="255" 
		hint="I am the maximum length for the text input field.<br />I default to '255'." />
    <cfargument name="formInputClass" type="string" default="GoogleSearchInputClassName" 
		hint="I am the maximum length for the text input field.<br />I default to '255'." />
    <cfargument name="formInputButtonClass" type="string" default="GoogleSearchInputButtonClassName" 
		hint="I am the maximum length for the text input field.<br />I default to '255'." />
    <cfargument name="formInputButtonID" type="string" default="GoogleSearchInputButtonID" 
		hint="I am the maximum length for the text input field.<br />I default to 'GoogleSearchInputButtonID'." />
	<cfargument name="hiddenFieldsOnly" type="boolean" default="false" 
		hint="Only return the hidden fields with the correct values?<br />I default to 'false'." />
		
	<cfset var theForm = "" />
	
	<cfsavecontent variable="theForm"><cfoutput>
		<cfparam name="url.q" default="" />
		<cfparam name="url.num" default="#getNum()#" />
		<cfparam name="url.sortType" default="#getSortType()#" />
		<cfparam name="url.scopeType" default="0" >
		<cfparam name="url.datefrom" default="" />
		<cfparam name="url.dateto" default="" />
		<cfparam name="url.BTNG" default="#getBTNG()#" />
		<cfif arguments.hiddenFieldsOnly eq false>
			<form 
				method="#arguments.formMethod#" 
				action="#arguments.formAction#" 
				name="#arguments.formName#" 
				id="#arguments.formID#" 
				class="#arguments.formClass#">
			<input 
				type="text" 
				name="q" 
				size="#arguments.formInputSize#" 
				maxlength="#arguments.formInputMaxLength#" 
				value="#url.q#"
                class="#arguments.formInputClass#" />
				<!--- <br /> the button if requested --->
				<cfif arguments.breakButton eq true>
					<br />
				</cfif>
			<input type="submit" name="btng" value="#trim(arguments.ButtonValue)#" class="#arguments.formInputButtonClass#" id="#arguments.formInputButtonID#" /></cfif>
			<input type="hidden" name="num" value="#trim(url.num)#" />
			<input type="hidden" name="sortType" value="#trim(url.sortType)#" />
			<input type="hidden" name="scopeType" value="#trim(url.scopeType)#" />
			<input type="hidden" name="datefrom" value="#trim(url.datefrom)#" />
			<input type="hidden" name="dateto" value="#trim(url.dateto)#" />
			<cfif arguments.hiddenFieldsOnly eq false></form>
		</cfif></cfoutput></cfsavecontent>
	
	<cfreturn compressHTML(theForm) />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="any" access="public" output="false"
	displayname="Get Instance" hint="I retrun my internal instace scope."
	description="I retrun my internal instace scope.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- makeGoogleResultHTML --->
<cffunction name="makeGoogleResultHTML" returntype="string" access="private" output="false"
	displayname="Make Google Results HTML" hint="I return the Google search return XML as display ready HTML."
	description="I return the Google search return XML as display ready HTML.">
	
	<cfargument name="searchResults" type="any" required="true" 
		hint="I am the google search result XM. I am required." />
	<cfargument name="input" type="any" required="true" 
		hint="I am the google search result XM. I am required." />
	<cfargument name="showRelevanceLinks" type="boolean" default="#variables.config.getGoogleDisplaySortOptions()#" 
		hint="Show the sort by relevance links?<br />I default a configured value." />
	
	<cfset var html = "" />
	<cfset var NumberOfSearchResults = 0 />
	<cfset var nArrayLen = 0 />
	<cfset var stDocType = "" />
	<cfset var i = 0 />

	<!--- save the results page as a string to return --->
	<cfsavecontent variable="html"><cfoutput>
		<cfif isdefined("arguments.searchResults.gsp.res")>
			<!--- Display search results if any --->
			<cfif isdefined("arguments.searchResults.gsp.res.r")>
				
				<cfsilent><!--- set this into the input struct, the render link functions use it --->
					<cfif structKeyExists(arguments.searchResults.gsp.res, "m")>
						<cfset arguments.input.NumberOfSearchResults = arguments.searchResults.gsp.res.m.xmltext />
					<cfelse>
						<cfset arguments.input.NumberOfSearchResults = 0 />
					</cfif>
				</cfsilent>
<!--- Parent wrapper for search information and records --->
<div id="serch-results-wrapper">
	<!--- Search Result information --->
	<div class="search-result-information-wrapper">
		Results 
		#arguments.searchResults.gsp.res.xmlAttributes.sn# - 
		#arguments.searchResults.gsp.res.xmlAttributes.en# 
		of about 
		#arguments.searchResults.gsp.res.m.xmltext# 
		for search term 
		[#HTMLEditFormat(input.q)#] 
		[in #mid(arguments.searchResults.gsp.tm.xmltext*10,1,4)# secs] 
		<br />
		<br />
		<cfset NumberOfSearchResults = #arguments.searchResults.gsp.res.m.xmltext# />
	</div>

	<!--- pagination --->
	<div class="search-result-pagination-link-wrapper">
		<div class="search-result-pagination-base-links">#getPaginationLinks(argumentCollection = arguments)#</div>
		<cfif variables.config.getGoogleDisplayNumbers() eq true><div class="search-result-pagination-numbers">#getNumberLinks(input = input)#</div></cfif>
	</div>
	<hr />
	<!--- Search Results Records --->
	<div class="search-result-record-wrapper">	
     		<cfset nArrayLen = arraylen(arguments.searchResults.gsp.res.r) />
		<cfloop from="1" to="#nArrayLen#" index="i">
			<div class="search-result-record">
				<!--- get the document type from the result --->
				<cfset stDocType = getDocType(arguments.searchResults.gsp.res.r[i].Xmlattributes) />
				<!--- display the result if there is a link, see Search Protocal Refrence -> XML Output --->
				<cfif structkeyexists(arguments.searchResults.gsp.res.r[i].XmlAttributes,"L")>
					
					<a href="#arguments.searchResults.gsp.res.r[i].u.xmltext#" class="subtitle">
						<!--- the title of the results --->
						<cfif structkeyexists(arguments.searchResults.gsp.res.r[i],"t")>
							#arguments.searchResults.gsp.res.r[i].t.xmltext#
						<cfelse>
							Default Page
						</cfif>
					</a>
					<br />
					<span>#getCleanSnippet(arguments.searchResults.gsp.res.r[i].s.xmltext,url.q)#</span>
					<strong>#stDocType#</strong>
					<br />
					<span style="color:green;">
						<!--- something to do with a cached result --->
						<cfif 
							structkeyexists(arguments.searchResults.gsp.res.r[i].has, "C")  
							and 
							arguments.searchResults.gsp.res.r[i].has.c.xmlattributes.sz is not ""> 
								#arguments.searchResults.gsp.res.r[i].has.c.xmlattributes.sz# &ndash; 
						</cfif>
						<!--- additional details about the result --->
						<cfif 
							structkeyexists(arguments.searchResults.gsp.res.r[i], "fs") 
							and 
							arguments.searchResults.gsp.res.r[i].fs.xmlattributes.value is not ""> 
								#arguments.searchResults.gsp.res.r[i].fs.xmlattributes.value#
						</cfif>
					</span>
					<br />
					<br />
				<cfelse>
					<a href="#arguments.searchResults.gsp.res.r[i].u.xmltext#" class="subtitle">
						<cfif structkeyexists(arguments.searchResults.gsp.res.r[i],"t")>
							#arguments.searchResults.gsp.res.r[i].t.xmltext#
						<cfelse>
							Default Page
						</cfif>
					</a>
					<br />
					<span>#getCleanSnippet(arguments.searchResults.gsp.res.r[i].s.xmltext,url.q)#</span>
					<strong>#stDocType#</strong>
					<br />
					<span style="color:green;">
						<cfif 
							structkeyexists(arguments.searchResults.gsp.res.r[i].has, "C") 
							and 
							arguments.searchResults.gsp.res.r[i].has.c.xmlattributes.sz is not ""> 
							#arguments.searchResults.gsp.res.r[i].has.c.xmlattributes.sz# - 
						</cfif>
						<cfif 
							structkeyexists(arguments.searchResults.gsp.res.r[i], "fs")
							and
							arguments.searchResults.gsp.res.r[i].fs.xmlattributes.value is not ""> 
							#arguments.searchResults.gsp.res.r[i].fs.xmlattributes.value#
						</cfif>
					</span>
					<br />
					<br />
				</cfif>
			</div>
		</cfloop>
	</div>
	<!--- pagination --->
	<div class="search-result-pagination-link-wrapper">				
		#getPaginationLinks(argumentCollection = arguments)#
		<cfif variables.config.getGoogleDisplayNumbers() eq true><div class="search-result-pagination-numbers">#getNumberLinks(input = input)#</div></cfif>
	</div>
</div>
			</cfif>
		<cfelse>
			<div class="search-result-pagination-link-wrapper">
				<p>Your search returned no results.</p>
			</div>
		</cfif></cfoutput></cfsavecontent>
	
	<!--- replace this string, it gets messed up with out partial or required strings --->	
	<cfset html = replaceNoCase(html, "dateto= ", "dateto=", "all") />

	<cfreturn compressHTML(html) />
</cffunction>



<!--- getNumberLinks --->
<cffunction name="getNumberLinks" returntype="string" access="private" output="false"
    displayname="Get Number Link" hint="I return an HTML string of number links."
    description="I return an HTML string of number links for the UI.">
	
	<cfargument name="input" type="struct" required="true" 
		hint="I am the input data.<br />I am required">
	
	<cfset var final = "" />
	<cfset var start = 0 />
	<cfset var x = 0 />
	<cfset var links = "" />
	<cfset var loopEnd = 0 />
	<cfset var recordcount = 0 />
	<cfset var count = 1 />

	<cfif structKeyExists(arguments.input, "start")>
		<cfset start = arguments.input.start />
	</cfif>
	<cfset loopEnd = start + getNum() />
	<cfset recordcount = arguments.input.NumberOfSearchResults />
	
	<!--- handle the end --->
	<cfif loopEnd gt recordcount>
		<cfset loopEnd = start>
	</cfif>

	<!--- loop and create each 1 - 10 links --->	
	<cfloop from="#start#" to="#loopEnd#" index="x"><cfsavecontent variable="links"><cfoutput>
		<cfif count eq 1 and start gte 20>
			<span class="GoogleStartNumbers">
				#getLink(
					start = 0,
					sortType = arguments.input.sortType,
					displayText = 1,
					input = arguments.input
				)#...
			</span>
			<cfif count gte 1 and x gte 30>
				<span class="GoogleStartNumbers">
					#getLink(
						start = 10,
						sortType = arguments.input.sortType,
						displayText = 2,
						input = arguments.input
					)#...
				</span>
			</cfif>
		<cfelse>
			<cfif start neq 0><!--- dont display the 0 index --->
				<span class="GoogleNumbers">
					#getLink(
						start = start,
						sortType = arguments.input.sortType,
						displayText = start / 10,
						input = arguments.input
					)#
				</span>
				<!--- 
				<cfif start lt loopEnd + 100 - 10>
					&nbsp;|&nbsp;
				</cfif>
				 --->
			</cfif>
		</cfif></cfoutput></cfsavecontent>
		
		<!--- increase the start postion and count --->
		<cfset start = start + 10 />
		<cfset count = count + 1 />
		
		<!--- keep appending the above content to the result string --->
		<cfset final = final & links />
	</cfloop>

	<cfset request.send.LoopEnd = loopEnd />

    <cfreturn  final />
</cffunction>



<!--- getPaginationLinks --->
<cffunction name="getPaginationLinks" returntype="string" access="private" output="false"
	displayName="Get Pagination Links" hint="I retrun a string with the pagination links all ready to render."
	Description="I retrun a string with the pagination links all ready to render.">
	
	<cfargument name="searchResults" type="any" required="true" 
		hint="I am the google search result XM. I am required." />
	<cfargument name="input" type="struct" required="true" 
		hint="I run URLDecode on all values in a structure." />
	<cfargument name="showRelevanceLinks" type="boolean" required="true" 
		hint="Show the sort by relevance links?<br />I am required." />
	
	<cfset var _start = getNum() />
	<cfset var _previous = 0 />
	<cfset var NumberOfSearchResults = arguments.searchResults.gsp.res.m.xmltext />
	<cfset var NumberOfDisplayedResults = getNum() />
	<cfset var paginationLinks = "" />
	
	<!--- logic for start and previous --->
	<cfif structKeyExists(arguments.input, "start")>
		<cfset _start = arguments.input.start + getNum()>
		<cfif  _start gte getNum()>
			<cfset _previous = arguments.input.start - getNum()>
		</cfif>
	</cfif>

	<!--- make the HTML String --->
	<cfsavecontent variable="paginationLinks">
		<cfoutput>
			<!--- Previous Link --->
			<cfif isdefined("arguments.input.start") and arguments.input.start gte getNum()>
				#getLink(
					start = _previous,
					sortType = arguments.input.sortType,
					displayText = variables.PREVIOUS_LINK_TEXT,
					input = arguments.input
				)##variables.GOOGLE_LINK_SEPERATOR#
			</cfif>
			<!--- Next Link --->
			<cfif NumberOfSearchResults GT getNum()>
				#getLink(
					start = _start,
					sortType = arguments.input.sortType,
					displayText =  variables.NEXT_LINK_TEXT,
					input = arguments.input
				)#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</cfif>
			<!--- show the relevance / date if configured --->
			<cfif arguments.showRelevanceLinks eq true>
				#getLink(
					start = 0,
					sortType = variables.GOOGLE_SORT_RELEVANCE_URL_INDICATOR,
					displayText = variables.SORT_BY_RELIVANCE_TEXT,
					input = arguments.input
				)#
				#variables.GOOGLE_LINK_SEPERATOR#
				#getLink(
					start = 0,
					sortType = variables.GOOGLE_SORT_DATE_URL_INDICATOR,
					displayText = variables.SORT_BY_DATE_TEXT,
					input = arguments.input
				)#
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfreturn paginationLinks />
</cffunction>



<!--- getLink --->
<cffunction name="getLink" returntype="string" access="private" output="false"
    displayname="Get Link" hint="I retrun a string that is a link."
    description="I return a string used for the pagination links.">
    
	<cfargument name="start" type="numeric" required="true" 
		hint="I am the start postion.<br />I a requried." />
	<cfargument name="sortType" type="string" required="true" 
		hint="I am the sortType.<br />I a requried." />
	<cfargument name="displayText" type="string" required="true" 
		hint="I am the text to display inside the anchor tag.<br />I a requried." />
	<cfargument name="input" type="any" required="true" 
		hint="I am the input values.<br />I a requried." />
	
	<cfset var link = "" />
	
	<cfsavecontent variable="link"><cfoutput>
	<a href="#cgi.script_name#?
		q=#urlencodedformat(arguments.input.q)#&
		btnG=#urlencodedformat(arguments.input.btnG)#&
		start=#arguments.start#&
		scopeType=#arguments.input.scopeType#&
		sortType=#arguments.sortType#&
		num=#getNum()#&
		datefrom=#arguments.input.datefrom#&
		dateto=#arguments.input.dateto#
		<cfif isDefined("arguments.input.partialfields")>&partialfields=#urlEncodedFormat(arguments.input.partialfields)#</cfif>
		<cfif isDefined("arguments.input.requiredfields")>&requiredfields=#URLEncodedFormat(arguments.input.requiredfields)#</cfif>">
			#arguments.displayText#
	</a></cfoutput></cfsavecontent>

    <cfreturn link />
</cffunction>



<!--- decodeInput --->
<cffunction name="decodeInput" returntype="struct" access="private" output="false"
	displayName="Decode Input" hint="I encode google formatted required and partial field URL paramaters."
	Description="I encode google formatted required and partial field URL paramaters.">
	
	<cfargument name="input" type="struct" required="true" 
		hint="I run URLDecode on all values in a structure." />
	
	<cfset var i = 0 />

	<cfloop collection="#arguments.input#" item="i">
		<cfset arguments.input[i] = URLDecode(arguments.input[i]) />
	</cfloop>

	<cfreturn arguments.input />
</cffunction>



<!--- parsePartialAndRequiredFields --->
<cffunction name="parsePartialAndRequiredFields" returntype="struct" access="private" output="false"
	displayName="Parse Partial and Required Fields" hint="I encode google formatted required and partial field URL paramaters."
	Description="I encode google formatted required and partial field URL paramaters.">
	
	<cfargument name="input" type="struct" required="true" 
		hint="I am the string to double URL encode.<br />I am required." />
	
	<cfset var newPartialFields = "" />
	<cfset var newRequiredFields = "" />
	<cfset var x = 0 />
	<cfset var key = "" />
	<cfset var value = "" />
	<cfset var keyValueString = "" />
	
	<!--- Handle partial and required google fields from a form submission --->
	<cfloop collection="#arguments.input#" item="x">

		<cfif x contains "partialfields_">	
			<cfset key = lcase(replaceNoCase(x, "partialfields_", "", "all")) />
			<cfset value = trim(input[x]) />
			<cfset keyValueString = key & ":" & value />
			<cfset newPartialFields = listAppend(newPartialFields, "#keyValueString#", "|") />
		</cfif>
		
		<cfif x contains "requiredfields_">	
			<cfset key = lcase(replaceNoCase(x, "requiredfields_", "", "all")) />
			<cfset value = trim(input[x]) />
			<cfset keyValueString = key & ":" & value />
			<cfset newRequiredFields = listAppend(newRequiredFields, "#keyValueString#", "|") />
		</cfif>
	</cfloop>

	<!--- overwrite the inputs values if needed --->
	<cfif len(newPartialFields)>
		<cfset arguments.input.partialfields = newPartialFields />
	</cfif>
	<cfif len(newRequiredFields)>
		<cfset arguments.input.requiredfields = newRequiredFields />
	</cfif>
	
	<cfreturn arguments.input />
</cffunction>



<!--- sendSearchDirective --->
<cffunction name="sendSearchDirective" returntype="any" access="public" output="false"
	displayname="Send Search Directive" hint="I send a search directive to a Google appliance an retrun the XML."
	description="I send a search directive to a Google appliance an retrun the XML or formatted HTML.">

	<cfargument name="searchserver" type="string" default="#getSearchServer()#" 
		hint="I am the URL of the Google Applicance" />
	<cfargument name="access" type="string" default="#getAccess()#" 
		hint="I am the access paramater that determins whether or not to search public or pirvate collections.<br />I default to a configured value." />
	<cfargument name="btnG" type="any" default="#getBtnG()#" 
		hint="I am the value for the Google search submission button.<br />I default to a configured value." />
	<cfargument name="client" type="string" default="#getClient()#" 
		hint="I am the 'type' of client the results are set for.<br />I default to a configured value."  />
	<cfargument name="filter" type="numeric" default="#getFilter()#" 
		hint="I am the filter flag, see Google documentation for explaination.<br />I default to a configured value.">
	<cfargument name="getfields" type="any" default="#getGetFields()#" 
		hint="I am a list of meta fields to be returned by search results.<br />I default to a configured value." />
	<cfargument name="ie" type="string" default="#getIe()#" 
		hint="I am the input encoding type value.<br />I default to a configured value." />
	<cfargument name="num" type="numeric" default="#getNum()#"
		hint="I am the number of search results to display.<br />I default to a configured value." />
	<cfargument name="oe" type="string" default="#getOe()#" 
		hint="I am the output encoding value.<br />I default to a configured value." />
	<cfargument name="output" type="string" default="#getOutput()#" 
		hint="I am the type of output for search results.<br />I default to a configured value." />
	<cfargument name="proxyreload" type="numeric" default="#getProxyreload()#" 
		hint="I am a flag that indicates to load the proxy XSL for every request.<br />I default to a configured value." />
	<cfargument name="partialfields" type="string" default="" 
		hint="I am the double encoded partialfields filter paramater list.<br />I default to an empty string." />
	<cfargument name="requiredfields" type="string" default="" 
		hint="I am the double encoded requiredfields filter paramater list.<br />I default to an empty string." />
	<cfargument name="site" type="string" default="#getSite()#" 
		hint="I am the site/collection to search against.<br />I default to a configured value." />
	<cfargument name="sortType" type="string" default="#getSortType()#" 
		hint="I am the sort type.<br />I default to a configured value."/>
	<cfargument name="start" type="numeric" default="0" 
		hint="I am the index of the start postion of a search result.<br />I default to '0'." />
	
	<cfset var result = 0 />

	<!--- a real search --->
	<cfif variables.config.getSearchMode() neq "development">
	
		<!--- send the search directive to GSA --->
		<cfhttp method="get" url="#arguments.searchServer#">
			<cfhttpparam type="url" name="access" value="#arguments.access#" />
			<cfhttpparam type="url" name="btnG" value="#arguments.btnG#" encoded="yes" />
			<cfhttpparam type="url" name="client" value="#arguments.client#" />
			<cfhttpparam type="url" name="filter" value="#arguments.filter#" />
			<cfhttpparam type="url" name="getfields" value="#arguments.getFields#" />
			<cfhttpparam type="url" name="ie" value="#arguments.ie#" />
			<cfhttpparam type="url" name="num" value="#arguments.num#" />
			<cfhttpparam type="url" name="oe"  value="#arguments.oe#" />
			<cfhttpparam type="url" name="output" value="#arguments.output#" />
			<cfhttpparam type="url" name="proxyreload" value="#arguments.proxyreload#" />
			<cfhttpparam type="url" name="q" value="#arguments.q#" encoded="yes" />
			<cfhttpparam type="url" name="site" value="#arguments.site#" />
			<cfhttpparam type="url" name="sort" value="date:D:#arguments.sortType#:d1" />
			
			<cfif arguments.Start neq 0>
				<cfhttpparam type="url" name="start" value="#arguments.start#" />
			</cfif>
			
			<!--- dobule encode and set if present --->
			<cfif len(arguments.partialfields)>
				<cfset arguments.partialFields = URLEncodePartialAndRequiredFields(fieldString = arguments.partialFields) />
				<cfhttpparam type="url" name="partialfields" value="#arguments.partialfields#" />
			</cfif>
			
			<!--- dobule encode and set if present --->
			<cfif len(arguments.requiredfields)>
				<cfset arguments.requiredFields = URLEncodePartialAndRequiredFields(fieldString = arguments.requiredFields) />
				<cfhttpparam type="url" name="requiredfields" value="#arguments.requiredfields#" />
			</cfif>
		</cfhttp>
		
		<cfset result = xmlparse(cfhttp.FileContent) />
	<cfelse><!--- development mode, retrun some XML from the disk --->

		<cfset result = variables.fileSystem.read(
			Destination = variables.config.getFigLeafFilePath() & "/com/applications/google/",
			FileName = "mockgooglesearchresultXML.xml") />
	
		<cfset result = xmlparse(result)>
	</cfif>
	
	<cfset request.send = arguments />
	<cfset request.send.result = result />
	
	<cfreturn result />
</cffunction>



<!--- URLEncodePartialAndRequiredFields --->
<cffunction name="URLEncodePartialAndRequiredFields" returntype="string" access="private" output="false"
	displayName="URL Encoded Parital and Required Fields" hint="I encode google formatted required and partial field URL paramaters."
	Description="I encode google formatted required and partial field URL paramaters.">
	
	<cfargument name="fieldString" type="string" required="true" 
		hint="I am the string to double URL encode.<br />I am required." />
	<cfargument name="doubleEncodeKey" type="boolean" default="1" 
		hint="Should I double encode the Key?<br />I defalut to true." />
	<cfargument name="doubleEncodeValue" type="boolean" default="1" 
		hint="Should I double encode the Value?<br />I defalut to true." />
	
	<cfset var x = "" />
	<cfset var keyValuePair = "" />
	<cfset var key = "" />
	<cfset var value = "" />
	<cfset var doubleEncodedValue = "" />
	<cfset var newKeyValuePair = "" />
	<cfset var newKeyValuePairList = "" />
	
	<!--- TODO: delete this after a release, only here for an easy override --->
	<cfif isDefined("url.jfa") or isDefined("url.de")>
		<cfset arguments.doubleEncodeKey = 0 />
	</cfif>
	
	<!--- loop and break each key value pair out --->
	<cfloop list="#arguments.fieldString#" index="x" delimiters="|">
		
		<cfset keyValuePair = x />
		
		<cfif listLen(keyValuePair, ":") gt 1>
			<cfset key = listGetAt(keyValuePair,1, ":") />
			<cfset value = listGetAt(KeyValuePair, 2, ":") />
			
			<!--- should we double encode? --->
			<cfif arguments.doubleEncodeKey eq 1>
				<cfset key = URLEncodedFormat(key) />
			</cfif>
			<cfif arguments.doubleEncodeValue eq 1>
				<cfset value = URLEncodedFormat(value) />
			</cfif>

			<!---  
			Note: added this check again for testing.
			TODO: delete this if else logic after we have totally debugged getting results.
			--->
			<cfif arguments.doubleEncodeKey eq 1>
				<!--- concatinate the new version --->
				<cfset newKeyValuePair = URLEncodedFormat(key) & ":" & URLEncodedFormat(value) />
			<cfelse>

				<!--- concatinate the new version --->
				<cfset newKeyValuePair = key & ":" & URLEncodedFormat(value) />
			</cfif>
	
			<!--- add them to a list --->
			<cfset newKeyValuePairList = listAppend(newKeyValuePairList, "#newKeyValuePair#", "|") />
		</cfif>
	</cfloop>

	<cftrace inline="true" var="newKeyValuePairList">
	<cfreturn newKeyValuePairList />
</cffunction>



<!--- getDocType --->
<cffunction name="getDocType" output="false" returntype="string">
	<cfargument type="struct" required="yes" name="stRes">
 
    <cfset var stDocType = "">
 
	<cfif structKeyExists(stRes, "MIME")>
		<cfswitch expression="#stRes.MIME#">
			<cfcase value="text/plain">
				<cfset stDocType = "[TEXT]" />
			</cfcase>
			<cfcase value="application/rtf">
				<cfset stDocType = "[RTF]" />
			</cfcase>
			<cfcase value="application/pdf">
				<cfset stDocType = "[PDF]" />
			</cfcase>
			<cfcase value="application/postscript">
				<cfset stDocType = "[PS]" />
			</cfcase>
			<cfcase value="application/vnd.ms-powerpoint'">
				<cfset stDocType = "[MS POWERPOINT]" />
			</cfcase>
			<cfcase value="application/vnd.ms-excel">
				<cfset stDocType = "[MS EXCEL]" />
			</cfcase>
			<cfcase value="application/msword">
				<cfset stDocType = "[MS WORD]" />
			</cfcase>
			<cfdefaultcase>
				<cfset stDocType = "" />
			</cfdefaultcase>
		</cfswitch>
	</cfif>
    
	<cfreturn stDocType />
</cffunction>



<!--- getCleanSnippet --->
<cffunction name="getCleanSnippet" output="false" returntype="string" 
	hint="I strip out some HTML tags for display.">
	
	<cfargument type="string" required="yes" name="sSnippet" />
	<cfargument type="string" required="yes" name="sQueryString"/>
    
	<cfset var sCleanSnippet = replacenocase(arguments.sSnippet, arguments.sQueryString,"<strong>" & arguments.sQueryString & "</strong>") />
	<cfset sCleanSnippet = replacenocase(sCleanSnippet,"<br>","","all") />
	
	<cfreturn sCleanSnippet />
</cffunction>



<!--- compressHTML --->
<cffunction name="compressHTML" returntype="string" output="false" access="private" 
	hint="Compresses any HTML given.">
	
	<cfargument name="HTML" type="string" required="true" 
		hint="I am the HTML string to compress.<br />I am required." />

	<cfreturn reReplace( arguments.HTML, "[[:space:]]{2,}", chr( 13 ), "all" ) />
</cffunction>



<!--- Access --->
<cffunction name="setAccess" output="false" access="private"
	hint="I set the Access property.">
	<cfargument name="Access" type="string" />
	<cfset variables.instance.Access = arguments.Access />
</cffunction>
<cffunction name="getAccess" output="false" access="public"
	hint="I return the Access property.">
	<cfreturn variables.instance.Access />
</cffunction>
<!--- BtnG --->
<cffunction name="setBtnG" output="false" access="private"
	hint="I set the BtnG property.">
	<cfargument name="BtnG" type="string" />
	<cfset variables.instance.BtnG = arguments.BtnG />
</cffunction>
<cffunction name="getBtnG" output="false" access="public"
	hint="I return the BtnG property.">
	<cfreturn variables.instance.BtnG />
</cffunction>
<!--- Client --->
<cffunction name="setClient" output="false" access="private"
	hint="I set the Client property.">
	<cfargument name="Client" type="string" />
	<cfset variables.instance.Client = arguments.Client />
</cffunction>
<cffunction name="getClient" output="false" access="public"
	hint="I return the Client property.">
	<cfreturn variables.instance.Client />
</cffunction>
<!--- GetFields --->
<cffunction name="setGetFields" output="false" access="private"
	hint="I set the GetFields property.">
	<cfargument name="GetFields" type="any" />
	<cfset variables.instance.GetFields = arguments.GetFields />
</cffunction>
<cffunction name="getGetFields" output="false" access="public"
	hint="I return the GetFields property.">
	<cfreturn variables.instance.GetFields />
</cffunction>
<!--- Filter --->
<cffunction name="setFilter" output="false" access="private"
	hint="I set the Filter property.">
	<cfargument name="Filter" type="numeric" />
	<cfset variables.instance.Filter = arguments.Filter />
</cffunction>
<cffunction name="getFilter" output="false" access="public"
	hint="I return the Filter property.">
	<cfreturn variables.instance.Filter />
</cffunction>
<!--- Ie --->
<cffunction name="setIe" output="false" access="private"
	hint="I set the Ie property.">
	<cfargument name="Ie" type="string" />
	<cfset variables.instance.Ie = arguments.Ie />
</cffunction>
<cffunction name="getIe" output="false" access="public"
	hint="I return the Ie property.">
	<cfreturn variables.instance.Ie />
</cffunction>
<!--- Num --->
<cffunction name="setNum" output="false" access="private"
	hint="I set the Num property.">
	<cfargument name="Num" type="numeric" />
	<cfset variables.instance.Num = arguments.Num />
</cffunction>
<cffunction name="getNum" output="false" access="public"
	hint="I return the Num property.">
	<cfreturn variables.instance.Num />
</cffunction>
<!--- Oe --->
<cffunction name="setOe" output="false" access="private"
	hint="I set the Oe property.">
	<cfargument name="Oe" type="string" />
	<cfset variables.instance.Oe = arguments.Oe />
</cffunction>
<cffunction name="getOe" output="false" access="public"
	hint="I return the Oe property.">
	<cfreturn variables.instance.Oe />
</cffunction>
<!--- Output --->
<cffunction name="setOutput" output="false" access="private"
	hint="I set the Output property.">
	<cfargument name="Output" type="string" />
	<cfset variables.instance.Output = arguments.Output />
</cffunction>
<cffunction name="getOutput" output="false" access="public"
	hint="I return the Output property.">
	<cfreturn variables.instance.Output />
</cffunction>
<!--- Proxyreload --->
<cffunction name="setProxyreload" access="private" output="false" 
	hint="I set the Proxyreload property.">
	<cfargument name="Proxyreload" hint="I am the Proxyreload." />
	<cfset variables.instance.Proxyreload = arguments.Proxyreload />
</cffunction>
<cffunction name="getProxyreload" access="public" output="false" 
	hint="I return the Proxyreload property.">
	<cfreturn variables.instance.Proxyreload  />
</cffunction>
<!--- SearchServer --->
<cffunction name="setSearchServer" output="false" access="private"
	hint="I set the SearchServer property.">
	<cfargument name="SearchServer" type="string" />
	<cfset variables.instance.SearchServer = arguments.SearchServer />
</cffunction>
<cffunction name="getSearchServer" output="false" access="public"
	hint="I return the SearchServer property.">
	<cfreturn variables.instance.SearchServer />
</cffunction>
<!--- Site --->
<cffunction name="setSite" output="false" access="private"
	hint="I set the Site property.">
	<cfargument name="Site" type="any" />
	<cfset variables.instance.Site = arguments.Site />
</cffunction>
<cffunction name="getSite" output="false" access="public"
	hint="I return the Site property.">
	<cfreturn variables.instance.Site />
</cffunction>
<!--- SortType --->
<cffunction name="setSortType" output="false" access="private"
	hint="I set the SortType property.">
	<cfargument name="SortType" type="any" />
	<cfset variables.instance.SortType = arguments.SortType />
</cffunction>
<cffunction name="getSortType" output="false" access="public"
	hint="I return the SortType property.">
	<cfreturn variables.instance.SortType />
</cffunction>
</cfcomponent>