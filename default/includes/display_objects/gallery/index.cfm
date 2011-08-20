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

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfsilent>
	<!--- the js is not loaded in contentRenderer.dspBody() to prevent caching --->
	<cfset hasComments=application.contentGateway.getHasComments(request.siteid,$.content('contentHistID')) />
	<cfset hasRatings=application.contentGateway.getHasRatings(request.siteid,$.content('contentHistID')) />
	
	<cfparam name="request.day" default="0">
	<cfparam name="request.filterBy" default="">
	
	<cfif not isNumeric(request.month)>
		<cfset request.month=month(now())>
	</cfif>
	
	<cfif not isNumeric(request.year)>
		<cfset request.year=year(now())>
	</cfif>
	
	<cfif isNumeric(request.day) and request.day
		and request.filterBy eq "releaseDate">
		<cfset menuType="releaseDate">
		<cfset menuDate=createDate(request.year,request.month,request.day)>
	<cfelseif request.filterBy eq "releaseMonth">
		<cfset menuType="releaseMonth">
		<cfset menuDate=createDate(request.year,request.month,1)>
	<cfelse>
		<cfset menuDate=now()>
		<cfset menuType="default">
	</cfif>
	
	<cfset rsPreSection=application.contentGateway.getKids('00000000000000000000000000000000000',request.siteid,$.content('contentID'),menutype,menuDate,0,request.keywords,0,$.content('sortBy'),$.content('sortDirection'),request.categoryID,request.relatedID,request.tag)>
	<cfif getSite().getExtranet() eq 1 and request.r.restrict eq 1>
		<cfset rssection=queryPermFilter(rsPreSection)/>
	<cfelse>
		<cfset rssection=rsPreSection/>
	</cfif>
	
	<cfset rbFactory=getSite().getRBFactory() />
	<cfset iterator=$.getBean("contentIterator")>
	<cfset iterator.setQuery(rsSection,event.getContentBean().getNextN())>
	
	<cfset event.setValue("currentNextNID",$.content('contentID'))>
	
	<cfif not len($.event("nextNID")) or $.event("nextNID") eq $.event("currentNextNID")>
		<cfif event.getContentBean().getNextN() gt 1>
			<cfset currentNextNIndex=$.event("startRow")>
			<cfset iterator.setStartRow(currentNextNIndex)>
		<cfelse>
			<cfset currentNextNIndex=$.event("pageNum")>
			<cfset iterator.setPage(currentNextNIndex)>
		</cfif>
	<cfelse>	
		<cfset currentNextNIndex=1>
		<cfset iterator.setPage(1)>
	</cfif>
	
	<cfset variables.nextN=application.utility.getNextN(rsSection,event.getContentBean().getNextN(),currentNextNIndex)>
</cfsilent>
	<cfif iterator.getRecordCount()>
	<div id="svGallery"> 
			<ul class="clearfix">
			<cfloop condition="iterator.hasNext()">
			<cfsilent>
			<cfset item=iterator.next()>
			<cfset class=""/>
			<cfif not iterator.hasPrevious()> 
				<cfset class=listAppend(class,"first"," ")/> 
			</cfif>
			<cfif not iterator.hasNext()> 
				<cfset class=listAppend(class,"last"," ")/> 
			</cfif>
			</cfsilent>
			<cfoutput>
			<li class="#class#">
			<a href="#createHREFForImage(item.getValue('siteid'),item.getValue('fileid'),item.getValue('fileext'),'large',false)#" title="#HTMLEditFormat(item.getValue('title'))#" rel="shadowbox[gallery]" class="gallery"><img src="#createHREFForImage(item.getValue('siteid'),item.getValue('fileid'),item.getValue('fileext'),'small')#" alt="#HTMLEditFormat(item.getValue('title'))#"/></a>	 
		 	<dl>
		 	<dt>
		 	<cfif hasComments>
		 	<a href="?linkServID=#item.getValue('contentid')#&categoryID=#HTMLEditFormat(request.categoryID)#&relatedID=#HTMLEditFormat(request.relatedID)#" title="#HTMLEditFormat(item.getValue('title'))#">#HTMLEditFormat(item.getValue('menutitle'))#</a>
		 	<cfelse>
		 	#HTMLEditFormat(item.getValue('menutitle'))#
		 	</cfif>
		 	</dt>
		 	<cfif item.getValue('summary') neq "">
		 	<dd class="summary">
		 	#item.getValue('summary')#
		 	</dd>
		 	</cfif>	 	
		 	<cfif item.getValue('credits') neq "">
		 	<dd class="credits">#$.rbKey('list.by')# #HTMLEditFormat(item.getValue('credits'))#</dd>
		 	</cfif>
		 	<cfif hasComments>
		 	<dd class="comments"><a href="?linkServID=#item.getValue('contentid')#&categoryID=#HTMLEditFormat(request.categoryID)#&relatedID=#HTMLEditFormat(request.relatedID)#" title="#HTMLEditFormat(item.getValue('title'))#">#$.rbKey('list.comments')# (#application.contentGateway.getCommentCount(request.siteid,item.getValue('contentid'))#)</a></dd>
		 	</cfif>
		 	<cfif item.getValue('tags') neq "">
		 	<dd class="tags"><cfmodule template="#getSite($.event('siteid')).getIncludePath()#/includes/display_objects/nav/dsp_tag_line.cfm" tags="#item.getValue('tags')#"></dd>
		 	</cfif>
		 	<cfif hasRatings>
			<!--- rating#replace(rateBean.getRate(),".","")# --->
		 	<dd class="ratings stars">#$.rbKey('list.rating')#: <img class="ratestars" src="#$.siteConfig('themeAssetPath')#/images/rater/star_#application.raterManager.getStarText(item.getValue('rating'))#.png" alt="<cfif isNumeric(item.getValue('rating'))>#item.getValue('rating')# star<cfif item.getValue('rating') gt 1>s</cfif></cfif>" border="0"></dd>
		 	</cfif>
		 	</dl>
			</li>
			</cfoutput>
			</cfloop>
		</ul>		
	</div>
	<cfif variables.nextN.numberofpages gt 1>
			<cfoutput>#dspObject_Include(thefile='dsp_nextN.cfm')#</cfoutput>
		</cfif>	
	<cfelse>
	 <cfoutput>
	 <cfif request.filterBy eq "releaseMonth">
		<p>#$.rbKey('list.nocontentmonth')#</p>		
	 <cfelseif request.filterBy eq "releaseDate">
		<p>#$.rbKey('list.nocontentday')#</p>	
	<cfelse>
		<p>#$.rbKey('list.galleryisempty')#</p>
	</cfif>
	</cfoutput>
	</cfif>