<!--- objects/data --->
<cfset config = application.beanFactory.getBean("config") />
<cfset application.beanfactory.getBean("google").search() />
<cfset google = application.beanFactory.getBean("google") />
<cfset pageEvent = application.VF.getPageEvent() />

<!--- display --->
<cfoutput>

	
<div style="float:right; width:250px;">
<form name="targetedSearch" method="get" action="#config.getSearchFormAction()#" id="targetedSearchID">
	#google.getSearchForm(hiddenFieldsOnly = true)#
	<!--- will need this to persist the "q" url variable
	<cfif structKeyExists(url, "q")>
		<input type="hidden" name="q" value="#URLEncodedFormat(url.q)#">
	</cfif>
	 --->
	<fieldset>
		
		<label for="partialfields_pub_id">Pub ID:</label>
		<input type="text" size="25" maxlength="255" name="partialfields_pub_id" id="partialfields_pub_id" />
		
	
		<label for="partialfields_authorlist">Author:</label>
		<input type="text" size="25" maxlength="255" name="partialfields_authorlist" id="partialfields_authorlist" />
		<br />
		
		<label for="partialfields_date_published">Date Published:</label>
		<input type="text" size="25" maxlength="255" name="partialfields_date_published" id="partialfields_date_published" />
		<br />
		
		<label for="partialfields_title">Title:</label>
		<input type="text" size="25" maxlength="255" name="partialfields_title" id="partialfields_title" />
		<br />
		
		<!--- <label for="partialfields_op_unit">OU</label>
		<select name="partialfields_op_unit">
			<option value="85">OU 1</option>
			<option value="820">OU 2</option>
			<option value="890">OU 3</option>
		</select> --->
		<br />
		<input type="submit" value="#config.getGoogleButtonText()#">
	</fieldset>
	
<p style="width:200px; font-size:.75em;">
	<strong>authorlist:</strong> Schenck, P. K., Klamo, J. L., Bassim, N. , Burke, P. G., Gerbig, Y. B., Green, M. L.<br />
	<strong>date_published:</strong> May 16, 2008<br />
	<strong>pub_id</strong>: 853610<br />
	<strong>title:</strong> Combinatorial study of the crystallinity boundary in the HfO2-TiO2-Y2O3 system using pulsed laser deposition library thin films<br />
	<strong>keywords:</strong> Combinatorial, Thin films, Reflectometry, X-ray diffraction, Nanoindentation<br />
	<strong>research_area:</strong> 271<br />
	<br />
	<br />
	<strong>authorlist:</strong> Morris, D. J., Cook, R. F.<br />
	<strong>date_published:</strong> December 12, 2009<br />
	<strong>pub_id:</strong> 851100<br />
	<strong>title:</strong> Indentation Fracture of Low Dielectric Constant Films, Part II. Indentation Fracture Mechanics Model<br />
	<strong>keywords:</strong> fracture, indentation, low-k, nanoindentation, reliability<br />
	<strong>research_area:</strong> error<br />
</p>
</form>
</div>
<cfif structKeyExists(request, "test")>
	<div style="float:right;"><cfdump var="#request.test#"></div>
</cfif>
#google.getSearchForm(
	formID = "inlineResultsGoogleForm",
	formName = "inlineResulteGoogleFormName"
)#
<hr />
#pageEvent.getAllValues().searchresults#
<!--- 
<cfif structKeyExists(request, "send")>
	<cfdump var="#request.send#" expand="true" />
</cfif>
 --->
</cfoutput>