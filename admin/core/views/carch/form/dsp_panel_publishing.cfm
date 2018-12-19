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
			<a class="collapse" role="button" data-toggle="collapse" data-parent="##content-panels" href="##panel-publishing" aria-expanded="false" aria-controls="panel-publishing">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.publishing")#</a>
		</h4>
	</div>
		<div id="panel-publishing" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-publishing" aria-expanded="false" style="height: 0px;">
			<div class="mura-panel-body">

			<span id="extendset-container-tabpublishingtop" class="extendset-container"></span>


		  	<cfif listFindNoCase('Page,Folder,Calendar,Gallery,File,Link',rc.type)>

					<div class="mura-control-group">
			      <label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.credits')#</label>
			      <input type="text" id="credits" name="credits" value="#esapiEncode('html_attr',rc.contentBean.getCredits())#"  maxlength="255">
			    </div>

				<cfif rc.moduleid eq '00000000000000000000000000000000000' and not len(tabAssignments) or listFindNocase(tabAssignments,'SEO')>
					<div class="mura-control-group">
						<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.description')#</label>
						<textarea name="metadesc" id="metadesc">#esapiEncode('html',rc.contentBean.getMETADesc())#</textarea>
					</div>

				<cfif application.configBean.getValue(property='keepMetaKeywords',defaultValue=false)>
					<div class="mura-control-group">
						<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.keywords')#</label>
						<textarea name="metakeywords" rows="3" id="metakeywords">#esapiEncode('html',rc.contentBean.getMetaKeywords())#</textarea>
					</div>
				<cfelse>
					<div class="mura-control-group">
						<label>Canonical URL</label>
						<input type="text" id="canonicalURL" name="canonicalURL" value="#esapiEncode('html_attr',rc.contentBean.getCanonicalURL())#"  maxlength="255">
		  		</div>
				</cfif>

		  	</cfif>

				<cfif application.settingsManager.getSite(rc.siteid).getextranet()>
					<div class="mura-control-group">
				      	<label for="Restricted" class="checkbox"><input name="restricted" id="Restricted" type="checkbox" value="1"  onclick="javascript: this.checked?toggleDisplay2('rg',true):toggleDisplay2('rg',false);" <cfif rc.contentBean.getrestricted() eq 1>checked </cfif> class="checkbox">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictaccess')#
						</label>
					</div>
			      	<div class="mura-control=group" id="rg"<cfif rc.contentBean.getrestricted() NEQ 1> style="display:none;"</cfif>>
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
					</div> <!--- /end mura-control-group --->
			    </cfif>

				 <div class="mura-control-group">
			      	<label for="isNav" class="checkbox">
			      		<input name="isnav" id="isNav" type="CHECKBOX" value="1" <cfif rc.contentBean.getisnav() eq 1 or rc.contentBean.getisNew() eq 1>checked</cfif> class="checkbox">
						    	<span data-toggle="popover" title="" data-placement="right"
							    	data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.includeSiteNav"))#"
							    	data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.isnav"))#"
							    	>
							      #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.isnav')#
					    		 <i class="mi-question-circle"></i>
			      	</label>
				</div> <!--- /end mura-control-group --->

				<div class="mura-control-group">
					<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mobileexclude')#</label>
					<div class="radio-group">
						<label class="radio"><input type="radio" name="mobileExclude" value="0" checked<!---<cfif rc.contentBean.getMobileExclude() eq 0> selected</cfif>--->>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mobileexclude.always')#</label>
						<label class="radio"><input type="radio" name="mobileExclude" value="2"<cfif rc.contentBean.getMobileExclude() eq 2> checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mobileexclude.mobile')#</label>
						<label class="radio"><input type="radio" name="mobileExclude" value="1"<cfif rc.contentBean.getMobileExclude() eq 1> checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mobileexclude.standard')#</label>
					</div>
				</div>

				<div class="mura-control-group">
			     	<label for="Target" class="checkbox">
			     	<input  name="target" id="Target" type="CHECKBOX" value="_blank" <cfif rc.contentBean.gettarget() eq "_blank">checked</cfif> class="checkbox" >
				    		<span data-toggle="popover" title="" data-placement="right"
					    		data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.openNewWindow"))#"
					    		data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.newWindow"))#"
					    		>
					     		#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.newwindow')#
					     		 <i class="mi-question-circle"></i>
			     	</label>
				</div> <!--- /end mura-control-group --->

				<div class="mura-control-group">
						 <label for="searchExclude" class="checkbox"><input name="searchExclude" id="searchExclude" type="CHECKBOX" value="1" <cfif rc.contentBean.getSearchExclude() eq "">checked <cfelseif rc.contentBean.getSearchExclude() eq 1>checked</cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.searchexclude')#</label>
				</div> <!--- /end mura-control-group --->

				<div class="mura-control-group">
				    <label>
				    	<span data-toggle="popover" title="" data-placement="right"
					    	data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.contentReleaseDate"))#"
					    	data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.releasedate"))#"
					    	>
			      		#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.releasedate')#
				      	 <i class="mi-question-circle"></i>
			      	</label>
			      	<cf_datetimeselector name="releaseDate" datetime="#rc.contentBean.getReleaseDate()#">
				</div> <!--- /end mura-control-group --->
			</cfif>

			<cfif ((rc.parentid neq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all') or (rc.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() eq 'none')) and rc.contentid neq '00000000000000000000000000000000001'>

				<!--- display yes/no/schedule --->
				<cfif rc.parentBean.getType() neq 'Calendar'>
					<cfinclude template="dsp_displaycontent.cfm">
				</cfif>
				<cfif application.settingsManager.getSite(rc.siteid).getlocking() neq 'all'>
					<div class="mura-control-group">
	      		<label>
		  			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentparent')#:
      			</label>
      			<div class="mura-control justify">
		  				<cfif arrayLen(rc.crumbData) gt 1>
		  					<div id="newparent-label">
			      			"<span><cfif rc.contentBean.getIsNew()>#rc.crumbData[1].menutitle#<cfelse>#rc.crumbData[2].menutitle#</cfif></span>"
			  				</div>
		  				</cfif>

							<!--- 'big ui' flyout panel --->
							<div class="bigui" id="bigui__selectparent" data-label="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectnewparent'))#">
								<div class="bigui__title">#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectnewparent'))#</div>
								<div class="bigui__controls">
									<!--- new parent UI gets loaded here --->
							    <span id="mover2" style="display:none"><input type="hidden" name="parentid" value="#esapiEncode('html_attr',rc.parentid)#"></span>
								</div>
							</div> <!--- /.bigui --->
				    
							<script>
								jQuery(document).ready(function(){
										siteManager.loadSiteParents(
											'#esapiEncode('javascript',rc.siteid)#'
											,'#esapiEncode('javascript',rc.contentid)#'
											,'#esapiEncode('javascript',rc.parentid)#'
											,''
											,1
										);

										// populate current parent text when changed
										jQuery(document).on('click', '##mover2 input[name="parentid"]',function(){
											var newparent = jQuery(this).parents('tr').find('ul.navZoom li:last-child').text().trim();
											jQuery('##newparent-label > span').html(newparent);
										})
										jQuery(document).on('click', '##mover2 td.var-width',function(){
											var parentradio = jQuery(this).parents('tr').find('td.actions input[name="parentid"]');
											jQuery(parentradio).trigger('click');
										})
								});
							</script>

						</div>
					</div> <!--- /end mura-control-group --->

				<cfelse>
				 	<input type="hidden" name="parentid" value="#esapiEncode('html_attr',rc.parentid)#">
				</cfif>
			<cfelse>
				<cfif rc.type neq 'Component' and rc.type neq 'Form'>
					<input type="hidden" name="display" value="#rc.contentBean.getdisplay()#">
						<cfif rc.contentid eq '00000000000000000000000000000000001' or (rc.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() eq 'top') or application.settingsManager.getSite(rc.siteid).getlocking() eq 'all'>
							<input type="hidden" name="parentid" value="#esapiEncode('html_attr',rc.parentid)#">
						</cfif>
					<input type="hidden" name="displayStart" value="">
					<input type="hidden" name="displayStop" value="">
				<cfelse>
					<input type="hidden" name="display" value="1">
					<input type="hidden" name="parentid" value="#esapiEncode('html_attr',rc.parentid)#">
				</cfif>

			</cfif>

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
				</div>
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

				<!--- todo: resource bundle key for 'Expires' --->
				<script type="text/javascript">
					function showSelectedFeat(){
						var featStr = '';
						var startDate = $('##mura-datepicker-featureStart').val();
						var stopDate = $('##mura-datepicker-featureStop').val();
						console.log(startDate);
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

						console.log(featStr);

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

			</cfif>

			<div class="mura-control-group">
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

			<div class="mura-control-group">
				<label>
					#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.addnotes')#
				</label>
				<textarea name="notes" rows="8" id="abstract">#esapiEncode('html',rc.contentBean.getNotes())#</textarea>
			</div> <!--- /end mura-control-group --->

		   <span id="extendset-container-publishing" class="extendset-container"></span>

		   <span id="extendset-container-tabpublishingbottom" class="extendset-container"></span>
				
		</div>
	</div>
</div> 

</cfoutput>