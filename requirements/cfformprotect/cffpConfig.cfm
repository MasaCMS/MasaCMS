<cfset iniPath = getDirectoryFromPath(getCurrentTemplatePath())>

<!--- Load the ini file into a structure in the application scope --->
<cfset iniFileStruct = getProfileSections("#iniPath#/cffp.ini.cfm")>
<cfset iniFileEntries = iniFileStruct["CFFormProtect"]>
<cfset cffpConfig = structNew()>
<cfloop list="#iniFileEntries#" index="iniEntry">
	<cfset cffpConfig[iniEntry] = getProfileString("#iniPath#/cffp.ini.cfm","CFFormProtect",iniEntry)>
</cfloop>