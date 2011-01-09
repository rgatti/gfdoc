<cfsetting showdebugoutput="false" />

<cfif thistag.executionMode eq "end">
<cfsavecontent variable="page">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
		<title><cfoutput>#application.config.title#</cfoutput></title>
		<link rel="stylesheet" href="/assets/style.css" type="text/css" />
	</head>
	<body><cfoutput>#thistag.generatedContent#</cfoutput></body>
</html>
</cfsavecontent>

<cfcontent reset="true" /><cfoutput>#page#</cfoutput>
</cfif>
