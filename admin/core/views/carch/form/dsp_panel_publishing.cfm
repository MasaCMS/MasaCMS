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
<cfset tabList=listAppend(tabList,"tabPublishing")>
<cfoutput>
<div class="mura-panel panel">
	<div class="mura-panel-heading" role="tab" id="heading-publishing">
		<h4 class="mura-panel-title">
			<a class="collapse collapsed" role="button" data-toggle="collapse" data-parent="##content-panels" href="##panel-publishing" aria-expanded="false" aria-controls="panel-publishing">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.publishing")#</a>
		</h4>
	</div>
		<div id="panel-publishing" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-publishing" aria-expanded="false" style="height: 0px;">
			<div class="mura-panel-body">

			<span id="extendset-container-tabpublishingtop" class="extendset-container"></span>

			<!--- featured --->
			<cfif not listFindNoCase('Component,Form,Variation',rc.type) and rc.contentid neq '00000000000000000000000000000000001'>
				<div class="mura-control-group">
					 <label>
					     	#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.isfeature')#
					</label>
			    	<select name="isFeature" onchange="javascript: this.selectedIndex==2?toggleDisplay2('editFeatureDates',true):toggleDisplay2('editFeatureDates',false);">
						<option value="0"  <cfif  rc.contentBean.getisfeature() EQ 0> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
						<option value="1"  <cfif  rc.contentBean.getisfeature() EQ 1> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
						<option value="2"  <cfif rc.contentBean.getisfeature() EQ 2> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.perschedule')#</option>
					</select>

					<div id="editFeatureDates" <cfif rc.contentBean.getisfeature() NEQ 2>style="display: none;"</cfif>>

						<div id="featureschedule-label"></div>
						<!--- 'big ui' flyout panel --->
						<!--- todo: resource bundle key for 'manage schedule' --->
						<div class="bigui" id="bigui__featureschedule" data-label="#esapiEncode('html_attr', 'Manage Schedule')#">
							<div class="bigui__title">#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.schedule'))#</div>
							<div class="bigui__controls">

								<div id="featureschedule-selector">
									<div class="mura-control-group">
										<label class="date-span">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.from')#</label>
											<cf_datetimeselector name="featureStart" datespanclass="time" datetime="#rc.contentBean.getFeatureStart()#">
									</div>
									<div class="mura-control-group">
											<label class="date-span">
											#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.to')#
											</label>
											<cf_datetimeselector name="featureStop" datespanclass="time" datetime="#rc.contentBean.getFeatureStop()#" defaulthour="23" defaultminute="59">
									</div>

								</div>
							</div>
						</div> <!--- /.bigui --->

					</div>
				</div> <!--- /.mura-control-group --->
	
				<!--- todo: resource bundle key for 'Featured' --->
				<script type="text/javascript">
					function showSelectedFeat(){
						var featStr = '';
						var startDate = $('##mura-datepicker-featureStart').val();
						var stopDate = $('##mura-datepicker-featureStop').val();
						if (startDate != ''){
							var featStr = startDate 
							+ ' ' + $('##mura-featureStartHour option:selected').html()
							+ ':' + $('##mura-featureStartMinute option:selected').html()
							+ ' ' + $('##mura-featureStartDayPart option:selected').html();
	
							if (stopDate != ''){
								var featStr = featStr +  ' to ' + stopDate 
								+ ' ' + $('##mura-featureStopHour option:selected').html()
								+ ':' + $('##mura-featureStopMinute option:selected').html()
								+ ' ' + $('##mura-featureStopDayPart option:selected').html();
							}
	
						}

						$('##featureschedule-label').html(featStr);
					}

					$(document).ready(function(){
						// run on page load
						setTimeout(function(){
							showSelectedFeat();
						}, 300);
						// run on change of any schedule element
						$('##featureschedule-selector *').on('change',function(){
							showSelectedFeat();
						})
					});				
				</script>

			</cfif><!--- / end featured --->

			<!--- release date --->
	  		<cfif listFindNoCase('Page,Folder,Calendar,Gallery,File,Link',rc.type)>
				<div class="mura-control-group">
				    <label>
				    	<span data-toggle="popover" title="" data-placement="right"
					    	data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.contentReleaseDate"))#"
					    	data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.releasedate"))#"
					    	>
			      		#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.releasedate')#
				      	 <i class="mi-question-circle"></i>
				      </span>
			      </label>
			      <cf_datetimeselector name="releaseDate" datetime="#rc.contentBean.getReleaseDate()#" timeselectwrapper="true">
				</div> <!--- /end mura-control-group --->
			</cfif>	<!--- /release date --->

			<!--- restrict by type --->
		  	<cfif listFindNoCase('Page,Folder,Calendar,Gallery,File,Link',rc.type)>

 				<!--- navigation --->
				<div class="mura-control-group boolean">
			      	<label for="isNav" class="checkbox">
			      		<input name="isnav" id="isNav" type="checkbox" value="1" <cfif rc.contentBean.getisnav() eq 1 or rc.contentBean.getisNew() eq 1>checked</cfif> class="checkbox">
				    	<span data-toggle="popover" title="" data-placement="right" data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.includeSiteNav"))#" data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.isnav"))#">
						      #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.isnav')#
				    		 <i class="mi-question-circle"></i>
			    		</span> 
			      	</label>
				</div> <!--- /end mura-control-group --->

				<!--- open new window --->
				<div class="mura-control-group boolean">
			     	<label for="Target" class="checkbox">
			     	<input  name="target" id="Target" type="checkbox" value="_blank" <cfif rc.contentBean.gettarget() eq "_blank">checked</cfif> class="checkbox" >
			    		<span data-toggle="popover" title="" data-placement="right" data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.openNewWindow"))#" data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.newWindow"))#">
					     		#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.newwindow')#
							<i class="mi-question-circle"></i>
				     	</span>	 
			     	</label>
				</div> <!--- /end mura-control-group --->

				<!--- exclude from search --->
				<div class="mura-control-group boolean">
					 <label for="searchExclude" class="checkbox"><input name="searchExclude" id="searchExclude" type="checkbox" value="1" <cfif rc.contentBean.getSearchExclude() eq "">checked <cfelseif rc.contentBean.getSearchExclude() eq 1>checked</cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.searchexclude')#</label>
				</div> <!--- /end mura-control-group --->

			</cfif>	

			<!--- lock node --->
			<cfif  rc.contentid neq '00000000000000000000000000000000001' and listFind(session.mura.memberships,'S2')>
				<div class="mura-control-group boolean">
			  <!--- <label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.locknodelabel')#</label> --->
					<label for="islocked" class="checkbox"><input name="isLocked" id="islocked" type="checkbox" value="1" <cfif rc.contentBean.getIsLocked() eq "">checked <cfelseif rc.contentBean.getIsLocked() eq 1>checked</cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.locknode')#</label>
			    </div>
			</cfif> <!--- ./lock node --->			

			<!--- restrict by type --->
		  	<cfif listFindNoCase('Page,Folder,Calendar,Gallery,File,Link',rc.type)>

		  		<!--- restrict access --->
				<cfif application.settingsManager.getSite(rc.siteid).getextranet()>
					<div class="mura-control-group boolean">
				      	<label for="Restricted" class="checkbox"><input name="restricted" id="Restricted" type="checkbox" value="1"  onclick="javascript: this.checked?toggleDisplay2('rg',true):toggleDisplay2('rg',false);" <cfif rc.contentBean.getrestricted() eq 1>checked </cfif> class="checkbox">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictaccess')#
						</label>
					</div>
			      	<div class="mura-control=group" id="rg"<cfif rc.contentBean.getrestricted() NEQ 1> style="display:none;"</cfif>>
			      		<div class="mura-control justify">
							<select name="restrictgroups" size="8" multiple="multiple" class="multiSelect" id="restrictGroups">
							<optgroup label="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.globalsettings'))#">
							<option value="" <cfif rc.contentBean.getrestrictgroups() eq ''>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.allowall')#</option>
							<option value="RestrictAll" <cfif rc.contentBean.getrestrictgroups() eq 'RestrictAll'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictall')#</option>
							</optgroup>
							<cfquery dbtype="query" name="rsGroups">select * from rc.rsrestrictgroups where isPublic=1</cfquery>
							<cfif rsGroups.recordcount>
								<optgroup label="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'user.membergroups'))#">
								<cfloop query="rsGroups">
									<option value="#rsGroups.userid#" <cfif listfind(rc.contentBean.getrestrictgroups(),rsGroups.groupname) or listfind(rc.contentBean.getrestrictgroups(),rsGroups.userid)>Selected</cfif>>#rsGroups.groupname#</option>
								</cfloop>
								</optgroup>
							</cfif>
							<cfquery dbtype="query" name="rsGroups">select * from rc.rsrestrictgroups where isPublic=0</cfquery>
							<cfif rsGroups.recordcount>
								<optgroup label="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'user.adminusergroups'))#">
								<cfloop query="rsGroups">
									<option value="#rsGroups.userid#" <cfif listfind(rc.contentBean.getrestrictgroups(),rsGroups.groupname) or listfind(rc.contentBean.getrestrictgroups(),rsGroups.userid)>Selected</cfif>>#rsGroups.groupname#</option>
								</cfloop>
								</optgroup>
							</cfif>
							</select>
						</div> <!--- /end mura-control justify --->	
					</div> <!--- /end mura-control-group --->
			    </cfif>
			    <!--- /end restrict access --->

			</cfif> <!--- /end restrict by type --->

			<!--- exclude from cache --->
			<cfif application.settingsManager.getSite(rc.siteid).getCache() and rc.type eq 'Component' or rc.type eq 'Form'>
				<div class="mura-control-group boolean">
<!--- 					<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.docachelabel')#</label> --->
		      		<label for="cacheItem" class="checkbox">
		      			<input name="doCache" id="doCache" type="checkbox" value="0"<cfif rc.contentBean.getDoCache() eq 0> checked</cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.docache')#
		      		</label>
		       </div>
			</cfif>

			<!--- ssl --->
			<cfif rc.type eq 'Component'>
				<div class="mura-control-group">
			      	<label>
			      		<cfoutput>
								<span data-toggle="popover" title="" data-placement="right"
						  	data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.layoutTemplate"))#"
						  	data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.layouttemplate"))#"
						  	>
								#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.layouttemplate')# <i class="mi-question-circle"></i></span>
							</cfoutput>
			      	</label>
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
			</cfif>
			<!--- Use site useSSL sitewide setting instead --->
			<cfif not listFindNoCase('Component,Form,Variation',rc.type) and rc.contentBean.getForceSSL() and not rc.$.siteConfig('useSSL')>
				<div class="mura-control-group">
				    <label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.forcessllabel')#</label>
			      	<label for="forceSSL" class="checkbox">
			      	<input name="forceSSL" id="forceSSL" type="checkbox" value="1" <cfif rc.contentBean.getForceSSL() eq "">checked <cfelseif rc.contentBean.getForceSSL() eq 1>checked</cfif> class="checkbox">
										<span data-toggle="popover" title="" data-placement="right"
								  	data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.makePageSecure"))#"
								  	data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.forcessllabel"))#">
								  	#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.forcessltext'),application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.#rc.type#'))#
					      	 <i class="mi-question-circle"></i>
					      	</span>
			  		</label>
			      </div>
			</cfif>

			<cfif not rc.$.siteConfig().getContentRenderer().useLayoutManager() and rc.type eq 'Form' >

				<cfif rc.contentBean.getForceSSL() and not rc.$.siteConfig('useSSL')>
					<div class="mura-control-group boolean">
						<!--- <label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.forcessllabel')#</label> --->
			     		<label for="forceSSL" class="checkbox">
			     			<input name="forceSSL" id="forceSSL" type="checkbox" value="1" <cfif rc.contentBean.getForceSSL() eq "">checked <cfelseif rc.contentBean.getForceSSL() eq 1>checked</cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.forcessl')#
			     		</label>
				    </div>
			   	</cfif>

			    <div class="mura-control-group boolean">
		      		<label for="displayTitle" class="checkbox">
		      			<input name="displayTitle" id="displayTitle" type="checkbox" value="1" <cfif rc.contentBean.getDisplayTitle() eq "">checked <cfelseif rc.contentBean.getDisplayTitle() eq 1>checked</cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displaytitlelabel')#
		      		</label>
		        </div>
			</cfif>

			<!--- notify for review --->
			<div class="mura-control-group boolean">
					<label for="dspnotify" class="checkbox">
			  		<input type="checkbox" name="dspNotify"  id="dspnotify" onclick="siteManager.loadNotify('#esapiEncode('javascript',rc.siteid)#','#esapiEncode('javascript',rc.contentid)#','#esapiEncode('javascript',rc.parentid)#');"  class="checkbox">
					<span data-toggle="popover" title="" data-placement="right"
						data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.notifyReview"))#"
						data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.notifyforreview"))#">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.notifyforreview')#
			      		 <i class="mi-question-circle"></i>
					 </span>
			  	</label>
				<div id="selectNotify" class="mura-control justify" style="display: none;"></div>
			</div> <!--- /end mura-control-group --->
			
			<!--- expiration --->
			<cfif listFind("Page,Folder,Calendar,Gallery,Link,File,Link",rc.type)>

				<div class="mura-control-group">
					<label>#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expires'))#</label>
					<div class="mura-control justify">
						<div id="expire-label">Expires: never</div>

					<!--- 'big ui' flyout panel --->
					<!--- todo: resource bundle key for 'manage expiration' --->
					<div class="bigui" id="bigui__expireschedule" data-label="#esapiEncode('html_attr', 'Manage Expiration')#">
						<div class="bigui__title">#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expires'))#</div>
						<div class="bigui__controls">

							<div class="mura-control-group" id="expireschedule-selector">
								<label><!---placeholder do not delete ---></label>
						     	<cf_datetimeselector name="expires" datetime="#rc.contentBean.getExpires()#" defaulthour="23" defaultminute="59">
								<div class="mura-control justify" id="expires-notify">
									<label for="dspexpiresnotify" class="checkbox">
										<input type="checkbox" name="dspExpiresNotify" id="dspexpiresnotify" onclick="siteManager.loadExpiresNotify('#esapiEncode('javascript',rc.siteid)#','#esapiEncode('javascript',rc.contenthistid)#','#esapiEncode('javascript',rc.parentid)#');"  class="checkbox"<cfif application.contentUtility.getNotify(rc.crumbdata).recordCount> checked</cfif>>
											#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expiresnotify')#
									</label>
								</div>
							<div class="mura-control-group" id="selectExpiresNotify"<cfif application.contentUtility.getNotify(rc.crumbdata).recordCount eq 0> style="display: none;"</cfif>></div>
							</div> <!--- /end mura-control-group --->
						</div>
					</div> <!--- /.bigui --->

					</div>
				</div>	

				<!--- todo: resource bundle key for 'Expires' --->
				<script type="text/javascript">
					function showSelectedExp(){
						var expStr = 'Never';
						var notifyCt = $('##expiresnotify option:selected[value!=""]').not(':empty').length;
						if ($('##mura-datepicker-expires').val() != ''){
							expStr = $('##mura-datepicker-expires').val() + ' ' 
											+ $('##mura-expiresHour').val() + ':' 
											+ $('##mura-expiresMinute option:selected').html() + ' '
											+ $('##mura-expiresDayPart option:selected').html();					
						}
						 if ($('##dspexpiresnotify').is(':checked') && notifyCt > 0){
						 	expStr += '<br>Notifying: ' + notifyCt;
						 }
						$('##expire-label').html('Expires: ' + expStr);
					}

					$(document).ready(function(){
						// load notification list if previously selected
						<cfif application.contentUtility.getNotify(rc.crumbdata).recordCount>
							siteManager.loadExpiresNotify('#esapiEncode('javascript',rc.siteid)#','#esapiEncode('javascript',rc.contenthistid)#','#esapiEncode('javascript',rc.parentid)#');						
						</cfif>
						// run on page load
						setTimeout(function(){
							showSelectedExp();
						}, 300);
						// run on change of any schedule element
						$('##expireschedule-selector *').on('change',function(){
							showSelectedExp();
						})
					});				
				</script>
		  		
			</cfif>
			<!--- /end expiration --->

			<!--- mobile nav --->
		  	<cfif listFindNoCase('Page,Folder,Calendar,Gallery,File,Link',rc.type)>	
			  	<!--- deprecating --->
			  	<cfif rc.contentBean.getMobileExclude() eq 0
			  	or rc.contentBean.getIsNew()>
			  		<input type="hidden" name="mobileExclude" value="0">
			  	<cfelse>	
					<div class="mura-control-group">
						<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mobileexclude')#</label>
						<div class="radio-group">
							<label class="radio"><input type="radio" name="mobileExclude" value="0" checked<!---<cfif rc.contentBean.getMobileExclude() eq 0> selected</cfif>--->>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mobileexclude.always')#</label>
							<label class="radio"><input type="radio" name="mobileExclude" value="2"<cfif rc.contentBean.getMobileExclude() eq 2> checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mobileexclude.mobile')#</label>
							<label class="radio"><input type="radio" name="mobileExclude" value="1"<cfif rc.contentBean.getMobileExclude() eq 1> checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mobileexclude.standard')#</label>
						</div>
					</div>
				</cfif>	
			</cfif> <!--- /end mobile nav --->

			<div class="mura-control-group extendedattributes-group" id="extendedattributes-container-publishing">
				<div class="bigui" id="bigui__publishing" data-label="Manage Extended Attributes">
					<div class="bigui__title">Manage Extended Attributes</div>
					<div class="bigui__controls">
						<span id="extendset-container-tabextendedattributestop"></span>
						<span id="extendset-container-publishing" class="extendset-container extendedattributes-body" data-controlparent="extendedattributes-container-publishing"></span>
						<span id="extendset-container-tabextendedattributesbottom"></span>
					</div>
				</div>
				<!--- /.bigui --->
			</div>


		   <span id="extendset-container-tabpublishingbottom" class="extendset-container"></span>
				
		</div>
	</div>
</div> 

</cfoutput>