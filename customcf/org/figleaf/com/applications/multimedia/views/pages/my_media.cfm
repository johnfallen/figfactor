<cfsilent>
	<!--- objects/data --->
	<cfset types = event.getValue("types")>
	<cfset user = event.getValue("user") />
	<cfset rb = event.getValue("rb") />
	<cfset type = event.getValue("type") />
	
	<!--- links --->
	<cfset myself = event.getValue("myself") />
	<cfset xe.editMedia = event.getValue("xe.editMedia") />
	<cfset bind.link = event.getValue("bind.link") />
</cfsilent>
<cfoutput><h4>#rb.getResource("CreateNewMedia")#</h4></cfoutput>
<table>
	<tr>
		<td>
		<!--- Search and Grid --->
			<cfform 
				name="MyMediaGridForm"
				id="MyMediaGridForm">
			
				<cfinput 
					type="hidden"
					id="localUserID" 
					name="localUserID" 
					value="#user.getIDUser()#">

			 	<cfgrid 
					format="html" 
					name="MyMediaGrid" 
					pagesize="10"
					appendKey="yes"
					bind="cfc:#bind.link#({cfgridpage},{cfgridpagesize},{cfgridsortcolumn},{cfgridsortdirection}, getUserID())">
					
					<cfgridcolumn 
						name="IDMedia" 
						display="false" />
					
					<cfgridcolumn 
						name="IDType" 
						display="false" />
					
					<cfgridcolumn 
						name="Title" 
						header="#rb.getResource("Title")#" 
						width="270" />
					
					<cfgridcolumn 
						name="Type" 
						header="#rb.getResource("Type")#"
						href="#myself##xe.editMedia#"/>
				
				</cfgrid>
			</cfform>
		</td>
		<td>
			<ul>
			<cfoutput query="types">
				<li><a href="#myself##xe.editMedia#&IDType=#IDType#">#rb.getResource("New")# #Name#</a></li>
			</cfoutput>
			</ul>		
		</td>
	</tr>
</table>

<script type="text/javascript">
	<!--- user id for myMedia grid --->
	getUserID = function() {
	   var s = ColdFusion.getElementValue('localUserID');
	   return s;
	}
</script>