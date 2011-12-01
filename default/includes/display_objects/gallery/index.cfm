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
	<!--- the js is not loaded in contentRenderer.dspBody() to prevent caching --->
	<cfset hasComments=$.getBean('contentGateway').getHasComments($.event('siteID'),$.content('contentHistID')) />
	<cfset hasRatings=$.getBean('contentGateway').getHasRatings($.event('siteID'),$.content('contentHistID')) />
	
	<cfif not isNumeric($.event('month'))>
		<cfset $.event('month',month(now()))>
	</cfif>
	
	<cfif not isNumeric($.event('year'))>
		<cfset $.event('year',year(now()))>
	</cfif>
	
	<cfif isNumeric($.event('day')) and $.event('day')
		and $.event('filterBy') eq "releaseDate">
		<cfset menuType="releaseDate">
		<cfset menuDate=createDate($.event('year'),$.event('month'),$.event('day'))>
	<cfelseif $.event('filter') eq "releaseMonth">
		<cfset menuType="releaseMonth">
		<cfset menuDate=createDate($.event('year'),$.event('month'),1)>
	<cfelse>
		<cfset menuDate=now()>
		<cfset menuType="default">
	</cfif>
	
	<cfset rsPreSection=$.getBean('contentGateway').getKids('00000000000000000000000000000000000',$.event('siteID'),$.content('contentID'),menutype,menuDate,0,$.event('keywords'),0,$.content('sortBy'),$.content('sortDirection'),$.event('categoryID'),$.event('relatedID'),$.event('tag'))>
	<cfif $.siteConfig('extranet') eq 1 and $.event('r').restrict eq 1>
		<cfset rssection=$.queryPermFilter(rsPreSection)/>
	<cfelse>
		<cfset rssection=rsPreSection/>
	</cfif>
	
	<cfset iterator=$.getBean("contentIterator")>
	<cfset iterator.setQuery(rsSection,event.getContentBean().getNextN())>
	
	<cfset imageArgs=structNew()/>
	
	<cfif $.content("imageSize") neq "Custom">
		<cfset imageArgs.size=$.content("imageSize")>
	<cfelse>
		<cfset imageArgs.height=$.content("imageHeight")>
		<cfset imageArgs.width=$.content("imageWidth")>
	</cfif>
	
	<cfset event.setValue("currentNextNID",$.content('contentID'))>
	
	<cfif not len($.event("nextNID")) or $.event("nextNID") eq $.event("currentNextNID")>
		<cfif event.getContentBean().getNextN() gt 1>
			<cfset currentNextNIndex=$.event("startRow")>
			<cfset iterator.setStartRow(currentNextNIndex)>
		<cfelse>
			<cfset currentNextNIndex=$.event("pageNum")>
			<cfset iterator.setPage(currentNextNIndex)>
		</cfif>
	<cfelse>	
		<cfset currentNextNIndex=1>
		<cfset iterator.setPage(1)>
	</cfif>
	
	<cfset variables.nextN=$.getBean('utility').getNextN(rsSection,event.getContentBean().getNextN(),currentNextNIndex)>

	<cfif NOT len($.content("displayList"))>
		<cfset variables.contentListFields="Title,Summary,Credits">
		
		<cfif $.getBean('contentGateway').getHasComments($.event('siteid'),$.content('contentID'))>
			<cfset variables.contentListFields=listAppend(contentListFields,"Comments")>
		</cfif>
			
		<cfset variables.contentListFields=listAppend(variables.contentListFields,"Tags")>
				
		<cfif $.getBean('contentGateway').getHasRatings($.event('siteid'),$.content('contentID'))>
			<cfset variables.contentListFields=listAppend(variables.contentListFields,"Rating")>
		</cfif>
		<cfset $.content("displayList",variables.contentListFields)>
	</cfif>
	
	<cfif $.content('imageSize') neq 'custom'>
		<cfset imageWidth=$.siteConfig('gallery#$.content('imageSize')#Scale')>
	<cfelseif isNumeric($.content('imageWidth'))>
		<cfset imageWidth=$.content('imageWidth')>
	<cfelse>
		<cfset imageWidth=0>
	</cfif>
</cfsilent>
	<cfif iterator.getRecordCount()>
	<div id="svGallery"> 
			<ul class="clearfix">
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
			</cfsilent>
			<cfoutput>
			<li class="#class#"<cfif imageWidth> style="width:#imageWidth#px;"</cfif>>
				<a href="#item.getImageURL(size='large')#" title="#HTMLEditFormat(item.getValue('title'))#" rel="shadowbox[gallery]" class="gallery"><img src="#item.getImageURL(argumentCollection=imageArgs)#" alt="#HTMLEditFormat(item.getValue('title'))#"/></a>	 
			 	<dl>
			 	<cfloop list="#$.content("displayList")#" index="field">
					<cfswitch expression="#field#">
						<cfcase value="Title">
							<dt>
							 	<cfif listFindNoCase($.content("displayList"),"comments")>
							 		<a href="?linkServID=#item.getValue('contentid')#&categoryID=#HTMLEditFormat($.event('categoryID'))#&relatedID=#HTMLEditFormat(request.relatedID)#" title="#HTMLEditFormat(item.getValue('title'))#">#HTMLEditFormat(item.getValue('menutitle'))#</a>
							 	<cfelse>
							 		#HTMLEditFormat(item.getValue('menutitle'))#
							 	</cfif>
							</dt>
						</cfcase>
						<cfcase value="Summary">
						 	<cfif item.getValue('summary') neq "" and item.getValue('summary') neq "<p></p>">
							 	<dd class="summary">
							 	#item.getValue('summary')#
							 	</dd>
						 	</cfif>
						</cfcase>
						<cfcase value="Credits">	 	
						 	<cfif item.getValue('credits') neq "">
						 		<dd class="credits">#$.rbKey('list.by')# #HTMLEditFormat(item.getValue('credits'))#</dd>
						 	</cfif>
						</cfcase>
						<cfcase value="Comments">
					 		<dd class="comments"><a href="?linkServID=#item.getValue('contentid')#&categoryID=#HTMLEditFormat($.event('categoryID'))#&relatedID=#HTMLEditFormat(request.relatedID)#" title="#HTMLEditFormat(item.getValue('title'))#">#$.rbKey('list.comments')# (#$.getBean('contentGateway').getCommentCount($.event('siteID'),item.getValue('contentid'))#)</a></dd>
					 	 </cfcase>
						<cfcase value="Tags">
						 	<cfif len(item.getValue('tags'))>
								<cfset tagLen=listLen(item.getValue('tags')) />
								<dd class="tags">
									#$.rbKey('tagcloud.tags')#: 
									<cfloop from="1" to="#tagLen#" index="t">
									<cfset tag=#trim(listgetAt(item.getValue('tags'),t))#>
									<a href="#$.createHREF(filename='#$.event('currentFilenameAdjusted')#/tag/#urlEncodedFormat(tag)#')#">#tag#</a><cfif tagLen gt t>, </cfif>
									</cfloop>
								</dd>
							</cfif>
					 	</cfcase>
						<cfcase value="Rating">
					 		<dd class="ratings stars">#$.rbKey('list.rating')#: <img class="ratestars" src="#$.siteConfig('themeAssetPath')#/images/rater/star_#application.raterManager.getStarText(item.getValue('rating'))#.png" alt="<cfif isNumeric(item.getValue('rating'))>#item.getValue('rating')# star<cfif item.getValue('rating') gt 1>s</cfif></cfif>" border="0"></dd>
					 	</cfcase>
					 	<cfdefaultcase>
							<cfif len(item.getValue(field))>
							 	<dd class="#lcase(field)#">#HTMLEditFormat(item.getValue(field))#</dd>	 	
							</cfif>
						</cfdefaultcase>
					</cfswitch>
				 	</dl>
				 </cfloop>
			</li>
			</cfoutput>
			</cfloop>
		</ul>		
	</div>
	<cfif variables.nextN.numberofpages gt 1>
			<cfoutput>#$.dspObject_Include(thefile='dsp_nextN.cfm')#</cfoutput>
		</cfif>	
	<cfelse>
	 <cfoutput>
	 <cfif $.event('filterBy') eq "releaseMonth">
		<p>#$.rbKey('list.nocontentmonth')#</p>		
	 <cfelseif $.event('filterBy') eq "releaseDate">
		<p>#$.rbKey('list.nocontentday')#</p>	
	<cfelse>
		<p>#$.rbKey('list.galleryisempty')#</p>
	</cfif>
	</cfoutput>
	</cfif>