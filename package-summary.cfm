<cfset components = application.doc.getComponents(url.package) />


<cf_layout>
<div id="details">
	<cfoutput>

	<cf_pageheader selected="package" />

	<div class="section">
		<h1>Package #url.package#</h1>
		<cfloop list="Interface,Component" index="type">
			<cfquery name="q" dbtype="query">
				select * from components where type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(type)#">
			</cfquery>

			<cfif q.recordcount>
				<div class="section summary">
					<table>
						<thead>
							<tr>
								<th colspan="2" style="text-align:left;"><cfoutput>#type#</cfoutput> Summary</th>
							</tr>
						</thead>
						<tbody>
							<cfloop query="q">
							<tr>
								<td class="first">
									<a href="/component-details.cfm?component=#urlEncodedFormat(package & '.' & component)#">#component#</a>
								</td>
								<td class="hint">
									<cfset info = application.doc.getComponentInfo(initcall) />
									<cfif structKeyExists(info.metadata, "hint")>#info.metadata.hint#</cfif>
								</td>
							</tr>
							</cfloop>
						</tbody>
					</table>
				</div>
			</cfif>
		</cfloop>
		</div>
	</cfoutput>
</div>
</cf_layout>
