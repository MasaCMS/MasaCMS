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

<cfsilent>
<!---<cfset loadShadowBoxJS() />--->
<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rsSection">select contentid,filename,menutitle,target,restricted,restrictgroups,type,sortBy,sortDirection from tcontent where siteid='#request.siteid#' and contentid='#arguments.objectid#' and approved=1 and active=1 and display=1</cfquery>
<cfif rsSection.recordcount>
<cfset hasComments=application.contentGateway.getHasComments(request.siteid,rsSection.contentID) />
<cfset hasRatings=application.contentGateway.getHasRatings(request.siteid,rsSection.contentID) />
<cfset checkMeta=hasRatings or hasComments />
<cfset menutype=iif(rsSection.type eq 'Portal',de('default'),de('calendar_features'))/>
<cfset rsPreFeatures=application.contentGateway.getkids('00000000000000000000000000000000000','#request.siteid#','#arguments.objectid#',menutype,now(),0,"",1,iif(rsSection.type eq 'Portal',de('#rsSection.sortBy#'),de('displaystart')),iif(rsSection.type eq 'Portal',de('#rsSection.sortDirection#'),de('desc')))>
	<cfif getSite().getExtranet() eq 1 and request.r.restrict eq 1>
		<cfset rsFeatures=queryPermFilter(rsPreFeatures)/>
	<cfelse>
		<cfset rsFeatures=rsPreFeatures/>
	</cfif>
</cfif>
<cfset rbFactory=getSite().getRBFactory() />
<cfparam name="hasSummary" default="true"/>
<cfset cssID="#createCSSID(rsSection.menuTitle)#Features">
<cfset doMeta=0 />
</cfsilent>
<cfoutput>
<cfif rsSection.recordcount and rsFeatures.recordcount>
<div id="#cssID#" class="svSyndLocal svIndex clearfix">
<#getHeaderTag('subHead1')#>#rsSection.menutitle#</#getHeaderTag('subHead1')#>
<cfloop query="rsFeatures">
		<cfsilent>
			<cfset theLink=createHREF(rsFeatures.type,rsFeatures.filename,rsFeatures.siteid,rsFeatures.contentid,rsFeatures.target,rsFeatures.targetparams,"",application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile()) />
				<cfset class=""/>
				<cfif rsFeatures.currentRow eq 1> 
					<cfset class=listAppend(class,"first"," ")/> 
				</cfif>
				<cfif rsFeatures.currentRow eq rsFeatures.recordcount> 
					<cfset class=listAppend(class,"last"," ")/> 
				</cfif>
				
				<cfset hasImage=len(rsFeatures.fileID) and showImageInList(rsFeatures.fileExt) />

				<cfif hasImage>
					<cfset class=listAppend(class,"hasImage"," ")>
				</cfif>
				<cfif checkMeta> 
				<cfset doMeta=rsFeatures.type eq 'Page' or showItemMeta(rsFeatures.type) or (len(rsFeatures.fileID) and showItemMeta(rsFeatures.fileExt))>
				</cfif>
				</cfsilent>
				<dl<cfif class neq ''> class="#class#"</cfif>>
				<cfif menutype eq  "calendar_features" and isDate(rsFeatures.displaystart)>
					<dt class="releaseDate"><cfif LSDateFormat(rsFeatures.displaystart,"short") lt LSDateFormat(rsFeatures.displaystop,"short")>#LSDateFormat(rsFeatures.displaystart,getShortDateFormat())# - #LSDateFormat(rsFeatures.displaystop,getShortDateFormat())#<cfelse>#LSDateFormat(rsFeatures.displaystart,getLongDateFormat())#</cfif></dt>
				<cfelseif LSisDate(rsFeatures.releasedate)>
					<dt class="releaseDate">#LSDateFormat(rsFeatures.releasedate,getLongDateFormat())#</dt>
				</cfif>
					<dt><a href="#theLink#">#rsFeatures.MenuTitle#</a></dt>
				<cfif hasImage>
					<dd class="image">
						<!---<a href="#application.configBean.getContext()#/tasks/render/file/index.cfm?fileID=#rsFeatures.FileID#&ext=.#rsFeatures.fileExt#" title="#HTMLEditFormat(rsFeatures.title)#" rel="shadowbox[#cssID#]">---><img src="#createHREFForImage(rsFeatures.siteID,rsFeatures.fileID,rsFeatures.fileExt,'small')#" alt="#htmlEditFormat(rsFeatures.title)#"/><!---</a>--->
					</dd>
				</cfif>
				<cfif hasSummary and len(rsFeatures.summary)>
					<dd>#setDynamicContent(rsFeatures.summary)#</dd>
					<dd class="readMore">#addlink(rsFeatures.type,rsFeatures.filename,rbFactory.getKey('list.readmore'),rsFeatures.target,rsFeatures.targetParams,rsFeatures.contentid,request.siteid,'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())#</dd>
				</cfif>
				<cfif len(rsFeatures.credits)>
					<dd class="credits">#rbFactory.getKey('list.by')# #rsFeatures.credits#</dd>
				</cfif>
				<cfif doMeta and hasComments>
					<dd class="comments"><cfif isNumeric(rsFeatures.comments)>#rsFeatures.comments#<cfelse>0</cfif> <cfif rsFeatures.comments neq 1>#rbFactory.getKey('list.comments')#<cfelse>#rbFactory.getKey('list.comment')#</cfif></dd>
				</cfif>
				<cfif len(rsFeatures.tags)>
					<dd class="tags"><cfmodule template="nav/dsp_tag_line.cfm" tags="#rsFeatures.tags#"></dd>
				</cfif>
				<cfif doMeta and hasRatings>
					<dd class="rating #application.raterManager.getStarText(rsFeatures.rating)#"><dd class="rating #application.raterManager.getStarText(rsFeatures.rating)#">#rbFactory.getKey('list.rating')#: <span><cfif isNumeric(rsFeatures.rating)>#rsFeatures.rating# star<cfif rsFeatures.rating gt 1>s</cfif><cfelse>Zero stars</cfif></span></dd>
				</cfif>
				</dl>
		</cfloop>	
		<dl class="moreResults">
		<dt>&raquo; <a href="#application.configBean.getContext()##getURLStem(request.siteid,rssection.filename)#">#rbFactory.getKey('list.viewall')#</a></dt></dl>
</div>
<cfelse>
	<!-- Empty Portal Features '#rsSection.menutitle#' -->
</cfif>
</cfoutput>