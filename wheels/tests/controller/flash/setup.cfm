<cffunction name="setup">
	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>
	<cfset controller.$setFlashStorage("cookie")>
	<cfset controller.flashClear()>
	<cfset controller.$setFlashStorage("session")>
	<cfset controller.flashClear()>
</cffunction>