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
<input type="button" class="submit" href="javascript:document.calendarForm.submit();" value="View" />
<input type="hidden" name="form" value="#htmlEditFormat(url.form)#"><input type="hidden" name="field" value="#htmlEditFormat(url.field)#"><input type="hidden" name="format" value="#htmlEditFormat(url.format)#"></form><table border="0" cellpadding="0" cellspacing="1" id="calendar" align="center">
<tr>
<th title="#HTMLEditFormat(dateLong)#"><a href="index.cfm?format=#URLEncodedFormat(URL.format)#&form=#URLEncodedFormat(URL.form)#&field=#URLEncodedFormat(URL.field)#&month=#URLEncodedFormat(previousmonth)#&year=#URLEncodedFormat(previousyear)#">&laquo;</a></th>
<th colspan="5">#HTMLEditFormat(dateShort)#</th>
<th><a href="index.cfm?format=#URLEncodedFormat(URL.format)#&form=#URLEncodedFormat(URL.form)#&field=#URLEncodedFormat(URL.field)#&month=#URLEncodedFormat(nextmonth)#&year=#URLEncodedFormat(nextyear)#">&raquo;</a></th>
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
		<a href="index.cfm?action=select&format=#URLEncodedFormat(URL.format)#&form=#URLEncodedFormat(URL.form)#&field=#URLEncodedFormat(URL.field)#&date=#URLEncodedFormat(URL.year)#-#URLEncodedFormat(URL.month)#-#URLEncodedFormat(id)#"  <cfif (URL.day eq id) AND (month(now()) eq URL.month) AND (year(now()) eq URL.year)>id="today"</cfif>>#id#</a>
		
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