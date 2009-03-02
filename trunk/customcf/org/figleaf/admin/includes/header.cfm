<cfsilent><!--- Document Information -----------------------------------------------------
Title: 				header.cfm
Author:				John Allen
Email:					jallen@figleaf.com
Company:			Figleaf Software
Website:			http://www.nist.gov
Purpose:			I am the header file include for the Fig Leaf System 
						admininstration interface.
================================================================================
John Allen		30/08/2008		Created
------------------------------------------------------------------------------->
</cfsilent>


<!--- ************ Display ************ --->

<cfoutput><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Fig Leaf System Manager</title>
	<script src="#config.getFigLeafFileContext()#/admin/js/jquery-1.2.6.min.js" type="text/javascript"></script>
	<link href="#config.getFigLeafFileContext()#/admin/css/style.css" rel="stylesheet" type="text/css" />
</head>
<body><a name="top" id="top"></a></cfoutput>