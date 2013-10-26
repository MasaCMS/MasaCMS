<!---
	This file is part of Mura CMS.

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
	the preparation of a derivative work based on Mura CMS. Thus, the terms 
	and conditions of the GNU General Public License version 2 ("GPL") cover 
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant 
	you permission to combine Mura CMS with programs or libraries that are 
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS 
	grant you permission to combine Mura CMS with independent software modules 
	(plugins, themes and bundles), and to distribute these plugins, themes and 
	bundles without Mura CMS under the license of your choice, provided that 
	you follow these specific guidelines: 

	Your custom code 

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

		/admin/
		/tasks/
		/config/
		/requirements/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that 
	meets the above guidelines as a combined work under the terms of GPL for 
	Mura CMS, provided that you include the source code of that other code when 
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not 
	obligated to grant this special exception for your modified version; it is 
	your choice whether to do so, or to make such modified version available 
	under the GNU General Public License version 2 without this exception.  You 
	may, if you choose, apply this exception to your own modified versions of 
	Mura CMS.
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

		<cfif this.contentListImageStyles>
			<cfif arguments.isCustomImage>
				<cfset arguments.imageStyles='style="#variables.$.generateListImageSyles(size='custom',width=arguments.imageWidth,height=arguments.imageHeight,padding=arguments.imagePadding)#"'>
			<cfelse>
				<cfset arguments.imageStyles='style="#variables.$.generateListImageSyles(size=arguments.imageSize,width=arguments.imageWidth,height=arguments.imageHeight,padding=arguments.imagePadding)#"'>
			</cfif>
		</cfif>
	</cfif>
</cfsilent>	

 <cfoutput>
 	<#variables.$.getContentListTag('containerEl')# #variables.$.getContentListAttributes('containerEl')#>
 </cfoutput>

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
		<#variables.$.getContentListTag('itemEl')# #variables.$.getContentListAttributes('itemEl',arguments.class)#"<cfif this.contentListImageStyles and arguments.hasImage> #arguments.imageStyles#</cfif>>
			<cfloop list="#arguments.fields#" index="arguments.field">
				<cfset arguments.field=trim(arguments.field)>
				<cfswitch expression="#arguments.field#">
					<cfcase value="Date">
						<cfif listFindNoCase("Folder,Portal",arguments.type) and isDate(arguments.item.getValue('releaseDate'))>
							<#variables.$.getContentListTag(arguments.field)# #variables.$.getContentListAttributes(arguments.field,'releaseDate')#>
								#variables.$.getContentListLabel(arguments.field)#
								#LSDateFormat(arguments.item.getValue('releaseDate'),variables.$.getLongDateFormat())#
							</#variables.$.getContentListTag(arguments.field)#>
						<cfelseif listFind("Search,Feed,Related",arguments.type) and arguments.item.getValue('parentType') eq 'Calendar' and isDate(arguments.item.getValue('displayStart'))>
							<#variables.$.getContentListTag(arguments.field)# class="releaseDate">
								#variables.$.getContentListLabel(arguments.field)#
								<cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>#LSDateFormat(arguments.item.getValue('displayStart'),variables.$.getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),variables.$.getShortDateFormat())#<cfelse>#LSDateFormat(arguments.item.getValue('displayStart'),variables.$.getLongDateFormat())#</cfif>
							</#variables.$.getContentListTag(arguments.field)#>
						<cfelseif arguments.type eq "Calendar">
							<#variables.$.getContentListTag(arguments.field)# #variables.$.getContentListAttributes(arguments.field,'releaseDate')#>
								#variables.$.getContentListLabel(arguments.field)#
								<cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>#LSDateFormat(arguments.item.getValue('displayStart'),variables.$.getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),variables.$.getShortDateFormat())#<cfelse>#LSDateFormat(arguments.item.getValue('displayStart'),variables.$.getLongDateFormat())#</cfif>
							</#variables.$.getContentListTag(arguments.field)#>
						<cfelseif LSisDate(arguments.item.getValue('releaseDate'))>
							<#variables.$.getContentListTag(arguments.field)# #variables.$.getContentListAttributes(arguments.field,'releaseDate')#>
								#variables.$.getContentListLabel(arguments.field)#
								#LSDateFormat(arguments.item.getValue('releaseDate'),variables.$.getLongDateFormat())#
							</#variables.$.getContentListTag(arguments.field)#>		
						</cfif>
					</cfcase>
					<cfcase value="Title">
						<#variables.$.getContentListTag(arguments.field)# #variables.$.getContentListAttributes(arguments.field)#>
							#variables.$.getContentListLabel(arguments.field)#
							<cfif arguments.type eq "Search">#arguments.iterator.getRecordIndex()#. </cfif>
							#variables.$.addLink(arguments.item.getValue('type'),arguments.item.getValue('filename'),arguments.item.getValue('menutitle'),arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),arguments.item.getValue('siteID'),'',variables.$.globalConfig('context'),variables.$.globalConfig('stub'),variables.$.globalConfig('indexFile'))#
						</#variables.$.getContentListTag(arguments.field)#>
					</cfcase>
					<cfcase value="Image">
						<cfif arguments.hasImage>
						<#variables.$.getContentListTag(arguments.field)# #variables.$.getContentListAttributes(arguments.field)#>
							<cfif variables.$.event('muraMobileRequest')>
							<img src="#arguments.item.getImageURL(size=arguments.imageSize,width=arguments.imageWidth,height=arguments.imageHeight)#"  alt="#htmlEditFormat(arguments.item.getValue('title'))#"/>
							<cfelse>
							<a href="#arguments.item.getURL()#" title="#HTMLEditFormat(arguments.item.getValue('title'))#" class="#this.contentListItemImageLinkClass#"><img src="#arguments.item.getImageURL(size=arguments.imageSize,width=arguments.imageWidth,height=arguments.imageHeight)#"  alt="#htmlEditFormat(arguments.item.getValue('title'))#"/></a>
							</cfif>
						</#variables.$.getContentListTag(arguments.field)#>
						</cfif>
					</cfcase>
					<cfcase value="Summary">
						<cfif len(arguments.item.getValue('summary')) and arguments.item.getValue('summary') neq "<p></p>">
						 	<#variables.$.getContentListTag(arguments.field)# #variables.$.getContentListAttributes(arguments.field)#>
						 		#variables.$.getContentListLabel(arguments.field)#
						 		#variables.$.setDynamicContent(arguments.item.getValue('summary'))#
						 	</#variables.$.getContentListTag(arguments.field)#>
						</cfif>
					</cfcase>
					<cfcase value="Body">
						<cfif not listFindNoCase('File,Link',arguments.item.getValue('type'))>
							<cfif len(arguments.item.getValue('body')) and arguments.item.getValue('body') neq "<p></p>">
						 		<#variables.$.getContentListTag(arguments.field)# #variables.$.getContentListAttributes(arguments.field)#>
						 			#variables.$.getContentListLabel(arguments.field)#
						 			#variables.$.setDynamicContent(arguments.item.getValue('body'))#
						 		</#variables.$.getContentListTag(arguments.field)#>
							 </cfif>
						<cfelse>
							 <cfif len(arguments.item.getValue('summary')) and arguments.item.getValue('summary') neq "<p></p>">
						 		<#variables.$.getContentListTag(arguments.field)# #variables.$.getContentListAttributes(arguments.field)#>
						 			#variables.$.getContentListLabel(arguments.field)#
						 			#variables.$.setDynamicContent(arguments.item.getValue('summary'))#
						 		</#variables.$.getContentListTag(arguments.field)#>
						 	</cfif>
						</cfif>
					</cfcase>
					<cfcase value="ReadMore">
					 	<#variables.$.getContentListTag(arguments.field)# #variables.$.getContentListAttributes(arguments.field,"readMore")#>#variables.$.a#variables.$.getContentListTag('itemdetail')#Link(arguments.item.getValue('type'),arguments.item.getValue('filename'),variables.$.rbKey('list.readmore'),arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),arguments.item.getValue('siteID'),'',variables.$.globalConfig('context'),variables.$.globalConfig('stub'),variables.$.globalConfig('indexFile'))#</#variables.$.getContentListTag(arguments.field)#>
					</cfcase>
					<cfcase value="Credits">
						<cfif len(arguments.item.getValue('credits'))>
						 	<#variables.$.getContentListTag(arguments.field)# #variables.$.getContentListAttributes(arguments.field)#>
						 		#variables.$.getContentListLabel(arguments.field)#
						 		#HTMLEditFormat(arguments.item.getValue('credits'))#
						 	</#variables.$.getContentListTag(arguments.field)#>
						</cfif>
					</cfcase>
					<cfcase value="Comments">
						<cfif not variables.$.event('muraMobileRequest') and (arguments.item.getValue('type') eq 'Page' or showItemMeta(arguments.item.getValue('type')) or (len(arguments.item.getValue('fileID')) and showItemMeta(arguments.item.getValue('fileEXT')))) >
						 	<#variables.$.getContentListTag(arguments.field)# #variables.$.getContentListAttributes(arguments.field)#>#variables.$.addLink(arguments.item.getValue('type'),arguments.item.getValue('filename'),'#variables.$.rbKey("list.comments")#(#variables.$.getBean('contentGateway').getCommentCount(variables.$.event('siteID'),arguments.item.getValue('contentID'))#)',arguments.item.getValue('target'),arguments.item.getValue('targetparams'),arguments.item.getValue('contentID'),variables.$.event('siteID'),'##comments')#</#variables.$.getContentListTag(arguments.field)#>
						</cfif>
					</cfcase>
					<cfcase value="Tags">
						<cfif len(arguments.item.getValue('tags'))>
							<cfset arguments.tagLen=listLen(arguments.item.getValue('tags')) />
							<#variables.$.getContentListTag(arguments.field)# #variables.$.getContentListAttributes(arguments.field)#>
								#variables.$.getContentListLabel(arguments.field)# 
								<cfloop from="1" to="#arguments.tagLen#" index="t">
								<cfset arguments.tag=#trim(listgetAt(arguments.item.getValue('tags'),t))#>
								<a href="#variables.$.createHREF(filename='#variables.$.event('currentFilenameAdjusted')#/tag/#urlEncodedFormat(arguments.tag)#')#">#HTMLEditFormat(arguments.tag)#</a><cfif arguments.tagLen gt t>, </cfif>
								</cfloop>
							</#variables.$.getContentListTag(arguments.field)#>
						</cfif>
					</cfcase>
					<cfcase value="Rating">
						<cfif (arguments.item.getValue('type') eq 'Page' or showItemMeta(arguments.item.getValue('type')) or (len(arguments.item.getValue('fileID')) and showItemMeta(arguments.item.getValue('fileEXT'))))>
						 	<#variables.$.getContentListTag(arguments.field)# class="rating #application.raterManager.getStarText(arguments.item.getValue('rating'))#">
						 		#variables.$.getContentListLabel(arguments.field)# 
						 		<span><cfif isNumeric(arguments.item.getValue('rating'))>#arguments.item.getValue('rating')# star<cfif arguments.item.getValue('rating') gt 1>s</cfif> <cfelse>Zero stars</cfif></span></#variables.$.getContentListTag('itemdetail')#>	 	
						</cfif>
					</cfcase>
					<cfdefaultcase>
						<cfif len(arguments.item.getValue(arguments.field))>
							<!--- sys based dynamic classes are deprecated --->
						 	<#variables.$.getContentListTag(arguments.field)# #variables.$.getContentListAttributes(arguments.field,'sys#uCase(left(arguments.field,1))##iif(len(arguments.field) gt 1,de('#right(arguments.field,len(arguments.field)-1)#'),de(''))#')#">
						 			#variables.$.getContentListLabel(arguments.field)#
						 			#HTMLEditFormat(arguments.item.getValue(arguments.field))#
						 		</#variables.$.getContentListTag(arguments.field)#>	 	
						</cfif>
					</cfdefaultcase>
				</cfswitch>
			</cfloop>
		</#variables.$.getContentListTag('itemEl')#>
	</cfoutput>
</cfloop>
 <cfoutput>
 	</#variables.$.getContentListTag('containerEl')#>
 </cfoutput>

