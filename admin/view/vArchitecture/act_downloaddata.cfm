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
<cfparam name="attributes.columns" default="">
<cfset attributes.fieldnames=application.dataCollectionManager.getCurrentFieldList(attributes.contentid)/>
<cfset rsdata=application.dataCollectionManager.getData(attributes)/>
<cfset TabChar=chr(9)>
<cfset NewLine=chr(13)&chr(10)>



<cffunction name="fixTabs" output="false" returntype="string">
	<cfargument default="" type="String" name="arg">
	<cfreturn replace(replace(arguments.arg,TabChar," ","All"),NewLine," ","All")>
</cffunction> 
</cfsilent>
<cfheader name="Content-Disposition" value="attachment;filename=#rereplace(request.currentBean.gettitle(),' ','-','ALL')#_#LSDateFormat(now(),'mmddyy')#.xls"> 
<cfheader name="Expires" value="0">
<cfcontent type="application/msexcel" reset="yes"><cfoutput>DATE/TIME ENTERED#TabChar#<cfloop list="#attributes.fieldnames#" index="c">#c##TabChar#</cfloop>#NewLine#</cfoutput><cfoutput query="rsData"><cfsilent><cfwddx action="wddx2cfml" input="#rsdata.data#" output="info"></cfsilent>#rsdata.entered##TabChar#<cfloop list="#iif(attributes.columns eq 'fixed',de('#attributes.fieldnames#'),de('#rsdata.fieldList#'))#" index="f"><cftry><cfif findNoCase('attachment',f) and isValid("UUID",info['#f#'])>http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/tasks/render/file/?fileID=#info['#f#']#<cfelse>#fixTabs(info['#f#'])#</cfif><cfcatch></cfcatch></cftry>#TabChar#</cfloop>#NewLine#</cfoutput>
 