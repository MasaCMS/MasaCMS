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
<cfset tabList=listAppend(tabList,"tabSchedule")>
<cfoutput>
<div class="mura-panel panel">
	<div class="mura-panel-heading" role="tab" id="heading-schedule">
		<h4 class="mura-panel-title">
			<!--- todo: rb key for scheduling --->
			<a class="collapse" role="button" data-toggle="collapse" data-parent="##content-panels" href="##panel-schedule" aria-expanded="true" aria-controls="panel-schedule">Scheduling<!--- #application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.basic")# ---></a>
		</h4>
	</div>
	<div id="panel-schedule" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-schedule" aria-expanded="false" style="height: 0px;">
		<div class="mura-panel-body">
			
			<span id="extendset-container-tabscheduletop" class="extendset-container"></span>

			<!--- display yes/no/schedule --->
			<cfif ((rc.parentid neq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all') or (rc.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() eq 'none')) and rc.contentid neq '00000000000000000000000000000000001'>

				<cfif rc.parentBean.getType() neq 'Calendar'>
					<cfinclude template="dsp_displaycontent.cfm">
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
				</cfif>

			</cfif>
			<!--- /end display yes/no/schedule --->

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
			      <cf_datetimeselector name="releaseDate" datetime="#rc.contentBean.getReleaseDate()#">
				</div> <!--- /end mura-control-group --->
			</cfif>	<!--- /end release date --->

			<span id="extendset-container-schedule" class="extendset-container"></span>

			<span id="extendset-container-tabschedulebottom" class="extendset-container"></span>

		</div>
	</div>
</div> 


</cfoutput>
