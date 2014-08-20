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
<cfsavecontent variable="rc.ajax">
<cfoutput>
<script src="assets/js/architecture.min.js?coreversion=#application.coreversion#" type="text/javascript" ></script>
</cfoutput>
</cfsavecontent>
<cfoutput>
<h1>Trash Detail</h1>

<div id="nav-module-specific" class="btn-group">
<a class="btn" href="./?muraAction=cTrash.list&siteID=#esapiEncode('url',rc.trashItem.getSiteID())#&keywords=#esapiEncode('url',rc.keywords)#&pageNum=#esapiEncode('url',rc.pageNum)#"><i class="icon-circle-arrow-left"></i>  Back to Trash Bin</a>
</div>

<ul class="metadata">
<li><strong>Label:</strong> #esapiEncode('html',rc.trashItem.getObjectLabel())#</li>
<li><strong>Type:</strong> #esapiEncode('html',rc.trashItem.getObjectType())#</li>
<li><strong>SubType:</strong> #esapiEncode('html',rc.trashItem.getObjectSubType())#</li>
<li><strong>ObjectID:</strong> #esapiEncode('html',rc.trashItem.getObjectID())#</li>
<li><strong>SiteID:</strong> #esapiEncode('html',rc.trashItem.getSiteID())#</li>
<li><strong>ParentID:</strong> #esapiEncode('html',rc.trashItem.getParentID())#</li>
<li><strong>Object Class:</strong> #esapiEncode('html',rc.trashItem.getObjectClass())#</li>
<li><strong>DeleteID:</strong> #esapiEncode('html',rc.trashItem.getDeleteID())#</li>
<li><strong>Deleted Date:</strong> #LSDateFormat(rc.trashItem.getDeletedDate(),session.dateKeyFormat)# #LSTimeFormat(rc.trashItem.getDeletedDate(),"short")#</li>
<li><strong>Deleted By:</strong> #esapiEncode('html',rc.trashItem.getDeletedBy())#</li>
</ul>

<cfif not listFindNoCase("Page,Folder,File,Link,Gallery,Calender",rc.trashItem.getObjectType())>
	<div class="clearfix form-actions">
		<input type="button" class="btn" onclick="return confirmDialog('Restore Item From Trash?','?muraAction=cTrash.restore&objectID=#rc.trashItem.getObjectID()#&siteid=#rc.trashItem.getSiteID()#');" value="Restore Item" />
		<cfif len(rc.trashItem.getDeleteID())>
		<input type="button" class="btn" onclick="return confirmDialog('Restore All Items in Delete Transaction from Trash?','?muraAction=cTrash.restore&objectID=#rc.trashItem.getObjectID()#&deleteID=#rc.trashItem.getDeleteID()#&siteid=#rc.trashItem.getSiteID()#');" value="Restore All Items in Delete Transaction" />
		</cfif>
	</div>
<cfelse>
	<cfset parentBean=application.serviceFactory.getBean("content").loadBy(contentID=rc.trashItem.getParentID(),siteID=rc.trashItem.getSiteID())>

	<div class="control-group">
		<label class="control-label">
			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentparent')#:
			<span id="mover1" class="text"> 
			<cfif parentBean.getIsNew()>NA<cfelse>#esapiEncode('html',parentBean.getMenuTitle())#</cfif>

			<button id="selectParent" name="selectParent" class="btn">
				#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectnewparent')#
			</button>		
		</span>
		</label>
		<div class="controls" id="mover2" style="display:none"><input type="hidden" id="parentid" name="parentid" value="#esapiEncode('html_attr',rc.trashItem.getParentID())#"></div>
	</div>

	</div>

	<div class="clearfix form-actions">
	<input type="button" class="btn" onclick="restoreItem();" value="Restore Item" />
	<cfif len(rc.trashItem.getDeleteID())>
	<input type="button" class="btn" onclick="restoreAll();" value="Restore All Items in Delete Transaction" />
	</cfif>
	</div>

	<script>
	function restoreItem(){
		var parentid="";

		if(typeof(jQuery('##parentid').val()) != 'undefined' ){
			parentid=jQuery('##parentid').val();
		}else{
			parentid=jQuery('input:radio[name=parentid]:checked').val();		
		}
		
		if(parentid.length==35){
			confirmDialog('Restore Item From Trash?',"?muraAction=cTrash.restore&siteID=#rc.trashItem.getSiteID()#&objectID=#rc.trashItem.getObjectID()#&parentid=" + parentid);
		}else{
			alertDialog('Please select a valid content parent.');
		}
	}

	function restoreAll(){
		var parentid="";

		if(typeof(jQuery('##parentid').val()) != 'undefined' ){
			parentid=jQuery('##parentid').val();
		}else{
			parentid=jQuery('input:radio[name=parentid]:checked').val();
		}
		
		if(parentid.length==35){
			confirmDialog('Restore Item From Trash?',"?muraAction=cTrash.restore&siteID=#rc.trashItem.getSiteID()#&objectID=#rc.trashItem.getObjectID()#&deleteID=#rc.trashItem.getDeleteID()#&parentid=" + parentid);
		}else{
			alertDialog('Please select a valid content parent.');
		}
	}

	jQuery(document).ready(function(){
		$('##selectParent').click(function(e){
			e.preventDefault();
			siteManager.loadSiteParents(
				'#esapiEncode('javascript',rc.trashItem.getSiteID())#'
				,'#esapiEncode('javascript',rc.trashItem.getParentID())#'
				,'#esapiEncode('javascript',rc.trashItem.getParentID())#'
				,''
				,1
			);
			return false;
		});
	});
					
	</script>
</cfif>
</cfoutput>
