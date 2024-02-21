<!--- 
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->

<cfsilent>
<cfscript>
	if(server.coldfusion.productname != 'ColdFusion Server'){
		backportdir='';
		include "/mura/backport/backport.cfm";
	} else {
		backportdir='/mura/backport/';
		include "#backportdir#backport.cfm";
	}
</cfscript>
<cfparam name="attributes.siteID" default="">
<cfparam name="attributes.parentID" default="">
<cfparam name="attributes.nestLevel" default="0">
<cfset rslist=application.categoryManager.getCategories(attributes.siteID,attributes.ParentID) />
<cfif attributes.nestlevel eq 0>
<cfset variables.nestLevel=""/>
<cfelse>
<cfset variables.nestLevel=attributes.nestlevel/>
</cfif>
</cfsilent>
<cfif rslist.recordcount>
<cfif attributes.nestlevel eq 0>
	<cfoutput>
	<table class="mura-table-grid">
	<thead>
	<tr>
	<th class="add"></th>
	<th class="var-width">#application.rbFactory.getKeyValue(session.rb,"categorymanager.category")#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,"categorymanager.assignable")#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,"categorymanager.interestgroup")#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,"categorymanager.active")#</th>
	<th class="actions hide"></th>
	</tr>
	<thead>
	<tbody class="nest">
	</cfoutput>
</cfif>
<cfoutput>
<cfloop query="rslist">
<tr>
<td class="add">
 <a href="javascript:;" <!---ontouchstart="this.onclick();"---> onclick="categoryManager.showMenu('newContentMenu',this,'#rslist.categoryid#','#esapiEncode('javascript',attributes.siteid)#');"><i class="mi-ellipsis-v"></i></a></td>
<td class="var-width"><ul <cfif rslist.hasKids>class="nest#variables.nestlevel#on"<cfelse>class="nest#variables.nestlevel#off"</cfif>><li class="Category#iif(rslist.restrictGroups neq '',de('Locked'),de(''))#"><a title="Edit" href="./?muraAction=cCategory.edit&categoryID=#rslist.categoryID#&parentID=#rslist.parentID#&siteid=#esapiEncode('url',attributes.siteid)#">#esapiEncode('html',rslist.name)#</a></li></ul></td>
<td><cfif rslist.isOpen><i class="mi-check" title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(rslist.isOpen)#')#"></i>
<cfelse><i class="mi-ban" title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(rslist.isOpen)#')#"></i></cfif>
<span>#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(rslist.isOpen)#')#</span></td>

<td>
	<cfif rslist.isInterestGroup>
		<i class="mi-check" title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(rslist.isInterestGroup)#')#"></i>
	<cfelse>
	<i class="mi-ban" title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(rslist.isInterestGroup)#')#"></i>
	</cfif>
	<span>#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(rslist.isInterestGroup)#')#</span>
</td>

<td>
	<cfif rslist.isActive>
		<i class="mi-check" title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(rslist.isActive)#')#"></i>
	<cfelse>
	<i class="mi-ban" title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(rslist.isActive)#')#"></i>
	</cfif>
	<span>#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(rslist.isActive)#')#</span>
</td>
<td class="actions hide"><ul><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.edit')#" href="./?muraAction=cCategory.edit&categoryID=#rslist.categoryID#&parentID=#rslist.parentID#&siteid=#esapiEncode('url',attributes.siteid)#"><i class="mi-pencil"></i></a></li><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.delete')#" href="./?muraAction=cCategory.update&action=delete&categoryID=#rslist.categoryID#&siteid=#esapiEncode('url',attributes.siteid)##attributes.muraScope.renderCSRFTokens(context=rslist.categoryid,format="url")#" onClick="return confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'categorymanager.deleteconfirm'))#',this.href)"><i class="mi-trash"></i></a></li></ul></td>
</tr>
<cf_dsp_nest siteID="#attributes.siteID#" parentID="#rslist.categoryID#" nestLevel="#val(attributes.nestLevel +1)#"  muraScope="#attributes.muraScope#">
</cfloop>
</cfoutput>
<cfif attributes.nestlevel eq 0>
	</tbody>
	</table>
</cfif>
<cfelseif attributes.nestlevel eq 0>
	<cfoutput><div class="help-block-empty">#application.rbFactory.getKeyValue(session.rb,"categorymanager.nocategories")#</div></cfoutput>
</cfif>
