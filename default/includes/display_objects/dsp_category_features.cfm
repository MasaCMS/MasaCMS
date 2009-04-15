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
