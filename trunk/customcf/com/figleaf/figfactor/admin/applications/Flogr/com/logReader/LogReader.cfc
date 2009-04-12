<cfcomponent displayname="Log Reader Service" hint="I am the log reader servcie." output="false">
	
	<cfscript>
		variables.logDir = "";
		variables.defaultListVals = QueryNew('label,data,numData');
	</cfscript>

	<cffunction name="init" displayname="Init" hint="I initialize the Log Reader Service" access="public" output="true" returntype="Any">
		<cfargument name="logDir" type="string" required="true" />
		<cfscript>
			setLogDir(arguments.logDir);
			setDefaultListVals();
		</cfscript>
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setLogDir" access="private" returntype="void" output="false">
		<cfargument name="logDir" type="string" required="true">
		<cfset variables.logDir = arguments.logDir >
	</cffunction>
	
	<cffunction name="getLogDir" access="public" returntype="string" output="false">
		<cfreturn variables.logDir />
	</cffunction>
	
	<cffunction name="setDefaultListVals" access="private" returntype="void" output="false">
		<cfset QueryAddRow(variables.defaultListVals) />
		<cfset QuerySetCell(variables.defaultListVals,'label','All') />
		<cfset QuerySetCell(variables.defaultListVals,'data','') />
		<cfset QuerySetCell(variables.defaultListVals,'numdata',0) />
	</cffunction>
	
	<cffunction name="getLogs" access="public" output="false" returntype="array">
		<cfscript>
			var qLogs = "";
			var stLog = "";
			var aLogs = ArrayNew(1);
		</cfscript>
		<cfdirectory name="qLogs" action="list" directory="#getlogDir()#" filter="*.log" sort="name ASC"/>
		<cfloop query="qLogs">
			<cfscript>
				stLog = structNew();
				stLog["name"] = qLogs.name;
				stLog["size"] = qLogs.size;
			</cfscript>			
			<cfset arrayAppend(aLogs,stLog)>
		</cfloop>
		<cfreturn aLogs />
	</cffunction>
	
	<cffunction name="getLogData" access="public" output="false" returntype="array">
		<cfargument name="logName" required="true" type="string" />
		<cfscript>
			var aData = ArrayNew(1);
			var logData = "";
			var columnList = "";
			var lineNum = 1;
			var curLine = "";
			var needFilterData = false;
			var logDate = "";
			var q = "";
		</cfscript>
		<cfloop file="#getLogDir()#/#arguments.logName#" index="curLine">
			<cfscript>
				if(lineNum EQ 1){
					if(listFirst(curLine) EQ '"Severity"'){
						curLine = RePlace(curLine,'"','','ALL');
						columnList = curLine;
						needFilterData = true;
					}
					else{
						columnList = 'Message';
					}
					
					logData = queryNew(columnList);
					
				}
				else{
					if(needFilterData){
						curLine = Replace(curLine,",,",',"",',"ALL");
						curLine = Replace(curLine,'","',' #chr(2710)# ',"ALL");
						logDate = CreateODBCDateTime(Replace(ListGetAt(curLine,3,chr(2710)),'"','','ALL')&' '&Replace(ListGetAt(curLine,4,chr(2710)),'"','','ALL'));
						queryAddRow(logData);
						querySetCell(logData,"date",logDate);
						querySetCell(logData,'severity',Trim(Replace(ListGetAt(curLine,1,chr(2710)),'"','','ALL')));
						querySetCell(logData,'threadid',Trim(Replace(ListGetAt(curLine,2,chr(2710)),'"','','ALL')));
						querySetCell(logData,'application',Trim(Replace(ListGetAt(curLine,5,chr(2710)),'"','','ALL')));
						querySetCell(logData,'message',Trim(Replace(Replace(Replace(Replace(ListGetAt(curLine,6,chr(2710)),'"','','ALL'),"<","&lt;","ALL"),">","&gt;","ALL"),chr(9)," ","ALL")));
											
					}
					else{
						queryAddRow(logData);
						querySetCell(logData,"message",curLine);					
						}
				}
				
				lineNum++;
			</cfscript>
		</cfloop>
		<cfif needFilterData>
			<cfquery name="q" dbtype="query">
			SELECT * FROM logData ORDER BY [date] DESC
			</cfquery>
			<cfset aData[1] = queryToArray (q) />
			<cfset aData[2] = getList("application", logdata) />
			<cfset aData[3] = getList("severity", logdata) />
			<cfset aData[4] = getList("threadid", logdata) />
			<cfelse>
			<cfset aData[1] = queryToarray( logData ) />			
		</cfif>
		<cfreturn aData />
	</cffunction>
	
	<cffunction name="getList" output="false" access="private" returntype="array">
		<cfargument name="item" required="yes" type="string" />
		<cfargument name="logData" required="yes" type="query" />
		<cfset var qApps = '' />
    	<cfset var curLog = arguments.logData />
		<cfquery name="qApps" dbtype="query">
			SELECT label,data
			FROM variables.defaultListVals
			UNION
			SELECT DISTINCT #arguments.item# AS label, #arguments.item# AS data
			FROM curLog
			WHERE #arguments.item# <> ''
			ORDER BY data
		</cfquery>

		<cfreturn queryToArray ( qApps ) />
	</cffunction>
	
	<cffunction name="queryToArray" access="private" output="false" returntype="array"
		hint="Converts a query recordset to an array of structures" >

		<cfargument name="query" type="query" required="true" hint="Query recordset to convert" />

		<!--- setup the array container --->
		<cfset var array = arrayNew(1) />
		<cfset var struct = structNew() />
		<cfset var col = "" />

		<!--- if the query contains records --->
 		<cfif arguments.query.recordCount >

  			<!--- loop through the records --->
			<cfloop query="arguments.query" >

				<!--- setup a temporary structure to store the record data --->
				<cfset struct = structNew() />

				<!--- loop through the column list, inserting each column and data into the structure --->
				<cfloop list="#lcase( arguments.query.columnlist )#" index="col" >
					<cfset struct[ col ] = arguments.query[ col ][ currentRow ] />
				</cfloop>

				<!--- insert the structure into the array --->
				<cfset arrayAppend( array, struct ) />

			</cfloop>

		</cfif> <!--- end: if the query contains records --->

		<!--- return the array --->
		<cfreturn array />
	</cffunction>  
	
	
	
	<!--- TODO: Remove _dump --->
	<cffunction name="_dump">
		<cfargument name="toDump" />
		
		<cfdump var="#arguments.toDump#"><cfabort>
	</cffunction>
</cfcomponent>