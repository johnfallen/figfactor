<cfset os = createObject("component", "ObjectStore").init() />
<cfset db = os.getDB() />
<cfset obj = os.getBean("publicationfeed")>

<cfset os.save(obj)>
<cfdump var="#db#">
