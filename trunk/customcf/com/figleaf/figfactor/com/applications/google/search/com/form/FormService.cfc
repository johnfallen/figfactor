<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			FormService.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am the API for form generation
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		11/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="FormService" output="false"
	hint="I am the API for form generation">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="FormService" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfargument name="configData" type="struct" required="true" 
		hint="I am the configuration structure. I am requried." />
	<cfargument name="metadataProperties" type="xml" required="false" 
		hint="I am the configuration structure. I am requried." />
	<cfargument name="Input" type="component" required="true" 
		hint="I am the Input utility component. I am requried." />
	
	<cfset variables.Input = arguments.Input />
	
	<cfset setInstanceVariables(arguments.configData) />
	<cfset setMetadataProperties(arguments.metadataProperties) />

	<cfreturn this />
</cffunction>



<!--- getSearchForm --->
<cffunction name="getSearchForm" returntype="string" access="public" output="false"
	displayname="Get Search Form" hint="I retrun a string that is an HTML form."
	Description="I retrun a string that is an HTML form.">
	
	<cfargument name="breakButton" type="boolean"  default="#getFormButtonBreakButton()#" 
		hint="Should the submit button be on a seperate line than the text input?<br />I default to false." />
	<cfargument name="buttonValue" type="string" default="#getFormButtonValue()#"
		hint="I am the value to appear in the submit button.<br />I default to 'Search.'" />
	<cfargument name="formClass" type="string" default="#getFormClass()#" 
		hint="I am the name of the form.<br />I default to 'GoogleSearchFrom'." />
	<cfargument name="formID" type="string" default="#getFormID()#" 
		hint="I am the ID of the form.<br />I default to'GoogleSearchFormID'." />
	<cfargument name="formName" type="string" default="#getFormName()#" 
		hint="I am the name of the form.<br />I default to 'GoogleSearchFrom'." />
	<cfargument name="formAction" type="string" default="#getformAction()#" 
		hint="I am the url to post to.<br />I default to a configured variable. " />
	<cfargument name="formMethod" type="string" default="#getFormMethod()#" 
		hint="I am the method the form uses to submit itself.<br />I default to a 'post'." />
	<cfargument name="formContent" type="string" default="" 
		hint="I am the content of the text input.<br />I default to an empty string." />
	<cfargument name="formInputSize" type="numeric" default="#getFormInputSize()#" 
		hint="I am the size of the text input field.<br />I default to '25'." />
	<cfargument name="formInputMaxLength" type="numeric" default="#getFormInputMaxLength()#" 
		hint="I am the maximum length for the text input field.<br />I default to '255'." />
    <cfargument name="formInputClass" type="string" default="#getFormInputClass()#" 
		hint="I am the maximum length for the text input field.<br />I default to '255'." />
    <cfargument name="formInputButtonClass" type="string" default="#getFormInputButtonClass()#" 
		hint="I am the maximum length for the text input field.<br />I default to '255'." />
    <cfargument name="formInputButtonID" type="string" default="#getFormInputButtonID()#" 
		hint="I am the maximum length for the text input field.<br />I default to 'GoogleSearchInputButtonID'." />
	<cfargument name="hiddenFieldsOnly" type="boolean" default="false" 
		hint="Only return the hidden fields with the correct values?<br />I default to 'false'." />
	
	<!--- if these arguments are passed the form returns metadata form fields --->
	<cfargument name="includePropertyFields" type="boolean" default="false" 
		hint="Should I return form fields that query metadata?<br />I default to 'false'." />
	<cfargument name="propertyPackageName" type="string" default="" 
		hint="I am the name of the XML package node to return as form fields?<br />I default an empty string." />
	
	<cfset var theForm = "" />
	<cfset var input = variables.input />
	
	<cfsavecontent variable="theForm"><cfoutput>
		<cfparam name="form.q" default="#input.getValue("name")#" />
		<cfparam name="form.num" default="#input.getValue("num")#" />
		<cfparam name="form.sort" default="#input.getValue('sort')#" />
		<cfparam name="form.scopeType" default="0" >
		<cfparam name="form.datefrom" default="#input.getValue('datefrom')#" />
		<cfparam name="form.dateto" default="#input.getValue('dateto')#" />
		<cfparam name="form.BTNG" default="#getBTNG()#" />
		
		<cfif arguments.hiddenFieldsOnly eq false>
			<form 
				method="#arguments.formMethod#" 
				action="#arguments.formAction#" 
				name="#arguments.formName#" 
				id="#arguments.formID#" 
				class="#arguments.formClass#">
				
				<!--- display this if the metadata form fields are returned --->		
				<cfif arguments.includePropertyFields eq true and len(arguments.propertyPackageName)>
					Search Text
				</cfif>
				
				<input 
					type="text" 
					name="q" 
					size="#arguments.formInputSize#" 
					maxlength="#arguments.formInputMaxLength#" 
					value="#form.q#"
	                class="#arguments.formInputClass#" />
				
				<cfif arguments.includePropertyFields eq true and len(arguments.propertyPackageName)><br />
					#getPropertyFields(
						packageName = arguments.propertyPackageName,
						input = input)#
				</cfif>
				
				<!--- <br /> the button if requested --->
				<cfif arguments.breakButton eq true>
					<br />
				</cfif>
				<input 
					type="submit" 
					name="btng" 
					value="#trim(arguments.ButtonValue)#" 
					class="#arguments.formInputButtonClass#" 
					id="#arguments.formInputButtonID#" />
			</cfif>
			
			<!--- always return these --->
			<input type="hidden" name="num" value="#trim(form.num)#" />
			<input type="hidden" name="sort" value="#trim(form.sort)#" />
			<input type="hidden" name="scopeType" value="#trim(form.scopeType)#" />
			<!--- <input type="hidden" name="datefrom" value="#trim(form.datefrom)#" />
			<input type="hidden" name="dateto" value="#trim(form.dateto)#" /> --->
			<input type="hidden" name="start" value="0" />
			
			<!--- close when we are not hidden fields only --->
			<cfif arguments.hiddenFieldsOnly eq false>
				</form>
			</cfif>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn compressHTML(theForm) />
</cffunction>



<!--- getPropertyFields --->
<cffunction name="getPropertyFields" returntype="any" access="public" output="false"
    displayname="Get Property Fields" hint="I return the requested properties as form fields by ""Package"" name."
    description="I return the requested properties as form fields by ""Package"" name.">
	
	<cfargument name="packageName" type="string" required="true" 
		hint="I am the name of the Package of properties to return as form fields. I am requried." />
	<cfargument name="fieldSize" type="numeric" default="#getFormInputSize()#" 
		hint="I am the size of the fields I render. I default to a configurable value.">
	<cfargument name="Input" type="component" required="true" 
		hint="I am the Input logic. I am requried." />
	
	<cfset var formFields = "" />
	<cfset var x = 0 />
	<cfset var y = 0 />
	<cfset var temp = 0 />
	<cfset var theValue = "" />
	
	<cfsavecontent variable="formFields">
		<cfloop array="#xmlSearch(getMetadataProperties(), '/googlemetadataproperties/package')#" index="x">		
			<cfif x.XmlAttributes.name eq arguments.packageName>
				<cfloop array="#x.XmlChildren#" index="y">
					<cfif structKeyExists(y.XmlAttributes, "formDisplay")>
						
						<!--- handle if its not a simple text field --->
						<cfif arrayLen(y.XmlChildren)>
							
							<!--- figure out each field type and render it --->
							<cfif y.XmlChildren[1].XmlAttributes.type eq "select">
								<cfoutput>
									#y.XmlAttributes.formLable#
									#getSelectList(y)#<br />
								</cfoutput>
							</cfif>
							
							<!--- TODO: add more form field types here when needed. --->
							<!---  radio
								<cfif y.XmlChildren[1].XmlAttributes.type eq "radio">
								</cfif>
							--->
							<!---
								checkbox
								<cfif y.XmlChildren[1].XmlAttributes.type eq "radio">
								</cfif>						
							--->
							<!---
								textarea
								<cfif y.XmlChildren[1].XmlAttributes.type eq "radio">
								</cfif>						
							--->
						<cfelse><!--- render a regular text field --->

							<cfoutput>
								#y.XmlAttributes.formLable#
								<input 
									type="text" 
								
									<!--- get all lose and evaluate if the value is in the form scope --->
									<cftry>
										<cfset temp = "partialfields_" & y.XmlAttributes.name />
										<cfset theValue = evaluate(temp) />
										value="#HTMLEditFormat(theValue)#"
										<cfcatch></cfcatch>												
									</cftry>
									
									name="partialfields_#y.XmlAttributes.name#" 
									id="partialfields_#y.XmlAttributes.name#" 
									size="#arguments.fieldSize#" /><br />
							</cfoutput>							
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
	</cfsavecontent>

    <cfreturn  formFields />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- formAction --->
<cffunction name="setformAction" access="public" output="false" returntype="void">
	<cfargument name="formAction" type="string" required="true"/>
	<cfset variables.instance.formAction = arguments.formAction />
</cffunction>
<cffunction name="getformAction" access="public" output="false" returntype="string">
	<cfreturn variables.instance.formAction />
</cffunction>
<!--- FormMethod --->
<cffunction name="setFormMethod" access="public" output="false" returntype="void">
	<cfargument name="FormMethod" type="string" required="true"/>
	<cfset variables.instance.FormMethod = arguments.FormMethod />
</cffunction>
<cffunction name="getFormMethod" access="public" output="false" returntype="string">
	<cfreturn variables.instance.FormMethod />
</cffunction>
<!--- FormID --->
<cffunction name="setFormID" access="public" output="false" returntype="void">
	<cfargument name="FormID" type="string" required="true"/>
	<cfset variables.instance.FormID = arguments.FormID />
</cffunction>
<cffunction name="getFormID" access="public" output="false" returntype="string">
	<cfreturn variables.instance.FormID />
</cffunction>
<!--- FormName --->
<cffunction name="setFormName" access="public" output="false" returntype="void">
	<cfargument name="FormName" type="string" required="true"/>
	<cfset variables.instance.FormName = arguments.FormName />
</cffunction>
<cffunction name="getFormName" access="public" output="false" returntype="string">
	<cfreturn variables.instance.FormName />
</cffunction>
<!--- FormClass --->
<cffunction name="setFormClass" access="public" output="false" returntype="void">
	<cfargument name="FormClass" type="string" required="true"/>
	<cfset variables.instance.FormClass = arguments.FormClass />
</cffunction>
<cffunction name="getFormClass" access="public" output="false" returntype="string">
	<cfreturn variables.instance.FormClass />
</cffunction>
<!--- FormInputSize --->
<cffunction name="setFormInputSize" access="public" output="false" returntype="void">
	<cfargument name="FormInputSize" type="numeric" required="true"/>
	<cfset variables.instance.FormInputSize = arguments.FormInputSize />
</cffunction>
<cffunction name="getFormInputSize" access="public" output="false" returntype="numeric">
	<cfreturn variables.instance.FormInputSize />
</cffunction>
<!--- FormInputMaxLength --->
<cffunction name="setFormInputMaxLength" access="public" output="false" returntype="void">
	<cfargument name="FormInputMaxLength" type="numeric" required="true"/>
	<cfset variables.instance.FormInputMaxLength = arguments.FormInputMaxLength />
</cffunction>
<cffunction name="getFormInputMaxLength" access="public" output="false" returntype="numeric">
	<cfreturn variables.instance.FormInputMaxLength />
</cffunction>
<!--- FormInputContent --->
<cffunction name="setFormInputContent" access="public" output="false" returntype="void">
	<cfargument name="FormInputContent" type="string" required="true"/>
	<cfset variables.instance.FormInputContent = arguments.FormInputContent />
</cffunction>
<cffunction name="getFormInputContent" access="public" output="false" returntype="string">
	<cfreturn variables.instance.FormInputContent />
</cffunction>
<!--- FormInputID --->
<cffunction name="setFormInputID" access="public" output="false" returntype="void">
	<cfargument name="FormInputID" type="string" required="true"/>
	<cfset variables.instance.FormInputID = arguments.FormInputID />
</cffunction>
<cffunction name="getFormInputID" access="public" output="false" returntype="string">
	<cfreturn variables.instance.FormInputID />
</cffunction>
<!--- FormInputClass --->
<cffunction name="setFormInputClass" access="public" output="false" returntype="void">
	<cfargument name="FormInputClass" type="string" required="true"/>
	<cfset variables.instance.FormInputClass = arguments.FormInputClass />
</cffunction>
<cffunction name="getFormInputClass" access="public" output="false" returntype="string">
	<cfreturn variables.instance.FormInputClass />
</cffunction>
<!--- FormInputButtonID --->
<cffunction name="setFormInputButtonID" access="public" output="false" returntype="void">
	<cfargument name="FormInputButtonID" type="string" required="true"/>
	<cfset variables.instance.FormInputButtonID = arguments.FormInputButtonID />
</cffunction>
<cffunction name="getFormInputButtonID" access="public" output="false" returntype="string">
	<cfreturn variables.instance.FormInputButtonID />
</cffunction>
<!--- FormInputButtonClass --->
<cffunction name="setFormInputButtonClass" access="public" output="false" returntype="void">
	<cfargument name="FormInputButtonClass" type="string" required="true"/>
	<cfset variables.instance.FormInputButtonClass = arguments.FormInputButtonClass />
</cffunction>
<cffunction name="getFormInputButtonClass" access="public" output="false" returntype="string">
	<cfreturn variables.instance.FormInputButtonClass />
</cffunction>
<!--- FormButtonValue --->
<cffunction name="setFormButtonValue" access="public" output="false" returntype="void">
	<cfargument name="FormButtonValue" type="string" required="true"/>
	<cfset variables.instance.FormButtonValue = arguments.FormButtonValue />
</cffunction>
<cffunction name="getFormButtonValue" access="public" output="false" returntype="string">
	<cfreturn variables.instance.FormButtonValue />
</cffunction>
<!--- FormShowMetaDataSearchFields --->
<cffunction name="setFormShowMetaDataSearchFields" access="public" output="false" returntype="void">
	<cfargument name="FormShowMetaDataSearchFields" type="boolean" required="true"/>
	<cfset variables.instance.FormShowMetaDataSearchFields = arguments.FormShowMetaDataSearchFields />
</cffunction>
<cffunction name="getFormShowMetaDataSearchFields" access="public" output="false" returntype="boolean">
	<cfreturn variables.instance.FormShowMetaDataSearchFields />
</cffunction>
<!--- FormButtonBreakButton --->
<cffunction name="setFormButtonBreakButton" access="public" output="false" returntype="void">
	<cfargument name="FormButtonBreakButton" type="boolean" required="true"/>
	<cfset variables.instance.FormButtonBreakButton = arguments.FormButtonBreakButton />
</cffunction>
<cffunction name="getFormButtonBreakButton" access="public" output="false" returntype="boolean">
	<cfreturn variables.instance.FormButtonBreakButton />
</cffunction>
<!--- Btng --->
<cffunction name="setBtng" access="public" output="false" returntype="void">
	<cfargument name="Btng" type="string" required="true"/>
	<cfset variables.instance.Btng = arguments.Btng />
</cffunction>
<cffunction name="getBtng" access="public" output="false" returntype="string">
	<cfreturn variables.instance.Btng />
</cffunction>
<!--- MetadataProperties --->
<cffunction name="setMetadataProperties" access="public" output="false" returntype="void">
	<cfargument name="MetadataProperties" type="xml" required="true"/>
	<cfset variables.instance.MetadataProperties = xmlParse(arguments.MetadataProperties) />
</cffunction>
<cffunction name="getMetadataProperties" access="public" output="false" returntype="xml">
	<cfreturn variables.instance.MetadataProperties />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
<!--- getSelectList --->
<cffunction name="getSelectList" returntype="string" access="private" output="false"
    displayname="Get Select List" hint="I return a select list for a form."
    description="I return a select list for a form.">
    
	<cfargument name="xml" type="xml" hint="I am the xml." />
	
	<cfset var selectList = "" />
	<cfset var x = 0 />
	<cfset var name = "" />
	<cfset var value = "" />
	
	<cfsavecontent variable="selectList"><cfoutput>
		<select name="partialfields_#arguments.xml.XmlAttributes.name#"  id="partialfields_#arguments.xml.XmlAttributes.name#">
			<cfloop array="#arguments.xml.XmlChildren[1].XmlChildren#" index="x">
					<cfset name = x.XmlChildren[1].XmlText />
					<cfset value = x.XmlChildren[2].XmlText />
					<option value="#value#">#name#</option>
			</cfloop>
		</select>
	</cfoutput></cfsavecontent> 

    <cfreturn selectList />
</cffunction>



<!--- compressHTML --->
<cffunction name="compressHTML" returntype="string" output="false" access="private" 
	hint="Compresses any HTML given.">
	
	<cfargument name="HTML" type="string" required="true" 
		hint="I am the HTML string to compress.<br />I am required." />

	<cfreturn reReplace( arguments.HTML, "[[:space:]]{2,}", chr( 13 ), "all" ) />
</cffunction>



<!--- setInstanceVariables --->
<cffunction name="setInstanceVariables" returntype="void" access="private" output="false"
    displayname="Set Instance Variables" hint="I set the internal variable scope data."
    description="I set the internal variable scope data. Pass me a structure with any keys that match the API's properties (getters/setters) and I will populate my internal variables.instance scope with the value.">
    
	<cfargument name="data" type="struct" required="false" default="#variables.instance#" 
		hint="I am a structure to populate my internals with. I defalut to another internaly stored structure." />
	
	<cfset var x = 0 />
	<cfset var y = 0 />
	<cfset var functionCall = 0 />

	<!--- loop over the collection, then the array of functions --->
	<cfloop collection="#arguments.data#" item="y">
		<cfloop array="#getMetaData(this).functions#" index="x">

			<cfif 
				y eq right( x.name, ( len(x.name)-3) ) 
				and 
				left(x.name, 3) eq "set">

				<cfset functionCall = evaluate(#x.name#) />
				<cfset functionCall(arguments.data[y]) />
				<cfbreak />
			</cfif>
		</cfloop>
	</cfloop>

</cffunction>
</cfcomponent>