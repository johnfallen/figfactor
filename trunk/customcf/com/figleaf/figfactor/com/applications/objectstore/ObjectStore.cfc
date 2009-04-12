<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			Gateway.cfc 
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:    		@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    		I am the gateway class to access the persisted xml
Modification Log:
Name 			Date 								Description
================================================================================
John Allen 		15/03/2009			Created
------------------------------------------------------------------------------->
<cfcomponent displayname="Object Store" output="false"
	hint="I am the API for the Object Storage class used to persist objects in an xml file.">

<cfset variables.THE_PATH = getDirectoryFromPath(GetCurrentTemplatePath()) />
<cfset variables.COM_FILE_PATH = "#variables.THE_PATH#com/figleaf/objectstore/" />
<cfset variables.BEAN_STORAGE_FILE_PATH = "#variables.COM_FILE_PATH#storage/bean_storage.xml" />
<cfset variables.EMPTY_STORAGE_FILE_PATH = "#variables.COM_FILE_PATH#storage/empty_storage.xml" />
<cfset variables.SHARED_STORAGE_FILE_PATH = "#variables.COM_FILE_PATH#storage/shared_storage.xml" />


<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="ObjectStore" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfset var xml = 0 />	
	<cfset var stroagePath = variables.BEAN_STORAGE_FILE_PATH />
	<cfset var emptyStoragePath = variables.EMPTY_STORAGE_FILE_PATH />
	<cfset var sharedStoragePath = variables.SHARED_STORAGE_FILE_PATH />

	<cfset variables.BeanService = createObject("component", "com.figleaf.objectstore.bean.BeanService").init() />
	<cfset variables.Serializer = createObject("component", "com.figleaf.objectstore.util.Serializer").init() />
	<cfset variables.Security = createObject("component", "com.figleaf.objectstore.security.Security").init() />
	<cfset variables.Sync = createObject("component", "com.figleaf.objectstore.sync.Sync").init() />
	
	<cffile action="read" file="#stroagePath#" variable="xml" />

	<cfset xml = xmlParse(xml) />
	
	<!--- use the empty file if no records exist in the real file --->
	<cfif not arrayLen(xml.Records.XmlChildren) gt 1>
		<cffile action="read"  file="#emptyStoragePath#" variable="xml" />
		<cfset xml = xmlParse(xml) />
	</cfif>
	
	<cfset setDB(xml) />
	
	<cfreturn this />
</cffunction>



<!--- create --->
<cffunction name="create" returntype="any" access="public" output="false"
    displayname="Create" hint="I create a record."
    description="I create and return a new record object.">

	<cfargument name="type" type="string" required="true" 
		hint="I am the type of the record to create. I am requried." />
	
	<cfset var bean = getBean(arguments.type) />
	<cfset makeRecordEntry(bean) />
	
	<cfreturn read(bean.getID()) />
</cffunction>



<!--- delete --->
<cffunction name="delete" returntype="void" access="public" output="false"
    displayname="Delete" hint="I delete a record object."
    description="I delete a record object.">
    
	<cfargument name="bean" type="component" required="true" 
		hint="I am the bean to delete from the store. I am requried." />
	
	<cfset var index = 1 />
	<cfset var x = 0 />
	
	<cfloop array="#getDB().records.XmlChildren#" index="x">
		<cfif x.XmlAttributes.id eq arguments.bean.getID()>
			<cfset arrayDeleteAt(getDB().records.XmlChildren, index) />
			<cfbreak />
		</cfif>
		<cfset index = index + 1 />
	</cfloop>
	
	<cfset saveDB() />
	
</cffunction>



<!--- getBean --->
<cffunction name="getBean" returntype="any" access="public" output="false"
    displayname="Get Bean" hint="I return an empty bean object as defined in the configuration XML by name."
    description="I return an empty bean object as defined in the configuration XML by name.">
    
	<cfargument name="type" type="string" required="true" 
		hint="I am the Type of Bean to return. I am required." />
	
    <cfreturn variables.BeanService.getBean(argumentCollection = arguments) />
</cffunction>



<!--- getDB --->
<cffunction name="getDB" access="public" output="false" returntype="xml"
	displayname="Get DB" hint="I return the DB property." 
	description="I return the DB property to my internal instance structure.">

	<cfreturn variables.instance.DB />
</cffunction>



<!--- getInstance --->
<cffunction name="getInstance" returntype="struct" access="public" output="false"
	displayname="Get Instance" hint="I return my internal instance data as a structure."
	description="I return my internal instance data as a structure, the 'momento' pattern.">
	
	<cfreturn variables.instance />
</cffunction>



<!--- listBeans --->
<cffunction name="listBeans" returntype="string" access="public" output="false"
    displayname="Get Avaiable Beans" hint="I return a list of the avaiable beans that I manage as defined in the configuration XML."
    description="I return list of the avaiable beans that I manage as defined in the configuration XML.">
    
    <cfreturn structKeyList(variables.beanService.getAllBeans()) />
</cffunction>



<!--- read --->
<cffunction name="read" returntype="any" access="public" output="false"
    displayname="Read" hint="I return a record object by id."
    description="I return a record object by id. If no object is found I return 0.">
    
	<cfargument name="id" type="string" required="true" 
		hint="I am the ID of the record. I am requried." />
	
	<cfset var record = XmlSearch(getDB(), "/records/record[ @id = '#arguments.id#' ]") />
	<cfset var bean = 0 />
	
	<cfif isArray(record) and arrayLen(record) eq 1>
		<cfset record = record[1] />
		<cfset bean = variables.serializer.deserialize(record.XmlChildren[1].XmlText) />
		<cfset bean.setBorneAgain("#dateFormat(now(), 'long')# | #timeFormat(now(), 'long')#")>
	</cfif>
	
	<cfreturn bean />
</cffunction>



<!--- save --->
<cffunction name="save" returntype="component" access="public" output="false"
    displayname="Save" hint="I save or update an object to the store."
    description="I save or update an object to the store.">

	<cfargument name="bean" type="component" required="true" 
		hint="I am the bean to save. I am requried." />
    
	<cfset var records = xmlSearch(getDB(), "/records/record/") />
	<cfset var x = 0 />
	<cfset var index = 1 />
	
	<!--- delete the item if it exists --->
	<cfloop array="#records#" index="x">	
		<cfif x.XmlAttributes.id eq arguments.bean.getID()>
			<cfset delete(arguments.bean) />
			<cfbreak />
		</cfif>
		<cfset index = index + 1 />
	</cfloop>

	<cfset makeRecordEntry(arguments.bean) />
	
    <cfreturn arguments.bean />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->

<!--- makeRecordEntry --->
<cffunction name="makeRecordEntry" returntype="xml" access="private" output="false"
    displayname="Make Record Entry" hint="I retrurn a record entry."
    description="I retrurn a record entry.">
    
	<cfargument name="bean" type="component" required="true" 
		hint="I am the bean to make a record for. I am requried." />
	
	<cfset var xml = 0 />
	
	<cfxml variable="xml">
<cfoutput>
		<record  
		id="#arguments.bean.getID()#" 
		type="#bean.getBeanName()#"
		saved="#dateformat(now(),"long")# | #timeFormat(now(), "long")#"><object><![CDATA[#variables.serializer.serialize(bean)#]]></object>
</record>
</cfoutput>
	</cfxml>	
	
	<cfset XmlAppend(getDB().records, xml) />
	
	<cfset saveDB() />
	
    <cfreturn xml />
</cffunction>



<!--- saveDB --->
<cffunction name="saveDB" returntype="void" access="private" output="false"
    displayname="Save DB" hint="I save the local XML storage."
    description="I save the local XML storage.">
    
	<cfset var storagePath = variables.BEAN_STORAGE_FILE_PATH />
	<cfset var xml = getDB() />
	
	<cflock type="exclusive" name="#createUUID()#WriteObjectStoreToDiskLock" timeout="120">
		<cffile action="write" file="#StoragePath#" output="#toString(xml)#" />
	</cflock>
	
</cffunction>



<!--- setDB --->
<cffunction name="setDB" access="private" output="false" returntype="void"
	displayname="Set DB" hint="I set the DB property." 
	description="I set the DB property to my internal instance structure.">
	
	<cfargument name="DB" type="xml" required="true"
		hint="I am the DB property. I am required."/>
	
	<cfset variables.instance.DB = arguments.DB />
	
</cffunction>



<!--- XmlAppend --->
<cffunction name="XmlAppend" access="public" returntype="any" output="false" 
	displayname="Xml Append" hint="Copies the children of one node to the node of another document."
	description="Copies the children of one node to the node of another document. Code by Ben Nadle: www.bennadle.com.">
 
	<cfargument name="NodeA" type="any" required="true"
		hint="The node whose children will be added to." />
	<cfargument name="NodeB" type="any" required="true"
		hint="The node whose children will be copied to another document." />

	<cfset var LOCAL = StructNew() />
	
	<cfset LOCAL.ChildNodes = ARGUMENTS.NodeB.GetChildNodes() />
 
	<!--- Loop over child nodes. --->
	<cfloop index="LOCAL.ChildIndex" from="1" to="#LOCAL.ChildNodes.GetLength()#" step="1">

		<cfset LOCAL.ChildNode = LOCAL.ChildNodes.Item(
			JavaCast(
				"int",
				(LOCAL.ChildIndex - 1)
				)
			) />

		<cfset LOCAL.ChildNode = ARGUMENTS.NodeA.GetOwnerDocument().ImportNode(
			LOCAL.ChildNode,
			JavaCast( "boolean", true )
			) />
 
		<cfset ARGUMENTS.NodeA.AppendChild(
				LOCAL.ChildNode
			) />
 
	</cfloop>

	<cfreturn ARGUMENTS.NodeA />
</cffunction>
</cfcomponent>