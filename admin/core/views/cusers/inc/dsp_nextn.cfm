<cfoutput>
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
</cfoutput>