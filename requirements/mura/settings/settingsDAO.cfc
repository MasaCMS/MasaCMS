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
<cfcomponent extends="mura.cfobject" output="false">

<cfsavecontent variable="variables.fieldlist"><cfoutput>siteid,pagelimit,domain,domainAlias,enforcePrimaryDomain,contact,locking,site,mailserverip,mailserverusername,mailserverpassword,emailbroadcaster,emailbroadcasterlimit,extranet,extranetPublicReg,extranetssl,
cache, cacheCapacity, cacheFreeMemoryThreshold, viewdepth,nextn,dataCollection,ExportLocation,
columnCount,primaryColumn,publicSubmission,adManager,columnNames,contactName,contactAddress,contactCity,contactState,contactZip,contactEmail,contactPhone,
publicUserPoolID,PrivateUserPoolID,AdvertiserUserPoolID,displayPoolID,orderno,feedManager,
largeImageHeight, largeImageWidth, smallImageHeight, smallImageWidth, mediumImageHeight, mediumImageWidth,
sendLoginScript, mailingListConfirmScript,publicSubmissionApprovalScript,reminderScript,ExtranetPublicRegNotify,
loginURL,editProfileURL,CommentApprovalDefault,deploy,accountActivationScript,
googleAPIKey,useDefaultSMTPServer,siteLocale, mailServerSMTPPort, mailServerPOPPort, mailserverTLS, mailserverSSL, theme, tagline,hasChangesets,baseID,enforceChangesets</cfoutput></cfsavecontent>

<cffunction name="init" access="public" returntype="any" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="clusterManager" type="any" required="yes"/>
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.clusterManager=arguments.clusterManager />
	<cfreturn this />
</cffunction>

<cffunction name="read" access="public" output="false" returntype="any">
<cfargument name="siteid" type="string" />
<cfargument name="settingsBean" default="" />
	<cfset var rs ="" />
	<cfset var bean=arguments.settingsBean />
	
	<cfif not isObject(bean)>
		<cfset bean=getBean("site")>
	</cfif>s

	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select #variables.fieldlist#, lastdeployment from tsettings where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	<cfif rs.recordcount>
	<cfset bean.set(rs) />
	</cfif>
	
	<cfreturn bean />
	
</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void">
<cfargument name="siteid" type="string" />

	<cftransaction>
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tsettings where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from timagesizes where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tusersinterests where CategoryID in (select categoryID from tcontentcategories where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />)
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tusersfavorites where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tusersmemb where groupID in (select userID from tusers where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" /> and type=1 )
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tuseraddresses where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tusers where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tmailinglist where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tmailinglistmembers where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tpermissions where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tformresponsepackets where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tformresponsequestions where 
	formID in (select contentID from tcontent
				where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
				and type ='Form')
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontent where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentcomments where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tsystemobjects where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentobjects where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentratings where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from temailreturnstats where emailID in (select emailID from temails where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />)
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from temailstats where emailID in (select emailID from temails where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />)
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from temails where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentrelated where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentassignments where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentcategoryassign where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentcategories where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontenteventreminders where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentfeeditems where feedid in (select feedid from tcontentfeeds where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />)
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentfeedadvancedparams where feedid in (select feedid from tcontentfeeds where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />)
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentfeeds where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tsessiontracking where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tsettings set PrivateUserPoolID=siteid where PrivateUserPoolID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tsettings set PublicUserPoolID=siteid where PublicUserPoolID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontenttags where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tclassextenddata where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tclassextendattributes where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tclassextendsets where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tclassextend where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tfiles where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from ttrash where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tchangesets where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	</cftransaction>
	
</cffunction>

<cffunction name="update" access="public" output="false" returntype="void">
<cfargument name="bean" type="any" />

<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      UPDATE tsettings SET
	  	 site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getsite()#" />,
         pagelimit = #arguments.bean.getpagelimit()#,
		 domain=<cfif arguments.bean.getdomain('production') neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getdomain('production'))#" /><cfelse>null</cfif>,
		 domainAlias=<cfif arguments.bean.getdomainAlias() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getdomainAlias())#" /><cfelse>null</cfif>,
		 enforcePrimaryDomain = '#arguments.bean.getEnforcePrimaryDomain()#',
		 contact=<cfif arguments.bean.getcontact() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getContact())#" /><cfelse>null</cfif>,
         locking = '#arguments.bean.getlocking()#',
		 MailServerIP=<cfif arguments.bean.getMailServerIP() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getMailServerIP())#" /><cfelse>null</cfif>,
		 MailServerUsername=<cfif arguments.bean.getMailServerUsername() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getMailserverUsername())#" /><cfelse>null</cfif>,
		 MailServerPassword=<cfif arguments.bean.getMailServerPassword() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getMailserverPassword())#" /><cfelse>null</cfif>,
		 emailbroadcaster=#arguments.bean.getemailbroadcaster()#,
		 emailbroadcasterlimit=#arguments.bean.getemailbroadcasterlimit()#,
		 extranet=#arguments.bean.getextranet()#,
		 extranetPublicReg=#arguments.bean.getextranetPublicReg()#,
		 extranetssl=#arguments.bean.getextranetssl()#,
		 cache=#arguments.bean.getcache()#,
		 cacheCapacity=#arguments.bean.getCacheCapacity()#,
		 cacheFreeMemoryThreshold=#arguments.bean.getCacheFreeMemoryThreshold()#,
		 viewdepth=#arguments.bean.getviewdepth()#,
		 nextn=#arguments.bean.getnextn()#,
		 dataCollection=#arguments.bean.getdataCollection()#,
		 ExportLocation =<cfif arguments.bean.getExportLocation() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getExportLocation())#" /><cfelse>null</cfif>,
		 columnCount=#arguments.bean.getcolumnCount()#,
		 primaryColumn=#arguments.bean.getprimaryColumn()#,
		 publicSubmission=#arguments.bean.getpublicSubmission()#,
		 adManager=#arguments.bean.getadManager()#,
		 columnNames=<cfif arguments.bean.getcolumnNames() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getColumnNames())#" /><cfelse>null</cfif>,
		 contactName=<cfif arguments.bean.getcontactName() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getContactName())#" /><cfelse>null</cfif>,
		 contactAddress=<cfif arguments.bean.getcontactAddress() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getContactAddress())#" /><cfelse>null</cfif>,
		 contactCity=<cfif arguments.bean.getcontactCity() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getContactCity())#" /><cfelse>null</cfif>,
		 contactState=<cfif arguments.bean.getcontactState() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getContactState())#" /><cfelse>null</cfif>,
		 contactZip=<cfif arguments.bean.getcontactZip() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getContactZip())#" /><cfelse>null</cfif>,
		 contactEmail=<cfif arguments.bean.getcontactEmail() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getContactEmail())#" /><cfelse>null</cfif>,
		 contactPhone=<cfif arguments.bean.getcontactPhone() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getContactPhone())#" /><cfelse>null</cfif>,
		 publicUserPoolID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getPublicUserPoolID()#" />,
		 privateUserPoolID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getPrivateUserPoolID()#" />,
		 advertiserUserPoolID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getAdvertiserUserPoolID()#" />,
		 displayPoolID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getDisplayPoolID()#" />,
		 feedManager=#arguments.bean.getHasfeedManager()#,
		 
		largeImageHeight = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getLargeImageHeight()#" />,
		largeImageWidth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getLargeImageWidth()#" />,
		smallImageHeight = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getSmallImageHeight()#" />,
		smallImageWidth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getSmallImageWidth()#" />,
		mediumImageHeight = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getMediumImageHeight()#" />,
		mediumImageWidth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getMediumImageWidth()#" />,
		
		 sendLoginScript=<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.bean.getSendLoginScript() neq '',de('no'),de('yes'))#" value="#arguments.bean.getSendLoginScript()#" />,
		 mailingListConfirmScript=<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.bean.getMailingListConfirmScript() neq '',de('no'),de('yes'))#" value="#arguments.bean.getMailingListConfirmScript()#" />,
		 publicSubmissionApprovalScript=<cfqueryparam  null="#iif(arguments.bean.getPublicSubmissionApprovalScript() neq '',de('no'),de('yes'))#" cfsqltype="cf_sql_longvarchar" value="#arguments.bean.getPublicSubmissionApprovalScript()#" />,
		 reminderScript = <cfqueryparam  null="#iif(arguments.bean.getreminderScript() neq '',de('no'),de('yes'))#" cfsqltype="cf_sql_longvarchar" value="#arguments.bean.getreminderScript()#" />,
		
		 ExtranetPublicRegNotify=<cfqueryparam  null="#iif(arguments.bean.getExtranetPublicRegNotify() neq '',de('no'),de('yes'))#" cfsqltype="cf_sql_longvarchar" value="#arguments.bean.getExtranetPublicRegNotify()#" />,
		 loginURL=<cfqueryparam  null="#iif(arguments.bean.getloginURL() neq '',de('no'),de('yes'))#" cfsqltype="cf_sql_varchar" value="#arguments.bean.getloginURL(parseMuraTag=false)#" />, 
		 editProfileURL=<cfqueryparam  null="#iif(arguments.bean.getEditProfileURL() neq '',de('no'),de('yes'))#" cfsqltype="cf_sql_varchar" value="#arguments.bean.getEditProfileURL(parseMuraTag=false)#" />,
		 CommentApprovalDefault = #arguments.bean.getCommentApprovalDefault()#,
 		 accountActivationScript=<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.bean.getAccountActivationScript() neq '',de('no'),de('yes'))#" value="#arguments.bean.getAccountActivationScript()#" />,
	 	 googleAPIKey=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.bean.getGoogleAPIKey() neq '',de('no'),de('yes'))#" value="#arguments.bean.getGoogleAPIKey()#" />,
	 	 useDefaultSMTPServer=#arguments.bean.getUseDefaultSMTPServer()#,
	 	 siteLocale=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.bean.getSiteLocale() neq '',de('no'),de('yes'))#" value="#arguments.bean.getSiteLocale()#" />,
	 	 mailserverSMTPPort=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.bean.getMailserverSMTPPort() neq '',de('no'),de('yes'))#" value="#arguments.bean.getMailserverSMTPPort()#" />,
	 	 mailserverPOPPort=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.bean.getMailserverPOPPort() neq '',de('no'),de('yes'))#" value="#arguments.bean.getMailserverPOPPort()#" />,
	 	 mailserverTLS=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.bean.getMailserverTLS() neq '',de('no'),de('yes'))#" value="#arguments.bean.getMailserverTLS()#" />,
	 	 mailserverSSL=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.bean.getMailserverSSL() neq '',de('no'),de('yes'))#" value="#arguments.bean.getMailserverSSL()#" />,
	 	 theme= <cfif arguments.bean.getTheme() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getTheme())#" /><cfelse>null</cfif>,
	 	 tagline=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getTagline()#" />,
	 	 hasChangesets=#arguments.bean.getHasChangesets()#,
	 	 baseID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getBaseID()#" />,
	 	 EnforceChangesets=#arguments.bean.getEnforceChangesets()#
		 
		where siteid='#arguments.bean.getsiteid()#'
   </cfquery>
   
	
</cffunction>

<cffunction name="create" access="public" output="false" returntype="void">
<cfargument name="bean" type="any" />

<cfset var rssites="">
<cfset var orderno=1>
<cfset var rsSystemObject="">
<cftransaction>

<cfquery name="rssites" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
 select siteID from tsettings
</cfquery>

<cfset orderno=rssites.recordcount+1>

<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      Insert into tsettings (#variables.fieldlist#)
	  values(
	  	'#arguments.bean.getsiteid()#',
         #arguments.bean.getpagelimit()# ,
		 <cfif arguments.bean.getdomain('production') neq ''>'#trim(arguments.bean.getdomain('production'))#'<cfelse>null</cfif>,
		 <cfif arguments.bean.getdomainAlias() neq ''>'#trim(arguments.bean.getdomainAlias())#'<cfelse>null</cfif>,
		 '#arguments.bean.getEnforcePrimaryDomain()#',
		<cfif arguments.bean.getcontact() neq ''>'#trim(arguments.bean.getcontact())#'<cfelse>null</cfif>,
         '#arguments.bean.getlocking()#',
		   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getsite()#" />,
		  <cfif arguments.bean.getMailServerIP() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getMailServerIP())#" /><cfelse>null</cfif>,
		  <cfif arguments.bean.getMailServerUsername() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getMailserverUsername())#" /><cfelse>null</cfif>,
		  <cfif arguments.bean.getMailServerPassword() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getMailserverPassword())#" /><cfelse>null</cfif>,
		  #arguments.bean.getemailbroadcaster()#,
		  #arguments.bean.getemailbroadcasterlimit()#,
		   #arguments.bean.getextranet()#,
		   #arguments.bean.getextranetPublicReg()#,
		   #arguments.bean.getextranetssl()#,
		   #arguments.bean.getcache()#,
		   #arguments.bean.getCacheCapacity()#,
		   #arguments.bean.getCacheFreeMemoryThreshold()#,
		   #arguments.bean.getviewdepth()#,
		   #arguments.bean.getnextn()#,
		   #arguments.bean.getdataCollection()#,
		   <cfif arguments.bean.getExportLocation() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getExportLocation())#" /><cfelse>null</cfif>,
		   #arguments.bean.getcolumnCount()#,
		  #arguments.bean.getprimaryColumn()#,
		   #arguments.bean.getpublicSubmission()#,
		   #arguments.bean.getadmanager()#,
		   <cfif arguments.bean.getcolumnNames() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getColumnNames())#" /><cfelse>null</cfif>,
		  <cfif arguments.bean.getcontactName() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getContactName())#" /><cfelse>null</cfif>,
		   <cfif arguments.bean.getcontactAddress() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getContactAddress())#" /><cfelse>null</cfif>,
		   <cfif arguments.bean.getcontactCity() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getContactCity())#" /><cfelse>null</cfif>,
		   <cfif arguments.bean.getcontactState() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getContactState())#" /><cfelse>null</cfif>,
		   <cfif arguments.bean.getcontactZip() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getContactZip())#" /><cfelse>null</cfif>,
		   <cfif arguments.bean.getcontactEmail() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getContactEmail())#" /><cfelse>null</cfif>,
		   <cfif arguments.bean.getcontactPhone() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getContactPhone())#" /><cfelse>null</cfif>,
		   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getPublicUserPoolID()#" />,
		   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getPrivateUserPoolID()#" />,
		   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getAdvertiserUserPoolID()#" />,
		   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getDisplayPoolID()#" />,
		   #orderno#,
		   #arguments.bean.getHasfeedManager()#,
		   
		 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getLargeImageHeight()#" />,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getLargeImageWidth()#" />,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getSmallImageHeight()#" />,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getSmallImageWidth()#" />,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getMediumImageHeight()#" />,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getMediumImageWidth()#" />,
	 
		 <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.bean.getSendLoginScript() neq '',de('no'),de('yes'))#" value="#arguments.bean.getSendLoginScript()#" />,
		 <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.bean.getMailingListConfirmScript() neq '',de('no'),de('yes'))#" value="#arguments.bean.getMailingListConfirmScript()#" />,
		 <cfqueryparam  null="#iif(arguments.bean.getPublicSubmissionApprovalScript() neq '',de('no'),de('yes'))#" cfsqltype="cf_sql_longvarchar" value="#arguments.bean.getPublicSubmissionApprovalScript()#" />,
		 <cfqueryparam  null="#iif(arguments.bean.getreminderScript() neq '',de('no'),de('yes'))#" cfsqltype="cf_sql_longvarchar" value="#arguments.bean.getreminderScript()#" />,
		 
		 <cfqueryparam  null="#iif(arguments.bean.getExtranetPublicRegNotify() neq '',de('no'),de('yes'))#" cfsqltype="cf_sql_longvarchar" value="#arguments.bean.getExtranetPublicRegNotify()#" />,
		 <cfqueryparam  null="#iif(arguments.bean.getloginURL() neq '',de('no'),de('yes'))#" cfsqltype="cf_sql_varchar" value="#arguments.bean.getloginURL(parseMuraTag=false)#" />,
		 <cfqueryparam  null="#iif(arguments.bean.getEditProfileURL() neq '',de('no'),de('yes'))#" cfsqltype="cf_sql_varchar" value="#arguments.bean.getEditProfileURL(parseMuraTag=false)#" />,
		 #arguments.bean.getCommentApprovalDefault()#,
		0,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.bean.getAccountActivationScript() neq '',de('no'),de('yes'))#" value="#arguments.bean.getAccountActivationScript()#" />,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.bean.getGoogleAPIKey() neq '',de('no'),de('yes'))#" value="#arguments.bean.getGoogleAPIKey()#" />,
		#arguments.bean.getUseDefaultSMTPServer()#,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.bean.getSiteLocale() neq '',de('no'),de('yes'))#" value="#arguments.bean.getSiteLocale()#" />,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.bean.getMailserverSMTPPort() neq '',de('no'),de('yes'))#" value="#arguments.bean.getMailserverSMTPPort()#" />,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.bean.getMailserverPOPPort() neq '',de('no'),de('yes'))#" value="#arguments.bean.getMailserverPOPPort()#" />,
	 	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.bean.getMailserverTLS() neq '',de('no'),de('yes'))#" value="#arguments.bean.getMailserverTLS()#" />,
	 	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.bean.getMailserverSSL() neq '',de('no'),de('yes'))#" value="#arguments.bean.getMailserverSSL()#" />,
	 	 <cfif arguments.bean.getTheme() neq ''><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.bean.getTheme())#" /><cfelse>null</cfif>,
	 	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getTagline()#" />,
	 	 #arguments.bean.getHasChangesets()#,
	 	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getBaseID()#" />,
	 	 #arguments.bean.getEnforceChangesets()#
		   )
   </cfquery>
  
 
   <cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      Insert into tcontent (siteid,moduleid,parentid,contentid,contenthistid,type,subType,active,title,display,approved,isnav,forceSSL)
	  values(
	  '#arguments.bean.getsiteid()#',
	  '00000000000000000000000000000000003',
	  '00000000000000000000000000000000END',
	  '00000000000000000000000000000000003',
	  '#createuuid()#',
	  'Module',
	  'Default',
	  1,
	  'Component Manager',
	  1,
	  1,
	  1,
	  0
	)
   </cfquery>
      <cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      Insert into tcontent (siteid,moduleid,parentid,contentid,contenthistid,type,subType,active,title,display,approved,isnav ,forceSSL,searchExclude)
	  values(
	  '#arguments.bean.getsiteid()#',
	  '00000000000000000000000000000000004',
	  '00000000000000000000000000000000END',
	  '00000000000000000000000000000000004',
	  '#createuuid()#',
	  'Module',
	  'Default',
	  1,
	  'Forms Manager',
	  1,
	  1,
	  1,
	  0,
	  0
	)
   </cfquery>
   <cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      Insert into tcontent (siteid,moduleid,parentid,contentid,contenthistid,type,subType,active,title,menutitle,display,approved,isnav,
	  template,orderno,lastupdate,lastupdateby,
	  restricted,responseChart,displayTitle,isFeature,isLocked,NextN,inheritObjects,sortBy,sortDirection,forceSSL,searchExclude,path,created)
	  values(
	  '#arguments.bean.getsiteid()#',
	  '00000000000000000000000000000000000',
	  '00000000000000000000000000000000END',
	  '00000000000000000000000000000000001',
	  '#createuuid()#',
	  'Page',
	  'Default',
	  1,
	  'Home',
	  'Home',
	  1,
	  1,
	  1,
	  'default.cfm',
	  1,
	  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
	  'System',
	  0,
	  0,
	  0,
	  0,
	  0,
	  10,
	  'Cascade',
	  'orderno',
	  'asc',
	  0,
	  0,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="00000000000000000000000000000000001" />,
	  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
	)
   </cfquery>
   
      <cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      Insert into tcontent (siteid,moduleid,parentid,contentid,contenthistid,type,subType,active,title,display,approved,isnav ,forceSSL,searchExclude)
	  values(
	  '#arguments.bean.getsiteid()#',
	  '00000000000000000000000000000000006',
	  '00000000000000000000000000000000END',
	  '00000000000000000000000000000000006',
	  '#createuuid()#',
	  'Module',
	  'Default',
	  1,
	  'Advertisement Manager',
	  1,
	  1,
	  1,
	  0,
	  0
	)
   </cfquery>
   
   <cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      Insert into tcontent (siteid,moduleid,parentid,contentid,contenthistid,type,subType,active,title,display,approved,isnav ,forceSSL,searchExclude)
	  values(
	  '#arguments.bean.getsiteid()#',
	  '00000000000000000000000000000000000',
	  '00000000000000000000000000000000END',
	  '00000000000000000000000000000000000',
	  '#createuuid()#',
	  'Module',
	  'Default',
	  1,
	  'Content Manager',
	  1,
	  1,
	  1,
	  0,
	  0
	)
   </cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      Insert into tcontent (siteid,moduleid,parentid,contentid,contenthistid,type,subType,active,title,display,approved,isnav ,forceSSL,searchExclude)
	  values(
	  '#arguments.bean.getsiteid()#',
	  '00000000000000000000000000000000008',
	  '00000000000000000000000000000000END',
	  '00000000000000000000000000000000008',
	  '#createuuid()#',
	  'Module',
	  'Default',
	  1,
	  'Public User Manager',
	  1,
	  1,
	  1,
	  0,
	  0
	)
   </cfquery>
	
	   
   <cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      Insert into tcontent (siteid,moduleid,parentid,contentid,contenthistid,type,subType,active,title,display,approved,isnav,forceSSL,searchExclude )
	  values(
	  '#arguments.bean.getsiteid()#',
	  '00000000000000000000000000000000005',
	  '00000000000000000000000000000000END',
	  '00000000000000000000000000000000005',
	  '#createuuid()#',
	  'Module',
	  'Default',
	  1,
	  'Email Broadcaster',
	  1,
	  1,
	  1,
	  0,
	  0
	)
   </cfquery>
   
   <cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      Insert into tcontent (siteid,moduleid,parentid,contentid,contenthistid,type,subType,active,title,display,approved,isnav ,forceSSL,searchExclude)
	  values(
	  '#arguments.bean.getsiteid()#',
	  '00000000000000000000000000000000009',
	  '00000000000000000000000000000000END',
	  '00000000000000000000000000000000009',
	  '#createuuid()#',
	  'Module',
	  'Default',
	  1,
	  'Mailing List Manager',
	  1,
	  1,
	  1,
	  0,
	  0
	)
   </cfquery>

   <cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      Insert into tcontent (siteid,moduleid,parentid,contentid,contenthistid,type,subType,active,title,display,approved,isnav ,forceSSL,searchExclude)
	  values(
	  '#arguments.bean.getsiteid()#',
	  '00000000000000000000000000000000010',
	  '00000000000000000000000000000000END',
	  '00000000000000000000000000000000010',
	  '#createuuid()#',
	  'Module',
	  'Default',
	  1,
	  'Category Manager',
	  1,
	  1,
	  1,
	  0,
	  0
	)
   </cfquery>
   
      <cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      Insert into tcontent (siteid,moduleid,parentid,contentid,contenthistid,type,subType,active,title,display,approved,isnav,forceSSL,searchExclude )
	  values(
	  '#arguments.bean.getsiteid()#',
	  '00000000000000000000000000000000011',
	  '00000000000000000000000000000000END',
	  '00000000000000000000000000000000011',
	  '#createuuid()#',
	  'Module',
	  'Default',
	  1,
	  'Content Collections Manager',
	  1,
	  1,
	  1,
	  0,
	  0
	)
   </cfquery>
   
   
   <cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      Insert into tcontent (siteid,moduleid,parentid,contentid,contenthistid,type,subType,active,title,display,approved,isnav ,forceSSL,searchExclude)
	  values(
	  '#arguments.bean.getsiteid()#',
	  '00000000000000000000000000000000012',
	  '00000000000000000000000000000000END',
	  '00000000000000000000000000000000012',
	  '#createuuid()#',
	  'Module',
	  'Default',
	  1,
	  'Filemanager Manager',
	  1,
	  1,
	  1,
	  0,
	  0
	)
   </cfquery>

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      Insert into tcontent (siteid,moduleid,parentid,contentid,contenthistid,type,subType,active,title,display,approved,isnav ,forceSSL,searchExclude)
	  values(
	  '#arguments.bean.getsiteid()#',
	  '00000000000000000000000000000000014',
	  '00000000000000000000000000000000END',
	  '00000000000000000000000000000000014',
	  '#createuuid()#',
	  'Module',
	  'Default',
	  1,
	  'Change Sets Manager',
	  1,
	  1,
	  1,
	  0,
	  0
	)
   </cfquery>
   
   <cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#" name="rsSystemObject">
      select * from tsystemobjects where siteid = 'default'
   	</cfquery>
	
	<cfloop query="rsSystemObject">
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		  Insert into tsystemobjects (object,siteid,name,orderno)
		  values(
		  '#rsSystemObject.object#',
		  '#arguments.bean.getsiteid()#',
		  '#rsSystemObject.name#',
		  #rsSystemObject.orderno#
			)
		</cfquery>
	</cfloop>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      Insert into tmailinglist (mlid,name,lastupdate,siteid,ispurge,ispublic)
	  values(
	  '#createUUID()#',
	  'Master Do Not Email List',
	  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
	  '#arguments.bean.getsiteid()#',
	  1,
	  1
	)
   	</cfquery>

 <cfquery  datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
        INSERT INTO tusers  (UserID, s2, Fname, Lname, Password, Email, GroupName, Type, subType, ContactForm, LastUpdate, lastupdateby, lastupdatebyid, InActive, username,  perm, isPublic,
		company,jobtitle,subscribe,siteid,website,notes,keepPrivate,created)
     VALUES(
         '#createUUID()#',
		 0, 
		 null,
		 null, 
         null,
		 null,
         'Admin', 
         1,
		'Default',
        null,
		 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		'System',
		 null,
		0,
		 null,
		  1,
		 0,
		  null,
		  null, 
		  0,
		 '#arguments.bean.getSiteID()#',
		  null,
		  null,
		  0,
		  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
		 
   </cfquery>

  </cftransaction>
  	
</cffunction>

</cfcomponent>