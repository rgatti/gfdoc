<cf_layout>
<div id="listing" class="section">
	<h1 id="title"><cfoutput>#application.config.subtitle#</cfoutput></h1>
	<a href="/list-components.cfm" target="classes">All Packages</a>
	<br/><br/>
	<strong>Packages</strong>
	<br/><br/>
	<ul>
	<cfset packages = application.doc.getPackages() />
	<cfoutput query="packages">
		<cfset showPackage = true />
		<cfloop array="#application.config.hide#" index="pattern">
			<cfif reFind(pattern, package) neq 0>
				<cfset showPackage = false />
				<cfbreak />
			</cfif>
		</cfloop>
		<cfif showPackage>
			<!--- Remove the docroot from the base of the package path --->
			<li><a href="/list-components.cfm?package=#urlEncodedFormat(package)#" target="classes">#package#</a></li>
		</cfif>
	</cfoutput>
	</ul>
</div>
</cf_layout>
