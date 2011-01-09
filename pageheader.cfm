<cfif thistag.executionMode eq "start">
	<!--- Page header --->
	<div id="pageheader">
		<div class="links">
		<table>
			<tr>
				<cfif attributes.selected eq "package">
					<td class="selected">Package</td>
				<cfelse>
					<cfoutput>
					<td><a href="/package-summary.cfm?package=#urlEncodedFormat(attributes.package)#">Package</a></td>
					</cfoutput>
				</cfif>

				<cfif attributes.selected eq "component">
					<td class="selected">Component</td>
				<cfelse>
					<td>Component</td>
				</cfif>

				<td>Index</td>
			</tr>
		</table>
		</div>
		<!---<span style="font-size:9px;"><a href="/index.cfm" target="_top">FRAMES</a>&nbsp;&nbsp;&nbsp;<a href="/overview.cfm" target="_top">NO FRAMES</a></span>--->
	</div>
</cfif>
