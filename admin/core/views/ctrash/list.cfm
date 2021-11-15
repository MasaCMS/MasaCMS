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
<cfparam name="rc.keywords" default="">
<cfoutput>

<div class="mura-header">
 <h1>Trash Bin</h1>

 <div class="nav-module-specific btn-group">
 	<a class="btn" href="./?muraAction=cSettings.editSite&siteID=#esapiEncode('url',rc.siteID)#"><i class="mi-arrow-circle-left"></i> Back to Site Settings</a>
	<a class="btn" href="./?muraAction=cTrash.empty&siteID=#esapiEncode('url',rc.siteID)#&sinceDate=#esapiEncode('html_attr',$.event('sinceDate'))#&beforeDate=#esapiEncode('html_attr',$.event('beforeDate'))#" onclick="return confirmDialog('Empty Site Trash?', this.href);"><i class="mi-trash"></i>Empty Trash</a>
 </div>

 <div class="mura-item-metadata">
	 <form class="form-inline" novalidate="novalidate" id="siteSearch" name="siteSearch" method="post">
			<div class="mura-search">
				<label>Search for Contents</label>
				<div class="mura-input-set">
					<input id="search" name="keywords" type="text" class="text" value="#esapiEncode('html_attr',rc.keywords)#" placeholder="Search Trash Bin">
					<button type="button" class="btn" onclick="submitForm(document.forms.siteSearch);"><i class="mi-search"></i></button>
				</div>
				<label>Trash Date Range</label>
				<div class="mura-control justify mura">
					<label class="label-inline">
						#application.rbFactory.getKeyValue(session.rb,"params.from")#
						<input type="text" name="sinceDate" id="startDate" class="datepicker mura-custom-datepicker" placeholder="Start Date" value="#LSDateFormat($.event('sinceDate'),session.dateKeyFormat)#" />
						#application.rbFactory.getKeyValue(session.rb,"params.to")#
						<input type="text" name="beforeDate" id="endDate" class="datepicker mura-custom-datepicker" placeholder="End Date" value="#LSDateFormat($.event('beforeDate'),session.dateKeyFormat)#" />
					</label>
				</div>
				<input type="hidden" name="muraAction" value="cTrash.list">
				<input type="hidden" name="siteid" value="#esapiEncode('html_attr',rc.siteid)#">
			</div>
		</form>
 </div>

</div> <!-- /.mura-header -->

<div class="block block-constrain">
	 <div class="block block-bordered">
		 <div class="block-content">
		 <cfif rc.trashIterator.hasNext()>
		 <table class="mura-table-grid">
		 <tr>
			 <th class="actions"></th>
			 <th class="var-width">Label</th>
			 <th>Type</th>
			 <th>SubType</th>
			 <th>SiteID</th>
			 <th>Date Deleted</th>
			 <th class="hidden-xs">Deleted By</th>
		 </tr>
		 <cfif not isNumeric(rc.pageNum)>
			 <cfset rc.pagenum=1>
		 </cfif>
		 <cfset rc.trashIterator.setPage(rc.pageNum)>
		 <cfloop condition="rc.trashIterator.hasNext()">
		 <cfset trashItem=rc.trashIterator.next()>
		 <tr>
			 <td class="actions">
				 <ul>
					 <li class="edit"><a title="Edit" href="?muraAction=cTrash.detail&objectID=#trashItem.getObjectID()#&keywords=#esapiEncode('url',rc.keywords)#&pageNum=#esapiEncode('url',rc.pageNum)#&sinceDate=#esapiEncode('url',$.event('sinceDate'))#&beforeDate=#esapiEncode('url',$.event('beforeDate'))#"><i class="mi-pencil"></i></a></li>
				 </ul>
			 </td>
			 <td class="var-width"><a href="?muraAction=cTrash.detail&objectID=#trashItem.getObjectID()#&keywords=#esapiEncode('url',rc.keywords)#&pageNum=#esapiEncode('url',rc.pageNum)#&sinceDate=#esapiEncode('url',$.event('sinceDate'))#&beforeDate=#esapiEncode('url',$.event('beforeDate'))#">#esapiEncode('html',left(trashItem.getObjectLabel(),80))#</a></td>
			 <td>#esapiEncode('html',trashItem.getObjectType())#</td>
			 <td>#esapiEncode('html',trashItem.getObjectSubType())#</td>
			 <td>#esapiEncode('html',trashItem.getSiteID())#</td>
			 <td>#LSDateFormat(trashItem.getDeletedDate(),session.dateKeyFormat)# #LSTimeFormat(trashItem.getDeletedDate(),"short")#</td>
			 <td class="hidden-xs">#esapiEncode('html',trashItem.getDeletedBy())#</td>
			 </tr>
		 </cfloop>
		 </table>

		 <cfif rc.trashIterator.pageCount() gt 1>
			 <ul class="pagination">
				 <cfif rc.pageNum gt 1>
								 <li><a href="?muraAction=cTrash.list&siteid=#esapiEncode('url',rc.siteid)#&keywords=#esapiEncode('url',rc.keywords)#&pageNum=#evaluate('rc.pageNum-1')#"><i class="mi-angle-left"></i></a></li>
				 </cfif>
				 <cfloop from="1"  to="#rc.trashIterator.pageCount()#" index="i">

					 <cfif rc.pageNum eq i>
						 <li class="active"><a href="##">#i#</a></li>
					 <cfelse>
						 <li><a href="?muraAction=cTrash.list&siteid=#esapiEncode('url',rc.siteid)#&keywords=#esapiEncode('url',rc.keywords)#&pageNum=#i#&sinceDate=#esapiEncode('url',$.event('sinceDate'))#&beforeDate=#esapiEncode('url',$.event('beforeDate'))#">#i#</a></li>
					 </cfif>

				 </cfloop>
				<cfif rc.pageNum lt rc.trashIterator.pageCount()>
					<li>
						<a href="?muraAction=cTrash.list&siteid=#esapiEncode('url',rc.siteid)#&keywords=#esapiEncode('url',rc.keywords)#&pageNum=#evaluate('rc.pageNum+1')#&sinceDate=#esapiEncode('url',$.event('sinceDate'))#&beforeDate=#esapiEncode('url',$.event('beforeDate'))#"><i class="mi-angle-right"></i></a>
					</li>
				</cfif>
			 </ul>
		 </cfif>
		 <cfelse>
			 <div class="help-block-empty">The trash is currently empty.</div>
		 </cfif>
	 </div> <!-- /.block-content -->
 </div> <!-- /.block-bordered -->
</div> <!-- /.block-constrain -->

</cfoutput>
