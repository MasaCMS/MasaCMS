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
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.listdisplayoptions"))/>
<cfset tabList=listAppend(tabList,"tabListDisplayOptions")>
<cfoutput>
  <div id="tabListDisplayOptions" class="tab-pane fade">

 <span id="extendset-container-tablistdisplayoptionstop" class="extendset-container"></span>

  <div class="fieldset">
			<div class="control-group">
				<div class="span2">
			      	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'collections.imagesize')#</label>
					<div class="controls">
						<select name="imageSize" data-displayobjectparam="imageSize" class="span12" onchange="if(this.value=='custom'){jQuery('##feedCustomImageOptions').fadeIn('fast')}else{jQuery('##feedCustomImageOptions').hide();jQuery('##feedCustomImageOptions').find(':input').val('AUTO');}">
							<cfloop list="Small,Medium,Large" index="i">
								<option value="#lcase(i)#"<cfif i eq rc.contentBean.getImageSize()> selected</cfif>>#I#</option>
							</cfloop>
					
							<cfset imageSizes=application.settingsManager.getSite(rc.siteid).getCustomImageSizeIterator()>
													
							<cfloop condition="imageSizes.hasNext()">
								<cfset image=imageSizes.next()>
								<option value="#lcase(image.getName())#"<cfif image.getName() eq rc.contentBean.getImageSize()> selected</cfif>>#HTMLEditFormat(image.getName())#</option>
							</cfloop>
								<option value="custom"<cfif "custom" eq rc.contentBean.getImageSize()> selected</cfif>>Custom</option>
						</select>
					</div>
				</div>
			
				<div id="feedCustomImageOptions" class="span6"<cfif rc.contentBean.getImageSize() neq "custom"> style="display:none"</cfif>>
				      <div class="span4">
				      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'collections.imagewidth')#
				      </label>
					<div class="controls">
						<input class="span10" name="imageWidth" data-displayobjectparam="imageWidth" type="text" value="#rc.contentBean.getImageWidth()#" />
					</div>
				      </div>
				      <div class="span4">
				      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'collections.imageheight')#</label>
				      <div class="controls">
				      	<input class="span10" name="imageHeight" data-displayobjectparam="imageHeight" type="text" value="#rc.contentBean.getImageHeight()#" />
					  </div>
				      </div>
				</div>	
	</div>

				<div class="control-group" id="availableFields">
			      	<label class="control-label">
						<span class="span6">Available Fields</span> <span class="span6">Selected Fields</span>
					</label>
					
					<div id="sortableFields" class="controls">
						<p class="dragMsg">
							<span class="dragFrom span6">Drag Fields from Here&hellip;</span><span class="span6">&hellip;and Drop Them Here.</span>
						</p>							
					
						<cfset displayList=rc.contentBean.getDisplayList()>
						<cfset availableList=rc.contentBean.getAvailableDisplayList()>
						<cfif rc.type eq "Gallery">
							<cfset finder=listFindNoCase(availableList,"Image")>
							<cfif finder>
								<cfset availableList=listDeleteAt(availableList,finder)>
							</cfif>
						</cfif>			
						<ul id="contentAvailableListSort" class="contentDisplayListSortOptions">
							<cfloop list="#availableList#" index="i">
								<li class="ui-state-default">#trim(i)#</li>
							</cfloop>
						</ul>
											
						<ul id="contentDisplayListSort" class="contentDisplayListSortOptions">
							<cfloop list="#displayList#" index="i">
								<li class="ui-state-highlight">#trim(i)#</li>
							</cfloop>
						</ul>
									
						<input type="hidden" id="contentDisplayList" value="#displayList#" name="displayList"/>
						
						<script>
							//Removed from jQuery(document).ready() because it would not fire in ie7 frontend editing.
							siteManager.setContentDisplayListSort();
						</script>
					</div>
			    </div>

				<div class="control-group">
			      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.recordsperpage')#</label> 
			      <div class="controls"><select name="nextN" class="dropdown">
					<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="r">
						<option value="#r#" <cfif r eq rc.contentBean.getNextN()>selected</cfif>>#r#</option>
					</cfloop>
					</select>
				</div>
			</div>

   
</div> 

	<span id="extendset-container-listdisplayoptions" class="extendset-container"></span>
	<span id="extendset-container-tablistdisplayoptionsbottom" class="extendset-container"></span>
	 
</div></cfoutput>