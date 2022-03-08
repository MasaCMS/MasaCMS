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
<cfset tabList=listAppend(tabList,"tabCategorization")>
<cfoutput>
<div class="mura-panel panel">
	<div class="mura-panel-heading" role="tab" id="heading-categories">
		<h4 class="mura-panel-title">
			<a class="collapse collapsed" role="button" data-toggle="collapse" data-parent="##content-panels" href="##panel-categories" aria-expanded="false" aria-controls="panel-categories">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.categorization")#</a>
		</h4>
	</div>
		<div id="panel-categories" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-categories" aria-expanded="false" style="height: 0px;">
			<div class="mura-panel-body">

				<span id="extendset-container-tabcategorizationtop" class="extendset-container"></span>

				<div class="mura-control-group">
					<div id="categories__selected"></div>

					<!--- 'big ui' flyout panel --->
					<!--- todo: resource bundle key for 'manage categories' --->
					<div class="bigui" id="bigui__categories" data-label="Manage Categories">
						<div class="bigui__title">#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.availablecategories'))#</div>
						<div class="bigui__controls">

								<div class="mura-control-group">
									<div class="mura-grid stripe" id="mura-grid-categories">
										<dl class="mura-grid-hdr">
											<dt class="categorytitle">
													#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.availablecategories')#
											</dt>
											<dd class="categoryassignmentwrapper">
												<!--- <a title="#application.rbFactory.getKeyValue(session.rb,'tooltip.categoryfeatureassignment')#" rel="tooltip" href="##"> --->
															#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.feature')#<!---  <i class="mi-question-circle"></i>
												</a> --->
											</dd>
										</dl><!--- /.mura-grid-hdr --->
											<cfset rc.rsCategoryAssign=application.contentManager.getCategoriesByHistID(rc.contentBean.getContentHistID()) />
											<cf_dsp_categories_nest
												siteID="#rc.siteID#"
												parentID=""
												nestLevel="0"
												contentBean="#rc.contentBean#"
												rsCategoryAssign="#rc.rsCategoryAssign#">

									</div><!--- /.mura-grid --->
								</div>

						</div>
					</div> <!--- /.bigui --->
				</div> <!--- /.mura-control-group --->	

				<div class="mura-control-group extendedattributes-group" id="extendedattributes-container-categorization">
					<div class="bigui" id="bigui__categorization" data-label="Manage Extended Attributes">
						<div class="bigui__title">Manage Extended Attributes</div>
						<div class="bigui__controls">
							<span id="extendset-container-tabextendedattributestop"></span>
							<span id="extendset-container-categorization" class="extendset-container extendedattributes-body" data-controlparent="extendedattributes-container-categorization"></span>
							<span id="extendset-container-tabextendedattributesbottom"></span>
						</div>
					</div>
					<!--- /.bigui --->
				</div>

				<span id="extendset-container-tabcategorizationbottom" class="extendset-container"></span>
		</div>
	</div>
</div> 

</cfoutput>
<script>
	siteManager.initCategoryAssignments();

	var stripeCategories=function() {
			var counter=0;
			//alert($('#bigui__categories dl').length)
			$('#bigui__categories dl').each(
				function(index) {
					//alert(index)
					if(index && !$(this).parents('ul.categorylist:hidden').length)
					{
						//alert($(this).parents('ul.categorylist').length);
						counter++;
						//alert(counter)
						if(counter % 2) {
							$(this).addClass('alt');
						} else {
							$(this).removeClass('alt');
						}
					}
			});
			//alert(counter)
		}

	$(document).ready(function(){

		var catsInited=false;

		$('.hasChildren').click(function(){
			if(catsInited){
				$(this).closest('li').find('ul.categorylist:first').toggle();
				$(this).toggleClass('open');
				$(this).toggleClass('closed');
				stripeCategories();
			} else {
				$(this).closest('li').find('ul.categorylist:first').show();
				if(!$(this).hasClass('open')){
					$(this).toggleClass('open').toggleClass('closed');
				}
			}
		});

		<cfparam name="request.opencategorylist" default="">
		
		<cfset cats=$.getBean('categoryFeed')
			.addParam(
				column="categoryid",
				list=true,
				condition="in",
				criteria=request.opencategorylist)
			.getIterator()>

		<cfset itemList="">
		<cfloop condition="cats.hasNext()">
			<cfset cat=cats.next()>
			<cfif listLen(cat.getPath()) gt 1>
				<cfset to=listLen(cat.getPath())-1>
				<cfloop from="1" to="#to#" index="i">
					<cfset item=replace(listGetAt(cat.getPath(),i),"'","","all")>
					<cfif not listFind(itemlist,item)>
						<cfoutput>$('##bigui__categories li[data-categoryid="#item#"]').find('span.hasChildren:first').trigger('click');</cfoutput>
					<cfset itemlist=listAppend(itemList,item)>
					</cfif>

				</cfloop>
			</cfif>
		</cfloop>

		catsInited=true;

		stripe('stripe');

		// display selected categories in text format
		var showSelectedCats = function(){	
			var catList = '';
			var delim = '&nbsp;&raquo;&nbsp;';
			// create list of selected categories
			$('#mura-grid-categories #mura-nodes li .categorytitle label').each(function(){
				if($(this).find('input[type=checkbox]').prop('checked')){
					var appendStr = '';
					$(this).parentsUntil($('#mura-nodes'), 'li').each(function(){
						var labelText = $(this).find('> dl > dt > label').text();
						if(labelText.trim().length > 0){
							var curStr = appendStr;
							appendStr = labelText.trim();
							if (curStr.trim().length > 0){
							 appendStr = appendStr + delim + curStr;
							}
						}
					});
					catList = catList + '<li>' + appendStr + '</li>';
				}
			})
			<!--- todo: resource bundle values for text --->
			if (catList.trim().length > 0){
				$('#categories__selected').html('<label>Selected</label><ul>' + catList + '</ul>');
			} else {
				$('#categories__selected').html('<label>Selected</label><div>No categories selected</div>');
			}

		}
		// run on page load
		showSelectedCats();
		// run on change of selection
		$('#mura-grid-categories #mura-nodes li .categorytitle input[type=checkbox]').on('click',function(){
			showSelectedCats();
		})

	});
</script>
