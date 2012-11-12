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
	<cfif not structKeyExists(arguments,"type")>
		<cfset arguments.type="Feed">
	</cfif>
	
	<cfif not structKeyExists(arguments,"fields")>
		<cfset arguments.fields="Date,Title,Image,Summary,Credits,Tags">
	</cfif>
	
	<cfset arguments.hasImages=listFindNoCase(arguments.fields,"Image")>
	
	<cfif arguments.hasImages>
		<cfset arguments.isCustomImage= false />	

		<cfif not structKeyExists(arguments,"imageSize") or variables.$.event("muraMobileRequest")>
			<cfset arguments.imageSize="small">		
		<cfelseif not listFindNoCase('small,medium,large,custom',arguments.imagesize)>
			<cfset arguments.customImageSize=getBean('imageSize').loadBy(name=arguments.imageSize,siteID=variables.$.event('siteID'))>
			<cfset arguments.imageWidth= arguments.customImageSize.getWidth() />
			<cfset arguments.imageHeight= arguments.customImageSize.getHeight() />
			<cfset arguments.isCustomImage= true />	
		</cfif>

		<cfif not structKeyExists(arguments,"imageHeight")>
			<cfset arguments.imageHeight="auto">
		</cfif>
		<cfif not structKeyExists(arguments,"imageWidth")>
			<cfset arguments.imageWidth="auto">
		</cfif>
		
		<cfif not structKeyExists(arguments,"imagePadding")>
			<cfset arguments.imagePadding=20>
		</cfif>

		<cfif arguments.isCustomImage>
			<cfset arguments.imageStyles='style="#variables.$.generateListImageSyles(size='custom',width=arguments.imageWidth,height=arguments.imageHeight,padding=arguments.imagePadding)#"'>
		<cfelse>
			<cfset arguments.imageStyles='style="#variables.$.generateListImageSyles(size=arguments.imageSize,width=arguments.imageWidth,height=arguments.imageHeight,padding=arguments.imagePadding)#"'>
		</cfif>
	</cfif>
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
			
		<cfset arguments.hasImage=arguments.hasImages and len(arguments.item.getValue('fileID')) and showImageInList(arguments.item.getValue('fileEXT')) />
			
		<cfif arguments.hasImage>
			<cfset arguments.class=listAppend(arguments.class,"hasImage"," ")>
		</cfif>
	</cfsilent>
	<cfoutput>
	<!---  UL MARKUP -------------------------------------------------------------------------- --->
	<cfif variables.$.getListFormat() eq "ul">
		<li<cfif not variables.$.event("muraMobileRequest")> class="clearfix<cfif arguments.class neq ''> #arguments.class#</cfif>" <cfif arguments.hasImage>#arguments.imageStyles#</cfif></cfif>>
			<cfloop list="#arguments.fields#" index="arguments.field">
				<cfset arguments.field=trim(arguments.field)>
				<cfswitch expression="#arguments.field#">
					<cfcase value="Image">
						<cfif arguments.hasImage>
							<cfif $.event('muraMobileRequest')>
							<!---<div class="image">---><img src="#arguments.item.getImageURL(size=arguments.imageSize,width=arguments.imageWidth,height=arguments.imageHeight)#"  alt="#htmlEditFormat(arguments.item.getValue('title'))#"/><!---</div>--->
							<cfelse>
							<a class="image thumbnail" href="#arguments.item.getURL()#" title="#HTMLEditFormat(arguments.item.getValue('title'))#"><img src="#arguments.item.getImageURL(size=arguments.imageSize,width=arguments.imageWidth,height=arguments.imageHeight)#"  alt="#htmlEditFormat(arguments.item.getValue('title'))#"/></a>	
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="Date">
						<cfif arguments.type eq "Portal" and isDate(arguments.item.getValue('releaseDate'))>
						<p class="releaseDate">#LSDateFormat(arguments.item.getValue('releaseDate'),variables.$.getLongDateFormat())#</dt>
						<cfelseif listFind("Search,Feed,Related",arguments.type) and arguments.item.getValue('parentType') eq 'Calendar' and isDate(arguments.item.getValue('displayStart'))>
						<p class="releaseDate"><cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>#LSDateFormat(arguments.item.getValue('displayStart'),variables.$.getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),variables.$.getShortDateFormat())#<cfelse>#LSDateFormat(arguments.item.getValue('displayStart'),variables.$.getLongDateFormat())#</cfif></p>
						<cfelseif arguments.type eq "Calendar">
						<p class="releaseDate"><cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>#LSDateFormat(arguments.item.getValue('displayStart'),variables.$.getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),variables.$.getShortDateFormat())#<cfelse>#LSDateFormat(arguments.item.getValue('displayStart'),variables.$.getLongDateFormat())#</cfif></p>
						<cfelseif LSisDate(arguments.item.getValue('releaseDate'))>
						<p class="releaseDate">#LSDateFormat(arguments.item.getValue('releaseDate'),variables.$.getLongDateFormat())#</p>		
						</cfif>
					</cfcase>
					<cfcase value="Title">
						<h3><cfif arguments.type eq "Search">#arguments.iterator.getRecordIndex()#. </cfif>#addlink(arguments.item.getValue('type'),arguments.item.getValue('filename'),arguments.item.getValue('menutitle'),arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),arguments.item.getValue('siteID'))#</h3>
					</cfcase>
					<cfcase value="Summary">
						<cfif len(arguments.item.getValue('summary')) and arguments.item.getValue('summary') neq "<p></p>">
							<!---<div class="summary">--->#variables.$.setDynamicContent(arguments.item.getValue('summary'))#<!---</div>--->
						</cfif>
					</cfcase>
					<cfcase value="Body">
						<cfif not listFindNoCase('File,Link',arguments.item.getValue('type'))>
							<cfif len(arguments.item.getValue('body')) and arguments.item.getValue('body') neq "<p></p>">
								<!---<div class="summary">--->#variables.$.setDynamicContent(arguments.item.getValue('summary'))#<!---</div>--->
							</cfif>
						<cfelse>
							<cfif len(arguments.item.getValue('summary')) and arguments.item.getValue('summary') neq "<p></p>">
								<!---<div class="summary">--->#variables.$.setDynamicContent(arguments.item.getValue('summary'))#<!---</div>--->
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="ReadMore">
					 	<p class="readMore">#variables.$.addLink(arguments.item.getValue('type'),arguments.item.getValue('filename'),variables.$.rbKey('list.readmore'),arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),arguments.item.getValue('siteID'),'',variables.$.globalConfig('context'),variables.$.globalConfig('stub'),variables.$.globalConfig('indexFile'))#</p>
					</cfcase>
					<cfcase value="Credits">
						<cfif len(arguments.item.getValue('credits'))>
							<p class="credits">#variables.$.rbKey('list.by')# #HTMLEditFormat(arguments.item.getValue('credits'))#</p>
						</cfif>
					</cfcase>
					<cfcase value="Comments">
						<cfif (arguments.item.getValue('type') eq 'Page' or showItemMeta(arguments.item.getValue('type')) or (len(arguments.item.getValue('fileID')) and showItemMeta(arguments.item.getValue('fileEXT')))) >
							<cfif not $.event('muraMobileRequest')>
							 	<p class="comments">#variables.$.addLink(arguments.item.getValue('type'),arguments.item.getValue('filename'),'#variables.$.rbKey("list.comments")#(#variables.$.getBean('contentGateway').getCommentCount(variables.$.event('siteID'),arguments.item.getValue('contentID'))#)',arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),variables.$.event('siteID'),'##comments')#</p>
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="Tags">
						<cfif len(arguments.item.getValue('tags'))>
							<cfset arguments.tagLen=listLen(arguments.item.getValue('tags')) />
							<p class="tags">
								#variables.$.rbKey('tagcloud.tags')#: 
								<cfif $.event('muraMobileRequest')>
								<cfloop from="1" to="#arguments.tagLen#" index="arguments.t">
									<cfset arguments.tag=#trim(listgetAt(arguments.item.getValue('tags'),arguments.t))#>
									#arguments.tag#<cfif arguments.tagLen gt arguments.t>, </cfif>
								</cfloop>
								<cfelse>
								<cfloop from="1" to="#arguments.tagLen#" index="arguments.t">
									<cfset arguments.tag=#trim(listgetAt(arguments.item.getValue('tags'),arguments.t))#>
									<a href="#variables.$.createHREF(filename='#variables.$.event('currentFilenameAdjusted')#/tag/#urlEncodedFormat(arguments.tag)#')#">#HTMLEditFormat(arguments.tag)#</a><cfif arguments.tagLen gt arguments.t>, </cfif>
								</cfloop>
								</cfif>
							</p>
						</cfif>
					</cfcase>
					<cfcase value="Rating">
						<cfif (arguments.item.getValue('type') eq 'Page' or showItemMeta(arguments.item.getValue('type')) or (len(arguments.item.getValue('fileID')) and showItemMeta(arguments.item.getValue('fileEXT'))))>
							<p class="rating #application.raterManager.getStarText(arguments.item.getValue('rating'))#">#variables.$.rbKey('list.rating')#: <span><cfif isNumeric(arguments.item.getValue('rating'))>#arguments.item.getValue('rating')# star<cfif arguments.item.getValue('rating') gt 1>s</cfif> <cfelse>Zero stars</cfif></span></p>	 	
						</cfif>
					</cfcase>
					<cfdefaultcase>
						<cfif len(arguments.item.getValue(arguments.field))>
						 	<p class="sys#uCase(left(arguments.field,1))##iif(len(arguments.field) gt 1,de('#right(arguments.field,len(arguments.field)-1)#'),de(''))#">#HTMLEditFormat(arguments.item.getValue(arguments.field))#</p>	 	
						</cfif>
					</cfdefaultcase>
				</cfswitch>
			</cfloop>
		</li>
	<cfelse>
	<!---  DL MARKUP -------------------------------------------------------------------------- --->
		<dl class="clearfix<cfif arguments.class neq ''> #arguments.class#</cfif>"<cfif arguments.hasImage> #arguments.imageStyles#</cfif>>
			<cfloop list="#arguments.fields#" index="arguments.field">
				<cfset arguments.field=trim(arguments.field)>
				<cfswitch expression="#arguments.field#">
					<cfcase value="Date">
						<cfif arguments.type eq "Portal" and isDate(arguments.item.getValue('releaseDate'))>
						<dt class="releaseDate">#LSDateFormat(arguments.item.getValue('releaseDate'),variables.$.getLongDateFormat())#</dt>
						<cfelseif listFind("Search,Feed,Related",arguments.type) and arguments.item.getValue('parentType') eq 'Calendar' and isDate(arguments.item.getValue('displayStart'))>
						<dt class="releaseDate"><cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>#LSDateFormat(arguments.item.getValue('displayStart'),variables.$.getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),variables.$.getShortDateFormat())#<cfelse>#LSDateFormat(arguments.item.getValue('displayStart'),variables.$.getLongDateFormat())#</cfif></dt>
						<cfelseif arguments.type eq "Calendar">
						<dt class="releaseDate"><cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>#LSDateFormat(arguments.item.getValue('displayStart'),variables.$.getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),variables.$.getShortDateFormat())#<cfelse>#LSDateFormat(arguments.item.getValue('displayStart'),variables.$.getLongDateFormat())#</cfif></dt>
						<cfelseif LSisDate(arguments.item.getValue('releaseDate'))>
						<dt class="releaseDate">#LSDateFormat(arguments.item.getValue('releaseDate'),variables.$.getLongDateFormat())#</dt>		
						</cfif>
					</cfcase>
					<cfcase value="Title">
						<dt class="title"><cfif arguments.type eq "Search">#arguments.iterator.getRecordIndex()#. </cfif>#variables.$.addLink(arguments.item.getValue('type'),arguments.item.getValue('filename'),arguments.item.getValue('menutitle'),arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),arguments.item.getValue('siteID'),'',variables.$.globalConfig('context'),variables.$.globalConfig('stub'),variables.$.globalConfig('indexFile'))#</dt>
					</cfcase>
					<cfcase value="Image">
						<cfif arguments.hasImage>
						<dd class="image">
							<a href="#arguments.item.getURL()#" title="#HTMLEditFormat(arguments.item.getValue('title'))#" class="thumbnail"><img src="#arguments.item.getImageURL(size=arguments.imageSize,width=arguments.imageWidth,height=arguments.imageHeight)#"  alt="#htmlEditFormat(arguments.item.getValue('title'))#"/></a>
						</dd>
						</cfif>
					</cfcase>
					<cfcase value="Summary">
						<cfif len(arguments.item.getValue('summary')) and arguments.item.getValue('summary') neq "<p></p>">
						 	<dd class="summary">#variables.$.setDynamicContent(arguments.item.getValue('summary'))#</dd>
						</cfif>
					</cfcase>
					<cfcase value="Body">
						<cfif not listFindNoCase('File,Link',arguments.item.getValue('type'))>
							<cfif len(arguments.item.getValue('body')) and arguments.item.getValue('body') neq "<p></p>">
						 		<dd class="body">#variables.$.setDynamicContent(arguments.item.getValue('body'))#</dd>
							 </cfif>
						<cfelse>
							 <cfif len(arguments.item.getValue('summary')) and arguments.item.getValue('summary') neq "<p></p>">
						 		<dd class="body">#variables.$.setDynamicContent(arguments.item.getValue('summary'))#</dd>
						 	</cfif>
						</cfif>
					</cfcase>
					<cfcase value="ReadMore">
					 	<dd class="readMore">#variables.$.addLink(arguments.item.getValue('type'),arguments.item.getValue('filename'),variables.$.rbKey('list.readmore'),arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),arguments.item.getValue('siteID'),'',variables.$.globalConfig('context'),variables.$.globalConfig('stub'),variables.$.globalConfig('indexFile'))#</dd>
					</cfcase>
					<cfcase value="Credits">
						<cfif len(arguments.item.getValue('credits'))>
						 	<dd class="credits">#variables.$.rbKey('list.by')# #HTMLEditFormat(arguments.item.getValue('credits'))#</dd>
						</cfif>
					</cfcase>
					<cfcase value="Comments">
						<cfif (arguments.item.getValue('type') eq 'Page' or showItemMeta(arguments.item.getValue('type')) or (len(arguments.item.getValue('fileID')) and showItemMeta(arguments.item.getValue('fileEXT')))) >
						 	<dd class="comments">#variables.$.addLink(arguments.item.getValue('type'),arguments.item.getValue('filename'),'#variables.$.rbKey("list.comments")#(#variables.$.getBean('contentGateway').getCommentCount(variables.$.event('siteID'),arguments.item.getValue('contentID'))#)',arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),variables.$.event('siteID'),'##comments')#</dd>
						</cfif>
					</cfcase>
					<cfcase value="Tags">
						<cfif len(arguments.item.getValue('tags'))>
							<cfset arguments.tagLen=listLen(arguments.item.getValue('tags')) />
							<dd class="tags">
								#variables.$.rbKey('tagcloud.tags')#: 
								<cfloop from="1" to="#arguments.tagLen#" index="t">
								<cfset arguments.tag=#trim(listgetAt(arguments.item.getValue('tags'),t))#>
								<a href="#variables.$.createHREF(filename='#variables.$.event('currentFilenameAdjusted')#/tag/#urlEncodedFormat(arguments.tag)#')#">#HTMLEditFormat(arguments.tag)#</a><cfif arguments.tagLen gt t>, </cfif>
								</cfloop>
							</dd>
						</cfif>
					</cfcase>
					<cfcase value="Rating">
						<cfif (arguments.item.getValue('type') eq 'Page' or showItemMeta(arguments.item.getValue('type')) or (len(arguments.item.getValue('fileID')) and showItemMeta(arguments.item.getValue('fileEXT'))))>
						 	<dd class="rating #application.raterManager.getStarText(arguments.item.getValue('rating'))#">#variables.$.rbKey('list.rating')#: <span><cfif isNumeric(arguments.item.getValue('rating'))>#arguments.item.getValue('rating')# star<cfif arguments.item.getValue('rating') gt 1>s</cfif> <cfelse>Zero stars</cfif></span></dd>	 	
						</cfif>
					</cfcase>
					<cfdefaultcase>
						<cfif len(arguments.item.getValue(arguments.field))>
						 	<dd class="sys#uCase(left(arguments.field,1))##iif(len(arguments.field) gt 1,de('#right(arguments.field,len(arguments.field)-1)#'),de(''))#">#HTMLEditFormat(arguments.item.getValue(arguments.field))#</dd>	 	
						</cfif>
					</cfdefaultcase>
				</cfswitch>
			</cfloop>
		</dl>
	</cfif>	
	</cfoutput>
</cfloop>

<cfif getListFormat() eq "ul">
	</ul>
</cfif>
