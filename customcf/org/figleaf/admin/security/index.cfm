<cfsilent>
	<cfset security = createObject("component", "Security").init() />
	<cfset myself = "index.cfm?event=" />
	<cfset isLoggedIn = session.figFactorAdminLogin />

	<cfparam name="displayUpdate" default="false" />
	<cfparam name="message" default="Log In" />
	<cfparam name="action" default="#myself#user.login" />
	<cfparam name="loginButtonText" default="Log In" />
	<cfparam name="pageTitle" default="Login" />
	<cfparam name="url.event" default="" />
	<cfparam name="result.message" default="" />
	<cfparam name="form.password" default="" />
	<cfparam name="form.password1" default="" />
	<cfparam name="form.password2" default="" />
	

	<!--- override if updating the password --->
	<cfif url.event eq "update.password">
		<cfset displayUpdate = true />
		<cfset action = "#myself#update.password" />
		<cfset message = "Update Admin Password" />
		<cfset loginButtonText = "Update" />
		<cfset pageTitle = "Update Admin Password" />
	</cfif>
	
	<cfif url.event eq "user.login">
		<cfset test = security.userLogin(form.password) />
	</cfif>
	

	
	<cfif not structKeyExists(url, "event")>
		<cfset url.event = "user.login" />
	</cfif>
</cfsilent>

<cfoutput>
	
<cfdump var="#security.userLogin("john")#">
	
<html>
<head>
	<title>#pageTitle#</title>
</head>
<body>
	<div style="height:300px;">
	<cfform action="#action#" method="post" format="flash">
		<cfformgroup type="panel" label="#message#" width="450">

			<cfformitem type="html" style="font-weight:bold;">
				&nbsp;#result.message#&nbsp;
			</cfformitem>
			
			<cfformgroup type="vertical">
				<cfinput 
					type="text" 
					name="password" 
					label="Password" 
					tooltip="Enter the current password." 
					width="200" 
					required="true" 
					message="You must enter a password." 
					validateat="onBlur" 
					maxlength="16"
				/>
				<!--- if requested to update the password --->	
				<cfif displayUpdate eq true>
					<cfinput 
						type="text" 
						name="password1" 
						label="New Password" 
						tooltip="Enter the new password." 
						width="200" 
						required="true" 
						message="You must enter a new password."
						validateat="onBlur"
						maxlength="16"
					/>
					<cfinput 
						type="text" 
						name="password2" 
						label="New Password Confirm" 
						tooltip="Enter the password confirm. Repeate the new password." 
						width="200" 
						required="true"  
						message="You must enter a confirmation password."
						validateat="onBlur"
						maxlength="16"
					/>
				</cfif>
			</cfformgroup>
			
			<cfformgroup type="vertical">
				<cfinput 
					name="_loginButtonText" 
					type="submit" 
					value="#loginButtonText#"
				/>
			</cfformgroup>

			<cfformitem type="html" style="font-weight:bold;">
				<p>
					<br />
					<cfif displayUpdate eq false>
						<font face="verdana" size="10">
							<a href="#myself#update.password">
								<u>
									Update Password &gt;&gt;
								</u>
							</a>
						</font>
					<cfelse>
						<font face="verdana" size="10">
							<a href="#myself#">
								<u>
									&lt;&lt; Back to Login
								</u>
							</a>
						</font>
					</cfif>	
					<br />
					<font face="verdana" size="10">
							<a href="#myself#log.out">
								<u>Log Out &gt;&gt;</u>
							</a>
					</font>
				</p>
			</cfformitem>
		</cfformgroup>
	</cfform>
	</div>
	<!--- forward them if its cool --->
	<cfif session.figFactorAdminLogin eq true>
		Should forward to<br />
		<cfdump var="#cgi.URL#">
	<cfelse>
		Not logged in<br />
	</cfif>
	<cfdump var="#isLoggedIn#">
	<cfdump var="#session#">
</body>
</html>
</cfoutput>