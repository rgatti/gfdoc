<cfset info = application.doc.getComponentInfo(url.component) />

<!--- If there was an error getting the metadata show it --->
<cfif info.metadata.type eq "error">
	<div class="section">
		<h1><cfoutput>#url.component#</cfoutput></h1>
		<cfdump var="#info.descendants#">
	</div>
	<cfabort>
</cfif>

<cfset package = listDeleteAt(info.metadata.fullname, listlen(info.metadata.fullname, "."), ".") />

<!--- Alphabetize functions by name --->
<cfif structKeyExists(info.metadata, "functions")>
	<cfset functionNames = structNew() />
	<cfloop from="1" to="#arraylen(info.metadata.functions)#" index="i">
		<!--- Make sure we remove private functions if needed --->
		<cfif not application.config.hidePrivateMethod
				or not structKeyExists(info.metadata.functions[i], "access")
				or info.metadata.functions[i].access neq "private">
			<cfset functionNames["#i#"] = info.metadata.functions[i].name />
		</cfif>
	</cfloop>
	<cfset sortedFunctions = structSort(functionNames) />
</cfif>


<cf_layout>
<div id="details">
	<cfoutput>

	<cf_pageheader package="#package#" selected="component" />

	<!--- Component header section --->
	<div class="section">
		<!--- Package and component name --->
		<div>#package#</div>
		<h1><cfif info.metadata.type eq "interface">Interface<cfelse>Component</cfif> #listlast(info.metadata.fullname, ".")#</h1>

		<!--- Print object hierarchy --->
		<cfif info.metadata.type eq "component" and structKeyExists(info.metadata, "extends")>
			<cfset md = info.metadata />
			<cfset hierarchy = "" />
			<cfloop condition="true">
				<cfset hierarchy = listAppend(md.fullname, hierarchy) />
				<cfif structKeyExists(md, "extends")>
					<cfset md = md.extends />
				<cfelse>
					<cfbreak />
				</cfif>
			</cfloop>
			<cfloop from="1" to="#listlen(hierarchy)#" index="i">
				<cfset fullname = listgetat(hierarchy, i) />
				<code>#repeatString("&nbsp;", (i - 1) * 7)#<cfif i neq 1><img src="/assets/inherit.gif" alt="extended by"/></cfif><cfif application.doc.hasComponentInfo(fullname) and fullname neq url.component><a href="/component-details.cfm?component=#urlEncodedFormat(fullname)#">#fullname#</a><cfelse>#fullname#</cfif></code><br/>
			</cfloop>
		</cfif>

		<!--- Superinterfaces (always has WEB-INF.cftags.interface) --->
		<cfif info.metadata.type eq "interface" and structCount(info.metadata.extends) gt 1>
		<p>
			<strong>All Superinterfaces:</strong><br/>
			<cfloop collection="#info.metadata.extends#" item="name">
				<cfoutput><a href="/component-details.cfm?component=#urlEncodedFormat(name)#">#listLast(name, ".")#</a></cfoutput>
			</cfloop>
		</p>
		</cfif>

		<!--- Implemented interfaces --->
		<cfif structKeyExists(info.metadata, "implements")>
		<p>
			<strong>All Implemented Interfaces:</strong><br/>
			<cfloop collection="#info.metadata.implements#" item="name">
				<cfoutput><a href="/component-details.cfm?component=#urlEncodedFormat(name)#">#listLast(name, ".")#</a></cfoutput>
			</cfloop>
		</p>
		</cfif>

		<!--- Descendants --->
		<cfif listlen(info.descendants)>
		<p>
			<strong>Direct Known Descendants:</strong><br/>
			<cfloop from="1" to="#listlen(info.descendants)#" index="i">
				<cfset name = listgetat(info.descendants, i) />
				<a href="/component-details.cfm?component=#urlEncodedFormat(name)#">#listLast(name, ".")#</a><cfif i lt listlen(info.descendants)>,</cfif>
			</cfloop>
		</p>
		</cfif>
	</div>
	<!--- // Component header section --->

	<!--- Component summary --->
	<cfif structKeyExists(info.metadata, "hint") or structKeyExists(info.metadata, "doc:since") or structKeyExists(info.metadata, "doc:see")>
	<div class="section">
		<p>
			<cfif structKeyExists(info.metadata, "hint")>#info.metadata.hint#<br/><br/></cfif>
			<cfif structKeyExists(info.metadata, "doc:since")><strong>Since: </strong>#info.metadata["doc:since"]#<br/><br/></cfif>
			<cfif structKeyExists(info.metadata, "doc:see")>
				<strong>See Also:</strong><br/>
				<cfloop from="1" to="#listlen(info.metadata['doc:see'])#" index="i">
					<cfset name = listgetat(info.metadata['doc:see'], i) />
					<a href="/component-details.cfm?component=#urlEncodedFormat(name)#">#listLast(name, ".")#</a><cfif i lt listlen(info.metadata['doc:see'])>,</cfif>
				</cfloop>
			</cfif>
		</p>
	</div>
	</cfif>
	<!--- // Component summary --->


	<!--- Property summary --->
	<!---
	<cfif structKeyExists(info.metadata, "properties")>
		<table class="summary">
			<thead>
				<tr>
					<th colspan="#listlen(application.config.tag.property)#">Property Summary:</th>
				</tr>
			</thead>
			<tbody>
				<cfloop from="1" to="#arraylen(info.metadata.properties)#" index="i">
					<cfset tag = info.metadata.properties[i] />
					<tr>
						<cfloop list="#application.config.tag.property#" index="attrib">
							<cfset aname = listFirst(attrib, "|") />
							<cfset default = listLast(attrib, "|") />
							<cfset isFullHint = listLast(aname, "-") eq "full" />
							<cfif isFullHint><cfset aname = "hint" /></cfif>
							<td>
								<cfif aname eq "hint" and not isFullHint>
									<cfif structKeyExists(tag, aname)>#listFirst(tag[aname], ".")#.<cfelse>#default#</cfif>
								<cfelse>
									<cfif structKeyExists(tag, aname)>#tag[aname]#<cfelse>#default#</cfif>
								</cfif>
							</td>
						</cfloop>
					</tr>
				</cfloop>
			</tbody>
		</table>
	</cfif>
	--->

	<!--- Constructor summary --->

	<!--- Function summary --->
	<cfif structKeyExists(info.metadata, "functions")>
	<div class="section summary">
		<table>
			<thead>
				<tr>
					<th colspan="2">Function Summary</th>
				</tr>
			</thead>
			<tbody>
				<cfloop array="#sortedFunctions#" index="i">
					<cfset tag = info.metadata.functions[i] />
					<tr>
						<td class="first">
							<cfif structKeyExists(tag, "access") and tag.access neq "public"><code>#tag.access#</code></cfif>
							<cfif structKeyExists(tag, "returntype")>
								<cfif application.doc.hasComponentInfo(tag.returntype)>
									<code><a href="/component-details.cfm?component=#urlEncodedFormat(tag.returntype)#">#tag.returntype#</a></code>
								<cfelseif application.doc.hasComponentInfo("#package#.#tag.returntype#")>
									<code><a href="/component-details.cfm?component=#urlEncodedFormat('#package#.#tag.returntype#')#">#tag.returntype#</a></code>
								<cfelse>
									<code>#tag.returntype#</code>
								</cfif>
							<cfelse>
								<code>any</code>
							</cfif>
						</td>
						<td>
							<!--- Use a string buffer to hold the formatted output of a function --->
							<cfscript>
								buf = "";
								for(j = 1; j lte arraylen(tag.parameters); j = j + 1) {
									if(j neq 1) {
										buf = buf & ", ";
									}
									if(structKeyExists(tag.parameters[j], "required") and yesNoFormat(tag.parameters[j].required) eq "no") {
										buf = buf & "[";
									}
									if(structKeyExists(tag.parameters[j], "type")) {
										buf = buf & tag.parameters[j].type;
									} else {
										buf = buf & "any";
									}
									buf = buf & " #tag.parameters[j].name#";
									if(structKeyExists(tag.parameters[j], "required") and yesNoFormat(tag.parameters[j].required) eq "no") {
										buf = buf & "]";
									}
								}
								// Store argument buffer for deail section
								functionArgs[tag.name] = buf;
							</cfscript>
							<code><strong><a href="###tag.name#">#tag.name#</a></strong>(#buf#)</code><br/>
							<cfif structKeyExists(tag, "hint") and len(trim(tag.hint))><div class="hint">#listfirst(tag.hint, ".")#.</div></cfif>
						</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	</div>
	</cfif>

	<!--- Inherited fnction summary, an interface extends field is a struct of structs, a component
	extends field is a single struct --->
	<cfif info.metadata.type eq "component" and structKeyExists(info.metadata, "extends") and info.metadata.extends.name neq "WEB-INF.cftags.component">
	<div class="section summary inherit">
		<cfset parent = info.metadata.extends />
		<cfloop condition="true">
			<cfif parent.name eq "WEB-INF.cftags.component">
				<cfbreak />
			</cfif>
			<table>
				<thead>
					<tr>
						<th colspan="2">
							Functions inherited from component
							<cfif application.doc.hasComponentInfo(parent.name)>
								<code>#replace(parent.name, listlast(parent.name, "."), "")#<a href="/component-details.cfm?component=#urlEncodedFormat("#parent.name#")#">#listlast(parent.name, ".")#</a></code>
							<cfelse>
								<code>#parent.name#</code>
							</cfif>
						</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							<cfif structKeyExists(parent, "functions")>
								<cfset buf = "" />
								<cfloop from="1" to="#arraylen(parent.functions)#" index="i">
									<cfset tag = parent.functions[i] />
									<cfif application.doc.hasComponentInfo(parent.name)>
										<cfset buf = listappend(buf, '<a href="/component-details.cfm?component=#urlEncodedFormat("#parent.name#")####tag.name#">#tag.name#</a>') />
									<cfelse>
										<cfset buf = listappend(buf, tag.name) />
									</cfif>
								</cfloop>
								<code>#listChangeDelims(buf, ", ")#</code>
							</cfif>
						</td>
					</tr>
				</tbody>
			</table>
			<cfif structKeyExists(parent, "extends")>
				<cfset parent = parent.extends />
			</cfif>
		</cfloop>
	</div>
	</cfif>

	<!--- Constructor detail --->

	<!--- Function detail --->
	<cfif structKeyExists(info.metadata, "functions")>
	<div class="section detail">
		<table>
			<thead>
				<tr>
					<th>Function Detail</th>
				</tr>
			</thead>
			<tbody>
				<cfloop array="#sortedFunctions#" index="i">
					<cfset tag = info.metadata.functions[i] />
					<tr>
						<td>
							<a name="#tag.name#" />
							<h3>#tag.name#</h3>

							<cfif structKeyExists(tag, "returntype")>
								<cfif application.doc.hasComponentInfo(tag.returntype)>
									<cfset returntype = '<code><a href="/component-details.cfm?component=#urlEncodedFormat(tag.returntype)#">#tag.returntype#</a></code>' />
								<cfelseif application.doc.hasComponentInfo("#package#.#tag.returntype#")>
									<cfset returntype = '<code><a href="/component-details.cfm?component=#urlEncodedFormat('#package#.#tag.returntype#')#">#tag.returntype#</a></code>' />
								<cfelse>
									<cfset returntype = '<code>#tag.returntype#</code>' />
								</cfif>
							<cfelse>
								<cfset returntype = '<code>any</code>' />
							</cfif>

							<cfsavecontent variable="call">
								<cfif structKeyExists(tag, "access")>#tag.access#<cfelse>public</cfif> <cfif structKeyExists(tag, "returntype")>#returntype#<cfelse>any</cfif> #tag.name#(
							</cfsavecontent>
							<cfset call = trim(call) />
							<!--- Calculate length of function call without any xref links --->
							<cfset callLength = rereplace(call, "<[^>]+>", "", "all") />

<!--- Special case formatting for the function declaration --->
<cfset first = true />
<pre>
#call#<cfloop list="#functionArgs[tag.name]#" index="arg"><cfif not first>,
#repeatString(" ", len(callLength))#</cfif><cfset first = false />#trim(arg)#</cfloop>)</pre>

							<div style="padding-left:50px;">
								<br/>
								<cfif structKeyExists(tag, "hint")>#tag.hint#<br/><br/></cfif>
								<cfif structKeyExists(tag, "parameters") and arraylen(tag.parameters)>
									<strong>Parameters:</strong><br/>
									<div style="padding-left:40px;">
										<cfloop from="1" to="#arraylen(tag.parameters)#" index="i">
											<code>#tag.parameters[i].name#</code><cfif structKeyExists(tag.parameters[i], "hint")> - #tag.parameters[i].hint#</cfif><br/>
										</cfloop>
									</div>
									<br/>
								</cfif>
								<cfif structKeyExists(tag, "throws")>
									<strong>Throws:</strong><br/>
									<div style="padding-left:40px;">
										<cfloop list="#tag.throws#" index="ex">
											<cfset ex = trim(ex) />
											<code>#listfirst(ex, " ")#</code> - #listrest(ex, " ")#<br/>
										</cfloop>
									</div>
									<br/>
								</cfif>
								<cfif not structKeyExists(tag, "returntype") or tag.returntype neq "void">
									<strong>Returns:</strong><br/>
									<div style="padding-left:40px;">
										<cfif structKeyExists(tag, "returntype")>
											<cfif application.doc.hasComponentInfo(tag.returntype)>
												<code><a href="/component-details.cfm?component=#urlEncodedFormat(tag.returntype)#">#tag.returntype#</a></code>
											<cfelse>
												<code>#tag.returntype#</code>
											</cfif>
										<cfelse>
											<code>any</code>
										</cfif>
									</div>
									<br/>
								</cfif>
							</div>
						</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	</div>
	</cfif>

	<!---<cfdump var="#info#">--->
	</cfoutput>
</div>
</cf_layout>
