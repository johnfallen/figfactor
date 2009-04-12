<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			BeanService.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am the Bean Service.
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		16/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Bean Service" output="false"
	hint="I am the Bean Service. I ap the API for beans.">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="BeanService" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfset var beanDefinitions = 0 />

	<cfset variables.instance = structNew() />
	
	<!--- a collection of all my avaiable beans --->
	<cfset variables.beanMap = structNew() />
	
	<cffile 
		action="read" 
		file="#getDirectoryFromPath(GetCurrentTemplatePath())#beans.xml" 
		variable="beanDefinitions" />

	<cfset setBeanDefinitions( xmlParse(beanDefinitions) ) />
	
	<cfreturn this />
</cffunction>



<!--- getBean --->
<cffunction name="getBean" returntype="component" access="public" output="false"
    displayname="Get Bean" hint="I return an empty bean by type."
    description="I return an empty bean by type.">
   
	<cfargument name="type" type="string" required="true" 
		hint="I am the Name of the bean. I am requried." />	
	
	<cfset var beanDefinitions = getBeanDefinitions() />
	<cfset var definition = 0 />
	<cfset var c = 0 />
	<cfset var x = 0 />
	<cfset var property = 0 />
	<cfset var args = structNew() />
	<cfset var bean = 0 />
		
	<cfloop array="#beanDefinitions.beans.XmlChildren#" index="c">
		<cfif structKeyExists(c.XmlAttributes, "name") and lcase(c.XmlAttributes.name) eq lcase(arguments.type)>
			<cfset definition = c />
			<cfbreak />
		</cfif>
	</cfloop>
	
	<cftry>
		<!--- create the args used to populate the abstract bean --->
		<cfloop array="#definition.XmlChildren#" index="x">
			<cfset property = x />
			<!--- set a propety --->
			<cfif property.XmlChildren[1].XmlName eq "name">	
				<cfset args[property.XmlChildren[1].xmlText] = "" />
			<!--- set a structure for children --->
			<cfelse>
				<!--- make a structure to contain the children --->
				<cfset args.children[property.XmlChildren[1].xmlAttributes.name] = structNew() />
			</cfif>
		</cfloop>
		
		<cfset args.beanName = definition.XmlAttributes.name />
		<cfset args.name = args.beanName />
		<cfset args.id = replace(createUUID(), "-", "", "all")/>
	
		<!--- make an abstract bean --->
		<cfset bean = createObject("component", "AbstractBean").init(
			argumentCollection = args) />
		
		<cfset setDefinedBean(bean.getBeanName(), duplicate(bean)) />
		<cfcatch>
			<cfthrow detail="#cfcatch.Detail#" message="Error Building the Bean named: #arguments.type#" />
		</cfcatch>
	</cftry>
    <cfreturn bean />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- getAllBeans --->
<cffunction name="getAllBeans" returntype="struct" access="public" output="false"
    displayname="Get All Beans" hint="I return all of my insanciated beans I manage.  NOTE: These beans are used to find out what ObjectStore can return, not beans to be used by applications using ObjectStore. Use the getBean() method to get a bean to work with and save in to the ObjectStore."
    description="I return all of my insanciated beans I manage.  NOTE: These beans are used to find out what ObjectStore can return, not beans to be used by applications using ObjectStore. Use the getBean() method to get a bean to work with and save in to the ObjectStore.">
    
    <cfreturn variables.beanMap />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
<!--- setDefinedBean --->
<cffunction name="setDefinedBean" returntype="void" access="private" output="false"
    displayname="Set Defined Bean" hint="I set a bean to my internal map of beans."
    description="I set a bean to my internal map of beans.">
    
	<cfargument name="name" type="string" required="true" 
		hint="I am the Name of the bean. I am requried." />	
	<cfargument name="bean" type="component" required="true" 
		hint="I am the bean. I am requried." />
	
	<cfset variables.beanMap[arguments.name] = arguments.bean />
	
</cffunction>



<!--- getBeanDefinitions --->
<cffunction name="getBeanDefinitions" access="public" output="false" returntype="xml"
	displayname="Get BeanDefinitions" hint="I return the BeanDefinitions property." 
	description="I return the BeanDefinitions property to my internal instance structure.">
	<cfreturn variables.instance.BeanDefinitions />
</cffunction>
<!--- setBeanDefinitions --->
<cffunction name="setBeanDefinitions" access="public" output="false" returntype="void"
	displayname="Set BeanDefinitions" hint="I set the BeanDefinitions property." 
	description="I set the BeanDefinitions property to my internal instance structure.">
	<cfargument name="BeanDefinitions" type="xml" required="true"
		hint="I am the BeanDefinitions property. I am required."/>
	<cfset variables.instance.BeanDefinitions = arguments.BeanDefinitions />
</cffunction>
</cfcomponent>