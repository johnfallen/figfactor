<cfsilent>
	<!--- objects/data --->
	<cfset rb = event.getValue("rb")>
	<cfset config = event.getValue("config") />
	<cfset jsPath = config.getDefaultUIPath() />
	<cfset xe.browseMedia = event.getValue("xe.browseMedia")>
</cfsilent>
<cfajaximport tags="cfform,cftextarea" />
<cfcontent reset="true"/><cfinclude template="inc_xhtml_header.cfm" /><cfoutput>
<title>#rb.getResource("MultiMedia")#</title>
<script type="text/javascript" language="javascript" src="#jsPath#/jquery-1.2.6.js"></script>
<cfinclude template="inc_styles.cfm" />
</head>
<body>
<div id="pageWrapper">
	<div id="pageContainer">
		<div id="headerWrapper">
			<div id="headerContainer">#viewCollection.getView("navigation")#</div>
		</div>
		<div id="bodyWrapper">
			<div id="boddyContainer">#viewCollection.getView("body")#</div>
		</div>
	</div>
</div>
</body>
</html></cfoutput>