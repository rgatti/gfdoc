<cfcomponent output="false">
	<cfset instance = structNew() />

	<cffunction name="init" returntype="Doc" access="public" output="false" hint="Setup the Doc cfc.">
		<cfargument name="docroots" type="array" required="true" hint="An array of doc roots." />
		<cfset instance.docroots = arguments.docroots />

		<!--- Cache structures --->
		<cfset instance.cache = structNew() />
		<cfset instance.cache.descendants = structNew() />	<!--- list of subinterfaces or subcomponents --->
		<cfset instance.cache.metadata = structNew() />		<!--- cache of metadata or a custom error struct --->
		<cfset instance.cache.error = structNew() />		<!--- collection of all failures --->
		<cfset instance.cache.query = queryNew("package,component,initcall,type,path", "varchar,varchar,varchar,varchar,varchar") />

		<cfreturn this />
	</cffunction>

	<cffunction name="createCache" returntype="void" access="public" output="false" hint="Find all cfc's in the docroots and cache the results.">
		<cfset var i = "" />
		<cfset var row = 1 />
		<cfset var docroot = "" />
		<cfset var files = "" />
		<cfset var package = "" />
		<cfset var component = "" />
		<cfset var metadata = "" />
		<cfset var parent = "" />
		<cfset var fullname = "" />

		<!--- Build cache for each docroot --->
		<cfloop from="1" to="#arraylen (instance.docroots)#" index="i">
			<cfset docroot = instance.docroots[i] />
			<cftrace text="indexing #docroot#" />

			<!--- Recursively grab all cfc's --->
			<cfdirectory action="list" directory="#expandPath('/#docroot#')#" recurse="true" filter="*.cfc" name="files" />

			<cfif files.recordcount>
				<cfset queryAddRow(instance.cache.query, files.recordcount) />

				<!--- Build cache --->
				<cfloop query="files">
					<!--- Setup individual cfc cache structs --->
					<cfset package = getPackageFromPath(directory, docroot) />
					<cfset component = getComponentFromFile(name) />
					<cfset fullname = package & "." & component />
					<cfset instance.cache.metadata[fullname] = structNew() />
					<cfparam name="instance.cache.descendants[fullname]" default="" />

					<!--- Try to cache the component metadata, if it errors save it --->
					<cftry>
						<cfset metadata = structNew() />
						<cfset metadata = getComponentMetadata(fullname) />
						<!--- Add this component to the descendant list of all its super- interfaces and components --->
						<cfset cacheDescendants(metadata) />
						<!--- There was an error getting the metadata, create a custom metadata type for an error
						and cache the exception instead --->
						<cfcatch>
							<cftrace text="error compiling metadata for #fullname# (docroot=#docroot#)" />
							<cfset metadata.type = "error" />
							<cfset instance.cache.error[fullname] = duplicate(cfcatch) />
						</cfcatch>
					</cftry>
					<cfset instance.cache.metadata[fullname] = metadata />

					<!--- Add this cfc to the docroot query of all cfc's --->
					<cfset querySetCell(instance.cache.query, "package", package, row) />
					<cfset querySetCell(instance.cache.query, "component", component, row) />
					<cfset querySetCell(instance.cache.query, "initcall", fullname, row) />
					<cfset querySetCell(instance.cache.query, "type", lcase(metadata.type), row) />
					<cfset querySetCell(instance.cache.query, "path", directory, row) />
					<cftrace text="adding #fullname# (type=#metadata.type#)" />

					<cfset row = row + 1 />
				</cfloop>
			<cfelse>
				<cftrace text="no components found for #expandPath('/#docroot#')#" />
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="getPackageFromPath" returntype="string" access="private" output="false" hint="Convert file path to package path.">
		<cfargument name="path" type="string" required="true" hint="A directory path." />
		<cfargument name="workingroot" type="string" required="true" hint="The current docroot being processed." />
		<cfset var package =  "" />
		<!--- Remove docroot path prefix --->
		<cfset package = replace(arguments.path, expandPath('/#arguments.workingroot#'), "") />
		<!--- Replace Windows and Unix style delimiters --->
		<cfset package = rereplace(package, "[\/\\]", ".", "all") />
		<!--- Prefix working docroot name to package path --->
		<cfset package = arguments.workingroot & "." & package />
		<!--- Remove any double dots --->
		<cfset package = replace(package, "..", ".", "all") />
		<!--- Trim extra dots from front/end of the path --->
		<cfset package = listChangeDelims(package, ".", ".") />
		<cfreturn package />
	</cffunction>

	<cffunction name="getComponentFromFile" returntype="string" access="private" output="false" hint="Convert a file name to component name.">
		<cfargument name="filename" type="string" required="true" hint="A filename." />
		<cfreturn replace(filename, ".cfc", "") />
	</cffunction>

	<cffunction name="cacheDescendants" returntype="void" access="private" output="false" hint="Adds this component to all its super-type descendant list.">
		<cfargument name="metadata" type="struct" required="true" hint="Metadata for a component." />
		<cfset var parent = "" />
		<cfset var key = "" />
		<!--- Loop over the implements and extends substructs --->
		<cfloop list="implements,extends" index="key">
			<cfif structKeyExists(arguments.metadata, key)>
				<!--- For all implemented interfaces and extended componens add ourself to their descendant list --->
				<cfloop list="#structKeyList(arguments.metadata[key])#" index="parent">
					<cfparam name="instance.cache.descendants[parent]" default="" />
					<cfset instance.cache.descendants[parent] =
						listAppend(instance.cache.descendants[parent], arguments.metadata.fullname) />
				</cfloop>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="getPackages" returntype="query" access="public" output="false" hint="Returns a query of package paths for a docroot.">
		<cfset var files = instance.cache.query />
		<cfset var result = "" />
		<cfquery name="result" dbtype="query">
			select distinct package from files order by package
		</cfquery>
		<cfreturn result />
	</cffunction>

	<cffunction name="getComponents" returntype="query" access="public" output="false" hint="Return a of components in all packages.">
		<cfargument name="package" type="string" required="false" hint="List of packages." />
		<cfset var result = "" />
		<cfset var files = instance.cache.query />
		<cfquery name="result" dbtype="query">
			select *
			from files
			<cfif isdefined("arguments.package")>
			where package = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.package#" />
			</cfif>
			order by type, component
		</cfquery>
		<cfreturn result />
	</cffunction>

	<cffunction name="hasComponentInfo" returntype="boolean" access="public" output="false" hint="Returns true if the component is cached.">
		<cfargument name="fullname" type="string" required="true" hint="Full dot notation name of the component." />
		<cfset arguments.fullname = trim(arguments.fullname) />
		<cfreturn structKeyExists(instance.cache.metadata, arguments.fullname) />
	</cffunction>

	<cffunction name="getComponentInfo" returntype="struct" access="public" output="false" hint="Returns a struct of all the info for a component.">
		<cfargument name="fullname" type="string" required="true" hint="Full dot notation name of the component." />
		<cfset var result = structNew() />
		<cfset arguments.fullname = trim(arguments.fullname) />
		<cfset result.metadata = instance.cache.metadata[arguments.fullname] />
		<cfset result.descendants = instance.cache.descendants[arguments.fullname] />
		<cfif structKeyExists(instance.cache.error, arguments.fullname)>
			<cfset result.descendants = instance.cache.error[arguments.fullname] />
		</cfif>
		<cfreturn result />
	</cffunction>

	<cffunction name="debug">
		<cfdump var="#instance#" />
	</cffunction>

</cfcomponent>