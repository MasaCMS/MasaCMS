<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfsilent>
	<!--- the js is not loaded in contentRenderer.dspBody() to prevent caching --->
	<cfset hasComments=application.contentGateway.getHasComments(request.siteid,request.contentBean.getContentHistID()) />
	<cfset hasRatings=application.contentGateway.getHasRatings(request.siteid,request.contentBean.getContentHistID()) />
	
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
	
	<cfset rsPreSection=application.contentGateway.getKids('00000000000000000000000000000000000',request.siteid,request.contentBean.getcontentid(),menutype,menuDate,0,request.keywords,0,request.contentBean.getsortBy(),request.contentBean.getsortDirection(),request.categoryID,request.relatedID,request.tag)>
	<cfif getSite().getExtranet() eq 1 and request.r.restrict eq 1>
		<cfset rssection=queryPermFilter(rsPreSection)/>
	<cfelse>
		<cfset rssection=rsPreSection/>
	</cfif>
	
	<cfset rbFactory=getSite().getRBFactory() />
	<cfset nextN=application.utility.getNextN(rsSection,request.contentBean.getNextN(),request.StartRow)>
</cfsilent>
	<cfif nextN.totalrecords>
	<div id="svGallery"> 
			<ul class="clearfix">
			<cfoutput query="rsSection"  startrow="#request.startrow#" maxrows="#nextn.RecordsPerPage#">
			<cfsilent>
			<cfset class=iif(rssection.currentrow eq 1,de('first'),de(iif(rssection.currentrow eq rssection.recordcount,de('last'),de(''))))>
			</cfsilent>
			<li class="#class#">
			<a href="#application.configBean.getContext()#/tasks/render/file/index.cfm?fileID=#rsSection.FileID#&ext=.#rsSection.fileExt#" title="#HTMLEditFormat(rsSection.title)#" rel="shadowbox[gallery]" class="gallery"><img src="#createHREFForImage(rsSection.siteID,rsSection.fileID,rsSection.fileExt,'small')#" alt="#HTMLEditFormat(rsSection.title)#"/></a>	 
		 	<dl>
		 	<dt>
		 	<cfif hasComments>
		 	<a href="#application.configBean.getIndexFile()#?linkServID=#rsSection.contentID#&categoryID=#request.categoryID#&relatedID=#request.relatedID#" title="#rsSection.title#">#rsSection.menutitle#</a>
		 	<cfelse>
		 	#rsSection.menutitle#
		 	</cfif>
		 	</dt>		 	
		 	<cfif rsSection.credits neq "">
		 	<dd class="credits">#rbFactory.getKey('list.by')# #rsSection.credits#</dd>
		 	</cfif>
		 	<cfif hasComments>
		 	<dd class="comments"><a href="#application.configBean.getIndexFile()#?linkServID=#rsSection.contentID#&categoryID=#request.categoryID#&relatedID=#request.relatedID#" title="#rsSection.title#">#rbFactory.getKey('list.comments')# (#application.contentGateway.getCommentCount(request.siteid,rsSection.contentid)#)</a></dd>
		 	</cfif>
		 	<cfif rsSection.tags neq "">
		 	<dd class="tags"><cfmodule template="../nav/dsp_tag_line.cfm" tags="#rsSection.tags#"></dd>
		 	</cfif>
		 	<cfif hasRatings>
			<!--- rating#replace(rateBean.getRate(),".","")# --->
		 	<dd class="ratings stars">#rbFactory.getKey('list.rating')#: <img class="ratestars" src="#event.getSite().getAssetPath()#/includes/display_objects/rater/images/star_#application.raterManager.getStarText(rsSection.rating)#.png" alt="<cfif isNumeric(rsSection.rating)>#rsSection.rating# star<cfif rsSection.rating gt 1>s</cfif></cfif>" border="0"></dd>
		 	</cfif>
		 	</dl>
			</li>
			</cfoutput>
		</ul>		
	</div>
	<cfif nextN.numberofpages gt 1>
			<cfinclude template="../dsp_nextN.cfm">
		</cfif>	
	<cfelse>
	 <cfoutput>
	 <cfif request.filterBy eq "releaseMonth">
		<p>#rbFactory.getKey('list.nocontentmonth')#</p>		
	 <cfelseif request.filterBy eq "releaseDate">
		<p>#rbFactory.getKey('list.nocontentday')#</p>	
	<cfelse>
		<p>#rbFactory.getKey('list.galleryisempty')#</p>
	</cfif>
	</cfoutput>
	</cfif>