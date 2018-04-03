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
<!---
<form class="form-inline" novalidate="novalidate" id="changesetSearch" name="changesetSearch" method="get">
	<div class="input-append">
	<input name="keywords" value="#esapiEncode('html_attr',rc.keywords)#" type="text" class="text" maxlength="50" />
	<button type="button" class="btn" onclick="submitForm(document.forms.changesetSearch);"><i class="mi-search"></i></button>
	<input type="hidden" name="muraAction" value="cChangesets.list">
	<input type="hidden" name="siteid" value="#esapiEncode('html_attr',rc.siteid)#">
	</div>
</form>
--->
	<div class="mura-header">
		<h1>#application.rbFactory.getKeyValue(session.rb,"changesets")#</h1>
		<cfinclude template="dsp_secondary_menu.cfm">
	</div> <!-- /.mura-header -->

		<div class="block block-constrain">
				<div class="block block-bordered">
					<div class="block-content">



<div id="navFilters">
	<div id="navFiltersToggle">#application.rbFactory.getKeyValue(session.rb,"sitemanager.filters")#<i class="mi-chevron-down"></i></div>
	<div id="navFilterControls">
		<form novalidate="novalidate" name="searchFrm" class="form-inline" onsubmit="return validate(this);">

			<div class="mura-layout-row">

				<!--- keywords --->
				<div class="mura-6 mura-control-group">
					<label>#application.rbFactory.getKeyValue(session.rb,"params.keywords")#</label>
			  	<input name="keywords" value="#esapiEncode('html_attr',rc.keywords)#" type="text" class="text"  maxlength="50" />
		  	</div>
				<!--- /keywords --->

				<!--- from / to --->
				
				<div class="mura-control-group mura-3">
					<label>#application.rbFactory.getKeyValue(session.rb,"params.from")#</label>
					<input type="text" class="datepicker text" name="startDate" value="#LSDateFormat(rc.startDate,session.dateKeyFormat)#" validate="date" message="The 'From' date is required." />
				</div>
				<div class="mura-control-group mura-3">
				     <label>#application.rbFactory.getKeyValue(session.rb,"params.to")#</label>
				     <input type="text" class="datepicker text" name="stopDate" value="#LSDateFormat(rc.stopDate,session.dateKeyFormat)#" validate="date" message="The 'To' date is required." />
				</div>

				<!--- /type --->

			</div>
			<div class="mura-layout-row">

				<!--- categories --->
				<cfif $.getBean("categoryManager").getCategoryCount($.event("siteID"))>
					<div id="mura-list-tree" class="mura-6 mura-control-group category-select">
						<label>#application.rbFactory.getKeyValue(session.rb,"sitemanager.categories")#</label>
						<div id="category-select-control"></div>	
						<div id="category-select-list">
							<cf_dsp_categories_nest siteID="#rc.siteID#" parentID="" nestLevel="0" categoryid="#rc.categoryid#">
						</div>
					</div>
				</cfif>
				<!--- /categories --->

				<!--- tags --->
					<div id="tags" class="mura-3 mura-control-group mura-filter-tags tagSelector">
						<label>#application.rbFactory.getKeyValue(session.rb,"sitemanager.tags")#</label>
						<input type="text" class="text" name="tags">
						<cfloop list="#$.event('tags')#" index="i">
							<span class="tag">
							#esapiEncode('html',i)# <a><i class="mi-times-circle"></i></a>
							<input name="tags" type="hidden" value="#esapiEncode('html_attr',i)#">
							</span>
						</cfloop>
					</div>
				<!--- /tags --->


				<!--- buttons --->
				<div id="navFilterButtons" class="mura-actions mura-5">
					<div class="form-actions">
						<cfif len($.event('categoryID') & $.event('tags') & $.event('keywords') & $.event('startdate') & $.event('stopdate'))>
					  		<button type="button" class="btn" name="removeFilter" onclick="location.href='./?siteID=#esapiEncode('url',$.event('siteid'))#&muraAction=cChangesets.list'"><i class="mi-times-circle"></i> #application.rbFactory.getKeyValue(session.rb,"sitemanager.removefilter")# </button>
					  	</cfif>	
							<button type="submit" class="btn mura-primary" onclick="submitForm(document.forms.searchFrm);"><i class="mi-filter"></i> #application.rbFactory.getKeyValue(session.rb,"sitemanager.filter")# </button>
							<!--- hidden inputs for form action --->
							<input type="hidden" value="#esapiEncode('html_attr',rc.siteid)#" name="siteID"/>
							<input type="hidden" name="muraAction" value="cChangesets.list">

					</div>
				</div>
				<!--- /buttons --->

			</div> <!--- /.mura-layout-row --->
		</form>
	</div>	<!--- /navFilterControls --->
</div>	<!--- /navFilters --->



					<cfif rc.changesets.hasNext()>
					<table class="mura-table-grid">
					<tr>
					<th class="actions"></th>
					<th class="var-width">#application.rbFactory.getKeyValue(session.rb,'changesets.name')#</th>
					<th>#application.rbFactory.getKeyValue(session.rb,'changesets.datetopublish')#</th>
					<th>#application.rbFactory.getKeyValue(session.rb,'changesets.lastupdate')#</th>
					</tr>

					<cfloop condition="rc.changesets.hasNext()">
					<cfset rc.changeset=rc.changesets.next()>
					<tr>
						<td class="actions">
							<a class="show-actions" href="javascript:;" <!---ontouchstart="this.onclick();"---> onclick="showTableControls(this);"><i class="mi-ellipsis-v"></i></a>
							<div class="actions-menu hide">
							<ul class="actions-list">
										<li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'changesets.edit')#" href="./?muraAction=cChangesets.edit&changesetID=#rc.changeset.getchangesetID()#&siteid=#esapiEncode('url',rc.changeset.getSiteID())#&categoryid=#esapiEncode('url',rc.categoryid)#&tags=#esapiEncode('url',rc.tags)#"><i class="mi-pencil"></i>#application.rbFactory.getKeyValue(session.rb,'changesets.edit')#</a></li>
								<cfif rc.changeset.getPublished()>
											<!--- <li class="preview disabled"><i class="mi-globe"></i></li> --->
								<cfelse>
											<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'changesets.preview')#" href="##" onclick="return preview('#rc.$.getBean('content').loadBy(filename='').getURL(complete=1,queryString='changesetID=#rc.changeset.getchangesetID()#')#');"><i class="mi-globe"></i>#application.rbFactory.getKeyValue(session.rb,'changesets.preview')#</a></li>
								</cfif>
										<li class="change-sets"><a title="#application.rbFactory.getKeyValue(session.rb,'changesets.assignments')#" href="./?muraAction=cChangesets.assignments&changesetID=#rc.changeset.getchangesetID()#&siteid=#esapiEncode('url',rc.changeset.getSiteID())#&categoryid=#esapiEncode('url',rc.categoryid)#"><i class="mi-reorder"></i>#application.rbFactory.getKeyValue(session.rb,'changesets.assignments')#</a></li>
										<li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'changesets.delete')#" href="./?muraAction=cChangesets.delete&changesetID=#rc.changeset.getchangesetID()#&siteid=#esapiEncode('url',rc.changeset.getSiteID())#&categoryid=#esapiEncode('url',rc.categoryid)#&tags=#esapiEncode('url',rc.tags)##rc.$.renderCSRFTokens(context=rc.changeset.getChangesetID(),format='url')#" onclick="return confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'changesets.deleteconfirm'))#',this.href)"><i class="mi-trash"></i>#application.rbFactory.getKeyValue(session.rb,'changesets.delete')#</a></li>
							</ul>
							</div>
						</td>
						<td class="var-width"><a title="Edit" href="./?muraAction=cChangesets.assignments&changesetID=#rc.changeset.getchangesetID()#&siteid=#esapiEncode('url',rc.siteID)#&categoryid=#esapiEncode('url',rc.categoryid)#&tags=#esapiEncode('url',rc.tags)#">#esapiEncode('html',rc.changeset.getName())#</a></td>
						<td><cfif isDate(rc.changeset.getPublishDate())>#LSDateFormat(rc.changeset.getPublishDate(),session.dateKeyFormat)# #LSTimeFormat(rc.changeset.getPublishDate(),"short")#<cfelse>NA</cfif></td>
						<td>#LSDateFormat(rc.changeset.getLastUpdate(),session.dateKeyFormat)# #LSTimeFormat(rc.changeset.getLastUpdate(),"short")#</td>
					</tr></cfloop>
					</table>
					<cfelse>
						<div class="help-block-empty">#application.rbFactory.getKeyValue(session.rb,'changesets.nochangesets')#</div>
					</cfif>

					<cfif rc.changesets.pageCount() gt 1>
						<cfset args=arrayNew(1)>
						<cfset args[1]="#rc.changesets.getFirstRecordOnPageIndex()#-#rc.changesets.getLastRecordOnPageIndex()#">
						<cfset args[2]=rc.changesets.getRecordcount()>
						<div class="clearfix mura-results-wrapper">
							<p class="search-showing">
								#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.paginationmeta"),args)#
							</p>
							<ul class="pagination moreResults">
							<cfif rc.changesets.getPageIndex() gt 1>
							<li>
								<a href="./?muraAction=cChangesets.list&page=#evaluate('#rc.changesets.getPageIndex()#-1')#&siteid=#esapiEncode('url',rc.siteid)#&keywords=#esapiEncode('url',rc.keywords)#&startdate=#esapiEncode('url',rc.startdate)#&stopdate=#esapiEncode('url',rc.stopdate)#&categoryid=#esapiEncode('url',rc.categoryid)#&tags=#esapiEncode('url',rc.tags)#"><i class="mi-angle-left"></i></a>
							</li>
							</cfif>
							<cfloop from="1" to="#rc.changesets.pageCount()#" index="i">
								<cfif rc.changesets.getPageIndex() eq i>
									<li class="active"><a href="##">#i#</a></li>
								<cfelse>
									<li>
										<a href="./?muraAction=cChangesets.list&page=#i#&siteid=#esapiEncode('url',rc.siteid)#&keywords=#esapiEncode('url',rc.keywords)#&startdate=#esapiEncode('url',rc.startdate)#&stopdate=#esapiEncode('url',rc.stopdate)#&categoryid=#esapiEncode('url',rc.categoryid)#"&tags=#esapiEncode('url',rc.tags)#>#i#</a>
									</li>
								</cfif>
							</cfloop>
							<cfif rc.changesets.getPageIndex() lt rc.changesets.pagecount()>
								<li>
									<a href="./?muraAction=cChangesets.list&page=#evaluate('#rc.changesets.getPageIndex()#+1')#&siteid=#esapiEncode('url',rc.siteid)#&keywords=#esapiEncode('url',rc.keywords)#&startdate=#esapiEncode('url',rc.startdate)#&stopdate=#esapiEncode('url',rc.stopdate)#&categoryid=#esapiEncode('url',rc.categoryid)#&tags=#esapiEncode('url',rc.tags)#"><i class="mi-angle-right"></i></a>
								</li>
							</cfif>
							</ul> <!-- /.pagination -->
						</div> <!-- /.mura-results-wrapper -->
					</cfif>


					 <script>

			  	 	$(function(){
						$.get('?muraAction=cchangesets.loadtagarray&siteid=' + siteid).done(
							function(data){
								var tagArray=eval('(' + data + ')');
								$('##tags').tagSelector(tagArray, 'tags');
								}
							);
						});
		  	 		// changesets advanced filters
		  	 	  jQuery(document).ready(function(){

					  	var serializeCatCheckboxes = function(){
								var catContainer = jQuery('##category-select-control');
					  		jQuery(catContainer).find('.tag').remove();
								jQuery('##category-select-list input[type=checkbox]:checked').each(function(){
						  		var thisText = $(this).parent('li').clone().children().remove().end().text();
						  		var selCat = '<span class="tag">' + thisText + '</span>';
						  		jQuery(selCat).appendTo(catContainer);

					  		});
					  	}
					  	jQuery('##category-select-list input[type=checkbox]').click(function(){
					  			serializeCatCheckboxes();
					  	});
							serializeCatCheckboxes();

					  	jQuery('##category-select-list').hide();
					  	jQuery('##category-select-control').click(function(){
					  		jQuery('##category-select-list').slideToggle('fast');
					  	})

							jQuery('##navFilterControls').hide();
							var toggleNavFilters = function(el){
								jQuery('##navFilterControls').slideToggle('fast');
								jQuery(el).find('i').toggleClass('mi-chevron-down').toggleClass('mi-chevron-up');			
							}

							jQuery('##navFiltersToggle').click(function(){
								toggleNavFilters(jQuery(this));
							})

						<cfif len($.event('categoryID') & $.event('tags') & $.event('keywords') & $.event('startdate') & $.event('stopdate'))>
								toggleNavFilters(jQuery('##navFiltersToggle'));
							</cfif>

					  });
					</script>


<!--- 
 						<div class="well">

					<form novalidate="novalidate" name="searchFrm" class="form-inline" onsubmit="return validate(this);">

							<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.filters")#</h2>
						<div class="mura-control-group">
							<label>#application.rbFactory.getKeyValue(session.rb,"params.keywords")#</label>
						  	<input name="keywords" value="#esapiEncode('html_attr',rc.keywords)#" type="text" class="text"  maxlength="50" />
						</div>

						<div class="mura-control-group">
							<label>#application.rbFactory.getKeyValue(session.rb,"params.from")#</label>
							<input type="text" class="datepicker text" name="startDate" value="#LSDateFormat(rc.startDate,session.dateKeyFormat)#" validate="date" message="The 'From' date is required." />
						</div>
						<div class="mura-control-group">
						     <label>#application.rbFactory.getKeyValue(session.rb,"params.to")#</label>
						     <input type="text" class="datepicker text" name="stopDate" value="#LSDateFormat(rc.stopDate,session.dateKeyFormat)#" validate="date" message="The 'To' date is required." />
						</div>

						<div id="tags" class="module mura-control-group mura-filter-tags tagSelector">
							<label>#application.rbFactory.getKeyValue(session.rb,"sitemanager.tags")#</label>
							<input type="text" class="text" name="tags">
							<cfloop list="#$.event('tags')#" index="i">
								<span class="tag">
								#esapiEncode('html',i)# <a><i class="mi-times-circle"></i></a>
								<input name="tags" type="hidden" value="#esapiEncode('html_attr',i)#">
								</span>
							</cfloop>
						</div>

						<cfif application.categoryManager.getCategoryCount(rc.siteid)>
						<div class="mura-control-group" id="mura-list-tree">
							<label>#application.rbFactory.getKeyValue(session.rb,"sitemanager.categories")#</label>
						     <cf_dsp_categories_nest siteID="#rc.siteID#" parentID="" nestLevel="0" categoryid="#rc.categoryid#">
						</div>
						</cfif>
						<div class="sidebar-buttons">
							<button type="submit" class="btn" onclick="submitForm(document.forms.searchFrm);"><i class="mi-filter"></i> #application.rbFactory.getKeyValue(session.rb,"sitemanager.filter")# </button>
							<cfif len($.event('categoryID') & $.event('tags') & $.event('keywords') & $.event('startdate') & $.event('stopdate'))>
						  		<button type="button" class="btn" name="removeFilter" onclick="location.href='./?siteID=#esapiEncode('url',$.event('siteid'))#&muraAction=cChangesets.list'"><i class="mi-times-circle"></i> #application.rbFactory.getKeyValue(session.rb,"sitemanager.removefilter")# </button>
					  		</cfif>
						</div><!-- /.sidebar-buttons -->
						<input type="hidden" value="#esapiEncode('html_attr',rc.siteid)#" name="siteID"/>
						<input type="hidden" name="muraAction" value="cChangesets.list">

					</form>
				</div> <!-- /.well -->
 --->


			<div class="clearfix"></div>
		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
</div> <!-- /.block-constrain -->

</cfoutput>
