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

<cfsilent>
<cfset emailBean=application.emailManager.read(attributes.emailID) />
<cfset rsAddresses=application.emailManager.getAddresses(emailBean.getGroupID(),emailBean.getSiteID())/>
<cfset TabChar=chr(9) />
<cfset NewLine=chr(13)&chr(10) />
<cfset prevEmail = "" />
</cfsilent>
<cfheader name="Content-Disposition" value="attachment;filename=#emailBean.getSubject()#.xls"> 
<cfheader name="Expires" value="0">
<cfcontent type="application/msexcel" reset="yes"><cfoutput><cfloop list="email,firstName,lastName,company" index="c">#c##TabChar#</cfloop>#NewLine#</cfoutput><cfoutput query="rsAddresses"><cfif prevEmail neq rsAddresses.email>#rsAddresses.email##TabChar##rsAddresses.fname##TabChar##rsAddresses.lname##TabChar##rsAddresses.company##TabChar##NewLine#<cfset prevEmail=rsAddresses.email /></cfif></cfoutput>
 