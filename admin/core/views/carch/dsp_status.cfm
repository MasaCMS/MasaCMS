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
<cfoutput>
<cfif $.siteConfig('hasLockableNodes')>
	<cfset nodeLockedByYou= stats.getLockType() eq 'node' and stats.getLockID() eq session.mura.userID>
	<cfset nodeLockedBySomeElse=len(stats.getLockID()) and stats.getLockType() eq 'node' and  stats.getLockID() neq session.mura.userID>

	<cfif nodeLockedByYou or nodeLockedBySomeElse>

		<cfif not nodeLockedBySomeElse>
			<p id="msg-node-locked" class="alert alert-error"<cfif not nodeLockedByYou> style="display:none;"</cfif>>
				<span>
#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.youvelockednode')# <a class="mura-node-unlock" href="##"<cfif not nodeLockedByYou> style="display:none;"</cfif>><i class="mi-unlock"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlocknode')#</a>
				</span>
			</p>
		<cfelse>
			<!--- Locked by someone else --->
			<cfset lockedBy=$.getBean("user").loadBy(stats.getLockID())>
			<p id="msg-node-locked-else" class="alert alert-error">
				<span>
					#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.nodeLockedby"),"#esapiEncode('html_attr',lockedBy.getFName())# #esapiEncode('html',lockedBy.getLName())#")#.<br>
				<a href="mailto:#esapiEncode('html',lockedBy.getEmail())#?subject=#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.nodeunlockrequest'))#"><i class="mi-envelope"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.requestnoderelease')#</a>
					<cfif $.currentUser().isSuperUser() or $.currentUser().isAdminUser()> &nbsp; &nbsp;<a class="mura-node-unlock" href="##"><i class="mi-unlock"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlocknode')#</a>
					</cfif>
				</span>
			</p>

		</cfif>
		<script>
			$(function(){
				jQuery(".mura-node-unlock").click(
					function(event){
						event.preventDefault();
						confirmDialog(
							"#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlocknodeconfirm'))#",
							function(){
								jQuery("##msg-node-locked").fadeOut();
								jQuery(".mura-node-unlock").hide();
								if(lockedbysomeonelse){
									jQuery("##msg-node-locked-else").fadeOut();
									lockedbysomeonelse=false;
									siteManager.doConditionalExit=true;
								}
								siteManager.hasNodeLock=false;
								$('.form-actions').fadeIn();
								<cfset csrf=rc.$.generateCSRFTokens(context=rc.contentBean.getContentID() & 'unlocknode')>
								jQuery.post("./",{
									muraAction:"carch.unlockNode",
									contentid:"#rc.contentBean.getContentID()#",
									siteid:"#rc.contentBean.getSiteID()#",
									csrf_token:'#csrf.token#',
									csrf_token_expires: '#csrf.expires#'
								})
							}
						);
					}
				);

				<cfif nodeLockedBySomeElse>
				$('.form-actions').hide();
				lockedbysomeonelse=true;
				siteManager.doConditionalExit=false;
				</cfif>
			});
			</script>
	</cfif>
</cfif>
<cfif isdefined('showApprovalStatus')>

<div style="display:none;" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"layout.status"))#" id="approvalModalContainer"></div>

<cfif showApprovalStatus and listFindNoCase('Pending,Rejected',rc.contentBean.getApprovalStatus())  >
	<div class="alert alert-error">
		<span>
		<cfif rc.contentBean.getApprovalStatus() eq 'Rejected'>
			#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.rejectedmessage")#:
		<cfelseif rc.contentBean.getApprovalStatus() eq 'Cancelled'>
			#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.canceledmessage")#:
		<cfelse>
			#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.pendingmessage")#:
		</cfif>
		<strong><a href="##" onclick="return viewStatusInfo('#esapiEncode('javascript',rc.contentBean.getContentHistID())#','#esapiEncode('javascript',rc.contentBean.getSiteID())#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.viewdetails")#</a></strong>
		</span>
	</div>
</cfif>

<cfif rc.parentBean.getType() eq 'Calendar'>
	<cfset conflicts=rc.contentBean.getDisplayConflicts()>

	<cfif rc.contentBean.getDisplay() eq 2>
		<div class="alert alert-info" >
			<span>
				<strong>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.display')#:</strong> #rc.contentBean.getDisplayIntervalDesc(showTitle=false)#
			</span>
		</div>
	</cfif>

	<cfif conflicts.hasNext()>
		<cfset calendar=rc.contentBean.getParent()>
		<div class="alert alert-error">
			<span>
			<h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.displayinterval.schedulingconflicts")#:</h3>
				<cfloop condition="conflicts.hasNext()">
					<cfset conflict=conflicts.next()>
					<p><strong><a href="#conflict.getEditURL()#">#esapiEncode('html',conflict.getTitle())#:</strong></a>
						<cfset conflictDetails=conflict.getConfictDetailIterator()>
						<cfloop condition="conflictDetails.hasNext()">
							<cfset conflictdetail=conflictDetails.next()>
							<a href="#rc.$.createHREF(filename='#calendar.getFilename()#/_/date/#year(conflictdetail.getDisplayStart())#/#month(conflictdetail.getDisplayStart())#/#day(conflictdetail.getDisplayStart())#',complete=true)#" <cfif rc.compactdisplay eq 'true'>target="_top"<cfelse>target="_blank"</cfif>>#LSDateFormat(conflictdetail.getDisplayStart(),session.dateKeyFormat)#</a>
							<cfif conflictDetails.hasNext()>, </cfif>
						</cfloop>
					</p>
				</cfloop>
			</span>
		</div>
	</cfif>
</cfif>
<script>
function viewStatusInfo(contenthistid,siteid){

	var url = 'index.cfm';
	var pars = 'muraAction=cArch.statusmodal&compactDisplay=true&siteid=' + siteid  + '&contenthistid=' + contenthistid +'&cacheid=' + Math.random();
	var d = jQuery('##approvalModalContainer');
	d.html('<div class="load-inline"></div>');
	//$('##approvalModalContainer .load-inline').spin(spinnerArgs2);
	$.get(url + "?" + pars,
		function(data) {
			if(data.indexOf('mura-primary-login-token') != -1) {
				location.href = './';
			}
			$('##approvalModalContainer .load-inline').spin(false);
			jQuery('##approvalModalContainer').html(data);
			stripe('stripe');
		});

		$("##approvalModalContainer").dialog({
			resizable: false,
			modal: true,
			width: 600,
			position: { my: "center", at: "top+180", of: window, collision: "fit" }
		});


	return false;
}

function applyApprovalAction(requestid,action,comment,siteid){

	if(action == 'Reject' && comment == ''){
		alertDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"approvalchains.rejectioncommentrequired"))#');
	} else {
		$('##mura-approval-apply').attr('disabled','disabled').css('opacity', '.30');

		<cfset csrf=rc.$.generateCSRFTokens(context='approvalaction')>
		var pars={
					muraAction:'carch.approvalaction',
					siteid: siteid,
					requestid: requestid,
					comment: comment,
					action:action,
					csrf_token:'#csrf.token#',
					csrf_token_expires: '#csrf.expires#'
				};

		actionModal(
			function(){
				$.post('index.cfm',
					pars,
					function(data) {
						if(typeof(data) == 'string'){
							$('html').html(data);
						} else {
							var href = window.location.href.replace('#rc.contentBean.getContentHistID()#',data.contenthistid);
							//alert(href)
							window.location = href;
						}
					}
				).fail(function(data){
					$('html').html(data);
				});
			}
		);
	}
}
</script>
</cfif>
</cfoutput>
