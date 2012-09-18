<cfsetting showdebugoutput="false" />

<cfif thistag.executionMode eq "end">
<cfsavecontent variable="page">
<!DOCTYPE html>
<html>
	<head>
		<title><cfoutput>#application.config.title#</cfoutput></title>
		<link rel="stylesheet" href="/assets/style.css" type="text/css" />
	</head>
	<body><cfoutput>#thistag.generatedContent#</cfoutput></body>
</html>
</cfsavecontent>

<cfcontent reset="true" /><cfoutput>#page#</cfoutput>
</cfif>
