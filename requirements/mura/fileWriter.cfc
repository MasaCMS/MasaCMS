<cfcomponent extends="mura.cfobject" output="false">
<cfset variables.useMode=true>
<cffunction name="init" output="false" returntype="any">
<cfargument name="useMode" required="true" default="true">
<cfargument name="tempDir" required="true" default="#application.configBean.getTempDir()#">
<cfif isBoolean(arguments.useMode)>
<cfset variables.useMode=arguments.useMode>
<cfelse>
<cfset variables.useMode=true>
</cfif>
<cfset variables.tempDir=arguments.tempDir >
<cfreturn this>
</cffunction>

<cffunction name="copyFile" output="false">
<cfargument name="source">
<cfargument name="destination">
<cfargument name="mode" required="true" default="775">
<cfif variables.useMode >
	<cffile action="copy" mode="#arguments.mode#" source="#arguments.source#" destination="#arguments.destination#" />
<cfelse>
	<cffile action="copy" source="#arguments.source#" destination="#arguments.destination#" />
</cfif>
</cffunction>

<cffunction name="moveFile" output="false">
<cfargument name="source">
<cfargument name="destination">
<cfargument name="mode" required="true" default="775">
<cfif variables.useMode >
	<cffile action="move" mode="#arguments.mode#" source="#arguments.source#" destination="#arguments.destination#" />
<cfelse>
	<cffile action="move" source="#arguments.source#" destination="#arguments.destination#" />
</cfif>
</cffunction>

<cffunction name="renameFile" output="false">
<cfargument name="source">
<cfargument name="destination">
<cfargument name="mode" required="true" default="775">
<cfif variables.useMode >
	<cffile action="rename" mode="#arguments.mode#" source="#arguments.source#" destination="#arguments.destination#" />
<cfelse>
	<cffile action="rename" source="#arguments.source#" destination="#arguments.destination#" />
</cfif>
</cffunction>

<cffunction name="writeFile" output="false">
<cfargument name="file">
<cfargument name="output">
<cfargument name="addNewLine" required="true" default="true">
<cfargument name="mode" required="true" default="775">
<cfif variables.useMode >
	<cffile action="write" mode="#arguments.mode#" file="#arguments.file#" output="#arguments.output#" addnewline="#arguments.addNewLine#"/>
<cfelse>
	<cffile action="write" file="#arguments.file#" output="#arguments.output#" addnewline="#arguments.addNewLine#"/>
</cfif>
</cffunction>

<cffunction name="uploadFile" output="false">
<cfargument name="filefield">
<cfargument name="destination" required="true" default="#variables.tempDir#">
<cfargument name="nameConflict" required="true" default="makeunique">
<cfargument name="attributes" required="true" default="normal">
<cfargument name="mode" required="true" default="775">
<cfif variables.useMode >
	<cffile action="upload"
					fileField="#arguments.fileField#"
					destination="#arguments.destination#"
					nameConflict="#arguments.nameConflict#"
					mode="#arguments.mode#"
					attributes="#arguments.attributes#"
					result="upload">
<cfelse>
	<cffile action="upload"
					fileField="#arguments.fileField#"
					destination="#arguments.destination#"
					nameConflict="#arguments.nameConflict#"
					attributes="#arguments.attributes#"
					result="upload">
</cfif>
<cfreturn upload>
</cffunction>

<cffunction name="appendFile" output="false">
<cfargument name="file">
<cfargument name="output">
<cfargument name="mode" required="true" default="775">
<cfif variables.useMode >
	<cffile action="append" mode="#arguments.mode#" file="#arguments.file#" output="#arguments.output#"/>
<cfelse>
	<cffile action="append" file="#arguments.file#" output="#arguments.output#" />
</cfif>
</cffunction>

<cffunction name="createDir" output="false">
<cfargument name="directory">
<cfargument name="mode" required="true" default="775">
<cfif variables.useMode >
	<cfdirectory action="create" mode="#arguments.mode#" directory="#arguments.directory#"/>
<cfelse>
	<cfdirectory action="create" directory="#arguments.directory#"/>
</cfif>
</cffunction>

<cffunction name="renameDir" output="false">
<cfargument name="directory">
<cfargument name="newDirectory">
<cfargument name="mode" required="true" default="775">
<cfif variables.useMode >
	<cfdirectory action="rename" mode="#arguments.mode#" directory="#arguments.directory#" newDirectory="#arguments.newDirectory#"/>
<cfelse>
	<cfdirectory action="rename" directory="#arguments.directory#" newDirectory="#arguments.newDirectory#"/>
</cfif>
</cffunction>

<cffunction name="deleteDir" output="false">
<cfargument name="directory">
<cfargument name="recurse" required="true" default="true">
<cfdirectory action="delete" directory="#arguments.directory#" recurse="#arguments.recurse#"/>
</cffunction>

</cfcomponent>