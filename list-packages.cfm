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
		<!--- Remove the docroot from the base of the package path --->
		<li><a href="/list-components.cfm?package=#urlEncodedFormat(package)#" target="classes">#package#</a></li>
	</cfoutput>
	</ul>
</div>
</cf_layout>
