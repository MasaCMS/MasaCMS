<!---
	This file is part of Mura CMS.

	Mura CMS is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, Version 2 of the License.

	Mura CMS is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See theƒ
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
	/core/
	/Application.cfc
	/index.cfm

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

	<cfset arguments.propertyMapFinal={
		itemEl={tag="div",class="mura-item-meta"},
		labelEl={tag="span"},
		credits={tag="div",showLabel=true,labelDelim=":",rbkey="list.by"},
		tags={tag="div",showLabel=true,labelDelim=":",rbkey="tagcloud.tags"},
		rating={tag="div",showLabel=true,labelDelim=":",rbkey="list.rating"},
		'default'={tag="div"}
	}>

	<cfif isDefined('arguments.propertyMap')>
		<cfset structAppend(arguments.propertyMapFinal, arguments.propertyMap, true)>
	</cfif>

	<cfif not structKeyExists(arguments,"type")>
		<cfset arguments.type="Feed">
	</cfif>
	<cfif not structKeyExists(arguments,"fields")>
		<cfset arguments.fields="Date,Title,Summary,Credits,Tags">
	</cfif>
</cfsilent>
<cfoutput>
	#variables.$.getContentListPropertyValue('itemEl','openingOuterMarkUp',arguments.propertyMapFinal)#
	<#variables.$.getContentListPropertyValue('itemEl','tag',arguments.propertyMapFinal)# class="mura-item-meta">
		#variables.$.getContentListPropertyValue('itemEL',"openingInnerMarkUp",arguments.propertyMapFinal)#
		<cfloop list="#arguments.fields#" index="arguments.field">
			<cfif arguments.field neq 'image'>
			<cfset arguments.field=trim(arguments.field)>
			#variables.$.getContentListPropertyValue(arguments.field,"openingOuterMarkUp",arguments.propertyMapFinal)#
			<cfswitch expression="#arguments.field#">
				<cfcase value="Date">
					<cfif arguments.type eq 'Folder' and isDate(arguments.item.getValue('releaseDate'))>
						<#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)# class="mura-item-meta__date">
						#variables.$.getContentListPropertyValue(arguments.field,"openingInnerMarkUp",arguments.propertyMapFinal)#
							#variables.$.getContentListLabel(arguments.field,arguments.propertyMapFinal)#
							<time>#LSDateFormat(arguments.item.getValue('releaseDate'),variables.$.getLongDateFormat())#</time>
						#variables.$.getContentListPropertyValue(arguments.field,"closingInnerMarkUp",arguments.propertyMapFinal)#
						</#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)#>
					<cfelseif listFind("Search,Feed,Related",arguments.type) and arguments.item.getValue('parentType') eq 'Calendar' and isDate(arguments.item.getValue('displayStart'))>
						<#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)# class="mura-item-meta__date">
							#variables.$.getContentListLabel(arguments.field,arguments.propertyMapFinal)#
							<cfif LSDateFormat(arguments.item.getValue('displayStart'),"short") lt LSDateFormat(arguments.item.getValue('displayStop'),"short")>
								<time>#LSDateFormat(arguments.item.getValue('displayStart'),variables.$.getShortDateFormat())# - #LSDateFormat(arguments.item.getValue('displayStop'),variables.$.getShortDateFormat())#</time>
							<cfelse>
								<time>#LSDateFormat(arguments.item.getValue('displayStart'),variables.$.getLongDateFormat())#</time>
							</cfif>
						#variables.$.getContentListPropertyValue(arguments.field,"closingInnerMarkUp",arguments.propertyMapFinal)#
						</#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)#>
					<cfelseif arguments.type eq "Calendar">
						<#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)# class="mura-item-meta__date">
						#variables.$.getContentListPropertyValue(arguments.field,"openingInnerMarkUp")#
							#variables.$.getContentListLabel(arguments.field,arguments.propertyMapFinal)#
							#arguments.item.getDisplayIntervalDesc(showTitle=this.calendarTitleInDesc)#
						#variables.$.getContentListPropertyValue(arguments.field,"closingInnerMarkUp",arguments.propertyMapFinal)#
						</#variables.$.getContentListPropertyValue(arguments.field,'tag')#>
					<cfelseif LSisDate(arguments.item.getValue('releaseDate'))>
						<#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)# class="mura-item-meta__date">
						#variables.$.getContentListPropertyValue(arguments.field,"openingInnerMarkUp",arguments.propertyMapFinal)#
							#variables.$.getContentListLabel(arguments.field,arguments.propertyMapFinal)#
							<time>#LSDateFormat(arguments.item.getValue('releaseDate'),variables.$.getLongDateFormat())#</time>
						#variables.$.getContentListPropertyValue(arguments.field,"closingInnerMarkUp",arguments.propertyMapFinal)#
						</#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)#>
					</cfif>
				</cfcase>
				<cfcase value="Title">
					<#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)# class="mura-item-meta__title">
					#variables.$.getContentListPropertyValue(arguments.field,"openingInnerMarkUp",arguments.propertyMapFinal)#
						#variables.$.getContentListLabel(arguments.field,arguments.propertyMapFinal)#
						<cfif arguments.type eq "Search" && this.searchShowNumbers eq 1><span class="record-index">#arguments.iterator.getRecordIndex()#.</span> </cfif>
						#variables.$.addLink(
							type=arguments.item.getValue('type'),
							filename=arguments.item.getValue('filename'),
							title=arguments.item.getValue('menutitle'),
							target=arguments.item.getValue('target'),
							contentid=arguments.item.getValue('contentID'),
							siteid=arguments.item.getValue('siteID'),
							aHasKidsClass='',
							aHasKidsAttributes='',
							aCurrentClass=this.aMetaListCurrentClass,
							aCurrentAttributes=this.aMetaListCurrentAttributes,
							aNotCurrentClass=this.aMetaListNotCurrentClass
						)#
					#variables.$.getContentListPropertyValue(arguments.field,"closingInnerMarkUp",arguments.propertyMapFinal)#
					</#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)#>
				</cfcase>
				<cfcase value="Summary">
					<cfif len(arguments.item.getValue('summary')) and arguments.item.getValue('summary') neq "<p></p>">
					 	<#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)# class="mura-item-meta__summary">
					 	#variables.$.getContentListPropertyValue(arguments.field,"openingInnerMarkUp",arguments.propertyMapFinal)#
					 		#variables.$.getContentListLabel(arguments.field,arguments.propertyMapFinal)#
					 		#variables.$.setDynamicContent(arguments.item.getValue('summary'))#
					 	#variables.$.getContentListPropertyValue(arguments.field,"closingInnerMarkUp",arguments.propertyMapFinal)#
					 	</#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)#>
					</cfif>
				</cfcase>
				<cfcase value="Body">
					<cfif not listFindNoCase('File,Link',arguments.item.getValue('type'))>
						<cfif len(arguments.item.getValue('body')) and arguments.item.getValue('body') neq "<p></p>">
					 		<#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)# class="mura-item-meta__body">
					 		#variables.$.getContentListPropertyValue(arguments.field,"openingInnerMarkUp",arguments.propertyMapFinal)#
					 			#variables.$.getContentListLabel(arguments.field,arguments.propertyMapFinal)#
					 			#variables.$.setDynamicContent(arguments.item.getValue('body'))#
					 		#variables.$.getContentListPropertyValue(arguments.field,"closingInnerMarkUp",arguments.propertyMapFinal)#
					 		</#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)#>
						 </cfif>
					<cfelse>
						 <cfif len(arguments.item.getValue('summary')) and arguments.item.getValue('summary') neq "<p></p>">
					 		<#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)# class="mura-item-meta__body">
					 		#variables.$.getContentListPropertyValue(arguments.field,"openingInnerMarkUp",arguments.propertyMapFinal)#
					 			#variables.$.getContentListLabel(arguments.field,arguments.propertyMapFinal)#
					 			#variables.$.setDynamicContent(arguments.item.getValue('summary'))#
					 		#variables.$.getContentListPropertyValue(arguments.field,"closingInnerMarkUp",arguments.propertyMapFinal)#
					 		</#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)#>
					 	</cfif>
					</cfif>
				</cfcase>
				<cfcase value="ReadMore">
				 	<#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)# class="mura-item-meta__readmore">
				 	#variables.$.getContentListPropertyValue(arguments.field,"openingInnerMarkUp",arguments.propertyMapFinal)#
					#variables.$.addLink(
						type=arguments.item.getValue('type'),
						filename=arguments.item.getValue('filename'),
						title=variables.$.rbKey('list.readmore'),
						target=arguments.item.getValue('target'),
						contentid=arguments.item.getValue('contentID'),
						siteid=arguments.item.getValue('siteID'),
						aHasKidsClass='',
						aHasKidsAttributes='',
						aCurrentClass=this.aMetaListCurrentClass,
						aCurrentAttributes=this.aMetaListCurrentAttributes,
						aNotCurrentClass=this.aMetaListNotCurrentClass
					)#
				 	#variables.$.getContentListPropertyValue(arguments.field,"closingInnerMarkUp",arguments.propertyMapFinal)#
				 	</#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)#>
				</cfcase>
				<cfcase value="Credits">
					<cfif len(arguments.item.getValue('credits'))>
					 	<#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)# class="mura-item-meta__credits">
					 	#variables.$.getContentListPropertyValue(arguments.field,"openingInnerMarkUp",arguments.propertyMapFinal)#
					 		#variables.$.getContentListLabel(arguments.field)#
					 		#HTMLEditFormat(arguments.item.getValue('credits'))#
					 	#variables.$.getContentListPropertyValue(arguments.field,"closingInnerMarkUp",arguments.propertyMapFinal)#
					 	</#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)#>
					</cfif>
				</cfcase>
				<cfcase value="Comments">
					<cfif not variables.$.event('muraMobileTemplate') and (arguments.item.getValue('type') eq 'Page' or showItemMeta(arguments.item.getValue('type')) or (len(arguments.item.getValue('fileID')) and showItemMeta(arguments.item.getValue('fileEXT')))) >
					 	<#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)# class="mura-item-meta__comments">
					 	#variables.$.getContentListPropertyValue(arguments.field,"openingInnerMarkUp",arguments.propertyMapFinal)#
						#variables.$.addLink(
							type=arguments.item.getValue('type'),
							filename=arguments.item.getValue('filename'),
							title='#variables.$.rbKey("list.comments")# (#variables.$.getBean('contentGateway').getCommentCount(variables.$.event('siteID'),arguments.item.getValue('contentID'))#)',
							target=arguments.item.getValue('target'),contentid=arguments.item.getValue('contentID'),
							siteid=arguments.item.getValue('siteID'),
							queryString='##mura-comments',
							aHasKidsClass='',
							aHasKidsAttributes='',
							aCurrentClass=this.aMetaListCurrentClass,
							aCurrentAttributes=this.aMetaListCurrentAttributes,
							aNotCurrentClass=this.aMetaListNotCurrentClass
						)#
					 	#variables.$.getContentListPropertyValue(arguments.field,"closingInnerMarkUp",arguments.propertyMapFinal)#
					 	</#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)#>
					</cfif>
				</cfcase>
				<cfcase value="Tags">
					<cfif len(arguments.item.getValue('tags'))>
						<cfset arguments.tagLen=listLen(arguments.item.getValue('tags')) />
						<#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)# class="mura-item-meta__tags">
						#variables.$.getContentListPropertyValue(arguments.field,"openingInnerMarkUp",arguments.propertyMapFinal)#
							#variables.$.getContentListLabel(arguments.field)#
							<cfloop from="1" to="#arguments.tagLen#" index="t">
							<cfset arguments.tag=#trim(listgetAt(arguments.item.getValue('tags'),t))#>
							<span><a href="#variables.$.createHREF(filename='#variables.$.event('currentFilenameAdjusted')#/tag/#urlEncodedFormat(arguments.tag)#')#">#esapiEncode('html',arguments.tag)#</a></span>
							</cfloop>
						#variables.$.getContentListPropertyValue(arguments.field,"closingInnerMarkUp",arguments.propertyMapFinal)#
						</#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)#>
					</cfif>
				</cfcase>
				<cfcase value="Rating">
					<cfif (arguments.item.getValue('type') eq 'Page' or showItemMeta(arguments.item.getValue('type')) or (len(arguments.item.getValue('fileID')) and showItemMeta(arguments.item.getValue('fileEXT'))))>
					 	<#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)# class="mura-item-meta__rating #application.raterManager.getStarText(arguments.item.getValue('rating'))#">
					 	#variables.$.getContentListPropertyValue(arguments.field,"openingInnerMarkUp",arguments.propertyMapFinal)#
					 		#variables.$.getContentListLabel(arguments.field,arguments.propertyMapFinal)#
					 		<span><cfif isNumeric(arguments.item.getValue('rating'))>#arguments.item.getValue('rating')# star<cfif arguments.item.getValue('rating') gt 1>s</cfif> <cfelse>Zero stars</cfif></span>
					 	#variables.$.getContentListPropertyValue(arguments.field,"closingInnerMarkUp",arguments.propertyMapFinal)#
					 	</#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)#>
					</cfif>
				</cfcase>
				<cfdefaultcase>
					<cfif len(arguments.item.getValue(arguments.field))>
						<!--- sys based dynamic classes are deprecated --->
					 	<#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)# class="mura-item-meta__#lcase(arguments.field)#">
					 	#variables.$.getContentListPropertyValue(arguments.field,"openingInnerMarkUp",arguments.propertyMapFinal)#
					 			#variables.$.getContentListLabel(arguments.field,arguments.propertyMapFinal)#
					 			 <cfif LSisDate(arguments.item.getValue(arguments.field))>
					 			 	#LSDateFormat(arguments.item.getValue(arguments.field),variables.$.getLongDateFormat())#
					 			 <cfelse>
					 			 	#esapiEncode("html",arguments.item.getValue(arguments.field))#
					 			 </cfif>
					 	#variables.$.getContentListPropertyValue(arguments.field,"closingInnerMarkUp",arguments.propertyMapFinal)#
					 	</#variables.$.getContentListPropertyValue(arguments.field,'tag',arguments.propertyMapFinal)#>
					</cfif>
				</cfdefaultcase>
			</cfswitch>
			#variables.$.getContentListPropertyValue(arguments.field,"closingOuterMarkUp",arguments.propertyMapFinal)#
			</cfif>
		</cfloop>
	#variables.$.getContentListPropertyValue('itemEl',"closingInnerMarkUp",arguments.propertyMapFinal)#
	</#variables.$.getContentListPropertyValue('itemEl',"tag",arguments.propertyMapFinal)#>
	#variables.$.getContentListPropertyValue('itemEl',"closingOuterMarkUp",arguments.propertyMapFinal)#
</cfoutput>
