<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfsavecontent variable="servicesXML"><cfoutput><beans>
		<bean id="utility" class="#mapdir#.utility" singleton="true" >
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="configBean" class="#mapdir#.configBean" singleton="true" >
			<constructor-arg name="config">
				<map>
				<entry key="mode">
					<value>#XMLFormat(variables.mode)#</value>
				</entry>
				<entry key="mapdir">
					<value>#XMLFormat(variables.mapdir)#</value>
				</entry>
				<entry key="version">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "version"))#</value>
				</entry>
				<entry key="title">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "title"))#</value>
				</entry>
				<entry key="webroot">
					<value>#XMLFormat(variables.webroot)#</value>
				</entry>
				<entry key="webrootmap">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "webrootmap"))#</value>
				</entry>
				<entry key="datasource">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "datasource"))#</value>
				</entry>
				<entry key="context">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "context"))#</value>
				</entry>
				<entry key="stub">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "stub"))#</value>
				</entry>
				<entry key="admindomain">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "admindomain"))#</value>
				</entry>
				<entry key="indexfile">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "indexfile"))#</value>
				</entry>
				<entry key="adminemail">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "adminemail"))#</value>
				</entry>
				<entry key="mailServerIP">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "mailServerIP"))#</value>
				</entry>
				<entry key="mailserverusername">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "mailserverusername"))#</value>
				</entry>
				<entry key="mailserverpassword">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "mailserverpassword"))#</value>
				</entry>
				<entry key="mailserversmtpport">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "mailserversmtpport"))#</value>
				</entry>
				<entry key="mailserverpoppport">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "mailserverpopport"))#</value>
				</entry>
				<entry key="mailservertls">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "mailservertls"))#</value>
				</entry>
				<entry key="mailserverssl">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "mailserverssl"))#</value>
				</entry>
				<entry key="adminssl">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "adminssl"))#</value>
				</entry>
				<entry key="logEvents">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "logEvents"))#</value>
				</entry>
				<entry key="dbType">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "dbType"))#</value>
				</entry>
				<entry key="dbPassword">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "dbPassword"))#</value>
				</entry>
				<entry key="dbUsername">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "dbUsername"))#</value>
				</entry>
				<entry key="debuggingEnabled">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "debuggingEnabled"))#</value>
				</entry>
				<entry key="port">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "port"))#</value>
				</entry>
				<entry key="fileDir">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "filedir"))#</value>
				</entry>
				<entry key="assetPath">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "assetpath"))#</value>
				</entry>
				<entry key="productionAssetPath">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "productionassetpath"))#</value>
				</entry>
				<entry key="ProductionWebroot">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "ProductionWebroot"))#</value>
				</entry>
				<entry key="ProductionDatasource">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "ProductionDatasource"))#</value>
				</entry>
				<entry key="ProductionFiledir">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "ProductionFiledir"))#</value>
				</entry>
				<entry key="fileStore">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "fileStore"))#</value>
				</entry>
				<entry key="fileStoreAccessInfo">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "fileStoreAccessInfo"))#</value>
				</entry>
				<entry key="sessionHistory">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "sessionHistory"))#</value>
				</entry>
				<entry key="locale">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "locale"))#</value>
				</entry>
				<entry key="useDefaultSMTPServer">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "useDefaultSMTPServer"))#</value>
				</entry>
				<entry key="imageInterpolation">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "imageInterpolation"))#</value>
				</entry>
				<entry key="clusterIPList">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "clusterIPList"))#</value>
				</entry>
				<entry key="enableMuraTag">
					<value>#XMLFormat(GetProfileString("#variables.iniPath#", mode, "enableMuraTag"))#</value>
				</entry>
				<entry key="appreloadKey">
					<value>#XMLFormat(application.appreloadKey)#</value>
				</entry>
				</map>
			</constructor-arg>
		</bean>
		<bean id="contentRenderer" class="mura.content.contentRenderer"  singleton="false" />
		<bean id="contentManager" class="mura.content.contentManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="contentGateway"><ref bean="contentGateway" /></constructor-arg>
			<constructor-arg name="contentDAO"><ref bean="contentDAO" /></constructor-arg>
			<constructor-arg name="contentUtility"><ref bean="contentUtility" /></constructor-arg>
			<constructor-arg name="reminderManager"><ref bean="reminderManager" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
			<constructor-arg name="utility"><ref bean="utility" /></constructor-arg>
			<constructor-arg name="categoryManager"><ref bean="categoryManager" /></constructor-arg>
			<constructor-arg name="fileManager"><ref bean="fileManager" /></constructor-arg>
			<constructor-arg name="pluginManager"><ref bean="pluginManager" /></constructor-arg>
		</bean>
		<bean id="contentGateway" class="mura.content.contentGateway" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
		</bean>
		<bean id="contentDAO" class="mura.content.contentDAO" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
		</bean>
		<bean id="contentUtility" class="mura.content.contentUtility" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="contentDAO"><ref bean="contentDAO" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
			<constructor-arg name="permUtility"><ref bean="permUtility" /></constructor-arg>
			<constructor-arg name="fileManager"><ref bean="fileManager" /></constructor-arg>
			<constructor-arg name="contentRenderer"><ref bean="contentRenderer" /></constructor-arg>
			<property name="mailer">
			    <ref bean="mailer"/>
			</property>
		</bean>
		<bean id="contentBean" class="mura.content.contentBean" singleton="false" >
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="fileManager" class="mura.content.file.fileManager" singleton="true" >
			<constructor-arg name="fileDAO"><ref bean="fileDAO" /></constructor-arg>
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
		</bean>
		<bean id="fileDAO" class="mura.content.file.fileDAO" singleton="true" >
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
			<constructor-arg name="pluginManager"><ref bean="pluginManager" /></constructor-arg>
		</bean>
		<bean id="image" class="mura.content.file.imagecfc.image" singleton="false" />
		<bean id="reminderManager" class="mura.content.reminder.reminderManager" singleton="true">
			<constructor-arg name="reminderGateway"><ref bean="reminderGateway" /></constructor-arg>
			<constructor-arg name="reminderDAO"><ref bean="reminderDAO" /></constructor-arg>
			<constructor-arg name="reminderUtility"><ref bean="reminderUtility" /></constructor-arg>
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="reminderGateway" class="mura.content.reminder.reminderGateway" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="reminderDAO" class="mura.content.reminder.reminderDAO" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="reminderUtility" class="mura.content.reminder.reminderUtility" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
			<constructor-arg name="contentRenderer"><ref bean="contentRenderer" /></constructor-arg>
			<property name="mailer"> 			   
				<ref bean="mailer"/>
			</property>
		</bean>
		<bean id="reminderBean" class="mura.content.reminder.reminderBean" singleton="false" />
		<bean id="permUtility" class="mura.permission" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
		</bean>
		<bean id="mailer" <cfif StructKeyExists(SERVER,"bluedragon") or (server.coldfusion.productname eq "ColdFusion Server" and listFirst(server.coldfusion.productversion) lt 8) or (server.coldfusion.productname eq "Railo" and listFirst(server.railo.version,".") lt 3)>class="mura.mailerLimited"<cfelse>class="mura.mailer"</cfif> singleton="true" >
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
			<constructor-arg name="contentRenderer"><ref bean="contentRenderer" /></constructor-arg>
		</bean>
		<bean id="dataCollectionManager" class="mura.content.dataCollection.dataCollectionManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
			<constructor-arg name="fileManager"><ref bean="fileManager" /></constructor-arg>
		</bean>
		<bean id="categoryManager" class="mura.category.categoryManager" singleton="true">
			<constructor-arg name="categoryGateway"><ref bean="categoryGateway" /></constructor-arg>
			<constructor-arg name="categoryDAO"><ref bean="categoryDAO" /></constructor-arg>
			<constructor-arg name="utility"><ref bean="utility" /></constructor-arg>
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="categoryUtility"><ref bean="categoryUtility" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
		</bean>
		<bean id="categoryDAO" class="mura.category.categoryDAO" singleton="true" >
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="categoryGateway" class="mura.category.categoryGateway" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
		</bean>
		<bean id="categoryUtility" class="mura.category.categoryUtility" singleton="true">
			<constructor-arg name="categoryGateway"><ref bean="categoryGateway" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="categoryBean" class="mura.category.categoryBean"  singleton="false" />
		<bean id="settingsManager" class="mura.settings.settingsManager" singleton="true">
			<constructor-arg name="settingsGateway"><ref bean="settingsGateway" /></constructor-arg>
			<constructor-arg name="settingsDAO"><ref bean="settingsDAO" /></constructor-arg>
			<constructor-arg name="utility"><ref bean="utility" /></constructor-arg>
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="clusterManager"><ref bean="clusterManager" /></constructor-arg>
		</bean>
		<bean id="settingsGateway" class="mura.settings.settingsGateway" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="settingsDAO" class="mura.settings.settingsDAO" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="clusterManager"><ref bean="clusterManager" /></constructor-arg>
			<constructor-arg name="javaLoader"><ref bean="javaLoader" /></constructor-arg>
		</bean>
		<bean id="settingsBean" class="mura.settings.settingsBean" singleton="false">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="clusterManager"><ref bean="clusterManager" /></constructor-arg>
		</bean>
		<bean id="userManager" class="mura.user.userManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="userDAO"><ref bean="userDAO" /></constructor-arg>
			<constructor-arg name="userGateway"><ref bean="userGateway" /></constructor-arg>
			<constructor-arg name="userUtility"><ref bean="userUtility" /></constructor-arg>
			<constructor-arg name="utility"><ref bean="utility" /></constructor-arg>
			<constructor-arg name="fileManager"><ref bean="fileManager" /></constructor-arg>
			<constructor-arg name="pluginManager"><ref bean="pluginManager" /></constructor-arg>
		</bean>
		<bean id="userDAO" class="mura.user.userDAO" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
		</bean>
		<bean id="userUtility" class="mura.user.userUtility" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="utility"><ref bean="utility" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
			<constructor-arg name="userDAO"><ref bean="userDAO" /></constructor-arg>
			<property name="mailer"> 			    
				<ref bean="mailer"/> 		
			</property>
			<constructor-arg name="pluginManager"><ref bean="pluginManager" /></constructor-arg>
		</bean>
		<bean id="userGateway" class="mura.user.userGateway" singleton="true" >
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
		</bean>
		<bean id="userBean" class="mura.user.userBean"  singleton="false">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
			<constructor-arg name="geoCoding"><ref bean="geoCoding" /></constructor-arg>
		</bean>
		<bean id="addressBean" class="mura.user.addressBean"  singleton="false">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
			<constructor-arg name="geoCoding"><ref bean="geoCoding" /></constructor-arg>
		</bean>
		<bean id="loginManager" class="mura.login.loginManager" singleton="true" >
			<constructor-arg name="userUtility"><ref bean="userUtility" /></constructor-arg>
			<constructor-arg name="userDAO"><ref bean="userDAO" /></constructor-arg>
			<constructor-arg name="utility"><ref bean="utility" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
			<constructor-arg name="permUtility"><ref bean="permUtility" /></constructor-arg>
			<constructor-arg name="sessionTrackingManager"><ref bean="sessionTrackingManager" /></constructor-arg>
		</bean>
		<bean id="mailinglistManager" class="mura.mailinglist.mailinglistManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="mailinglistDAO"><ref bean="mailinglistDAO" /></constructor-arg>
			<constructor-arg name="mailinglistGateway"><ref bean="mailinglistGateway" /></constructor-arg>
			<constructor-arg name="mailinglistUtility"><ref bean="mailinglistUtility" /></constructor-arg>
			<constructor-arg name="memberManager"><ref bean="memberManager" /></constructor-arg>
			<constructor-arg name="utility"><ref bean="utility" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
		</bean>
		<bean id="mailinglistBean" class="mura.mailinglist.mailinglistBean" singleton="false" />
		<bean id="memberBean" class="mura.mailinglist.memberBean" singleton="false" />
		<bean id="mailinglistDAO" class="mura.mailinglist.mailinglistDAO" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="mailinglistGateway" class="mura.mailinglist.mailinglistGateway" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="mailinglistUtility" class="mura.mailinglist.mailinglistUtility" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
			<bean id="memberManager" class="mura.mailinglist.memberManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="memberDAO"><ref bean="memberDAO" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
			<constructor-arg name="contentRenderer"><ref bean="contentRenderer" /></constructor-arg>
			<property name="mailer"> 			   
				<ref bean="mailer"/> 		
			</property>
		</bean>
		<bean id="memberDAO" class="mura.mailinglist.memberDAO" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="emailManager" class="mura.email.emailManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="emailDAO"><ref bean="emailDAO" /></constructor-arg>
			<constructor-arg name="emailGateway"><ref bean="emailGateway" /></constructor-arg>
			<constructor-arg name="emailUtility"><ref bean="emailUtility" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
			<constructor-arg name="utility"><ref bean="utility" /></constructor-arg>
		</bean>
		<bean id="emailDAO" class="mura.email.emailDAO" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="emailGateway" class="mura.email.emailGateway" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="emailUtility" class="mura.email.emailUtility" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="utility"><ref bean="utility" /></constructor-arg>
			<constructor-arg name="mailinglistManager"><ref bean="mailinglistManager" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
			<constructor-arg name="contentRenderer"><ref bean="contentRenderer" /></constructor-arg>
			<property name="mailer"> 			    
				<ref bean="mailer"/> 			
			</property>
		</bean>
		<bean id="emailBean" class="mura.email.emailBean" singleton="false" />
		<bean id="advertiserManager" class="mura.advertising.advertiserManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="advertiserGateway"><ref bean="advertiserGateway" /></constructor-arg>
			<constructor-arg name="campaignManager"><ref bean="campaignManager" /></constructor-arg>
			<constructor-arg name="adZoneManager"><ref bean="adZoneManager" /></constructor-arg>
			<constructor-arg name="creativeManager"><ref bean="creativeManager" /></constructor-arg>
			<constructor-arg name="advertiserRenderer"><ref bean="advertiserRenderer" /></constructor-arg>
			<constructor-arg name="advertiserUtility"><ref bean="advertiserUtility" /></constructor-arg>
			<constructor-arg name="utility"><ref bean="utility" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
		</bean>
		<bean id="advertiserGateway" class="mura.advertising.advertiserGateway" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
		</bean>
		<bean id="advertiserRenderer" class="mura.advertising.advertiserRenderer" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="advertiserUtility" class="mura.advertising.advertiserUtility" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="advertiserGateway"><ref bean="advertiserGateway" /></constructor-arg>
		</bean>
		<bean id="campaignManager" class="mura.advertising.campaign.campaignManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="campaignGateway"><ref bean="campaignGateway" /></constructor-arg>
			<constructor-arg name="campaignDAO"><ref bean="campaignDAO" /></constructor-arg>
			<constructor-arg name="placementManager"><ref bean="placementManager" /></constructor-arg>
			<constructor-arg name="utility"><ref bean="utility" /></constructor-arg>
		</bean>
		<bean id="campaignGateway" class="mura.advertising.campaign.campaignGateway" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="campaignDAO" class="mura.advertising.campaign.campaignDAO" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="campaignBean" class="mura.advertising.campaign.campaignBean" singleton="false" />
		<bean id="placementManager" class="mura.advertising.campaign.placement.placementManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="placementGateway"><ref bean="placementGateway" /></constructor-arg>
			<constructor-arg name="placementDAO"><ref bean="placementDAO" /></constructor-arg>
			<constructor-arg name="utility"><ref bean="utility" /></constructor-arg>
		</bean>
		<bean id="placementGateway" class="mura.advertising.campaign.placement.placementGateway" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="placementDAO" class="mura.advertising.campaign.placement.placementDAO" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="placementBean" class="mura.advertising.campaign.placement.placementBean" singleton="false" />
		<bean id="adZoneManager" class="mura.advertising.adZone.adZoneManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="adZoneGateway"><ref bean="adZoneGateway" /></constructor-arg>
			<constructor-arg name="adZoneDAO"><ref bean="adZoneDAO" /></constructor-arg>
			<constructor-arg name="utility"><ref bean="utility" /></constructor-arg>
		</bean>
		<bean id="adZoneGateway" class="mura.advertising.adZone.adZoneGateway" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
		</bean>
		<bean id="adZoneDAO" class="mura.advertising.adZone.adZoneDAO" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="adZoneBean" class="mura.advertising.adZone.adZoneBean" singleton="false" />
		<bean id="creativeManager" class="mura.advertising.creative.creativeManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="creativeGateway"><ref bean="creativeGateway" /></constructor-arg>
			<constructor-arg name="creativeDAO"><ref bean="creativeDAO" /></constructor-arg>
			<constructor-arg name="utility"><ref bean="utility" /></constructor-arg>
			<constructor-arg name="fileManager"><ref bean="fileManager" /></constructor-arg>
		</bean>
		<bean id="creativeGateway" class="mura.advertising.creative.creativeGateway" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="creativeDAO" class="mura.advertising.creative.creativeDAO" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="creativeBean" class="mura.advertising.creative.creativeBean" singleton="false" />
		<bean id="feedManager" class="mura.content.feed.feedManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="feedGateway"><ref bean="feedGateway" /></constructor-arg>
			<constructor-arg name="feedDAO"><ref bean="feedDAO" /></constructor-arg>
			<constructor-arg name="utility"><ref bean="utility" /></constructor-arg>
			<constructor-arg name="feedUtility"><ref bean="feedUtility" /></constructor-arg>
			<constructor-arg name="pluginManager"><ref bean="pluginManager" /></constructor-arg>
		</bean>
		<bean id="feedGateway" class="mura.content.feed.feedGateway" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="feedDAO" class="mura.content.feed.feedDAO" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="feedUtility" class="mura.content.feed.feedUtility" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="feedDAO"><ref bean="feedDAO" /></constructor-arg>
			<constructor-arg name="utility"><ref bean="utility" /></constructor-arg>
			<constructor-arg name="contentManager"><ref bean="contentManager" /></constructor-arg>
		</bean>
		<bean id="feedBean" class="mura.content.feed.feedBean" singleton="false" />
		<bean id="sessionTrackingManager" class="mura.user.sessionTracking.sessionTrackingManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
			<constructor-arg name="sessionTrackingDAO"><ref bean="sessionTrackingDAO" /></constructor-arg>
			<constructor-arg name="sessionTrackingGateway"><ref bean="sessionTrackingGateway" /></constructor-arg>
		</bean>
		<bean id="sessionTrackingDAO" class="mura.user.sessionTracking.sessionTrackingDAO" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
		</bean>
		<bean id="sessionTrackingGateway" class="mura.user.sessionTracking.sessionTrackingGateway" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
		</bean>
		<bean id="favoriteManager" class="mura.content.favorite.favoriteManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
		</bean>
		<bean id="raterManager" class="mura.content.rater.raterManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
		</bean>
		<bean id="dashboardManager" class="mura.dashboard.dashboardManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="advertiserGateway"><ref bean="advertiserGateway" /></constructor-arg>
			<constructor-arg name="userGateway"><ref bean="userGateway" /></constructor-arg>
			<constructor-arg name="contentGateway"><ref bean="contentGateway" /></constructor-arg>
			<constructor-arg name="sessionTrackingGateway"><ref bean="sessionTrackingGateway" /></constructor-arg>
			<constructor-arg name="emailGateway"><ref bean="emailGateway" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
			<constructor-arg name="raterManager"><ref bean="raterManager" /></constructor-arg>
			<constructor-arg name="feedGateway"><ref bean="feedGateway" /></constructor-arg>
		</bean>
		<bean id="publisher" class="mura.publisher" singleton="true"/>
		<bean id="projectManager" class="mura.workspace.project.projectManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
			<constructor-arg name="fileManager"><ref bean="fileManager" /></constructor-arg>
		</bean>
		<bean id="servlet" class="mura.servlet" singleton="false" />
		<bean id="geoCoding" class="mura.geoCoding.googleGeoCode" singleton="true" />
		<bean id="resourceBundleFactory" class="mura.resourceBundle.resourceBundleFactory" singleton="true" />
		<bean id="pluginManager" class="mura.plugin.pluginManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
			<constructor-arg name="settingsManager"><ref bean="settingsManager" /></constructor-arg>
			<constructor-arg name="utility"><ref bean="utility" /></constructor-arg>
			<constructor-arg name="genericManager"><ref bean="genericManager" /></constructor-arg>
		</bean>
		<bean id="clusterManager" class="mura.cluster.clusterManager" singleton="true">
			<constructor-arg name="configBean"><ref bean="configBean" /></constructor-arg>
		</bean>
		<bean id="genericManager" class="mura.generic.genericManager" singleton="true" />
		<bean id="contentServer" class="mura.content.contentServer" singleton="true" />
		<bean id="javaLoader" class="mura.javaloader.javaLoader" singleton="true">
			<constructor-arg name="loadPaths">
				<list>
					<value>#expandPath('/mura')#/cache/java/FactoryClasses.jar</value>
				</list>
			</constructor-arg>
		</bean>
		<cfinclude template="coldspring.custom.xml.cfm">
	</beans></cfoutput>
	</cfsavecontent>