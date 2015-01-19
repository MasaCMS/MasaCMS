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
<cfparam name="rc.isNew" default="1">
<cfparam name="rc.keywords" default="">
<cfparam name="rc.searchTypeSelector" default="">
<cfparam name="rc.rcStartDate" default="">
<cfparam name="rc.rcEndDate" default="">
<cfparam name="rc.rcCategoryID" default="">
<cfset request.layout=false>
<cfset baseTypeList = "Page,Folder,Calendar,Gallery,File,Link"/>
<cfset rsSubTypes = application.classExtensionManager.getSubTypes(siteID=rc.siteID, activeOnly=true) />
<cfset contentPoolSiteIDs = $.getBean('settingsManager').getSite($.event('siteId')).getContentPoolID()>
<cfif listFind(contentPoolSiteIDs, $.event('siteid'))>
	<cfset contentPoolSiteIDs = listDeleteAt(contentPoolSiteIDs, listFind(contentPoolSiteIDs, $.event('siteid')))>
</cfif>

<cfoutput>
	<script>
		function toggleRelatedType(clicked){
			$('##mura-rc-quickedit').hide();

			if($(clicked).val()=='internal'){
				$(".mura-related-internal").show();
				$(".mura-related-external").hide();
			} else {	
				$(".mura-related-internal").hide();
				$(".mura-related-external").show();
			}
		}

		function createExternalLink(){

			if($('##mura-related-title').val()=='' || $('##mura-related-url').val()==''){

				alertDialog("#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.newcontentvalidation'))#");

				return false;
			}

			var newcontentid=Math.random();

			$("##draggableContainmentExternal .list-table-items").append(
			 	$('<li/>').attr('data-contentid',newcontentid)
			 	.attr('data-url',$('##mura-related-url').val())
			 	.attr('data-title',$('##mura-related-title').val())
			 	.attr('data-content-type','Link/Default')
			 	.attr('class','item')
			 	.append(
			 		$('<button class="btn mura-rc-quickoption" type="button" value="'+ newcontentid +'"><i class="icon-plus-sign"></i></button><ul class="navZoom"/><li class="link">' + $('##mura-related-title').val() + '</li></ul></li>')
			 	)
			 ); 

			if(!$("##draggableContainmentExternal").is(":visible")){
				$("##draggableContainmentExternal").fadeIn();
			}

			$("##draggableContainmentExternal .rcDraggable li.item").draggable({
				connectToSortable: '.rcSortable',
				helper: 'clone',
				revert: 'invalid',
				appendTo: 'body',
				start: function(event, ui) {
					// bind mouse events to clone
					$('##mura-rc-quickedit').hide();
					siteManager.bindMouse();
				},
				zIndex: 100
			}).disableSelection();

			siteManager.setupRCQuikEdit();

			siteManager.bindMouse();

		}		
	</script>
	<div class="control-group">
		<label class="control-label"><a href="##" rel="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'tooltip.addrelatedcontent'))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.whereistherelatedcontent')# <i class="icon-question-sign"></i></a></label>
		<div class="controls">
			<label class="radio inline"><input type="radio" onclick="toggleRelatedType(this)" id="contentlocation1" name="contentlocation" value="internal" checked="true"/>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.inthissite')#</label>
			<label class="radio inline"><input type="radio" onclick="toggleRelatedType(this)" id="contentlocation2" name="contentlocation" value="external"/>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.onanothersite')#</label>
		</div>
	</div>
	<div class="control-group mura-related-internal">
		<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.inthissite')#</label>
		<div id="internalContent" class="form-inline">
			<div class="input-append">
				<input type="text" name="keywords" value="#rc.keywords#" id="rcSearch" placeholder="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.searchforcontent')#"/>
				<button type="button" name="btnSearch" id="rcBtnSearch" class="btn"><i class="icon-search"></i></button>
			</div>
			<a href="##" class="btn" id="aAdvancedSearch" data-toggle="button">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.advancedsearch')#</a>
		</div>	
	</div>
	
	<div class="mura-related-internal">
		<div id="rcAdvancedSearch" style="display:none;">
			<div class="control-group">
				<div class="span4">
					<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.contenttype')#</label>
					<div class="controls">
						<select name="searchTypeSelector" id="searchTypeSelector">
							<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.all')#</option>
							<cfloop list="#baseTypeList#" index="t">
								<cfsilent>
									<cfquery name="rsst" dbtype="query">select * from rsSubTypes where type = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#t#"> and subtype not in ('Default','default')</cfquery>
								</cfsilent>
								<option value="#t#^Default"<cfif rc.searchTypeSelector eq "#t#^Default"> selected="selected"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#</option>
								<cfif rsst.recordcount>
									<cfloop query="rsst">
										<option value="#t#^#rsst.subtype#"<cfif rc.searchTypeSelector eq "#t#^#rsst.subtype#"> selected="selected"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#  / #rsst.subtype#</option>
									</cfloop>
								</cfif>
							</cfloop>
						</select>
					</div>
				</div>	
				<div class="span8">
					<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.releasedaterange')#</label>
					<div class="controls">
						<input type="text" name="rcStartDate" id="rcStartDate" class="datepicker span3 mura-relatedContent-datepicker" placeholder="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.startdate'))#" value="#rc.rcStartDate#" /> &ndash; <input type="text" name="rcEndDate" id="rcEndDate" class="datepicker span3 mura-relatedContent-datepicker" placeholder="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.enddate')#" value="#rc.rcEndDate#" />
					</div>
				</div>			
			</div>
			<div class="control-group">
				<div class="controls">
					<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.availablecategories')#</label>
			
					<div id="mura-list-tree" class="controls">
						<cf_dsp_categories_nest siteID="#rc.siteID#" parentID="" categoryID="#rc.rcCategoryID#" nestLevel="0" useID="0" elementName="rcCategoryID">
					</div>
				</div>
			</div>
		</div>
	</div>
</cfoutput>


<cfif not rc.isNew>
	<cfscript>
		$=application.serviceFactory.getBean("MuraScope");
	
		function getRelatedFeed($,siteid){
			feed=$.getBean("feed");
			feed.setMaxItems(100);
			feed.setNextN(100);
			feed.setLiveOnly(0);
			feed.setShowNavOnly(0);
			feed.setSortBy("lastupdate");
			feed.setSortDirection("desc");
			feed.setContentPoolID(arguments.siteid);
			
			feed.addParam(field="active", criteria=1, condition="eq");
			feed.addParam(field="contentid", criteria=$.event('contentid'), condition="neq");

			if (len($.event("searchTypeSelector"))) {
				feed.addParam(field="tcontent.type",criteria=listFirst($.event("searchTypeSelector"), "^"),condition="eq");	
				feed.addParam(field="tcontent.subtype",criteria=listLast($.event("searchTypeSelector"), "^"),condition="eq");	
			}
			
			if(len($.event("rcStartDate")) or len($.event("rcEndDate"))){
				feed.addParam(relationship="and (");
				

				started=false;

				feed.addParam(relationship="(");

				if (len($.event("rcStartDate"))) {
					feed.addParam(field="tcontent.releaseDate",datatype="date",condition="gte",criteria=$.event("rcStartDate"));	
				}
				
				if (len($.event("rcEndDate"))) {
					feed.addParam(field="tcontent.releaseDate",datatype="date",condition="lt",criteria=dateAdd('d',1,$.event("rcEndDate")));	
				}

				feed.addParam(relationship=")");

				feed.addParam(relationship="or (");

				if (len($.event("rcStartDate"))) {
					feed.addParam(field="tcontent.displayStart",datatype="date",condition="gte",criteria=$.event("rcStartDate"));	
				}
				
				if (len($.event("rcEndDate"))) {
					feed.addParam(field="tcontent.displayStart",datatype="date",condition="lt",criteria=dateAdd('d',1,$.event("rcEndDate")));	
				}

				feed.addParam(relationship=")");

				feed.addParam(relationship="or (");

				if (len($.event("rcStartDate"))) {
					feed.addParam(field="tcontent.featureStart",datatype="date",condition="gte",criteria=$.event("rcStartDate"));	
				}
				
				if (len($.event("rcEndDate"))) {
					feed.addParam(field="tcontent.featureStart",datatype="date",condition="lt",criteria=dateAdd('d',1,$.event("rcEndDate")));	
				}

				feed.addParam(relationship=")");


		
				feed.addParam(relationship=")");
			}
			
			if (len($.event("rcCategoryID"))) {
				feed.setCategoryID($.event("rcCategoryID"));	
			}
			
			if (len($.event("keywords"))) {	
				subList=$.getBean("contentManager").getPrivateSearch(arguments.siteid,$.event("keywords"));
				feed.addParam(field="tcontent.contentID",datatype="varchar",condition="in",criteria=valuelist(subList.contentID));
			}
			return feed;
		}

		rc.rslist=getRelatedFeed($,$.event('siteid')).getQuery();
	</cfscript>

	<div class="control-group mura-related-internal">
		<cfif rc.rslist.recordcount>
			<div id="draggableContainmentInternal" class="list-table search-results">
				<div class="list-table-content-set">
					<cfoutput><cfif len( contentPoolSiteIDs )>#$.getBean('settingsManager').getSite($.event('siteId')).getSite()#:</cfif> 
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.searchresults')# (1-#min(rc.rslist.recordcount,100)# of #rc.rslist.recordcount#)</cfoutput>
				</div>
				<ul class="rcDraggable list-table-items">
					<cfoutput query="rc.rslist" startrow="1" maxrows="100">	
						<cfset crumbdata = application.contentManager.getCrumbList(rc.rslist.contentid, rc.siteid)/>
						<cfif arrayLen(crumbdata) and structKeyExists(crumbdata[1],"parentArray") and not listFind(arraytolist(crumbdata[1].parentArray),rc.contentid)>
							<li class="item" data-content-type="#rc.rslist.type#/#rc.rslist.subtype#" data-contentid="#rc.rslist.contentID#">
								<button class="btn mura-rc-quickoption" type="button" value="#rc.rslist.contentID#"><i class="icon-plus"></i></button>  #$.dspZoomNoLinks(crumbdata=crumbdata, charLimit=90, minLevels=2)#
							</li>
						</cfif>
					</cfoutput>
				</ul>
			</div>
		<cfelse>
			<cfoutput>  
				<p>#application.rbFactory.getKeyValue(session.rb,'sitemanager.noresults')#</p>
			</cfoutput>
		</cfif>

		
		<!--- Cross-Site Related Search --->
		<cfloop list="#contentPoolSiteIDs#" index="siteId">
			<cfif siteId neq $.event('siteid') and len($.event("keywords"))>		
				<cfset rc.rslist=getRelatedFeed($,siteId).getQuery()>

				<cfif rc.rslist.recordcount>
					<div id="draggableContainmentInternal" class="list-table search-results">
						<div class="list-table-content-set">
							<cfoutput>#$.getBean('settingsManager').getSite(siteId).getSite()#: 
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.searchresults')# (1-#min(rc.rslist.recordcount,100)# of #rc.rslist.recordcount#)</cfoutput>
						</div>
						<ul class="rcDraggable list-table-items">
							<cfoutput query="rc.rslist" startrow="1" maxrows="100">
								<cfset crumbdata = application.contentManager.getCrumbList(rc.rslist.contentid, siteId)/>
								<cfif arrayLen(crumbdata) and structKeyExists(crumbdata[1],"parentArray") and not listFind(arraytolist(crumbdata[1].parentArray),rc.contentid)>
									<li class="item" data-content-type="#rc.rslist.type#/#rc.rslist.subtype#" data-contentid="#rc.rslist.contentID#">
										<button class="btn mura-rc-quickoption" type="button" value="#rc.rslist.contentID#"><i class="icon-plus"></i></button>  #$.dspZoomNoLinks(crumbdata=crumbdata, charLimit=90, minLevels=2)#
									</li>
								</cfif>
							</cfoutput>
						</ul>
					</div>
				<cfelse>
					<cfoutput>  
						<p>#application.rbFactory.getKeyValue(session.rb,'sitemanager.noresults')#</p>
					</cfoutput>
				</cfif>
			</cfif>
		</cfloop>
	</div>
</cfif>
<cfoutput>
<div class="control-group mura-related-external" style="display:none;">
	<div class="span6">
		<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.title')#</label>
		<div class="controls">
			<input type="text" id="mura-related-title" value="" class="span12">	
		</div>
	</div>
	<div class="span6">
		<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.url')#</label>
		<div class="controls input-append">
			<input type="text" id="mura-related-url" value="" placeholder="http://www.example.com" class="span12">
			<button type="button" name="btnCreateLink" id="rcBtnCreateLink" class="btn" onclick="createExternalLink();"><i class="icon-plus-sign"></i></button>		
		</div>
	</div>
</div>	

<div class="mura-related-external" style="display:none;">
	<div id="draggableContainmentExternal" class="control-group" style="display:none;">
		<div class="list-table search-results">
			<div class="list-table-content-set">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.relatedcontent.availableurls')#</label></div>
			<ul class="rcDraggable list-table-items"></ul>
		</div>	
	</div>
</div>
</cfoutput>



