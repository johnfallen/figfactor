<cfset s = createObject("component", "Security").init() />
<cfdump var="#s#">
<!--- ******************************************************** --->
<h2>Admin Login and Out Test</h2>
<li><a href="test.cfm?login=true&name=user1&password=password">Login as User 1 (username:user1, password:password)</a></li>
<li><a href="test.cfm?login=true&name=admin&password=admin">Login as Admin</a></li>
<cfif isDefined("url.login")>
	<cfset test = s.userLogin(username = "#url.name#", password = "#url.password#") />
	Result: <cfdump var="#test#" />
</cfif>
<hr />
<!--- ******************************************************** --->
<h2>Create New User </h2>
	<cfif not isDefined("url.createUser") and not isDefined("url.doCreateUser")>
		<a href="test.cfm?createUser=true">Click to perform</a>
	</cfif>
<cfif isDefined("url.createUser")>
	<!--- login --->
	<cfset s.userLogin("admin", "admin") />
	Create:
	<form method="get" action="test.cfm">
		<input type="hidden" name="doCreateUser">
		<select name="name" id="name">
			<option>user1</option>
			<option>name</option>
			<option>figleaf</option>
		</select>
		<input type="submit" value="create!">
	</form>
</cfif>
	<cfif isDefined("url.doCreateUser")>
		<cfset test = s.userLogin(username = "admin", password = "admin") />
		Creating USER: <cfoutput>#url.name#</cfoutput><br />
		<cfif url.name eq "user1">
			<cfset test = s.createUser("user1", "user1", "password", "password") />
		<cfelse>
			<cfset test = s.createUser("#url.name#", "#url.name#", "#url.name#", "#url.name#") />
		</cfif>
		Result: <cfdump var="#test#" />
		<cfset s.UserLogout()>
		
		<h3>Test New User Login</h3>
		<cfif url.name eq "user1">
			<cfset test = s.userLogin("user1", "password") />
		<cfelse>
		<cfset test = s.userLogin("#url.name#", "#url.name#") />
		</cfif>
		Result: <cfdump var="#test#">
		<cfset s.UserLogout() />
		<br />
		<a href="test.cfm">Back to normal</a>
</cfif>
<hr />
<!--- ******************************************************** --->
<h2>Delete Users</h2>
	<cfif not isDefined("url.deleteUser") and not isDefined("url.doDeleteUser")>
		<a href="test.cfm?deleteUser=true">Click to perform</a>
	</cfif>
<cfif isDefined("url.deleteUser")>
	<!--- login --->
	<cfset s.userLogin("admin", "admin") />
	Delete:
	<form method="get" action="test.cfm">
		<input type="hidden" name="doDeleteUser">
		<select name="name" id="name">
			<option>user1</option>
			<option>name</option>
			<option>figleaf</option>
		</select>
		<input type="submit" value="Delete!">
	</form>
</cfif>
	<cfif isDefined("url.doDeleteUser")>
		<cfset test = s.userLogin(username = "admin", password = "admin") />
		Deleting USER: <cfoutput>#url.name#</cfoutput><br />
		<cfset test = s.deleteUser("#url.name#") />
		Result: <cfdump var="#test#" />
		<cfset s.UserLogout()>
		<br />
		<a href="test.cfm">Back to normal</a>
</cfif>
<hr />
<!--- ******************************************************** --->
<h2>Log All Users In:</h2>
<cfset test = s.UserLogin("admin", "admin") />
Admin: <cfdump var="#test#" /><br />
<cfset s.UserLogout() />
<cfset test = s.UserLogin("figleaf", "figleaf") />
figleaf: <cfdump var="#test#" /><br />
<cfset s.UserLogout() />
<cfset test = s.UserLogin("name", "name") />
name: <cfdump var="#test#" /><br />
<cfset s.UserLogout() />
<hr />
<!--- ******************************************************** --->
<h2>User List</h2>
<cfif isDefined("url.listUser")>
	<cfset test = s.userLogin(username = "admin", password = "admin") />
	<cfset list = s.listUser() />
	<cfdump var="#list#">
<cfelse>
	<a href="test.cfm?listUser=true">List Users</a>
</cfif>
<hr />








