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
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.seo"))/>
<cfset tabList=listAppend(tabList,"tabSEO")>
<cfoutput>
  <div id="tabSEO" class="tab-pane fade">

  	<span id="extendset-container-tabseotop" class="extendset-container"></span>

	  <div class="fieldset">
					<div class="control-group">
			      		<label class="control-label">
			      			<a href="##" rel="tooltip" title="#application.rbFactory.getKeyValue(session.rb,"tooltip.navigationTitle")#">
			      				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.menutitle")#
			      			 <i class="icon-question-sign"></i></a>
			      		</label>
						<div class="controls">
							<input type="text" id="menuTitle" name="menuTitle" value="#HTMLEditFormat(rc.contentBean.getmenuTitle())#"  maxlength="255" class="span12">
						</div>
					</div>
							
					<div class="control-group">
			      		<label class="control-label">
			      			<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.urlTitle"))#">
			      				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.urltitle")#
			      			 <i class="icon-question-sign"></i></a>
			      		</label>
						<div class="controls">
								<input type="text" id="urlTitle" name="urlTitle" value="#HTMLEditFormat(rc.contentBean.getURLTitle())#"  maxlength="255" class="span12">
						</div>
					</div>
						
					<div class="control-group">
			      		<label class="control-label">
			      			<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.htmlTitle"))#">
			      				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.htmltitle")#
			      			 <i class="icon-question-sign"></i></a>
			      		</label>
						<div class="controls">
							<input type="text" id="htmlTitle" name="htmlTitle" value="#HTMLEditFormat(rc.contentBean.getHTMLTitle())#"  maxlength="255" class="span12">
						</div>
					</div>

					 <div class="control-group">
					  <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.description')#</label>
					      <div class="controls"><textarea name="metadesc" rows="8" id="metadesc" class="span12">#HTMLEditFormat(rc.contentBean.getMETADesc())#</textarea></div>
					    </div>

					  <div class="control-group">
					  <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.keywords')#</label>
					      <div class="controls"><textarea name="metakeywords" rows="8" id="metakeywords" class="span12">#HTMLEditFormat(rc.contentBean.getMETAKEYWORDS())#</textarea></div>
					    </div>

	  </div>

	<span id="extendset-container-seo" class="extendset-container"></span>
	<span id="extendset-container-tabseobottom" class="extendset-container"></span>

</div></cfoutput>