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
<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="variables.rsSection">select contentid,filename,menutitle,target,restricted,restrictgroups,type,sortBy,sortDirection from tcontent where siteid='#request.siteid#' and contentid='#arguments.objectid#' and approved=1 and active=1 and display=1</cfquery>
<cfif variables.rsSection.recordcount>
<cfset variables.hasComments=application.contentGateway.getHasComments(request.siteid,rsSection.contentID) />
<cfset variables.hasRatings=application.contentGateway.getHasRatings(request.siteid,rsSection.contentID) />
<cfset variables.checkMeta=variables.hasRatings or variables.hasComments />
<cfset menutype=iif(rsSection.type eq 'Portal',de('default'),de('calendar_features'))/>
<cfset rsPreFeatures=application.contentGateway.getkids('00000000000000000000000000000000000','#request.siteid#','#arguments.objectid#',menutype,now(),0,"",1,iif(rsSection.type eq 'Portal',de('#rsSection.sortBy#'),de('displaystart')),iif(rsSection.type eq 'Portal',de('#rsSection.sortDirection#'),de('desc')))>
	<cfif getSite().getExtranet() eq 1 and request.r.restrict eq 1>
		<cfset variables.rsFeatures=queryPermFilter(variables.rsPreFeatures)/>
	<cfelse>
		<cfset variables.rsFeatures=rsPreFeatures/>
	</cfif>
</cfif>
<cfset variables.rbFactory=getSite().getRBFactory() />
<cfparam name="variables.hasSummary" default="true"/>
<cfset cssID="#createCSSID(variables.rsSection.menuTitle)#Features">
<cfset doMeta=0 />
</cfsilent>
<cfoutput>
<cfif variables.rsSection.recordcount and variables.rsFeatures.recordcount>
<div id="#variables.cssID#" class="svSyndLocal svIndex clearfix">
<#variables.$.getHeaderTag('subHead1')#>#variables.rsSection.menutitle#</#variables.$.getHeaderTag('subHead1')#>
<cfloop query="variables.rsFeatures">
		<cfsilent>
			<cfset variables.theLink=createHREF(variables.rsFeatures.type,variables.rsFeatures.filename,variables.rsFeatures.siteid,variables.rsFeatures.contentid,variables.rsFeatures.target,variables.rsFeatures.targetparams,"",application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile()) />
				<cfset variables.class=""/>
				<cfif variables.rsFeatures.currentRow eq 1> 
					<cfset variables.class=listAppend(variables.class,"first"," ")/> 
				</cfif>
				<cfif variables.rsFeatures.currentRow eq variables.rsFeatures.recordcount> 
					<cfset variables.class=listAppend(variables.class,"last"," ")/> 
				</cfif>
				
				<cfset variables.hasImage=len(variables.rsFeatures.fileID) and showImageInList(variables.rsFeatures.fileExt) />

				<cfif variables.hasImage>
					<cfset variables.class=listAppend(variables.class,"hasImage"," ")>
				</cfif>
				<cfif variables.checkMeta> 
				<cfset variables.doMeta=variables.rsFeatures.type eq 'Page' or showItemMeta(variables.rsFeatures.type) or (len(variables.rsFeatures.fileID) and showItemMeta(variables.rsFeatures.fileExt))>
				</cfif>
				</cfsilent>
				<dl<cfif class neq ''> class="#variables.class#"</cfif>>
				<cfif variables.menutype eq  "calendar_features" and isDate(variables.rsFeatures.displaystart)>
					<dt class="releaseDate"><cfif LSDateFormat(variables.rsFeatures.displaystart,"short") lt LSDateFormat(variables.rsFeatures.displaystop,"short")>#LSDateFormat(variables.rsFeatures.displaystart,getShortDateFormat())# - #LSDateFormat(variables.rsFeatures.displaystop,getShortDateFormat())#<cfelse>#LSDateFormat(variables.rsFeatures.displaystart,getLongDateFormat())#</cfif></dt>
				<cfelseif LSisDate(rsFeatures.releasedate)>
					<dt class="releaseDate">#LSDateFormat(variables.rsFeatures.releasedate,getLongDateFormat())#</dt>
				</cfif>
					<dt><a href="#variables.theLink#">#variables.rsFeatures.MenuTitle#</a></dt>
				<cfif hasImage>
					<dd class="image">
						<!---<a href="#application.configBean.getContext()#/tasks/render/file/index.cfm?fileID=#rsFeatures.FileID#&ext=.#rsFeatures.fileExt#" title="#HTMLEditFormat(rsFeatures.title)#" rel="shadowbox[#cssID#]">---><img src="#createHREFForImage(rsFeatures.siteID,rsFeatures.fileID,rsFeatures.fileExt,'small')#" alt="#htmlEditFormat(rsFeatures.title)#"/><!---</a>--->
					</dd>
				</cfif>
				<cfif variables.hasSummary and len(variables.rsFeatures.summary)>
					<dd>#variables.$.setDynamicContent(variables.rsFeatures.summary)#</dd>
					<dd class="readMore">#variables.$.addlink(variables.rsFeatures.type,variables.rsFeatures.filename,rbFactory.getKey('list.readmore'),variables.rsFeatures.target,variables.rsFeatures.targetParams,rsFeatures.contentid,request.siteid,'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())#</dd>
				</cfif>
				<cfif len(variables.rsFeatures.credits)>
					<dd class="credits">#variables.rbFactory.getKey('list.by')# #variables.rsFeatures.credits#</dd>
				</cfif>
				<cfif doMeta and hasComments>
					<dd class="comments"><cfif isNumeric(variables.rsFeatures.comments)>#variables.rsFeatures.comments#<cfelse>0</cfif> <cfif rsFeatures.comments neq 1>#variables.rbFactory.getKey('list.comments')#<cfelse>#variables.rbFactory.getKey('list.comment')#</cfif></dd>
				</cfif>
				<cfif len(rsFeatures.tags)>
					<dd class="tags"><cfmodule template="nav/dsp_tag_line.cfm" tags="#variables.rsFeatures.tags#"></dd>
				</cfif>
				<cfif variables.doMeta and variables.hasRatings>
					<dd class="rating #application.raterManager.getStarText(variables.rsFeatures.rating)#"><dd class="rating #application.raterManager.getStarText(variables.rsFeatures.rating)#">#rbFactory.getKey('list.rating')#: <span><cfif isNumeric(variables.rsFeatures.rating)>#variables.rsFeatures.rating# star<cfif variables.rsFeatures.rating gt 1>s</cfif><cfelse>Zero stars</cfif></span></dd>
				</cfif>
				</dl>
		</cfloop>	
		<dl class="moreResults">
		<dt>&raquo; <a href="#application.configBean.getContext()##getURLStem(request.siteid,rssection.filename)#">#variables.rbFactory.getKey('list.viewall')#</a></dt></dl>
</div>
<cfelse>
	<!-- Empty Portal Features '#rsSection.menutitle#' -->
</cfif>
</cfoutput>