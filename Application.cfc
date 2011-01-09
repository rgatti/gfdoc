<cfcomponent output="false">
	<cfscript>
		this.name = getDirectoryFromPath(getCurrentTemplatePath());
		this.sessionManagement = false;
		this.clientManagement = false;
	</cfscript>

	<cffunction name="onApplicationStart" returntype="boolean" access="public" output="false">
		<!--- Include the configuration --->
		<cfinclude template="config.cfm" />

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
			<cflock scope="application" timeout="3">
				<cfif not onApplicationStart()>
					<cfreturn false />
				</cfif>
			</cflock>
		</cfif>
		<cfreturn true />
	</cffunction>
</cfcomponent>