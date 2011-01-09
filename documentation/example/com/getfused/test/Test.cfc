<cfcomponent output="false" implements="ITest" extends="AbstractTest" hint="A sample Coldfusion Component">

	<cffunction name="init" returntype="Test" access="public" output="false">
		<cfreturn this />
	</cffunction>

	<cffunction name="exampleFunction" returntype="boolean" access="public" output="false" hint="This is an example function.">
		<cfargument name="arg1" type="string" required="true" hint="First argument." />
		<cfargument name="arg2" type="numeric" required="false" default="3" hint="Second argument." />
		<cfreturn true />
	</cffunction>

</cfcomponent>