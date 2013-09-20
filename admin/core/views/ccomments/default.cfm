<cfsilent>
<!---
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

	Linking Mura CMS statically or dynamically with other modules constitutes 
	the preparation of a derivative work based on Mura CMS. Thus, the terms 
	and conditions of the GNU General Public License version 2 ("GPL") cover 
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant 
	you permission to combine Mura CMS with programs or libraries that are 
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS 
	grant you permission to combine Mura CMS with independent software modules 
	(plugins, themes and bundles), and to distribute these plugins, themes and 
	bundles without Mura CMS under the license of your choice, provided that 
	you follow these specific guidelines: 

	Your custom code 

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

		/admin/
		/tasks/
		/config/
		/requirements/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that 
	meets the above guidelines as a combined work under the terms of GPL for 
	Mura CMS, provided that you include the source code of that other code when 
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not 
	obligated to grant this special exception for your modified version; it is 
	your choice whether to do so, or to make such modified version available 
	under the GNU General Public License version 2 without this exception.  You 
	may, if you choose, apply this exception to your own modified versions of 
	Mura CMS.
--->
<!---

	TODO:	
			*) maybe display comments grouped by content title and nested by replies
			*) flag comment as SPAM
				- allow for blacklisting/blocking IP

--->
</cfsilent>
<cfoutput>
<div id="commentsManagerWrapper">
	<h1>#rc.$.rbKey('comments.commentsmanager')#</h1>

	<!--- MESSAGING --->
	<cfif StructKeyExists(rc, 'processed') and IsBoolean(rc.processed)>
		<cfset local.class = rc.processed ? 'success' : 'error'>
		<div id="feedback" class="alert alert-#local.class#">
			<button type="button" class="close" data-dismiss="alert">&times;</button>
			<cfif rc.processed>
				#rc.$.rbKey('comments.message.confirmation')#
			<cfelse>
				#rc.$.rbKey('comments.message.error')#
			</cfif>
		</div>
	</cfif>

	<!--- TAB NAV --->
	<div class="row-fluid">
		<div class="span12">
			<ul class="nav nav-tabs">
				<li<cfif !rc.isapproved> class="active"</cfif>><a href="#buildURL(action='cComments.default', querystring='siteid=#urlEncodedFormat(session.siteID)#&isapproved=0')#"><i class="icon-bell-alt"></i> #rc.$.rbKey('comments.pending')#</a></li>
				<li<cfif rc.isapproved> class="active"</cfif>><a href="#buildURL(action='cComments.default', querystring='siteid=#urlEncodedFormat(session.siteID)#&isapproved=1')#"><i class="icon-check"></i> #rc.$.rbKey('comments.approved')#</a></li>
			</ul>
		</div>
	</div>

	<!--- BODY --->
	<cfif rc.itComments.hasNext()>

		<!--- FORM --->
		<form name="frmUpdate" id="frmUpdate" method="post" action="#buildURL(action='cComments.bulkedit', querystring='isapproved=#rc.isapproved#&pageno=#rc.pageno#&sortby=#rc.sortby#&sortdirection=#rc.sortdirection#')#">
			<input type="hidden" name="bulkedit" id="bulkedit" value="" />
			<table class="mura-table-grid">
				<thead>
					<tr>
						<th>
							<a id="checkall" href="##" title="#rc.$.rbKey('comments.selectall')#"><i class="icon-check"></i></a>
						</th>
						<th>
							<a href="#buildURL(action='#rc.muraAction#', querystring='sortby=entered&sortdirection=#rc.sortdirlink#&isapproved=#rc.isapproved#&nextn=#Val(rc.nextn)#')#" title="#rc.$.rbKey('comments.sortbydatetime')#">Date / Time</a>
						</th>
						<th class="var-width">
							<a href="#buildURL(action='#rc.muraAction#', querystring='sortby=name&sortdirection=#rc.sortdirlink#&isapproved=#rc.isapproved#&nextn=#Val(rc.nextn)#')#" title="#rc.$.rbKey('comments.sortbyname')#">User</a>
						</th>
						<th>&nbsp;</th>
					</tr>
				</thead>

				<tbody>
					<!--- RECORDS --->
					<cfloop condition="rc.itComments.hasNext()">

						<cfsilent>
							<cfscript>
								local.item = rc.itComments.next();
								local.content = rc.$.getBean('content').loadBy(contentID=local.item.getContentID(),siteID=local.item.getSiteID());
							</cfscript>
						</cfsilent>

<!--- MODAL WINDOW --->
<div id="comment-#local.item.getCommentID()#" class="modal hide fade">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true" title="Close Comments"><i class="icon-comments"></i></button>
		<p>
			<strong>#HTMLEditFormat(local.item.getName())#</strong> <em>#rc.$.rbKey('comments.commentedon')#:</em><br>
			<a href="#local.content.getURL(complete=1,queryString='##comment-#local.item.getCommentID()#')#" target="_blank"><i class="icon-external-link"></i> #HTMLEditFormat(local.content.getMenuTitle())#</a>
		</p>
	</div>
	<div class="modal-body">
		#application.contentRenderer.setParagraphs(HTMLEditFormat(local.item.getComments()))#
	</div>
	<div class="modal-footer">
		<div class="pull-left">
			<i class="icon-calendar"></i>&nbsp;&nbsp;#DateFormat(local.item.getEntered(), 'yyyy.mm.dd')#&nbsp;&nbsp;&nbsp;&nbsp;<i class="icon-time"></i> #TimeFormat(local.item.getEntered(), 'hh:mm:ss tt')#
		</div>
		<div class="pull-right">
			<a href="##" class="btn" data-dismiss="modal"><i class="icon-undo"></i> #rc.$.rbKey('comments.cancel')#</a>
			<cfif rc.isapproved>
				<a href="#buildURL(action='cComments.disapprove', querystring='commentid=#local.item.getCommentID()#&isapproved=#rc.isapproved#&nextn=#rc.nextn#')#" class="btn btn-warning" onclick="return confirm('Disapprove Comment?',this.href);"><i class="icon-ban-circle"></i> #rc.$.rbKey('comments.disapprove')#</a>
			<cfelse>
				<a href="#buildURL(action='cComments.approve', querystring='commentid=#local.item.getCommentID()#&isapproved=#rc.isapproved#&nextn=#rc.nextn#')#" class="btn btn-success" onclick="return confirm('Approve Comment?',this.href);"><i class="icon-ok"></i> #rc.$.rbKey('comments.approve')#</a>
			</cfif>
			<a href="#buildURL(action='cComments.delete', querystring='commentid=#local.item.getCommentID()#&isapproved=#rc.isapproved#&nextn=#rc.nextn#')#" class="btn btn-danger" onclick="return confirm('Delete Comment?',this.href);"><i class="icon-trash"></i> #rc.$.rbKey('comments.delete')#</a>
		</div>
	</div>
</div>
<!--- /@END MODAL --->

						<tr>
							<!--- BULK ACTION CHECKBOX --->
							<td>
								<input type="checkbox" name="ckUpdate" class="checkall" value="#local.item.getCommentID()#" />
							</td>

							<!--- DATE / TIME --->
							<td>
								<a href="##comment-#local.item.getCommentID()#" data-toggle="modal" title="Commented on: #HTMLEditFormat(local.content.getMenuTitle())#">
									#DateFormat(local.item.getEntered(), 'yyyy.mm.dd')# /
									#TimeFormat(local.item.getEntered(), 'hh:mm:ss tt')#
								</a>
							</td>

							<!--- USER --->
							<td class="var-width">
								<a href="##comment-#local.item.getCommentID()#" data-toggle="modal">
									#HTMLEditFormat(local.item.getName())#
								</a>
							</td>

							<!--- ACTIONS --->
							<td class="actions">
								<cfif IsValid('url', local.item.getURL())>
										<a href="#HTMLEditFormat(local.item.getURL())#" title="#HTMLEditFormat(local.item.getURL())#" target="_blank"><i class="icon-link"></i></a> 
									</cfif>
									<a href="mailto:#HTMLEditFormat(local.item.getEmail())#" title="#HTMLEditFormat(local.item.getEmail())#"><i class="icon-envelope"></i></a>
									<a href="##comment-#local.item.getCommentID()#" data-toggle="modal" title="Comments"><i class="icon-comments"></i></a>
								
								<cfif rc.isapproved>
									<a href="#buildURL(action='cComments.disapprove', querystring='commentid=#local.item.getCommentID()#&isapproved=#rc.isapproved#&nextn=#rc.nextn#')#" title="Disapprove" onclick="return confirmDialog('Disapprove Comment?',this.href);"><i class="icon-ban-circle" title="Disapprove"></i></a>
								<cfelse>
									<a href="#buildURL(action='cComments.approve', querystring='commentid=#local.item.getCommentID()#&isapproved=#rc.isapproved#&nextn=#rc.nextn#')#" title="Approve" onclick="return confirmDialog('Approve Comment?',this.href);"><i class="icon-ok" title="Approve"></i></a>
								</cfif>

								<a href="#buildURL(action='cComments.delete', querystring='commentid=#local.item.getCommentID()#&isapproved=#rc.isapproved#&nextn=#rc.nextn#')#" title="Delete" onclick="return confirmDialog('Delete Comment?',this.href);"><i class="icon-trash" title="Delete"></i></a>
							</td>
						</tr>
					</cfloop>
					<!--- /@END RECORDS --->
				</tbody>
			</table>
		</form>
		
		<div class="row-fluid">

			<!--- BULK EDIT BUTTONS --->
			<div class="span9">
				<div class="commentform-actions">
					<cfif rc.isapproved>
						<button type="button" class="btn" id="btnDisapproveComments">
							<i class="icon-ban-circle"></i> 
							#rc.$.rbKey('comments.disapproveselectedcomments')#
						</button>
					<cfelse>
						<button type="button" class="btn" id="btnApproveComments">
							<i class="icon-ok"></i> 
							#rc.$.rbKey('comments.approveselectedcomments')#
						</button>
					</cfif>
					<button type="button" class="btn" id="btnDeleteComments">
						<i class="icon-trash"></i> 
						#rc.$.rbKey('comments.deleteselectedcomments')#
					</button>
				</div>
			</div>

			<!--- RECORDS PER PAGE --->
			<cfif rc.itComments.pageCount() gt 1>
				<div class="span3">
					<div class="btn-group pull-right">
						<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
							Comments Per Page
							<span class="caret"></span>
						</a>
						<ul class="dropdown-menu">
							<li><a href="#buildURL(action='cComments.default', querystring='nextn=10&isapproved=#rc.isapproved#')#">10</a></li>
							<li><a href="#buildURL(action='cComments.default', querystring='nextn=25&isapproved=#rc.isapproved#')#">25</a></li>
							<li><a href="#buildURL(action='cComments.default', querystring='nextn=50&isapproved=#rc.isapproved#')#">50</a></li>
							<li><a href="#buildURL(action='cComments.default', querystring='nextn=100&isapproved=#rc.isapproved#')#">100</a></li>
							<li><a href="#buildURL(action='cComments.default', querystring='nextn=250&isapproved=#rc.isapproved#')#">250</a></li>
							<li><a href="#buildURL(action='cComments.default', querystring='nextn=500&isapproved=#rc.isapproved#')#">500</a></li>
							<li><a href="#buildURL(action='cComments.default', querystring='nextn=1000&isapproved=#rc.isapproved#')#">1000</a></li>
							<li><a href="#buildURL(action='cComments.default', querystring='nextn=100000&isapproved=#rc.isapproved#')#">#rc.$.rbKey('comments.all')#</a></li>
						</ul>
					</div>
				</div>
			</cfif>
			<!--- /@END RECORDS PER PAGE --->

		</div><!--- /.row-fluid --->

		<!--- PAGINATION --->
		<cfif rc.itComments.pageCount() gt 1>
			<div id="paginationWrapper" class="row-fluid">
				<div class="span12">
					<div class="pagination paginationWrapper">
						<ul>
							<!--- PREVIOUS --->
							<cfscript>
								if ( rc.pageno eq 1 ) {
									local.prevClass = 'disabled';
									local.prevURL = '##';
								} else {
									local.prevClass = '';
									local.prevURL = buildURL(action='cComments.default', queryString='pageno=#rc.pageno-1#&nextn=#rc.nextn#&isapproved=#rc.isapproved#&sortby=#rc.sortby#&sortdirection=#rc.sortdirection#');
								}
							</cfscript>
							<li class="#local.prevClass#">
								<a href="#local.prevURL#">&laquo;</a>
							</li>
							<!--- LINKS --->
							<cfloop from="#rc.startPage#" to="#rc.endPage#" index="p">
								<li<cfif rc.pageno eq p> class="disabled"</cfif>>
									<a href="#buildURL(action='cComments.default', queryString='pageno=#p#&nextn=#rc.nextn#&isapproved=#rc.isapproved#&sortby=#rc.sortby#&sortdirection=#rc.sortdirection#')#"<cfif val(rc.pageno) eq p> class="active"</cfif>>
										#p#
									</a>
								</li>
							</cfloop>
							<!--- NEXT --->
							<cfscript>
								if ( rc.pageno == rc.totalPages ) {
									rc.nextClass = 'disabled';
									rc.nextURL = '##';
								} else {
									rc.nextClass = '';
									rc.nextURL = buildURL(action='cComments.default', queryString='pageno=#rc.pageno+1#&nextn=#rc.nextn#&isapproved=#rc.isapproved#&sortby=#rc.sortby#&sortdirection=#rc.sortdirection#');
								}
							</cfscript>
							<li class="#rc.nextClass#">
								<a href="#rc.nextURL#">&raquo;</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</cfif>

		<!--- SCRIPTS --->
		<script type="text/javascript">
			jQuery(function ($) {
				// CHECKBOXES
				$('##checkall').click(function (e) {
					e.preventDefault();
					var checkBoxes = $(':checkbox.checkall');
					checkBoxes.prop('checked', !checkBoxes.prop('checked'));
				});

				// APPROVE
				$('##btnApproveComments').click(function() {
					confirmDialog(
						'#rc.$.rbKey("comments.message.confirm.approve")#'
						,function(){
							actionModal(
								function(){
									$('.commentform-actions').hide();
									$('##bulkedit').val('approve');
									$('##actionIndicator').show();
									$('##frmUpdate').submit();
								}
							);
						}
					)
				});

				// DISAPPROVE
				$('##btnDisapproveComments').click(function() {
					confirmDialog(
						'#rc.$.rbKey("comments.message.confirm.disapprove")#'
						,function(){
							actionModal(
								function(){
									$('.commentform-actions').hide();
									$('##bulkedit').val('disapprove');
									$('##actionIndicator').show();
									$('##frmUpdate').submit();
								}
							);
						}
					)
				});

				// DELETE
				$('##btnDeleteComments').click(function() {
					confirmDialog(
						'#rc.$.rbKey("comments.message.confirm.delete")#'
						,function(){
							actionModal(
								function(){
									$('.commentform-actions').hide();
									$('##bulkedit').val('delete');
									$('##actionIndicator').show();
									$('##frmUpdate').submit();
								}
							);
						}
					)
				});
			});
		</script>

	<cfelse>

		<div class="row-fluid">
			<div class="span12">
				<div class="alert alert-info">
					<cfif rc.isapproved>
						<p>#rc.$.rbKey('comments.message.nocommentsapproved')#</p>
					<cfelse>
						<p>#rc.$.rbKey('comments.message.nocommentspending')#</p>
					</cfif>
				</div>
			</div>
		</div>

	</cfif>

	<script type="text/javascript">
		jQuery(function ($) {
			$('##feedback').delay(4000).fadeOut(1500); // MESSAGING : auto-hide after 4 secs.
		});
	</script>
</div>
</cfoutput>