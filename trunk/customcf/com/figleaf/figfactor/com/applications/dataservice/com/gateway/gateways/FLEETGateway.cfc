<!--- Document Information -----------------------------------------------------
Build:      			@@@revision-number@@@
Title:      			FLEETGateway.cfc
Author:     			John Allen
Email:      			jallen@figleaf.com
Company:   	 	@@@company-name@@@
Website:    		@@@web-site@@@
Purpose:    
Modification Log:
Name	 		Date	 			Description
================================================================================
John Allen	 07/06/2008	 Created
------------------------------------------------------------------------------->
<cfcomponent displayname="FLEET Gateway" hint="I am the FLEET Gateway" output="false">

<!--- *********** Public ************ --->

<!--- init --->
<cffunction name="init" returntype="FLEETGateway" access="public" output="false" 
	displayname="Init" hint="I am the constructor." 
	description="I am the pseudo constructor for this CFC. I return an instance of myself.">

	<cfreturn this />
</cffunction>


<!--- getFakeMetaData --->
<cffunction name="getFakeMetaData" returntype="any" access="public" output="false" 
	displayname="Get Fake Meta Data Query" hint="I return a query of generated query data. I am used for development." 
	description="I return a query that should 'look' like what is comming from the remote meta data provider. I am used for development." >
	
	<cfargument name="BeanFactory" default="#Application.FigFactor.getFactory()#" />
	<cfset var udf = arguments.BeanFactory.getBean("udf") />

	<cfset var FLEETData = variables.Utilities.querySim('
itemid , ParentID , keyword
1 | 0 | North America
2 | 1 | Canada
3 | 1 | United States
4 | 1 | Mexico

5 | 0 | South America
6 | 5 | Columbia
7 | 5 | Brazil
8 | 5 | Argentina
9 | 5 | Peru

10 | 0 | Europe
11 | 10 | England
12 | 10 | France
13 | 10 | Irland
14 | 10 | Italy
15 | 10 | Germany
16 | 10 | Spain
17 | 10 | Poland

18 | 0 | Asia
19 | 18 | Russia
20 | 18 | China
21 | 18 | Usbeckistan
22 | 18 | Afghanistan
23 | 18 | Pakistan
24 | 18 | Terkmenistan
25 | 18 | Azerbijan
	
26 | 3 | NC
27 | 3 | CA
28 | 3 | SC
29 | 3 | OH
30 | 3 | FL
31 | 3 | MD
32 | 31 | Gathersburg
33 | 31 | Baltimore
34 | 31 | Sutland
') />
	
	<cfreturn udf.queryTreeSort(FLEETData) />
</cffunction>



<!--- *********** Package *********** --->
<!--- *********** Private *********** --->
</cfcomponent>