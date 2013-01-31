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
<cfcomponent output="false" extends="coldspring.beans.DefaultXmlBeanFactory">

	
	<cfset variables.transient=structNew()>
	<cfset variables.transientAlias=structNew()>
	<cfset variables.transientObjects=structNew()>
	
	<cfset variables.transient["contentBean"]="mura.content.contentBean"/>
	<cfset variables.transient["contentNavBean"]="mura.content.contentNavBean"/>
	<cfset variables.transient["contentStatsBean"]="mura.content.contentStatsBean"/>
	<cfset variables.transient["contentIterator"]="mura.content.contentIterator"/>
	<cfset variables.transient["contentCommentIterator"]="mura.content.contentCommentIterator"/>
	<cfset variables.transient["contentCommentBean"]="mura.content.contentCommentBean"/>
	<cfset variables.transient["contentCommentFeedBean"]="mura.content.contentCommentFeedBean"/>	
	<cfset variables.transient["httpSession"]="mura.client.httpSession"/>
	<cfset variables.transient["MuraScope"]="mura.MuraScope">
	<cfset variables.transient["changesetBean"]="mura.content.changeset.changesetBean"/>
	<cfset variables.transient["changesetIterator"]="mura.content.changeset.changesetIterator"/>
	<cfset variables.transient["extendObjectIterator"]="mura.extend.extendObjectIterator"/>
	<cfset variables.transient["extendObject"]="mura.extend.extendObject"/>
	<cfset variables.transient["extendObjectFeedBean"]="mura.extend.extendObjectFeedBean"/>
	<cfset variables.transient["pluginScriptBean"]="mura.plugin.pluginScriptBean"/>
	<cfset variables.transient["pluginDisplayObjectBean"]="mura.plugin.pluginDisplayObjectBean"/>		
	<cfset variables.transient["pluginSettingBean"]="mura.plugin.pluginSettingBean"/>
	<cfset variables.transient["changesetBean"]="mura.content.changeset.changesetBean"/>
	<cfset variables.transient["changesetIterator"]="mura.content.changeset.changesetIterator"/>
	<cfset variables.transient["rateBean"]="mura.content.rater.rateBean"/>
	<cfset variables.transient["servlet"]="mura.servlet" />
	<cfset variables.transient["favoriteBean"]="mura.content.favorite.favoriteBean"/>
	<cfset variables.transient["creativeBean"]="mura.advertising.creative.creativeBean" />
	<cfset variables.transient["image"]="mura.content.file.imagecfc.image" />
	<cfset variables.transient["adZoneBean"]="mura.advertising.adZone.adZoneBean" />
	<cfset variables.transient["reminderBean"]="mura.content.reminder.reminderBean" />
	<cfset variables.transient["contentRenderer"]="mura.content.contentRenderer"  />
	<cfset variables.transient["categoryIterator"]="mura.category.categoryIterator"/>
	<cfset variables.transient["categoryBean"]="mura.category.categoryBean" />
	<cfset variables.transient["categoryFeedBean"]="mura.category.categoryFeedBean" />
	<cfset variables.transient["settingsBean"]="mura.settings.settingsBean"/>
	<cfset variables.transient["settingsImageSizeBean"]="mura.settings.settingsImageSizeBean"/>
	<cfset variables.transient["settingsImageSizeIterator"]="mura.settings.settingsImageSizeIterator"/>
	<cfset variables.transient["settingsBundle"]="mura.settings.settingsBundle"/>
	<cfset variables.transient["userIterator"]="mura.user.userIterator"/>
	<cfset variables.transient["userFeedBean"]="mura.user.userFeedBean"/>
	<cfset variables.transient["addressIterator"]="mura.user.addressIterator"/>
	<cfset variables.transient["userBean"]="mura.user.userBean" />
	<cfset variables.transient["addressBean"]="mura.user.addressBean" />
	<cfset variables.transient["mailinglistBean"]="mura.mailinglist.mailinglistBean" />
	<cfset variables.transient["memberBean"]="mura.mailinglist.memberBean" />
	<cfset variables.transient["emailBean"]="mura.email.emailBean" />
	<cfset variables.transient["campaignBean"]="mura.advertising.campaign.campaignBean" />
	<cfset variables.transient["placementBean"]="mura.advertising.campaign.placement.placementBean" />
	<cfset variables.transient["feedBean"]="mura.content.feed.feedBean"/>
	<cfset variables.transient["beanServicePlaceHolder"]="mura.bean.beanServicePlaceHolder"/>
	<cfset variables.transient["dbUtility"]="mura.dbUtility"/>
	<cfset variables.transientAlias["content"]="contentBean"/>
	<cfset variables.transientAlias["feed"]="feedBean"/>
	<cfset variables.transientAlias["site"]="settingsBean"/>
	<cfset variables.transientAlias["user"]="userBean"/>
	<cfset variables.transientAlias["group"]="userBean"/>
	<cfset variables.transientAlias["address"]="addressBean"/>
	<cfset variables.transientAlias["category"]="categoryBean"/>
	<cfset variables.transientAlias["categoryFeed"]="categoryFeedBean"/>
	<cfset variables.transientAlias["userFeed"]="userFeedBean"/>
	<cfset variables.transientAlias["comment"]="contentCommentBean"/>
	<cfset variables.transientAlias["commentFeed"]="contentCommentFeedBean"/>
	<cfset variables.transientAlias["stats"]="contentStatsBean"/>
	<cfset variables.transientAlias["changeset"]="changesetBean"/>
	<cfset variables.transientAlias["bundle"]="settingsBundle"/>
	<cfset variables.transientAlias["mailingList"]="mailingListBean"/>
	<cfset variables.transientAlias["mailingListMember"]="memberBean"/>
	<cfset variables.transientAlias["groupDAO"]="userDAO"/>
	<cfset variables.transientAlias["placement"]="placementBean"/>
	<cfset variables.transientAlias["creative"]="creativeBean"/>
	<cfset variables.transientAlias["rate"]="rateBean"/>
	<cfset variables.transientAlias["favorite"]="favoriteBean"/>
	<cfset variables.transientAlias["campaign"]="campaignBean"/>
	<cfset variables.transientAlias["email"]="emailBean"/>
	<cfset variables.transientAlias["adZone"]="adZoneBean"/>
	<cfset variables.transientAlias["imageSize"]="settingsImageSizeBean"/>
	<cfset variables.transientAlias["imageSizeIterator"]="settingsImageSizeIterator"/>
	<cfset variables.transientAlias["$"]="MuraScope"/>
	
	<cffunction name="loadBeansFromXMLRaw" output="false">
		<cfset super.loadBeansFromXMLRaw(argumentCollection=arguments)>
		<cfset variables.beanInjector=super.getBean("beanInjector")>	
	</cffunction>
	
	<cffunction name="getBean" outout="false">
		<cfargument name="beanName">
		<cfargument name="targetService">
		<cfset var bean="">
	
		<cfif super.containsBean(arguments.beanName) OR left(arguments.beanName, 1) IS "&">
			<cfif structKeyExists(arguments,"targetService")>
				<cfreturn createObject("component","beanServicePlaceholder").init(argumentCollection=arguments)>
			<cfelse>
				<cfreturn super.getBean(arguments.beanName)>
			</cfif>
		</cfif>
		
		<cfif structKeyExists(variables.transientAlias,arguments.beanName)>
			<cfset arguments.beanName=variables.transientAlias["#arguments.beanName#"]>
		</cfif>
		
		<cfif structKeyExists(variables.transient,arguments.beanName)>
			<cfif StructKeyExists(application,"configBean") and application.configBean.getValue("duplicateTransients")>
				<cfif not structKeyExists(variables.transientObjects,"#arguments.beanName#")>
					<cfset variables.transientObjects["#arguments.beanName#"]=createObject("component",variables.transient["#arguments.beanName#"]).init()>
				</cfif>
				
				<cfset bean=duplicate(variables.transientObjects["#arguments.beanName#"])>
			<cfelse>
				<cfset bean=createObject("component",variables.transient["#arguments.beanName#"]).init()>
			</cfif>
			
			<cfif arguments.beanName neq "MuraScope">
				<cfset variables.beanInjector.autowire(bean,variables.transient["#arguments.beanName#"])>
			</cfif>
		<cfelse>
			<cfthrow message="The bean '#arguments.beanName#' does not exist" type="coldspring.NoSuchBeanDefinitionException">
		</cfif>
		
		<cfreturn bean>
	</cffunction>
	
	<cffunction name="containsBean" output="false">
		<cfargument name="beanName">
		
		<cfreturn (structKeyExists(variables.transient,arguments.beanName) or structKeyExists(variables.transientAlias,arguments.beanName) or super.containsBean(arguments.beanName))>
	</cffunction>
	  
	
</cfcomponent>