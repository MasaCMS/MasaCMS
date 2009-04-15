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
<!---<cfset loadShadowBoxJS() />--->
<cfset hasComments=application.contentGateway.getHasComments(request.siteid,request.contentBean.getcontentid()) />
<cfset hasRatings=application.contentGateway.getHasRatings(request.siteid,request.contentBean.getcontentid()) />

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

<cfset rsPreSection=application.contentGateway.getKids('00000000000000000000000000000000000',request.siteid,request.contentBean.getcontentid(),menuType,menuDate,100,request.keywords,0,request.contentBean.getsortBy(),request.contentBean.getsortDirection(),request.categoryID,request.relatedID,request.tag)>
<cfif getSite().getExtranet() eq 1 and request.r.restrict eq 1>
	<cfset rssection=queryPermFilter(rsPreSection)/>
<cfelse>
	<cfset rssection=rsPreSection/>
</cfif>
<cfset rbFactory=getSite().getRBFactory() />	
<cfset nextN=application.utility.getNextN(rsSection,request.contentBean.getNextN(),request.StartRow)>
				
</cfsilent>

<cfif nextN.totalrecords>
<div id="svPortal">
		<cfoutput query="rsSection"  startrow="#request.startrow#" maxrows="#nextn.RecordsPerPage#">
		<cfsilent>
		<cfset class=iif(rssection.currentrow eq 1,de('first'),de(iif(rssection.currentrow eq rssection.recordcount,de('last'),de(''))))>
		<cfset link=addlink(rsSection.type,rsSection.filename,rsSection.menutitle,rsSection.target,rsSection.targetParams,rsSection.contentid,request.siteid,'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())>
		<cfset class=""/>
		
		<cfif rsSection.currentRow eq 1> 
			<cfset class=listAppend(class,"first"," ")/> 
		</cfif>
		
		<cfif rsSection.currentRow eq rsSection.recordcount> 
			<cfset class=listAppend(class,"last"," ")/> 
		</cfif>
		
		<cfif hasComments and (rsSection.type eq 'Page' or showItemMeta(rsSection.type) or (len(rssection.fileID) and showItemMeta(rssection.fileExt))) >
		<cfset commentsLink=addlink(rsSection.type,rsSection.filename,'#rbFactory.getKey("list.comments")#(#application.contentGateway.getCommentCount(request.siteid,rsSection.contentid)#)',rsSection.target,rsSection.targetParams,rsSection.contentid,request.siteid,'##comments',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())>
		<cfelse>
		<cfset commentsLink="">
		</cfif>
		
		<cfset hasImage=len(rssection.fileID) and showImageInList(rssection.fileExt) />
		
		<cfif hasImage>
			<cfset class=listAppend(class,"hasImage"," ")>
		</cfif>
		
		</cfsilent>
		<dl class="clearfix<cfif class neq ''> #class#</cfif>">
		<cfif isDate(rsSection.releasedate)>
		<dt class="releaseDate">#LSDateFormat(rsSection.releasedate,getLongDateFormat())#</dt>
		</cfif>
		<dt>#link#</dt>
		<cfif hasImage>
		<dd class="image">
			<a href="#createHREF(rsSection.type,rsSection.filename,rsSection.siteid,rsSection.contentid,rsSection.target,rsSection.targetparams,"",application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())#" title="#HTMLEditFormat(rsSection.title)#"><img src="#application.configBean.getContext()#/tasks/render/small/index.cfm?fileid=#rsSection.fileid#"  alt="#htmlEditFormat(rsSection.title)#"/></a>
		</dd>
		</cfif>
	 	<cfif rsSection.summary neq ''>
	 	<dd class="summary">#rsSection.summary# <span class="readMore">#addlink(rsSection.type,rsSection.filename,rbFactory.getKey('list.readmore'),rsSection.target,rsSection.targetParams,rsSection.contentid,request.siteid,'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())#</span></dd>
	 	</cfif>
	 	<cfif rsSection.credits neq "">
	 	<dd class="credits">#rbFactory.getKey('list.by')# #rsSection.credits#</dd>
	 	</cfif>
	 	<cfif len(commentsLink)>
	 	<dd class="comments">#commentsLink#</dd>
	 	</cfif>
	 	<cfif rsSection.tags neq "">
	 	<dd class="tags"><cfmodule template="nav/dsp_tag_line.cfm" tags="#rsSection.tags#"></dd>
	 	</cfif>
	 	<cfif hasRatings and (rsSection.type eq 'Page' or showItemMeta(rsSection.type) or (len(rssection.fileID) and showItemMeta(rssection.fileExt)))>
		<!--- rating#replace(rateBean.getRate(),".","")# --->
	 	<dd class="ratings stars">#rbFactory.getKey('list.rating')#: <img class="ratestars" src="#application.configBean.getContext()#/#application.settingsmanager.getSite(request.siteid).getDisplayPoolID()#/includes/display_objects/rater/images/star_#application.raterManager.getStarText(rsSection.rating)#.png" alt="<cfif isNumeric(rsSection.rating)>#rsSection.rating# star<cfif rsSection.rating gt 1>s</cfif></cfif>" border="0"></dd>
	 	</cfif>
	 	</dl>
	 	</cfoutput>
	 
	
	<cfif nextn.numberofpages gt 1>
		<cfinclude template="dsp_nextN.cfm">
	</cfif>	
</div>
</cfif>

 <cfif not rsSection.recordcount>
	 <cfoutput>
	 <cfif request.filterBy eq "releaseMonth">
		<div id="svPortal">
		<br>
		<p>#rbFactory.getKey('list.nocontentmonth')#</p>	
		</div>
	 <cfelseif request.filterBy eq "releaseDate">
		<div id="svPortal">
		<br>
		<p>#rbFactory.getKey('list.nocontentday')#</p>	
		</div>
	 </cfif>
	 </cfoutput>
</cfif>
	
