<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfsilent>
	<cfset loadShadowBoxJS() />
	<cfset addToHTMLHeadQueue("gallery/htmlhead/gallery.cfm")>
		
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
			<a href="#application.configBean.getContext()#/tasks/render/file/index.cfm?fileID=#rsSection.FileID#&ext=.#rsSection.fileExt#" title="#HTMLEditFormat(rsSection.title)#" rel="shadowbox[gallery]" class="gallery"><img onload="setGallery(this);"src="#application.configBean.getContext()#/tasks/render/small/index.cfm?fileID=#rsSection.FileID#" alt="#HTMLEditFormat(rsSection.title)#"/></a>	 
		 	<dl>
		 	<dt><a href="#application.configBean.getIndexFile()#?linkServID=#rsSection.contentID#&categoryID=#request.categoryID#&relatedID=#request.relatedID#" title="#rsSection.title#">#rsSection.menutitle#</a></dt>		 	
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
		 	<dd class="ratings stars">#rbFactory.getKey('list.rating')#: <img class="ratestars" src="#application.configBean.getContext()#/#application.settingsmanager.getSite(request.siteid).getDisplayPoolID()#/includes/display_objects/rater/images/star_#application.raterManager.getStarText(rsSection.rating)#.png" alt="<cfif isNumeric(rsSection.rating)>#rsSection.rating# star<cfif rsSection.rating gt 1>s</cfif></cfif>" border="0"></dd>
		 	</cfif>
		 	</dl>
			</li>
		
			</cfoutput>
		</ul>
		<cfif nextN.numberofpages gt 1>
			<cfinclude template="../dsp_nextN.cfm">
		</cfif>
	</div>
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