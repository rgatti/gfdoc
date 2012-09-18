<cf_layout>
<div id="listing" class="section">
	<cfif isdefined("url.package")>
		<cfoutput><h1><a href="/package-summary.cfm?package=#urlEncodedFormat(url.package)#" target="content">#url.package#</a></h1></cfoutput>
		<cfset components = application.doc.getComponents(url.package) />
		<cfset group = "Interface,Component" />
	<cfelse>
		<h1 style="font-weight:bold;">All packages</h1>
		<cfset components = application.doc.getComponents() />
		<cfset group = "all">
	</cfif>
	<cfloop list="#group#" index="type">
		<cfquery name="q" dbtype="query">
			select * from components
			<cfif type neq "all">
			where type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(type)#">
			</cfif>
			order by component
		</cfquery>
		<cfif q.recordcount>
		<div <cfif type eq 'interface'>class="interface"</cfif> style="padding-left:2px;">
			<cfif type neq "all"><cfoutput><h2>#type#</h2></cfoutput></cfif>
			<ul>
			<cfoutput query="q">
				<cfset showPackage = true />
				<cfloop array="#application.config.hide#" index="pattern">
					<cfif reFind(pattern, package) neq 0>
						<cfset showPackage = false />
						<cfbreak />
					</cfif>
				</cfloop>

				<cfif showPackage>
					<li><a href="/component-details.cfm?component=#urlEncodedFormat(package & '.' & component)#" target="content" title="#package#">#component#</a></li>
				</cfif>
			</cfoutput>
			</ul>
		</div>
		</cfif>
	</cfloop>
</div>
</cf_layout>
