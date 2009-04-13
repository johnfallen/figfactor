<cfset path = Application.FigFactor.getBean("config").getWebPathToAdmin() /><cfoutput><html>
<head>
<title>FigFactor Adminstration !!</title>
<link type="text/css" href="#path#ui/js/jquery-ui-1.7.1.custom/development-bundle/themes/base/ui.all.css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="#path#ui/js/superfish-1.4.8/css/superfish.css" media="screen" />
<link rel="stylesheet" type="text/css" href="#path#ui/pagination/gray.css" media="screen" />
<script type="text/javascript" src="#path#ui/js/jquery-ui-1.7.1.custom/development-bundle/jquery-1.3.2.js"></script>
<script type="text/javascript" src="#path#ui/js/jquery-ui-1.7.1.custom/development-bundle/ui/ui.core.js"></script>
<script type="text/javascript" src="#path#ui/js/jquery-ui-1.7.1.custom/development-bundle/ui/ui.tabs.js"></script>
<script type="text/javascript" src="#path#ui/js/jquery-ui-1.7.1.custom/development-bundle/ui/ui.accordion.js"></script>
<script type="text/javascript" src="#path#ui/js/superfish-1.4.8/js/hoverIntent.js"></script>
<script type="text/javascript" src="#path#ui/js/superfish-1.4.8/js/superfish.js"></script>
<link type="text/css" href="#path#ui/js/jquery-ui-1.7.1.custom/development-bundle/demos/demos.css" rel="stylesheet" />
<script type="text/javascript" src="#path#ui/js/superfish-1.4.8/js/hoverIntent.js"></script>
<script type="text/javascript" src="#path#ui/js/superfish-1.4.8/js/superfish.js"></script>
<style>
body {
	font-family:verdana; 
	font-size:1em; 
	background-color:##efefef;
	font-family: "Trebuchet MS", verdana, arial, sans-serif; 
	}
.borders {
	border:solid 1px gray;
	border-right:solid 2px black;
	border-bottom:solid 2px black;
	}
##pageFrame {
	display:table-cell;
	border:solid 1px silver;
	border-right:solid 2px black;
	border-bottom:solid 2px black;
	min-width:900px; 
	padding:10px;
	background-color:##fff;
	}
##menu  {
	width:100%;
	font-size:.65em;
	margin-bottom:20px;
	font-family:verdana;
	font-weight:bold;
	}
##content {
	background-color:##fff; 
	padding:4px;
	}
##tabs {
	font-size:.65em;
	font-family: "verdana; 
	}
##tabs, ##accordion {
	margin-left:-15px;
	}
##tabs .info	{
	font-color:gray;
	}
h1, h2, h3 {
	text-align:left; border-top:solid 1px white;
	}
.ini fieldset {
	border:solid 1px black;
	background-color:##f7f7f7;
	}
.ini input {
	font-size:.90em;
	background-color:##fff;
	}
.mapTitle {
	font-size:.75em;
	font-weight:bold;
	}
.mapping  {
	font-size:.70em;
	}
.mapTitle span {
	font-size;.80em;
	display:block;
	float:right;
	clear:left;
	}
.mapActions {
	padding:4px 4px 4px 0px;
	float:right;
	}
.mapActions a {
	border:solid 1px gray;
	background-color:##0f0;
	color:##000;
	padding:3px;
	font-weight:bold;
	}
.mapActions a:hover {
	background-color:##f0f;
	}
.sourceDestination {
	padding:4px;
	margin-bottom:4px;
	margin-top:4px;
	}
.dataTable {
	font-size:.90em;
	width:100%;
	}
.logEntry {
	padding:4px;
	}
.lightBorder {
	border:dotted 1px ##ccc;
	}
##header {
	float:right;
	font-size:1.4em;
	color:##f0f;
	font-family: "Trebuchet MS", verdana, arial, sans-serif;
	border:solid 1px silver;
	border-right:solid 2px silver;
	border-bottom:solid 2px silver;
	padding:2px 10px 4px 30px;
	background-color:##000; 
	font-style:italic;
	text-align:right;
	}
.small {
	font-size:90%;
	}
.small u 
	{color:##fff;}
##listTable {
	font-size:.65em;
	font-family:verdana;
	}
##listTable th {
	text-align:left;
	background-color:##000;
	color:##fff;
	}
##listTable tr {
	background-color:##efefef;
	}
</style>
<script type="text/javascript">
jQuery(function(){
	jQuery('ul.sf-menu').superfish();
});
</script>
</head>
<body>
<div id="pageFrame">
	<div id="menu">
		<div id="header">
			FigFactor<br />
			<span class="small">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...cool<br />
				Logged in? <u>#session.AllowExternalApplicationManagement#</u>
			</span>
		</div>
		<cfoutput>#viewcollection.getView("menu")#</cfoutput>
	</div>
	<br />
	<div id="contentFrame">
		<div id="content">
			<cfoutput>#viewcollection.getView("body")#</cfoutput>
		</div>
	</div>
</div>
</body>
</html>
</cfoutput>