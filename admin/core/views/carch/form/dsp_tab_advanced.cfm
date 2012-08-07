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

<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.advanced"))/>
<cfset tabList=listAppend(tabList,"tabAdvanced")>
<cfoutput>
<div id="tabAdvanced" class="tab-pane">
	<div id="configuratorTab">

			<div class="control-group">
			      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentid')#</label>
			      <div class="controls"><cfif len(rc.contentID) and len(rc.contentBean.getcontentID())>#rc.contentBean.getcontentID()#<cfelse>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.notavailable')#</cfif></div>
			    </div>
			<cfif listFind("Gallery,Link,Portal,Page,Calendar",rc.type)>
				<div class="control-group">
			      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.currentfilename')#</label>
			      <div class="controls"><cfif rc.contentBean.getContentID() eq "00000000000000000000000000000000001">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.emptystring')#<cfelseif len(rc.contentID) and len(rc.contentBean.getcontentID())>#rc.contentBean.getFilename()#<cfelse>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.notavailable')#</cfif>
				</div>
			   </div>
			</cfif>

			<cfif rc.type neq 'Component' and rc.type neq 'Form'>
				<div class="control-group">
			      	<label class="control-label">
			      		<cfoutput><a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.layoutTemplate"))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.layouttemplate')#</a></cfoutput>
			  		</label>
			      <div class="controls">
			      	<select name="template" class="dropdown">
						<cfif rc.contentid neq '00000000000000000000000000000000001'>
							<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.inheritfromparent')#</option>
						</cfif>
						<cfloop query="rc.rsTemplates">
							<cfif right(rc.rsTemplates.name,4) eq ".cfm">
								<cfoutput>
									<option value="#rc.rsTemplates.name#" <cfif rc.contentBean.gettemplate() eq rc.rsTemplates.name>selected</cfif>>#rc.rsTemplates.name#</option>
								</cfoutput>
							</cfif>
						</cfloop>
					</select>
				</div>
			    </div>

				<div class="control-group">
			      	<label class="control-label">
			      		<cfoutput><a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.childTemplate"))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.childtemplate')#</a></cfoutput>
			      	</label>
			      	<div class="controls">
			      	<select name="childTemplate" class="dropdown">
						<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.none')#</option>
						<cfloop query="rc.rsTemplates">
							<cfif right(rc.rsTemplates.name,4) eq ".cfm">
								<cfoutput>
									<option value="#rc.rsTemplates.name#" <cfif rc.contentBean.getchildTemplate() eq rc.rsTemplates.name>selected</cfif>>#rc.rsTemplates.name#</option>
								</cfoutput>
							</cfif>
						</cfloop>
					</select>
				</div>
			    </div>

				<div class="control-group">
			      <div class="controls">
			      	<label for="forceSSL" class="checkbox">
			      	<input name="forceSSL" id="forceSSL" type="CHECKBOX" value="1" <cfif rc.contentBean.getForceSSL() eq "">checked <cfelseif rc.contentBean.getForceSSL() eq 1>checked</cfif> class="checkbox"> 
			      	<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.makePageSecure"))#">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.forcessltext'),application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.#rc.type#'))#
			      	</a>
			  		</label>
			      </div>
			    </div>

				<div class="control-group">
			      <div class="controls"><label for="searchExclude" class="checkbox"><input name="searchExclude" id="searchExclude" type="CHECKBOX" value="1" <cfif rc.contentBean.getSearchExclude() eq "">checked <cfelseif rc.contentBean.getSearchExclude() eq 1>checked</cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.searchexclude')#</label> 
			     </div>
			    </div>

				<div class="control-group">
			      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mobileexclude')#</label> 
			      <div class="controls">	
						<label class="radio"><input type="radio" name="mobileExclude" value="0" checked<!---<cfif rc.contentBean.getMobileExclude() eq 0> selected</cfif>--->>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mobileexclude.always')#</option></label>
						<label class="radio"><input type="radio" name="mobileExclude" value="2"<cfif rc.contentBean.getMobileExclude() eq 2> checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mobileexclude.mobile')#</label>
						<label class="radio"><input type="radio" name="mobileExclude" value="1"<cfif rc.contentBean.getMobileExclude() eq 1> checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mobileexclude.standard')#</label>
					</div>
			    </div>
				
				<cfif application.settingsManager.getSite(rc.siteid).getextranet()>
					<div class="control-group">
			      	<div class="controls"><label for="Restricted" class="checkbox"><input name="restricted" id="Restricted" type="checkbox" value="1"  onclick="javascript: this.checked?toggleDisplay2('rg',true):toggleDisplay2('rg',false);" <cfif rc.contentBean.getrestricted() eq 1>checked </cfif> class="checkbox">
					#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictaccess')#</label>
					</div> 
			      	<div class="controls"id="rg"<cfif rc.contentBean.getrestricted() NEQ 1> style="display:none;"</cfif>>
					<select name="restrictgroups" size="8" multiple="multiple" class="multiSelect" id="restrictGroups">
					<optgroup label="#htmlEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.globalsettings'))#">
					<option value="" <cfif rc.contentBean.getrestrictgroups() eq ''>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.allowall')#</option>
					<option value="RestrictAll" <cfif rc.contentBean.getrestrictgroups() eq 'RestrictAll'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictall')#</option>
					</optgroup>
					<cfquery dbtype="query" name="rsGroups">select * from rc.rsrestrictgroups where isPublic=1</cfquery>	
					<cfif rsGroups.recordcount>
						<optgroup label="#htmlEditFormat(application.rbFactory.getKeyValue(session.rb,'user.membergroups'))#">
						<cfloop query="rsGroups">
							<option value="#rsGroups.groupname#" <cfif listfind(rc.contentBean.getrestrictgroups(),rsGroups.groupname)>Selected</cfif>>#rsGroups.groupname#</option>
						</cfloop>
						</optgroup>
					</cfif>
					<cfquery dbtype="query" name="rsGroups">select * from rc.rsrestrictgroups where isPublic=0</cfquery>	
					<cfif rsGroups.recordcount>
						<optgroup label="#htmlEditFormat(application.rbFactory.getKeyValue(session.rb,'user.adminusergroups'))#">
						<cfloop query="rsGroups">
							<option value="#rsGroups.groupname#" <cfif listfind(rc.contentBean.getrestrictgroups(),rsGroups.groupname)>Selected</cfif>>#rsGroups.groupname#</option>
						</cfloop>
						</optgroup>
					</cfif>
					</select>
					</div>
			    </div>
				</cfif>
				
			</cfif>

			<cfif rc.type eq 'Component' and rc.rsTemplates.recordcount>
				<div class="control-group">
			      	<label class="control-label">
			      		<cfoutput><a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.layoutTemplate"))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.layouttemplate')#></a></cfoutput>
			      	</label> 
			      	<div class="controls">
			      		<select name="template" class="dropdown">
							<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.none')#</option>
							<cfloop query="rc.rsTemplates">
							<cfif right(rc.rsTemplates.name,4) eq ".cfm">
							<cfoutput>
							<option value="#rc.rsTemplates.name#" <cfif rc.contentBean.getTemplate() eq rc.rsTemplates.name>selected</cfif>>#rc.rsTemplates.name#</option>
							</cfoutput>
							</cfif></cfloop>
						</select>
					</div>
			    </div>
			</cfif>

			<cfif rc.type eq 'Form' >
				<div class="control-group">
				 	<div class="controls">
			     		<label for="forceSSL" class="checkbox">
			     			<input name="forceSSL" id="forceSSL" type="CHECKBOX" value="1" <cfif rc.contentBean.getForceSSL() eq "">checked <cfelseif rc.contentBean.getForceSSL() eq 1>checked</cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.forcessl')#
			     		</label>
			    	</div>
			    </div>
			    <div class="control-group">
				 	<div class="controls">
			      		<label for="displayTitle" class="checkbox">
			      			<input name="displayTitle" id="displayTitle" type="CHECKBOX" value="1" <cfif rc.contentBean.getDisplayTitle() eq "">checked <cfelseif rc.contentBean.getDisplayTitle() eq 1>checked</cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displaytitle')#
			      		</label>
			        </div>
			    </div>
			</cfif>

			<cfif application.settingsManager.getSite(rc.siteid).getCache() and rc.type eq 'Component' or rc.type eq 'Form'>
				<div class="control-group">
			      <div class="controls">
			      		<label for="cacheItem" class="checkbox">
			      			<input name="doCache" id="doCache" type="CHECKBOX" value="0"<cfif rc.contentBean.getDoCache() eq 0> checked</cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.docache')#
			      		</label>
			       </div>
			    </div>
			</cfif>
			 
			<cfif  rc.contentid neq '00000000000000000000000000000000001' and listFind(session.mura.memberships,'S2')>
				<div class="control-group">
			      <div class="controls"><label for="islocked" class="checkbox"><input name="isLocked" id="islocked" type="CHECKBOX" value="1" <cfif rc.contentBean.getIsLocked() eq "">checked <cfelseif rc.contentBean.getIsLocked() eq 1>checked</cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.locknode')#</label>
				 </div>
			    </div>
			</cfif>

			<cfif rc.type eq 'Portal' or rc.type eq 'Calendar' or rc.type eq 'Gallery'>
				<div class="control-group">
			      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'collections.imagesize')#</label> 
			      	<div class="controls">
						<select name="assets/imagesize" class="dropdown" onchange="if(this.value=='custom'){jQuery('##CustomImageOptions').fadeIn('fast')}else{jQuery('##CustomImageOptions').hide();jQuery('##CustomImageOptions').find(':input').val('AUTO');}">
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
					<div class="controls" id="CustomImageOptions"<cfif rc.contentBean.getImageSize() neq "custom"> style="display:none"</cfif>>
							<div class="control-group">
								<label class="control-label">
									#application.rbFactory.getKeyValue(session.rb,'collections.imagewidth')#
								</label>
								<div class="controls">
									<input name="imageWidth" class="text" value="#rc.contentBean.getImageWidth()#" />
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'collections.imageheight')#</label>
								<div class="controls">
									<input name="imageHeight" class="text" value="#rc.contentBean.getImageHeight()#" />
								</div>
							</div>
					</div>  
				</div>

				<div class="control-group" id="availableFields">
			      	<label class="control-label">
			      		<span>Available Fields</span> <span>Selected Fields</span>
			      	</label>
				  	<div class="controls sortableFields">
					
						<p class="dragMsg"><span class="dragFrom">Drag Fields from Here&hellip;</span><span>&hellip;and Drop Them Here.</span></p>
					
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
							setContentDisplayListSort();
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
	</cfif>

	<cfif (rc.type neq 'Component' and rc.type neq 'Form') and rc.contentBean.getcontentID() neq '00000000000000000000000000000000001'>
		<fieldset>
			<legend>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remoteinformation')#</legend> 
			     <div id="editRemote">
					<div class="control-group">
			     	 	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remoteid')#</label>
			     	 	<div class="controls"><input type="text" id="remoteID" name="remoteID" value="#rc.contentBean.getRemoteID()#"  maxlength="255" class="text"></div>
			   		</div>
					
					<div class="control-group">
			     	 	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remoteurl')#</label>
			      		<div class="controls"><input type="text" id="remoteURL" name="remoteURL" value="#rc.contentBean.getRemoteURL()#"  maxlength="255" class="text"></div>
			    	</div>
					
					<div class="control-group">
			     	 	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotepublicationdate')#</label>
			      		<div class="controls"><input type="text" id="remotePubDate" name="remotePubDate" value="#rc.contentBean.getRemotePubDate()#"  maxlength="255" class="text"></div>
			    	</div>
					
					<div class="control-group">
			     	 	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotesource')#</label>
			      		<div class="controls"><input type="text" id="remoteSource" name="remoteSource" value="#rc.contentBean.getRemoteSource()#"  maxlength="255" class="text"></div>
			    	</div>
					
					<div class="control-group">
			     	 	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotesourceurl')#</label>
			      		<div class="controls"><input type="text" id="remoteSourceURL" name="remoteSourceURL" value="#rc.contentBean.getRemoteSourceURL()#"  maxlength="255" class="text"></div>
			    	</div>
			    </div>
			 </fieldset>
		</cfif>
	</div>
</div>
</cfoutput>