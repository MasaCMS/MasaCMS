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

<cfoutput>
<cfsilent>
	<!---<cfset addToHTMLHeadQueue("prototype.cfm")>
	<cfset addToHTMLHeadQueue("scriptaculous.cfm")>
	<cfset addToHTMLHeadQueue("shadowbox-prototype.cfm")>
	<cfset addToHTMLHeadQueue("shadowbox.cfm")>--->
	<cfparam name="hasSummary" default="false"/>
	<cfset rbFactory=getSite().getRBFactory() />
	<cfset rsRelatedContent = application.contentManager.getRelatedContent(request.siteID,request.contentBean.getcontentHistID(),true) />
</cfsilent>
<cfif rsRelatedContent.recordCount>
	<div class="svRelContent">
	<h3>#rbFactory.getKey('list.relatedcontent')#</h3>
	<cfloop query="rsRelatedContent">
		<cfsilent>
			<cfset contentLink = createHref(rsRelatedContent.Type, rsRelatedContent.filename, request.siteid, contentID, rsRelatedContent.target,rsRelatedContent.targetParams, '', '#application.configBean.getContext()#', '#application.configBean.getStub()#', '#application.configBean.getIndexFile()#', 'false') />
			<cfset contentLink = "<a href='#contentLink#'>#menuTitle#</a>" />
			<cfset class=""/>
			<cfif rsRelatedContent.currentRow eq 1> 
			<cfset class=listAppend(class,"first"," ")/> 
			</cfif>
			<cfif rsRelatedContent.currentRow eq rsRelatedContent.recordcount> 
			<cfset class=listAppend(class,"last"," ")/> 
			</cfif>
			
			<cfset hasImage=len(rsRelatedContent.fileID) and listFindNoCase("jpg,jpeg,png",rsRelatedContent.fileExt) />
			
			<cfif hasImage>
				<cfset class=listAppend(class,"hasImage"," ")>
			</cfif>

		</cfsilent>
	<dl<cfif len(class)> class="#class#"</cfif>>
		<cfif isDate(rsRelatedContent.releasedate)>
			<dt class="releaseDate">#LSDateFormat(rsRelatedContent.releasedate,getLongDateFormat())#</dt>
		</cfif>
		<dt>#contentLink#</dt>
		<cfif hasImage>
				<dd class="image">
					<!---<a href="#application.configBean.getContext()#/tasks/render/file/index.cfm?fileID=#rsRelatedContent.FileID#&ext=.#rsRelatedContent.fileExt#" title="#HTMLEditFormat(rsRelatedContent.title)#" rel="shadowbox[svRelatedContent]">---><img src="#application.configBean.getContext()#/tasks/render/small/index.cfm?fileid=#rsRelatedContent.fileid#"/><!---</a>--->
				</dd>
		</cfif>
		<cfif hasSummary><dd>#rsRelatedContent.summary#</dd></cfif>
	</dl>
	</cfloop>
	</div>
<cfelse>
	<!-- Empty Related Content -->
</cfif>
</cfoutput>
