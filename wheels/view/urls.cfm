<cffunction name="linkTo" returntype="any" access="public" output="false">
	<cfargument name="url" type="any" required="false" default="">
	<cfargument name="text" type="any" required="false" default="">
	<cfargument name="confirm" type="any" required="false" default="">
	<!--- Accepts URLFor arguments --->
	<cfset var loc = structNew()>
	<cfset arguments.$namedArguments = "url,text,confirm,controller,action,id,anchor,onlyPath,host,protocol,params">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfif len(arguments.url) IS NOT 0>
		<cfset loc.href = arguments.url>
	<cfelse>
		<cfset loc.href = URLFor(argumentCollection=arguments)>
	</cfif>

	<cfif len(arguments.text) IS 0>
		<cfset arguments.text = loc.href>
	</cfif>

	<cfif len(arguments.confirm) IS NOT 0>
		<cfset loc.confirm = " onclick=""return confirm('#arguments.confirm#')"" ">
	<cfelse>
		<cfset loc.confirm = "">
	</cfif>

	<cfset loc.result = "<a href=""#loc.href#""#loc.confirm##loc.attributes#>#arguments.text#</a>">

	<cfreturn loc.result>
</cffunction>

<cffunction name="buttonTo" returntype="any" access="public" output="false">
	<cfargument name="url" type="any" required="false" default="">
	<cfargument name="text" type="any" required="false" default="">
	<cfargument name="confirm" type="any" required="false" default="">
	<cfargument name="disable" type="any" required="false" default="">
	<cfargument name="source" type="any" required="false" default="">
	<!--- Accepts URLFor arguments --->
	<cfset var loc = structNew()>
	<cfset arguments.$namedArguments = "url,text,confirm,disable,source,controller,action,id,anchor,onlyPath,host,protocol,params">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfif len(arguments.url) IS NOT 0>
		<cfset loc.action = arguments.url>
	<cfelse>
		<cfset loc.action = URLFor(argumentCollection=arguments)>
	</cfif>

	<!--- create the form tag --->
	<cfset loc.result = "<form action=""#loc.action#"" method=""post""">
	<cfif len(arguments.confirm) IS NOT 0>
		<cfset loc.result = loc.result & " onsubmit=""return confirm('#JSStringFormat(replace(arguments.confirm, """", '&quot;', 'all'))#');""">
	</cfif>
	<cfset loc.result = loc.result & ">">

	<!--- create the input tag --->
	<cfset loc.result = loc.result & "<input">
	<cfif len(arguments.source) IS 0>
		<cfset loc.result = loc.result & " type=""submit""">
	<cfelse>
		<cfset loc.result = loc.result & " type=""image"" src=""#application.wheels.webPath##application.settings.paths.images#/#arguments.source#""">
	</cfif>
	<cfif len(arguments.text) IS NOT 0>
		<cfset loc.result = loc.result & " value=""#arguments.text#""">
	</cfif>
	<cfif len(arguments.disable) IS NOT 0>
		<cfset loc.result = loc.result & " onclick=""this.disabled=true;">
		<cfif len(arguments.source) IS 0 AND NOT isBoolean(arguments.disable)>
			<cfset loc.result = loc.result & "this.value='#arguments.disable#';">
		</cfif>
		<cfset loc.result = loc.result & "this.form.submit();""">
	</cfif>
	<cfset loc.result = loc.result & "#loc.attributes# />">

	<!--- create the closing form tag --->
	<cfset loc.result = loc.result & "</form>">

	<cfreturn loc.result>
</cffunction>

<cffunction name="mailTo" returntype="any" access="public" output="false">
	<cfargument name="email" type="any" required="true">
	<cfargument name="text" type="any" required="false" default="">
	<cfargument name="encode" type="any" required="false" default="false">
	<cfset var loc = structNew()>

	<cfset loc.linkToArguments = structNew()>
	<cfset loc.linkToArguments.url = "mailto:#arguments.email#">
	<cfif len(arguments.text) IS 0>
		<cfset loc.linkToArguments.text = arguments.email>
	<cfelse>
		<cfset loc.linkToArguments.text = arguments.text>
	</cfif>
	<cfset loc.result = linkTo(argumentCollection=loc.linkToArguments)>

	<cfif arguments.encode>
		<cfset loc.js = "document.write('#trim(loc.result)#');">
		<cfset loc.encoded = "">
		<cfloop from="1" to="#len(loc.js)#" index="loc.i">
			<cfset loc.encoded = loc.encoded & "%" & right("0" & formatBaseN(asc(mid(loc.js,loc.i,1)),16),2)>
		</cfloop>
		<cfset loc.result = "<script type=""text/javascript"" language=""javascript"">eval(unescape('#loc.encoded#'))</script>">
	</cfif>

	<cfreturn loc.result>
</cffunction>

<cffunction name="linkToUnlessCurrent" returntype="any" access="public" output="false">
	<!--- accepts linkTo and URLFor arguments --->
	<cfset var loc = structNew()>
	<cfif isCurrentPage(argumentCollection=arguments)>
		<cfset loc.result = arguments.text>
	<cfelse>
		<cfset loc.result = linkTo(argumentCollection=arguments)>
	</cfif>
	<cfreturn loc.result>
</cffunction>

<cffunction name="isCurrentPage" returntype="any" access="public" output="false">
	<!--- accepts URLFor arguments --->
	<cfset var loc = structNew()>
	<cfset loc.newUrl = urlFor(argumentCollection=arguments)>
	<cfset loc.currentUrl = cgi.script_name>
	<cfif cgi.script_name IS NOT cgi.path_info>
		<cfset loc.currentUrl = loc.currentUrl & cgi.path_info>
	</cfif>
	<cfset loc.currentUrl = replace(loc.currentUrl, "rewrite.cfm/", "")>
	<cfif len(cgi.query_string) IS NOT 0>
		<cfset loc.currentUrl = loc.currentUrl & "?" & cgi.query_string>
	</cfif>
	<cfif loc.currentUrl IS loc.newUrl OR loc.currentUrl IS "/index.cfm" AND loc.newUrl IS "/">
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>