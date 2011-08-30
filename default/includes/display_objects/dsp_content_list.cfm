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

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfsilent>
	<cfset $.addToHTMLHeadQueue("listImageStyles.cfm")>
	
	<cfif not structKeyExists(arguments,"type")>
		<cfset arguments.type="Feed">
	</cfif>
	
	<cfif not structKeyExists(arguments,"fields")>
		<cfset arguments.fields="Title,Summary,Date,Image,Tags,Credits">
	</cfif>
	
	<cfset arguments.hasTitle=listFindNoCase(arguments.fields,"Title")>
	<cfset arguments.hasDate=listFindNoCase(arguments.fields,"Date")>
	<cfset arguments.hasImages=listFindNoCase(arguments.fields,"Image")>
	<cfset arguments.hasSummary=listFindNoCase(arguments.fields,"Summary") and not cookie.mobileFormat>
	<cfset arguments.hasComments=listFindNoCase(arguments.fields,"Comments")>
	<cfset arguments.hasRatings=listFindNoCase(arguments.fields,"Rating")>
	<cfset arguments.hasCredits=listFindNoCase(arguments.fields,"Credits")>
	<cfset arguments.hasTags=listFindNoCase(arguments.fields,"Tags")>
	
	<cfif arguments.hasImages>
		<cfset arguments.imageURLArgs=structNew()>
		<cfset arguments.imageURLArgs.size="small">
		
		<cfif structKeyExists(arguments,"imageSize")>
			<cfset arguments.imageURLArgs.size=arguments.imageSize>
		<cfelse>
			<cfif structKeyExists(arguments,"imageWidth") or structKeyExists(arguments,"imageHeight")>
				<cfif structKeyExists(arguments,"imageWidth")>
					<cfset arguments.imageURLArgs.width=arguments.imageWidth>
				<cfelse>
					<cfset arguments.imageURLArgs.width="auto">
				</cfif>
				<cfif structKeyExists(arguments,"imageHeight")>
					<cfset arguments.imageURLArgs.height=arguments.imageHeight>
				<cfelse>
					<cfset arguments.imageURLArgs.height="auto">
				</cfif>
				<cfif arguments.imageURLArgs.height eq "auto" 
					and arguments.imageURLArgs.width eq "auto">
					<cfset arguments.imageURLArgs=structNew()>
					<cfset arguments.imageURLArgs.size="small">
				</cfif>
			</cfif>
		</cfif>
	</cfif>
	
	
	<cfset $.addToHTMLHeadQueue("listImageStyles.cfm")>
</cfsilent>
<cfif getListFormat() eq "ul">
	<ul>
</cfif>
<cfloop condition="arguments.iterator.hasNext()">
	<cfsilent>
		<cfset arguments.item=arguments.iterator.next()>
		<cfset arguments.class=""/>
		
		<cfif not arguments.iterator.hasPrevious()> 
			<cfset arguments.class=listAppend(arguments.class,"first"," ")/> 
		</cfif>
		
		<cfif not arguments.iterator.hasNext()> 
			<cfset arguments.class=listAppend(arguments.class,"last"," ")/> 
		</cfif>
			
		<cfset arguments.link=$.addLink(arguments.item.getValue('type'),arguments.item.getValue('filename'),arguments.item.getValue('menutitle'),arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),arguments.item.getValue('siteID'),'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())>
			
		<cfif arguments.hasComments and (arguments.item.getValue('type') eq 'Page' or showItemMeta(arguments.item.getValue('type')) or (len(arguments.item.getValue('fileID')) and showItemMeta(arguments.item.getValue('fileEXT')))) >
			<cfset arguments.commentsLink=$.addLink(arguments.item.getValue('type'),arguments.item.getValue('filename'),'#$.rbKey("list.comments")#(#application.contentGateway.getCommentCount(request.siteid,arguments.item.getValue('contentID'))#)',arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),request.siteid,'##comments',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())>
		<cfelse>
			<cfset arguments.commentsLink="">
		</cfif>
			
		<cfset arguments.hasImage=arguments.hasImages and len(arguments.item.getValue('fileID')) and showImageInList(arguments.item.getValue('fileEXT')) />
			
		<cfif arguments.hasImage>
			<cfset arguments.class=listAppend(arguments.class,"hasImage"," ")>
		</cfif>
	</cfsilent>
	<cfoutput>
	<cfif $.getListFormat() eq "ul">
		<li>
			<cfif arguments.hasImage>
				<cfif cookie.mobileFormat>
				<img src="#arguments.item.getImageURL(argumentCollection=arguments.imageURLArgs)#"  alt="#htmlEditFormat(arguments.item.getValue('title'))#"/>	
				<cfelse>
				<a href="#arguments.item.getURL()#" title="#HTMLEditFormat(arguments.item.getValue('title'))#"><img src="#arguments.item.getImageURL(argumentCollection=arguments.imageURLArgs)#"  alt="#htmlEditFormat(arguments.item.getValue('title'))#"/></a>	
				</cfif>
			</cfif>
			<cfif arguments.hasDate>
				<cfif arguments.type eq "Portal" and isDate(arguments.item.getValue('releaseDate'))>
				<p class="releaseDate">#LSDateFormat(arguments.item.getValue('releaseDate'),$.getLongDateFormat())#</dt>
				<cfelseif listFind("Search,Feed,Related",arguments.type) and arguments.item.getValue('parentType') eq 'Calendar' and isDate(arguments.item.getValue('displayStart'))>
				<p class="releaseDate"><cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>#LSDateFormat(arguments.item.getValue('displayStart'),$.getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),$.getShortDateFormat())#<cfelse>#LSDateFormat(arguments.item.getValue('displayStart'),$.getLongDateFormat())#</cfif></p>
				<cfelseif arguments.type eq "Calendar">
				<p class="releaseDate"><cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>#LSDateFormat(arguments.item.getValue('displayStart'),$.getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),$.getShortDateFormat())#<cfelse>#LSDateFormat(arguments.item.getValue('displayStart'),$.getLongDateFormat())#</cfif></p>
				<cfelseif LSisDate(arguments.item.getValue('releaseDate'))>
				<p class="releaseDate">#LSDateFormat(arguments.item.getValue('releaseDate'),$.getLongDateFormat())#</p>		
				</cfif>
			</cfif>
			<cfif arguments.hasTitle>
				<h3><cfif arguments.type eq "Search">#arguments.iterator.getRecordIndex()#. </cfif>#arguments.link#</h3>
			</cfif>
			
			<cfif arguments.hasSummary and len(arguments.item.getValue('summary')) and arguments.item.getValue('summary') neq "<p></p>">
				#$.setDynamicContent(arguments.item.getValue('summary'))#
			</cfif>
			<cfif arguments.hasCredits and len(arguments.item.getValue('credits'))>
				<p class="credits">#$.rbKey('list.by')# #HTMLEditFormat(arguments.item.getValue('credits'))#</p>
			</cfif>
			<cfif not cookie.mobileFormat and len(arguments.commentsLink)>
			 	<p class="comments">#arguments.commentsLink#</p>
			</cfif>
			<cfif arguments.hasTags and len(arguments.item.getValue('tags'))>
				<cfset arguments.tagLen=listLen(arguments.item.getValue('tags')) />
				<p class="tags">
					#$.rbKey('tagcloud.tags')#: 
					<cfif cookie.mobileFormat>
					<cfloop from="1" to="#arguments.tagLen#" index="arguments.t">
						<cfset arguments.tag=#trim(listgetAt(arguments.item.getValue('tags'),arguments.t))#>
						#arguments.tag#<cfif arguments.tagLen gt arguments.t>, </cfif>
					</cfloop>
					<cfelse>
					<cfloop from="1" to="#arguments.tagLen#" index="arguments.t">
						<cfset arguments.tag=#trim(listgetAt(arguments.item.getValue('tags'),arguments.t))#>
						<a href="#$.createHREF(filename='#$.event('currentFilenameAdjusted')#/tag/#urlEncodedFormat(arguments.tag)#')#">#arguments.tag#</a><cfif arguments.tagLen gt arguments.t>, </cfif>
					</cfloop>
					</cfif>
				</p>
			</cfif>
			<cfif arguments.hasRatings and (arguments.item.getValue('type') eq 'Page' or showItemMeta(arguments.item.getValue('type')) or (len(arguments.item.getValue('fileID')) and showItemMeta(arguments.item.getValue('fileEXT'))))>
				<p class="rating #application.raterManager.getStarText(arguments.item.getValue('rating'))#">#$.rbKey('list.rating')#: <span><cfif isNumeric(arguments.item.getValue('rating'))>#arguments.item.getValue('rating')# star<cfif arguments.item.getValue('rating') gt 1>s</cfif> <cfelse>Zero stars</cfif></span></p>	 	
			</cfif>
		</li>
	<cfelse>
		<dl class="clearfix<cfif arguments.class neq ''> #arguments.class#</cfif>">
			<cfif arguments.hasDate>
				<cfif arguments.type eq "Portal" and isDate(arguments.item.getValue('releaseDate'))>
				<dt class="releaseDate">#LSDateFormat(arguments.item.getValue('releaseDate'),$.getLongDateFormat())#</dt>
				<cfelseif listFind("Search,Feed,Related",arguments.type) and arguments.item.getValue('parentType') eq 'Calendar' and isDate(arguments.item.getValue('displayStart'))>
				<dt class="releaseDate"><cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>#LSDateFormat(arguments.item.getValue('displayStart'),$.getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),$.getShortDateFormat())#<cfelse>#LSDateFormat(arguments.item.getValue('displayStart'),$.getLongDateFormat())#</cfif></dt>
				<cfelseif arguments.type eq "Calendar">
				<dt class="releaseDate"><cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>#LSDateFormat(arguments.item.getValue('displayStart'),$.getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),$.getShortDateFormat())#<cfelse>#LSDateFormat(arguments.item.getValue('displayStart'),$.getLongDateFormat())#</cfif></dt>
				<cfelseif LSisDate(arguments.item.getValue('releaseDate'))>
				<dt class="releaseDate">#LSDateFormat(arguments.item.getValue('releaseDate'),$.getLongDateFormat())#</dt>		
				</cfif>
			</cfif>
			<cfif arguments.hasTitle>
				<dt><cfif arguments.type eq "Search">#arguments.iterator.getRecordIndex()#. </cfif>#arguments.link#</dt>
			</cfif>
			<cfif arguments.hasImage>
				<dd class="image">
					<a href="#arguments.item.getURL()#" title="#HTMLEditFormat(arguments.item.getValue('title'))#"><img src="#arguments.item.getImageURL(argumentCollection=arguments.imageURLArgs)#"  alt="#htmlEditFormat(arguments.item.getValue('title'))#"/></a>
				</dd>
			</cfif>
			<cfif arguments.hasSummary and len(arguments.item.getValue('summary')) and arguments.item.getValue('summary') neq "<p></p>">
			 	<dd class="summary">#$.setDynamicContent(arguments.item.getValue('summary'))# <span class="readMore">#$.addLink(arguments.item.getValue('type'),arguments.item.getValue('filename'),$.rbKey('list.readmore'),arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),arguments.item.getValue('siteID'),'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())#</span></dd>
			</cfif>
			<cfif arguments.hasCredits and len(arguments.item.getValue('credits'))>
			 	<dd class="credits">#$.rbKey('list.by')# #HTMLEditFormat(arguments.item.getValue('credits'))#</dd>
			</cfif>
			<cfif len(arguments.commentsLink)>
			 	<dd class="comments">#arguments.commentsLink#</dd>
			</cfif>
			<cfif arguments.hasTags and len(arguments.item.getValue('tags'))>
				<cfset arguments.tagLen=listLen(arguments.item.getValue('tags')) />
				<dd class="tags">
					#$.rbKey('tagcloud.tags')#: 
					<cfloop from="1" to="#arguments.tagLen#" index="t">
					<cfset arguments.tag=#trim(listgetAt(arguments.item.getValue('tags'),t))#>
					<a href="#$.createHREF(filename='#$.event('currentFilenameAdjusted')#/tag/#urlEncodedFormat(arguments.tag)#')#">#arguments.tag#</a><cfif arguments.tagLen gt t>, </cfif>
					</cfloop>
				</dd>
			</cfif>
			<cfif arguments.hasRatings and (arguments.item.getValue('type') eq 'Page' or showItemMeta(arguments.item.getValue('type')) or (len(arguments.item.getValue('fileID')) and showItemMeta(arguments.item.getValue('fileEXT'))))>
			 	<dd class="rating #application.raterManager.getStarText(arguments.item.getValue('rating'))#">#$.rbKey('list.rating')#: <span><cfif isNumeric(arguments.item.getValue('rating'))>#arguments.item.getValue('rating')# star<cfif arguments.item.getValue('rating') gt 1>s</cfif> <cfelse>Zero stars</cfif></span></dd>	 	
			</cfif>
		</dl>
	</cfif>	
	</cfoutput>
</cfloop>

<cfif getListFormat() eq "ul">
	</ul>
</cfif>
