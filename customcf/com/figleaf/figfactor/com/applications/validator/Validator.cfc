<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			Validator.cfc
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I harden the inputs for the CommonSpot Authoring modules
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		10/12/2008			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Validator" output="false"
	hint="I harden the inputs for the CommonSpot Authoring modules">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="Validator" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">
	
	<cfargument name="Config" type="component" required="true"  />
	<cfargument name="Logger" type="component" required="true"  />
	<cfargument name="FileSystem" type="component" required="true" />
	
	<cfset var thePath = "" />
	<cfset var theFileData = ""/>
	<cfset var theXML = 0 />
	<cfset var x = 0 />
	
	<cfset variables.config = arguments.Config />
	<cfset variables.logger = arguments.logger />
	<cfset variables.FileSystem = arguments.FileSystem />
	
	<!--- list of forbidden strings --->
	<cfset variables.forbiddenStrings = "">
	
	<!--- read the xml --->
	<cfset thePath = variables.config.getFrameworkPath() & "/com/applications/validator/" />
	<cfset theFileData = variables.FileSystem.read(
		Destination = thePath, 
		FileName = "forbidden_strings.xml") />
	<cfset theXML = XMLParse(theFileData)>
	
	<!--- loop and set the forbidden strings list --->
	<cfloop from="1" to="#arrayLen(theXML.forbiddenstrings.XMLChildren)#" index="x">
		<cfset variables.forbiddenStrings = listAppend(
			variables.forbiddenStrings, 
			theXML.forbiddenstrings.XMLChildren[x].XmlText) />
	</cfloop>

	<cfreturn this />
</cffunction>



<!--- checkInput --->
<cffunction name="checkInput" returntype="void" access="public" output="true"
	displayname="Format From" hint="I check if a form contains any XSS attack strings."
	description="I check if a form contains any XSS attack strings.<br />Throw error if a forbiden string is found.">

	<cfset var x = 0 />
	<cfset var stuffToCheck = application.BeanFactory.getBean("Input").load() />

	<cfloop collection="#stuffToCheck#" item="x">
		
		<!--- WDDX is passed in form fields, so skip that stuff --->
		<cfif not isWDDX(stuffToCheck[x])>	
			
			<!--- Check the input collection, keys & values, for anything bad --->
			<cfif containsXSS(stuffToCheck[x]) eq true>
				<cfset variables.logger.setMessage(type="WARN",  message = "XSS Paramater passed as Value: #stuffToCheck[x]#") />
				<cfthrow message="A string containing harmfull content was passed to the application." />
			</cfif>
			<cfif containsXSS(x) eq true>
				<cfset variables.logger.setMessage(type="WARN",  message = "XSS Paramater passed as Key: #x#") />
				<cfthrow message="A string containing harmfull content was passed to the application." />
			</cfif>
		</cfif>
	</cfloop>

	<cfdump var="#this#">
	<cfabort>
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- containsXSS --->
<cffunction name="containsXSS" returntype="boolean" access="private" output="false"
	displayname="Contains XSS" hint="I check a string for possiable XSS attack strings."
	description="I check a string for possiable XSS attack strings.">
	
	<cfargument name="stringToCheck" type="string" required="true" 
		hint="I am the string to check for XSS attacks.<br />I am required." />
	
	<cfset var x = "">
	<cfset var test = false />
	
	<cfloop list="#variables.forbiddenStrings#" index="x" delimiters=",">
		<cfif arguments.StringToCheck contains x>
			<cfset test = true />
		</cfif>
	</cfloop>
	<cfreturn test />
</cffunction>
</cfcomponent>