<cfset files = event.getValue("beans") />
<cfset message = event.getValue("message") />
<cfset myself = event.getValue("myself") />
<cfset xe.loadBeanByName = event.getValue("xe.loadBeanByName") />

<cfoutput>
<h3>Bean Management</h3>

<cfif len(message)>
	<div class="message">#message#</div>
</cfif>

<table id="listTable">
	<tr>
		<th>click to <br />load</th>
		<th>Bean Name</th>
	</tr>
<form action="#myself##xe.loadBeanByName#" method="post">
<cfloop collection="#files#" item="definitionFile">
	<cfset beans = files[definitionFile] />
	<cfloop collection="#beans#" item="bean">
		<cfset beanDefinition = beans[bean]>
		<cfloop array="#beanDefinition.XmlChildren#" index="x">
			<tr valign="top">
				<td><input type="checkbox" name="beanID" value="#x.XmlAttributes.id#" /></td>
				<td>#x.XmlAttributes.id#</td>
			</tr>
		</cfloop>
	</cfloop>
</cfloop>
</table>
<input type="submit" value="Load Bean &raquo;" />
</form>
</cfoutput>