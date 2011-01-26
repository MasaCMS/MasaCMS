<cfsilent>
	<cfset arguments.hasTitle=listFindNoCase(arguments.fields,"Title")>
	<cfset arguments.hasDate=listFindNoCase(arguments.fields,"Date")>
	<cfset arguments.hasImages=listFindNoCase(arguments.fields,"Image")>
	<cfset arguments.hasSummary=listFindNoCase(arguments.fields,"Summary") and not cookie.mobileFormat>
	<cfset arguments.hasComments=listFindNoCase(arguments.fields,"Comments")>
	<cfset arguments.hasRatings=listFindNoCase(arguments.fields,"Rating")>
	<cfset arguments.hasCredits=listFindNoCase(arguments.fields,"Credits")>
	<cfset arguments.hasTags=listFindNoCase(arguments.fields,"Tags")>
	<cfset variables.rbFactory=getSite().getRBFactory()>
	<cfset addToHTMLHeadQueue("listImageStyles.cfm")>
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
			
		<cfset arguments.link=addlink(arguments.item.getValue('type'),arguments.item.getValue('filename'),arguments.item.getValue('menutitle'),arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),arguments.item.getValue('siteID'),'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())>
			
		<cfif arguments.hasComments and (arguments.item.getValue('type') eq 'Page' or showItemMeta(arguments.item.getValue('type')) or (len(arguments.item.getValue('fileID')) and showItemMeta(arguments.item.getValue('fileEXT')))) >
			<cfset arguments.commentsLink=addlink(arguments.item.getValue('type'),arguments.item.getValue('filename'),'#variables.rbFactory.getKey("list.comments")#(#application.contentGateway.getCommentCount(request.siteid,arguments.item.getValue('contentID'))#)',arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),request.siteid,'##comments',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())>
		<cfelse>
			<cfset arguments.commentsLink="">
		</cfif>
			
		<cfset arguments.hasImage=arguments.hasImages and len(arguments.item.getValue('fileID')) and showImageInList(arguments.item.getValue('fileEXT')) />
			
		<cfif arguments.hasImage>
			<cfset arguments.class=listAppend(arguments.class,"hasImage"," ")>
		</cfif>
	</cfsilent>
	<cfoutput>
	<cfif getListFormat() eq "ul">
		<li>
			<cfif arguments.hasImage>
				<cfif cookie.mobileFormat>
				<img src="#createHREFForImage(arguments.item.getValue('siteID'),arguments.item.getValue('fileID'),arguments.item.getValue('fileEXT'),'small')#"  alt="#htmlEditFormat(arguments.item.getValue('title'))#"/>	
				<cfelse>
				<a href="#createHREF(arguments.item.getValue('type'),arguments.item.getValue('filename'),arguments.item.getValue('siteID'),arguments.item.getValue('contentID'),arguments.item.getValue('target'),arguments.item.getValue('targetparams'),"",application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())#" title="#HTMLEditFormat(arguments.item.getValue('title'))#"><img src="#createHREFForImage(arguments.item.getValue('siteID'),arguments.item.getValue('fileID'),arguments.item.getValue('fileEXT'),'small')#"  alt="#htmlEditFormat(arguments.item.getValue('title'))#"/></a>	
				</cfif>
			</cfif>
			<cfif arguments.hasDate>
				<cfif arguments.type eq "Portal" and isDate(arguments.item.getValue('releaseDate'))>
				<p class="releaseDate">#LSDateFormat(arguments.item.getValue('releaseDate'),getLongDateFormat())#</dt>
				<cfelseif listFind("Search,Feed,Related",arguments.type) and arguments.item.getValue('parentType') eq 'Calendar' and isDate(arguments.item.getValue('displayStart'))>
				<p class="releaseDate"><cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>#LSDateFormat(arguments.item.getValue('displayStart'),getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),getShortDateFormat())#<cfelse>#LSDateFormat(arguments.item.getValue('displayStart'),getLongDateFormat())#</cfif></p>
				<cfelseif arguments.type eq "Calendar">
				<p class="releaseDate"><cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>#LSDateFormat(arguments.item.getValue('displayStart'),getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),getShortDateFormat())#<cfelse>#LSDateFormat(arguments.item.getValue('displayStart'),getLongDateFormat())#</cfif></p>
				<cfelseif LSisDate(arguments.item.getValue('releaseDate'))>
				<p class="releaseDate">#LSDateFormat(arguments.item.getValue('releaseDate'),getLongDateFormat())#</p>		
				</cfif>
			</cfif>
			<cfif arguments.hasTitle>
				<h3><cfif arguments.type eq "Search">#arguments.iterator.getRecordIndex()#. </cfif>#arguments.link#</h3>
			</cfif>
			
			<cfif arguments.hasSummary and len(arguments.item.getValue('summary')) and arguments.item.getValue('summary') neq "<p></p>">
				#setDynamicContent(arguments.item.getValue('summary'))#
			</cfif>
			<cfif arguments.hasCredits and len(arguments.item.getValue('credits'))>
				<p class="credits">#variables.rbFactory.getKey('list.by')# #HTMLEditFormat(arguments.item.getValue('credits'))#</p>
			</cfif>
			<cfif not cookie.mobileFormat and len(arguments.commentsLink)>
			 	<p class="comments">#arguments.commentsLink#</p>
			</cfif>
			<cfif arguments.hasTags and len(arguments.item.getValue('tags'))>
				<cfset arguments.tagLen=listLen(arguments.item.getValue('tags')) />
				<p class="tags">
					#variables.rbFactory.getKey('tagcloud.tags')#: 
					<cfif cookie.mobileFormat>
					<cfloop from="1" to="#arguments.tagLen#" index="arguments.t">
						<cfset arguments.tag=#trim(listgetAt(arguments.item.getValue('tags'),arguments.t))#>
						#arguments.tag#<cfif arguments.tagLen gt arguments.t>, </cfif>
					</cfloop>
					<cfelse>
					<cfloop from="1" to="#arguments.tagLen#" index="arguments.t">
						<cfset arguments.tag=#trim(listgetAt(arguments.item.getValue('tags'),arguments.t))#>
						<a href="?tag=#urlEncodedFormat(arguments.tag)#&newSearch=1&display=search">#arguments.tag#</a><cfif arguments.tagLen gt arguments.t>, </cfif>
					</cfloop>
					</cfif>
				</p>
			</cfif>
			<cfif arguments.hasRatings and (arguments.item.getValue('type') eq 'Page' or showItemMeta(arguments.item.getValue('type')) or (len(arguments.item.getValue('fileID')) and showItemMeta(arguments.item.getValue('fileEXT'))))>
				<p class="rating #application.raterManager.getStarText(arguments.item.getValue('rating'))#">#variables.rbFactory.getKey('list.rating')#: <span><cfif isNumeric(arguments.item.getValue('rating'))>#arguments.item.getValue('rating')# star<cfif arguments.item.getValue('rating') gt 1>s</cfif> <cfelse>Zero stars</cfif></span></p>	 	
			</cfif>
		</li>
	<cfelse>
		<dl class="clearfix<cfif arguments.class neq ''> #arguments.class#</cfif>">
			<cfif arguments.hasDate>
				<cfif arguments.type eq "Portal" and isDate(arguments.item.getValue('releaseDate'))>
				<dt class="releaseDate">#LSDateFormat(arguments.item.getValue('releaseDate'),getLongDateFormat())#</dt>
				<cfelseif listFind("Search,Feed,Related",arguments.type) and arguments.item.getValue('parentType') eq 'Calendar' and isDate(arguments.item.getValue('displayStart'))>
				<dt class="releaseDate"><cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>#LSDateFormat(arguments.item.getValue('displayStart'),getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),getShortDateFormat())#<cfelse>#LSDateFormat(arguments.item.getValue('displayStart'),getLongDateFormat())#</cfif></dt>
				<cfelseif arguments.type eq "Calendar">
				<dt class="releaseDate"><cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>#LSDateFormat(arguments.item.getValue('displayStart'),getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),getShortDateFormat())#<cfelse>#LSDateFormat(arguments.item.getValue('displayStart'),getLongDateFormat())#</cfif></dt>
				<cfelseif LSisDate(arguments.item.getValue('releaseDate'))>
				<dt class="releaseDate">#LSDateFormat(arguments.item.getValue('releaseDate'),getLongDateFormat())#</dt>		
				</cfif>
			</cfif>
			<cfif arguments.hasTitle>
				<dt><cfif arguments.type eq "Search">#arguments.iterator.getRecordIndex()#. </cfif>#arguments.link#</dt>
			</cfif>
			<cfif arguments.hasImage>
				<dd class="image">
					<a href="#createHREF(arguments.item.getValue('type'),arguments.item.getValue('filename'),arguments.item.getValue('siteID'),arguments.item.getValue('contentID'),arguments.item.getValue('target'),arguments.item.getValue('targetparams'),"",application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())#" title="#HTMLEditFormat(arguments.item.getValue('title'))#"><img src="#createHREFForImage(arguments.item.getValue('siteID'),arguments.item.getValue('fileID'),arguments.item.getValue('fileEXT'),'small')#"  alt="#htmlEditFormat(arguments.item.getValue('title'))#"/></a>
				</dd>
			</cfif>
			<cfif arguments.hasSummary and len(arguments.item.getValue('summary'))>
			 	<dd class="summary">#setDynamicContent(arguments.item.getValue('summary'))# <span class="readMore">#addlink(arguments.item.getValue('type'),arguments.item.getValue('filename'),variables.rbFactory.getKey('list.readmore'),arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),arguments.item.getValue('siteID'),'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())#</span></dd>
			</cfif>
			<cfif arguments.hasCredits and len(arguments.item.getValue('credits'))>
			 	<dd class="credits">#variables.rbFactory.getKey('list.by')# #HTMLEditFormat(arguments.item.getValue('credits'))#</dd>
			</cfif>
			<cfif len(arguments.commentsLink)>
			 	<dd class="comments">#arguments.commentsLink#</dd>
			</cfif>
			<cfif arguments.hasTags and len(arguments.item.getValue('tags'))>
				<cfset arguments.tagLen=listLen(arguments.item.getValue('tags')) />
				<dd class="tags">
					#variables.rbFactory.getKey('tagcloud.tags')#: 
					<cfloop from="1" to="#arguments.tagLen#" index="t">
					<cfset arguments.tag=#trim(listgetAt(arguments.item.getValue('tags'),t))#>
					<a href="?tag=#urlEncodedFormat(arguments.tag)#&newSearch=1&display=search">#arguments.tag#</a><cfif arguments.tagLen gt t>, </cfif>
					</cfloop>
				</dd>
			</cfif>
			<cfif arguments.hasRatings and (arguments.item.getValue('type') eq 'Page' or arguments.showItem.itemMeta(arguments.item.getValue('type')) or (len(arguments.item.getValue('fileID')) and arguments.showItem.itemMeta(arguments.item.getValue('fileEXT'))))>
			 	<dd class="rating #application.raterManager.getStarText(arguments.item.getValue('rating'))#">#variables.rbFactory.getKey('list.rating')#: <span><cfif isNumeric(arguments.item.getValue('rating'))>#arguments.item.getValue('rating')# star<cfif arguments.item.getValue('rating') gt 1>s</cfif> <cfelse>Zero stars</cfif></span></dd>	 	
			</cfif>
		</dl>
	</cfif>	
	</cfoutput>
</cfloop>

<cfif getListFormat() eq "ul">
	</ul>
</cfif>
