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
<cfcomponent output="false" extend="mura.cfobject">

	
	<cfset variables.beans=structNew()>
	<cfset variables.beans["contentBean"]="mura.content.contentBean"/>
	<cfset variables.beans["contentNavBean"]="mura.content.contentNavBean"/>
	<cfset variables.beans["contentStatsBean"]="mura.content.contentStatsBean"/>
	<cfset variables.beans["contentIterator"]="mura.content.contentIterator"/>
	<cfset variables.beans["contentCommentIterator"]="mura.content.contentCommentIterator"/>
	<cfset variables.beans["contentCommentBean"]="mura.content.contentCommentBean"/>	
	<cfset variables.beans["httpSession"]="mura.client.httpSession"/>
	<cfset variables.beans["MuraScope"]="mura.MuraScope">
	<cfset variables.beans["changesetBean"]="mura.content.changeset.changesetBean"/>
	<cfset variables.beans["changesetIterator"]="mura.content.changeset.changesetIterator"/>
	<cfset variables.beans["extendObjectIterator"]="mura.extend.extendObjectIterator"/>
	<cfset variables.beans["extendObject"]="mura.extend.extendObject"/>
	<cfset variables.beans["extendObjectFeedBean"]="mura.extend.extendObjectFeedBean"/>
	<cfset variables.beans["pluginScriptBean"]="mura.plugin.pluginScriptBean"/>
	<cfset variables.beans["pluginDisplayObjectBean"]="mura.plugin.pluginDisplayObjectBean"/>		
	<cfset variables.beans["pluginSettingBean"]="mura.plugin.pluginSettingBean"/>
	<cfset variables.beans["changesetBean"]="mura.content.changeset.changesetBean"/>
	<cfset variables.beans["changesetIterator"]="mura.content.changeset.changesetIterator"/>
	<cfset variables.beans["rateBean"]="mura.content.rater.rateBean"/>
	<cfset variables.beans["servlet"]="mura.servlet" />
	<cfset variables.beans["favoriteBean"]="mura.content.favorite.favoriteBean"/>
	<cfset variables.beans["creativeBean"]="mura.advertising.creative.creativeBean" />
	<cfset variables.beans["image"]="mura.content.file.imagecfc.image" />
	<cfset variables.beans["adZoneBean"]="mura.advertising.adZone.adZoneBean" />
	<cfset variables.beans["reminderBean"]="mura.content.reminder.reminderBean" />
	<cfset variables.beans["contentRenderer"]="mura.content.contentRenderer"  />
	<cfset variables.beans["categoryIterator"]="mura.category.categoryIterator"/>
	<cfset variables.beans["categoryBean"]="mura.category.categoryBean" />
	<cfset variables.beans["settingsBean"]="mura.settings.settingsBean"/>
	<cfset variables.beans["settingsBundle"]="mura.settings.settingsBundle"/>
	<cfset variables.beans["userIterator"]="mura.user.userIterator"/>
	<cfset variables.beans["userFeedBean"]="mura.user.userFeedBean"/>
	<cfset variables.beans["addressIterator"]="mura.user.addressIterator"/>
	<cfset variables.beans["userBean"]="mura.user.userBean" />
	<cfset variables.beans["addressBean"]="mura.user.addressBean" />
	<cfset variables.beans["mailinglistBean"]="mura.mailinglist.mailinglistBean" />
	<cfset variables.beans["memberBean"]="mura.mailinglist.memberBean" />
	<cfset variables.beans["emailBean"]="mura.email.emailBean" />
	<cfset variables.beans["campaignBean"]="mura.advertising.campaign.campaignBean" />
	<cfset variables.beans["placementBean"]="mura.advertising.campaign.placement.placementBean" />
	<cfset variables.beans["feedBean"]="mura.content.feed.feedBean"/>
	<cfset variables.alias["content"]="contentBean"/>
	<cfset variables.alias["feed"]="feedBean"/>
	<cfset variables.alias["site"]="settingsBean"/>
	<cfset variables.alias["user"]="userBean"/>
	<cfset variables.alias["group"]="userBean"/>
	<cfset variables.alias["address"]="addressBean"/>
	<cfset variables.alias["category"]="categoryBean"/>
	<cfset variables.alias["userFeed"]="userFeedBean"/>
	<cfset variables.alias["comment"]="contentCommentBean"/>
	<cfset variables.alias["stats"]="contentStatsBean"/>
	<cfset variables.alias["changeset"]="changesetBean"/>
	<cfset variables.alias["bundle"]="settingsBundle"/>
	<cfset variables.alias["mailingList"]="mailingListBean"/>
	<cfset variables.alias["mailingListMember"]="memberBean"/>
	<cfset variables.alias["groupDAO"]="userDAO"/>
	<cfset variables.alias["placement"]="placementBean"/>
	<cfset variables.alias["creative"]="creativeBean"/>
	<cfset variables.alias["rate"]="rateBean"/>
	<cfset variables.alias["favorite"]="favoriteBean"/>
	<cfset variables.alias["campaign"]="campaignBean"/>
	<cfset variables.alias["email"]="emailBean"/>
	
	<cffunction name="init" output="false">
		<cfargument name="parentFactory">
		
		<cfset variables.parentFactory=arguments.parentFactory>
		<cfset variables.beanInjector=variables.parentFactory.getBean("beanInjector")>	
		<cfreturn this>
		
	</cffunction>
	
	<cffunction name="getBean" outout="false">
		<cfargument name="beanName">
		<cfset var bean="">
		
		<cfif variables.parentFactory.containsBean(arguments.beanName)>
			<cfset bean=variables.parentFactory.getBean(arguments.beanName)>
		<cfelseif structKeyExists(variables.alias,arguments.beanName)>
			<cfset arguments.beanName=variables.alias["#arguments.beanName#"]>
			<cfset bean=createObject("component",variables.beans["#arguments.beanName#"]).init()>
			<cfset variables.beanInjector.autowire(bean,variables.beans["#arguments.beanName#"])>
		<cfelseif structKeyExists(variables.beans,arguments.beanName)>
			<cfset bean=createObject("component",variables.beans[arguments.beanName]).init()>
			<cfif arguments.beanName neq "MuraScope">
				<cfset variables.beanInjector.autowire(bean,variables.beans[arguments.beanName])>
			</cfif>
		<cfelse>
			<cfthrow message="The bean '#arguments.beanName#' does not exist">
		</cfif>
		
		<cfreturn bean>
	</cffunction>
	
	<cffunction name="containsBean" output="false">
		<cfargument name="beanName">
		
		<cfreturn (structKeyExists(variables.beans,arguments.beanName) or structKeyExists(variables.alias,arguments.beanName) or variables.parentFactory.containsBean(arguments.beanName))>
	</cffunction>
	
</cfcomponent>