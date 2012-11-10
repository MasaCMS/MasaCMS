<cfset iniPath = getDirectoryFromPath(getCurrentTemplatePath())>

<!--- Custom For Mura --->
<cfset configFilename=application.configBean.getCFFPConfigFilename()>
<!--- End Custom --->

<!--- Load the ini file into a structure in the application scope --->
<cfset iniFileStruct = getProfileSections("#iniPath#/#configFilename#")>
<cfset iniFileEntries = iniFileStruct["CFFormProtect"]>
<cfset cffpConfig = structNew()>
<cfloop list="#iniFileEntries#" index="iniEntry">
	<cfset cffpConfig[iniEntry] = getProfileString("#iniPath#/#configFilename#","CFFormProtect",iniEntry)>
</cfloop>