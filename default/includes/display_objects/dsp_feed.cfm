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
<!--- <cftry> --->
<cfsilent>
	<cfif isValid("UUID", arguments.objectID)>
		<cfset variables.feedBean = $.getBean("feed").loadBy(feedID=arguments.objectID, 
		                                                     siteID=arguments.siteID)>
	<cfelse>
		<cfset variables.feedBean = $.getBean("feed").loadBy(name=arguments.objectID, 
		                                                     siteID=arguments.siteID)>
	</cfif>
	<cfif not structIsEmpty(objectparams)>
		<cfset variables.feedBean.set(objectparams)>
	<cfelseif variables.feedBean.getType() eq "Local" and not arguments.hasSummary>
		<cfset variables.contentListFields=listDeleteAt(variables.feedBean.getDisplayList(),listFindNoCase(variables.feedBean.getDisplayList(),"Summary"))>
		<cfset variables.feedBean.setDisplayList(variables.contentListFields)>
	</cfif>
	
</cfsilent>

<cfif variables.feedBean.getIsActive()>

	<cfset variables.cssID = $.createCSSid(feedBean.renderName())>

	<cfif variables.feedBean.getType() eq 'local'>
		<cfsilent>
			<cfset variables.rsPreFeed = application.feedManager.getFeed(feedBean)/>
			<cfif $.siteConfig('extranet') eq 1 and $.event('r').restrict eq 1>
				<cfset variables.rs = $.queryPermFilter(rsPreFeed)/>
			<cfelse>
				<cfset variables.rs = rsPreFeed/>
			</cfif>
			<cfset variables.iterator = $.getBean("contentIterator")>
			<cfset variables.iterator.setQuery(rs, feedBean.getNextN())>
		
			<cfset variables.checkMeta = feedBean.getDisplayRatings() or feedBean.getDisplayComments()>
			<cfset variables.doMeta = 0/>
			<cfset event.setValue("currentNextNID", feedBean.getFeedID())>
		
			<cfif not len($.event("nextNID")) or $.event("nextNID") eq $.event("currentNextNID")>
				<cfif event.getContentBean().getNextN() gt 1>
					<cfset variables.currentNextNIndex = $.event("startRow")>
					<cfset variables.iterator.setStartRow(currentNextNIndex)>
				<cfelse>
					<cfset variables.currentNextNIndex = $.event("pageNum")>
					<cfset variables.iterator.setPage(currentNextNIndex)>
				</cfif>
			<cfelse>
				<cfset variables.currentNextNIndex = 1>
				<cfset variables.iterator.setPage(1)>
			</cfif>
			<cfset variables.nextN = $.getBean('utility').getNextN(variables.rs, 
			                                                      variables.feedBean.getNextN(),
			                                                      variables.currentNextNIndex)>
		</cfsilent>
	
		<cfif variables.iterator.getRecordCount()>
			<cfoutput>
				<div class="svSyndLocal svFeed svIndex clearfix" id="#variables.cssID#">
					<cfif variables.feedBean.getDisplayName()>
						<#$.getHeaderTag('subHead1')#>#HTMLEditFormat(variables.feedBean.renderName())#</#$.getHeaderTag('subHead1')#>
					</cfif>
					#$.dspObject_Include(
									thefile='dsp_content_list.cfm', 
									fields=variables.feedBean.getDisplayList(), 
				                    type="Feed",
									iterator=variables.iterator, 
				                    imageSize=variables.feedBean.getImageSize(),
				                    imageHeight=variables.feedBean.getImageHeight(),
				                    imageWidth=variables.feedBean.getImageWidth()
								)#
					<cfif variables.nextN.numberofpages gt 1>
						#$.dspObject_Include(thefile='dsp_nextN.cfm')#
					</cfif>
				</div>
			</cfoutput>
		<cfelse>
			<cfoutput>#dspObject("component", "[placeholder] #variables.feedBean.getName()#", arguments.siteID)#</cfoutput>
			<!-- Empty Collection '
			<cfoutput>#feedBean.getName()#</cfoutput>
			' -->
		</cfif>
	<cfelse>
		<!---<cftry> --->
		<cfsilent>
			<cfset request.cacheItemTimespan = createTimeSpan(0, 0, 5, 0)>
			<cfset variables.feedData = application.feedManager.getRemoteFeedData(variables.feedBean.getChannelLink(), 
			                                                                      variables.feedBean.getMaxItems())/>
			                                                                      
			<cfif not structIsEmpty(objectparams)>
				<cfset arguments.hasSummary=objectparams.displaySummaries>	
			</cfif>
		</cfsilent>
		<cfoutput>
			<cfif isDefined("variables.feedData.maxItems") and variables.feedData.maxItems>
				<div class="svSyndRemote svIndex svFeed clearfix" id="#variables.cssID#">
					<#$.getHeaderTag('subHead1')#>#HTMLEditFormat(variables.feedBean.getName())#</#$.getHeaderTag('subHead1')#>
					<cfif variables.feedData.type neq "atom">
						<cfloop from="1" to="#variables.feedData.maxItems#" index="i">
							<dl<cfif (i EQ 1)> class="first"<cfelseif (i EQ variables.feedData.maxItems)> class="last"</cfif>>
								<!--- Date stuff--->
								<cfif structKeyExists(variables.feedData.itemArray[i],"pubDate")>
									<cftry>
									<cfset variables.itemDate=parseDateTime(variables.feedData.itemArray[i].pubDate.xmlText)>
									<dt class="releaseDate"><cfif isDate(variables.itemDate)>#LSDateFormat(variables.itemDate,$.getLongDateFormat())#<cfelse>#variables.feedData.itemArray[i].pubDate.xmlText#</cfif></dt>
									<cfcatch></cfcatch>
									</cftry>
								<cfelseif structKeyExists(variables.feedData.itemArray[i],"dc:date")>
									<cftry>
									<cfset itemDate=parseDateTime(variables.feedData.itemArray[i]["dc:date"].xmlText)>
									<dt class="releaseDate"><cfif isDate(variables.itemDate)>#LSDateFormat(variables.itemDate,$.getLongDateFormat())#<cfelse>#variables.feedData.itemArray[i]["dc:date"].xmlText#</cfif></dt>
									<cfcatch></cfcatch>
									</cftry>
								</cfif>
								<dt><a href="#variables.feedData.itemArray[i].link.xmlText#" onclick="window.open(this.href); return false;">#variables.feedData.itemArray[i].title.xmlText#</a></dt>						
								<cfif arguments.hasSummary and structKeyExists(variables.feedData.itemArray[i],"description")><dd class="summary">#variables.feedData.itemArray[i].description.xmlText#</dd></cfif>
							</dl>
						</cfloop>
					<cfelse>
						<cfloop from="1" to="#variables.feedData.maxItems#" index="i">
							<dl<cfif (i EQ 1)> class="first"<cfelseif (i EQ variables.feedData.maxItems)> class="last"</cfif>>
								<!--- Date stuff--->
								<cfif structKeyExists(variables.feedData.itemArray[i],"updated")>
									<cftry>
									<cfset variables.itemDate=parseDateTime(variables.feedData.itemArray[i].updated.xmlText)>
									<dt class="releaseDate"><cfif isDate(variables.itemDate)>#LSDateFormat(variables.itemDate,$.getLongDateFormat())#<cfelse>#variables.feedData.itemArray[i].updated.xmlText#</cfif></dt>
									<cfcatch></cfcatch>
									</cftry>
								</cfif>
								<dt><a href="#variables.feedData.itemArray[i].link.XmlAttributes.href#" onclick="window.open(this.href); return false;">#variables.feedData.itemArray[i].title.xmlText#</a></dt>
								<cfif arguments.hasSummary and structKeyExists(variables.feedData.itemArray[i],"summary")><dd class="summary">#variables.feedData.itemArray[i].summary.xmlText#</dd></cfif>
							</dl>
						</cfloop>
					</cfif>
				</div>
			<cfelse>
				#dspObject("component", "[placeholder] #variables.feedBean.getName()#", arguments.siteID)#
				<!-- Empty Feed 
				<cfoutput>'#feedBean.getName()#'</cfoutput>
				-->
			</cfif>
		</cfoutput>
		<!---
		<cfcatch><!-- Error getting Feed <cfoutput>'#feedBean.getName()#'</cfoutput> --></cfcatch>
		</cftry>---->
	</cfif>
<cfelse>
	<!-- Inactive Feed '
	<cfoutput>#feedBean.getName()#</cfoutput>
	' -->
</cfif>
<!---   <cfcatch>
  </cfcatch>
</cftry> --->