<cfcomponent output="false">
	<cfset this.name = "Coldfusion Documentation Tool" />
	<cfset this.sessionManagement = false />
	<cfset this.clientManagement = false />

	<!--- This should be registered in the Coldfusion administrator. --->
	<cfset this.mappings = {
		"/gfplatform" = "C:/Users/rgatti/Development/Websites/gfplatform",
		"/coldbox" = "C:/Users/rgatti/Development/Websites/gfplatform/frameworks/coldbox",
		"/coldspring" = "C:/Users/rgatti/Development/Websites/gfplatform/frameworks/coldspring"
	} />

	<cffunction name="onApplicationStart" returntype="boolean" access="public" output="false">
		<!--- Include the configuration --->
		<cfinclude template="config.cfm" />

		<!---
		<cfdump var="#expandPath('/gfplatform')#" />
		<cfdump var="#getComponentMetaData('gfplatform.cms.api.field.TextInput')#" expand="false" abort="true" />
		--->

		<!--- Create Doc utility and cache the doc roots --->
		<cfset application.doc = createObject("component", "Doc").init(application.config.docroots) />
		<!--- Create a cache of the cfc's in each docroot --->
		<cfset application.doc.createCache() />

		<!--- The application started correctly --->
		<cfreturn true />
	</cffunction>

	<cffunction name="onRequestStart" returntype="boolean" access="public" output="false">
		<!--- Refresh the application --->
		<cfif isdefined("url.refresh")>
			<cflock scope="application" timeout="300">
				<cfif not onApplicationStart()>
					<cfreturn false />
				</cfif>
			</cflock>
		</cfif>
		<cfreturn true />
	</cffunction>
</cfcomponent>