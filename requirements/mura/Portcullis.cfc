<cfcomponent output="false">

	<!---
		Portcullis is a CFC based url,form,cookie filter to help protect against 
		SQL Injection and XSS scripting attacks.
		
		Author: John Mason, mason@fusionlink.com
		Blog: www.codfusion.com
		Twitter: john_mason_
		Public Version: 2.0.1
		Release Date: 4/23/2008
		Last Updated: 1/16/2010
		
		WARNING: URL, SQL Injection and XSS attacks are an ever evolving threats. Though this 
		CFC will filter many types of attacks. There are no warranties, expressed or implied, 
		with using this filter. It is YOUR responsibility to monitor/modify/update/alter this code 
		to properly protect your application now and in the future. It is also highly encouraged to 
		implement a hardware Web Application Firewall (WAF) to obtain the best protection. In fact, 
		PCI-DSS requires either a full code audit or a WAF when handling credit card information.

		1.0.2 (4/23/2008) - First public release
		1.0.3 (5/10/2008) - Added CRLF defense, HttpOnly for cookies, remove individual IPs from the log and a new escapeChars function that replaces htmlEditFormat()
		1.0.4 (6/19/2008) - Fixed item naming with a regex scan to allow just alphanumeric and underscore characters
		1.0.5 (7/21/2008) - Added some key words to block the popular CAST()/ASCII injection attack. Also, fixed a bug reported if ampersands are in the url string it sometimes mixes up the variable naming
		1.0.6 (8/26/2008) - Exception field corrections, fixed a couple missing var scopes, querynew bug in CF6, bug fix for checkReferer
		1.0.7 (6/10/2009) - Added to sql and word filters, modified MSWord smart quotes filter
		2.0.0 (1/4/2010)  - Additions to the keyword list, accessors, context aware sql command words search
		2.0.1 (1/16/2010) - New isDetected() method and verification of valid variable names in accordance with the cf variable naming rules
		
		Follow me on Twitter to get Portcullis news - @john_mason_
		
		Special Thanks to Shawn Gorrell who developed the XSSBlock custom tag which inspired this project. You can download his tag at http://www.illumineti.com/documents/xssblock.txt
	--->
	 
	<!---Start of settings--->
	<cfset variables.instance={}>
	<cfset variables.instance.log = true/>	
	<cfset variables.instance.ipBlock = true/>										<!---Requires variables.instance.log set to true--->
	<cfset variables.instance.allowedAttempts = 10/>
	<cfset variables.instance.blockTime = 86400/> 									<!---In Seconds, 86400 seconds equals 1 day--->
	<cfset variables.instance.keepInnerText = false/> 								<!---Keep any text within a blocked tag--->
	<cfset variables.instance.invalidMarker = "[INVALID]"/>							<!---Strongly encouraged to replace stripped items with some type of marker, otherwise the attacker can rebuild a bad string from the stripping---> 								
	<cfset variables.instance.escapeChars = false/>									<!---So HtmlEditFormat and XMLFormat does not catch everything - we have a better method here--->
	<cfset variables.instance.checkReferer = true/> 								<!---For form variables only--->
	<cfset variables.instance.safeReferers = ""/> 									<!---Comma delimited list of sites that can send submit form variables to this site--->
	<cfset variables.instance.exceptionFields = "comments,summary,body,tags,title,menutitle,description,notes"/>							 	<!---Comma delimited list of fields not to scan--->
	<cfset variables.instance.allowJSAccessCookies = true/>						<!---Turn off Javascript access to cookies with the HttpOnly attribute - supported by only some browsers--->					
	<cfset variables.instance.blockCRLF = false/>									<!---Block CRLF (carriage return line feed) hacks, this particular hack has limited abilities so this could be overkill--->
	
	<cfset variables.instance.sqlFilter = "select,insert,update,delete,create,drop,alter,declare,execute,--,xp_,sp_sqlexecute,table_cursor,cast\(,exec\(,eval\(,information_schema"/>
	<cfset variables.instance.tagFilter = "script,object,applet,embed,form,input,layer,ilayer,frame,iframe,frameset,param,meta,base,style,xss"/>
	<cfset variables.instance.wordFilter = "onLoad,onClick,onDblClick,onKeyDown,onKeyPress,onKeyUp,onMouseDown,onMouseOut,onMouseUp,onMouseOver,onBlur,onChange,onFocus,onSelect,javascript:,vbscript:,\.cookie,\.toString,:expr,:expression,\.fromCharCode,String\."/>

	<cfset variables.instance.thisServer = lcase(CGI.SERVER_NAME)/>
	<!---End of settings--->

	<cfset variables.internal.detected = false/>

	<cfif isdefined("variables.internal.iplog") eq false>
		<cfset variables.internal.iplog = QueryNew("IP, Attempts, Blocked, DateBlocked", "VarChar, Integer, Bit, Date")/>
	</cfif>	
	
	<cffunction name="init" output="false" access="public" returntype="Portcullis">
		<cfargument name="settings" required="false" type="Struct"/>
		<cfif structkeyexists(arguments,"settings")>
			<cfset setSettings(arguments.settings)/>
		</cfif>
		<cfreturn this/>
	</cffunction>

	<cffunction name="setSettings" output="false" access="public" returntype="Any">
		<cfargument name="settings" required="true" type="Struct"/>
		<cfset var local = StructNew()/>
		<cfloop collection="#arguments.settings#" item="local.item">
			<cfset variables.instance[local.item] = arguments.settings[local.item]/>
		</cfloop>
	</cffunction>

	<cffunction name="getSettings" output="false" access="public" returntype="Any">
		<cfreturn variables.instance/>
	</cffunction>

	<cffunction name="scan" output="false" access="public" returntype="Void">
		<cfargument name="object" required="true" type="Struct"/>
		<cfargument name="objectname" required="true" type="String"/>
		<cfargument name="ipAddress" required="true" type="String"/>
		<cfargument name="exceptionFields" required="false" type="String"/>
		<cfargument name="useWordFilter" default="false"/>
		<cfargument name="useSQLFilter" default="false"/>
		<cfargument name="useTagFilter" default="false"/>
		<cfargument name="pattern" default=""/>
		<cfargument name="fixValues" default="true"/>
		 <!---Comma delimited list of fields not to scan--->
		<cfset var object2 = StructNew()/>
		<cfset var result = StructNew()/>
		<cfset var item= ""/>
		<cfset var itemname= ""/>
		<cfset var exFF= variables.instance.exceptionFields/>
		<cfset var detected= 0/>
		<cfset var temp= StructNew()/>
		<cfset var newitem = ""/>
		<cfset var contents = ""/>
		<cfset var nameregex = "[^a-zA-Z0-9_]"/>
			
		<!---Clean up Ampersands and nonexistent names that may mess up variable naming later on--->
		<cfif arguments.fixValues>	
			<cfloop collection="#object#" item="item">
				<cfif not isSimpleValue(object[item]) or isValidCFVariableName(item) eq false>
					<!---Item name is invalid anyway in CF so we just dump it --->
					<cfset structdelete(object,item,false)/>
				<cfelse>
					<cfset newitem = replaceNoCase(item,"&amp;","","ALL")/>
					<cfset newitem = replaceNoCase(newitem,"amp;","","ALL")/>
					<cfset contents = removeNullChars("#object[item]#")/>
					<cfset structdelete(object,item,false)/>
					<cfset StructInsert(object,"#newitem#",contents,true)/>		
				</cfif>
			</cfloop>
		</cfif>

		<cfif structkeyexists(arguments,"exceptionFields") and len(arguments.exceptionFields)>
			<cfset exFF = exFF & "," & arguments.exceptionFields/>
		</cfif>
		
		<!---Filter Tags--->
		<cfif arguments.useTagFilter>
			<cfloop collection="#object#" item="item">
				<cfif ListContainsNoCase(exFF,item,',') eq false and (not len(arguments.pattern) or refindNoCase(arguments.pattern,item))>
					<cfset temp = filterTags(object[item])/>
					<cfset itemname = REReplaceNoCase(item,nameregex,"","All")>
					<cfif temp.detected eq true><cfset detected = detected + 1/></cfif>
					<cfif arguments.fixValues>
						<cfif objectname eq "cookie" and variables.instance.allowJSAccessCookies eq false>
							<cfheader name="Set-Cookie" value="#itemname#=#temp.cleanText#;HttpOnly;path=/">
						<cfelse>
							<cfset "#objectname#.#itemname#" = temp.cleanText/>
						</cfif>
					</cfif>		
				</cfif>
			</cfloop>
		</cfif>

		<!---Filter Words--->
		<cfloop collection="#object#" item="item">
			<cfif ListContainsNoCase(exFF,item,',') eq false and (not len(arguments.pattern) or refindNoCase(arguments.pattern,item))>
				<!---trim white space and deal with "smart quotes" from MS Word, etc.--->	
				<!---trim white space and deal with "smart quotes" from MS Word, etc.--->
				<cfif arguments.fixValues>
					<cfset object[item]=trim(REReplace(object[item],"(�|�)", "'", "ALL"))>
				</cfif>
				
				<cfif arguments.useWordFilter>
					<cfset temp = filterWords(object[item])/>
					<cfset itemname = REReplaceNoCase(item,nameregex,"","All")>
					<cfif temp.detected eq true><cfset detected = detected + 1/></cfif>
					<cfif arguments.fixValues>
						<cfif objectname eq "cookie" and variables.instance.allowJSAccessCookies eq false>
							<cfheader name="Set-Cookie" value="#itemname#=#temp.cleanText#;HttpOnly;path=/">
						<cfelse>
							<cfset "#objectname#.#itemname#" = temp.cleanText/>
						</cfif>
					</cfif>	
				</cfif>
			</cfif>
		</cfloop>

		<!---Filter CRLF--->
		<cfif variables.instance.blockCRLF eq true>
		<cfloop collection="#object#" item="item">
			<cfif ListContainsNoCase(exFF,item,',') eq false and (not len(arguments.pattern) or refindNoCase(arguments.pattern,item))>
				<cfset temp = filterCRLF(object[item])/>
				<cfset itemname = REReplaceNoCase(item,nameregex,"","All")>
				<!---<cfif temp.detected eq true><cfset detected = detected + 1/></cfif>  // We're not going to take note of CRLFs since it's very likely benign--->
				<cfif arguments.fixValues>
					<cfif objectname eq "cookie" and variables.instance.allowJSAccessCookies eq false>
						<cfheader name="Set-Cookie" value="#itemname#=#temp.cleanText#;HttpOnly;path=/">
					<cfelse>
						<cfset "#objectname#.#itemname#" = temp.cleanText/>
					</cfif>
				</cfif>	
			</cfif>
		</cfloop>
		</cfif>

		<!---Filter SQL--->
		<cfif arguments.useSQLFilter>
			<cfloop collection="#object#" item="item">
				<cfif ListContainsNoCase(exFF,item,',') eq false and (not len(arguments.pattern) or refindNoCase(arguments.pattern,item))>
					<cfset temp = filterSQL(object[item],arguments.useSQLFilter)/>
					<cfset itemname = REReplaceNoCase(item,nameregex,"","All")>
					<cfif temp.detected eq true><cfset detected = detected + 1/></cfif>
					<cfif arguments.fixValues>
						<cfif objectname eq "cookie" and variables.instance.allowJSAccessCookies eq false>
							<cfheader name="Set-Cookie" value="#itemname#=#temp.cleanText#;HttpOnly;path=/">
						<cfelse>
							<cfset "#objectname#.#itemname#" = temp.cleanText/>
						</cfif>
					</cfif>	
				</cfif>
			</cfloop>
		</cfif>

		<!---Escape Special Characters--->
		<cfif variables.instance.escapeChars eq true and arguments.fixValues>
			<cfloop collection="#object#" item="item">
			<cfif ListContainsNoCase(exFF,item,',') eq false and (not len(arguments.pattern) or refindNoCase(arguments.pattern,item))>
				<cfif isNumeric(object[item]) eq false>
					<cfset itemname = REReplaceNoCase(item,nameregex,"","All")>
					<cfset temp = escapeChars(object[item])/>
					<cfset "#objectname#.#itemname#" = temp/>
				</cfif>
			</cfif>
			</cfloop>
		</cfif>

		<cfif variables.instance.log eq true and detected gt 0>
			<cfset setLog(arguments.ipAddress)/>
			<cfset cleanLog()/>
		</cfif>
		<cfif detected gt 0><cfset variables.internal.detected = true/><cfelse><cfset variables.internal.detected = false/></cfif>

	</cffunction>

	<cffunction name="setlog" output="false" access="public" returntype="Void">
		<cfargument name="ipAddress" required="true" type="String">
		<cfif isLogged(request.remoteAddr) eq 1>
			<cfset updateLog(arguments.ipAddress)/>
			<cfelse>
			<cfset insertLog(arguments.ipAddress)/>
		</cfif>

	</cffunction>

	<cffunction name="getLog" output="false" access="public" returntype="Any">
		<cfreturn variables.internal.iplog/>
	</cffunction>

	<cffunction name="isLogged" output="false" access="public" returntype="Any">
		<cfargument name="ipAddress" required="true" type="String">
		<cfset var find = ""/>
		
		<cfquery dbtype="query" name="find">
		select IP from variables.internal.iplog
		where IP = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="50" value="#arguments.ipAddress#">
		</cfquery>
		
		<cfreturn YesNoFormat(find.recordcount)/>
	</cffunction>

	<cffunction name="isBlocked" output="false" access="public" returntype="Any">
		<cfargument name="ipAddress" required="true" type="String">
		<cfset var blocked = false/>
		<cfset var find = ""/>
		
		<cfif isDefined("form.fieldnames") and variables.instance.checkReferer eq true and isSafeReferer() eq false>
			<cfset blocked = true/>
 		<cfelse>
			<cfquery dbtype="query" name="find">
			SELECT blocked 
			FROM variables.internal.iplog
			WHERE IP = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="50" value="#arguments.ipAddress#">
			</cfquery>
			<cfif find.blocked eq 1>
				<cfset blocked = true/>
			</cfif>
		</cfif>

		<cfreturn blocked/>
	</cffunction>

	<cffunction name="cleanLog" output="false" access="public" returntype="Any">
		<cfset var cutoff = 0 - variables.instance.blockTime/>
		
		<cfquery dbtype="query" name="variables.internal.iplog">
		SELECT IP, Attempts, Blocked, DateBlocked
		FROM variables.internal.iplog
		WHERE DateBlocked > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("s",cutoff,now())#">
		</cfquery>

		<cfreturn true/>
	</cffunction>

	<cffunction name="updateLog" output="false" access="public" returntype="Any">
		<cfargument name="ipAddress" required="true" type="String">
		<cfset var attempts = 0/>
		<cfset var find = ""/>
		
		<cfquery dbtype="query" name="find">
		SELECT attempts 
		FROM variables.internal.iplog
		WHERE IP = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="50" value="#arguments.ipAddress#">
		</cfquery>
		<cfset attempts = val(find.attempts) + 1/>
		
		<cfquery dbtype="query" name="variables.internal.iplog">
		<cfif variables.instance.ipBlock eq true and variables.instance.allowedAttempts lte attempts>
		SELECT IP, #attempts# AS Attempts, 1 AS Blocked, #now()# as DateBlocked
		<cfelse>
		SELECT IP, #attempts# AS Attempts, Blocked, #now()# as DateBlocked
		</cfif> 
		FROM variables.internal.iplog
		WHERE IP = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="50" value="#arguments.ipAddress#">
		UNION
		SELECT IP, Attempts, Blocked, DateBlocked 
		FROM variables.internal.iplog
		WHERE NOT IP = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="50" value="#arguments.ipAddress#">
		</cfquery>
		
		<cfreturn true/>
	</cffunction>

	<cffunction name="removeIPfromLog" output="false" access="public" returntype="Any">
		<cfargument name="ipAddress" required="true" type="String">
		
		<cfquery dbtype="query" name="variables.internal.iplog">
		SELECT *
		FROM variables.internal.iplog
		WHERE IP <> <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="50" value="#arguments.ipAddress#">
		</cfquery>
		
		<cfreturn true/>
	</cffunction>

	<cffunction name="insertLog" output="false" access="public" returntype="Any">
		<cfargument name="ipAddress" required="true" type="String">

		<cfset QueryAddRow(variables.internal.iplog, 1)>
		<cfset QuerySetCell(variables.internal.iplog, "IP", "#arguments.ipAddress#")/> 
		<cfset QuerySetCell(variables.internal.iplog, "Attempts", 1)/> 
		<cfset QuerySetCell(variables.internal.iplog, "Blocked", 0)/> 
		<cfset QuerySetCell(variables.internal.iplog, "DateBlocked", now())/> 

		<cfreturn true/>
	</cffunction>

	<cffunction name="filterTags" output="false" access="public" returntype="Any">
		<cfargument name="text" required="true" type="String">
		<cfset var result = StructNew()/>
		<cfset var tag = ""/>
		<cfset var tcount = 0/>
		<cfset var lcount = 0/>
		
		<!---trim white space and deal with "smart quotes" from MS Word, etc. This code came from Shawn Gorrell's popular cf_xssblock tag - http://www.illumineti.com/documents/xssblock.txt --->
		<cfset result.originalText = trim(replaceList(arguments.text,chr(8216) & "," & chr(8217) & "," & chr(8220) & "," & chr(8221) & "," & chr(8212) & "," & chr(8213) & "," & chr(8230),"',',"","",--,--,..."))/>

		<cfset result.detected = true/>
		<cfset result.cleanText = result.originalText/>
		
		<cfloop index="tag" list="#variables.instance.tagFilter#">
			<cfif REFindNoCase(("<#tag#.*?>|<#tag#.*?/>|</#tag#.*?>"),result.cleanText) eq 0>
				<cfset tcount = tcount + 1/>
			<cfelse>
				<cfif variables.instance.keepInnerText eq true>
					<cfset result.cleanText = ReReplaceNoCase(result.cleanText, "<#tag#.*?>(.*?)</#tag#.*?>", "\1", "All")>
					<cfset result.cleanText = ReReplaceNoCase(result.cleanText, "<#tag#.*?>|<#tag#.*?/>|</#tag#.*?>", variables.instance.invalidMarker, "All")>
				<cfelse>
					<cfset result.cleanText = ReReplaceNoCase(result.cleanText, "<#tag#.*?>.*?</#tag#.*?>|<#tag#.*?/>|</#tag#.*?>", variables.instance.invalidMarker, "All")>
				</cfif>
			</cfif>
			<cfset lcount = lcount + 1/>
		</cfloop>

		<cfif tcount eq lcount>
			<cfset result.detected = false/>
		</cfif>
			
		<cfreturn result/>
	</cffunction>

	<cffunction name="filterWords" output="false" access="public" returntype="Any">
		<cfargument name="text" required="true" type="String">
		<cfset var result = StructNew()/>
		<cfset result.detected = true/>
		<cfset result.originalText = arguments.text/>
		
		<cfif len(variables.instance.wordFilter)>
			<cfif REFindNoCase((ListChangeDelims(variables.instance.wordFilter,"|")),arguments.text) eq 0>
				<cfset result.detected = false/>
				<cfset result.cleanText = result.originalText/>
			<cfelse>
				<cfset result.cleanText = REReplaceNoCase(result.originalText,(ListChangeDelims(variables.instance.wordFilter,"|")),variables.instance.invalidMarker,"ALL")>
			</cfif>
		<cfelse>
			<cfset result.cleanText = result.originalText/>
		</cfif>
		
		<cfreturn result/>
	</cffunction>

	<cffunction name="filterSQL" output="false" access="public" returntype="Any">
		<cfargument name="text" required="true" type="String">
		<cfset var result = StructNew()/>
		<cfset var sqlcmdword = ""/>
		<cfset var tcount = 0/>
		<cfset var lcount = 0/>
		<cfset result.detected = true/>
		<cfset result.originalText = arguments.text/>
		<cfset result.cleanText = arguments.text/>

		<cfloop index="sqlcmdword" list="#variables.instance.sqlFilter#">
			<cfif REFindNoCase("[[:punct:]]",sqlcmdword) eq 0>
				<cfif REFindNoCase(sqlcmdword,arguments.text) eq 0>
					<cfset tcount = tcount + 1/>
				<cfelse>
					<!---Simple sql command word - need to check for the context of use--->
					<cfif badSQLContext(sqlcmdword,arguments.text) eq true>
						<cfset result.cleanText = REReplaceNoCase(result.cleanText,sqlcmdword,variables.instance.invalidMarker,"ALL")>
					<cfelse>
						<cfset tcount = tcount + 1/>
					</cfif>
				</cfif>
			<cfelse>
				<!---Advance sql command word - no need for context check--->
				<cfif REFindNoCase(sqlcmdword,arguments.text) eq 0>
					<cfset tcount = tcount + 1/>
				<cfelse>
					<cfset result.cleanText = REReplaceNoCase(result.cleanText,sqlcmdword,variables.instance.invalidMarker,"ALL")>
				</cfif>
			</cfif>
			<cfset lcount = lcount + 1/>
		</cfloop>

		<cfif tcount eq lcount>
			<cfset result.detected = false/>
		</cfif>

		<cfreturn result/>
	</cffunction>

	<!--- Some SQL command words are commonly used in everyday language like update and alter - this method determines if the context appears malign--->
	<cffunction name="badSQLContext" output="false" access="public" returntype="Any">
		<cfargument name="sqlcmdword" required="true" type="String">
		<cfargument name="text" required="true" type="String">
		<cfset var local = StructNew()/>
		<cfset local.tcount = 0/>
		<cfset local.lcount = 0/>
		<cfset local.afterwords = ""/>
		<cfset local.cmdwords1 = "create,drop,alter"/>
		<cfset local.dbobjects = "database,default,function,index,procedure,rule,schema,statistics,table,trigger,view"/>
		<cfset local.cmdwords2 = "select,insert,update,delete"/>
		<cfset local.dbverbs = "from,@,into,where,group,having,order,union"/>
		<cfset local.result = true/>

		<cfif REFindNoCase((ListChangeDelims(local.cmdwords1,"|")),arguments.sqlcmdword) gt 0>
			<cfset local.afterwords = local.dbobjects/>
		<cfelseif REFindNoCase((ListChangeDelims(local.cmdwords2,"|")),arguments.sqlcmdword) gt 0>
			<cfset local.afterwords = local.dbverbs/>
		<cfelse>
			<cfset local.afterwords = local.dbobjects & "," & local.dbverbs/>
		</cfif>

		<cfloop index="local.word" list="#local.afterwords#">
			<cfset local.temp = "#sqlcmdword#.*?#local.word#"/>
			<cfif REFindNoCase(local.temp,arguments.text) eq 0>
				<cfset local.tcount = local.tcount + 1/>
			</cfif>
			<cfset local.lcount = local.lcount + 1/>
		</cfloop>

		<cfif local.tcount eq local.lcount>
			<cfset local.result = false/>
		</cfif>
		
		<cfreturn local.result/>
	</cffunction>

	<cffunction name="filterCRLF" output="false" access="public" returntype="Any">
		<cfargument name="text" required="true" type="String">
		<cfset var result = StructNew()/>
		<cfset result.detected = true/>
		<cfset result.originalText = arguments.text/>
		
		<cfif REFindNoCase(chr(13),arguments.text) eq 0 and REFindNoCase(chr(10),arguments.text) eq 0>
			<cfset result.detected = false/>
			<cfset result.cleanText = result.originalText/>
		<cfelse>
			<cfset result.cleanText = REReplaceNoCase(arguments.text,chr(13),"","ALL")>
			<cfset result.cleanText = REReplaceNoCase(result.cleanText,chr(10)," ","ALL")>
		</cfif>
		<cfreturn result/>
	</cffunction>

	<!---HTMLEditFormat and XMLFormat simply don't do enough, so we do far more here--->
	<cffunction name="escapeChars" output="false" access="public" returntype="Any">
		<cfargument name="text" required="true" type="String">
		<cfset var result = arguments.text/>

		<cfset result = ReplaceNoCase(result,";","[semicolon]","ALL")>
		<cfset result = ReplaceNoCase(result,"##","&##35;","ALL")>
		<cfset result = ReplaceNoCase(result,"(","&##40;","ALL")>
		<cfset result = ReplaceNoCase(result,")","&##41;","ALL")>
		<cfset result = ReplaceNoCase(result,"<","&lt;","ALL")>
		<cfset result = ReplaceNoCase(result,">","&gt;","ALL")>
		<cfset result = ReplaceNoCase(result,"'","&##39;","ALL")>
		<cfset result = ReplaceNoCase(result,"""","&quot;","ALL")>
		<cfset result = ReplaceNoCase(result,"[semicolon]","&##59;","ALL")>

		<cfreturn result/>
	</cffunction>

	<cffunction name="isSafeReferer" output="false" access="public" returntype="Any">
		<cfset var thisserver = lcase(CGI.SERVER_NAME)/>
		<cfset var thisreferer = "none"/>
		<cfset var isSafe = false/> <!---We assume false until it's verified--->
		
		<cfif structkeyexists(cgi,"HTTP_REFERER") and len(cgi.HTTP_REFERER)>
			<cfset thisreferer = replace(lcase(CGI.HTTP_REFERER),'http://','','all')/>
			<cfset thisreferer = replace(thisreferer,'https://','','all')/>
			<cfset thisreferer = listgetat(thisreferer,1,'/')/>
		<cfelse>	
			<cfset thisreferer = "none"/>
		</cfif>	

		<cfif thisreferer eq "none" or thisreferer eq thisserver>
			<cfset isSafe = true/>
		<cfelse>
			<cfif ListContainsNoCase(variables.instance.safeReferers,thisreferer,',')>
				<cfset isSafe = true/>
			</cfif>		
		</cfif>	

		<cfreturn isSafe/>
	</cffunction>

	<!---Sometimes submitted variable names which are valid in other languages are not usable in CF due to its Variable naming rules--->
	<cffunction name="isValidCFVariableName" output="false" access="public" returntype="Any">
		<cfargument name="text" required="true" type="String">
		<cfset var local = StructNew()/>	
		<cfset local.result = true/>

		<cfif len(arguments.text) eq 0>
			<cfset local.result = false/>
		<cfelseif FindNoCase(".",arguments.text) gt 0 and listFindNoCase( "session,form,url,server,cgi,cookie,application,local",listFirst(arguments.text,"."))>
			<cfset local.result = false/>
		<cfelseif FindNoCase(" ",arguments.text) gt 0>
			<cfset local.result = false/>
		<cfelseif ReFindNoCase("^[A-Za-z][A-Za-z0-9_]*",arguments.text) eq 0>
			<cfset local.result = false/>
		</cfif>

		<cfreturn local.result/>
	</cffunction>

	<cffunction name="isDetected" output="false" access="public" returntype="Any">
		<cfreturn variables.internal.detected/>
	</cffunction>

	<cffunction name="removeNullChars" access="private" output="false" returntype="string">    
		<cfargument name="theString" type="string" required="true" />           
		<cfreturn urldecode(replace(urlEncodedFormat(arguments.theString),"%00","","all"))> 
	</cffunction>
	
</cfcomponent>