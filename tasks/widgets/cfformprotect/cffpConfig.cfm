<cfset iniPath = getDirectoryFromPath(getCurrentTemplatePath())>

<!--- Custom For Mura --->
<cfif not isDefined("cffp")>
	<cfset cffp = CreateObject("component","cffpVerify").init() />
</cfif>
<!--- End Custom --->

<!--- Load the ini file into a structure in the application scope --->
<cfset cffpConfig=new mura.IniFile("#iniPath#/#cffp.configFilename#").get(section='CFFormProtect')>
