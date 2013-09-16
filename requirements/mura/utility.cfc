<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->

<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" access="public" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="fileWriter" type="any" required="yes"/>
<cfargument name="javaloader" type="any" required="yes"/>
<cfset variables.configBean=arguments.configBean />
<cfset variables.fileWriter=arguments.fileWriter />

<cfset variables.javaVersion=listGetAt(createObject("java", "java.lang.System").getProperty("java.version"),2,".") />
<cfset variables.bCrypt=arguments.javaloader.create("BCrypt")>
<cfreturn this >
</cffunction>

<cffunction name="displayErrors" access="public" output="true">
<cfargument name="error" type="struct" required="yes" default="#structnew()#"/>
<cfset var err=""/>
<cfset var started=false>
<cfloop collection="#arguments.error#" item="err">
<cfif err neq "siteID">
<cfset started=true>
<cfoutput><strong>#structfind(arguments.error,err)#</strong><br/></cfoutput>
</cfif>
</cfloop>
</cffunction>

<cffunction name="getNextN" returntype="struct" access="public" output="false">
	<cfargument name="data" type="query" />
	<cfargument name="RecordsPerPage" type="numeric" />
	<cfargument name="startRow" type="numeric" />
	<cfargument name="pageBuffer" type="numeric" default="5" />
	<cfset var nextn=structnew() />
	
	<cfset nextn.TotalRecords=arguments.data.RecordCount>
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
	<cfset nextn.startrow=arguments.startrow>
	
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
			<CFSET "str.#a#"  = replaceNoCase(str[a], arguments.badwords,  "****" ,  "ALL")/>
		</cfif>
	<cfcatch></cfcatch></cftry>
	</CFLOOP>

<cfreturn str />
</cffunction> 

<cffunction name="createRequiredSiteDirectories" returntype="void" output="false" access="public">
<cfargument name="siteid" type="string" default="" required="yes"/>
	<cfset var webroot=expandPath('/muraWRM')>

	<!--- make sure that the file cache directory exists, for node level files --->
	<cfif not directoryExists("#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteid##variables.configBean.getFileDelim()#cache#variables.configBean.getFileDelim()#file")> 
	
		<cfif not directoryExists("#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteid#")> 
			<cfset variables.fileWriter.createDir(directory="#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteid#")>
		</cfif>
	
		<cfif not directoryExists("#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteid##variables.configBean.getFileDelim()#cache")> 
			<cfset variables.fileWriter.createDir(directory="#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteid##variables.configBean.getFileDelim()#cache")>
		</cfif>
		
		<cfset variables.fileWriter.createDir(directory="#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteid##variables.configBean.getFileDelim()#cache#variables.configBean.getFileDelim()#file")>
	</cfif>
	
	<!--- make sure that the asset directory exists, for fckeditor assets --->
	<cfif not directoryExists("#variables.configBean.getAssetDir()##variables.configBean.getFileDelim()##arguments.siteid##variables.configBean.getFileDelim()#assets")> 
		<cfset variables.fileWriter.createDir(directory="#variables.configBean.getAssetDir()##variables.configBean.getFileDelim()##arguments.siteid##variables.configBean.getFileDelim()#assets")>
	</cfif>

	<cfif not fileExists("#webroot#/#arguments.siteid#/includes/contentRenderer.cfc")> 
		<cfset variables.fileWriter.copyFile(source="#webroot#/config/templates/site/contentRenderer.template.cfc", destination="#webroot#/#arguments.siteid#/includes/contentRenderer.cfc")>
	</cfif>

	<cfif not fileExists("#webroot#/#arguments.siteid#/includes/Application.cfc")> 
		<cfset variables.fileWriter.copyFile(source="#webroot#/config/templates/site/application.template.cfc", destination="#webroot#/#arguments.siteid#/includes/Application.cfc")>
	</cfif>

	<cfif not fileExists("#webroot#/#arguments.siteid#/includes/eventHandler.cfc")> 
		<cfset variables.fileWriter.copyFile(source="#webroot#/config/templates/site/eventHandler.template.cfc", destination="#webroot#/#arguments.siteid#/includes/eventHandler.cfc")>
	</cfif>

	<cfif not directoryExists("#webroot#/#arguments.siteid#/includes/email")> 
		<cfset variables.fileWriter.createDir(directory="#webroot#/#arguments.siteid#/includes/email")>
	</cfif>

	<cfif not fileExists("#webroot#/#arguments.siteid#/includes/email/inc_email.cfm")> 
		<cfset variables.fileWriter.copyFile(source="#webroot#/config/templates/site/email.template.cfm", destination="#webroot#/#arguments.siteid#/includes/email/inc_email.cfm")>
	</cfif>
	
</cffunction>

<cffunction name="logEvent" returntype="void" output="false" access="public">
<cfargument name="text" type="string" default="" required="yes"/>
<cfargument name="file" type="string" default="" required="yes"/>
<cfargument name="type" type="string" default="Information" required="yes"/>
<cfargument name="application" type="boolean" default="true" required="yes"/>

<cfset var msg=arguments.text />
<cfset var user = "Anonymous" />
<cfset var remoteAddr = StructKeyExists(request, 'remoteAddr') ? request.remoteAddr : CGI.REMOTE_ADDR />

<cfif isBoolean(variables.configBean.getLogEvents()) and variables.configBean.getLogEvents()>
<cfif session.mura.isLoggedIn>
<cfset user=session.mura.fname & " " & session.mura.lname />
</cfif>

<cfset msg="#msg# By #user# from #remoteAddr#" />

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

<cffunction name="cfformprotect" output="false" returntype="any">
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

<cffunction name="arrayToQuery" access="public" returntype="query" output="false">
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

<cffunction name="queryRowToStruct" access="public" output="false" returntype="struct">
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
<cffunction name="isValidCFVariableName" output="false" access="public" returntype="Any">
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

<!--- 
Blog:http://www.modernsignal.com/coldfusionhttponlycookie--->
<cffunction name="SetCookie" hint="Replacement for cfcookie that handles httponly cookies" output="false" returntype="void">
    <cfargument name="name" type="string" required="true">
    <cfargument name="value" type="string" required="true">
    <cfargument name="expires" type="any" default="" hint="''=session only|now|never|[date]|[number of days]">
    <cfargument name="domain" type="string" default="">
    <cfargument name="path" type="string" default="/">
    <cfargument name="secure" type="boolean" default="false">
    <cfargument name="httponly" type="boolean" default="false">
    <cfset var c = "">
    <cfset var expDate = "">
	
	<cfif server.coldfusion.productname eq "BlueDragon">
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
        <cfset c = c & "httponly;">
    </cfif>
    <cfheader name="Set-Cookie" value="#c#" />
</cffunction>

<cffunction name="toBCryptHash" output="false">
	<cfargument name="string">
	<cfargument name="logRounds" default="#variables.configBean.getBCryptLogRounds()#">
	<cfreturn variables.bCrypt.hashpw(JavaCast('string',arguments.string), variables.bCrypt.gensalt(JavaCast('int',arguments.logRounds)))>
</cffunction>

<cffunction name="checkBCryptHash" output="false">
	<cfargument name="string">
	<cfargument name="hash">
	<cftry>
	<cfreturn variables.bCrypt.checkpw(JavaCast('string',arguments.string), JavaCast('string',arguments.hash))>
	<cfcatch>
		<cfreturn false>
	</cfcatch>
	</cftry>
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
			<div id="mura-stacktrace">
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

 <cffunction name="textPreview" access="public" returntype="string" output="false">
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

</cfcomponent>