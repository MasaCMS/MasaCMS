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
	<!---<cfset addToHTMLHeadQueue("prototype.cfm")>
	<cfset addToHTMLHeadQueue("scriptaculous.cfm")>
	<cfset addToHTMLHeadQueue("shadowbox-prototype.cfm")>
	<cfset addToHTMLHeadQueue("shadowbox.cfm")>--->
	<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rsSection">select contentid,filename,menutitle,target,restricted,restrictgroups,type,sortBy,sortDirection from tcontent where siteid='#request.siteid#' and contentid='#arguments.objectid#' and approved=1 and active=1 and display=1</cfquery>
	<cfif rsSection.recordcount>
	<cfset menutype=iif(rsSection.type eq 'Portal',de('default'),de('calendar_features'))/>
	<cfset rsPreFeatures=application.contentGateway.getkids('00000000000000000000000000000000000','#request.siteid#','#arguments.objectid#',menutype,now(),0,"",0,iif(rsSection.type eq 'Portal',de('#rsSection.sortBy#'),de('displaystart')),iif(rsSection.type eq 'Portal',de('#rsSection.sortDirection#'),de('desc')),'','#request.contentBean.getcontentID()#')>
		<cfif getSite().getExtranet() eq 1 and request.r.restrict eq 1>
			<cfset rsFeatures=queryPermFilter(rsPreFeatures)/>
		<cfelse>
			<cfset rsFeatures=rsPreFeatures/>
		</cfif>
	</cfif>
</cfsilent>
<cfoutput>
<cfif rsSection.recordcount and rsFeatures.recordcount>
<cfsilent>
	<cfset hasComments=application.contentGateway.getHasComments(request.siteid,arguments.objectid) />
	<cfparam name="hasSummary" default="true"/>
	<cfset cssID=createCSSID(rsSection.menuTitle)>
</cfsilent>
<div id="#cssID#" class="svRelSecContent">
<h3>#rsSection.menutitle#</h3>
<cfloop query="rsFeatures">
		<cfsilent>
			<cfset class=iif(rsFeatures.currentrow eq 1,de('first'),de(iif(rsFeatures.currentrow eq rsFeatures.recordcount,de('last'),de(''))))>
			<cfset hasImage=len(rsFeatures.fileID) and listFindNoCase("jpg,jpeg,png",rsFeatures.fileExt) />
			
			<cfif hasImage>
				<cfset class=listAppend(class,"hasImage"," ")>
			</cfif>
			
			<cfset link=addlink('#rsFeatures.type#','#rsFeatures.filename#','#rsFeatures.menutitle#','#rsFeatures.target#','#rsFeatures.targetParams#','#rsFeatures.contentid#','#request.siteid#','','#application.configBean.getContext()#','#application.configBean.getStub()#','#application.configBean.getIndexFile()#')>
			<cfif rsFeatures.type eq 'Page' and hasComments>
				<cfset commentsLink=addlink('#rsFeatures.type#','#rsFeatures.filename#','Comments(#application.contentGateway.getCommentCount(request.siteid,rsFeatures.contentid)#)','#rsFeatures.target#','#rsFeatures.targetParams#','#rsFeatures.contentid#','#request.siteid#','##comments','#application.configBean.getContext()#','#application.configBean.getStub()#','#application.configBean.getIndexFile()#')>
			</cfif>
		</cfsilent>
		<dl<cfif class neq ''> class="#class#"</cfif>>
		<cfif isDate(rsFeatures.releasedate) or menutype eq 'calendar_features'>
		  <dt class="releaseDate"><cfif menutype neq 'calendar_features'>#LSDateFormat(rsFeatures.releasedate,getLongDateFormat())#<cfelse><cfif LSDateFormat(rsFeatures.displaystart,"short") lt LSDateFormat(rsFeatures.displaystop,"short")>#LSDateFormat(rsFeatures.displaystart,getShortDateFormat())#  - #LSDateFormat(rsFeatures.displaystop,getShortDateFormat())#<cfelse>#LSDateFormat(rsFeatures.displaystart,getLongDateFormat())#</cfif></cfif></dt>
		</cfif>
		<dt>#link#</dt>
		<cfif hasImage>
				<dd class="image">
					<!---<a href="#application.configBean.getContext()#/tasks/render/file/index.cfm?fileID=#rsFeatures.FileID#&ext=.#rsFeatures.fileExt#" title="#HTMLEditFormat(rsFeatures.title)#" rel="shadowbox[#cssID#]">---><img src="#application.configBean.getContext()#/tasks/render/small/index.cfm?fileid=#rsFeatures.fileid#"/><!---</a>--->
				</dd>
		</cfif>
		<cfif hasSummary or (rsFeatures.type eq 'Page' and  hasComments)><dd>#rsFeatures.summary#<cfif hasComments><ul class="navComment"><li>#commentsLink#</li></ul></cfif></dd></cfif>
		</dl>
		</cfloop>
		<dl class="moreResults">
		<dt>&raquo; <a href="#application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(request.siteid,rsSection.filename)#">View All</a></dt></dl>
</div>
<cfelse>
	<!-- Empty Related Section Content '#rsSection.menutitle#' -->
</cfif>
</cfoutput>