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

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and      
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/admin/
/tasks/
/config/
/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfsilent>
       <cfset str = "" />
       <!--- get records --->
       <cfset records = application.userManager.getAdvancedSearch(session,attributes.siteid,1) />
       <!--- get orig list --->
       <cfset origColumnList = records.columnlist />
       <!--- get column lists --->
       <cfset qualifiedColumns = ListQualify( origColumnList, '"', ",", "CHAR" ) />
       <!--- assign columns to string --->
       <cfset str = str & qualifiedColumns & chr(10) />
       <!--- query over records and append --->
       <cfloop query="records">
               <cfset record = "" />
               <!--- loop over columns --->
               <cfloop list="#origColumnList#" index="column">
                       <cfset record = listAppend( record, replace( records[column][records.currentrow], ",", "**comma**", "ALL" ) & " " ) />
               </cfloop>
               <cfset str = str & listQualify( record, '"', ",", "CHAR" ) & chr(10) />
       </cfloop>
</cfsilent>
<cfheader name="Content-Disposition" value="disposition;filename=members.csv">
<cfcontent type="text/csv"><cfoutput>#replace( str, "**comma**", ",", "ALL" )#</cfoutput>