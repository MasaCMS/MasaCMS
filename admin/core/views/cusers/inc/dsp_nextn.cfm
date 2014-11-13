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
<cfoutput>

	<cfif IsDefined('rc.nextn')>


		<script>
		jQuery(document).ready(function($){

			$('a.nextN').click(function(e){
				e.preventDefault();
				actionModal();
				$('form##frmNextN input[name="recordsperpage"]').val($(this).attr('data-nextn'));
				$('form##frmNextN input[name="pageno"]').val(1);
				$('form##frmNextN').submit();
			});

			$('a.pageNo').click(function(e){
				e.preventDefault();
				actionModal();
				$('form##frmNextN input[name="startrow"]').val($(this).attr('data-pageno'));
				$('form##frmNextN').submit();
			});

		});
		</script>

		<form id="frmNextN" action="" method="post">
			<input type="hidden" name="muraAction" value="#rc.muraAction#">
			<input type="hidden" name="siteid" value="#rc.siteid#">
			<input type="hidden" name="ispublic" value="#rc.ispublic#">
			<input type="hidden" name="unassigned" value="#rc.unassigned#">
			<input type="hidden" name="recordsperpage" value="#rc.nextn.recordsperpage#">
			<input type="hidden" name="startrow" value="#rc.nextn.startrow#">
		</form>

		<div class="container">
			<div class="row-fluid">

				<!--- Records Per Page --->
					<div class="btn-group">
						<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
							#rbKey('user.recordsperpage')#
							<span class="caret"></span>
						</a>

						<cfset local.arrPages = [5,10,25,50,100,250,500,1000] />
						<ul class="dropdown-menu">
							<cfloop array="#local.arrPages#" index="local.pagecount">
								<li <cfif rc.recordsperpage eq local.pagecount> class="active"</cfif>><a href="##" class="nextN" data-nextn="#local.pagecount#">#local.pagecount#</a></li>
							</cfloop>
							<li <cfif rc.recordsperpage eq 100000> class="active"</cfif>><a href="##" class="nextN" data-nextn="100000">#rbKey('user.all')#</a></li>
						</ul>
					</div>

				<cfif rc.nextn.numberofpages gt 1>
					<!--- Pagination --->
						<div class="pagination pull-right">
							<ul>

								<!--- Previous Link --->
									<cfscript>
										if ( rc.it.getPageIndex() == 1 ) {
											local.prevClass = 'disabled';
											local.prevNo = '';
										} else {
											local.prevClass = 'pageNo';
											local.prevNo = rc.it.getPageIndex() - 1;
										}
									</cfscript>
									<li class="#local.prevClass#">
										<a hre="##" data-pageno="#local.prevNo#" class="#local.prevClass#">&laquo;</a>
									</li>

								<!--- Page Number Links --->
									<cfloop from="#rc.nextn.firstpage#" to="#rc.nextn.lastpage#" index="local.pagenumber">
										<li<cfif rc.it.getPageIndex() eq local.pagenumber> class="disabled"</cfif>>
											<cfset lClass = "pageNo">
											<cfif Val(rc.it.getPageIndex()) eq local.pagenumber>
												<cfset lClass &= ' active' />
											</cfif>
											<a href="##" data-pageno="#local.pagenumber#" class="#lClass#">
												#local.pagenumber#
											</a>
										</li>
									</cfloop>

								<!--- Next Link --->
									<cfscript>
										if ( rc.it.getPageIndex() == rc.nextn.numberofpages ) {
											rc.nextClass = 'disabled';
											rc.prevNo = '';
										} else {
											rc.nextClass = 'pageNo';
											rc.prevNo = rc.it.getPageIndex() + 1;
										}
									</cfscript>
									<li class="#rc.nextClass#">
										<a href="##" data-pageno="#rc.prevNo#" class="#rc.nextClass#">&raquo;</a>
									</li>

							</ul>
						</div>
				</cfif>
			</div>
		</div>
	</cfif>
</cfoutput>