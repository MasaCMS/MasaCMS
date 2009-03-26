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

<cfset newline= chr(13)& chr(10)>
<cfset TabChar=chr(9)>
<cfheader name="Content-Disposition" value="attachment;filename=#request.listBean.getname()#.txt"> 
<cfheader name="Expires" value="0">
<cfcontent type="text/plain" reset="yes"><cfoutput>email#tabChar#fname#tabChar#lname#tabChar#company#newline#</cfoutput><cfoutput query="request.rslist">#request.rslist.email##tabChar##request.rslist.fname##tabChar##request.rslist.lname##tabChar##request.rslist.company##newline#</cfoutput>