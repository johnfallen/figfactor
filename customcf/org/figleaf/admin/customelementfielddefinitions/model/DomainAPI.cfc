<!--- Document Information -----------------------------------------------------
Build:      		@@@revision-number@@@
Title:      		DomainAPI.cfc
Author:     		John Allen
Email:      		jallen@figleaf.com
Company:    	@@@company-name@@@
Website:    	@@@web-site@@@

Purpose:    	I am the Domain API, the interface for the applicaiton

Usage:      		

Modification Log:
Name 			Date 					Description

================================================================================
John Allen 		07/10/2008			Created

------------------------------------------------------------------------------->
<cfcomponent displayname="Domain API" output="false"
	hint="I am the Domain API, the interface for the applicaiton">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="DomainAPI" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfreturn this />
</cffunction>



<!--- getCustomElementXML --->
<cffunction name="getCustomElementXML" output="false"
	hint="I read the customelementdefinitions.xml file, parst it and return it.">
	
	<cfset var xml = 0 />
	<cfset var elements = 0 />
	<cfset var _file = getDirectoryFromPath(getCurrentTemplatePath()) & "xmlstorage/customelementdefinitions.xml" />
	<cfset var formData = structNew() />
	<cfset var x = 0 />
	<cfset var y = 0 />
	
	<cffile action="read" file="#_file#" variable="xml" />
	<cfset elements = xmlParse(xml) />
	
	<cfloop collection="#elements.customelementdefinitions#" item="x">
		
	<!--- 	<cfdump var="#elements.customelementdefinitions[x]#" expand="false" />
		<cfdump var="#elements.customelementdefinitions[x].XMLChildren#" expand="false" /> --->
		
		<cfset formData[elements.customelementdefinitions[x].XmlAttributes.name] = 
			elements.customelementdefinitions[x].XmlAttributes.name />
		
		<cfloop from="1" to="#arrayLen(elements.customelementdefinitions[x].XMLChildren)#" index="y">
			
			<cfset tab.name = elements.customelementdefinitions[x].XMLChildren[y].XMLAttributes.name />
			
			<!--- <cfdump var="#elements.customelementdefinitions[x].XMLChildren[y].XMLChildren[1].XMLAttributes#"> --->
			<cfset tab.properties = arrayNew(1) />
			<cfset arrayAppend(tab.properties, elements.customelementdefinitions[x].XMLChildren[y].XMLChildren[1].XMLAttributes) />
			<!--- <cfset formData[elements.customelementdefinitions[x].XmlAttributes.name & "_data"] = structNew() /> --->
			
			<cfdump var="#tab#">
		</cfloop>
		<!--- <cfset formData[elements.customelementdefinitions[x].XmlAttributes.name & "_data"] = 
			elements.customelementdefinitions[x].XMLChildren /> --->
	
	</cfloop>
	
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>