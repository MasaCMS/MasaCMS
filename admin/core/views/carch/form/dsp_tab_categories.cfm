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
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.categorization"))/>
<cfset tabList=listAppend(tabList,"tabCategorization")>
<cfoutput>
	<div id="tabCategorization" class="tab-pane fade">

		<span id="extendset-container-tabcategorizationtop" class="extendset-container"></span>

		<div class="fieldset">
		<div class="control-group">
		<div class="mura-grid stripe">
			<dl class="mura-grid-hdr">
				<dt class="categorytitle">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.availablecategories')#
				</dt>
				<dd class="categoryassignmentwrapper">
					<a title="#application.rbFactory.getKeyValue(session.rb,'tooltip.categoryfeatureassignment')#" rel="tooltip" href="##">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.feature')# <i class="icon-question-sign"></i>
					</a>
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

		<span id="extendset-container-categorization" class="extendset-container"></span>
		<span id="extendset-container-tabcategorizationbottom" class="extendset-container"></span>
		
	</div><!--- /tabCatgeorization --->
</cfoutput>
<script>
	siteManager.initCategoryAssignments();

	var stripeCategories=function() {
			var counter=0;
			//alert($('#tabCategorization dl').length)
			$('#tabCategorization dl').each(
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
						<cfoutput>$('##tabCategorization li[data-categoryid="#item#"]').find('span.hasChildren:first').trigger('click');</cfoutput>
					<cfset itemlist=listAppend(itemList,item)>
					</cfif>
					
				</cfloop>
			</cfif>		
		</cfloop>
		
		catsInited=true;

		$('a[data-toggle="tab"]').on('shown', function (e) {		
		  if(e.target.toString().indexOf('#tabCategorization') != -1){
		  	stripeCategories()
		  }	 
		})
	});
</script>