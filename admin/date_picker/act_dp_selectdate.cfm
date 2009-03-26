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

  
     <cfset returnDate=LSDateFormat(createDate(yearValue,monthValue,dayValue),session.dateKeyFormat) />
   
</cfif>

<cfif URL.form is "">
<font face="arial,helvetica,sans" size="2"><b>Returned date:</b><cfoutput>#returnDate#</cfoutput></font>
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
