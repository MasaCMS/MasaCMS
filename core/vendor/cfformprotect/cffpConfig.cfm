<cfset iniPath = getDirectoryFromPath(getCurrentTemplatePath())>

<!--- Custom For Masa CMS --->
<cfif not isDefined("cffp")>
	<cfset cffp = CreateObject("component","cffpVerify").init() />
</cfif>
<!--- End Custom --->

<!--- Load the ini file into a structure in the application scope --->
<cfset iniFileStruct = getProfileSections("#iniPath#/#cffp.configFilename#")>
<cfset iniFileEntries = iniFileStruct["CFFormProtect"]>
<!--- Custom For Masa CMS: BoxLang returns each section as a struct instead of a list of entry names --->
<cfif isStruct(iniFileEntries)>
	<cfset iniFileEntries = structKeyList(iniFileEntries)>
</cfif>
<!--- End Custom --->
<cfset cffpConfig = structNew()>
<cfloop list="#iniFileEntries#" index="iniEntry">
	<cfset cffpConfig[iniEntry] = getProfileString("#iniPath#/#cffp.configFilename#","CFFormProtect",iniEntry)>
</cfloop>