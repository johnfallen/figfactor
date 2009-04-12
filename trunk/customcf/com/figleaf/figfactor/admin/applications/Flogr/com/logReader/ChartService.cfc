<cfcomponent displayname="Chart Service" hint="I am the chart service" output="false">

	<cfscript>
		variables._dsn = "";
	</cfscript>
	
	<cffunction name="init" access="package" output="false" returntype="any">
		<cfargument name="dsn" type="string" required="true" />
		<cfscript>
			setDsn(arguments.dsn);
			return this;
		</cfscript>		
		
	</cffunction>

	<cffunction name="getDsn" access="public" output="false" returntype="string">
		<cfreturn variables._dsn />
	</cffunction>

	<cffunction name="setDsn" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables._dsn = arguments.dsn />
	</cffunction>
	
	<cffunction name="getChartLogList" output="false" returntype="query" access="package">
		<cfset var logsForCharting = '' />						
		<cfquery name="logsForCharting" datasource="#getDatasource()#">
			SELECT 0 as data,' All ' as label
			UNION
			SELECT logID as data,logName AS label
			FROM logWatcherLogs
			ORDER BY label
		</cfquery>
		<cfreturn logsForCharting />
	</cffunction>
	
	<cffunction name="getAllCharts" output="false" returntype="array" access="package">
		<cfargument name="logFile" type="numeric" required="false" default="0" />
		<cfset var aChartData = ArrayNew(1) />
		<cfset ArrayAppend(aChartData,getLogAggs(logFile=arguments.logfile)) />
		<cfset ArrayAppend(aChartData,getApplicationAggs(logFile=arguments.logfile)) />
		<cfset ArrayAppend(aChartData,getPageAggs(logFile=arguments.logfile)) />
		<cfset ArrayAppend(aChartData,getSeverityAggs(logFile=arguments.logfile)) />
		<cfset ArrayAppend(aChartData,getThreadAggs(logFile=arguments.logfile))/>
		<cfset ArrayAppend(aChartData,getYearAggs(logFile=arguments.logfile))/>
		<cfset ArrayAppend(aChartData,getMonthAggs(logFile=arguments.logfile))/>
		<cfset ArrayAppend(aChartData,getDateAggs(logFile=arguments.logfile))/>
		<cfset ArrayAppend(aChartData,getWeekdayAggs(logFile=arguments.logfile))/>
		<cfset ArrayAppend(aChartData,getHourAggs(logFile=arguments.logfile))/>
		<cfset ArrayAppend(aChartData,getQuarterAggs(logFile=arguments.logfile))/>
		<cfreturn aChartData />
	</cffunction>
	
	<cffunction name="getLogAggs" access="private" output="false" returntype="query">
		<cfargument name="logFile" required="yes" type="numeric" />
		<cfset var getLogs = '' />
		<cfquery name="getLogs" datasource="#getDsn()#">
			SELECT logName AS serieslabel,hitcount
			FROM logWatcherLogs
		</cfquery>
		<cfreturn getLogs />
	</cffunction>
	
	<cffunction name="getApplicationAggs" access="private" output="false" returntype="query">
		<cfargument name="logFile" required="yes" type="numeric" />
		<cfset var getApplication = '' />
		<cfquery name="getApplication" datasource="#getDsn()#">
			SELECT DISTINCT application as serieslabel,SUM(hitCount) as hitcount
			FROM logWatcherApplication
			<cfif arguments.logFile GT 0>
				WHERE logid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.logFile#" />
			</cfif>
			GROUP BY application
		</cfquery>	
		<cfreturn getApplication />
	</cffunction>
	
	<cffunction name="getPageAggs" access="private" output="false" returntype="query">
		<cfargument name="logFile" required="yes" type="numeric" />
		<cfset var getPage = '' />
		<cfquery name="getPage" datasource="#getDsn()#">
			SELECT DISTINCT page as serieslabel,SUM(hitCount) as hitcount
			FROM logWatcherPage
			<cfif arguments.logFile GT 0>
				WHERE logid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.logFile#" />
			</cfif>
			GROUP BY page
		</cfquery>
		<cfreturn getPage />
	</cffunction>
	
	<cffunction name="getSeverityAggs" access="private" output="false" returntype="query">
		<cfargument name="logFile" required="yes" type="numeric" />
		<cfset var getSeverity = '' />
		<cfquery name="getSeverity" datasource="#getDsn()#">
			SELECT DISTINCT severity as serieslabel,SUM(hitCount) as hitcount
			FROM logWatcherSeverity
			<cfif arguments.logFile GT 0>
				WHERE logid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.logFile#" />
			</cfif>
			GROUP BY severity
		</cfquery>
		<cfreturn getSeverity />
	</cffunction>
	
	<cffunction name="getThreadAggs" access="private" output="false" returntype="query">
		<cfargument name="logFile" required="yes" type="numeric" />
		<cfset var getThread = '' />
		<cfquery name="getThread" datasource="#getDsn()#">
			SELECT DISTINCT thread as serieslabel,SUM(hitCount) as hitcount
			FROM logWatcherThread
			<cfif arguments.logFile GT 0>
				WHERE logid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.logFile#" />
			</cfif>
			GROUP BY thread
		</cfquery>
		<cfreturn getThread /> 
	</cffunction>
	
		<cffunction name="getYearAggs" access="private" output="false" returntype="query">
		<cfargument name="logFile" required="yes" type="numeric" />
		<cfset var getYear = '' />
		<cfquery name="getYear" datasource="#getDsn()#">
			SELECT DISTINCT Year(ld.date) as serieslabel,SUM(hitcount) hitcount
			FROM logWatcherDate ld

			<cfif arguments.logFile GT 0>
				WHERE ld.logid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.logFile#" />
			</cfif>
			GROUP BY Year(ld.date)
			ORDER BY Year(ld.date)
		</cfquery>
		<cfreturn getYear /> 
	</cffunction>
	
	<cffunction name="getMonthAggs" access="private" output="false" returntype="query">
		<cfargument name="logFile" required="yes" type="numeric" />
		<cfset var getMonth = '' />
		<cfquery name="getMonth" datasource="#getDsn()#" maxrows="12">
			SELECT i.item,i.month serieslabel,
			CASE WHEN SUM(l.hitcount) IS NULL THEN 0
			ELSE SUM(l.hitcount)
			END AS hitcount
			FROM itemCount i
			LEFT OUTER JOIN logWatcherDate l ON i.item = Month(l.date)
			<cfif arguments.logFile GT 0>
				AND l.logid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.logFile#" />
			</cfif>
			GROUP BY i.item,i.month
			ORDER BY i.item
		</cfquery>
		<cfreturn getMonth /> 
	</cffunction>
	
	<cffunction name="getDateAggs" access="private" output="false" returntype="query">
		<cfargument name="logFile" required="yes" type="numeric" />
		<cfset var getDate = '' />
		<cfquery name="getDate" datasource="#getDsn()#" maxrows="31">
			SELECT i.item as logdate,
			i.item serieslabel,
			CASE WHEN SUM(l.hitcount) IS NULL THEN 0
			ELSE SUM(l.hitcount)
			END hitcount
			FROM itemcount i
			LEFT OUTER JOIN logWatcherDate l on i.item = Day(l.date)
			<cfif arguments.logFile GT 0>
				AND l.logid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.logFile#" />
			</cfif>
			GROUP BY i.item
			ORDER BY logdate
		</cfquery>
		<cfreturn getDate /> 
	</cffunction>
	
	<cffunction name="getWeekdayAggs" access="private" output="false" returntype="query">
		<cfargument name="logFile" required="yes" type="numeric" />
		<cfset var getWeekday = '' />
		<cfquery name="getWeekday" datasource="#getDsn()#" maxrows="7">
			SELECT i.item,i.weekday serieslabel,
			CASE WHEN SUM(l.hitcount) IS NULL THEN 0
			ELSE SUM(l.hitcount)
			END AS hitcount
			FROM itemCount i
			LEFT OUTER JOIN logWatcherDate l ON i.item = DATEPART('dw',l.date)
			<cfif arguments.logFile GT 0>
				AND l.logid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.logFile#" />
			</cfif>
			GROUP BY i.item,i.weekday
			ORDER BY i.item
		</cfquery>
		<cfreturn getWeekday /> 
	</cffunction>
	
	<cffunction name="getHourAggs" access="private" output="false" returntype="query">
		<cfargument name="logFile" required="yes" type="numeric" />
		<cfset var getHour = '' />
		<cfquery name="getHour" datasource="#getDsn()#" maxrows="24">
			SELECT i.item-1 as loghour,
			CASE WHEN i.item-1 = 0 THEN '12:00 AM'
			WHEN i.item-1 < 12 THEN CAST(i.item-1 AS VARCHAR(2))+':00 AM'
			WHEN i.item-1 = 12 THEN '12:00 PM'
			ELSE CAST(i.item-13 AS VARCHAR(2))+':00 PM'
			END  serieslabel,
			CASE WHEN SUM(l.hitcount) IS NULL THEN 0
			ELSE SUM(l.hitcount)
			END hitcount
			FROM itemcount i
			LEFT OUTER JOIN logWatcherDate l on i.item-1 = HOUR(l.date)
			<cfif arguments.logFile GT 0>
				AND l.logid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.logFile#" />
			</cfif>
			GROUP BY CAST(i.item-1 as varchar(2))+':00',DATEPART(HH,L.DATE),I.ITEM
			ORDER BY loghour
		</cfquery>
		<cfreturn getHour /> 
	</cffunction>
	
	<cffunction name="getQuarterAggs" access="private" output="false" returntype="query">
		<cfargument name="logFile" required="yes" type="numeric" />
		<cfset var getQuarter = '' />
		<cfquery name="getQuarter" datasource="#getDsn()#" maxrows="4">
			SELECT i.item as logdate,
			i.item serieslabel,
			CASE WHEN SUM(l.hitcount) IS NULL THEN 0
			ELSE SUM(l.hitcount)
			END hitcount
			FROM itemcount i
			LEFT OUTER JOIN logWatcherDate l on i.item = DATEPART(q,l.date)
			<cfif arguments.logFile GT 0>
				AND l.logid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.logFile#" />
			</cfif>
			GROUP BY i.item
			ORDER BY logdate
		</cfquery>
		<cfreturn getQuarter /> 
	</cffunction>
</cfcomponent>