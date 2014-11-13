<cfset request.layout=false>
<style>
	td.actions a:hover {
		text-decoration: none;
	}
</style>
<cfoutput>
	<div class="control-group">
		<label class="control-label">Search for Comments</label>
		<div class="form-inline">
			<div class="input-append">
				<input type="text" name="keywords" value="#esapiEncode('html_attr',$.event('keywords'))#" id="rcSearch" placeholder="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.searchforcontent')#"/>
				<button type="submit" name="btnSearch" id="btnSearch" class="btn"><i class="icon-search"></i></button>
			</div>
		</div>	
	</div>
	
	<div id="advancedSearch">
		<div class="control-group">
			<div class="span4">
				<label class="control-label">Comment Status</label>
				<div class="controls">
					<select name="commentStatus" id="commentStatusSelector">
						<option value="">All</option>
						<cfloop list="Unapproved,Approved,Spam,Deleted" index="i">
							<option value="#i#"<cfif $.event('commentStatus') eq i> selected="selected"</cfif>>#i#</option>
						</cfloop>
					</select>
				</div>
			</div>
			<div class="span8 date-range-selector">
				<label class="control-label">Comment Date Range</label>
				<div class="controls">
					<div class="input-prepend"><span class="add-on"><i class="icon-calendar"></i></span><input type="text" name="startDate" id="startDate" class="datepicker span10 mura-custom-datepicker" placeholder="Start Date" value="#esapiEncode('html_attr',$.event('startDate'))#" /></div>&nbsp;&ndash;&nbsp;<div class="input-prepend"><span class="add-on"><i class="icon-calendar"></i></span><input type="text" name="endDate" id="endDate" class="datepicker span10 mura-custom-datepicker" placeholder="End Date" value="#esapiEncode('html_attr',$.event('endDate'))#" /></div>
				</div>
			</div>
			<!--- <div class="span4">
				<label class="control-label">ContentID</label>
		
				<div class="controls">
					<input type="text" name="contentID" id="inputcontentID" value="#$.event('contentID')#"/>
				</div>
			</div> --->
		</div>
		<div class="control-group">
			<div class="controls">
				<label class="control-label">Available Categories</label>
		
				<div id="mura-list-tree" class="controls">
					#$.getBean('contentCommentManager').dspCategoriesNestSelect($.event("siteID"), "", $.event('categoryID'), 0, 0, "categoryID")#
				</div>
			</div>
		</div>
		<input type="hidden" id="sortBy" name="sortBy" value="#esapiEncode('html_attr',$.event('sortBy'))#">
		<input type="hidden" id="sortDirection" name="sortDirection" value="#esapiEncode('html_attr',$.event('sortdirection'))#">
		<input type="hidden" id="nextN" name="nextN" value="#esapiEncode('html_attr',rc.nextN)#">
		<input type="hidden" id="pageNo" name="pageNo" value="#esapiEncode('html_attr',rc.pageNo)#">
	</div>
</cfoutput>


<cfoutput>
	<div class="control-group">
		<!--- BODY --->
		
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
									<li><a href="##" class="bulkEdit" data-alertmessage="#rbKey('comments.message.confirm.approve')#" data-action="approve"><i class="icon-ok"></i> Approved</a></li>
									<li><a href="##" class="bulkEdit" data-alertmessage="Are you sure you want to mark the selected comments as spam?" data-action="spam"><i class="icon-flag"></i> Spam</a></li>
									<li><a href="##" class="bulkEdit" data-alertmessage="#rbKey('comments.message.confirm.delete')#" data-action="delete"><i class="icon-trash"></i> Deleted</a></li>
								</ul>
							</div>
							<div class="btn-group">
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
									<li><a href="##" class="nextN" data-nextn="10000">#rbKey('comments.all')#</a></li>
								</ul>
							</div>
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
			<!--- /@END RECORDS PER PAGE --->
					</div>
				</div>
				<br />
				<table class="mura-table-grid">
					<thead>
						<tr>
							<th>
								<a id="checkall" href="##" title="#rbKey('comments.selectall')#"><i class="icon-check"></i></a>
							</th>
							<th>
								<a class="sort" data-sortby="entered" data-sortdirection="#rc.sortdirlink#" data-nextn="#Val(rc.nextn)#" title="#rbKey('comments.sortbydatetime')#" href="##">Date</a>
							</th>
							<th>
								<a class="sort" data-sortby="entered" data-sortdirection="#rc.sortdirlink#" data-nextn="#Val(rc.nextn)#" title="#rbKey('comments.sortbydatetime')#" href="##">Time</a>
							</th>
							<th>
								<a class="sort" data-sortby="name" data-sortdirection="#rc.sortdirlink#" data-nextn="#Val(rc.nextn)#" title="#rbKey('comments.sortbyname')#" href="##">User</a>
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
							<div id="comment-#local.item.getCommentID()#" data-contentid="#local.item.getContentID()#" data-commentid="#local.item.getCommentID()#" class="modal comment-modal hide fade">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true" title="Close Comments"><i class="icon-remove-sign"></i></button>
									
									<p>
										<!--- <strong>#esapiEncode('html',local.item.getName())#</strong> <em>#rbKey('comments.commentedon')#:</em><br /> --->
										<cfif local.content.getIsNew()>
											<h1><i class="icon-external-link"></i> Content Missing</h1>
										<cfelse>
											<h1><a href="#local.content.getURL(complete=1,queryString='##comment-#local.item.getCommentID()#')#" target="_blank"><i class="icon-external-link"></i> #esapiEncode('html',local.content.getMenuTitle())#</a></h1>
										</cfif>
										
									<!---
<br />
										<i class="icon-calendar"></i>&nbsp;&nbsp;#DateFormat(local.item.getEntered(), 'yyyy.mm.dd')#&nbsp;&nbsp;&nbsp;&nbsp;<i class="icon-time"></i> #TimeFormat(local.item.getEntered(), 'hh:mm:ss tt')#
--->
									</p>
								</div>
								<div class="modal-body">
									<!--- loadcommentspage.cfm --->
								</div>
								<div class="modal-footer">
									<div class="pull-right">
										<!--- <a href="##" class="btn  btn-primary" data-dismiss="modal"><i class="icon-undo"></i> #rbKey('comments.cancel')#</a> --->
										<cfif local.item.getIsDeleted()>
											<a href="##" class="singleEdit btn btn-primary" data-commentid="#local.item.getCommentID()#" data-action="undelete"><i class="icon-trash"></i> Undelete</a>
										<cfelse>
											<a href="##" class="singleEdit btn btn-primary" data-commentid="#local.item.getCommentID()#" data-action="delete"><i class="icon-trash"></i> #rbKey('comments.delete')#</a>
											<cfif local.item.getIsSpam()>
												<a href="##" class="singleEdit btn btn-primary" data-commentid="#local.item.getCommentID()#" data-action="unspam"><i class="icon-flag"></i> Unspam</a>
											<cfelse>
												<a href="##" class="singleEdit btn btn-primary" data-commentid="#local.item.getCommentID()#" data-action="spam"><i class="icon-flag"></i> Spam</a>
												<cfif local.item.getIsApproved()>
													<a href="##" class="singleEdit btn  btn-primary" data-commentid="#local.item.getCommentID()#" data-action="unapprove"><i class="icon-ban-circle"></i> #rbKey('comments.unapprove')#</a>
												<cfelse>
													<a href="##" class="singleEdit btn  btn-primary" data-commentid="#local.item.getCommentID()#" data-action="approve"><i class="icon-ok"></i> #rbKey('comments.approve')#</a>
												</cfif>
											</cfif>
										</cfif>
									</div>
								</div>
							</div>
							<!--- /@END MODAL --->

							<tr>
								<!--- BULK ACTION CHECKBOX --->
								<td>
									<input type="checkbox" name="ckUpdate" class="checkall" value="#local.item.getCommentID()#" />
								</td>

								<!--- DATE --->
								<td>
									<a href="##comment-#local.item.getCommentID()#" data-toggle="modal" title="Commented on: #esapiEncode('html',local.content.getMenuTitle())#">
										#DateFormat(local.item.getEntered(), 'yy/mm/dd')#
									</a>
								</td>
								
								<!--- TIME --->
								<td>
									<a href="##comment-#local.item.getCommentID()#" data-toggle="modal" title="Commented on: #esapiEncode('html',local.content.getMenuTitle())#">
										#TimeFormat(local.item.getEntered(), 'h:mm tt')#
									</a>
								</td>

								<!--- USER --->
								<td>
									<a href="##comment-#local.item.getCommentID()#" data-toggle="modal">
										#esapiEncode('html',local.item.getName())#
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
									<a href="##comment-#local.item.getCommentID()#" data-toggle="modal">#esapiEncode('html',theComments)#</a>
								</td>

								<td>
									<cfif local.item.getIsDeleted()>
										<i class="icon-trash"></i>
									<cfelseif local.item.getIsSpam()>
										<i class="icon-flag"></i>
									<cfelseif local.item.getIsApproved()>
										<i class="icon-ok"></i>
									<cfelseif not local.item.getIsApproved()>
										<i class="icon-ban-circle"></i>
									</cfif>
								</td>

								<td>
									#esapiEncode('html',local.item.getFlagCount())#
								</td>

								<!--- ACTIONS --->
								<td class="actions">
								<ul>
									<li><a href="##comment-#local.item.getCommentID()#" data-toggle="modal" title="Comments"><i class="icon-comments"></i></a></li>
									<cfif IsValid('url', local.item.getURL())>
										<li><a href="#esapiEncode('html_attr',local.item.getURL())#" title="#esapiEncode('html_attr',local.item.getURL())#" target="_blank"><i class="icon-link"></i></a></li>
									<cfelse>
										<li class="disabled"><i class="icon-link"></i></li>
									</cfif>
									<li><a href="mailto:#esapiEncode('html',local.item.getEmail())#" title="#esapiEncode('html_attr',local.item.getEmail())#"><i class="icon-envelope"></i></a></li>
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
				<div class="btn-group">
								<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
									Mark As
									<span class="caret"></span>
								</a>
								<ul class="dropdown-menu">
									<li><a href="##" class="bulkEdit" data-alertmessage="#rbKey('comments.message.confirm.approve')#" data-action="approve"><i class="icon-ok"></i> Approved</a></li>
									<li><a href="##" class="bulkEdit" data-alertmessage="Are you sure you want to mark the selected comments as spam?" data-action="spam"><i class="icon-flag"></i> Spam</a></li>
									<li><a href="##" class="bulkEdit" data-alertmessage="#rbKey('comments.message.confirm.delete')#" data-action="delete"><i class="icon-trash"></i> Deleted</a></li>
								</ul>
							</div>
							<div class="btn-group">
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
									<li><a href="##" class="nextN" data-nextn="10000">#rbKey('comments.all')#</a></li>
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
</cfoutput>
