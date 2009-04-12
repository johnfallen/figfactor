<cfcomponent displayname="xmlCFC">
	
	<!--- init --->
	<cffunction name="init" access="public" output="false" 
		displayname="Init" hint="I am the constructor." 
		description="I am the pseudo constructor for this CFC. I return an instance of myself.">
		
		<cfreturn this />
	</cffunction>
	
	<!--- These are the attribute methods. --->()
	<!--- * Returns the count of the passed in XML Element. --->
	<cffunction name="attributesCount" hint="Returns the count of the passed in XML Element." output="no">
		<cfargument name="xmlElement" required="yes">
		<cfreturn structCount( xmlElement.XmlAttributes )>
	</cffunction>
	
	<!--- * Deletes an attribute from the passed in XML Element only if it exist. --->
	<cffunction name="attributesDelete" hint="Deletes an attribute from the passed in XML Element only if it exist." output="no">
		<cfargument name="xmlElement" required="yes">
		<cfargument name="attributeNames" required="yes">
		<cfset var iAttr = 0 />

		<cfloop index="iAttr" list="#arguments.attributeNames#">
			<cfif structKeyExists(xmlElement.XmlAttributes,iAttr)>
				<cfset structDelete(xmlElement.XmlAttributes,iAttr)>
			</cfif>
		</cfloop>
	</cffunction>
	
	<!--- * Checks to see if the attributes exists in passed in XML Element. --->
	<cffunction name="attributesExist" hint="Checks to see if the attributes exists in passed in XML Element." output="no">
		<cfargument name="xmlElement" required="yes">
		<cfargument name="attributeNames" required="yes">
		
		<cfset var myResult = true />
		<cfset var  iAttr = "" />
		
		<cfloop index="iAttr" list="#arguments.attributeNames#">
			<cfif NOT structKeyExists(xmlElement.XmlAttributes,iAttr)>
				<cfset myResult = false>
			</cfif>
		</cfloop>
		<cfreturn myResult>
	</cffunction>
	
	<!--- * Adds or Edits an attribute of passed in XML Element. --->
	<cffunction name="attributeSet" hint="Adds or Edits an attribute of passed in XML Element." output="no">
		<cfargument name="xmlElement" required="yes">
		<cfargument name="attributeName" required="yes">
		<cfargument name="attributeValue" required="yes">
		<cfset arguments.xmlElement.XmlAttributes[attributeName] = attributeValue />
	</cffunction>
	
	<!--- * Returns the value of an attribute of passed in XML Element. --->
	<cffunction name="attributeGet" hint="Returns the value of an attribute of passed in XML Element." output="no">
		<cfargument name="xmlElement" required="yes">
		<cfargument name="attributeName" required="yes">
		<cfif structKeyExists(xmlElement.XmlAttributes,attributeName)>
			<cfreturn xmlElement.XmlAttributes[attributeName]>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>
	
	<!--- * Adds an attribute to the passed in XML Element only if attribute doesn't exist. --->
	<cffunction name="attributeParam" hint="Adds an attribute to the passed in XML Element only if attribute doesn't exist." output="no">
		<cfargument name="xmlElement" required="yes">
		<cfargument name="attributeName" required="yes">
		<cfargument name="attributeValue" required="yes">
		<cfif NOT structKeyExists(arguments.xmlElement.XmlAttributes,attributeName)>
			<cfset arguments.xmlElement.XmlAttributes[attributeName] = attributeValue />
		</cfif>
	</cffunction>
	
	<!--- * Returns the attributes structure of the XML Element. --->
	<cffunction name="attributesGetStruct" hint="Returns the attributes structure of the XML Element." output="no">
		<cfargument name="xmlElement" required="yes">
		<cfreturn xmlElement.XmlAttributes>
	</cffunction>
	
	<!--- * Returns the list of attributes in an XML Element. --->
	<cffunction name="attributesList" hint="Returns the list of attributes in an XML Element." output="no">
		<cfargument name="xmlElement" required="yes">
		<cfreturn structKeyList(xmlElement.XmlAttributes)>
	</cffunction>
	
	
	<!--- These are the child(ren) methods. --->
	<!--- * Adds a child element to the passed in XML Element. --->
	<cffunction name="childAdd" hint="Adds a child element to the passed in XML Element." output="no">
		<cfargument name="xmlStructure" required="yes">
		<cfargument name="xmlElement" required="yes">
		<cfargument name="newElementName" required="yes">
		<cfset xmlElement.XmlChildren[arrayLen(xmlElement.XmlChildren)+1] = XMLElemNew(arguments.xmlStructure,"",arguments.newElementName)>
	</cffunction>
	
	<!--- * Returns the count children elements for the passed in XML Element. --->
	<cffunction name="childrenCount" hint="Returns the count children elements for the passed in XML Element." output="no">
		<cfargument name="xmlElement" required="yes">
		<cfreturn arrayLen( xmlElement.XmlChildren )>
	</cffunction>
	
	<!--- * Deletes a children elements from the passed in XML Element if it exist. --->
	<cffunction name="childrenDelete" hint="Deletes a child element from the passed in XML Element if it exist." output="no">
		<cfargument name="xmlElement" required="yes">
		<cfargument name="childrenNames" required="yes">

		<cfset var iChild = "" />
		<cfset var iChildNum = "" />

		<cfloop index="iChild" list="#arguments.childrenNames#">
			<cfloop index="iChildNum" from="#arrayLen(arguments.xmlElement.XmlChildren)#" to="1" step="-1">
				<cfif arguments.xmlElement.XmlChildren[iChildNum].XmlName EQ iChild>
					<cfset arrayDeleteAt(arguments.xmlElement.XmlChildren,iChildNum) />
				</cfif>
			</cfloop>
		</cfloop>
	</cffunction>
	
	<!--- * Returns the count children elements for the passed in XML Element. --->
	<cffunction name="childrenExist" hint="Returns the count children elements for the passed in XML Element." output="no">
		<cfargument name="xmlElement" required="yes">
		<cfargument name="children" required="no" default="">
		
		<cfset var hasChildren = iif( childrenCount(xmlElement) , true, false) />
		<cfset var foundChild = false />
		<cfset var iChild = "" />
		<cfset var iChildNum = "" />

		<cfloop index="iChild" list="#arguments.children#">
			<cfset foundChild = false>
			<cfloop index="iChildNum" from="#arrayLen(xmlElement.XmlChildren)#" to="1" step="-1">
				<cfif xmlElement.XmlChildren[iChildNum].XmlName EQ iChild>
					<cfset foundChild = true>
				</cfif>
			</cfloop>
			<cfset hasChildren = hasChildren AND foundChild>
		</cfloop>
		<cfreturn hasChildren>
	
	</cffunction>
	
	<!--- * Returns the count children elements for the passed in XML Element. --->
	<cffunction name="childrenGet" hint="Returns the count children elements for the passed in XML Element." output="no">
		<cfargument name="xmlElement" required="yes">
		<cfreturn xmlElement.XmlChildren>
	</cffunction>
	
	
	<!--- Element Management Methods --->	
	<!--- * Returns the name of the passed XML element. --->
	<cffunction name="elementGetName" access="public" returntype="string" hint="Returns the name of the passed XML element." output="no">
		<cfargument name="xmlElement" required="yes">
		<cfreturn xmlElement.xmlName>
	</cffunction>

	<!--- * Returns a the root element of an XML Structure. --->
	<cffunction name="elementGetRoot" access="public" returntype="string" hint="Returns a the root element of an XML Structure." output="no">
		<cfargument name="xmlStructure" required="yes">
		<cfif isXMLRoot( arguments.xmlStructure[structKeyList( arguments.xmlStructure )] )>
			 <cfreturn arguments.xmlStructure[structKeyList( arguments.xmlStructure )]>
		</cfif>
	</cffunction>
	
	<!--- Returns the passed element text. --->
	<cffunction name="elementGetText" access="public" returntype="string" hint="Returns true if the passed element has XML text." output="no">
		<cfargument name="xmlElement" required="yes">
		<cfreturn xmlElement.xmlText>
	</cffunction>
	
	<!--- Returns true if the passed element has XML text. --->
	<cffunction name="elementHasText" access="public" returntype="boolean" hint="Returns true if the passed element has XML text." output="no">
		<cfargument name="xmlElement" required="yes">
		<cfif len(xmlElement.xmlText)>
			 <cfreturn true>
		<cfelse>
			 <cfreturn false>	
		</cfif>
	</cffunction>
	
	<!--- Sets the passed element text. --->
	<cffunction name="elementSetText" access="public" hint="Sets the passed element text." output="no">
		<cfargument name="xmlElement" required="yes">
		<cfargument name="xmlText" required="yes" type="string">
		<cfset arguments.xmlElement.xmlText = arguments.xmlText>
	</cffunction>
	
</cfcomponent>