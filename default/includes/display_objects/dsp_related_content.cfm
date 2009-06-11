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
	<div class="svRelContent svIndex">
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
