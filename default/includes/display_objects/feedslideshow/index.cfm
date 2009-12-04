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
<cfparam name="hasSummary" default="true"/>
<cfset feedBean=application.feedManager.read(arguments.objectID) />

<cfset editableControl.editLink = "">
	<!---
	<cfset editableControl.historyLink = "">
	--->
	<cfset editableControl.innerHTML = "">
	
	<cfif this.showEditableObjects and objectPerm eq 'editor'>
		<cfset bean = feedBean>
		<cfset request.contentRenderer.loadShadowBoxJS()>
		
		<cfif len(application.configBean.getAdminDomain())>
			<cfif application.configBean.getAdminSSL()>
				<cfset adminBase="https://#application.configBean.getAdminDomain()#"/>
			<cfelse>
				<cfset adminBase="http://#application.configBean.getAdminDomain()#"/>
			</cfif>
		<cfelse>
			<cfset adminBase=""/>
		</cfif>
		
		<cfset editableControl.editLink = adminBase & "#application.configBean.getContext()#/admin/index.cfm?fuseaction=cFeed.edit">
		<cfset editableControl.editLink = editableControl.editLink & "&amp;siteid=" & bean.getSiteID()>
		<cfset editableControl.editLink = editableControl.editLink & "&amp;feedid=" & bean.getFeedID()>
		<cfset editableControl.editLink = editableControl.editLink & "&amp;type=" & bean.getType()>
		<cfset editableControl.editLink = editableControl.editLink & "&amp;homeID=" & request.contentBean.getContentID()>
		<cfset editableControl.editLink = editableControl.editLink & "&amp;compactDisplay=true">
		
		<cfset editableControl.innerHTML = generateEditableObjectControl(editableControl.editLink)>
	</cfif>
</cfsilent>
	<cfif editableControl.innerHTML neq "">
		<div class="editableObject editableFeed editableSlideShow">
	</cfif>
<cfswitch expression="#getJsLib()#">
	<cfcase value="jquery">
	<cfset loadJSLib() />
	<cfset addToHTMLHeadQueue("feedslideshow/htmlhead/slideshow.jquery.cfm")>
	  <cfif feedBean.getIsActive()>
		<cfset cssID=createCSSid(feedBean.renderName())>
	      <cfsilent>
			<!---<cfset loadShadowBoxJS() />--->
			<cfset rsPreFeed=application.feedManager.getFeed(feedBean,request.tag) />
			<cfif getSite().getExtranet() eq 1 and request.r.restrict eq 1>
				<cfset rs=queryPermFilter(rsPreFeed)/>
			<cfelse>
				<cfset rs=rsPreFeed />
			</cfif>
			<cfset rbFactory=getSite().getRBFactory() />
			<cfset nextN=application.utility.getNextN(rs,feedBean.getNextN(),request.StartRow)>
			<cfset checkMeta=feedBean.getDisplayRatings() or feedBean.getDisplayComments()>
			<cfset doMeta=0 />
		  </cfsilent>
	  	<cfif rs.recordcount>
	  	<div class="svSlideshow svSyndLocal svFeed svIndex clearfix" id="<cfoutput>#cssID#</cfoutput>">
	  		<cfif feedBean.getDisplayName()><cfoutput><#getHeaderTag('subHead1')#>#feedBean.renderName()#</#getHeaderTag('subHead1')#></cfoutput></cfif>
			<cfoutput><div class="svSlides"></cfoutput>
	          <cfoutput query="rs"  startrow="#request.startrow#" maxrows="#nextn.RecordsPerPage#">
	            <cfset theLink=createHREF(rs.type,rs.filename,rs.siteid,rs.contentid,rs.target,rs.targetparams,"",application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile()) />

				<cfsilent>
				<cfset class=""/>
				<cfif rs.currentRow eq 1> 
					<cfset class=listAppend(class,"first"," ")/> 
				</cfif>
				<cfif rs.currentRow eq rs.recordcount> 
					<cfset class=listAppend(class,"last"," ")/> 
				</cfif>
				
				<cfset hasImage=len(rs.fileID) and showImageInList(rs.fileExt) />

				<cfif hasImage>
					<cfset class=listAppend(class,"hasImage"," ")>
				</cfif>
				<cfif checkMeta> 
				<cfset doMeta=rs.type eq 'Page' or showItemMeta(rs.type) or (len(rs.fileID) and showItemMeta(rs.fileExt))>
				</cfif>
				</cfsilent>
				<dl<cfif class neq ''> class="#class#"</cfif>>
				<cfif rs.parentType eq 'Calendar' and isDate(rs.displaystart)>
					<dt class="releaseDate"><cfif LSDateFormat(rs.displaystart,"short") lt LSDateFormat(rs.displaystop,"short")>#LSDateFormat(rs.displaystart,getShortDateFormat())# - #LSDateFormat(rs.displaystop,getShortDateFormat())#<cfelse>#LSDateFormat(rs.displaystart,getLongDateFormat())#</cfif></dt>
				<cfelseif LSisDate(rs.releasedate)>
					<dt class="releaseDate">#LSDateFormat(rs.releasedate,getLongDateFormat())#</dt>
				</cfif>
					<dt><a href="#theLink#">#rs.MenuTitle#</a></dt>
				<cfif hasImage>
					<dd class="image">
						<a href="#theLink#" title="#HTMLEditFormat(rs.title)#"><img src="#application.configBean.getContext()#/tasks/render/medium/index.cfm?fileid=#rs.fileid#" alt="#htmlEditFormat(rs.title)#"/></a>
					</dd>
				</cfif>
				<cfif hasSummary and len(rs.summary)>
					<dd class="summary">#rs.summary#
						<span class="readMore">#addlink(rs.type,rs.filename,rbFactory.getKey('list.readmore'),rs.target,rs.targetParams,rs.contentid,request.siteid,'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())#</span>
					</dd>
				</cfif>
				<cfif len(rs.credits)>
					<dd class="credits">#rbFactory.getKey('list.by')# #rs.credits#</dd>
				</cfif>
				<cfif doMeta and feedBean.getDisplayComments()>
					<dd class="comments"><cfif isNumeric(rs.comments)>#rs.comments#<cfelse>0</cfif> <cfif rs.comments neq 1>#rbFactory.getKey('list.comments')#<cfelse>#rbFactory.getKey('list.comment')#</cfif></dd>
				</cfif>
				<cfif len(rs.tags)>
					<dd class="tags"><cfmodule template="../nav/dsp_tag_line.cfm" tags="#rs.tags#"></dd>
				</cfif>
				<cfif doMeta and feedBean.getDisplayRatings()>
					<dd class="ratings">#rbFactory.getKey('list.rating')#: <img class="ratestars" src="#event.getSite().getAssetPath()#/includes/display_objects/rater/images/star_#application.raterManager.getStarText(rs.rating)#.png" alt="<cfif isNumeric(rs.rating)>#rs.rating# star<cfif rs.rating gt 1>s</cfif></cfif>" border="0"></dd>
				</cfif>
				
				</dl>
			</cfoutput>
			</div>
		</div>
		
		<cfelse>
			<!-- Empty Collection '<cfoutput>#feedBean.getName()#</cfoutput>'  -->
		</cfif>
		
	<cfelse>
		<!-- Inactive Feed '<cfoutput>#feedBean.getName()#</cfoutput>' -->
	 </cfif>
	 </cfcase>
<cfdefaultcase>
		 <!-- The Prototype js library is not currently support for the slide show functionality  -->
</cfdefaultcase>
</cfswitch>
 <cfoutput>#editableControl.innerHTML#</cfoutput>
  <cfif editableControl.innerHTML neq "">
  	</div>
 </cfif>
