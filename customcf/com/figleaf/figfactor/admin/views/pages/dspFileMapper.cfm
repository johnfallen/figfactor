<cfset fileMaps = event.getValue("fileMaps") />
<cfset message = event.getValue("message") />
<cfset myself = event.getValue("myself") />
<cfset xe.loadFileMapping = event.getValue("xe.loadFileMapping") />

<cfsavecontent variable="accordianjs">
<cfoutput>
<script type="text/javascript">
	$(function() {
		$("##accordion").accordion();
	});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#accordianjs#" />

<cfoutput>
<h3>File Mappings </h3>

<cfif len(message)>
	<div class="message">#message#</div>
</cfif>

<div class="demo">
	<div id="accordion">
		<cfloop collection="#fileMaps#" item="map">
			<h3 class="mapTitle">
				<a href="##">
					<span>deployed? #fileMaps[map].getHasDeployed()#</span>
					#fileMaps[map].getMapName()#
				</a>
			</h3>
			<div>
				<div class="mapping">
					<div class="map">
						
						<cfif len(fileMaps[map].getFileName())>
							<em><strong>file: #fileMaps[map].getFileName()#</strong></em><br />
						<cfelse>
							<em><strong>Directory Copy</strong></em><br />
						</cfif>
						
						<div class="sourceDestination borders">
							source:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#fileMaps[map].getSource()#<br />
							destination: #fileMaps[map].getDestination()#<br />
						</div>
						
						<div class="mapActions">
							<a href="#myself##xe.loadFileMapping#&map=#map#">Deploy &raquo;</a>	
						</div>
						
						<cfif len(fileMaps[map].getAllowedExtensions())>
							Allowed Extensions: #fileMaps[map].getAllowedExtensions()#<br />
						</cfif>
						
						<cfif len(fileMaps[map].getRecursive())>
							recursive: #fileMaps[map].getRecursive()#<br />
						</cfif>
						
						<cfif len(fileMaps[map].getNameConfilct())>
							Name Conflict: #fileMaps[map].getNameConfilct()#<br />
						</cfif>
					</div>
				</div>
			</div>
		</cfloop>
	</div>
</div>
</cfoutput>