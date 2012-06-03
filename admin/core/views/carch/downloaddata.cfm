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
<cfsilent>
<cfset request.layout=false>
<cfparam name="rc.columns" default="">

<cfif len(rc.contentBean.getResponseDisplayFields()) gt 0 and rc.contentBean.getResponseDisplayFields() neq "~">
	<cfset rc.fieldnames=replace(listLast(rc.contentBean.getResponseDisplayFields(),"~"), "^", ",", "ALL")>
<cfelse>
	<cfset rc.fieldnames=application.dataCollectionManager.getCurrentFieldList(rc.contentid)/>
</cfif>

<cfset rsdata=application.dataCollectionManager.getData(rc)/>
<cfset DelimChar=",">
<cfset NewLine=chr(13)&chr(10)>

<cffunction name="fixDelim" output="false" returntype="string">
	<cfargument default="" type="String" name="arg">
	<cfreturn '"' & replace(replace(arguments.arg,'"','""',"All"),NewLine," ","All") & '"'>
</cffunction>

</cfsilent>
<cfheader name="Content-Disposition" value="attachment;filename=#rereplace(rc.contentBean.gettitle(),' ','-','ALL')#_#LSDateFormat(now(),'mmddyy')#.csv">
<cfheader name="Expires" value="0">
<cfcontent type="application/msexcel" reset="yes"><cfoutput>DATE/TIME ENTERED#DelimChar#<cfloop list="#rc.fieldnames#" index="c">#c##DelimChar#</cfloop>#NewLine#</cfoutput><cfoutput query="rsData"><cfsilent><cfwddx action="wddx2cfml" input="#rsdata.data#" output="info"></cfsilent>#rsdata.entered##DelimChar#<cfloop list="#iif(rc.columns eq 'fixed',de('#rc.fieldnames#'),de('#rsdata.fieldList#'))#" index="f"><cftry><cfif findNoCase('attachment',f) and isValid("UUID",info['#f#'])>http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/tasks/render/file/?fileID=#info['#f#']#<cfelse>#fixDelim(info['#f#'])#</cfif><cfcatch></cfcatch></cftry>#DelimChar#</cfloop>#NewLine#</cfoutput><cfabort>
