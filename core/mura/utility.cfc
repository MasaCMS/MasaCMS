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

<cfcomponent extends="mura.cfobject" output="false" hint="This provides global utility methods">

<cffunction name="init" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="fileWriter" type="any" required="yes"/>
<cfset variables.configBean=arguments.configBean />
<cfset variables.fileWriter=arguments.fileWriter />

<cfreturn this >
</cffunction>

<cffunction name="getBCrypt" output="false">
	<cfif not isDefined('variables.bCrypt')>
		<cfif variables.configBean.getValue(property='legacyJavaLoader',defaultValue=false)>
			<cfset variables.bCrypt=getBean("javaLoader").create("BCrypt")>
		<cfelse>
			<cfset variables.bCrypt=createObject("java","BCrypt")>
		</cfif>
	</cfif>
	<cfreturn variables.bCrypt>
</cffunction>


<cffunction name="displayErrors" output="true">
<cfargument name="error" type="struct" required="yes" default="#structnew()#"/>
<cfset var err=""/>
<cfset var started=false>
<cfset var ct = 1>
<cfloop collection="#arguments.error#" item="err">
	<cfif err neq "siteID">
		<cfset started=true>
		<cfoutput>#structfind(arguments.error,err)#</cfoutput>
		<cfif structCount(arguments.error) gt ct><br></cfif>
	</cfif>
	<cfset ct += 1>
</cfloop>
</cffunction>

<cffunction name="getNextN" returntype="struct" output="false">
	<cfargument name="data" />
	<cfargument name="RecordsPerPage" type="numeric" />
	<cfargument name="startRow" type="numeric" />
	<cfargument name="pageBuffer" type="numeric" default="5" />
	<cfset var nextn=structnew() />

	<cfif isNumeric(arguments.data)>
		<cfset nextn.TotalRecords=arguments.data>
	<cfelse>
		<cfset nextn.TotalRecords=arguments.data.RecordCount>
	</cfif>

	<cfset nextn.RecordsPerPage=arguments.RecordsPerPage>
	<cfset nextn.NumberOfPages=Ceiling(nextn.TotalRecords/nextn.RecordsPerPage)>
	<cfset nextn.CurrentPageNumber=Ceiling(arguments.StartRow/nextn.RecordsPerPage)>

	<cfif nextn.CurrentPageNumber gt arguments.pageBuffer>
		<cfset nextn.firstPage= nextn.CurrentPageNumber - arguments.pageBuffer />
	<cfelse>
		<cfset nextn.firstPage= 1 />
	</cfif>

	<cfset nextN.lastPage =nextn.firstPage + (2 * arguments.pageBuffer)/>

	<cfif nextn.NumberOfPages lt nextN.lastPage>
		<cfset nextN.lastPage=nextn.NumberOfPages />
	</cfif>

	<cfif (nextn.lastPage - nextn.firstPage) lt (2 * arguments.pageBuffer)>
 		<cfset nextn.firstPage = max(1, nextn.lastPage - (2 * arguments.pageBuffer)) />
 	</cfif>

	<cfset nextn.next = ((nextn.CurrentPageNumber+1)*nextN.recordsperpage) - nextn.RecordsPerPage +1 />

	<cfset nextn.previous=nextn.CurrentPageNumber-1 />

	<cfif nextn.previous lt 1>
		<cfset nextn.previous=1 />
	</cfif>

	<cfset nextn.previous=(nextn.previous*nextN.recordsperpage) - nextn.RecordsPerPage +1 />

	<cfset nextn.through=iif(nextn.totalRecords lt nextn.next,nextn.totalrecords,nextn.next-1)>

	<cfif nextn.next gt nextn.totalrecords>
		<cfset nextn.next=1 />
	</cfif>

	<cfset nextn.startrow=arguments.startrow>

	<cfreturn nextn />
</cffunction>

<cffunction name="filterArgs" returntype="struct" output="true">
<cfargument name="args" type="struct">
<cfargument name="badwords" type="string">
<cfset var str=structCopy(arguments.args)/>
<cfset var a=""/>

	<CFLOOP collection="#str#" item="a" >
	<cftry>
		<cfif str[a] neq "">
			<CFSET "str.#a#"  = replaceNoCase(str[a], arguments.badwords,  "****" ,  "ALL")/>
		</cfif>
	<cfcatch></cfcatch></cftry>
	</CFLOOP>

<cfreturn str />
</cffunction>

<cffunction name="createRequiredSiteDirectories" output="false">
<cfargument name="siteid" type="string" default="" required="yes"/>
<cfargument name="displaypoolid" type="string" default="" required="yes"/>
	<cfset var webroot=expandPath('/muraWRM')>

	<!--- make sure that the file cache directory exists, for node level files --->
	<cfif not directoryExists("#variables.configBean.getFileDir()#/#arguments.siteid#/cache/file")>

		<cfif not directoryExists("#variables.configBean.getFileDir()#/#arguments.siteid#")>
			<cfset variables.fileWriter.createDir(directory="#variables.configBean.getFileDir()#/#arguments.siteid#")>
		</cfif>

		<cfif not directoryExists("#variables.configBean.getFileDir()#/#arguments.siteid#/cache")>
			<cfset variables.fileWriter.createDir(directory="#variables.configBean.getFileDir()#/#arguments.siteid#/cache")>
		</cfif>

		<cfset variables.fileWriter.createDir(directory="#variables.configBean.getFileDir()#/#arguments.siteid#/cache/file")>
	</cfif>

	<!--- make sure that the asset directory exists, for fckeditor assets --->
	<cfif not directoryExists("#variables.configBean.getAssetDir()#/#arguments.siteid#/assets")>
		<cfset variables.fileWriter.createDir(directory="#variables.configBean.getAssetDir()#/#arguments.siteid#/assets")>
	</cfif>

	<cfif variables.configBean.getSiteIDInURLS() and not fileExists("#variables.configBean.getSiteDir()#/#arguments.siteid#/index.cfm")>
		<cfset variables.fileWriter.copyFile(source="#webroot#/core/templates/site/index.template.cfm", destination="#variables.configBean.getSiteDir()#/#arguments.siteid#/index.cfm")>
	</cfif>

	<!--- Double checking that it sees the new property on autoupdated instances--->
	<cfif len(variables.configBean.getSiteDir())>
		<cfif directoryExists('#variables.configBean.getSiteDir()#/#arguments.siteid#/includes')>
			<cfset basedir="#variables.configBean.getSiteDir()#/#arguments.siteid#/includes">
		<cfelse>
			<cfset basedir="#variables.configBean.getSiteDir()#/#arguments.siteid#">
		</cfif>

		<cfif not directoryExists(basedir) and arguments.displaypoolid neq arguments.siteid>
			<cfif directoryExists('#variables.configBean.getSiteDir()#/#arguments.displaypoolid#/includes')>
				<cfset basedir="#variables.configBean.getSiteDir()#/#arguments.displaypoolid#/includes">
			<cfelse>
				<cfset basedir="#variables.configBean.getSiteDir()#/#arguments.displaypoolid#">
			</cfif>
		</cfif>
	<cfelse>
		<cfset var basedir="#webroot#/#arguments.siteid#/includes">

		<cfif not directoryExists(basedir) and arguments.displaypoolid neq arguments.siteid>
			<cfset basedir="#webroot#/#arguments.displaypoolid#/includes">
		</cfif>
	</cfif>

	<cfif not directoryExists(basedir)>
		<cfset variables.fileWriter.createDir(directory=basedir)>
	</cfif>

	<cfif not fileExists("#basedir#/contentRenderer.cfc")>
		<cfset variables.fileWriter.copyFile(source="#webroot#/core/templates/site/contentRenderer.template.cfc", destination="#basedir#/contentRenderer.cfc")>
	</cfif>

	<cfif listLast(variables.configBean.getSiteDir(),'/\') neq 'sites' and  not fileExists("#basedir#/Application.cfc")>
		<cfset variables.fileWriter.copyFile(source="#webroot#/core/templates/site/application.depth2.template.cfc", destination="#basedir#/Application.cfc")>
	</cfif>

	<cfif not fileExists("#basedir#/eventHandler.cfc")>
		<cfset variables.fileWriter.copyFile(source="#webroot#/core/templates/site/eventHandler.template.cfc", destination="#basedir#/eventHandler.cfc")>
	</cfif>

	<cfif getBean('configBean').getEmailBroadcaster()>
		<cfif not directoryExists("#basedir#/email")>
			<cfset variables.fileWriter.createDir(directory="#basedir#/email")>
		</cfif>

		<cfif not fileExists("#basedir#/email/inc_email.cfm")>
			<cfset variables.fileWriter.copyFile(source="#webroot#/core/templates/site/email.template.cfm", destination="#basedir#/email/inc_email.cfm")>
		</cfif>
	</cfif>

</cffunction>

<cffunction name="logEvent" output="false">
<cfargument name="text" type="string" default="" required="yes"/>
<cfargument name="file" type="string" default="" required="yes"/>
<cfargument name="type" type="string" default="Information" required="yes"/>
<cfargument name="application" type="boolean" default="true" required="yes"/>

<cfset var msg=arguments.text />
<cfset var user = "Anonymous" />
<cfset var remoteAddr = StructKeyExists(request, 'remoteAddr') ? request.remoteAddr : CGI.REMOTE_ADDR />
<cfset var sessionData=getSession()>

<cfif isBoolean(variables.configBean.getLogEvents()) and variables.configBean.getLogEvents() and isdefined('sessionData.mura')>
	<cfif sessionData.mura.isLoggedIn>
		<cfset user=sessionData.mura.fname & " " & sessionData.mura.lname />
	</cfif>

	<cfset msg="#msg# By #user# from #remoteAddr#" />

	<cflog
		text="#msg#"
		file="#arguments.file#"
		type="#arguments.type#"
		application="#arguments.application#">
</cfif>
</cffunction>

<cffunction name="backUp" output="false">

	<cfif cgi.HTTP_REFERER neq ''>
		<cflocation url="#cgi.HTTP_REFERER#" addtoken="no">
	<cfelse>
		<cflocation url="./" addtoken="no">
	</cfif>

</cffunction>

<cffunction name="copyDir" output="false">
	<cfargument name="baseDir" default="" required="true" />
	<cfargument name="destDir" default="" required="true" />
	<cfargument name="excludeList" default="" required="true" />
	<cfargument name="sinceDate" default="" required="true" />
	<cfargument name="excludeHiddenFiles" default="true" required="true" />
	<cfreturn variables.fileWriter.copyDir(argumentCollection=arguments)>
</cffunction>

<cffunction name="deleteDir">
	<cfargument name="baseDir" default="" required="yes">
	<cfset var rs=""/>
	<cfdirectory directory="#baseDir#" name="rs" action="delete" recurse="yes">

</cffunction>

<cffunction name="createDir">
	<cfargument name="baseDir" default="" required="yes">
	<cfset variables.fileWriter.createDir(directory=arguments.baseDir)>
</cffunction>

<cffunction name="arrayFind">
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

<cffunction name="joinArrays" output="false">
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

<cffunction name="createRedirectID" output="false">
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


<!--- deprecated, just user createUUID() --->
<cffunction name="getUUID" output="false">
	<cfreturn createUUID() />
</cffunction>

<cffunction name="fixLineBreaks" output="false">
<cfargument name="str">
	<cfset arguments.str=replace(arguments.str,chr(13),"","all")>
	<cfset arguments.str=replace(arguments.str,chr(10),chr(13) & chr(10),"all")>
	<cfreturn arguments.str>
</cffunction>

<cffunction name="isHTTPS" output="false" returnType="boolean">
	<cfreturn getRequestProtocol() eq 'https'>
</cffunction>

<cffunction name="getRequestHost" output="false">
	<cfset var headers=getHttpRequestData().headers>

	<cfif StructKeyExists(headers,"X-Forwarded-Host") and len(headers["X-Forwarded-Host"])>
		<cfreturn headers["X-Forwarded-Host"]>
	<cfelseif len(cgi.http_host)>
		<cfreturn cgi.http_host>
	<cfelse>
		<cfreturn cgi.server_name>
	</cfif>

</cffunction>

<cffunction name="getRemoteIP" output="false">
	<cfset var headers=getHttpRequestData().headers>

	<cfif StructKeyExists(headers,"X-Forwarded-For") and len(headers["X-Forwarded-For"])>
		<cfreturn headers["X-Forwarded-Host"]>
	<cfelse>
		<cfreturn cgi.Remote_Addr>
	</cfif>

</cffunction>

<cffunction name="getRequestProtocol" output="false">
	<cftry>
		<cfset var headers=getHttpRequestData().headers>

		<cfif StructKeyExists(headers,"X-Forwarded-Proto") and headers["X-Forwarded-Proto"] eq "https">
		    <cfreturn "https">
		<cfelseif StructKeyExists(headers,"Front-End-Https") and isBoolean(headers["Front-End-Https"]) and headers["Front-End-Https"]>
			<cfreturn "https">
		<cfelse>
		    <cfreturn getPageContext().getRequest().getScheme()>
		</cfif>

		<cfcatch>
			<!--- Legacy --->
			<cfif len(cgi.HTTPS) and listFindNoCase("Yes,On,True",cgi.HTTPS)>
				<cfreturn "https">
			<cfelseif isBoolean(cgi.SERVER_PORT_SECURE) and cgi.SERVER_PORT_SECURE>
				<cfreturn "https">
			<cfelseif len(cgi.SERVER_PORT) and cgi.SERVER_PORT eq "443">
				<cfreturn "https">
			<cfelse>
				<cfreturn "http">
			</cfif>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="listFix" output="false">
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
var nullString = "NULL";
var special_char_list = "\,+,*,?,.,[,],^,$,(,),{,},|,-";
var esc_special_char_list = "\\,\+,\*,\?,\.,\[,\],\^,\$,\(,\),\{,\},\|,\-";
var i = "";

if(arrayLen(arguments) gt 1) delim = arguments[2];
if(arrayLen(arguments) gt 2) nullString = arguments[3];

if(findnocase(left(list, 1),delim)) list = nullString & list;
if(findnocase(right(list,1),delim)) list = list & nullString;

i = len(delim) - 1;
while(i GTE 1){
    delim = mid(delim,1,i) & "_Separator_" & mid(delim,i+1,len(delim) - (i));
    i = i - 1;
}

delim = ReplaceList(delim, special_char_list, esc_special_char_list);
delim = Replace(delim, "_Separator_", "|", "ALL");

list = rereplace(list, "(" & delim & ")(" & delim & ")", "\1" & nullString & "\2", "ALL");
list = rereplace(list, "(" & delim & ")(" & delim & ")", "\1" & nullString & "\2", "ALL");

return list;
</cfscript>
</cffunction>

<cffunction name="cfformprotect" output="false">
	<cfargument name="event">
	<cfset var cffp=CreateObject("component","cfformprotect.cffpVerify").init()>
	<cfset var result=false>
	<cfif len(event.getSite().getExtranetPublicRegNotify())>
		<cfset cffp.updateConfig('emailServer', event.getSite().getMailServerIP())>
		<cfset cffp.updateConfig('emailUserName', event.getSite().getMailserverUsername(true))>
		<cfset cffp.updateConfig('emailPassword', event.getSite().getMailserverPassword())>
		<cfset cffp.updateConfig('emailFromAddress', event.getSite().getMailserverUsernameEmail())>
		<cfset cffp.updateConfig('emailToAddress', event.getSite().getExtranetPublicRegNotify())>
		<cfset cffp.updateConfig('emailSubject', 'Spam form submission')>
	</cfif>
	<cfreturn cffp.testSubmission(event.getAllValues())>
</cffunction>

<cffunction name="arrayToQuery" output="false">
<cfargument name="array" type="array" required="yes"/>
<cfscript>
var r = 0;
var c = 0;
var myArray = ArrayNew(1);
var myStruct = StructNew();
var myQuery = QueryNew( "" );
var colName = ArrayNew(1);
var colCount = 0;
var recCount = 0;
var columnList = "";

myArray = arguments.array;
myStruct = myArray[1];
colName = StructKeyArray( myStruct );
colCount = ArrayLen( colName );
columnList = ArrayToList( colName );
recCount = ArrayLen( myArray );
myQuery = QueryNew( columnList );

QueryAddRow( myQuery , recCount );
for( r = 1 ; r LTE recCount ; r = r + 1 ) {
for( c = 1 ; c LTE colCount ; c = c + 1 ) {
QuerySetCell( myQuery , colName[ c ] , myArray[ r ][colName[ c ] ] , r );
}
}
</cfscript>
<cfreturn myQuery />
</cffunction>

<cfscript>
	function queryRowToArray( qry,i ) {
		var row = 1;
		var ii = 1;
		var cols = listToArray(arguments.qry.columnList);
		var aReturn = [];

		if(arrayLen(arguments) GT 1)
			row = arguments[2];

		for(ii = 1; ii lte arraylen(cols); ii = ii + 1) {
			ArrayAppend(aReturn,arguments.qry[cols[ii]][row]);
		}

		return aReturn;
	}

	function queryToStruct( qry ) {

		var str = {};

		for(var i = 1;i <= qry.recordcount;i++) {
			str[i] = queryRowToStruct( qry,i);
		}

		return str;
	}

	function queryToArray( qry,primarykey="" ) {

		var arr = [];

		for(var i = 1;i <= qry.recordcount;i++) {
			ArrayAppend(arr,queryRowToStruct( qry,i,primarykey) );
		}

		return arr;
	}
</cfscript>

<cffunction name="queryRowToStruct" output="false" returntype="struct">
	<cfargument name="qry" type="query" required="true">

		<cfscript>
			/**
			 * Makes a row of a query into a structure.
			 *
			 * @param query 	 The query to work with.
			 * @param row 	 Row number to check. Defaults to row 1.
			 * @return Returns a structure.
			 * @author Nathan Dintenfass (nathan@changemedia.com)
			 * @version 1, December 11, 2001
			 */
			//by default, do this to the first row of the query
			var row = 1;
			//a var for looping
			var ii = 1;
			//the cols to loop over
			var cols = listToArray(arguments.qry.columnList);
			//the struct to return
			var stReturn = structnew();
			//if there is a second argument, use that for the row number
			if(arrayLen(arguments) GT 1)
				row = arguments[2];
			//loop over the cols and build the struct from the query row
			for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
				stReturn[cols[ii]] = arguments.qry[cols[ii]][row];
			}
			//return the struct
			return stReturn;
		</cfscript>
</cffunction>

<!---
Author: John Mason, mason@fusionlink.com
Blog: www.codfusion.com--->
<cffunction name="isValidCFVariableName" output="false">
	<cfargument name="text" required="true" type="String">
	<cfset var local = StructNew()/>
	<cfset local.result = true/>

	<cfif len(arguments.text) eq 0>
		<cfset local.result = false/>
	<cfelseif FindNoCase(".",arguments.text) gt 0>
		<cfset local.result = false/>
	<cfelseif FindNoCase(" ",arguments.text) gt 0>
		<cfset local.result = false/>
	<cfelseif ReFindNoCase("^[A-Za-z][A-Za-z0-9_]*",arguments.text) eq 0>
		<cfset local.result = false/>
	</cfif>

	<cfreturn local.result/>
</cffunction>

<cffunction name="setSessionCookies" output="false">
	<cfargument name="reset" default="#application.configBean.getManageSessionCookies()#">

	<!---<cfif application.configBean.getSecureCookies() or application.configBean.getSessionCookiesExpires() neq 'never' or len(application.configBean.getCookieDomain())>--->
		<!---<cftry>--->
			<cfset var sessionData=getSession()>

			<cftry>
				<cfset var hasURLToken=len(sessionData.urlToken)>
				<cfcatch>
					<cfset var hasURLToken=false>
				</cfcatch>
			</cftry>

			<cfif hasURLToken>
				<cfset var sessionTokens={}>

				<cfloop list="#sessionData.urlToken#" index="local.item" delimiters="&">
					<cfset local.key=listFirst(local.item,"=")>
					<cfset sessionTokens["#local.key#"]=listLast(local.item,"=")>
				</cfloop>
			<cfelse>
				<cfreturn>
			</cfif>

			<cfif isDefined('sessionTokens.cfid') and (isBoolean(arguments.reset) and arguments.reset or not isDefined('cookie.cfid'))>
				<!--- Lucee uses lowercase cookies the setCookieLegacy method allows it to maintain case--->
				<cfif server.coldfusion.productname neq 'Coldfusion Server'>
					<cfif application.configBean.getSessionCookiesExpires() EQ "" OR application.configBean.getSessionCookiesExpires() EQ "session" OR application.configBean.getSessionCookiesExpires() EQ "session only">
						<cfset setCookieLegacy(name='cfid', value=sessionTokens.CFID, maintainCase=true)>
						<cfset setCookieLegacy(name='cftoken', value=sessionTokens.CFTOKEN, maintainCase=true)>
					<cfelse>
						<cfset setCookieLegacy(name='cfid', value=sessionTokens.CFID, expires=application.configBean.getSessionCookiesExpires(), maintainCase=true)>
						<cfset setCookieLegacy(name='cftoken', value=sessionTokens.CFTOKEN, expires=application.configBean.getSessionCookiesExpires(), maintainCase=true)>
					</cfif>
				<cfelse>
					<cfif application.configBean.getSessionCookiesExpires() EQ "" OR application.configBean.getSessionCookiesExpires() EQ "session" OR application.configBean.getSessionCookiesExpires() EQ "session only">
						<cfset setCookieLegacy(name="CFID", value=sessionTokens.CFID) />
						<cfset setCookieLegacy(name="CFTOKEN", value=sessionTokens.CFTOKEN)/>
					<cfelse>
						<cfset setCookieLegacy(name="CFID", value=sessionTokens.CFID, expires=application.configBean.getSessionCookiesExpires()) />
						<cfset setCookieLegacy(name="CFTOKEN", value=sessionTokens.CFTOKEN, expires=application.configBean.getSessionCookiesExpires()) />
					</cfif>
				</cfif>
			</cfif>

			<cfif isDefined('sessionTokens.jsessionid') and (isBoolean(arguments.reset) and arguments.reset or not isDefined('cookie.jsessionid'))>
				<cfif application.configBean.getSessionCookiesExpires() EQ "" OR application.configBean.getSessionCookiesExpires() EQ "session">
					<cfset setCookieLegacy(name="JSESSIONID", value=sessionTokens.jsessionid) />
				<cfelse>
					<cfset setCookieLegacy(name="JSESSIONID", value=sessionTokens.jsessionid, expires=application.configBean.getSessionCookiesExpires()) />
				</cfif>
			</cfif>
		<!---<cfcatch></cfcatch>
		</cftry>--->
	<!---</cfif>--->
</cffunction>

<cffunction name="deleteCookie" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="maintainCase" type="boolean" default="true">
	<cfset structDelete(cookie,arguments.name)>
	<cfset arguments.expires="0">
	<cfset arguments.value="">
	<cfset setCookieLegacy(argumentCollection=arguments)>
	<cfreturn this>
</cffunction>

<cffunction name="setCookie" output="false">
  <cfargument name="name" type="string" required="true">
  <cfargument name="value" type="string" required="true">
	<cfargument name="expires" type="string" default="never">
  <cfargument name="maintainCase" type="boolean" default="true">
	<cfargument name="httpOnly" type="boolean" default="true">

	<cfif variables.configBean.getSecureCookies()>
		<cfset arguments.secure=true>
	</cfif>

	<cfif len(variables.configBean.getCookieDomain())>
		<cfset arguments.domain=variables.configBean.getCookieDomain()>
	</cfif>

	<cfif len(variables.configBean.getCookiePath()) and len(variables.configBean.getCookieDomain())>
		<cfset arguments.path=variables.configBean.getCookiePath()>
	<cfelseif len(variables.configBean.getCookieDomain()) and variables.configBean.getCompiler() eq 'Lucee'>
		<cfset arguments.path="/">
	</cfif>

	<cfset arguments.preserveCase=arguments.maintainCase>

	<cfif not (
			isDate(arguments.expires)
			or isNumeric(arguments.expires)
			or listFindNoCase('session only,now,never',arguments.expires)
		)>
		<cfset structDelete(arguments,'expires')>
	</cfif>

	<cfset structDelete(arguments,'path')>

	<cfif application.cfversion gt 9>
		<cfcookie attributeCollection="#arguments#" />
	<cfelse>
		<cfset setCookieLegacy(argumentCollection=arguments)>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="setCookieLegacy" hint="Replacement for cfcookie that handles httponly cookies" output="false" returntype="void">
    <cfargument name="name" type="string" required="true">
    <cfargument name="value" type="string" required="true">
    <cfargument name="expires" type="any" default="" hint="''=session only|now|never|[date]|[number of days]">
    <cfargument name="domain" type="string" default="">
    <cfargument name="path" type="string" default="/">
    <cfargument name="secure" type="boolean" default="false">
    <cfargument name="httponly" type="boolean" default="true">
    <cfargument name="maintainCase" type="boolean" default="false">
    <cfset var c = "">
    <cfset var expDate = "">

	<cfif variables.configBean.getSecureCookies()>
		<cfset arguments.secure=true>
	</cfif>

	<cfif len(variables.configBean.getCookieDomain())>
		<cfset arguments.domain=variables.configBean.getCookieDomain()>
	</cfif>

	<cfif len(variables.configBean.getCookiePath()) and len(variables.configBean.getCookieDomain())>
		<cfset arguments.path=variables.configBean.getCookiePath()>
	<cfelseif len(variables.configBean.getCookieDomain())>
		<cfset arguments.path="/">
	</cfif>

	<cfif arguments.maintainCase>
		<cfset c = "#name#=#value#;">
	<cfelseif server.coldfusion.productname eq "BlueDragon">
		<cfset c = "#LCase(name)#=#value#;">
	<cfelse>
		<cfset c = "#UCase(name)#=#value#;">
	</cfif>

    <cfswitch expression="#Arguments.expires#">
        <cfcase value="">
        </cfcase>
        <cfcase value="now">
            <cfset expDate = DateAdd('d',-1,Now())>
        </cfcase>
        <cfcase value="never">
            <cfset expDate = DateAdd('yyyy',30,Now())>
        </cfcase>
        <cfdefaultcase>
            <cfif IsDate(Arguments.expires)>
                <cfset expDate = Arguments.expires>
            <cfelseif IsNumeric(Arguments.expires)>
                <cfset expDate = DateAdd('d',Arguments.expires,Now())>
            </cfif>
        </cfdefaultcase>
    </cfswitch>
    <cfif IsDate(expDate) gt 0>
        <cfset expDate = DateConvert('local2Utc',expDate)>
        <cfset c = c & "expires=#DateFormat(expDate, 'ddd, dd-mmm-yyyy')# #TimeFormat(expDate, 'HH:mm:ss')# GMT;">
    </cfif>
    <cfif Len(Arguments.domain) gt 0>
        <cfset c = c & "domain=#Arguments.domain#;">
    </cfif>
    <cfif Len(Arguments.path) gt 0>
        <cfset c = c & "path=#Arguments.path#;">
    </cfif>
    <cfif Arguments.secure>
        <cfset c = c & "secure;">
    </cfif>
    <cfif Arguments.httponly>
        <cfset c = c & "HttpOnly;">
    </cfif>
    <cfheader name="SET-COOKIE" value="#c#" />
</cffunction>

<cffunction name="fixQueryPaths" output="false">
	<cfargument name="rsDir">
	<cfargument name="path" default="directory">
	<cfloop query="rsDir">
		<cfset querySetCell(rsDir,arguments.path,pathFormat(rsDir[arguments.path][rsDir.currentrow]),rsDir.currentrow)>
	</cfloop>
	<cfreturn rsDir>
</cffunction>

<cffunction name="getCryptoSalt" output="false">
    <cfargument name="logRounds" default="#variables.configBean.getBCryptLogRounds()#">
    <cfargument name="reseedFrequency" default="#variables.configBean.getBCryptReseedFrequency()#" hint="How often to re-seed." >
    <cfif structKeyExists(variables, "cryptoSaltSct") >

            <cfset var minutesSinceSaltCreated =
                    dateDiff(
                            "n",
                            variables.cryptoSaltSct.dateTimeCreated,
                            now()
                    )
            />

            <cfif minutesSinceSaltCreated GTE reseedFrequency >
                    <cfset this.setCryptoSalt(arguments.logRounds) />
            </cfif>

    <cfelse>

            <cfset this.setCryptoSalt(arguments.logRounds) />

    </cfif>

    <cfreturn variables.cryptoSaltSct.salt />

</cffunction>

<cffunction name="setCryptoSalt" output="true" >
        <cfargument name="logRounds" default="#variables.configBean.getBCryptLogRounds()#">
        <cfset variables.cryptoSaltSct.salt =
                getBCrypt().gensalt(JavaCast('int',arguments.logRounds))
        />
        <cfset variables.cryptoSaltSct.dateTimeCreated = now() />
</cffunction>

<cffunction name="toBCryptHash" output="false">
        <cfargument name="string">
        <cfargument name="logRounds" default="#variables.configBean.getBCryptLogRounds()#">
        <cfset var hash = getBCrypt().hashpw(JavaCast('string',arguments.string), this.getCryptoSalt(logRounds=arguments.logRounds) )>
        <cfreturn hash >
</cffunction>

<cffunction name="checkBCryptHash" output="false">
        <cfargument name="string">
        <cfargument name="hash">
        <cfset var match = "" />
        <cftry>
        <cfset match = getBCrypt().checkpw(JavaCast('string',arguments.string), JavaCast('string',arguments.hash))>
        <cfcatch>
                <cfset match = false>
        </cfcatch>
        </cftry>
        <cfreturn match />
</cffunction>

<cffunction name="checkForInstanceOf" output="false">
	<cfargument name="obj">
	<cfargument name="name">
	<cfreturn isInstanceOf(arguments.obj, arguments.name)>
</cffunction>

<cffunction name="dumpTrace" output="false">
	<cfset var trace="">
	<cfset var i=0>
	<cfset var tracePoint="">
	<cfset var total=0>
	<cfsavecontent variable="trace">
		<cfoutput>
			<div id="mura-stacktrace" class="mura-stacktrace">
			<h3>Stack Trace</h3>
			<ol>
				<cfloop from="1" to="#arrayLen(request.muraTraceRoute)#" index="i">
					<cfset tracePoint=request.muraTraceRoute[i]>
					<li>#HTMLEditFormat(tracePoint.detail)# <span class="duration">(<cfif isDefined("tracePoint.duration")>#tracePoint.duration#<cfelse>ERROR</cfif> | <cfif isDefined("tracePoint.total")>#tracePoint.total#<cfelse>ERROR</cfif>)</span></li>
				</cfloop>
			</ol>
			<cfset total=getTickCount()-request.muraRequestStart>
			<p>Total: <strong>#total# milliseconds</strong></p>
			</div>
		</cfoutput>
	</cfsavecontent>

	<cfreturn trace>
</cffunction>

<cffunction name="fixOracleClobs" output="false">
	<cfargument name="rs">
		<cfset var rsmeta=getMetaData(arguments.rs)>
		<cfset var clobArray=arrayNew(1)>
		<cfset var i=1>

		<cfif arrayLen(rsmeta)>
		<cfloop from="1" to="#arrayLen(rsmeta)#" index="i">
			<cfif rsmeta[i].typename eq "clob">
				<cfset arrayAppend(clobArray,rsmeta[i].name)>
			</cfif>
		</cfloop>
		</cfif>

		<cfif arrayLen(clobArray)>
		<cfloop query="arguments.rs">
			<cfloop from="1" to="#arrayLen(clobArray)#" index="i">
				 <cfset QuerySetCell(arguments.rs, clobArray[i],evaluate('arguments.rs.#clobArray[i]#'), arguments.rs.currentRow)>
			</cfloop>
		</cfloop>
		</cfif>
	<cfreturn arguments.rs>
</cffunction>

 <cffunction name="textPreview" output="false">
		<cfargument name="str" type="string" required="true">
		<cfargument name="maxlen" type="numeric" required="false" default="100" hint="Maximum length">
		<cfargument name="finishlist" type="string" required="false" default=".|?|!" hint="List of finish symbols">
		<cfargument name="finishdelim" type="string" required="false" default="|" hint="Deliemiter for List of finish symbols">

		<cfset var sOutText = "">
 		<cfset var sLastSym = "">
 		<cfset var iFinish="">
 		<cfset var idx="">
 		<cfset var iTemp="">

		<cfset sOutText = ReReplace(arguments.str, "<[^>]*>","","all") />

		<CFIF Find('[break]', sOutText)>
			<CFSET sOutText = Left(sOutText, Find('[break]', sOutText)-1)>
		<CFELSE>
			<CFSET sLastSym = Mid(sOutText, Arguments.maxlen-1, 1)>
			<CFIF ListFind(Arguments.finishlist, sLastSym, Arguments.finishdelim)>
				<CFSET sOutText = Left(sOutText, Arguments.maxlen)>
			<CFELSE>
				<CFSET iFinish = Len(sOutText)>
				<CFLOOP index="idx" list="#Arguments.finishlist#" delimiters="#Arguments.finishdelim#">
					<CFSET iTemp = ReFind('\#idx#[\s\<]', sOutText, Arguments.maxlen)>
					<CFIF iTemp AND iTemp LT iFinish>
						<CFSET iFinish = iTemp>
					</CFIF>
				</CFLOOP>
				<CFTRY>
					<CFSET sOutText = Left(sOutText, iFinish)>
					<CFCATCH TYPE="ANY"><CFRETURN sOutText></CFCATCH>
				</CFTRY>
			</CFIF>
		</CFIF>

		<CFRETURN sOutText>
	</cffunction>

	<cffunction name="suppressDebugging" output="false">
		<cfsetting showdebugoutput="no">
	</cffunction>

	<cffunction name="queryAppend" output="false"
		hint="This takes two queries and appends the second one to the first one. This actually updates the first query and does not return anything.">
		<cfargument name="QueryOne" type="query" required="true" />
		<cfargument name="QueryTwo" type="query" required="true" />
		<cfset var LOCAL = StructNew() />
		<!--- Get the column list (as an array for faster access. --->
		<cfset LOCAL.Columns = ListToArray( ARGUMENTS.QueryTwo.ColumnList ) />
		<!--- Loop over the second query. --->
		<cfloop query="ARGUMENTS.QueryTwo">
			<!--- Add a row to the first query. --->
			<cfset QueryAddRow( ARGUMENTS.QueryOne ) />
			<!--- Loop over the columns. --->
			<cfloop index="LOCAL.Column" from="1" to="#ArrayLen( LOCAL.Columns )#" step="1">
				<!--- Get the column name for easy access. --->
				<cfset LOCAL.ColumnName = LOCAL.Columns[ LOCAL.Column ] />
				<!--- Set the column value in the newly created row. --->
				<cfset ARGUMENTS.QueryOne[ LOCAL.ColumnName ][ ARGUMENTS.QueryOne.RecordCount ] = ARGUMENTS.QueryTwo[ LOCAL.ColumnName ][ ARGUMENTS.QueryTwo.CurrentRow ] />
			</cfloop>
		</cfloop>
	</cffunction>

	<cfscript>
		public boolean function reCAPTCHA(required event) {
			var verified = false;
			var $ = arguments.event.getValue('muraScope');
			var secret = $.siteConfig('reCAPTCHASecret');

			if ( Len(secret) && StructKeyExists(form, 'g-recaptcha-response') && Len(form['g-recaptcha-response']) ) {
				var reCaptcha = new mura.reCAPTCHA(secret);
				var verified = reCaptcha.verifyResponse(response=form['g-recaptcha-response'], remoteid=request.remoteAddr);
			}

			return verified;
		}

		public struct function getReCAPTCHAKeys(required event) {
			var $ = arguments.event.getValue('muraScope');
			return {
				'siteKey' = $.siteConfig('reCAPTCHASiteKey')
				, 'secret' = $.siteConfig('reCAPTCHASecret')
				, 'language' = $.siteConfig('reCAPTCHALanguage')
			};
		}

		public boolean function isHuman(required event) {
			var reCAPTCHAKeys = getReCAPTCHAKeys(argumentCollection=arguments);

			return Len(reCAPTCHAKeys.siteKey) && Len(reCAPTCHAKeys.secret)
				? reCAPTCHA(argumentCollection=arguments)
				: cfformprotect(argumentCollection=arguments);
		}

		public struct function getReCAPTCHALanguages() {
			return {
				'Arabic'='ar'
				,'Bulgarian'='bg'
				,'Catalan'='ca'
				,'Chinese (Simplified)'='zh-CN'
				,'Chinese (Traditional)'='zh-TW'
				,'Croatian'='hr'
				,'Czech'='cs'
				,'Danish'='da'
				,'Dutch'='nl'
				,'English (UK)'='en-GB'
				,'English (US)'='en'
				,'Filipino'='fil'
				,'Finnish'='fi'
				,'French'='fr'
				,'French (Canadian)'='fr-CA'
				,'German'='de'
				,'German (Austria)'='de-AT'
				,'German (Switzerland)'='de-CH'
				,'Greek'='el'
				,'Hebrew'='iw'
				,'Hindi'='hi'
				,'Hungarain'='hu'
				,'Indonesian'='id'
				,'Italian'='it'
				,'Japanese'='ja'
				,'Korean'='ko'
				,'Latvian'='lv'
				,'Lithuanian'='lt'
				,'Norwegian'='no'
				,'Persian'='fa'
				,'Polish'='pl'
				,'Portuguese'='pt'
				,'Portuguese (Brazil)'='pt-BR'
				,'Portuguese (Portugal)'='pt-PT'
				,'Romanian'='ro'
				,'Russian'='ru'
				,'Serbian'='sr'
				,'Slovak'='sk'
				,'Slovenian'='sl'
				,'Spanish'='es'
				,'Spanish (Latin America)'='es-419'
				,'Swedish'='sv'
				,'Thai'='th'
				,'Turkish'='tr'
				,'Ukrainian'='uk'
				,'Vietnamese'='vi'
			};
		}
	</cfscript>

<cffunction name="formatError" output="false">
<cfargument name="exception">
<cfsavecontent variable="local.str">
<cfoutput>
	<style type="text/css">
		.mura-core-errorBox {
			margin: 10px auto 10px auto;
			width: 90%;
		}

		.mura-core-errorBox h1 {
			font-size: 100px;
			margin: 5px 0px 5px 0px;
		}

	</style>
	<div class="mura-core-errorBox">
		<h2>500 Error</h2>
		<cfif isDefined("arguments.exception.Cause")>
			<cfset var errorData=arguments.exception.Cause>
		<cfelse>
			<cfset var errorData=arguments.exception>
		</cfif>
		<cfif isdefined('errorData.Message') and len(errorData.Message)>
			<h3><cfoutput>#errorData.Message#</cfoutput><br /></h3>
		</cfif>
		<cfif isdefined('errorData.DataSource') and len(errorData.DataSource)>
			<h4><cfoutput>Datasource: #errorData.DataSource#</cfoutput><br /></h4>
		</cfif>
		<cfif isdefined('errorData.sql') and len(errorData.sql)>
			<h4><cfoutput>SQL: #errorData.sql#</cfoutput><br /></h4>
		</cfif>
		<cfif isdefined('errorData.errorCode') and len(errorData.errorCode)>
			<h4><cfoutput>Code: #errorData.errorCode#</cfoutput><br /></h4>
		</cfif>
		<cfif isdefined('errorData.type') and len(errorData.errorCode)>
			<h4><cfoutput>Type: #errorData.errorCode#</cfoutput><br /></h4>
		</cfif>
		<cfif isdefined('errorData.Detail') and len(errorData.Detail)>
			<h4><cfoutput>#errorData.Detail#</cfoutput><br /></h4>
		</cfif>
		<cfif isdefined('errorData.extendedInfo') and len(errorData.extendedInfo)>
			<h4><cfoutput>#errorData.extendedInfo#</cfoutput><br /></h4>
		</cfif>
		<!---
		<cfif isdefined('errorData.StackTrace')>
			<pre><cfoutput>#errorData.StackTrace#</cfoutput></pre><br />
		</cfif>
		--->
		<cfif isDefined('errorData.TagContext') and isArray(errorData.TagContext)>
			<cfset var errorContexts=''>
			<cfloop array="#errorData.TagContext#" index="errorContexts">
				<cfoutput>
				<hr />
				<cfif isDefined('errorContexts.COLUMN')>
					Column: #errorContexts.COLUMN#<br />
				</cfif>
				<cfif isDefined('errorContexts.ID')>
					ID: #errorContexts.ID#<br />
				</cfif>
				<cfif isDefined('errorContexts.Line')>
					Line: #errorContexts.Line#<br />
				</cfif>
				<cfif isDefined('errorContexts.RAW_TRACE')>
					Raw Trace: #errorContexts.RAW_TRACE#<br />
				</cfif>
				<cfif isDefined('errorContexts.TEMPLATE')>
					Template: #errorContexts.TEMPLATE#<br />
				</cfif>
				<cfif isDefined('errorContexts.TYPE')>
					Type: #errorContexts.TYPE#<br />
				</cfif>
				<br />
				</cfoutput>
			</cfloop>
		</cfif>
	</div>
</cfoutput>
</cfsavecontent>

<cfreturn local.str>
</cffunction>

<cffunction name="sanitizeHref" output="false">
	<cfargument name="href">

	<cfif len(arguments.href) and listFindNoCase("http,https",listFirst(arguments.href,":"))>
		<cfset var returnProtocol = listFirst(arguments.href,':') />
		<cfset var returnDomain = reReplace(arguments.href, "^\w+://([^\/:]+)[\w\W]*$", "\1", "one") />

		<cfif not listfindNoCase(getBean('settingsManager').getAccessControlOriginDomainList(),returnProtocol & "://" & returnDomain) and len(returnDomain)>
			<cfif len(cgi.http_host)>
				<cfset arguments.href=replace(arguments.href,returnDomain,listFirst(cgi.http_host,":"))>
			<cfelse>
				<cfset arguments.href=replace(arguments.href,returnDomain,cgi.server_name)>
			</cfif>
		</cfif>
	</cfif>

	<cfreturn arguments.href>
</cffunction>

<cfscript>
	public string function stripTags(text='', tagsToStrip='script,style,embed,object') {
		var t = '';
		var tags = ListToArray(arguments.tagsToStrip);
		var str = arguments.text;

		for ( t in tags ) {
			str = ReReplaceNoCase(str, '<' & t & '.*?>.*?</' & t & '>', '', 'all');
		}

		return str;
	}

	public string function createCSSHook(text='') {
		var str = LCase(stripTags(arguments.text));
		str = Trim(ReReplace(str, '<[^>]*>', ' ', 'all'));
		str = ReReplace(str, '\s{2,}', ' ', 'all');
		str = ReReplace(str, '&[^;]+?;', '', 'all');
		str = ReReplace(str, '[^a-zA-Z0-9_\-\s]', '', 'all');
		str = ReReplace(str, '_|\s+', '-', 'all');

		while( IsNumeric(Left(str, 1)) || Left(str, 1) == '-' ) {
			str = RemoveChars(str, 1, 1);
		}

		return str;
	}

	public string function setCamelback(theString='') {
		var str = arguments.theString;
		str = setProperCase(str);
		str = REReplace(str, '[^a-zA-Z0-9]', '', 'ALL');
		return str;
	}

	public string function setProperCase(theString='') {
		if(isdefined('arguments.theString') && len(arguments.theString)){
			var str = arguments.theString;
			var newString = '';
			var frontpointer = 0;
			var strlen = Len(str);
			var counter = 0;

			if ( strLen > 0 ) {
				for (counter=1;counter LTE strlen;counter=counter + 1) {
			 		frontpointer = counter + 1;
					if (Mid(str, counter, 1) is " ") {
						newstring = newstring & ' ' & ucase(Mid(str, frontpointer, 1));
						counter = counter + 1;
					} else {
						if (counter is 1) {
							newstring = newstring & ucase(Mid(str, counter, 1));
						} else {
							newstring = newstring & lcase(Mid(str, counter, 1));
						}
					}
			 	}
			}

			return newString;
		} else {
			return '';
		}
	}

	public string function renderFileSize(size=0) {
		var str = '';
		var theSize = Val(arguments.size);

		if ( theSize > 1000000 ) {
			return NumberFormat(theSize*.000001, 9.99) & 'Mb';
		} else {
			return NumberFormat(theSize*.001, 9) & 'kb';
		}
	}

	function getIsoTimeString(
			required date datetime,
			boolean convertToUTC = true
		) {
		if ( arguments.convertToUTC ) {
			arguments.datetime = dateConvert( "local2utc", arguments.datetime );
		}
		// When formatting the time, make sure to use "HH" so that the
		// time is formatted using 24-hour time.
		return(
			dateFormat( arguments.datetime, "yyyy-mm-dd" ) &
			"T" &
			timeFormat( arguments.datetime, "HH:mm:ss" ) &
			"Z"
		);
	}

	function getEpochTime() {
	  var datetime = 0;
	  if (ArrayLen(Arguments) is 0) {
		datetime = Now();
	  }
	  else {
		if (IsDate(Arguments[1])) {
		  datetime = Arguments[1];
		} else {
		  return arguments[1];
		}
	  }
	  return DateDiff("s", "January 1 1970 00:00", datetime);
	}

	function getStringBytesLength(str) {

	    return arrayLen(CreateObject(
	    "java",
	    "java.lang.String"
	    ).Init(
	        JavaCast(
	            "string",
	            arguments.str
	            )
	        ).getBytes()
	    );
	}

	function leftTrimByBytes(str='',len=255){
	    /*
	      The java.text.StringCharacterIterator respects unicode characters.
	      So it iterates over the characters until the resulting string's byte array length reaches the arguments.len value
	    */
	    var characterIterator = CreateObject(
	        "java",
	        "java.text.StringCharacterIterator"
	        ).Init(
	            arguments.str
	        );
	    var returnStr='';
	    var stageStr='';
	    while(characterIterator.Current() != characterIterator.DONE){
	        stageStr = stageStr & characterIterator.Current();
	        if(getStringBytesLength(stageStr) <= arguments.len){
	            returnStr=stageStr;
	        } else {
	            return returnStr;
	        }
	        characterIterator.Next();
	    }

	    return returnStr;
	}

	function trimVarchar(str,len){
		if(variables.configBean.getDbType() eq 'Oracle'){
			return leftTrimByBytes(arguments.str,arguments.len);
		} else {
			return left(arguments.str,arguments.len);
		}
	}

	function getXMLKeyValue(xmlObj, key, defaultValue=""){
		if(isdefined('arguments.xmlObj.xmlAttributes.#arguments.key#')){
			return xmlObj.xmlAttributes[arguments.key];
		} else if ( isDefined('arguments.xmlObj.#arguments.key#.xmlText')){
			return arguments.xmlObj[arguments.key].xmlText;
		} else {
			return arguments.defaultValue;
		}
	}

	function isPathLegal(path){
		var rootPath=replace(variables.configBean.getWebRoot(), "\", "/", "ALL");
		var pluginPath=replace(variables.configBean.getPluginDir(), "\", "/", "ALL");
		arguments.path=replace(expandPath(arguments.path), "\", "/", "ALL");
		return (
			len(arguments.path) >= len(rootPath) && left(arguments.path,len(rootPath)) == rootPath
		) && (
			rootPath & "/plugins" == pluginPath

			||

			(
				len(arguments.path) >= len(pluginPath) && left(arguments.path,len(pluginPath)) == pluginPath
			)
		);
	}

	function datetimeToTimespanInterval(datetime=now(),timespan=''){
		if(!(0+arguments.timespan)){
			arguments.timespan=createTimeSpan(0,0,5,0);
		}
		var nowBase=arguments.datetime;
		var nowEpoch=DateDiff("s", DateConvert("utc2Local", "January 1 1970 00:00"), nowBase);
		var seconds=dateDiff('s',nowBase,nowBase + arguments.timespan);
		if(variables.configBean.getValue('compiler') == 'Adobe'){
			seconds=seconds+1;
		}
		return DateAdd("s",fix(nowEpoch/seconds) * seconds,DateConvert("utc2Local", "January 1 1970 00:00"));
	}

</cfscript>

<!--- Stashing some support for tags here until CF10 support is dropped --->
<cffunction name="setHeader" output="false">
	<cfargument name="statustext">
	<cfargument name="statuscode">
	<cfheader statustext="#arguments.statustext#" statuscode="#arguments.statuscode#">
</cffunction>

<cffunction name="resetContent" output="false">
	<cfcontent reset="true">
</cffunction>

<cffunction name="clearObjectCache" output="false">
	<cfobjectcache action="clear" />
</cffunction>

<cffunction name="setRequestTimeout" output="false">
	<cfargument name="timeout">
	<cfsetting requestTimeout = "#timeout#">
</cffunction>

<cffunction name="scheduleTask" output="false">
	<cfschedule attributeCollection="#arguments#">
</cffunction>

<cffunction name="legacyLogout" output="false">
	<cflogout>
</cffunction>

<cffunction name="invokeMethod" output="false">
		<cfargument name="component">
		<cfargument name="methodName">
		<cfargument name="args" default="#structNew()#">
		<cfinvoke component="#arguments.component#" method="#arguments.methodName#" returnVariable="local.returnValue" argumentCollection="#arguments.args#">
		<cfif isDefined('local.returnValue')>
			<cfreturn local.returnValue>
		</cfif>
</cffunction>

<cffunction name="cfml2wddx" output="false">
	<cfargument name="value">
		<cfwddx action="cfml2wddx" input="#arguments.value#" output="local.temp">
		<cfreturn local.temp>
</cffunction>

<cffunction name="wddx2cfml" output="false">
	<cfargument name="value">
		<cfwddx action="wddx2cfml" input=#arguments.value# output="local.temp">
		<cfreturn local.temp>
</cffunction>

<cffunction name="setHTMLHead" output="false">
	<cfargument name="value">
		<cfhtmlhead text="#arguments.value#">
</cffunction>

</cfcomponent>
