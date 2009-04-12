<cfset event = application.viewFramework.getPageEvent() />
<cfset rednerHandlerDirectory = event.getRederHandlerDirectory()>
<cfset numberOfColumns = 1 />
<cfset pageTitle = "" />
<cfset isPageIndex = 0 />

<!--- set the desired column amount --->
<cfif structKeyExists(event.getValue("customelement"), "page_list_column_amount")>
	<cfset numberOfColumns =  event.getValue("customelement").page_list_column_amount />
</cfif>

<!--- set the page title --->
<cfif structKeyExists(event.getValue("customelement"), "page_list_title")>
	<cfset pageTitle = event.getValue("customelement").page_list_title />
</cfif>

<!--- only set this if its there and has a value --->
<cfif structKeyExists(event.getValue("customelement"), "page_list_is_page_index") 
	and 
	len(event.getValue("customelement").page_list_is_page_index)>
	<cfset isPageIndex = event.getValue("customelement").page_list_is_page_index>
</cfif>


<cfoutput>
<div id="render-handler-wrapper">
	<div id="center-coll-wrapper">
		</cfoutput>

		<!--- output the page title --->
		<cfif len(pageTitle)>
			<cfoutput><h1>#pageTitle#</h1></cfoutput>
		</cfif>
		
		<!--- output the page index element --->
		<cfif isPageIndex eq 1>	
			
			<cfmodule template="/commonspot/utilities/invoke-dynamic-cfml.cfm" 
				cfml="#rednerHandlerDirectory#/includes/page_index_page_list.cfm">
			
		<!--- output the query of pages that are tagged with the selected meta data --->
		<cfelse>
			
			<cfmodule template="/commonspot/utilities/invoke-dynamic-cfml.cfm" 
				cfml="#rednerHandlerDirectory#/includes/meta_data_page_list.cfm">
		</cfif>

		<cfoutput>
	</div>
	</cfoutput>
	
	<!--- display the right hand colum if desired --->
	<cfif numberOfColumns eq 2>
		<cfoutput>
			<div id="right-coll-wrapper">
				<p>rich text editor</p>
				<p>link bar</p>
			</div>
		</cfoutput>
	</cfif>
	<cfoutput>
</div>
</cfoutput>