<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->

<cfparam name="URL.form" default="">
<cfparam name="URL.field" default="">
<cfparam name="URL.date" default="">
<cfparam name="URL.format" default="ISO">
<cfset returnDate="">

<cfif NOT URL.date is "">
  <cfset yearValue=listGetAt("#URL.date#",1,"-")>
  <cfset monthValue=listGetAt("#URL.date#",2,"-")>
  <cfset dayValue=listGetAt("#URL.date#",3,"-")>
  <cfif len(dayvalue) eq 1><cfset dayValue="0#dayValue#"></cfif>
  <cfif len(monthvalue) eq 1><cfset monthValue="0#monthValue#"></cfif>
  <cfset sysDate=createDate(yearValue,monthValue,dayValue)>

    <cfswitch expression="#URL.format#">
    <cfcase value="ISO">
       <!--- ISO9660 Date format (YYYY-MM-DD HH:MM:SS) *Default* --->
       <cfset returnDate="#yearValue#-#monthValue#-#dayValue# 00:00:00">
    </cfcase>
    <cfcase value="DMY">
       <!--- UK Date format (DD-MM-YYYY) --->
       <cfset returnDate="#dayValue#-#monthValue#-#yearValue#">
    </cfcase>
	<cfcase value="MDY">
       <!--- UK Date format (Msession.dateKeyFormatYY) --->
       <cfset returnDate="#monthValue#/#dayValue#/#yearValue#">
    </cfcase>
    <cfcase value="YMD">
       <!--- USA Date format (YYYY-MM-DD) --->
       <cfset returnDate="#yearValue#-#monthValue#-#dayValue#">
    </cfcase>
    <cfcase value="ODBC">
       <!--- ODBC Date format ({ts 'YYYY-MM-DD HH:MM:SS'}) --->    
       <cfset returnDate="#createodbcDatetime(sysDate)#">
    </cfcase>
    <cfcase value="CF">
       <!--- Coldfusion Internal Date format ({ts 'YYYY-MM-DD HH:MM:SS'}) --->    
       <cfset returnDate="#sysDate#">
    </cfcase>
    </cfswitch>
</cfif>

<cfif URL.form is "">
Returned date: <cfoutput>#returnDate#</cfoutput>
<cfelse>
  <script language="JavaScript">
  <!--
  <cfoutput>
  self.opener.document.forms["#URL.form#"].#URL.field#.value = '#returnDate#';
  window.close();
  </cfoutput>
  //-->
  </script>
</cfif>
