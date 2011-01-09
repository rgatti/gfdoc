<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
		<title><cfoutput>#application.config.title#</cfoutput></title>
	</head>
	<cfif isdefined("url.refresh")>
	<body>
		<p>Done reindexing. <a href="/">Click here to continue.</a></p>
	</body>
	<cfelse>
	<frameset cols="210px,*">
		<frameset rows="250px,*">
			<frame name="packages" src="/list-packages.cfm" />
			<frame name="classes" src="/list-components.cfm" />
		</frameset>
		<cfoutput>
		<frame name="content" src="#application.config.startPage#" />
		</cfoutput>
	</frameset>
	</cfif>
</html>