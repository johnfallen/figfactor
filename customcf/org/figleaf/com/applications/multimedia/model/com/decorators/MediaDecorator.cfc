<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			Media.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I decorate the Transfer Media object
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		04/01/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Media Decorator" output="false" extends="transfer.com.TransferDecorator" 
	hint="I decorate Transfer's Media object.">

<!--- *********** Public ************ --->

<!--- configure --->
<cffunction name="configure" returntype="void" access="public" output="false" 
	displayname="Configure" hint="I am the Transfer Configure method." 
	description="I set variables that this cfc needs.">
	
	<!--- the property that contains new file uploads --->
	<cfset variables.MediaFile = "" />
	<cfset variables.KeywordIDList = "" />

	<cfset variables.config = application.beanfactory.getBean("Multimedia").getBean("config") />
	
	<!--- 
		There are three (can add more!) types of media objects: audio, image and video. 
		We need properties definitions for each type that can also vary per deployment.
		An XML file provides the objects and their properties, then the specific XML is 
		stored in the database.
	 --->
	<cfset variables.globalPropertiesXML = variables.config.getMediaPropertiesXML() />
	
	<!--- 
		Media objects have parent Type objects. The getTypeName() method is used
		in a couple of places to check on what type of xml to get if its a new object,
		so make sure its defined.
	--->
	<cfset setTypeName() />
	
	<cfset variables.NOT_FOUND = "NOT_FOUND" />
	
</cffunction>



<!--- getMediaPropertyArray --->
<cffunction name="getMediaPropertyArray" returntype="array" access="public" output="false"
    displayname="Get Media Property Array" hint="I am a helper function that returns the meida objects properties as an array."
    description="I am a helper function that returns the meida objects properties as an array. THROWS ERROR if the object isnt persisted and has no XML.">
	
	<cfargument name="typeName" type="string" required="false" default="#getTypeName()#" 
		hint="I am the name of the Parent Type object. I default to getTypeName()." />
    	
	<cfset arguments.returnAsArray = true />
		
	<cfreturn getMediaPropertyXML(argumentCollection = arguments) />
</cffunction>



<!--- getMediaPropertyValue --->
<cffunction name="getMediaPropertyValue" returntype="string" access="public" output="false"
    displayname="Get Media PropertyValue" hint="I return a Media object configurable propergty value by name."
    description="I return a Media object configurable propergty value by name. Returns a 'not_found' constant if the value dose not exist.">
    
	<cfargument name="name" type="string" required="true"
		hint="I am the name of the property to return. I am requried." />
	
	<cfset var properties = arrayNew(1) />
	<cfset var x = 0 />
	<cfset var property = variables.NOT_FOUND />
	
	<!--- if saved and has XML --->
	<cfif getOriginalTransferObject().getIsPersisted() and isXML(getOriginalTransferObject().getMediaPropertyXML())>

		<cfset properties = XMLSearch(getMediaPropertyXML(), "/#getTypeName()#/property/") />

		<!--- loop.  if equal, set the value from the XML then break --->
		<cfloop array="#properties#" index="x">
			<cfif x.XMLAttributes.name eq arguments.name>
				<cfset property =  x.XMLAttributes.value />
				<cfbreak />
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn property />
</cffunction>



<!--- getMediaPropertyXML --->
<cffunction name="getMediaPropertyXML" returntype="any" access="public" output="false"
    displayname="Get Media Property XML" hint="I return the media objects XML propeties."
    description="I return the media objects XML propeties. THROWS ERROR if the object is not persisted and not passed a typeName.">
    
	<cfargument name="typeName" type="string" required="false" default="#getTypeName()#" 
		hint="I am the Parent Type objects name. I default to getTypeName().">
	<cfargument name="returnAsArray" type="boolean" required="false" default="false" 
		hint="Should i return the property data as an array? Helpfull for non peristed objects.">
	
	<cfset var xml = 0 />
	
	<!--- if saved with XML --->
	<cfif getOriginalTransferObject().getIsPersisted() and isXML(getOriginalTransferObject().getMediaPropertyXML())>
			
		<cfset xml = getTransferObject().getMediaPropertyXML() />
	
	<!--- if saved with no XML (a rare condition here for coverage) --->
	<cfelseif getTransferObject().getIsPersisted() >
	
		<cfset xml = getGlobalXMLDefinitions().objects[getTransferObject().getParentType().getName()] />
	
	<!--- inplicitly get the definition by name --->
	<cfelseif len(arguments.typeName)>
		<cfset xml = getGlobalXMLDefinitions().objects[arguments.typeName] />
	<cfelse>
		<cfset throwError(
			message = "The Media object is not persisted so NO XML is yet avaiable.",	
			detail = "IDMedia: #getIDMedia()#, typeName: #typeName#") />
	</cfif>
	
	<!--- return based on desire --->
	<cfif arguments.returnAsArray eq true>
		<cfset xml = XMLParse(xml) />
		<cfreturn XMLSearch(xml, "/#arguments.typeName#/property/") />
	<cfelse>
		<cfreturn XMLParse(xml) />
	</cfif>
</cffunction>



<!--- setAvaiable --->
<cffunction name="setAvaiable" access="public" returntype="void" output="false"
	displayname="setAvaiable" hint="I set the Avaiable property of the Transfer object." 
	description="I set the Avaiable property of the Transfer object. THROWS ERROR if the arguments.avaiable is not an interger of 0 or 1.">

	<cfargument name="Avaiable" type="any" required="true" 
		hint="Am I avaiable for the public?<br />I am required." />

	<!--- check if this is cool to save for coverage --->
	<cfif isNumeric(arguments.Avaiable) and arguments.Avaiable lte 1 or arguments.Avaiable eq "on">
		<cfset getTransferObject().setAvaiable(trim(castCheckBox(checkbox = arguments.Avaiable))) />
	</cfif>
</cffunction>



<!--- setMediaPropertyXML --->
<cffunction name="setMediaPropertyXML" returntype="void" access="public" output="false"
    displayname="Set Media Property XML" hint="I take a structure and update the media objects properties xml."
    description="I take a structure and update the object properties values xml, then set the object property. THROWS ERROR: if the object is not persisted, and no type name provided or defined in the object itself.">
    
	<cfargument name="input" type="struct" required="true" 
		hint="I am the structure of properties to set. I am requried." />
	<cfargument name="typeName" type="string" default="#getTypeName()#" 
		hint="I am the name of the parent type object. I defalut to the getTypeName() method." />
	
	<cfset var xml = getMediaPropertyXML(argumentCollection = arguments) />
	<cfset var properties = XMLSearch(xml, "/#arguments.typeName#/property/") />
	
	<!--- loop and update the object properties with new values --->
	<cfloop array="#properties#" index="x">

		<cfloop collection="#arguments.input#" item="y">
			<cfif x.XMLAttributes.name eq y>
				<cfset x.XMLAttributes.value = arguments.input[y] />
			</cfif>
		</cfloop>
	</cfloop>

	<!--- make the xml a string and set ti --->
	<cfset getTransferObject().setMediaPropertyXML(ToString(xml)) />
	
</cffunction>



<!--- *********** Getters Setters / Accesssors Mutators *********** --->

<!--- setKeywordIDList --->
<cffunction name="setKeywordIDList" access="public" returntype="void" output="false" 
	hint="I set the keyword IDs property of the Transfer object's decorator'.">
	<cfargument name="KeywordIDList" type="string" required="true" 
		hint="I am the name of the list of keyword IDs.<br />I am required." />
	<cfif len(arguments.KeywordIDList)>
		<cfset variables.KeywordIDList = arguments.KeywordIDList />
	</cfif>
</cffunction>
<!--- getKeywordIDs --->
<cffunction name="getKeywordIDList" access="public" returntype="string" output="false" 
	hint="I return the media's keyword IDs as a string.">
	<cfreturn variables.KeywordIDList /> 
</cffunction>
<!--- setMediaFile --->
<cffunction name="setMediaFile" access="public" returntype="void" output="false" 
	hint="I set the MediaFile property of the Transfer object's decorator.">
	<cfargument name="MediaFile" type="any" required="true" 
		hint="I am the MediaFile.<br />I am required." />
	<cfif len(arguments.MediaFile)>
		<cfset variables.MediaFile = arguments.MediaFile />
	</cfif>
</cffunction>
<!--- getMediaFile --->
<cffunction name="getMediaFile" access="public" returntype="any" output="false" 
	hint="I return the new file to replace the origional.">
	<cfreturn variables.MediaFile /> 
</cffunction>
<!--- setTypeName --->
<cffunction name="setTypeName" access="public" returntype="void" output="false" 
	hint="I set the name of the media objects Parent Type object.">
	<cfargument name="TypeName" type="any" required="false" default="" 
		hint="I am the TypeName. I default to a null string." />
	<cfset variables.TypeName = arguments.TypeName />
</cffunction>
<!--- getTypeName --->
<cffunction name="getTypeName" access="public" returntype="any" output="false" 
	hint="I return the name of the media objects Parent Type object.">
	<cfreturn variables.TypeName /> 
</cffunction>
<!--- setIDType --->
<cffunction name="setIDType" access="public" returntype="void" output="false" 
	hint="I set the name of the parent Type.">
	<cfargument name="IDType" type="numeric" required="true" 
		hint="I am the IDType.<br />I am required." />
	<cfif len(arguments.IDType)>
		<cfset variables.IDType = arguments.IDType />
	</cfif>
</cffunction>
<!--- getIDType --->
<cffunction name="getIDType" access="public" returntype="any" output="false" 
	hint="I return the ID of the medias Type.">
	<cfreturn variables.IDType /> 
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- castCheckBox --->
<cffunction name="castCheckBox" returntype="numeric" access="private" output="false" 
	displayname="Cast Check Box" hint="I check if a check box is on or off and retrun a 1 or 0." 
	description="I check if a check box is on or off and retrun a 1 or 0.">
	<cfargument name="CheckBox" type="any" required="true" hint="I am the check box value to check.<br />I am required." />
	
	<cfset var result = 0 />
	
	<cfif arguments.CheckBox eq "on">
		<cfset result = 1 />
	</cfif>
	
	<cfif arguments.CheckBox eq "on" or arguments.CheckBox eq 1>
		<cfset result = 1 />
	</cfif>
	
	<cfreturn result />
</cffunction>



<!--- getGlobalXMLDefinitions --->
<cffunction name="getGlobalXMLDefinitions" returntype="xml" access="private" output="false"
    displayname="Get All Media Property XML Defnitions" hint="I return the mediaproperty.xml as a XML object."
    description="I return the whole configuration mediaproperty.xml as a XML object.">

    <cfreturn variables.globalPropertiesXML />
</cffunction>



<!--- getMediaPropetyDefinition --->
<cffunction name="getMediaPropetyDefinition" returntype="any" access="private" output="false"
    displayname="Get Media Property Definition" hint="I return the media objects XML (empty, not the persisted XML) properties read from the conguration file."
    description="I return the media objects XML (empty, not the persisted XML) properties read from the conguration file, eg: audio, image, videos. <br />THROWS ERROR if the typeName is 0 length.">
    
	<cfargument name="typeName" type="string" default="#getTypeName()#"
		hint="I am the name of the type of objects properties to return. Audio, Image, Video. I default to a method call: getTypeName()." />

	<cfset var definition = 0 />

	<cfif len(arguments.typeName)>		 
		  <cfset definition = XMLSearch(variables.globalPropertiesXML, "/objects/#arguments.typeName#") />
		 <!--- always an array from XMLSearch so retrun the top index, there only one element --->
		  <cfreturn definition[1] />
	<cfelse>
		<cfset throwError(
			message="You are trying to access the XML definition for a Media object and there is no Parent Type set." , 
			detail="This means the media object has not yet been persisted. IDMedia = #getIDMedia()#.") />
	</cfif>
</cffunction>



<!--- thowError --->
<cffunction name="throwError" returntype="void" access="private" output="false"
    displayname="Throw Error" hint="I am a helper funciton to thow an error."
    description="I am a helper funciton to thow an error.">

	<cfthrow 
		message="#arguments.message#" 
		detail="#arguments.detail#"
		type="multimedia.model.com.decorator.MediaDecorator" />
</cffunction>
</cfcomponent>