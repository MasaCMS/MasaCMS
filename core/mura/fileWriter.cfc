<!---
  This file is part of Mura CMS.

  Mura CMS is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, Version 2 of the License.

  Mura CMS is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

  Linking Mura CMS statically or dynamically with other modules constitutes
  the preparation of a derivative work based on Mura CMS. Thus, the terms
  and conditions of the GNU General Public License version 2 ("GPL") cover
  the entire combined work.

  However, as a special exception, the copyright holders of Mura CMS grant
  you permission to combine Mura CMS with programs or libraries that are
  released under the GNU Lesser General Public License version 2.1.

  In addition, as a special exception, the copyright holders of Mura CMS
  grant you permission to combine Mura CMS with independent software modules
  (plugins, themes and bundles), and to distribute these plugins, themes and
  bundles without Mura CMS under the license of your choice, provided that
  you follow these specific guidelines:

  Your custom code

  • Must not alter any default objects in the Mura CMS database and
  • May not alter the default display of the Mura CMS logo within Mura CMS and
  • Must not alter any files in the following directories:

   	/admin/
	/core/
	/Application.cfc
	/index.cfm

  You may copy and distribute Mura CMS with a plug-in, theme or bundle that
  meets the above guidelines as a combined work under the terms of GPL for
  Mura CMS, provided that you include the source code of that other code when
  and as the GNU GPL requires distribution of source code.

  For clarity, if you create a modified version of Mura CMS, you are not
  obligated to grant this special exception for your modified version; it is
  your choice whether to do so, or to make such modified version available
  under the GNU General Public License version 2 without this exception.  You
  may, if you choose, apply this exception to your own modified versions of
  Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false" hint="This provides a CRUD utility for the host file system">

	<cfset variables.useMode=true>

	<cffunction name="init" output="false">
		<cfargument name="useMode" required="true" default="">
		<cfargument name="tempDir" required="true" default="#application.configBean.getTempDir()#">

		<cfif findNoCase(server.os.name,"Windows")>
			<cfset variables.useMode=false>
		<cfelse>
			<cfif isBoolean(arguments.useMode)>
				<cfset variables.useMode=arguments.useMode>
			<cfelse>
				<cfset variables.useMode=application.configBean.getValue("useFileMode")>
			</cfif>
		</cfif>

		<cfset variables.tempDir=arguments.tempDir >

		<cfif isNumeric(application.configBean.getValue("defaultFileMode"))>
			<cfset variables.defaultFileMode=application.configBean.getValue("defaultFileMode")>
		<cfelse>
			<cfset variables.defaultFileMode=775>
		</cfif>

		<cfreturn this />
	</cffunction>

	<cffunction name="copyFile" output="false">
		<cfargument name="source">
		<cfargument name="destination">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">
		<cflock name="mfw#hash(arguments.source)#" type="exclusive" timeout="5">
			<cftry>
				<cfif variables.useMode >
					<cffile action="copy" mode="#arguments.mode#" source="#arguments.source#" destination="#arguments.destination#" />
				<cfelse>
					<cffile action="copy" source="#arguments.source#" destination="#arguments.destination#" />
				</cfif>
				<cfcatch>
					<cfset sleep(RandRange(500, 1000))>
					<cfif fileExists(arguments.destination)>
						<cfset fileDelete(arguments.destination)>
					</cfif>
					<cfif variables.useMode >
						<cffile action="copy" mode="#arguments.mode#" source="#arguments.source#" destination="#arguments.destination#" />
					<cfelse>
						<cffile action="copy" source="#arguments.source#" destination="#arguments.destination#" />
					</cfif>
				</cfcatch>
			</cftry>
		</cflock>
		<cfreturn this />
	</cffunction>

	<cffunction name="moveFile" output="false">
		<cfargument name="source">
		<cfargument name="destination">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">
		<cflock name="mfw#hash(arguments.source)#" type="exclusive" timeout="5">
			<!---<cfif not listFirst(expandPath(arguments.file),':') eq 's3>--->
				<cfif variables.useMode >
					<cffile action="copy" mode="#arguments.mode#" source="#arguments.source#" destination="#arguments.destination#" />
					<cftry><cffile action="delete" file="#arguments.source#" /><cfcatch></cfcatch></cftry>
				<cfelse>
					<cffile action="copy" source="#arguments.source#" destination="#arguments.destination#" />
					<cftry><cffile action="delete" file="#arguments.source#" /><cfcatch></cfcatch></cftry>
				</cfif>
			<!---
			<cfelse>
				<cffile action="copy" acl="private" source="#arguments.source#" destination="#arguments.destination#" />
				<cftry><cffile action="delete" file="#arguments.source#" /><cfcatch></cfcatch></cftry>
			</cfif>
			--->
		</cflock>
		<cfreturn this />
	</cffunction>

	<cffunction name="renameFile" output="false">
		<cfargument name="source">
		<cfargument name="destination">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">
		<cflock name="mfw#hash(arguments.source)#" type="exclusive" timeout= "5">
			<cfif variables.useMode >
				<cffile action="rename" mode="#arguments.mode#" source="#arguments.source#" destination="#arguments.destination#" />
			<cfelse>
				<cffile action="rename" source="#arguments.source#" destination="#arguments.destination#" />
			</cfif>
		</cflock>
		<cfreturn this />
	</cffunction>

	<cffunction name="writeFile" output="true">
		<cfargument name="file">
		<cfargument name="output">
		<cfargument name="addNewLine" required="true" default="true">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">
		<cfargument name="charset">
		<cfset var new = "">
		<cfset var x = "">
		<cfset var counter = 0>

		<cfif isDefined('arguments.output.mode')>
				<cfset new = FileOpen(arguments.file, "write")>

				<cfloop condition="!fileIsEOF( arguments.output )">
					<cfset x = FileRead(arguments.output, 10000)>
					<cfif isDefined('arguments.charset')>
						<cfset FileWrite(new, x, arguments.charset)>
					<cfelse>
						<cfset FileWrite(new, x)>
					</cfif>
					<cfset counter = counter + 1>
				</cfloop>

				<cfset FileClose(arguments.output)>
				<cfset FileClose(new)>

				<cfif fileExists(arguments.output.path)>
					<cfset FileDelete(arguments.output.path)>
				<cfelseif fileExists(arguments.output.path & "/" & arguments.output.name)>
					<cfset FileDelete(arguments.output.path & "/" & arguments.output.name)>
				</cfif>
		<cfelse>
			<!---<cfif not listFirst(expandPath(arguments.file),':') eq 's3>--->
				<cfif variables.useMode >
					<cffile action="write" mode="#arguments.mode#" file="#arguments.file#" output="#arguments.output#" addnewline="#arguments.addNewLine#"/>
				<cfelse>
					<cffile action="write" file="#arguments.file#" output="#arguments.output#" addnewline="#arguments.addNewLine#"/>
				</cfif>
			<!---<cfelse>
				<cffile action="write" acl="private" file="#arguments.file#" output="#arguments.output#" addnewline="#arguments.addNewLine#"/>
			</cfif>--->
		</cfif>
		<cfreturn this />
	</cffunction>

	<cffunction name="uploadFile" output="false">
		<cfargument name="filefield">
		<cfargument name="destination" required="true" default="#variables.tempDir#">
		<cfargument name="nameConflict" required="true" default="makeunique">
		<cfargument name="attributes" required="true" default="normal">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">
		<cfargument name="accept" required="false" default="" />

		<cfset touchDir(arguments.destination,arguments.mode) />

		<cfif variables.useMode >
			<cffile action="upload"
							fileField="#arguments.fileField#"
							destination="#arguments.destination#"
							nameConflict="#arguments.nameConflict#"
							mode="#arguments.mode#"
							attributes="#arguments.attributes#"
							result="upload"
							accept="#arguments.accept#">
		<cfelse>
			<cffile action="upload"
							fileField="#arguments.fileField#"
							destination="#arguments.destination#"
							nameConflict="#arguments.nameConflict#"
							attributes="#arguments.attributes#"
							result="upload"
							accept="#arguments.accept#">
		</cfif>
		<cfreturn upload>
	</cffunction>

	<cffunction name="appendFile" output="false">
		<cfargument name="file">
		<cfargument name="output">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">
		<cflock name="mfw#hash(arguments.file)#" type="exclusive" timeout="5">
			<cfif variables.useMode >
				<cffile action="append" mode="#arguments.mode#" file="#arguments.file#" output="#arguments.output#"/>
			<cfelse>
				<cffile action="append" file="#arguments.file#" output="#arguments.output#" />
			</cfif>
		</cflock>
		<cfreturn this />
	</cffunction>

	<cffunction name="createDir" output="false">
		<cfargument name="directory">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">
		<!--- Skip if using Amazon S3 --->
		<cfif Not ListFindNoCase('s3', Left(arguments.directory, 2))>
			<cfif variables.useMode >
				<cfdirectory action="create" mode="#arguments.mode#" directory="#arguments.directory#"/>
			<cfelse>
				<cfdirectory action="create" directory="#arguments.directory#"/>
			</cfif>
		</cfif>
		<cfreturn this />
	</cffunction>

	<cffunction name="touchDir" output="false">
		<cfargument name="directory">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">
		<cfif Not DirectoryExists(arguments.directory)>
			<cfset createDir(arguments.directory,arguments.mode) />
		</cfif>
		<cfreturn this />
	</cffunction>

	<cffunction name="renameDir" output="false">
		<cfargument name="directory">
		<cfargument name="newDirectory">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">
		<cfif variables.useMode >
			<cfdirectory action="rename" mode="#arguments.mode#" directory="#arguments.directory#" newDirectory="#arguments.newDirectory#"/>
		<cfelse>
			<cfdirectory action="rename" directory="#arguments.directory#" newDirectory="#arguments.newDirectory#"/>
		</cfif>
		<cfreturn this />
	</cffunction>

	<cffunction name="deleteDir" output="false">
		<cfargument name="directory">
		<cfargument name="recurse" required="true" default="true">
		<cfdirectory action="delete" directory="#arguments.directory#" recurse="#arguments.recurse#"/>
		<cfreturn this />
	</cffunction>

	<cffunction name="copyDir" output="false">
		<cfargument name="baseDir" default="" required="true" />
		<cfargument name="destDir" default="" required="true" />
		<cfargument name="excludeList" default="" required="true" />
		<cfargument name="sinceDate" default="" required="true" />
		<cfargument name="excludeHiddenFiles" default="true" required="true" />
		<cfset var rsAll = "">
		<cfset var rs = "">
		<cfset var i="">
		<cfset var errors=arrayNew(1)>
		<cfset var copyItem="">

		<cfset arguments.baseDir=pathFormat(expandPath(arguments.baseDir))>
		<cfset arguments.destDir=pathFormat(expandPath(arguments.destDir))>
		<cfset arguments.excludeList=pathFormat(arguments.excludeList)>

		<cfif arguments.baseDir neq arguments.destDir>
			<cfdirectory directory="#arguments.baseDir#" name="rsAll" action="list" recurse="true" />
			<!--- filter out Subversion hidden folders --->

			<cfset rsAll=fixQueryPaths(rsAll)>

			<cfquery name="rsAll" dbtype="query">
				SELECT * FROM rsAll
				WHERE
				1=1
				<cfif arguments.excludeHiddenFiles>
					and directory NOT LIKE '%/.svn%'
					and directory NOT LIKE '%/.git%'
					and name not like '.%'
				</cfif>
				<cfif len(arguments.excludeList)>
					<cfloop list="#arguments.excludeList#" index="i">
						and directory NOT LIKE '%#i#%'
					</cfloop>
				</cfif>

				<cfif isDate(arguments.sinceDate)>
					and dateLastModified >= #createODBCDateTime(arguments.sinceDate)#
				</cfif>
			</cfquery>

			<cfset copyItem=arguments.destDir>
			<cftry>
				<cfset createDir(directory=copyItem)>
				<cfcatch><!---<cfset arrayAppend(errors,copyItem)>---></cfcatch>
			</cftry>

			<cfquery name="rs" dbtype="query">
				select * from rsAll where lower(type) = 'dir'
			</cfquery>

			<cfloop query="rs">
				<cfset copyItem="#replace('#rs.directory#/',arguments.baseDir,arguments.destDir)##rs.name#/">
				<cfif not DirectoryExists(copyItem)>
				<cftry>
					<cfset createDir(directory=copyItem)>
					<cfcatch><!---<cfset arrayAppend(errors,copyItem)>---></cfcatch>
				</cftry>
				</cfif>
			</cfloop>

			<cfquery name="rs" dbtype="query">
				select * from rsAll where lower(type) = 'file'
			</cfquery>

			<cfloop query="rs">
				<cfset copyItem="#replace('#rs.directory#/',arguments.baseDir,arguments.destDir)#">
				<cfif fileExists("#copyItem#/#rs.name#")>
					<cffile action="delete" file="#copyItem#/#rs.name#">
				</cfif>

				<cftry>
					<cfset copyFile(source="#rs.directory#/#rs.name#", destination=copyItem, sinceDate=arguments.sinceDate)>
					<cfcatch><cfset arrayAppend(errors,"#copyItem#/#rs.name#")></cfcatch>
				</cftry>
			</cfloop>
		</cfif>

		<cfreturn errors>
	</cffunction>

	<cffunction name="getFreeSpace" output="false">
		<cfargument name="file">
		<cfargument name="unit" default="gb">
		<cfset var space=createObject("java", "java.io.File").init(arguments.file).getFreeSpace()>

		<cfif arguments.unit eq "bytes">
			<cfreturn space>
		<cfelseif arguments.unit eq "kb">
			<cfreturn space /1024 >
		<cfelseif arguments.unit eq "mb">
			<cfreturn space /1024 / 1024>
		<cfelse>
			<cfreturn space /1024 / 1024 / 1024>
		</cfif>
	</cffunction>

	<cffunction name="getTotalSpace" output="false">
		<cfargument name="file">
		<cfargument name="unit" default="gb">
		<cfset var space=createObject("java", "java.io.File").init(arguments.file).getTotalSpace()>

		<cfif arguments.unit eq "byte">
			<cfreturn space>
		<cfelseif arguments.unit eq "kb">
			<cfreturn space /1024 >
		<cfelseif arguments.unit eq "mb">
			<cfreturn space /1024 / 1024>
		<cfelse>
			<cfreturn space /1024 / 1024 / 1024>
		</cfif>
	</cffunction>

	<cffunction name="getUsableSpace" output="false">
		<cfargument name="file">
		<cfargument name="unit" default="gb">
		<cfset var space=createObject("java", "java.io.File").init(arguments.file).getUsableSpace()>

		<cfif arguments.unit eq "byte">
			<cfreturn space>
		<cfelseif arguments.unit eq "kb">
			<cfreturn space /1024 >
		<cfelseif arguments.unit eq "mb">
			<cfreturn space /1024 / 1024>
		<cfelse>
			<cfreturn space /1024 / 1024 / 1024>
		</cfif>
	</cffunction>

	<cffunction name="chmod" output="false">
		<cfargument name="path">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">

		<cfif variables.useMode and application.configBean.getJavaEnabled()>
			<cftry>
				<cfif directoryExists(arguments.path)>
					<cfset createObject("java","java.lang.Runtime").getRuntime().exec("chmod -R #arguments.mode# #arguments.path#")>
				<cfelse>
					<cfset createObject("java","java.lang.Runtime").getRuntime().exec("chmod #arguments.mode# #arguments.path#")>
				</cfif>
				<cfcatch></cfcatch>
			</cftry>
		</cfif>
	</cffunction>

	<cffunction name="PathFormat" access="private" output="no" hint="Convert path into Windows or Unix format.">
		<cfargument name="path" required="yes" type="string" hint="The path to convert.">
		<cfset arguments.path = Replace(arguments.path, "\", "/", "ALL")>
		<cfreturn arguments.path>
	</cffunction>

	<cffunction name="fixQueryPaths" output="false">
		<cfargument name="rsDir">
		<cfargument name="path" default="directory">
		<cfloop query="rsDir">
			<cfset querySetCell(rsDir,arguments.path,pathFormat(rsDir[arguments.path][rsDir.currentrow]),rsDir.currentrow)>
		</cfloop>
		<cfreturn rsDir>
	</cffunction>

	<cffunction name="getDirectoryList" output="false">
		<cfargument name="directory">
		<cfargument name="filter" default="*">
		<cfargument name="type" default="all">
		<cfset var rs="">
		<cfdirectory directory="#arguments.directory#" filter="#arguments.filter#" type="#arguments.type#" name="rs" action="list">
		<cfreturn rs>
	</cffunction>

</cfcomponent>
