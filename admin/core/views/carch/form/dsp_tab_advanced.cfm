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
<div id="tabAdvanced" class="tab-pane fade">
	
	<span id="extendset-container-tabadvancedtop" class="extendset-container"></span>

		<div class="fieldset">
			<div class="control-group">
			      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentid')#</label>
			      <div class="controls"><cfif len(rc.contentID) and len(rc.contentBean.getcontentID())>#rc.contentBean.getcontentID()#<cfelse>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.notavailable')#</cfif></div>
			    </div>
			<cfif listFind("Gallery,Link,Folder,Page,Calendar",rc.type)>
				<div class="control-group">
			      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.currentfilename')#</label>
			      <div class="controls"><cfif rc.contentBean.getContentID() eq "00000000000000000000000000000000001">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.emptystring')#<cfelseif len(rc.contentID) and len(rc.contentBean.getcontentID())>#rc.contentBean.getFilename()#<cfelse>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.notavailable')#</cfif>
				</div>
			   </div>
			</cfif>

			
			<cfif rc.contentBean.getType() eq 'Component'>
			<div class="control-group">
			      	<label class="control-label">
			      		<cfoutput><a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.layoutTemplate"))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.layouttemplate')# <i class="icon-question-sign"></i></a></cfoutput>
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

			<cfif rc.type neq 'Component' and rc.type neq 'Form'>
			

				<div class="control-group">
			      <div class="controls">
			      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.forcessllabel')#</label>
			      	<label for="forceSSL" class="checkbox">
			      	<input name="forceSSL" id="forceSSL" type="CHECKBOX" value="1" <cfif rc.contentBean.getForceSSL() eq "">checked <cfelseif rc.contentBean.getForceSSL() eq 1>checked</cfif> class="checkbox"> 
			      	<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.makePageSecure"))#">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.forcessltext'),application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.#rc.type#'))#
			      	 <i class="icon-question-sign"></i></a>
			  		</label>
			      </div>
			    </div>
				
			</cfif>

			<cfif rc.type eq 'Form' >
				<div class="control-group">
					<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.forcessllabel')#</label>
				 	<div class="controls">
			     		<label for="forceSSL" class="checkbox">
			     			<input name="forceSSL" id="forceSSL" type="CHECKBOX" value="1" <cfif rc.contentBean.getForceSSL() eq "">checked <cfelseif rc.contentBean.getForceSSL() eq 1>checked</cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.forcessl')#
			     		</label>
			    	</div>
			    </div>
			    <div class="control-group">
					<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displaytitlelabel')#</label>
				 	<div class="controls">
			      		<label for="displayTitle" class="checkbox">
			      			<input name="displayTitle" id="displayTitle" type="CHECKBOX" value="1" <cfif rc.contentBean.getDisplayTitle() eq "">checked <cfelseif rc.contentBean.getDisplayTitle() eq 1>checked</cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displaytitle')#
			      		</label>
			        </div>
			    </div>
			</cfif>

			<cfif application.settingsManager.getSite(rc.siteid).getCache() and rc.type eq 'Component' or rc.type eq 'Form'>
				<div class="control-group">
					<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.docachelabel')#</label>
			      <div class="controls">
			      		<label for="cacheItem" class="checkbox">
			      			<input name="doCache" id="doCache" type="CHECKBOX" value="0"<cfif rc.contentBean.getDoCache() eq 0> checked</cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.docache')#
			      		</label>
			       </div>
			    </div>
			</cfif>
			 
			<cfif  rc.contentid neq '00000000000000000000000000000000001' and listFind(session.mura.memberships,'S2')>
				<div class="control-group">
				<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.locknodelabel')#</label>
			      <div class="controls"><label for="islocked" class="checkbox"><input name="isLocked" id="islocked" type="CHECKBOX" value="1" <cfif rc.contentBean.getIsLocked() eq "">checked <cfelseif rc.contentBean.getIsLocked() eq 1>checked</cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.locknode')#</label>
				 </div>
			    </div>
			</cfif>
	</div>
	<cfif (rc.type neq 'Component' and rc.type neq 'Form') and rc.contentBean.getcontentID() neq '00000000000000000000000000000000001'>
		<div class="fieldset">
			<h2>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remoteinformation')#</h2> 
			     <!--- <div id="editRemote"> --->
					<div class="control-group">
							<div class="span6">
					     	 	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remoteid')#</label>
					     	 	<div class="controls"><input type="text" id="remoteID" name="remoteID" value="#rc.contentBean.getRemoteID()#"  maxlength="255" class="span12"></div>
							</div>
				     	 	<div class="span6">
					     	 	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remoteurl')#</label>
					      		<div class="controls"><input type="text" id="remoteURL" name="remoteURL" value="#rc.contentBean.getRemoteURL()#"  maxlength="255" class="span12"></div>
				     	 	</div>
			   		</div>

					
					<div class="control-group">
						 	<div class="span6">
				     	 	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotepublicationdate')#</label>
				      		<div class="controls"><input type="text" id="remotePubDate" name="remotePubDate" value="#rc.contentBean.getRemotePubDate()#"  maxlength="255" class="span12"></div>
						 	</div>
				      		
				      		<div class="span6">
				     	 	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotesource')#</label>
				      		<div class="controls"><input type="text" id="remoteSource" name="remoteSource" value="#rc.contentBean.getRemoteSource()#"  maxlength="255" class="span12"></div>
				      		</div>
			    	</div>
			    	
			    	<div class="control-group">
					     	 	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotesourceurl')#</label>
					      		<div class="controls"><input type="text" id="remoteSourceURL" name="remoteSourceURL" value="#rc.contentBean.getRemoteSourceURL()#"  maxlength="255" class="span6"></div>
			    	</div>
			    	
			    </div>
		</cfif>
	<!--- </div> --->

	<span id="extendset-container-advanced" class="extendset-container"></span>
	<span id="extendset-container-tabadvancedbottom" class="extendset-container"></span>

</div>

</cfoutput>