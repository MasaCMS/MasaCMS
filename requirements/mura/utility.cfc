<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" access="public" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfset variables.configBean=arguments.configBean />
<cfset variables.javaVersion=listGetAt(createObject("java", "java.lang.System").getProperty("java.version"),2,".") />
<cfreturn this />
</cffunction>

<cffunction name="displayErrors" access="public" output="true" returntype="string">
<cfargument name="error" type="struct" required="yes" default="#structnew()#"/>
<cfset var err=""/>
<cfif not structIsEmpty(arguments.error)>
<cfoutput>
<cfloop collection="#arguments.error#" item="err">
<strong>#structfind(arguments.error,err)#</strong><br/>
</cfloop><br/>
</cfoutput>
</cfif>
<cfreturn/>
</cffunction>

<cffunction name="getNextN" returntype="struct" access="public" output="false">
	<cfargument name="data" type="query" />
	<cfargument name="RecordsPerPage" type="numeric" />
	<cfargument name="startRow" type="numeric" />
	<cfargument name="pageBuffer" type="numeric" default="5" />
	<cfset var nextn=structnew() />
	
	<cfset nextn.TotalRecords=data.RecordCount>
	<cfset nextn.RecordsPerPage=arguments.RecordsPerPage> 
	<cfset nextn.NumberOfPages=Ceiling(nextn.TotalRecords/nextn.RecordsPerPage)>
	<cfset nextn.CurrentPageNumber=Ceiling(arguments.StartRow/nextn.RecordsPerPage)> 
	
	<cfif nextn.CurrentPageNumber gt arguments.pageBuffer>
		<cfset nextn.firstPage= nextn.CurrentPageNumber - arguments.pageBuffer />
	<cfelse>
		<cfset nextn.firstPage= 1 />
	</cfif>
	
	<cfset nextN.lastPage =nextn.firstPage + (2 * arguments.pageBuffer) + 1/>
	<cfif nextn.NumberOfPages lt nextN.lastPage>
		<cfset nextN.lastPage=nextn.NumberOfPages />
	</cfif>
	
	<cfset nextn.next=nextn.CurrentPageNumber+1 />
	<cfif nextn.next gt nextn.NumberOfPages>
		<cfset nextn.next=1 />
	</cfif>
	<cfset nextn.next=(nextn.next*nextN.recordsperpage) - nextn.RecordsPerPage +1 />
	
	<cfset nextn.previous=nextn.CurrentPageNumber-1 />
	<cfif nextn.previous lt 1>
		<cfset nextn.previous=1 />
	</cfif>
	<cfset nextn.previous=(nextn.previous*nextN.recordsperpage) - nextn.RecordsPerPage +1 />
	
	<cfset nextn.through=iif(nextn.totalRecords lt nextn.next,nextn.totalrecords,nextn.next-1)> 
	
	<cfreturn nextn />
</cffunction>

<cffunction name="filterArgs" access="public" returntype="struct" output="true">
<cfargument name="args" type="struct">
<cfargument name="badwords" type="string">
<cfset var str=structCopy(arguments.args)/>
<cfset var a=""/>

	<CFLOOP collection="#str#" item="a" >
	<cftry>
		<cfif str[a] neq "">
			<CFSET "str.#a#"  = REREplaceNoCase(evaluate("str.#a#"), arguments.badwords,  "****" ,  "ALL")/>
		</cfif>
	<cfcatch></cfcatch></cftry>
	</CFLOOP>

<cfreturn str />
</cffunction> 

<cffunction name="createRequiredSiteDirectories" returntype="void" output="false" access="public">
<cfargument name="siteid" type="string" default="" required="yes"/>
	
	<!--- make sure that the file cache directory exists, for node level files --->
	<cfif not directoryExists("#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteid##variables.configBean.getFileDelim()#cache#variables.configBean.getFileDelim()#component")> 
	
		<cfif not directoryExists("#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteid#")> 
			<cfdirectory action="create" mode="775" directory="#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteid#"> 
		</cfif>
	
		<cfif not directoryExists("#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteid##variables.configBean.getFileDelim()#cache")> 
			<cfdirectory action="create" mode="775" directory="#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteid##variables.configBean.getFileDelim()#cache"> 
		</cfif>
	
		<cfdirectory action="create" mode="775" directory="#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteid##variables.configBean.getFileDelim()#cache#variables.configBean.getFileDelim()#component">
		<cfdirectory action="create" mode="775" directory="#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteid##variables.configBean.getFileDelim()#cache#variables.configBean.getFileDelim()#file"> 
	</cfif>
	
	<!--- make sure that the asset directory exists, for fckeditor assets --->
	<cfif not directoryExists("#variables.configBean.getAssetDir()##variables.configBean.getFileDelim()##arguments.siteid##variables.configBean.getFileDelim()#assets")> 
			<cfdirectory action="create" mode="775" directory="#variables.configBean.getAssetDir()##variables.configBean.getFileDelim()##arguments.siteid##variables.configBean.getFileDelim()#assets"> 
	</cfif>
	
</cffunction>

<cffunction name="logEvent" returntype="void" output="false" access="public">
<cfargument name="text" type="string" default="" required="yes"/>
<cfargument name="file" type="string" default="" required="yes"/>
<cfargument name="type" type="string" default="Information" required="yes"/>
<cfargument name="application" type="boolean" default="true" required="yes"/>

<cfset var msg=arguments.text />
<cfset var user = "Anonymous" />

<cfif isBoolean(variables.configBean.getLogEvents()) and variables.configBean.getLogEvents()>
<cfif session.mura.isLoggedIn>
<cfset user=session.mura.fname & " " & session.mura.lname />
</cfif>

<cfset msg="#msg# By #user# from #cgi.REMOTE_ADDR#" />

	<cflog 
		text="#msg#"
		file="#arguments.file#"
		type="#arguments.type#"
		application="#arguments.application#">
</cfif>
</cffunction>

<cffunction name="backUp" access="public" output="false" returntype="void">

	<cfif cgi.HTTP_REFERER neq ''>
		<cflocation url="#cgi.HTTP_REFERER#" addtoken="no">
	<cfelse>
		<cflocation url="index.cfm" addtoken="no">
	</cfif>

</cffunction>

<cffunction name="copyDir" returnType="any" output="false">
	<cfargument name="baseDir" default="" required="true" />
	<cfargument name="destDir" default="" required="true" />
	<cfset var rs = "" />
	<cfset var errors=arrayNew(1)>
	<cfset var copyItem="">
	
	<cfdirectory directory="#arguments.baseDir#" name="rs" action="list" recurse="true" />
	<!--- filter out Subversion hidden folders --->
	<cfquery name="rs" dbtype="query">
	SELECT * FROM rs
	WHERE directory NOT LIKE '%#variables.configBean.getFileDelim()#.svn%'
	AND name <> '.svn'
	</cfquery>
	
	<cfset copyItem=arguments.destDir>
	<cftry>
		<cfdirectory action="create" mode="775" directory="#copyItem#" />
		<cfcatch><cfset arrayAppend(errors, copyItem)></cfcatch>
	</cftry>
	
	<cfloop query="rs">
		<cfif rs.type eq "dir">
			<cfset copyItem="#replace('#rs.directory##variables.configBean.getFileDelim()#',arguments.baseDir,arguments.destDir)##rs.name##variables.configBean.getFileDelim()#">
			<cftry>
				<cfdirectory action="create" mode="775" directory="#copyItem#" />
				<cfcatch><cfset arrayAppend(errors, copyItem)></cfcatch>
			</cftry>
		<cfelse>
		<cfset copyItem="#replace('#rs.directory##variables.configBean.getFileDelim()#',arguments.baseDir,arguments.destDir)#">
			<cftry>
				<cffile action="copy" mode="775" source="#rs.directory##variables.configBean.getFileDelim()##rs.name#" destination="#copyItem#" />
				<cfcatch><cfset arrayAppend(errors, copyItem)></cfcatch>
			</cftry>
		</cfif>
	</cfloop>
	<cfreturn errors>
</cffunction>

<cffunction name="deleteDir">
	<cfargument name="baseDir" default="" required="yes">
	<cfset var rs=""/>
	<cfdirectory directory="#baseDir#" name="rs" action="delete" recurse="yes">
	
</cffunction>

<cffunction name="arrayFind" returntype="numeric">
	<cfargument name="array" required="yes" type="array">
	<cfargument name="stringa" required="yes" type="string">
		<cfset var i=0>
		
		<cfif stringa is "">
		<cfreturn i>
		</cfif>
		
		<cfloop index="i" from="1" to="#arrayLen(array)#">
		<cfif array[i] is stringa>
		<cfreturn i>
		</cfif>
		</cfloop>
	
	<cfreturn i>
</cffunction>

<cffunction name="joinArrays" returntype="any" output="false">
	<cfargument name="array1">
	<cfargument name="array2">
	<cfset var i="">
	<cfif arrayLen(array2)>
		<cfloop from="1" to="#arrayLen(array2)#" index="i">
			<cfset arrayAppend(array1,array2[i])>
		</cfloop>
	</cfif>
	<cfreturn array1 />
</cffunction>

<cffunction name="createRedirectID" access="public" returntype="string" output="false">
	<cfargument name="theLink" required="true">
	<cfset var redirectID= createUUID() />
	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into tredirects (redirectID,URL,created) values(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#redirectID#" >,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.theLink#" >,
		#createODBCDateTime(now())#
		)
	</cfquery>
	
	<cfreturn redirectID />
</cffunction>

<cffunction name="getUUID" output="false" returntype="string">
	<cfset var u=""/>
	<cfif variables.configBean.getCompiler() eq "Adobe" and variables.javaVersion gte 5>
	<cfset u = ucase(createObject("java","java.util.UUID").randomUUID().toString()) />
	<cfset u = listToArray(u,"-") />
	<cfset u[4]=u[4] & u[5] />
	<cfset arrayDeleteAt(u,5) />
	<cfreturn arrayToList(u,"-") />
	<cfelse>
		<cfreturn createUUID() />
	</cfif>
</cffunction>

<cffunction name="fixLineBreaks" output="false" returntype="string">
<cfargument name="str">
	<cfset arguments.str=replace(arguments.str,chr(13),"","all")>
	<cfset arguments.str=replace(arguments.str,chr(10),chr(13) & chr(10),"all")>
	<cfreturn arguments.str>
</cffunction>

<cffunction name="isHTTPS" output="false" returnType="boolean">
	<cfif len(cgi.HTTPS) and listFindNoCase("Yes,On,True",cgi.HTTPS)>
		<cfreturn true>
	<cfelseif isBoolean(cgi.SERVER_PORT_SECURE) and cgi.SERVER_PORT_SECURE>
		<cfreturn true>
	<cfelseif len(cgi.SERVER_PORT) and cgi.SERVER_PORT eq "443">
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="listFix" output="false" returntype="any">
<cfargument name="list">
<cfscript>
/**
* Fixes a list by replacing null entries.
* This is a modified version of the ListFix UDF
* written by Raymond Camden. It is significantly
* faster when parsing larger strings with nulls.
* Version 2 was by Patrick McElhaney (pmcelhaney@amcity.com)
*
* @param list      The list to parse. (Required)
* @param delimiter      The delimiter to use. Defaults to a comma. (Optional)
* @param null      Null string to insert. Defaults to "NULL". (Optional)
* @return Returns a list.
* @author Steven Van Gemert (pmcelhaney@amcity.comsvg2@placs.net)
* @version 3, July 31, 2004
*/
var delim = ",";
var null = "NULL";
var special_char_list = "\,+,*,?,.,[,],^,$,(,),{,},|,-";
var esc_special_char_list = "\\,\+,\*,\?,\.,\[,\],\^,\$,\(,\),\{,\},\|,\-";
var i = "";

if(arrayLen(arguments) gt 1) delim = arguments[2];
if(arrayLen(arguments) gt 2) null = arguments[3];

if(findnocase(left(list, 1),delim)) list = null & list;
if(findnocase(right(list,1),delim)) list = list & null;

i = len(delim) - 1;
while(i GTE 1){
    delim = mid(delim,1,i) & "_Separator_" & mid(delim,i+1,len(delim) - (i));
    i = i - 1;
}

delim = ReplaceList(delim, special_char_list, esc_special_char_list);
delim = Replace(delim, "_Separator_", "|", "ALL");

list = rereplace(list, "(" & delim & ")(" & delim & ")", "\1" & null & "\2", "ALL");
list = rereplace(list, "(" & delim & ")(" & delim & ")", "\1" & null & "\2", "ALL");
    
return list;
</cfscript>
</cffunction>

</cfcomponent>