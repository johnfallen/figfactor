<cfcomponent displayname="Controller" extends="ModelGlue.unity.controller.Controller" output="false" 
	beans="AdminConfig, Config, Logger, FileMapper, Pagination, DataService, Security">

<!--- onRequestStart --->
<cffunction name="onRequestStart" access="public" returnType="void" output="false">
	<cfargument name="event" type="any" />
	
	<!--- TODO: prototyped code!... whats the event name in the event object??? kill url.event --->
	<cfparam name="url.event" default="page.index" />
	
	<cfif 
	isDefined("session.AllowExternalApplicationManagement") 
	and session.AllowExternalApplicationManagement eq false
	and url.event neq "login.form" 
	and url.event neq "do.login" 
	and url.event neq "do.logout">
		<cfset arguments.event.forward("login.form") />
	<cfelse>
		<cfif 
		not isDefined("session.AllowExternalApplicationManagement") 
		and url.event neq "login.form"
		and url.event neq "login.form" 
		and url.event neq "do.login" 
		and url.event neq "do.logout">
			<cfset arguments.event.forward("login.form") />
		</cfif>
	</cfif>
	<!--- make a refrence, the beans scop is a cool idea --->
	<cfset beans.FigFactor = Application.FigFactor />
</cffunction>


<!--- listBeans --->
<cffunction name="listBeans" output="false">
	<cfargument name="event" />
	
	<cfset var data = beans.figFactor.getDIConfiguration() />
	<cfset var paths = data.DIProperties />
	<cfset var files = data.DIXml />
	<cfset var beansXML = structNew() />
	<cfset var x = 0 />
	<cfset var temp = 0 />
	<cfset var basePath = paths.FrameworkPath & paths.CODEBASEREALITIVEPATH & "config/system/coldspring/" />
	
	<!--- read and parse each bean definition file --->
	<cfloop collection="#files#" item="x">
		<cffile action="read" file="#basePath##files[x]#" variable="xml">
		<cfset temp = xmlParse(xml) />
		<cfset beansXML[x] = temp />
	</cfloop>
	
	<cfset arguments.event.setValue("beans", beansXML) />
</cffunction> 



<!--- doLogin --->
<cffunction name="doLogin" output="false">
	<cfargument name="event" />
	
	<cfset var username = arguments.event.getValue("username") />
	<cfset var password = arguments.event.getValue("password") />
	
	<cfif beans.security.userLogin(username = username, password = password) eq 0>
		<cfset session.AllowExternalApplicationManagement = false />
		<cfset arguments.event.setValue("message", "Log in failed.") />
		<cfset arguments.event.forward("login.form", "message") />
	<cfelse>
		<cfset session.AllowExternalApplicationManagement = true />
	</cfif>
</cffunction> 



<!--- doLogout --->
<cffunction name="doLogout" output="false">
	<cfargument name="event" />
	<cfset beans.security.userLogOut() />
	<cfset arguments.event.setValue("message", "Logged out.") />
	<cfset arguments.event.forward("login.form", "message") />
	<cfset structClear(session) />
</cffunction> 



<!--- addUser --->
<cffunction name="addUser" output="false">
	<cfargument name="event" />
	
	<cfset var args = structNew() />
	<cfset var message = "" />
	<cfset var usernameMessage = "" />
	<cfset var passwordMessage = "" />
	<cfset var test = false />
	
	<cfset args.username = trim(arguments.event.getValue("username")) />
	<cfset args.username2 = trim(arguments.event.getValue("username2")) />
	<cfset args.password = trim(arguments.event.getValue("password")) />
	<cfset args.password2 = trim(arguments.event.getValue("password2")) />
	
	<cfif not args.username eq args.username2>
		<cfset usernameMessage = "Usernames did not match.&nbsp;&nbsp;" />
		<cfset test = true />
	</cfif>
	
	<cfif not args.password eq args.password2>
		<cfset passwordMessage = "&nbsp;&nbsp;Passwords did not match." />
		<cfset test = true />
	</cfif>
	
	<!--- it failed cause test is true --->
	<cfif test eq true>
		<cfset message = "Failed:" & usernameMessage & passwordMessage />
		<cfset arguments.event.setValue("message", message) />
		<!--- end method, forward --->
		<cfset arguments.event.forward("user.management", "message") />
	</cfif>
	
	<!--- this is the real loging security call --->
	<cfif beans.security.createUser(argumentCollection = args) eq 1>
		<cfset arguments.event.setValue("message", "User created successfully!") />
	<cfelse>
		<cfset arguments.event.setValue("message", "The Security service said this failed. Did you meet the minum password length, OR the username is not unique.") />
		<cfset arguments.event.forward("user.management", "message") />
	</cfif>
</cffunction>



<!--- deleteUser --->
<cffunction name="deleteUser" output="false">
	<cfargument name="event" />
	<cfset var x = "" />
	<cfloop list="#arguments.event.getValue("username")#" index="x">
		<cfset beans.security.deleteUser(x) />
	</cfloop>
</cffunction> 



<!--- listUsers --->
<cffunction name="listUsers" output="false">
	<cfargument name="event" />
	<cfset arguments.event.setValue("users", beans.security.listUser()) />
</cffunction>



<!--- getLog --->
<cffunction name="getLog" output="false">
	<cfargument name="event" />
	
	<cfset var logType = event.getValue("logType")/>
	<cfset var logFileName = event.getValue("logFileName")/>
	<cfset var log = arrayNew(1) />
	<cfset var logsPath =  "" />
	<cfset var x = 0 />
	<cfset var logEntry = "" />

	<!--- TODO: clean this up --->
	<!--- i suck, this isnt DRY!  :P rushing at the end --->
	<cfif 
	not Len(logType) 
	or lcase(logType) eq "figfactor" 
	and beans.Config.getEnableExternalLogger() eq true>
		
		<cfset logsPath = beans.Config.getLogsPath() />
		
		<!--- build an array of log Messages --->
		<cfloop file="#logsPath#" index="x">
			<cfset arrayAppend(log, replaceNoCase(x, "CFLog4j ", "", "all")) />
		</cfloop>
	
		<cfset arguments.event.setValue("logFileName", "cflog4j.log") />
		<cfset arguments.event.setValue("log", log) />
		<cfset arguments.event.setValue("displayAmount", 50) />

	<!--- we are going to read a commonspot log --->
	<cfelseif logType eq "commonspot" and len(logFileName)>
		<cfset logsPath = beans.config.getCommonspotPath() & "logs/#logFileName#" />
		<cfset log = parseCommonSpotLog(logsPath) />
		<cfset arguments.event.setValue("logFileName", logFileName) />	
		<cfset arguments.event.setValue("log", log) />
		<cfset arguments.event.setValue("displayAmount", 5) />
	<cfelseif logType eq "replication">
		<cfset logsPath = beans.config.getCommonspotPath() & "sync/logs/#logFileName#" />
		<cfset log = parseCommonSpotLog(logsPath) />
		<cfset arguments.event.setValue("logFileName", logFileName) />
		<cfset arguments.event.setValue("log", log) />
		<cfset arguments.event.setValue("displayAmount", 5) />
	</cfif>
	
	<cfset arguments.event.setValue("pagination", beans.Pagination) />
</cffunction> 



<!--- getCommonspotLogs --->
<cffunction name="getCommonspotLogs" output="false">
	<cfargument name="event" />
	
	<cfset var csLogs = "" />
	<cfset var thePath = beans.config.getCommonspotPath() />
	<cfset var logType = arguments.event.getValue("logType")>
	
	<cfif len(logType) and lcase(logType) eq "commonspot">
		<cfset thePath = thePath & "logs/">
	<cfelseif lcase(logType) eq "replication">
		<cfset thePath = thePath & "logs/sync/">
	</cfif>
	
	<cfdirectory action="list" directory="#thePath#" name="csLogs" />
	
	<cfset arguments.event.setValue("logs", csLogs) />
	<cfset arguments.event.setValue("logType", "commonspot")>
	<cfset arguments.event.setValue("pagination", beans.Pagination) />
	<cfset arguments.event.setValue("FigFactor", Application.FigFactor) />
</cffunction> 



<!---  getCustomElementXML --->
<cffunction name="getCustomElementXML" output="false">
	<cfargument name="event" type="any" />
</cffunction>



<!--- getFileMappings --->
<cffunction name="getFileMappings" output="false">
	<cfargument name="event" />
	<cfset arguments.event.setValue("fileMaps", beans.FileMapper.getMappingDefinitions()) />
</cffunction> 



<!--- loadBeanByName --->
<cffunction name="loadBeanByName" output="false">
	<cfargument name="event" />
	
	<cfset var beanIDs = arguments.event.getValue("BeanID") />
	<cfset var beanXML = 0/>
	<cfset var x = 0 />
	<cfset var fileData = 0 />
	<cfset var y = 0 />
	
	<!--- need to get this from the framework cause its allready abstracted out --->
	<cfset listBeans(arguments.event) />
	<cfset beanXML = arguments.event.getValue("beans")>
	
	<!--- make and array of beans to load --->
	<cfloop collection="#beanXML#" item="x">
		<cfset fileData  = beanXML[x].beans />
		<cfloop from="1" to="#arrayLen(fileData.XmlChildren)#" index="y">
			<cfif listContains(beanIDs, fileData.XmlChildren[y].XmlAttributes.id)>
		
				<cfset beans.FigFactor.getFactory().loadBeansFromXmlRaw(
					beanXML[x].beans.XmlChildren[y]) />
			</cfif>
		</cfloop>
	</cfloop>

	<cfif listLen(beanIDs) gt 1>
		<cfset message  = "The beans: <strong>#beanIDs#</strong> were loaded." />
	<cfelse>
		<cfset message  = "The bean: <strong>#beanIDs#</strong> was loaded." />
	</cfif>
	
	<cfset arguments.event.setValue("message", message) />
	<cfset arguments.event.setValue("loadedBeans", beanIDs) />
</cffunction> 



<!--- loadFileMapping --->
<cffunction name="loadFileMapping" output="false">
	<cfargument name="event" />

	<cfset var map = beans.FIleMapper.getMap(event.getValue("map")) />
	<cfset var message = "" />

	<cfif map.deploy() eq true>
		<cfset message ="The map #map.getMapName()# was deployed!" />
	<cfelse>
		<cfset message ="The map #map.getMapName()# was NOT deployed. :(" />
	</cfif>

	<cfset arguments.event.setValue("message", message) />
</cffunction> 



<!--- onQueueComplete --->
<cffunction name="onQueueComplete" access="public" returnType="void" output="false">
	<cfargument name="event" type="any" />
	<cfset arguments.event.setValue("AdminConfig", beans.AdminConfig) />
	<cfset arguments.event.setValue("Config", beans.Config) />
	<cfset arguments.event.setValue("Logger", beans.Logger) />
	<cfset arguments.event.setValue("thePath", beans.Config.getFigLeafFileContext() & "/admin/") />
	<cfset arguments.event.setValue("DataService", beans.DataService) />
	<cfset arguments.event.setValue("jquey", "ui/js/jquery-ui-1.7.1.custom/") />
</cffunction>



<!--- onRequestEnd --->
<cffunction name="onRequestEnd" access="public" returnType="void" output="false">
	<cfargument name="event" type="any" />
</cffunction>



<!--- parseCommonSpotLog --->
<cffunction name="parseCommonSpotLog" returntype="any" access="public" output="false">
    
	<cfargument name="logsPath" hint="I am the absolute file path to the CommonSpot log File" />
	
	<cfset var log = arrayNew(1) />
	<cfset var startEntry = "" />
	<cfset var logEntry = "" />
	
	<!--- all the logic here is to split apart and format the HTML in the array --->
	<cfloop file="#logsPath#" index="x">
		<cfset startEntry = true>
		<!--- TODO: use the Date Time with all these ----- for the string check --->
		<!--- don't laugh, it's working 96% of the time' --->
		<cfif trim(x) contains "--------------------------------------------------------------------------------" and startEntry eq true and len(logEntry)>
			<cfif logEntry neq "<br />">
				<cfset arrayAppend(log, replace(logEntry, "<br /><br />", "", "all")) />
			</cfif>
			<cfset startEntry = true />
		<cfelse>
				<cfset logEntry = logEntry & "<br />" & x>
		</cfif>
	</cfloop>
	
	<cfreturn log />
</cffunction>
</cfcomponent>