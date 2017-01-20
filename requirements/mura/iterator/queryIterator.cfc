<!---
   Copyright 2007 Paul Marcotte

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

   Iterator.cfc (.3)
   [2007-05-31] Added Apache license.
				Fixed bug in currentRow method.
				Dropped cfscript blocks in favour of tags in all methods but queryRowToStruct().
   [2007-05-27] Added end() method.
				Renamed rewind() to reset().
				Acknowlegement to Aaron Roberson for suggesting currentRow() method and other enhancements.
   [2007-05-10]	Initial Release.
				Acknowlegement to Peter Bell for the "Iterating Business Object" concept that Iterator seeks to provide as a composite.
 --->
<cfcomponent extends="mura.cfobject" displayname="Iterator" output="false" hint="This provide core iterating functionality">
	<cfset variables.maxRecordsPerPage=1000>
	<cfset variables.recordTranslator="">
	<cfset variables.iteratorID="">
	<cfset variables.feed="">
	<cfset variables.recordIDField="id">
	<cfset variables.pageQueries=structNew()>

	<cffunction name="init" output="false">
		<cfset variables.recordIndex = 0 />
		<cfset variables._recordcount = 0 />
		<cfset variables.pageIndex = 1 />
		<cfset variables.iteratorID="i" & hash(createUUID())>
		<cfreturn THIS />
	</cffunction>

	<cffunction name="setFeed" output="false">
		<cfargument name="feed">
		<cfset variables.feed=arguments.feed>
		<cfreturn this>
	</cffunction>

	<cffunction name="getFeed" output="false">
		<cfreturn variables.feed>
	</cffunction>

	<cffunction name="hasFeed" output="false">
		<cfreturn isObject(variables.feed)>
	</cffunction>

	<cffunction name="getIteratorID" output="false">
		<cfreturn variables.iteratorID  />
	</cffunction>

	<cffunction name="currentIndex" output="false">
		<cfreturn variables.recordIndex  />
	</cffunction>

	<cffunction name="getRecordIndex" output="false">
		<cfreturn variables.recordIndex />
	</cffunction>

	<cffunction name="getRecordIdField" output="false">
		<cfreturn variables.recordIDField />
	</cffunction>

	<cffunction name="getPageIDList" output="false">
		<cfset var idList="">
		<cfset var i="">

		<cfif getRecordCount()>
			<cfif isArray(variables.records)>
				<cfloop array="#variables.records#" index="i">
					<cfset idList=listAppend(idList,i[getRecordIDField()])>
				</cfloop>
			<cfelse>
				<cfloop from="#getFirstRecordOnPageIndex()#" to="#getLastRecordOnPageIndex()#" index="i">
					<cfset idList=listAppend(idList,variables.records[getRecordIDField()][i])>
				</cfloop>
			</cfif>
		</cfif>

		<cfreturn idList>

	</cffunction>

	<cffunction name="getFirstRecordOnPageIndex" output="false">
		<cfset var first = ((variables.pageIndex-1) * variables.maxRecordsPerPage)>

		<cfif first gt getRecordCount()>
			<cfreturn 1>
		<cfelse>
			<cfreturn first+1 />
		</cfif>

	</cffunction>

	<cffunction name="getLastRecordOnPageIndex" output="false">
		<cfset var last=(((variables.pageIndex-1) * variables.maxRecordsPerPage) + variables.maxRecordsPerPage)>
		<cfif last gt getRecordCount()>
			<cfset last=getRecordCount()>
		</cfif>
		<cfreturn last />
	</cffunction>

	<cffunction name="setStartRow" output="false">
		<cfargument name="startRow">
		<cfif getRecordCount()>
			<cfif variables.maxRecordsPerPage neq 1>
				<cfset setPage(Ceiling(arguments.startRow/variables.maxRecordsPerPage))>
			<cfelse>
				<cfset setPage(arguments.startRow)>
			</cfif>
		<cfelse>
			<cfset variables.recordIndex=0 />
			<cfset setPage(1)>
		</cfif>
		<cfreturn this>
	</cffunction>

	<cffunction name="currentRow" output="false">
    	<cfreturn variables.recordIndex />
    </cffunction>

	<cffunction name="hasNext" output="false" returntype="boolean">
		<cfreturn currentIndex() lt getRecordCount() and currentIndex() lt (getPageIndex() *  variables.maxRecordsPerPage ) />
	</cffunction>

	<cffunction name="peek" output="false">
			<cfreturn packageRecord( currentIndex() + 1) />
	</cffunction>

	<cffunction name="next" output="false">
		<cfset variables.recordIndex = currentIndex() + 1 />
		<cfreturn packageRecord() />
	</cffunction>

	<cffunction name="hasPrevious" output="false" returntype="boolean">
		<cfreturn (currentIndex() gt (((variables.pageIndex-1) * variables.maxRecordsPerPage) + 1)) />
	</cffunction>

	<cffunction name="previous" output="false">
		<cfset variables.recordIndex = currentIndex() - 1 />
		<cfreturn packageRecord() />
	</cffunction>

	<cffunction name="packageRecord" output="false">
		<cfargument name="recordIndex" default="#currentIndex()#">
		<cfif isQuery(variables.records)>
			<cfreturn queryRowToStruct(variables.records,arguments.recordIndex)>
		<cfelseif isArray(variables.records)>
			<cfreturn variables.records[arguments.recordIndex]>
		<cfelse>
			<cfthrow message="The records have not been set.">
		</cfif>
	</cffunction>

	<cffunction name="reset" output="false">
		<cfset variables.recordIndex = 0 />
		<cfreturn this>
	</cffunction>

	<cffunction name="end" output="false">
		<cfset variables.recordIndex = getRecordCount() + 1 />
		<cfreturn this>
	</cffunction>

	<cffunction name="pageCount" output="false">
		<cfset var pageCount = 1 />
		<cfif structKeyExists(variables,"maxRecordsPerPage")>
			<cfset pageCount = Ceiling(getRecordCount()/variables.maxRecordsPerPage) />
		</cfif>
		<cfreturn pageCount />
	</cffunction>

	<cffunction name="recordCount" output="false" hint="For Lucee compatibility use getRecordCount()">
		<cfreturn getRecordCount()>
	</cffunction>

	<cffunction name="getRecordCount" output="false">
		<cfreturn variables._recordCount />
	</cffunction>

	<cffunction name="getPageIndex" output="false">
		<cfreturn variables.pageIndex />
	</cffunction>

	<cffunction name="setPage" output="false">
		<cfargument name="pageIndex">
		<cfset setPageIndex(arguments.pageIndex)>
		<cfreturn this>
	</cffunction>

	<cffunction name="setPageIndex" output="false">
		<cfargument name="pageIndex" type="numeric" required="true">
		<cfset variables.pageIndex = arguments.pageIndex />
		<cfset variables.recordIndex = ((variables.pageIndex-1) * variables.maxRecordsPerPage)>

		<cfif variables.recordIndex gt getRecordCount()>
			<cfset variables.recordIndex=0>
			<cfset variables.pageIndex=1>
		</cfif>
		<cfreturn this>
	</cffunction>

	<cffunction name="setItemsPerPage" output="false">
		<cfargument name="itemsPerPage">
		<cfset setNextN(nextN=arguments.itemsPerPage)>
		<cfreturn this>
	</cffunction>

	<cffunction name="getItemsPerPage" output="false">
		<cfreturn variables.maxRecordsPerPage>
	</cffunction>

	<cffunction name="setNextN" output="false">
		<cfargument name="nextN">
		<cfif isNumeric(arguments.nextN) and arguments.nextN>
			<cfset variables.maxRecordsPerPage=arguments.nextN>
		<cfelse>
			<cfset variables.maxRecordsPerPage=getRecordCount()>
		</cfif>
		<cfreturn this>
	</cffunction>

	<cffunction name="getNextN" output="false">
		<cfreturn variables.maxRecordsPerPage>
	</cffunction>

	<cffunction name="setArray" output="false">
		<cfargument name="array" type="any" required="true">
		<cfargument name="maxRecordsPerPage" type="numeric" required="false">

		<cfset variables.records = arguments.array />
		<cfset variables._recordcount=arrayLen(arguments.array)>

		<cfif structKeyExists(arguments,"maxRecordsPerPage") and isNumeric(arguments.maxRecordsPerPage)>
			<cfset variables.maxRecordsPerPage = arguments.maxRecordsPerPage />
		<cfelse>
			<cfset variables.maxRecordsPerPage = arrayLen(variables.records) />
		</cfif>
		<cfreturn this>
	</cffunction>

	<cffunction name="getArray" output="false">
		<cfset var array=arrayNew(1)>
		<cfset var i=1>

		<cfif isArray(variables.records)>
			<cfreturn variables.records>
		<cfelseif isQuery(variables.records)>
			<cfloop query="variables.records">
				<cfset arrayAppend(array,queryRowToStruct(variables.records,variables.records.currentRow))>
			</cfloop>
			<cfreturn array>
		<cfelse>
			<cfthrow message="The records have not been set.">
		</cfif>
	</cffunction>

	<cffunction name="setQuery" output="false">
		<cfargument name="rs" type="query" required="true">
		<cfargument name="maxRecordsPerPage" type="numeric" required="false">

		<cfset variables.records = arguments.rs />
		<cfset variables._recordcount=rs.recordcount>

		<cfif structKeyExists(arguments,"maxRecordsPerPage") and isNumeric(arguments.maxRecordsPerPage) and arguments.maxRecordsPerPage>
			<cfset variables.maxRecordsPerPage = arguments.maxRecordsPerPage />
		<cfelse>
			<cfset variables.maxRecordsPerPage = getRecordCount() />
		</cfif>
		<cfreturn this>
	</cffunction>

	<cffunction name="getQuery" output="false">
		<cfif isQuery(variables.records)>
			<cfreturn variables.records>
		<cfelseif isArray(variables.records)>
			<cfreturn getBean("utility").arrayToQuery(variables.records)>
		<cfelse>
			<cfthrow message="The records have not been set.">
		</cfif>
	</cffunction>

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

	<cffunction name="setPageQuery" output="false">
	<cfargument name="queryName"  type="string" required="true">
	<cfargument name="queryObject" default="" >

		<cfset variables.pageQueries["#arguments.queryName#"]=arguments.queryObject />
		<cfreturn this>
	</cffunction>

	<cffunction name="getPageQuery" output="false">
	<cfargument name="queryName"  type="string" required="true">

		<cfif structKeyExists(variables.pageQueries,"#arguments.queryName#")>
			<cfreturn variables.pageQueries["#arguments.queryName#"] />
		<cfelse>
			<cfreturn "" />
		</cfif>

	</cffunction>

	<cffunction name="clearPageQueries" output="false">
		<cfset variables.pageQueries=structNew()>
		<cfreturn this>
	</cffunction>

	<!---
	<cffunction name="each">
		<cfargument name="action" hint="A function that will run per item in iterator.">
		<cfargument name="$" hint="If not provides a MuraScope instance is created.">
		<cfset var test=false>
		<cfset var item="">

		<cfif structKeyExists(arguments,"mura")>
			<cfset arguments.$=arguments.mura>
		</cfif>

		<cfif structKeyExists(arguments,"$")>
			<cfset arguments.$.event("each:count",getRecordCount())>
		</cfif>

		<cfloop condition="hasNext()">
			<cfset item=next()>
			<cfif not structKeyExists(arguments,"$")>
				<cfset arguments.$=getBean("$").init(item.getValue("siteID"))>
				<cfset arguments.$.event("each:count",getRecordCount())>
			</cfif>
			<cfset arguments.$.event("each:index",getRecordIndex())>
			<cfset test=arguments.action(item=item, $=arguments.$, mura=arguments.$)>
			<cfif isDefined("test") and isBoolean(test) and not test>
				<cfbreak>
			</cfif>
		</cfloop>
	</cffunction>
	--->
</cfcomponent>
