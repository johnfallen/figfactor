<cfset myself = event.getValue("myself") />
<cfset users = event.getValue("users") />
<cfset xe.addUser = event.getValue("xe.addUser") />
<cfset xe.deleteUser = event.getValue("xe.deleteUser") />
<cfset message = event.getValue("message") />

<cfsavecontent variable="thisJS">
<cfoutput>
<script type="text/javascript">
	$(function() {
		$("##tabs").tabs();
	});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#thisJS#" />

<cfoutput>
<h3>User Management</h3>

<cfif len(message)>
	<div class="message">#message#</div>
</cfif>

<div class="demo">
<div id="tabs">
	<ul>
		<li><a href="##tabs-1">Manage Users</a></li>
		<li><a href="##tabs-2">Add User</a></li>
	</ul>
	<div id="tabs-1">
		<form action="#myself##xe.deleteUser#" method="post" id="deleteUserForm">
			<table border="1">
				<tr>
					<th>click to delete</th>
					<th>Date Created</th>
				</tr>
				<cfloop array="#users#" index="x">
					<tr valign="top">
						<td><input type="checkbox" name="username" value="#x.USERNAME#"></td>
						<td>#x.dateCreated#</td>
					</tr>
				</cfloop>
			</table>
			<input type="submit" value="Delete Users" />
		</form>
	</div>
	<div id="tabs-2">
		<form action="<cfoutput>#myself##xe.addUser#</cfoutput>" method="post" id="addUserForm">
			username:<br />
			<input type="text" name="username" /><br />
			confirm username:<br />
			<input type="text" name="username2" /><br />
			password:<br />
			<input type="password" name="password" /><br />
			password confirm:<br />
			<input type="password" name="password2" /><br />
			<input type="submit" value="Add User" />
		</form>
	</div>
</div>
</div>
</cfoutput>
