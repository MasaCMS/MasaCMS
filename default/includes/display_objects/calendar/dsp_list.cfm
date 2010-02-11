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
<cfset hasComments=application.contentGateway.getHasComments(event.getValue('siteid'),event.getContentBean().getContentID()) />
<cfset hasRatings=application.contentGateway.getHasRatings(event.getValue('siteid'),event.getContentBean().getContentID()) />
<cfset iterator=application.serviceFactory.getBean("contentIterator")>
<cfset iterator.setQuery(rsSection,request.contentBean.getNextN())>

<cfset event.setValue("currentNextNID",event.getContentBean().getContentID())>

<cfif not len(event.getValue("nextNID")) or event.getValue("nextNID") eq event.getValue("currentNextNID")>
	<cfif event.getContentBean().getNextN() gt 1>
		<cfset currentNextNIndex=event.getValue("startRow")>
		<cfset iterator.setStartRow(currentNextNIndex)>
	<cfelse>
		<cfset currentNextNIndex=event.getValue("pageNum")>
		<cfset iterator.setPage(currentNextNIndex)>
	</cfif>
<cfelse>	
	<cfset currentNextNIndex=1>
	<cfset iterator.setPage(1)>
</cfif>

<cfset nextN=application.utility.getNextN(rsSection,event.getContentBean().getNextN(),currentNextNIndex)>

</cfsilent>
<!---
<div id="svCalendar" class="svCalendar">
<cfoutput>
<table>
<tr>
<th title="#dateLong#" id="previousMonth"><a href="?month=#previousmonth#&year=#previousyear#&categoryID=#htmlEditFormat(request.categoryID)#&relatedID=#htmlEditFormat(request.relatedID)#&filterBy=releaseMonth">&laquo;</a></th>
<th colspan="5">#dateLong#</th>
<th id="nextMonth"><a href="?month=#nextmonth#&year=#nextyear#&categoryID=#htmlEditFormat(request.categoryID)#&relatedID=#htmlEditFormat(request.relatedID)#&filterBy=releaseMonth">&raquo;</a></th>
</tr>
</table>
</div>
</cfoutput>--->
<cfif iterator.getRecordcount()>
<div id="svPortal" class="svIndex">
		<cfloop condition="iterator.hasNext()">
		<cfsilent>
		<cfset item=iterator.next()>
		<cfset class=""/>
		<cfif not iterator.hasPrevious()> 
			<cfset class=listAppend(class,"first"," ")/> 
		</cfif>
		<cfif not iterator.hasNext()> 
			<cfset class=listAppend(class,"last"," ")/> 
		</cfif>
		
		<cfset link=addlink(item.getValue('type'),item.getValue('filename'),item.getValue('menutitle'),item.getValue('target'),item.getValue('targetparams'),item.getValue('contentID'),item.getValue('siteID'),'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())>
		
		<cfif hasComments and (item.getValue('type') eq 'Page' or showItemMeta(item.getValue('type')) or (len(item.getValue('fileID')) and showItemMeta(item.getValue('fileEXT')))) >
		<cfset commentsLink=addlink(item.getValue('type'),item.getValue('filename'),'#rbFactory.getKey("list.comments")#(#application.contentGateway.getCommentCount(request.siteid,item.getValue('contentID'))#)',item.getValue('target'),item.getValue('targetparams'),item.getValue('contentID'),request.siteid,'##comments',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())>
		<cfelse>
		<cfset commentsLink="">
		</cfif>
		
		<cfset hasImage=len(item.getValue('fileID')) and showImageInList(item.getValue('fileEXT')) />
		
		<cfif hasImage>
			<cfset class=listAppend(class,"hasImage"," ")>
		</cfif>
		
		</cfsilent>
		<cfoutput>
		<dl class="clearfix<cfif class neq ''> #class#</cfif>">
		<dt class="releaseDate"><cfif LSDateFormat(item.getValue('displayStart'),"short") lt LSDateFormat(item.getValue('displayStop'),"short")>#LSDateFormat(item.getValue('displayStart'),getShortDateFormat())# - #LSDateFormat(item.getValue('displayStop'),getShortDateFormat())#<cfelse>#LSDateFormat(item.getValue('displayStart'),getLongDateFormat())#</cfif></dt>
		<dt>#link#</dt>
		<cfif hasImage>
		<dd class="image">
			<a href="#createHREF(item.getValue('type'),item.getValue('filename'),item.getValue('siteID'),item.getValue('contentID'),item.getValue('target'),item.getValue('targetparams'),"",application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())#" title="#HTMLEditFormat(item.getValue('title'))#"><img src="#createHREFForImage(item.getValue('siteID'),item.getValue('fileID'),item.getValue('fileEXT'),'small')#"  alt="#htmlEditFormat(item.getValue('title'))#"/></a>
		</dd>
		</cfif>
	 	<cfif len(item.getValue('summary'))>
	 	<dd class="summary">#setDynamicContent(item.getValue('summary'))# <span class="readMore">#addlink(item.getValue('type'),item.getValue('filename'),rbFactory.getKey('list.readmore'),item.getValue('target'),item.getValue('targetparams'),item.getValue('contentID'),item.getValue('siteID'),'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())#</span></dd>
	 	</cfif>
	 	<cfif len(item.getValue('credits'))>
	 	<dd class="credits">#rbFactory.getKey('list.by')# #HTMLEditFormat(item.getValue('credits'))#</dd>
	 	</cfif>
	 	<cfif len(commentsLink)>
	 	<dd class="comments">#commentsLink#</dd>
	 	</cfif>
	 	<cfif len(item.getValue('tags'))>
	 	<dd class="tags"><cfmodule template="#getSite(event.getValue('siteid')).getIncludePath()#/includes/display_objects/nav/dsp_tag_line.cfm" tags="#item.getValue('tags')#"></dd>
	 	</cfif>
	 	<cfif hasRatings and (item.getValue('type') eq 'Page' or showItemMeta(item.getValue('type')) or (len(item.getValue('fileID')) and showItemMeta(item.getValue('fileEXT'))))>
		<!--- rating#replace(rateBean.getRate(),".","")# --->
	 	<dd class="rating #application.raterManager.getStarText(item.getValue('rating'))#">#rbFactory.getKey('list.rating')#: <span><cfif isNumeric(item.getValue('rating'))>#item.getValue('rating')# star<cfif item.getValue('rating') gt 1>s</cfif> <cfelse>Zero stars</cfif></span></dd>	 	
	 	</cfif>
	 	</dl>
	 	</cfoutput>
	 	</cfloop>
	
	<cfif nextn.numberofpages gt 1>
		<cfoutput>#dspObject_Include(thefile='dsp_nextN.cfm')#</cfoutput>
	</cfif>	
</div>
</cfif>

<cfif not iterator.getRecordCount()>
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
       <cfelse>
            <div id="svPortal">
            <p>#rbFactory.getKey('list.nocontent')#</p>   
            </div>
       </cfif>
       </cfoutput>
</cfif>
	
