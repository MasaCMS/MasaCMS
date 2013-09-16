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
	<cfset variables.hasComments=variables.$.getBean('contentGateway').gethasComments(variables.$.event('siteID'),variables.$.content('contentHistID')) />
	<cfset variables.hasRatings=variables.$.getBean('contentGateway').gethasRatings(variables.$.event('siteID'),variables.$.content('contentHistID')) />
	
	<cfif not isNumeric(variables.$.event('month'))>
		<cfset variables.$.event('month',month(now()))>
	</cfif>
	
	<cfif not isNumeric(variables.$.event('year'))>
		<cfset variables.$.event('year',year(now()))>
	</cfif>
	
	<cfif isNumeric(variables.$.event('day')) and variables.$.event('day')
		and variables.$.event('filterBy') eq "releaseDate">
		<cfset variables.menuType="releaseDate">
		<cfset variables.menuDate=createDate(variables.$.event('year'),variables.$.event('month'),variables.$.event('day'))>
	<cfelseif variables.$.event('filter') eq "releaseMonth">
		<cfset variables.menuType="releaseMonth">
		<cfset variables.menuDate=createDate(variables.$.event('year'),variables.$.event('month'),1)>
	<cfelse>
		<cfset variables.menuDate=now()>
		<cfset variables.menuType="default">
	</cfif>
	
	<cfset applyPermFilter=variables.$.siteConfig('extranet') eq 1 and variables.$.event('r').restrict eq 1>

	<cfset variables.rssection=variables.$.getBean('contentGateway').getKids('00000000000000000000000000000000000',variables.$.event('siteID'),variables.$.content('contentID'),variables.menuType,variables.menuDate,0,variables.$.event('keywords'),0,variables.$.content('sortBy'),variables.$.content('sortDirection'),variables.$.event('categoryID'),variables.$.event('relatedID'),variables.$.event('tag'),false,applyPermFilter,variables.$.event('taggroup'))>
	
	<cfset variables.iterator=variables.$.getBean("contentIterator")>
	<cfset variables.iterator.setQuery(variables.rssection,event.getContentBean().getNextN())>
	
	<cfset imageArgs=structNew()/>
	
	<cfif variables.$.content("imageSize") neq "Custom">
		<cfset imageArgs.size=variables.$.content("imageSize")>
	<cfelse>
		<cfset imageArgs.height=variables.$.content("imageHeight")>
		<cfset imageArgs.width=variables.$.content("imageWidth")>
	</cfif>
	
	<cfset variables.$.event("currentNextNID",variables.$.content('contentID'))>
	
	<cfif not len(variables.$.event("nextNID")) or variables.$.event("nextNID") eq variables.$.event("currentNextNID")>
		<cfif event.getContentBean().getNextN() gt 1>
			<cfset currentNextNIndex=variables.$.event("startRow")>
			<cfset variables.iterator.setStartRow(currentNextNIndex)>
		<cfelse>
			<cfset currentNextNIndex=variables.$.event("pageNum")>
			<cfset variables.iterator.setPage(currentNextNIndex)>
		</cfif>
	<cfelse>	
		<cfset currentNextNIndex=1>
		<cfset variables.iterator.setPage(1)>
	</cfif>
	
	<cfset variables.nextN=variables.$.getBean('utility').getNextN(variables.rssection,event.getContentBean().getNextN(),currentNextNIndex)>

	<cfif NOT len(variables.$.content("displayList"))>
		<cfset variables.contentListFields="Title,Summary,Credits">
		
		<cfif variables.$.getBean('contentGateway').gethasComments(variables.$.event('siteid'),variables.$.content('contentID'))>
			<cfset variables.contentListFields=listAppend(contentListFields,"Comments")>
		</cfif>
			
		<cfset variables.contentListFields=listAppend(variables.contentListFields,"Tags")>
				
		<cfif variables.$.getBean('contentGateway').gethasRatings(variables.$.event('siteid'),variables.$.content('contentID'))>
			<cfset variables.contentListFields=listAppend(variables.contentListFields,"Rating")>
		</cfif>
		<cfset variables.$.content("displayList",variables.contentListFields)>
	</cfif>
	
	<cfif variables.$.content('imageSize') neq 'custom'>
		<cfset variables.imageWidth=variables.$.siteConfig('gallery#variables.$.content('imageSize')#Scale')>
	<cfelseif isNumeric(variables.$.content('imageWidth'))>
		<cfset variables.imageWidth=variables.$.content('imageWidth')>
	<cfelse>
		<cfset variables.imageWidth=0>
	</cfif>
</cfsilent>
	<cfif variables.iterator.getRecordCount()>
	<div id="svGallery"> 
			<ul class="clearfix">
			<cfloop condition="variables.iterator.hasNext()">
			<cfsilent>
			<cfset variables.item=variables.iterator.next()>
			<cfset variables.class=""/>
			<cfif not variables.iterator.hasPrevious()> 
				<cfset variables.class=listAppend(variables.class,"first"," ")/> 
			</cfif>
			<cfif not variables.iterator.hasNext()> 
				<cfset variables.class=listAppend(variables.class,"last"," ")/> 
			</cfif>
			</cfsilent>
			<cfoutput>
			<li class="#variables.class#"<cfif isNumeric(variables.imageWidth)> style="width:#variables.imageWidth#px;"</cfif>>
				<a href="#variables.item.getImageURL(size='large')#" title="#HTMLEditFormat(variables.item.getValue('title'))#" rel="shadowbox[gallery]" class="gallery thumbnail"><img src="#variables.item.getImageURL(argumentCollection=imageArgs)#" alt="#HTMLEditFormat(variables.item.getValue('title'))#"/></a>	 
			 	<dl>
			 	<cfloop list="#variables.$.content("displayList")#" index="field">
					<cfswitch expression="#field#">
						<cfcase value="Title">
							<dt>
							 	<cfif listFindNoCase(variables.$.content("displayList"),"comments")>
							 		<a href="?linkServID=#variables.item.getValue('contentid')#&categoryID=#HTMLEditFormat(variables.$.event('categoryID'))#&relatedID=#HTMLEditFormat(request.relatedID)#" title="#HTMLEditFormat(variables.item.getValue('title'))#">#HTMLEditFormat(variables.item.getValue('menutitle'))#</a>
							 	<cfelse>
							 		#HTMLEditFormat(variables.item.getValue('menutitle'))#
							 	</cfif>
							</dt>
						</cfcase>
						<cfcase value="Summary">
						 	<cfif variables.item.getValue('summary') neq "" and variables.item.getValue('summary') neq "<p></p>">
							 	<dd class="summary">
							 	#variables.item.getValue('summary')#
							 	</dd>
						 	</cfif>
						</cfcase>
						<cfcase value="Credits">	 	
						 	<cfif variables.item.getValue('credits') neq "">
						 		<dd class="credits">#variables.$.rbKey('list.by')# #HTMLEditFormat(variables.item.getValue('credits'))#</dd>
						 	</cfif>
						</cfcase>
						<cfcase value="Comments">
					 		<dd class="comments"><a href="?linkServID=#variables.item.getValue('contentid')#&categoryID=#HTMLEditFormat(variables.$.event('categoryID'))#&relatedID=#HTMLEditFormat(request.relatedID)#" title="#HTMLEditFormat(variables.item.getValue('title'))#">#variables.$.rbKey('list.comments')# (#variables.$.getBean('contentGateway').getCommentCount(variables.$.event('siteID'),variables.item.getValue('contentid'))#)</a></dd>
					 	 </cfcase>
						<cfcase value="Tags">
						 	<cfif len(variables.item.getValue('tags'))>
								<cfset tagLen=listLen(variables.item.getValue('tags')) />
								<dd class="tags">
									#variables.$.rbKey('tagcloud.tags')#: 
									<cfloop from="1" to="#tagLen#" index="variables.t">
									<cfset tag=#trim(listgetAt(variables.item.getValue('tags'),variables.t))#>
									<a href="#variables.$.createHREF(filename='#variables.$.event('currentFilenameAdjusted')#/tag/#urlEncodedFormat(tag)#')#">#tag#</a><cfif tagLen gt t>, </cfif>
									</cfloop>
								</dd>
							</cfif>
					 	</cfcase>
						<cfcase value="Rating">
					 		<dd class="ratings stars">#variables.$.rbKey('list.rating')#: <img class="ratestars" src="#variables.$.siteConfig('themeAssetPath')#/images/rater/star_#application.raterManager.getStarText(variables.item.getValue('rating'))#.png" alt="<cfif isNumeric(variables.item.getValue('rating'))>#variables.item.getValue('rating')# star<cfif variables.item.getValue('rating') gt 1>s</cfif></cfif>" border="0"></dd>
					 	</cfcase>
					 	<cfdefaultcase>
							<cfif len(variables.item.getValue(field))>
							 	<dd class="#lcase(field)#">#HTMLEditFormat(variables.item.getValue(field))#</dd>	 	
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
			<cfoutput>#variables.$.dspObject_Include(thefile='dsp_nextN.cfm')#</cfoutput>
		</cfif>	
	<cfelse>
	 <cfoutput>
	 <cfif variables.$.event('filterBy') eq "releaseMonth">
		<p>#variables.$.rbKey('list.nocontentmonth')#</p>		
	 <cfelseif variables.$.event('filterBy') eq "releaseDate">
		<p>#variables.$.rbKey('list.nocontentday')#</p>	
	<cfelse>
		<p>#variables.$.rbKey('list.galleryisempty')#</p>
	</cfif>
	</cfoutput>
	</cfif>