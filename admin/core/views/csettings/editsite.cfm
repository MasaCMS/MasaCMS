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

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/admin/
/tasks/
/config/
/requirements/mura/
You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfsilent>
<cfset rsThemes=rc.siteBean.getThemes() />
<cfset variables.pluginEvent=createObject("component","mura.event").init(request.event.getAllValues())/>
<cfset rsSites=application.settingsManager.getList() />
<cfset extendSets=application.classExtensionManager.getSubTypeByName("Site","Default",rc.siteid).getExtendSets(inherit=true,container="Default",activeOnly=true) />
<cfparam name="rc.action" default="">
<cfset rsPluginScripts=application.pluginManager.getScripts("onSiteEdit",rc.siteID)>
</cfsilent>

<h1>Site Settings</h1>
<cfoutput>
  <cfif len(rc.siteid)>
    <div id="nav-module-specific" class="btn-group"> <a class="btn" href="index.cfm?muraAction=cExtend.listSubTypes&siteid=#URLEncodedFormat(rc.siteid)#"><i class="icon-list-alt"></i> Class Extension Manager</a> <a  class="btn" href="index.cfm?muraAction=cTrash.list&siteID=#URLEncodedFormat(rc.siteid)#"><i class="icon-trash"></i> Trash Bin</a>
      <cfif rc.action eq "updateFiles">
        <a href="index.cfm?muraAction=cSettings.editSite&siteid=#URLEncodedFormat(rc.siteid)#"><i class="icon-pencil"></i> Edit Site</a>
        <cfelseif application.configBean.getAllowAutoUpdates()>
        <a  class="btn" href="##" onclick="confirmDialog('WARNING: Do not update your site files unless you have backed up your current siteID directory.',function(){actionModal('index.cfm?muraAction=cSettings.editSite&siteid=#URLEncodedFormat(rc.siteid)#&action=updateFiles')});return false;"><i class="icon-bolt"></i> Update Site Files to Latest Version</a> 

        <a  class="btn" href="?muraAction=cSettings.selectBundleOptions&siteID=#URLEncodedFormat(rc.siteBean.getSiteID())#"><i class="icon-gift"></i> Create Site Bundle</a>
      </cfif>
      <cfif len(rc.siteBean.getExportLocation()) and directoryExists(rc.siteBean.getExportLocation())>
        <a  class="btn" href="##"  onclick="confirmDialog('Export static HTML files to #JSStringFormat("'#rc.siteBean.getExportLocation()#'")#.',function(){actionModal('./?muraAction=csettings.exportHTML&siteID=#rc.siteBean.getSiteID()#')});return false;"><i class="icon-share"></i> Export Static HTML (BETA)</a>
      </cfif>
    </div>
  </cfif>
</cfoutput>
<cfif rc.action neq "updateFiles">
  <cfoutput>
    <form novalidate method ="post"  enctype="multipart/form-data" action="index.cfm?muraAction=cSettings.updateSite" name="form1"  onsubmit="return validate(this);">
    <!---
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="assets/js/ajax.js"></script>'>
<cfhtmlhead text='<script type="text/javascript" src="assets/js/tab-view.js"></script>'>
 --->
    <cfsavecontent variable="actionButtons">
    <cfoutput>
      <div class="form-actions">
        <cfif rc.siteBean.getsiteid() eq ''>
          <button type="button" class="btn" onclick="submitForm(document.forms.form1,'add');"  /><i class="icon-plus-sign"></i> Add</button>
          <cfelse>
          <cfif rc.siteBean.getsiteid() neq 'default'>
            <button type="button" class="btn" onclick="return confirmDialog('#JSStringFormat("WARNING: A deleted site and all of its files cannot be recovered. Are you sure that you want to continue?")#',function(){actionModal('index.cfm?muraAction=cSettings.updateSite&action=delete&siteid=#rc.siteBean.getSiteID()#')});" /><i class="icon-remove-sign"></i> Delete</button>
          </cfif>
          <button type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" /><i class="icon-ok-sign"></i> Update</button>
        </cfif>
      </div>
    </cfoutput>
    </cfsavecontent>
    <cfif arrayLen(extendSets)>
      <cfset tabLabelList='Basic,Contact Info,Shared Resources,Modules,Email,Images,Extranet,Display Regions,Extended Attributes,Deploy Bundle'>
      <cfset tabList='tabBasic,tabContactinfo,tabSharedresources,tabModules,tabEmail,tabImages,tabExtranet,tabDisplayregions,tabExtendedAttributes,tabBundles'>
      <cfelse>
      <cfset tabLabelList='Basic,Contact Info,Shared Resources,Modules,Email,Images,Extranet,Display Regions,Deploy Bundle'>
      <cfset tabList='tabBasic,tabContactinfo,tabSharedresources,tabModules,tabEmail,tabImages,tabExtranet,tabDisplayregions,tabBundles'>
    </cfif>
  </cfoutput> <cfoutput query="rsPluginScripts" group="pluginid"> <cfoutput>
      <cfset tabLabelList=listAppend(tabLabelList,rsPluginScripts.name)/>
      <cfset tabList=listAppend(tabList,"tab" & application.contentRenderer.createCSSID(rsPluginScripts.name))>
    </cfoutput> </cfoutput> <cfoutput>
    <div class="tabbable tabs-left">
    <ul class="nav nav-tabs tabs initActiveTab">
        <cfloop from="1" to="#listlen(tabList)#" index="t">
        <li><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
      </cfloop>
      </ul>
    <div class="tab-content">
    <!--- Basic --->
    <div id="tabBasic" class="tab-pane fade">
        <div class="fieldset">
        <div class="control-group">
            <div class="span6">
            <label class="control-label">Site ID</label>
            <div class="controls">
                <cfif rc.siteid eq ''>
                <input name="siteid" type="text" class="span12" value="#rc.siteBean.getsiteid()#" size="25" maxlength="25" required="true" onchange="removePunctuation(this);">
                <p class="help-block alert">Warning: No spaces, punctuation, dots or file delimiters allowed.</p>
                <cfelse>
                <input class="span12"  id="disabledInput" type="text" placeholder="#rc.siteBean.getsiteid()#" disabled>
                <input name="siteid" type="hidden" value="#rc.siteBean.getsiteid()#">
              </cfif>
              </div>
          </div>
            <div class="span6">
            <label class="control-label">Site</label>
            <div class="controls">
                <input name="site" type="text" class="span12"  value="#HTMLEditFormat(rc.siteBean.getsite())#" size="50" maxlength="50">
              </div>
          </div>
          </div>
        <div class="control-group">
            <label class="control-label">Tag Line</label>
            <div class="controls">
            <input name="tagline" type="text" class="span12"  value="#HTMLEditFormat(rc.siteBean.getTagline())#" size="50" maxlength="255">
          </div>
          </div>
        <div class="control-group">
            <div class="span6">
            <label class="control-label">Domain <span>(Example: www.google.com)</span></label>
            <div class="controls">
                <input name="domain" type="text" class="span12"  value="#HTMLEditFormat(rc.siteBean.getdomain('production'))#" size="50" maxlength="255">
              </div>
            <label class="control-label">Enforce Primary Domain</label>
            <div class="controls">
                <label class="radio inline">
                <input type="radio" name="enforcePrimaryDomain" value="0"<cfif rc.siteBean.getEnforcePrimaryDomain() neq 1> CHECKED</CFIF>>
                Off</label>
                <label class="radio inline">
                <input type="radio" name="enforcePrimaryDomain" value="1"<cfif rc.siteBean.getEnforcePrimaryDomain() eq 1> CHECKED</CFIF>>
                On</label>
              </div>
          </div>
            <div class="span6">
            <label class="control-label">Domain Alias List <span>(Line Delimited)</span></label>
            <div class="controls">
                <textarea rows="6" class="span12" name="domainAlias" rows="6" class="span12" >#HTMLEditFormat(rc.siteBean.getDomainAlias())#</textarea>
              </div>
          </div>
          </div>
        <div class="control-group">
            <div class="span6">
            <label class="control-label">Locale</label>
            <div class="controls">
                <select name="siteLocale">
                <option value="">Default</option>
                <cfloop list="#listSort(server.coldfusion.supportedLocales,'textnocase','ASC')#" index="l">
                    <option value="#l#"<cfif rc.siteBean.getSiteLocale() eq l> selected</cfif>>#l#</option>
                  </cfloop>
              </select>
              </div>
          </div>
            <div class="span6">
            <label class="control-label">Theme</label>
            <div class="controls">
                <select name="theme">
                <cfif rc.siteBean.hasNonThemeTemplates()>
                    <option value="">None</option>
                  </cfif>
                <cfloop query="rsThemes">
                    <option value="#rsThemes.name#"<cfif rsThemes.name eq rc.siteBean.getTheme() or (not len(rc.siteBean.getSiteID()) and rsThemes.currentRow eq 1)> selected</cfif>>#rsThemes.name#</option>
                  </cfloop>
              </select>
              </div>
          </div>
          </div>
        <div class="control-group">
            <div class="span6">
            <label class="control-label">Page Limit</label>
            <div class="controls">
                <input name="pagelimit" type="text" class="span12"  value="#HTMLEditFormat(rc.siteBean.getpagelimit())#" size="5" maxlength="6">
              </div>
          </div>
            <div class="span6">
            <label class="control-label">Default  Rows <span>(in Site Manager)</span></label>
            <div class="controls">
                <input name="nextN" type="text" class="span12"  value="#HTMLEditFormat(rc.siteBean.getnextN())#" size="5" maxlength="5">
              </div>
          </div>
          </div>
        <div class="control-group">
            <div class="span2">
            <label class="control-label">Site Caching</label>
            <div class="controls">
                <label class="radio inline">
                <input type="radio" name="cache" value="0"<cfif rc.siteBean.getcache() neq 1> CHECKED</CFIF>>
                Off</label>
                <label class="radio inline">
                <input type="radio" name="cache" value="1"<cfif rc.siteBean.getcache() eq 1> CHECKED</CFIF>>
                On</label>
              </div>
          </div>
            <div class="span4">
            <label class="control-label">Cache Capacity <span class="help-inline">(0=Unlimited)</span></label>
            <div class="controls">
                <input name="cacheCapacity" type="text" class="span3" value="#HTMLEditFormat(rc.siteBean.getCacheCapacity())#" size="15" maxlength="15">
              </div>
          </div>
            <div class="span6">
            <label class="control-label">Cache Free Memory Threshold <span class="help-inline">(Defaults to 60%)</span></label>
            <div class="controls">
                <input name="cacheFreeMemoryThreshold" type="text" class="span2" value="#HTMLEditFormat(rc.siteBean.getCacheFreeMemoryThreshold())#" size="3" maxlength="3">
                % </div>
          </div>
          </div>
        <div class="control-group">
            <div class="span6">
            <label class="control-label">Lock Site Architecture</label>
            <div class="controls">
                <p class="help-block">Restricts Addition or Deletion of Site Content</p>
                <label class="radio inline">
                <input type="radio" name="locking" value="none" <cfif rc.siteBean.getlocking() eq 'none' or rc.siteBean.getlocking() eq ''> CHECKED</CFIF>>
                None</label>
                <label class="radio inline">
                <input type="radio" name="locking" value="all" <cfif rc.siteBean.getlocking() eq 'all'> CHECKED</CFIF>>
                All</label>
                <label class="radio inline">
                <input type="radio" name="locking" value="top" <cfif rc.siteBean.getlocking() eq 'top'> CHECKED</CFIF>>
                Top</label>
              </div>
          </div>
            <div class="span6">
            <label class="control-label">Allow Comments to be Posted Without Site Admin Approval</label>
            <div class="controls">
                <label class="radio inline">
                <input type="radio" name="CommentApprovalDefault" value="1" <cfif rc.siteBean.getCommentApprovalDefault()  eq 1> CHECKED</CFIF>>
                Yes</label>
                <label class="radio inline">
                <input type="radio" name="CommentApprovalDefault" value="0" <cfif rc.siteBean.getCommentApprovalDefault() neq 1> CHECKED</CFIF>>
                No</label>
              </div>
          </div>
          </div>
        <div class="control-group">
            <label class="control-label">Static HTML Export Location (BETA)</label>
            <div class="controls">
            <cfif len(rc.siteBean.getExportLocation()) and not directoryExists(rc.siteBean.getExportLocation())>
                <p class="alert alert-error help-block">The current value is not a valid directory</p>
              </cfif>
            <input name="exportLocation" type="text" class="span12"  value="#rc.siteBean.getExportLocation()#" maxlength="100"/>
          </div>
          </div>
      </div>
    </div>
        
    <!--- Default Contact Info --->
    <div id="tabContactinfo" class="tab-pane fade">
	    <div class="fieldset">
	        <div class="control-group">
		        <div class="span6">
		            <label class="control-label">Contact Name </label>
		            <div class="controls">
		            	<input name="contactName" type="text" class="span12"  value="#HTMLEditFormat(rc.siteBean.getcontactName())#" size="50" maxlength="50" maxlength="100">
		            </div>
		        </div>
	          
		        <div class="span6">
		            <label class="control-label">Contact Address </label>
		            <div class="controls">
		            	<input name="contactAddress" type="text" class="span12"  value="#HTMLEditFormat(rc.siteBean.getcontactAddress())#" size="50" maxlength="50" maxlength="100">
		            </div>
		        </div>          
	        </div>
          
	        <div class="control-group">
		        <div class="span6">
		            <label class="control-label">Contact City </label>
		            <div class="controls">
		            	<input name="contactCity" type="text" class="span12"  value="#HTMLEditFormat(rc.siteBean.getcontactCity())#" size="50" maxlength="50" maxlength="100">
		            </div>
	            </div>

		        <div class="span2">
		            <label class="control-label">Contact State </label>
		            <div class="controls">
		            	<input name="contactState" type="text" class="span12"  value="#HTMLEditFormat(rc.siteBean.getcontactState())#" size="50" maxlength="50" maxlength="100">
		            </div>
	            </div>
            
		        <div class="span4">
		            <label class="control-label">Contact Zip </label>
		            <div class="controls">
		            	<input name="contactZip" type="text" class="span12"  value="#HTMLEditFormat(rc.siteBean.getcontactZip())#" size="50" maxlength="50" maxlength="100">
		            </div>
	            </div>
            </div>
          
	        <div class="control-group">
		        <div class="span6">
		            <label class="control-label">Contact Phone </label>
		            <div class="controls">
		            <input name="contactPhone" type="text" class="span12"  value="#HTMLEditFormat(rc.siteBean.getcontactPhone())#" size="50" maxlength="50" maxlength="100">
		            </div>
		        </div>
            
	        <div class="span6">
	            <label class="control-label">Contact Email </label>
	            <div class="controls">
	            <input name="contactEmail" type="text" class="span12"  value="#HTMLEditFormat(rc.siteBean.getcontactEmail())#" size="50" maxlength="50" maxlength="100">
	            </div>
	        </div>
            
          </div>
	   </div>
    </div>
    
    <!--- Shared Resources --->
    <div id="tabSharedresources" class="tab-pane fade">
        <div class="fieldset">
        <div class="control-group">
        <div class="span3">
        	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'siteconfig.sharedresources.memberuserpool')#</label>
	        <div class="controls">
	            <select class="span12"  id="publicUserPoolID" name="publicUserPoolID" onchange="if(this.value!='' || jQuery('##privateUserPoolID').val()!=''){jQuery('##bundleImportUsersModeLI').hide();jQuery('##bundleImportUsersMode').attr('checked',false);}else{jQuery('##bundleImportUsersModeLI').show();}">
	            <option value="">This site</option>
	            <cfloop query="rsSites">
	                <cfif rsSites.siteid neq rc.siteBean.getSiteID()>
	                <option value="#rsSites.siteid#" <cfif rsSites.siteid eq rc.siteBean.getPublicUserPoolID()>selected</cfif>>#HTMLEditFormat(rsSites.site)#</option>
	              </cfif>
	              </cfloop>
	          </select>
	          </div>
	      </div>
	      
        <div class="span3">
        <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'siteconfig.sharedresources.systemuserpool')#</label>
        <div class="controls">
            <select class="span12"  id="privateUserPoolID" name="privateUserPoolID" onchange="if(this.value!='' || jQuery('##publicUserPoolID').val()!=''){jQuery('##bundleImportUsersModeLI').hide();jQuery('##bundleImportUsersMode').attr('checked',false);}else{jQuery('##bundleImportUsersModeLI').show();}">
            <option value="">This site</option>
            <cfloop query="rsSites">
                <cfif rsSites.siteid neq rc.siteBean.getSiteID()>
                <option value="#rsSites.siteid#" <cfif rsSites.siteid eq rc.siteBean.getPrivateUserPoolID()>selected</cfif>>#HTMLEditFormat(rsSites.site)#</option>
              </cfif>
              </cfloop>
          </select>
          </div>
      </div>
      
        <div class="span3">
        <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'siteconfig.sharedresources.advertiseruserpool')#</label>
        <div class="controls">
            <select class="span12"  name="advertiserUserPoolID">
            <option value="">This site</option>
            <cfloop query="rsSites">
                <cfif rsSites.siteid neq rc.siteBean.getSiteID()>
                <option value="#rsSites.siteid#" <cfif rsSites.siteid eq rc.siteBean.getAdvertiserUserPoolID()>selected</cfif>>#HTMLEditFormat(rsSites.site)#</option>
              </cfif>
              </cfloop>
          </select>
          </div>
      </div>
        <div class="span3">
        <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'siteconfig.sharedresources.displayobjectpool')#</label>
        <div class="controls">
            <select class="span12"  name="displayPoolID">
            <option value="">This site</option>
            <cfloop query="rsSites">
                <cfif rsSites.siteid neq rc.siteBean.getSiteID()>
                <option value="#rsSites.siteid#" <cfif rsSites.siteid eq rc.siteBean.getDisplayPoolID()>selected</cfif>>#HTMLEditFormat(rsSites.site)#</option>
              </cfif>
              </cfloop>
          </select>
          </div>
          </div>
      </div>
        </div>
    </div>
    
    <!--- Modules --->
    <div id="tabModules" class="tab-pane fade">
	    <div class="fieldset">
	    
	        <div class="control-group">
	        
		        <div class="span3">
			        <label class="control-label">Extranet <span class="help-inline">(Password Protection)</span></label>
			        <div class="controls">
			            <label class="radio inline"><input type="radio" name="extranet" value="0" <cfif rc.siteBean.getextranet() neq 1> CHECKED</CFIF>>Off</label>
			            <label class="radio inline"><input type="radio" name="extranet" value="1" <cfif rc.siteBean.getextranet()  eq 1> CHECKED</CFIF>>On</label>
			        </div>
			    </div>
			    
		        <div class="span3">
			        <label class="control-label">Content Collections</label>
			        <div class="controls">
			            <label class="radio inline"><input type="radio" name="hasFeedManager" value="0" <cfif rc.siteBean.getHasFeedManager() neq 1> CHECKED</CFIF>>Off</label>
			            <label class="radio inline"><input type="radio" name="hasFeedManager" value="1" <cfif rc.siteBean.getHasFeedManager()  eq 1> CHECKED</CFIF>>On</label>
			        </div>
		        </div>
		        
		        <div class="span3">
			        <label class="control-label">Forms Manager</label>
			        <div class="controls">
			            <label class="radio inline">
			            <input type="radio" name="dataCollection" value="0" <cfif rc.siteBean.getdataCollection() neq 1> CHECKED</CFIF>>Off</label>
			            <label class="radio inline"><input type="radio" name="dataCollection" value="1" <cfif rc.siteBean.getdataCollection() eq 1> CHECKED</CFIF>>On</label>
			        </div>
		        </div>
	      
		        <div class="span3">
			        <label class="control-label">Advertisement Manager</label>
			        <div class="controls"> 
			            <!--- <p class="alert">NOTE: The Advertisement Manager is not supported within Mura Bundles and Staging to Production configurations.</p> --->
			            <label class="radio inline"><input type="radio" name="adManager" value="0" <cfif rc.siteBean.getadManager() neq 1> CHECKED</CFIF>>Off</label>
			            <label class="radio inline"><input type="radio" name="adManager" value="1" <cfif rc.siteBean.getadManager() eq 1> CHECKED</CFIF>>On</label>
			          </div>
			    </div>
	        
	        </div>
      
      
	        <div class="control-group">
	        
		        <div class="span3">
			        <label class="control-label">Email Broadcaster</label>
			        <div class="controls"> 
			            <!--- <p class="alert">NOTE: The Email Broadcaster is not supported within Mura Bundles.</p> --->
			            <label class="radio inline"><input type="radio" name="EmailBroadcaster" value="0" <cfif rc.siteBean.getemailbroadcaster() neq 1> CHECKED</CFIF>>Off</label>
			            <label class="radio inline"><input type="radio" name="EmailBroadcaster" value="1" <cfif rc.siteBean.getemailbroadcaster()  eq 1> CHECKED</CFIF>>On</label>
			        </div>
			    </div>
			      
		        <div class="span3">
			        <label class="control-label">Email Broadcaster Limit</label>
			        <div class="controls">
			            <input name="EmailBroadcasterLimit" type="text" class="span4" value="#HTMLEditFormat(rc.siteBean.getEmailBroadcasterLimit())#" size="50" maxlength="50">
			        </div>
			    </div>
			    
	        </div>
      
      
	        <div class="control-group">
	        
      
	        <div class="span3">
        <label class="control-label">Content Staging Manager</label>
        <div class="controls">
            <label class="radio inline">
            <input type="radio" name="hasChangesets" value="0" <cfif rc.siteBean.getHasChangesets() neq 1> CHECKED</CFIF>>
            Off </label>
            <label class="radio inline">
            <input type="radio" name="hasChangesets" value="1" <cfif rc.siteBean.getHasChangesets() eq 1> CHECKED</CFIF>>
            On </label>
          </div>
      </div>
	        
	        <div class="span6">
        <label class="control-label">Publish via Change Sets Only</label>
        <div class="controls">
            <label class="radio inline">
            <input type="radio" name="enforceChangesets" value="0" <cfif rc.siteBean.getEnforceChangesets() neq 1> CHECKED</CFIF>>
            Off </label>
            <label class="radio inline">
            <input type="radio" name="enforceChangesets" value="1" <cfif rc.siteBean.getEnforceChangesets() eq 1> CHECKED</CFIF>>
            On </label>
          </div>
      </div>
	    </div>
	    </div>
    </div>
    
    <!--- Email --->
    <div id="tabEmail" class="tab-pane fade">
	    <div class="fieldset">
	    
        <div class="control-group">
        <label class="control-label">Default "From" Email Address</label>
        <div class="controls">
            <input name="contact" type="text" class="span8" value="#HTMLEditFormat(rc.siteBean.getcontact())#" size="50" maxlength="50">
          </div>
      </div>
        <div class="control-group">
        <div class="span4">
        <label class="control-label">Mail Server IP/Host Name</label>
        <div class="controls">
            <input name="MailServerIP" type="text" class="text" value="#HTMLEditFormat(rc.siteBean.getMailServerIP())#" size="50" maxlength="50">
          </div>
      </div>
        <div class="span4">
        <label class="control-label">Mail Server SMTP Port</label>
        <div class="controls">
            <input name="MailServerSMTPPort" type="text" class="text" value="#HTMLEditFormat(rc.siteBean.getMailServerSMTPPort())#" size="5" maxlength="5">
          </div>
      </div>
        <div class="span4">
        <label class="control-label">Mail Server POP Port</label>
        <div class="controls">
            <input name="MailServerPOPPort" type="text" class="text" value="#HTMLEditFormat(rc.siteBean.getMailServerPOPPort())#" size="5" maxlength="5">
          </div>
      </div>
        </div>
        
        <div class="control-group">
        <div class="span6">
        <label class="control-label">Mail Server Username <a href="" rel="tooltip" data-original-title="<strong>Warning:</strong> Do Not Use a Personal Account. Email will be removed from server for tracking purposes."><i class="icon-warning-sign"></i></a></label>
        <div class="controls">
            <input name="MailServerUserName" type="text" class="span12" value="#HTMLEditFormat(rc.siteBean.getMailServerUserName())#" size="50" maxlength="50">
          </div>
      </div>
        <div class="span6">
        <label class="control-label">Mail Server Password</label>
        <div class="controls">
            <input name="MailServerPassword" type="text" class="span12" value="#HTMLEditFormat(rc.siteBean.getMailServerPassword())#" size="50" maxlength="50">
          </div>
      </div>
        </div>
      
        <div class="control-group">
        <div class="span3">
        <label class="control-label">Use TLS</label>
        <div class="controls">
            <label class="radio inline">
            <input type="radio" name="mailServerTLS" value="true" <cfif rc.siteBean.getmailServerTLS()  eq "true"> CHECKED</CFIF>>
            Yes </label>
            <label class="radio inline">
            <input type="radio" name="mailServerTLS" value="false" <cfif rc.siteBean.getmailServerTLS() eq "false"> CHECKED</CFIF>>
            No </label>
          </div>
      </div>
        <div class="span3">
        <label class="control-label">Use SSL</label>
        <div class="controls">
            <label class="radio inline">
            <input type="radio" name="mailServerSSL" value="true" <cfif rc.siteBean.getmailServerSSL()  eq "true"> CHECKED</CFIF>>
            Yes </label>
            <label class="radio inline">
            <input type="radio" name="mailServerSSL" value="false" <cfif rc.siteBean.getmailServerSSL() eq "false"> CHECKED</CFIF>>
            No </label>
          </div>
      </div>
        <div class="span3">
        <label class="control-label">Use Default SMTP Server</label>
        <div class="controls">
            <label class="radio inline">
            <input type="radio" name="useDefaultSMTPServer" value="1" <cfif rc.siteBean.getUseDefaultSMTPServer()  eq 1> CHECKED</CFIF>>
            Yes </label>
            <label class="radio inline">
            <input type="radio" name="useDefaultSMTPServer" value="0" <cfif rc.siteBean.getUseDefaultSMTPServer() neq 1> CHECKED</CFIF>>
            No </label>
          </div>
      </div>
      </div>
      
        <div class="control-group">
        <label class="control-label">User Login Info Request Script</label>
        <div class="controls">
            <p class="help-block">Available Dynamic Content: ##firstName## ##lastName## ##username## ##password## ##contactEmail## ##contactName## ##returnURL##</p>
            <textarea rows="6" class="span12" name="sendLoginScript">#HTMLEditFormat(rc.siteBean.getSendLoginScript())#</textarea>
          </div>
      </div>
        <div class="control-group">
        <label class="control-label">Mailing List Confirmation Script</label>
        <div class="controls">
            <p class="help-block">Available Dynamic Content: ##listName## ##contactName## ##contactEmail## ##returnURL##</p>
            <textarea rows="6" class="span12" name="mailingListConfirmScript">#HTMLEditFormat(rc.siteBean.getMailingListConfirmScript())#</textarea>
          </div>
      </div>
        <div class="control-group">
        <label class="control-label">Account Activation Script</label>
        <div class="controls">
            <p class="help-block">Available Dynamic Content: ##firstName## ##lastName## ##username## ##contactEmail## ##contactName##</p>
            <textarea rows="6" class="span12" name="accountActivationScript">#HTMLEditFormat(rc.siteBean.getAccountActivationScript())#</textarea>
          </div>
      </div>
        <div class="control-group">
        <label class="control-label">Public Submission Approval Script</label>
        <div class="controls">
            <p class="help-block">Available Dynamic Content: ##returnURL## ##contentName## ##parentName## ##contentType##</p>
            <textarea rows="6" class="span12" name="publicSubmissionApprovalScript">#HTMLEditFormat(rc.siteBean.getPublicSubmissionApprovalScript())#</textarea>
          </div>
      </div>
        <div class="control-group">
        <label class="control-label">Event Reminder Script</label>
        <div class="controls">
            <p class="help-block">Available Dynamic Content: ##returnURL## ##eventTitle## ##startDate## ##startTime## ##siteName## ##eventContactName## ##eventContactAddress## ##eventContactCity## ##eventContactState## ##eventContactZip## ##eventContactPhone##</p>
            <textarea rows="6" class="span12" name="reminderScript">#HTMLEditFormat(rc.siteBean.getReminderScript())#</textarea>
          </div>
      </div>
      
	    </div>
    </div>
    <!--- Galleries --->
    <div id="tabImages" class="tab-pane fade">
	    <div class="fieldset">
	    	
        <div class="control-group">
	        
	        <div class="span6">
	        <label class="control-label">Small (Thumbnail) Image</label>
	            <label>Height</label>
	            <div class="controls"><input name="smallImageHeight" type="text" class="span12" value="#rc.siteBean.getSmallImageHeight()#" /></div>
	        </div>
	        
	        <div class="span6"> 
	        <br />  
	            <label>Width</label>
	            <div class="controls"><input name="smallImageWidth" type="text" class="span12" value="#rc.siteBean.getSmallImageWidth()#" /></div>
	        </div>
	        
	    </div>
      
        <div class="control-group">
        <div class="span6">
	        <label class="control-label">Medium Image</label>
	            <label>Height</label>
	            <div class="controls"><input name="mediumImageHeight" type="text" class="span12" value="#rc.siteBean.getMediumImageHeight()#" /></div>
	        </div>
	        
	        <div class="span6"> 
	        <br />  
	            <label>Width</label>
	            <div class="controls"><input name="mediumImageWidth" type="text" class="span12" value="#rc.siteBean.getMediumImageWidth()#" /></div>
	        </div>
      </div>
      
        <div class="control-group">
        <div class="span6">
	        <label class="control-label">Large Image</label>
	            <label>Height</label>
	            <div class="controls"><input name="largeImageHeight" type="text" class="span12" value="#rc.siteBean.getLargeImageHeight()#" /></div>
	        </div>
	        
	        <div class="span6"> 
	        <br />  
	            <label>Width</label>
	            <div class="controls"><input name="largeImageWidth" type="text" class="span12" value="#rc.siteBean.getLargeImageWidth()#" /></div>
	        </div>
      </div>
      
        <cfif len(rc.siteBean.getSiteID())>
        <script>
      function openCustomImageSize(sizeid,siteid){
    
          jQuery("##custom-image-dialog").remove();
          jQuery("body").append('<div id="custom-image-dialog" rel="tooltip" title="Loading..." style="display:none"><div id="newContentMenu"><div class="load-inline"></div></div></div>');

          var dialogoptions= {
              Save: function() {
                saveCustomImageSize();
                jQuery( this ).dialog( "close" );
              },
              Cancel: function() {
                 jQuery( this ).dialog( "close" );
              }
            };

            if(sizeid != ''){
              dialogoptions.Delete=function(){
                deleteCustomImageSize();
                jQuery( this ).dialog( "close" );
              };
            }

          jQuery("##custom-image-dialog").dialog({
            resizable: true,
            modal: true,
            width: 400,
            position: getDialogPosition(),
            buttons: dialogoptions,
            open: function(){
              jQuery("##ui-dialog-title-custom-image-dialog").html('Edit Custom Image Size');
              jQuery("##custom-image-dialog").html('<div class="ui-dialog-content ui-widget-content"><div class="load-inline"></div></div>');
              var url = 'index.cfm';
              var pars = 'muraAction=cSettings.loadcustomimage&siteid=' + siteid +'&sizeid=' + sizeid  +'&cacheid=' + Math.random();
              jQuery.get(url + "?" + pars, 
                  function(data) {
                  jQuery('##custom-image-dialog').html(data);
                  $("##custom-image-dialog").dialog("option", "position", "center");
                  }
                );    
              
            },
            close: function(){
              jQuery(this).dialog("destroy");
              jQuery("##custom-image-dialog").remove();
            } 
        });

        return false;
     }

    function saveCustomImageSize(){
      loadCustomImages(
        {
          sizeid:$('##custom-image-form').attr('data-sizeid'),
          siteid:siteid,
          name:$('##custom-image-name').val(),
          height:$('##custom-image-height').val(),
          width:$('##custom-image-width').val(),
          imageaction:'save'
        }
      );
     }

    function deleteCustomImageSize(){
      if(confirm('Delete custom image size?')){
        loadCustomImages(
          {
            sizeid:$('##custom-image-form').attr('data-sizeid'),
            siteid:siteid,
            name:'',
            height:'',
            width:'',
            imageaction:'delete'
          }
        );
      }
     }

     function loadCustomImages(imageoptions){
        var merged=$.extend(
            {
              sizeid:'',
              siteid:'',
              name:'',
              height:'',
              width:'',
              imageaction:''
            },
            imageoptions
          );
        var url = 'index.cfm';
        var pars = 'muraAction=cSettings.loadcustomimages&siteid=' + merged.siteid + '&cacheid=' + Math.random();;
    
        jQuery.post(url + "?" + pars,
          merged, 
          function(data) {
            jQuery('##custom-images-container').html(data);
            }
        );    
     }

     $(document).ready(function(){loadCustomImages({siteid:'#JSStringFormat(rc.siteBean.getSiteID())#'})});

      </script>
      <div class="control-group">
        <label class="control-label">Custom Images</label>
        <ul class="nav nav-pills"><li><a href="##" onclick="return openCustomImageSize('','#JSStringFormat(rc.siteBean.getSiteID())#')"><i class="icon-plus-sign"></i>Add Custom Image Size</a></li></ul>
        <div id="custom-images-container"></div>
      </div>
      </cfif>
      
	    </div>
    </div>
    
    <!--- Extranet --->
    <div id="tabExtranet" class="tab-pane fade">
	    <div class="fieldset">
	    	
        <div class="control-group">
        <div class="span6">
        <label class="control-label">Allow Public Site Registration</label>
        <div class="controls">
            <label class="radio inline">
            <input type="radio" name="extranetpublicreg" value="0" <cfif rc.siteBean.getextranetpublicreg() neq 1> CHECKED</CFIF>>
            No </label>
            <label class="radio inline">
            <input type="radio" name="extranetpublicreg" value="1" <cfif rc.siteBean.getextranetpublicreg()  eq 1> CHECKED</CFIF>>
            Yes </label>
          </div>
      </div>
      
      <div class="span6">
        <label class="control-label">Require HTTPS Encryption for Extranet</label>
        <div class="controls">
            <label class="radio inline">
            <input type="radio" name="extranetssl" value="0" <cfif rc.siteBean.getextranetssl() neq 1> CHECKED</CFIF>>
            No </label>
            <label class="radio inline">
            <input type="radio" name="extranetssl" value="1" <cfif rc.siteBean.getextranetssl()  eq 1> CHECKED</CFIF>>
            Yes </label>
          </div>
      </div>
	</div>
	      
        <div class="control-group">
        <div class="span6">
        <label class="control-label">Custom Login URL</label>
        <div class="controls">
            <input name="loginURL" type="text" class="span12" value="#HTMLEditFormat(rc.siteBean.getLoginURL(parseMuraTag=false))#" maxlength="255">
          </div>
      </div>
        <div class="span6">
        <label class="control-label">Custom Profile URL</label>
        <div class="controls">
            <input name="editProfileURL" type="text" class="span12" value="#HTMLEditFormat(rc.siteBean.getEditProfileURL(parseMuraTag=false))#" maxlength="255">
          </div>
      </div>
        </div>
        <!---  <dt>Allow Public Submission In To Folders</dt>
      <dd>
        <input type="radio" name="publicSubmission" value="0" <cfif rc.siteBean.getpublicSubmission() neq 1> CHECKED</CFIF>>
        No&nbsp;&nbsp;
        <input type="radio" name="publicSubmission" value="1" <cfif rc.siteBean.getpublicSubmission() eq 1> CHECKED</CFIF>>
        Yes</dd>
      <dd> --->
       
        <div class="control-group">
        <label class="control-label">Email Site Registration Notifications to:</label>
        <div class="controls">
            <input name="ExtranetPublicRegNotify" type="text" class="span12" value="#rc.siteBean.getExtranetPublicRegNotify()#" size="50" maxlength="50">
          </div>
      </div>
      
	    </div>
    </div>
    
    <!--- Display Regions --->
    <div id="tabDisplayregions" class="tab-pane fade">
    	<div class="fieldset">
    	
        <div class="control-group">
        <div class="span6">
        <label class="control-label">Number of Display Regions</label>
        <div class="controls">
            <select class="span2" name="columnCount">
            <option value="1" <cfif rc.siteBean.getcolumnCount() eq 1 or rc.siteBean.getcolumnCount() eq 0> selected</cfif>> 1</option>
            <cfloop from="2" to="20" index="i">
                <option value="#i#" <cfif rc.siteBean.getcolumnCount() eq i> selected</cfif>>#i#</option>
              </cfloop>
          </select>
          </div>
          </div>
          </div>
          
         <div class="control-group">
         <div class="span6">
        <label class="control-label">Primary Display Region <span class="help-block">Dynamic System Content such as Login Forms<br />and Search Results get displayed here</span></label>
        <div class="controls">
            <select class="span2" name="primaryColumn">
            <cfloop from="1" to="20" index="i">
                <option value="#i#" <cfif rc.siteBean.getPrimaryColumn() eq i> selected</cfif>>#i#</option>
              </cfloop>
          </select>
            </div>
          </div>
      </div>
      
        <div class="control-group">
        <label class="control-label">Display Region Names <span class="help-inline">"^" Delimiter</span></label>
        <div class="controls">
            <input name="columnNames" type="text" class="span6" value="#HTMLEditFormat(rc.siteBean.getcolumnNames())#">
          </div>
      </div>
      
    	</div>
    </div>
    
    <!--- Extended Attributes --->
    <cfif arrayLen(extendSets)>
        <div id="tabExtendedAttributes" class="tab-pane fade">
	       <div class="fieldset">
        <cfset started=false />
        <cfloop from="1" to="#arrayLen(extendSets)#" index="s">
            <cfset extendSetBean=extendSets[s]/>
            <cfset style=extendSetBean.getStyle()/>
            <cfif not len(style)>
            <cfset started=true/>
          </cfif>
            <span class="extendset" extendsetid="#extendSetBean.getExtendSetID()#" categoryid="#extendSetBean.getCategoryID()#" #style#>
          <input name="extendSetID" type="hidden" value="#extendSetBean.getExtendSetID()#"/>
          <div class="fieldset">
              <h2>#extendSetBean.getName()#</h2>
              <cfsilent>
            <cfset attributesArray=extendSetBean.getAttributes() />
            </cfsilent>
              <cfloop from="1" to="#arrayLen(attributesArray)#" index="a">
              <cfset attributeBean=attributesArray[a]/>
              <cfset attributeValue=rc.siteBean.getvalue(attributeBean.getName(),'useMuraDefault') />
              <div class="control-group">
                  <label class="control-label">
                  <cfif len(attributeBean.getHint())>
                      <a rel="tooltip" href="##" title="#HTMLEditFormat(attributeBean.gethint())#">#attributeBean.getLabel()# <i class="icon-question-sign"></i></a>
                      <cfelse>
#attributeBean.getLabel()#
                    </cfif>
                  <cfif attributeBean.getType() eq "File" and len(attributeValue) and attributeValue neq 'useMuraDefault'>
                      <cfif listFindNoCase("png,jpg,jpeg",application.serviceFactory.getBean("fileManager").readMeta(attributeValue).fileExt)>
                      <a href="./index.cfm?muraAction=cArch.imagedetails&siteid=#rc.siteBean.getSiteID()#&fileid=#attributeValue#"><img id="assocImage" src="#application.configBean.getContext()#/tasks/render/small/index.cfm?fileid=#attributeValue#&cacheID=#createUUID()#" /></a>
                    </cfif>
                      <a href="#application.configBean.getContext()#/tasks/render/file/?fileID=#attributeValue#" target="_blank">[Download]</a>
                      <input type="checkbox" value="true" name="extDelete#attributeBean.getAttributeID()#"/>
                      Delete
                    </cfif>
                </label>
                  <!--- if it's an hidden type attribute then flip it to be a textbox so it can be editable through the admin --->
                  <cfif attributeBean.getType() IS "Hidden">
                  <cfset attributeBean.setType( "TextBox" ) />
                </cfif>
                  <div class="controls"> #attributeBean.renderAttribute(attributeValue)# </div>
                </div>
            </cfloop>
            </div>
          </span>
          </cfloop>
          </div>
        </div>
    </cfif>
    
    <!--- Site Bundles --->
    <div id="tabBundles" class="tab-pane fade">
    	<div class="fieldset">
    		
        <div class="control-group">
        	<label class="control-label"> Are you restoring a site from a backup bundle? </label>
        	<div class="controls">
            <label class="radio inline"><input type="radio" name="bundleImportKeyMode" value="copy" checked="checked">No - <em>Assign New Keys to Imported Items</em></label>
            <label class="radio inline" for=""><input type="radio" name="bundleImportKeyMode" value="publish">Yes - <em>Maintain All Keys from Imported Items</em></label>
          </div>
      </div>
        
        <div class="control-group">
        <label class="control-label">Include:</label>
        <div class="controls">
            <ul>
            <li>
                <label class="checkbox" for="bundleImportContentMode">
                <input id="bundleImportContentMode" name="bundleImportContentMode" value="all" type="checkbox" onchange="if(this.checked){jQuery('##contentRemovalNotice').show();}else{jQuery('##contentRemovalNotice').hide();}">
                Site Architecture &amp; Content</label>
              </li>
            <li id="bundleImportUsersModeLI"<cfif not (rc.siteBean.getPublicUserPoolID() eq rc.siteBean.getSiteID() and rc.siteBean.getPrivateUserPoolID() eq rc.siteBean.getSiteID())> style="display:none;"</cfif>>
                <label class="checkbox" for="bundleImportUsersMode">
                <input id="bundleImportUsersMode" name="bundleImportUsersMode" value="all" type="checkbox"  onchange="if(this.checked){jQuery('##userNotice').show();}else{jQuery('##userNotice').hide();}">
                Site Members &amp; Administrative Users</label>
              </li>
            <li>
                <label class="checkbox" for="bundleImportMailingListMembersMode">
                <input id="bundleImportMailingListMembersMode" name="bundleImportMailingListMembersMode" value="all" type="checkbox">
                Mailing Lists Members</label>
              </li>
            <li>
                <label class="checkbox" for="bundleImportFormDataMode">
                <input id="bundleImportFormDataMode" name="bundleImportFormDataMode" value="all" type="checkbox">
                Form Response Data</label>
              </li>
            <li>
                <label class="checkbox" for="bundleImportPluginMode">
                <input id="bundleImportPluginMode" name="bundleImportPluginMode" value="all" type="checkbox">
                All Plugins</label>
              </li>
          </ul>
            <p class="alert help-block" style="display:none" id="contentRemovalNotice"><strong>Important:</strong> When importing content from a Mura bundle ALL of the existing content will be deleted.</p>
            <p class="alert help-block" style="display:none" id="userNotice"><strong>Important:</strong> Importing users will remove all existing user data which may include the account that you are currently logged in as.</p>
          </div>
      </div>
        
        <div class="control-group">
	        <label class="control-label"> Which rendering files would you like to import? </label>
	        <div class="controls">
	            <label class="radio inline">
	            <input type="radio" name="bundleImportRenderingMode" value="all" onchange="if(this.value!='none'){jQuery('##themeNotice').show();}else{jQuery('##themeNotice').hide();}">All</label>
	            <label class="radio inline">
	            <input type="radio" name="bundleImportRenderingMode" value="theme" onchange="if(this.value!='none'){jQuery('##themeNotice').show();}else{jQuery('##themeNotice').hide();}">Theme Only</label>
	            <label class="radio inline">
	            <input type="radio" name="bundleImportRenderingMode" value="none" checked="checked" onchange="if(this.value!='none'){jQuery('##themeNotice').show();}else{jQuery('##themeNotice').hide();}">None</label>
	            <p class="alert help-block" style="display:none" id="themeNotice"><strong>Important:</strong> Your site's theme assignment and gallery image settings will be updated.</p>
	        </div>
        </div>
        
        <div class="control-group">
        <label class="control-label">Select Bundle File From Server
            <cfif application.configBean.getPostBundles()>
            (Preferred)
          </cfif>
          </label>
        <div class="controls">
            <p class="help-block alert">You can deploy a bundle that exists on the server by entering the complete server path to the Site Bundle here. This eliminates the need to upload the file via your web browser, avoiding some potential timeout issues.</p>
            <input class="text" type="text" name="serverBundlePath" id="serverBundlePath" value="">
            <input type="button" value="Browse Server" id="serverBundleBrowser"/>
            <script>
		jQuery(document).ready( function() {
			var finder = new CKFinder();
				finder.basePath = '#application.configBean.getContext()#/tasks/widgets/ckfinder/';
				finder.selectActionFunction = setServerBundlePath;
				finder.resourceType='Application_Root';
			
				 jQuery("##serverBundleBrowser").bind("click", function(){
					 finder.popup();
				 });		
		});
		
		function setServerBundlePath(fileUrl) {
			var check=fileUrl.split(".");
			if(check[check.length-1].toLowerCase() == 'zip'){
			jQuery('##serverBundlePath').val("#JSStringFormat('#application.configBean.getWebRoot()##application.configBean.getFileDelim()#')#" + fileUrl);
			}
		}
		</script> 
          </div>
      </div>
        <cfif application.configBean.getPostBundles()>
        <div class="control-group">
            <label class="control-label"><a rel="tooltip" title="Uploading large files via a web browser can produce inconsistent results.">Upload Bundle File</a></label>
            <div class="controls">
            <input type="file" name="bundleFile" accept=".zip"/>
          </div>
          </div>
        <cfelse>
        <input type="hidden" name="bundleFile" value=""/>
      </cfif>
      
    	</div>
    </div>
        
  </cfoutput>
  
  <cfoutput query="rsPluginScripts" group="pluginID"> 
    <!---<cfset tabLabelList=tabLabelList & ",'#jsStringFormat(rsPluginScripts.name)#'"/>--->
    <cfset tabID="tab" & application.contentRenderer.createCSSID(rsPluginScripts.name)>
    <div id="#tabID#" class="tab-pane fade"> <cfoutput>
        <cfset rsPluginScript=application.pluginManager.getScripts("onSiteEdit",rc.siteID,rsPluginScripts.moduleID)>
        <cfif rsPluginScript.recordcount>
#application.pluginManager.renderScripts("onSiteEdit",rc.siteid,pluginEvent,rsPluginScript)#
        </cfif>
      </cfoutput> </div>
  </cfoutput> <cfoutput> <div class="load-inline tab-preloader"></div> #actionButtons#
    <input type="hidden" name="action" value="update">
    </form>
  </cfoutput>
  <cfelse>
  <cftry>
    <cfset updated=application.autoUpdater.update(rc.siteid)>
    <cfset files=updated.files>
    <p class="alert alert-success">Your site's files have been updated to version <cfoutput>#application.autoUpdater.getCurrentCompleteVersion(rc.siteid)#</cfoutput>.</p>
    <p> <strong>Updated Files <cfoutput>(#arrayLen(files)#)</cfoutput></strong><br/>
      <cfif arrayLen(files)>
        <cfoutput>
          <cfloop from="1" to="#arrayLen(files)#" index="i">
#files[i]#             <br />
          </cfloop>
        </cfoutput>
      </cfif>
    </p>
    <cfcatch>
      <h2>An Error has occured.</h2>
      <cfdump var="#cfcatch.message#">
      <cfdump var="#cfcatch.TagContext#">
    </cfcatch>
  </cftry>
</cfif>