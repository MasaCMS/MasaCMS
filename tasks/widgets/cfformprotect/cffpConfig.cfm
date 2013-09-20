<cfset iniPath = getDirectoryFromPath(getCurrentTemplatePath())>

<!--- Custom For Mura --->
<cfif not isDefined("cffp")>
	<cfset cffp = CreateObject("component","cffpVerify").init() />
</cfif>
<!--- End Custom --->

<!--- Load the ini file into a structure in the application scope --->
<cfset iniFileStruct = getProfileSections("#iniPath#/#cffp.configFilename#")>
<cfset iniFileEntries = iniFileStruct["CFFormProtect"]>
<cfset cffpConfig = structNew()>
<cfloop list="#iniFileEntries#" index="iniEntry">
	<cfset cffpConfig[iniEntry] = getProfileString("#iniPath#/#cffp.configFilename#","CFFormProtect",iniEntry)>
</cfloop>