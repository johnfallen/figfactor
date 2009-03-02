<cfset line=chr(13)&chr(10)>
<cfoutput>
<cfloop file="#path#" index="x">
#replaceNoCase(x, "CFLog4j ", "", "all")#<br />
</cfloop>
</cfoutput>