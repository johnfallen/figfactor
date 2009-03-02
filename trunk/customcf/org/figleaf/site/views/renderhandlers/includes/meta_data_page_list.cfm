<cfset event = application.viewFramework.getPageEvent() />
<cfset pageList = 0 />

<cfif isStruct(event.getValue("queries")) and not StructIsEmpty(event.getValue("queries"))>
	<cfset pageList = event.getValue("queries").pageList />
</cfif>


<cfoutput>
<!--- if its a query with records... output --->
<cfif isQuery(pageList) and pageList.recordcount gt 0>
<ul>
	<cfloop query="pageList">
		<li><a href="#subsiteurl##filename#">#title#</a></li>
	</cfloop>
</ul>
</cfif>
</cfoutput>