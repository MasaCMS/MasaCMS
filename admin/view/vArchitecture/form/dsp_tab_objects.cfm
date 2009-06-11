<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfparam name="request.rsContentObjects1.recordcount" default=0>
<cfparam name="request.rsContentObjects2.recordcount" default=0>
<cfparam name="request.rsContentObjects3.recordcount" default=0>
<cfparam name="request.rsContentObjects4.recordcount" default=0>
<cfparam name="request.rsContentObjects5.recordcount" default=0>
<cfparam name="request.rsContentObjects6.recordcount" default=0>
<cfparam name="request.rsContentObjects7.recordcount" default=0>
<cfparam name="request.rsContentObjects8.recordcount" default=0>
<div class="page_aTab">
		<dl class="oneColumn">
	<cfoutput>
<dt class="first"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.inheritancerules')#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.inheritanceRules")#</span></a></dt>
<dd><input type="radio" name="inheritObjects" id="ioi" value="Inherit" <cfif request.contentBean.getinheritObjects() eq 'inherit' or request.contentBean.getinheritObjects() eq ''>checked</cfif>> <label for="ioi">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.inheritcascade')#</label>
	<input type="radio" name="inheritObjects" id="ioc" value="Cascade" <cfif request.contentBean.getinheritObjects() eq 'cascade'>checked</cfif>> <label for="ioc">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startnewcascade')#</label> 
	<input type="radio" name="inheritObjects" id="ior" value="Reject" <cfif request.contentBean.getinheritObjects() eq 'reject'>checked</cfif>> <label for="ior">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.donotinheritcascade')#</label>
	</dd>
	<cfset hideObjects = not request.rsContentObjects1.recordcount and not request.rsContentObjects2.recordcount and not request.rsContentObjects3.recordcount />
<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentobjects')#</dt>
<dd id="editObjects">
<!---<a href="javascript:;" onClick="javascript: toggleDisplay('editObjects'); return false">Display Objects</a>
<div id="editObjects" style="display: none;">--->
	<table class="displayObjects">		
			 <tr>
				<td  class="nested" rowspan="#application.settingsManager.getSite(attributes.siteid).getcolumnCount()#" valign="top">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.availablecontentobjects')#<br />
				<select name="classSelector" onchange="loadObjectClass('#attributes.siteid#',this.value,'');" class="dropdown" id="dragme">
				<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectobjecttype')#</option>
				<option value="system">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.system')#</option>
				<cfif application.settingsManager.getSite(attributes.siteid).getemailbroadcaster()>
				<option value="mailingList">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mailinglists')#</option>
				</cfif>
				<cfif application.settingsManager.getSite(attributes.siteid).getAdManager()>
				<option value="adzone">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.adregions')#</option>
				</cfif>
				<!--- <option value="category">Categories</option> --->
				<option value="portal">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.portals')#</option>
				<option value="calendar">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.calendars')#</option>
				<option value="gallery">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.galleries')#</option>
				<option value="component">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.components')#</option>
				<cfif application.settingsManager.getSite(attributes.siteid).getDataCollection()>
				<option value="form">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.forms')#</option>
				</cfif>
				<cfif application.settingsManager.getSite(attributes.siteid).getHasfeedManager()>
				<option value="localFeed">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexes')#</option>
				<option value="slideshow">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexslideshows')#</option>
				<option value="remoteFeed">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotefeeds')#</option>
				</cfif>
				<cfif fileExists("#application.configBean.getWebRoot()##application.configBean.getFileDelim()##attributes.siteid##application.configBean.getFileDelim()#includes#application.configBean.getFileDelim()#display_objects#application.configBean.getFileDelim()#custom#application.configBean.getFileDelim()#admin#application.configBean.getFileDelim()#dsp_objectClassLabel.cfm")> 
				<cfinclude template="/#application.configBean.getWebRootMap()#/#attributes.siteID#/includes/display_objects/custom/admin/dsp_objectClassLabel.cfm" >
				</cfif>
				<option value="plugins">#application.rbFactory.getKeyValue(session.rb,'layout.plugins')#</option>
				</select>
				<div id="classList"></div>
				</td>
				<td class="nested">
				<cfloop from="1" to="#application.settingsManager.getSite(attributes.siteid).getcolumnCount()#" index="r"> 
				
							<table>
							<tr>
							<td class="nested">
							<input type="button" value=">>" onclick="addObject('availableObjects','selectedObjects#r#','objectList#r#');" class="objectNav"><br />
							<input type="button" value="<<" onclick="deleteObject('selectedObjects#r#','objectList#r#');" class="objectNav">
							</td>
							<td class="nested">
							<cfif listlen(application.settingsManager.getSite(attributes.siteid).getcolumnNames(),"^") gte r><strong>#listgetat(application.settingsManager.getSite(attributes.siteid).getcolumnNames(),r,"^")#</strong> <cfelse><strong>Region #r#</strong></cfif> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentobjects')#<br />
							<cfset variables["objectlist#r#"]="">
							<select name="selectedObjects#r#" id="selectedObjects#r#" class="multiSelect" multiple size="4">
							<cfloop query="request.rsContentObjects#r#">
							<option value="#request["rsContentObjects#r#"].object#~#request["rsContentObjects#r#"].name#~#request["rsContentObjects#r#"].objectid#">#request["rsContentObjects#r#"].name#</option>
							<cfset variables["objectlist#r#"]=listappend(variables["objectlist#r#"],"#request["rsContentObjects#r#"].object#~#request["rsContentObjects#r#"].name#~#request["rsContentObjects#r#"].objectid#","^")>
							</cfloop>
							</select>
							<input type="hidden" name="objectList#r#" id="objectList#r#" value="#variables["objectlist#r#"]#">
				
							</td>
							<td  class="nested"><input type="button" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.up')#" onclick="moveUp('selectedObjects#r#','objectList#r#');" class="objectNav"><br />
							<input type="button" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.down')#" onclick="moveDown('selectedObjects#r#','objectList#r#');" class="objectNav">
							</td>
							</tr>
							</table>
					</cfloop>
				</td>
			  </tr>
			
			
	</table>
</dd>	  
</dl></div>	
</cfoutput>
<!---<script>
  dndMgr.registerDraggable( new Rico.Draggable('test-rico-dnd','dragme') );
  dndMgr.registerDropZone( new Rico.Dropzone('selectedObjects1') );
  dndMgr.registerDropZone( new Rico.Dropzone('selectedObjects2') );
</script>
--->