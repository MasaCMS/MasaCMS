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
<cfset categoryBean=application.categoryManager.read(arguments.objectid) />
<cfif categoryBean.getIsActive()>
<cfset rsPreFeatures=application.categoryManager.getLiveCategoryFeatures(arguments.objectid)>
	<cfif getSite().getExtranet() eq 1 and request.r.restrict eq 1>
		<cfset rsFeatures=queryPermFilter(rsPreFeatures)/>
	<cfelse>
		<cfset rsFeatures=rsPreFeatures/>
	</cfif>
</cfif>
<cfset rbFactory=getSite().getRBFactory() />
</cfsilent> 
<cfoutput>
<cfif rsFeatures.recordcount and categoryBean.getIsActive()>
<cfparam name="hasSummary" default="true"/>
<cfset cssID=createCSSid(categoryBean.getName())>
<div class="svCatFeatures" id="#cssID#">
<h3>#categoryBean.getName()#</h3>
<cfloop query="rsFeatures">
		<cfsilent>
			<cfset class=iif(rsFeatures.currentrow eq 1,de('first'),de(iif(rsFeatures.currentrow eq rsFeatures.recordcount,de('last'),de(''))))>
			<cfset link=addlink('#rsFeatures.type#','#rsFeatures.filename#','#rsFeatures.menutitle#','#rsFeatures.target#','#rsFeatures.targetParams#','#rsFeatures.contentid#','#request.siteid#','','#application.configBean.getContext()#','#application.configBean.getStub()#','#application.configBean.getIndexFile()#')>
				
			<cfset hasImage=len(rsFeatures.fileID) and showImageInList(rsFeatures.fileExt) />

			<cfif hasImage>
				<cfset class=listAppend(class,"hasImage"," ")>
			</cfif>
		</cfsilent> 
		 <dl<cfif class neq ''> class="#class#"</cfif>>
		 <cfif isDate(rsFeatures.releasedate)>
		 <dt class="releaseDate">#LSDateFormat(rsFeatures.releasedate,getLongDateFormat())#</dt>
		</cfif>
		<dt>#link#</dt>
		<cfif hasImage>
			<dd class="image">
				<!---<a href="#application.configBean.getContext()#/tasks/render/file/index.cfm?fileID=#rsFeatures.FileID#&ext=.#rsFeatures.fileExt#" title="#HTMLEditFormat(rsFeatures.title)#" rel="shadowbox[#cssID#]">---><img src="#application.configBean.getContext()#/tasks/render/small/index.cfm?fileid=#rsFeatures.fileid#"/><!---</a>--->
			</dd>
		</cfif>
		<cfif hasSummary><dd>#rsFeatures.summary#</dd></cfif></dl></cfloop>
</div>
<cfelse>
<!-- Empty Category Features '#categoryBean.getName()#' -->
</cfif>
</cfoutput>
