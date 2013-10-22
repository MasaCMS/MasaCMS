<cfset $.event('format', 'ajax')>

<style>
	td.actions a:hover {
		text-decoration: none;
	}
</style>
<cfset request.layout=false>
<cfoutput>
	<div class="control-group">
		<label class="control-label">Search for Comments</label>
		<div class="form-inline">
			<div class="input-append">
				<input type="text" name="keywords" value="#$.event('keywords')#" id="rcSearch" placeholder="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.searchforcontent')#"/>
				<button type="submit" name="btnSearch" id="btnSearch" class="btn"><i class="icon-search"></i></button>
			</div>
			<a class="btn" href="##" id="aAdvancedSearch" data-toggle="button">Advanced Search</a>
		</div>	
	</div>
	
	<div id="advancedSearch" style="display:none;">
		<div class="control-group">
			<div class="span4">
				<label class="control-label">Comment Status</label>
				<div class="controls">
					<select name="commentStatus" id="commentStatusSelector">
						<option value="">All</option>
						<cfloop list="Pending,Approved,Spam,Deleted" index="i">
							<option value="#i#"<cfif $.event('commentStatus') eq i> selected="selected"</cfif>>#i#</option>
						</cfloop>
					</select>
				</div>
			</div>
			<div class="span8">
				<label class="control-label">Comment Date Range</label>
				<div class="controls">
					<input type="text" name="startDate" id="startDate" class="datepicker span3 mura-custom-datepicker" placeholder="Start Date" value="#$.event('startDate')#" /> &ndash; <input type="text" name="endDate" id="endDate" class="datepicker span3 mura-custom-datepicker" placeholder="End Date" value="#$.event('endDate')#" />
				</div>
			</div>
			<!--- <div class="span4">
				<label class="control-label">ContentID</label>
		
				<div class="controls">
					<input type="text" name="contentID" id="inputcontentID" value="#$.event('contentID')#"/>
				</div>
			</div> --->
		</div>
		<!--- <div class="control-group">
			<div class="controls">
				<label class="control-label">Available Categories</label>
		
				<div id="mura-list-tree" class="controls">
					#$.getBean('contentCommentManager').dspCategoriesNestSelect($.event("siteID"), "", $.event('searchCategoryID'), 0, 0, "searchCategoryID")#
				</div>
			</div>
		</div> --->
		<input type="hidden" id="sortBy" name="sortBy" value="#$.event('sortBy')#">
		<input type="hidden" id="sortDirection" name="sortDirection" value="#$.event('sortdirection')#">
		<input type="hidden" id="nextN" name="nextN" value="#rc.nextN#">
		<input type="hidden" id="pageNo" name="pageNo" value="#rc.pageNo#">
	</div>
</cfoutput>


<cfoutput>
	<div class="control-group">
		<!--- BODY --->
		<!--- <cfdump var="#rc.itComments.getQuery()#" abort="true"> --->
		<cfif rc.itComments.hasNext()>
			<!--- FORM --->
			<form name="frmUpdate" id="frmUpdate">
				<input type="hidden" name="bulkedit" id="bulkedit" value="" />
				<!--- BULK EDIT BUTTONS --->
				<div class="row-fluid">
					<div class="span9">
						<div class="commentform-actions">
							<div class="btn-group">
								<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
									Mark As
									<span class="caret"></span>
								</a>
								<ul class="dropdown-menu">
									<li><a href="##" class="bulkEdit" data-alertmessage="#rc.$.rbKey('comments.message.confirm.approve')#" data-action="approve"><i class="icon-ok"></i> Approved</a></li>
									<li><a href="##" class="bulkEdit" data-alertmessage="Are you sure you want to mark the selected comments as spam?" data-action="spam"><i class="icon-flag"></i> Spam</a></li>
									<li><a href="##" class="bulkEdit" data-alertmessage="#rc.$.rbKey('comments.message.confirm.disapprove')#" data-action="disapprove"><i class="icon-ban-circle"></i> Disapproved</a></li>
									<li><a href="##" class="bulkEdit" data-alertmessage="#rc.$.rbKey('comments.message.confirm.delete')#" data-action="delete"><i class="icon-remove-sign"></i> Deleted</a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
				
				<br />
				
				<table class="mura-table-grid">
					<thead>
						<tr>
							<th>
								<a id="checkall" href="##" title="#rc.$.rbKey('comments.selectall')#"><i class="icon-check"></i></a>
							</th>
							<th>
								<a class="sort" data-sortby="entered" data-sortdirection="#rc.sortdirlink#" data-nextn="#Val(rc.nextn)#" title="#rc.$.rbKey('comments.sortbydatetime')#" href="##">Date / Time</a>
							</th>
							<th>
								<a class="sort" data-sortby="name" data-sortdirection="#rc.sortdirlink#" data-nextn="#Val(rc.nextn)#" title="#rc.$.rbKey('comments.sortbyname')#" href="##">User</a>
							</th>
							<th class="var-width">Comment</th>
							<th>Status</th>
							<th>
								<a class="sort" data-sortby="flagCount" data-sortdirection="#rc.sortdirlink#" href="##">Flag Count</a>
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
									<!--- <cfif rc.isapproved>
										<a href="#buildURL(action='cComments.disapprove', querystring='commentid=#local.item.getCommentID()#&isapproved=#rc.isapproved#&nextn=#rc.nextn#')#" class="btn btn-warning" onclick="return confirm('Disapprove Comment?',this.href);"><i class="icon-ban-circle"></i> #rc.$.rbKey('comments.disapprove')#</a>
									<cfelse>
										<a href="#buildURL(action='cComments.approve', querystring='commentid=#local.item.getCommentID()#&isapproved=#rc.isapproved#&nextn=#rc.nextn#')#" class="btn btn-success" onclick="return confirm('Approve Comment?',this.href);"><i class="icon-ok"></i> #rc.$.rbKey('comments.approve')#</a>
									</cfif> --->
									<a href="#buildURL(action='cComments.delete', querystring='commentid=#local.item.getCommentID()#&nextn=#rc.nextn#')#" class="btn btn-danger" onclick="return confirm('Delete Comment?',this.href);"><i class="icon-trash"></i> #rc.$.rbKey('comments.delete')#</a>
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
								<td>
									<a href="##comment-#local.item.getCommentID()#" data-toggle="modal">
										#HTMLEditFormat(local.item.getName())#
									</a>
								</td>
								
								<!--- COMMENT --->
								
								<td class="var-width">
									<cfscript>
										theCount = 210;
										if ( Len(item.getComments()) > theCount ) {
											theComments = Left(Trim(item.getComments()), theCount);
											theComments = !ListFindNoCase('.,!,?', Right(theComments, 1)) ? theComments & ' ...' : theComments;
										} else {
											theComments = item.getComments();
										}
									</cfscript>
									<a href="##comment-#local.item.getCommentID()#" data-toggle="modal">#HTMLEditFormat(theComments)#</a>
								</td>

								<td>
									<cfif local.item.getIsDeleted()>
										<i class="icon-remove-sign icon-white">
									<cfelseif local.item.getIsSpam()>
										<i class="icon-flag"></i>
									<cfelseif local.item.getIsApproved()>
										<i class="icon-ok"></i>
									<cfelseif not local.item.getIsApproved()>
										<i class="icon-ban-circle"></i>
									</cfif>
								</td>

								<td>
									#HTMLEditFormat(local.item.getFlagCount())#
								</td>

								<!--- ACTIONS --->
								<td class="actions">
								<ul>
									<cfif IsValid('url', local.item.getURL())>
											<li><a href="#HTMLEditFormat(local.item.getURL())#" title="#HTMLEditFormat(local.item.getURL())#" target="_blank"><i class="icon-link"></i></a></li>
											<cfelse>
											<li class="disabled"><i class="icon-link"></i></li>
										</cfif>
										<li><a href="mailto:#HTMLEditFormat(local.item.getEmail())#" title="#HTMLEditFormat(local.item.getEmail())#"><i class="icon-envelope"></i></a></li>
										<li><a href="##comment-#local.item.getCommentID()#" data-toggle="modal" title="Comments"><i class="icon-comments"></i></a></li>
									
									<!--- <cfif rc.isapproved>
										<li><a href="#buildURL(action='cComments.disapprove', querystring='commentid=#local.item.getCommentID()#&isapproved=#rc.isapproved#&nextn=#rc.nextn#')#" title="Disapprove" onclick="return confirmDialog('Disapprove Comment?',this.href);"><i class="icon-ban-circle" title="Disapprove"></i></a></li>
									<cfelse>
										<li><a href="#buildURL(action='cComments.approve', querystring='commentid=#local.item.getCommentID()#&isapproved=#rc.isapproved#&nextn=#rc.nextn#')#" title="Approve" onclick="return confirmDialog('Approve Comment?',this.href);"><i class="icon-ok" title="Approve"></i></a></li>
									</cfif> --->

									<li><a href="#buildURL(action='cComments.delete', querystring='commentid=#local.item.getCommentID()#&nextn=#rc.nextn#')#" title="Delete" onclick="return confirmDialog('Delete Comment?',this.href);"><i class="icon-remove-sign" title="Delete"></i></a></li>
								</ul>
								</td>
							</tr>
						</cfloop>
						<!--- /@END RECORDS --->
					</tbody>
				</table>
			</form>

			<!--- RECORDS PER PAGE --->
			
			<div class="view-controls row-fluid">
				<div class="btn-group pull-left">
					<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
						Comments Per Page
						<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="##" class="nextN" data-nextn="10">10</a></li>
						<li><a href="##" class="nextN" data-nextn="25">25</a></li>
						<li><a href="##" class="nextN" data-nextn="50">50</a></li>
						<li><a href="##" class="nextN" data-nextn="100">100</a></li>
						<li><a href="##" class="nextN" data-nextn="250">250</a></li>
						<li><a href="##" class="nextN" data-nextn="500">500</a></li>
						<li><a href="##" class="nextN" data-nextn="100">1000</a></li>
						<li><a href="##" class="nextN" data-nextn="10000">#rc.$.rbKey('comments.all')#</a></li>
					</ul>
				</div>
				
				<!--- PAGINATION --->
				<cfif rc.itComments.pageCount() gt 1>
					<div class="pagination pull-right">
						<ul>
							<!--- PREVIOUS --->
							<cfscript>
								if ( rc.pageno eq 1 ) {
									local.prevClass = 'disabled';
									local.prevNo = '';
								} else {
									local.prevClass = 'pageNo';
									local.prevNo = rc.pageno - 1;
								}
							</cfscript>
							<li class="#local.prevClass#">
								<a hre="##" data-pageno="#local.prevNo#">&laquo;</a>
							</li>
							<!--- LINKS --->
							<cfloop from="#rc.startPage#" to="#rc.endPage#" index="p">
								<li<cfif rc.pageno eq p> class="disabled"</cfif>>
									<cfset lClass = "pageNo">
									<cfif val(rc.pageno) eq p>
										<cfset lClass = listAppend("lClass", "active", " ")>
									</cfif>
									<a href="##" data-pageno="#p#" class="#lClass#">
										#p#
									</a>
								</li>
							</cfloop>
							<!--- NEXT --->
							<cfscript>
								if ( rc.pageno == rc.totalPages ) {
									rc.nextClass = 'disabled';
									rc.prevNo = '';
								} else {
									rc.nextClass = 'pageNo';
									rc.prevNo = rc.pageno + 1;
								}
							</cfscript>
							<li class="#rc.nextClass#">
								<a href="##" data-pageno="#rc.prevNo#">&raquo;</a>
							</li>
						</ul>
					</div>
				</cfif>
			</div>
			<!--- /@END RECORDS PER PAGE --->		
		<cfelse>
			<div class="row-fluid">
				<div class="span12">
					<div class="alert alert-info">
						<p>No #$.event('commentStatus')# comments found.</p>
					</div>
				</div>
			</div>
		</cfif>
	</div>
	<script type="text/javascript">
		jQuery(function ($) {
			$('##feedback').delay(4000).fadeOut(1500); // MESSAGING : auto-hide after 4 secs.
		});
	</script>
</cfoutput>
