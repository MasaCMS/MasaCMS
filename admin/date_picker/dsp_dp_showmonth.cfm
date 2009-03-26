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
<cfparam name="URL.format" default="ISO">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Choose Date</title>
    <link href="../css/admin.css" rel="stylesheet" type="text/css">
     <script language="JavaScript">
  <!--

  self.focus();

  //-->
  </script>
  <!--[if IE]>
<link href="../css/ie.css" rel="stylesheet" type="text/css" />
<![endif]-->
</head>

<body id="datePicker">
<div>
<cfoutput><form action="index.cfm" method="get" name="calendarForm"><select name="MONTH" class="dropdown"><cfset i=0><cfloop condition="i lt 12"><cfset i=i+1>
<option value="#i#"  <cfif month(now()) eq i>selected</cfif>>#i#</option></cfloop></select> <select name="YEAR" class="dropdown">		  <cfloop from="#year(now())#" to="#evaluate("#year(now())#+5")#" index="i"><option value="#i#"  <cfif  year(now()) eq i>selected</cfif> >#i#</option></cfloop></select> 
<a class="submit" href="javascript:document.calendarForm.submit();"><span>View</span></a>
<input type="hidden" name="form" value="#url.form#"><input type="hidden" name="field" value="#url.field#"><input type="hidden" name="format" value="#url.format#"></form><table border="0" cellpadding="0" cellspacing="1" id="calendar" align="center">
<tr>
<th title="#dateLong#"><a href="index.cfm?format=#URL.format#&form=#URL.form#&field=#URL.field#&month=#previousmonth#&year=#previousyear#">&laquo;</a></th>
<th colspan="5">#dateShort#</th>
<th><a href="index.cfm?format=#URL.format#&form=#URL.form#&field=#URL.field#&month=#nextmonth#&year=#nextyear#">&raquo;</a></th>
</tr>
	<tr class="dayofweek">
	<cfloop index="id" from="1" to="#listLen(weekdayShort)#">
	<cfset dayValue = listGetAt(weekdayShort,id,",")>
	<cfset dayValueLong = listGetAt(weekdayLong,id,",")>
	<td title="#dayValueLong#">#dayValue#</td>
	
	</cfloop>
	</tr>
	<cfset posn = 1>
	<tr>
	<cfloop index="id" from="1" to="#firstDayOfWeek#">
		<td>&nbsp;</td>
		<cfset posn=posn+1>
	</cfloop>
	<cfloop index="id" from="1" to="#daysInMonth#">
		<cfif posn eq 8></tr><cfif id lte daysInMonth><tr></cfif>
		<cfset posn=1></cfif>
		<td>
		<a href="index.cfm?action=select&format=#URL.format#&form=#URL.form#&field=#URL.field#&date=#URL.year#-#URL.month#-#id#"  <cfif (URL.day eq id) AND (month(now()) eq URL.month) AND (year(now()) eq URL.year)>id="today"</cfif>>#id#</a>
		
		</td>
		<cfset posn=posn+1>
	</cfloop>
	<cfif posn lt 8>
		<cfloop index="id" from="#posn#" to="7">
		<td>&nbsp;</td>
		</cfloop>
	</cfif></tr>
	</table></cfoutput></div>
</body>
</html>