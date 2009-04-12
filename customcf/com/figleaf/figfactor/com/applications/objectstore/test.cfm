<cfset os = createObject("component", "ObjectStore").init() />
<cfset db = os.getDB() />
<cfdump var="#os#">
<cfset test = os.read("205A6F2060231763989B972C2C99F0FA") />
<cfdump var="#os.getDB()#" />
<cfdump var="#test.getInstance()#" />