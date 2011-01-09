<cfinterface hint="Base interface for example cfc.">

	<cffunction name="exampleFunction" returntype="boolean" access="public" output="false" hint="This is an example function.">
		<cfargument name="arg1" type="string" required="true" hint="First argument." />
		<cfargument name="arg2" type="numeric" required="false" default="3" hint="Second argument." />
	</cffunction>

</cfinterface>