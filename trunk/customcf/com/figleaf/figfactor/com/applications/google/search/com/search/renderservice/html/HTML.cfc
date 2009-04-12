<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			HTMLTransfrom.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I manage the transforming of XML to display HTML
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		12/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="HTML Transform" output="false"
	hint="I manage the transforming of XML to display HTML">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="HTML" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="configData" type="struct" required="true" 
		hint="I am the configuration structure. I am requried." />
	
	<cfset setInstanceVariables(arguments.configData) />

	<cfreturn this />
</cffunction>



<!--- render --->
<cffunction name="render" returntype="component" access="public" output="false"
    displayname="Render" hint="I render the Google XML as HTML."
    description="I render the Google XML as HTML.">
    
	<cfargument name="searchEvent" type="component" required="true" 
		hint="I am the Search Event object. I am required" />
	
	<!--- code that lets the mockSearchXML pass through --->
	<cfif not structKeyExists(arguments.SearchEvent.getOrigionalInput(), "q")>
		<cfset arguments.SearchEvent.getOrigionalInput().q = "" />
	</cfif>
	<cfif not structKeyExists(arguments.SearchEvent.getOrigionalInput(), "sortType")>
		<cfset arguments.SearchEvent.getOrigionalInput().sorttype = arguments.SearchEvent.getSort() />
	</cfif>
	<cfif not structKeyExists(arguments.SearchEvent.getOrigionalInput(), "btng")>
		<cfset arguments.SearchEvent.getOrigionalInput().btng = arguments.SearchEvent.getBtng() />
	</cfif>
	<cfif not structKeyExists(arguments.SearchEvent.getOrigionalInput(), "scopeType")>
		<cfset arguments.SearchEvent.getOrigionalInput().scopeType = 0 />
	</cfif>
	<cfif not structKeyExists(arguments.SearchEvent.getOrigionalInput(), "dateFrom")>
		<cfset arguments.SearchEvent.getOrigionalInput().dateFrom = "" />
	</cfif>
	<cfif not structKeyExists(arguments.SearchEvent.getOrigionalInput(), "dateTo")>
		<cfset arguments.SearchEvent.getOrigionalInput().dateTo = "" />
	</cfif>
	
	<cfset arguments.SearchEvent.setResults(			
			makeGoogleResultHTML(
				searchResults = arguments.searchEvent.GetSearchResultXML(),
				input = arguments.SearchEvent.getOrigionalInput(),
				SearchEvent = arguments.searchEvent
			)) />

    <cfreturn arguments.searchEvent />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
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
	<cfargument name="showRelevanceLinks" type="boolean" default="#getShowRelevanceLinks()#" 
		hint="Show the sort by relevance links?<br />I default a configured value." />
	<cfargument name="SearchEvent" type="component" required="true" 
		hint="I am the Search Event object. I am required." />
	
	<cfset var html = "" />
	<cfset var NumberOfSearchResults = 0 />
	<cfset var nArrayLen = 0 />
	<cfset var stDocType = "" />
	<cfset var i = 0 />
	
	<!---  coverage for an old URL scoped variable --->
	<cfset var searchString = xmlSearch(arguments.searchResults, "//Q") />
	<cfset searchString = searchString[1].XmlText />
	
	<!--- patch to get the search event in the request context so we dont put it in the variables --->
	<cfset request.PatchForLinksSearchEvent = arguments.SearchEvent />

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
		<cfif getShowPaginationNumberLinks() eq true><div class="search-result-pagination-numbers">#getNumberLinks(input = input)#</div></cfif>
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
					
					<span>#getCleanSnippet(arguments.searchResults.gsp.res.r[i].s.xmltext,searchString)#</span>
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
					<span>#getCleanSnippet(arguments.searchResults.gsp.res.r[i].s.xmltext,input.q)#</span>
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
		
		<cfif getShowPaginationNumberLinks() eq true>
			<div class="search-result-pagination-numbers">#getNumberLinks(input = input)#</div>
		</cfif>
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
		<cfset loopEnd = start />
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
		<cfset _start = arguments.input.start + getNum() />
		<cfif  _start gte getNum()>
			<cfset _previous = arguments.input.start - getNum() />
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
					displayText = getPreviousLink(),
					input = arguments.input
				)##nbsp(3)##getGoogleLinkSeporator()##nbsp(3)#
			</cfif>
			
			<!--- Next Link --->
			<cfif NumberOfSearchResults GT getNum()>
				#getLink(
					start = _start,
					sortType = arguments.input.sortType,
					displayText =  getNextLink(),
					input = arguments.input
				)##nbsp(14)#
			</cfif>
			
			<!--- show the relevance / date if configured --->
			<cfif arguments.showRelevanceLinks eq true>
				#getLink(
					start = 0,
					sortType = getSortRelavenceURLIndicator(),
					displayText = getSortByRelavenceText(),
					input = arguments.input
				)#
				#nbsp(3)##getGoogleLinkSeporator()##nbsp(3)#
				#getLink(
					start = 0,
					sortType = getSortDateURLIndicator(),
					displayText = getSortByDateText(),
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
	<cfset var partialFields = "" />
	
	<cfif structKeyExists(request.PatchForLinksSearchEvent.getInstance(), "PARTIALFIELDS")>
		<cfset partialFields = request.PatchForLinksSearchEvent.getInstance().PARTIALFIELDS />
	</cfif>
	
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
		<cfif len(partialFields)>&partialfields=#partialFields#</cfif>
		<cfif isDefined("arguments.input.requiredfields")>&requiredfields=#URLEncodedFormat(arguments.input.requiredfields)#</cfif>">
			#arguments.displayText#
	</a></cfoutput></cfsavecontent>


    <cfreturn link />
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
    
	<cfset var sCleanSnippet  =  "" />
	
	<cfif len(arguments.sQueryString)>
		<cfset sCleanSnippet = replacenocase(arguments.sSnippet, arguments.sQueryString,"<strong>" & arguments.sQueryString & "</strong>") />
		<cfset sCleanSnippet = replacenocase(sCleanSnippet,"<br>","","all") />
		<cfreturn sCleanSnippet />
	<cfelse>
		<cfreturn arguments.sSnippet>
	</cfif>
</cffunction>



<!--- compressHTML --->
<cffunction name="compressHTML" returntype="string" output="false" access="private" 
	hint="Compresses any HTML given.">
	
	<cfargument name="HTML" type="string" required="true" 
		hint="I am the HTML string to compress.<br />I am required." />

	<cfreturn reReplace( arguments.HTML, "[[:space:]]{2,}", chr( 13 ), "all" ) />
</cffunction>


<!--- nbsp --->
<cffunction name="nbsp" returntype="string" access="private" output="false"
    displayname="&amp;nbsp" hint="I return a specifyed amount of ""nbsp"" HTML entities."
    description="I return a specifyed amount of ""nbsp"" HTML entities.">
    
	<cfargument name="amount" type="numeric" required="false" default="1" 
		hint="I am the amout of nbsp's to return. I default to 1." />
	
	<cfset var nbsps = "&nbsp;" />
	<cfset var x = 0 />
	
	<cfif arguments.amount gt 1>
		<cfloop from="1" to="#arguments.amount#" index="x">
			<cfset nbsps = nbsps & "&nbsp;" />
		</cfloop>
	</cfif>
	
    <cfreturn nbsps />
</cffunction>



<!--- breakButton --->
<cffunction name="setbreakButton" access="public" output="false" returntype="void">
	<cfargument name="breakButton" type="string" required="true"/>
	<cfset variables.instance.breakButton = arguments.breakButton />
</cffunction>
<cffunction name="getbreakButton" access="public" output="false" returntype="string">
	<cfreturn variables.instance.breakButton />
</cffunction>
<!--- NextLink --->
<cffunction name="setNextLink" access="public" output="false" returntype="void">
	<cfargument name="NextLink" type="string" required="true"/>
	<cfset variables.instance.NextLink = arguments.NextLink />
</cffunction>
<cffunction name="getNextLink" access="public" output="false" returntype="string">
	<cfreturn variables.instance.NextLink />
</cffunction>
<!--- PreviousLink --->
<cffunction name="setPreviousLink" access="public" output="false" returntype="void">
	<cfargument name="PreviousLink" type="string" required="true"/>
	<cfset variables.instance.PreviousLink = arguments.PreviousLink />
</cffunction>
<cffunction name="getPreviousLink" access="public" output="false" returntype="string">
	<cfreturn variables.instance.PreviousLink />
</cffunction>
<!--- ShowRelevanceLinks --->
<cffunction name="setShowRelevanceLinks" access="public" output="false" returntype="void">
	<cfargument name="ShowRelevanceLinks" type="boolean" required="true"/>
	<cfset variables.instance.ShowRelevanceLinks = arguments.ShowRelevanceLinks />
</cffunction>
<cffunction name="getShowRelevanceLinks" access="public" output="false" returntype="boolean">
	<cfreturn variables.instance.ShowRelevanceLinks />
</cffunction>
<!--- SortByDateText --->
<cffunction name="setSortByDateText" access="public" output="false" returntype="void">
	<cfargument name="SortByDateText" type="string" required="true"/>
	<cfset variables.instance.SortByDateText = arguments.SortByDateText />
</cffunction>
<cffunction name="getSortByDateText" access="public" output="false" returntype="string">
	<cfreturn variables.instance.SortByDateText />
</cffunction>
<!--- SortByRelavenceText --->
<cffunction name="setSortByRelavenceText" access="public" output="false" returntype="void">
	<cfargument name="SortByRelavenceText" type="string" required="true"/>
	<cfset variables.instance.SortByRelavenceText = arguments.SortByRelavenceText />
</cffunction>
<cffunction name="getSortByRelavenceText" access="public" output="false" returntype="string">
	<cfreturn variables.instance.SortByRelavenceText />
</cffunction>
<!--- GoogleLinkSeporator --->
<cffunction name="setGoogleLinkSeporator" access="public" output="false" returntype="void">
	<cfargument name="GoogleLinkSeporator" type="string" required="true"/>
	<cfset variables.instance.GoogleLinkSeporator = arguments.GoogleLinkSeporator />
</cffunction>
<cffunction name="getGoogleLinkSeporator" access="public" output="false" returntype="string">
	<cfreturn variables.instance.GoogleLinkSeporator />
</cffunction>
<!--- SortRelavenceURLIndicator --->
<cffunction name="setSortRelavenceURLIndicator" access="public" output="false" returntype="void">
	<cfargument name="SortRelavenceURLIndicator" type="string" required="true"/>
	<cfset variables.instance.SortRelavenceURLIndicator = arguments.SortRelavenceURLIndicator />
</cffunction>
<cffunction name="getSortRelavenceURLIndicator" access="public" output="false" returntype="string">
	<cfreturn variables.instance.SortRelavenceURLIndicator />
</cffunction>
<!--- SortDateURLIndicator --->
<cffunction name="setSortDateURLIndicator" access="public" output="false" returntype="void">
	<cfargument name="SortDateURLIndicator" type="string" required="true"/>
	<cfset variables.instance.SortDateURLIndicator = arguments.SortDateURLIndicator />
</cffunction>
<cffunction name="getSortDateURLIndicator" access="public" output="false" returntype="string">
	<cfreturn variables.instance.SortDateURLIndicator />
</cffunction>
<!--- ShowPaginationNumberLinks --->
<cffunction name="setShowPaginationNumberLinks" access="public" output="false" returntype="void">
	<cfargument name="ShowPaginationNumberLinks" type="boolean" required="true"/>
	<cfset variables.instance.ShowPaginationNumberLinks = arguments.ShowPaginationNumberLinks />
</cffunction>
<cffunction name="getShowPaginationNumberLinks" access="public" output="false" returntype="boolean">
	<cfreturn variables.instance.ShowPaginationNumberLinks />
</cffunction>
<!--- Num --->
<cffunction name="setNum" access="public" output="false" returntype="void">
	<cfargument name="Num" type="numeric" required="true"/>
	<cfset variables.instance.Num = arguments.Num />
</cffunction>
<cffunction name="getNum" access="public" output="false" returntype="numeric">
	<cfreturn variables.instance.Num />
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
			<!--- 
				If the arguments.data key equals the methods name minus the first
				three characters and the first three characters are 'set'. 
			--->
			<cfif 
				y eq right( x.name, ( len(x.name)-3) ) 
				and 
				left(x.name, 3) eq "set">

				<!---  
					Dynamically create a refrence to the function call and then 
					run the function. Populate it with the arguments.data's 
					current value in the outer loop, break and start all over.
				--->
				<cfset functionCall = evaluate(#x.name#) />
				<cfset functionCall(arguments.data[y]) />
				<cfbreak />
			</cfif>
		</cfloop>
	</cfloop>

</cffunction>
</cfcomponent>