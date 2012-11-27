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

<cfswitch expression="#variables.$.getJsLib()#">
<cfcase value="jquery">
	<cfset loadJSLib() />
	<cfset variables.$.addToHTMLHeadQueue("feedslideshow/htmlhead/slideshow.jquery.cfm")>
	<cf_CacheOMatic key="#arguments.object##arguments.objectid#" nocache="#variables.$.event('nocache')#">
	<cfsilent>
	<cfparam name="hasSummary" default="true"/>
	<cfif isValid("UUID",arguments.objectID)>
		<cfset variables.feedBean = variables.$.getBean("feed").loadBy(feedID=arguments.objectID,siteID=arguments.siteID)>
  	<cfelse>
		<cfset variables.feedBean = variables.$.getBean("feed").loadBy(name=arguments.objectID,siteID=arguments.siteID)>
  	</cfif>

	<cfif not structIsEmpty(objectparams)>
		<cfset variables.feedBean.set(objectparams)>
	<cfelse>
		<cfset variables.feedBean.setImageSize("medium")>
		<cfif not arguments.hasSummary>
			<cfset variables.contentListFields=listDeleteAt(variables.feedBean.getDisplayList(),listFindNoCase(variables.feedBean.getDisplayList(),"Summary"))>
			<cfset variables.feedBean.setDisplayList(variables.contentListFields)>
		</cfif>
	</cfif>
</cfsilent>

	<cfif variables.feedBean.getIsActive()>
		<cfset variables.cssID=variables.$.createCSSid(variables.feedBean.renderName())>
      	<cfsilent>
			<cfset variables.rsPreFeed=application.feedManager.getFeed(variables.feedBean,request.tag) />
			<cfif variables.$.siteConfig('Extranet') eq 1 and variables.$.event('r').restrict eq 1>
				<cfset variables.rs=variables.$.queryPermFilter(variables.rsPreFeed)/>
			<cfelse>
				<cfset variables.rs=variables.rsPreFeed />
			</cfif>

			<cfset variables.iterator=variables.$.getBean("contentIterator")>
			<cfset variables.iterator.setQuery(variables.rs,variables.feedBean.getNextN())>


			<cfset variables.nextN=variables.$.getBean('utility').getNextN(variables.rs,variables.feedBean.getNextN(),request.StartRow)>
			<cfset variables.checkMeta=feedBean.getDisplayRatings() or variables.feedBean.getDisplayComments()>
			<cfset variables.doMeta=0 />
		  </cfsilent>
	  	<cfif variables.iterator.hasNext()>
	  	<cfoutput>
	  	<div class="svSlideshow <cfif this.generalWrapperClass neq "">#this.generalWrapperClass#</cfif>" id="#variables.cssID#">
		 	<cfif variables.feedBean.getDisplayName()>
		       <#variables.$.getHeaderTag('subHead1')#>#HTMLEditFormat(variables.feedBean.renderName())#</#variables.$.getHeaderTag('subHead1')#>
			</cfif>
	  		<div class="svSlides"<cfif listFindNoCase(variables.feedBean.getDisplayList(),"image")> style="#variables.$.generateListImageSyles(size=variables.feedBean.getImageSize(),height=variables.feedBean.getImageHeight(),setWidth=false)#"</cfif>>

				#variables.$.dspObject_Include(
					thefile='dsp_content_list.cfm',
					fields=variables.feedBean.getDisplayList(),
					type="Feed",
					iterator= variables.iterator,
					imageSize=variables.feedBean.getImageSize(),
					imageHeight=variables.feedBean.getImageHeight(),
					imageWidth=variables.feedBean.getImageWidth()
					)#

			</div>
		</div>
		</cfoutput>
		<cfelse>
			<!-- Empty Collection '<cfoutput>#feedBean.getName()#</cfoutput>'  -->
		</cfif>

	<cfelse>
		<!-- Inactive Feed '<cfoutput>#feedBean.getName()#</cfoutput>' -->
	 </cfif>
	</cf_CacheOMatic>
 </cfcase>
<cfdefaultcase>
		 <!-- The Prototype js library is not currently support for the slide show functionality  -->
</cfdefaultcase>
</cfswitch>

