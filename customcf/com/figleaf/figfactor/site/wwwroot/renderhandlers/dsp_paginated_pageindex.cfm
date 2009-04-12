<cfset event = application.vf.getPageEvent() />
<!--- get the pageindex element data --->
<cfset list = application.ViewFramework.getElementData(attributes.ELEMENTINFO, "pageindex")>
<!--- create the paginatino object --->
<cfset pagination = createobject("component", "includes.Pagination").init() />

<cfset pagination.setArrayToPaginate(list) />

<cfdump var="#pagination.getRenderedHTML()#">
