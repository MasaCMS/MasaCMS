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

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfsilent>
 <cfset rsThemes=request.siteBean.getThemes() />
 <cfset rsSites=application.settingsManager.getList() />
 <cfparam name="attributes.action" default="">
</cfsilent>
<h2>Site Settings</h2>
<cfoutput>
<cfif len(attributes.siteid)>
<ul id="navTask">
<li><a href="index.cfm?fuseaction=cExtend.listSubTypes&siteid=#URLEncodedFormat(attributes.siteid)#">Class Extension Manager</a></li>
<li><a href="index.cfm?fuseaction=cTrash.list&siteID=#URLEncodedFormat(attributes.siteid)#">Trash Bin</a></li>
<cfif attributes.action eq "updateFiles">
<li><a href="index.cfm?fuseaction=cSettings.editSite&siteid=#URLEncodedFormat(attributes.siteid)#">Edit Site</a></li>
<cfelse>
<li><a href="index.cfm?fuseaction=cSettings.editSite&siteid=#URLEncodedFormat(attributes.siteid)#&action=updateFiles" onclick="return confirmDialog('WARNING: Do not update your site files unless you have backed up your current siteID directory.',this.href);">Update Site Files to Latest Version</a></li>
<li><a href="?fuseaction=cSettings.selectBundleOptions&siteID=#URLEncodedFormat(request.siteBean.getSiteID())#">Create Site Bundle</a></li>
<cfif len(request.siteBean.getExportLocation()) and directoryExists(request.siteBean.getExportLocation())>
<li><a href="./?fuseaction=csettings.exportHTML&siteID=#request.siteBean.getSiteID()#"  onclick="return confirmDialog('Export static HTML files to #JSStringFormat("'#request.siteBean.getExportLocation()#'")#.',this.href);">Export Static HTML (BETA)</a></li>
</cfif>
</cfif>
</ul></cfif>
</cfoutput>
<cfif attributes.action neq "updateFiles">
<cfoutput>
<form novalidate="novalidate" method ="post"  enctype="multipart/form-data" action="index.cfm?fuseaction=cSettings.updateSite" name="form1"  onsubmit="return validate(this);">
<!---
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="js/ajax.js"></script>'>
<cfhtmlhead text='<script type="text/javascript" src="js/tab-view.js"></script>'>
 --->
<cfset tabLabelList='Basic,Contact Info,Shared Resources,Modules,Email,Images,Extranet,Display Regions,Deploy Bundle'>
<cfset tabList='tabBasic,tabContactinfo,tabSharedresources,tabModules,tabEmail,tabImages,tabExtranet,tabDisplayregions,tabBundles'>
 <div class="tabs initActiveTab" style="display:none">
  <ul>
	<cfloop from="1" to="#listlen(tabList)#" index="t">
	<li><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
	</cfloop>
  </ul>
  <!--- Basic --->
  	<div id="tabBasic">
    <dl class="oneColumn">
      <dt class="first">Site ID <span>(Warning: no punctuation, dots or file delimiters)</span></dt>
      <dd>
        <cfif attributes.siteid eq ''><input name="siteid" type="text" class="text" value="#request.siteBean.getsiteid()#" size="25" maxlength="25" required="true"><cfelse>#request.siteBean.getsiteid()#<input name="siteid" type="hidden" value="#request.siteBean.getsiteid()#"></cfif>
      <dd>
      <dt>Site</dt>
      <dd>
        <input name="site" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getsite())#" size="50" maxlength="50">
      </dd>
	 <dt>Tag Line</dt>
      <dd>
        <input name="tagline" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getTagline())#" size="50" maxlength="255">
      </dd>
      <dt>Domain <span>(Example: www.google.com)</span></dt>
      <dd>
        <input name="domain" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getdomain('production'))#" size="50" maxlength="100">
      </dd>
	 <dt>Domain Alias List <span>(Line Delimited)</span></dt>
      <dd>
        <textarea name="domainAlias">#HTMLEditFormat(request.siteBean.getDomainAlias())#</textarea>
      </dd>
	 <dt>Locale</dt>
      <dd>
		<select name="siteLocale">
		<option value="">Default</option>	
		<cfloop list="#listSort(server.coldfusion.supportedLocales,'textnocase','ASC')#" index="l">
        <option value="#l#"<cfif request.siteBean.getSiteLocale() eq l> selected</cfif>>#l#</option>
		</cfloop>
		</select>
      </dd>

	  <dt>Theme</dt>
      <dd>
		<select name="theme">
		<cfif request.siteBean.hasNonThemeTemplates()><option value="">None</option></cfif>	
		<cfloop query="rsThemes">
        <option value="#rsThemes.name#"<cfif rsThemes.name eq request.siteBean.getTheme() or (not len(request.siteBean.getSiteID()) and rsThemes.currentRow eq 1)> selected</cfif>>#rsThemes.name#</option>
		</cfloop>
		</select>
      </dd>
      <dt>Page Limit</dt>
      <dd>
        <input name="pagelimit" type="text" class="text short" value="#HTMLEditFormat(request.siteBean.getpagelimit())#" size="5" maxlength="6">
      </dd>
    <!---  <dt>Default View Depth <span>(in Site Manager)</span></dt>
      <dd>
        <input name="viewDepth" type="text" class="text short" value="#HTMLEditFormat(request.siteBean.getviewDepth())#" size="5" maxlength="5">
      </dd>--->
      <dt>Default  Rows <span>(in Site Manager)</span></dt>
      <dd>
        <input name="nextN" type="text" class="text short" value="#HTMLEditFormat(request.siteBean.getnextN())#" size="5" maxlength="5">
      </dd>
      <dt>Site Caching</dt>
      <dd>		 
       <input type="radio" name="cache" value="0"<cfif request.siteBean.getcache() neq 1> CHECKED</CFIF>>
        Off&nbsp;&nbsp;
       <input type="radio" name="cache" value="1"<cfif request.siteBean.getcache() eq 1> CHECKED</CFIF>>
        On
	  <dt>Cache Capacity <span>(0=Unlimited)</span></dt>
      <dd>
        <input name="cacheCapacity" type="text" class="text short" value="#HTMLEditFormat(request.siteBean.getCacheCapacity())#" size="15" maxlength="15">
      </dd>
	  <dt>Cache Free Memory Threshold <span>(Defaults to 40%)</span></dt>
      <dd>
        <input name="cacheFreeMemoryThreshold" type="text" class="text short" value="#HTMLEditFormat(request.siteBean.getCacheFreeMemoryThreshold())#" size="3" maxlength="3">%
      </dd>
      <dt>Lock Site Architecture <span>(Restricts Addition or Deletion of Site Content)</span></dt>
      <dd>
        <input type="radio" name="locking" value="none" <cfif request.siteBean.getlocking() eq 'none' or request.siteBean.getlocking() eq ''> CHECKED</CFIF>>
        None&nbsp;&nbsp;
        <input type="radio" name="locking" value="all" <cfif request.siteBean.getlocking() eq 'all'> CHECKED</CFIF>>
        All &nbsp;&nbsp;
        <input type="radio" name="locking" value="top" <cfif request.siteBean.getlocking() eq 'top'> CHECKED</CFIF>>
        Top</dd>
        <dt>Allow Comments to be Posted Without Site Admin Approval</dt>
		<dd>
        <input type="radio" name="CommentApprovalDefault" value="1" <cfif request.siteBean.getCommentApprovalDefault()  eq 1> CHECKED</CFIF>>
        Yes&nbsp;
        <input type="radio" name="CommentApprovalDefault" value="0" <cfif request.siteBean.getCommentApprovalDefault() neq 1> CHECKED</CFIF>>
       No
</dd>
       <dt>Static HTML Export Location (BETA)
		<cfif len(request.siteBean.getExportLocation()) and not directoryExists(request.siteBean.getExportLocation())>
			<p class="error">ERROR: The current value is not a valid directory</p>
		</cfif>
		</dt>
      <dd>
        <input name="exportLocation" type="text" class="text" value="#request.siteBean.getExportLocation()#" maxlength="100"/>
      </dd> 
     <!--- 
	  <dt>Google API Key <a href="http://www.google.com/apis/maps/signup.html" target="_blank">(Required for Google Maps Support)</a></dt>
      <dd>
        <input name="googleAPIKey" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getGoogleAPIKey())#">
      </dd>
	   --->
      <!--- <dt>Google Analytics Account #</dt>
      <dd>
        <input name="googleAnalyticsAcct" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getGoogleAnalyticsAcct())#">
      </dd> --->
      </dl>
      </div>
      
       <!--- Default Contact Info --->
      <div id="tabContactinfo">
      <dl class="oneColumn">
      <dt class="first">Contact Name</dt>
      <dd>
        <input name="contactName" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getcontactName())#" size="50" maxlength="50" maxlength="100">
      </dd>
      <dt>Contact Address</dt>
      <dd>
        <input name="contactAddress" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getcontactAddress())#" size="50" maxlength="50" maxlength="100">
      </dd>
      <dt>Contact City</dt>
      <dd>
        <input name="contactCity" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getcontactCity())#" size="50" maxlength="50" maxlength="100">
      </dd>
      <dt>Contact State</dt>
      <dd>
        <input name="contactState" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getcontactState())#" size="50" maxlength="50" maxlength="100">
      </dd>
      <dt>Contact Zip</dt>
      <dd>
        <input name="contactZip" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getcontactZip())#" size="50" maxlength="50" maxlength="100">
      </dd>
      <dt>Contact Phone</dt>
      <dd>
        <input name="contactPhone" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getcontactPhone())#" size="50" maxlength="50" maxlength="100">
      </dd>
      <dt>Contact Email</dt>
      <dd>
        <input name="contactEmail" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getcontactEmail())#" size="50" maxlength="50" maxlength="100">
      </dd>
    </dl>
    </div>
      
       <!--- Shared Resources --->
      <div id="tabSharedresources">
      <dl class="oneColumn">
      <dt class="first">Member Pool</dt>
      <dd>
        <select id="publicUserPoolID" name="publicUserPoolID" onchange="if(this.value!='' || jQuery('##privateUserPoolID').val()!=''){jQuery('##bundleImportUsersModeLI').hide();jQuery('##bundleImportUsersMode').attr('checked',false);}else{jQuery('##bundleImportUsersModeLI').show();}">
          <option value="">This site</option>
          <cfloop query="rsSites">
            <cfif rsSites.siteid neq request.siteBean.getSiteID()>
              <option value="#rsSites.siteid#" <cfif rsSites.siteid eq request.siteBean.getPublicUserPoolID()>selected</cfif>>#HTMLEditFormat(rsSites.site)#</option>
            </cfif>
          </cfloop>
        </select>
      </dd>
      <dt>Administrative User Pool</dt>
      <dd>
        <select id="privateUserPoolID" name="privateUserPoolID" onchange="if(this.value!='' || jQuery('##publicUserPoolID').val()!=''){jQuery('##bundleImportUsersModeLI').hide();jQuery('##bundleImportUsersMode').attr('checked',false);}else{jQuery('##bundleImportUsersModeLI').show();}">
          <option value="">This site</option>
          <cfloop query="rsSites">
            <cfif rsSites.siteid neq request.siteBean.getSiteID()>
              <option value="#rsSites.siteid#" <cfif rsSites.siteid eq request.siteBean.getPrivateUserPoolID()>selected</cfif>>#HTMLEditFormat(rsSites.site)#</option>
            </cfif>
          </cfloop>
        </select>
      </dd>
      <dt>Advertiser User Pool</dt>
      <dd>
        <select name="advertiserUserPoolID">
          <option value="">This site</option>
          <cfloop query="rsSites">
            <cfif rsSites.siteid neq request.siteBean.getSiteID()>
              <option value="#rsSites.siteid#" <cfif rsSites.siteid eq request.siteBean.getAdvertiserUserPoolID()>selected</cfif>>#HTMLEditFormat(rsSites.site)#</option>
            </cfif>
          </cfloop>
        </select>
      </dd>
	  <dt>Display Object Pool</dt>
      <dd>
        <select name="displayPoolID">
          <option value="">This site</option>
          <cfloop query="rsSites">
            <cfif rsSites.siteid neq request.siteBean.getSiteID()>
              <option value="#rsSites.siteid#" <cfif rsSites.siteid eq request.siteBean.getDisplayPoolID()>selected</cfif>>#HTMLEditFormat(rsSites.site)#</option>
            </cfif>
          </cfloop>
        </select>
      </dd>
      </dl>
      </div>
      
      <!--- Modules --->
      <div id="tabModules">
      <dl class="oneColumn">
      <dt class="first">Extranet <span>(Password Protection)</span></dt>
      <dd>
        <input type="radio" name="extranet" value="0" <cfif request.siteBean.getextranet() neq 1> CHECKED</CFIF>>
        Off&nbsp;&nbsp;
        <input type="radio" name="extranet" value="1" <cfif request.siteBean.getextranet()  eq 1> CHECKED</CFIF>>
        On</dd>
      <dt>Email Broadcaster</dt>
      <dd>
		<!--- <p class="notice">NOTE: The Email Broadcaster is not supported within Mura Bundles.</p> --->
        <input type="radio" name="EmailBroadcaster" value="0" <cfif request.siteBean.getemailbroadcaster() neq 1> CHECKED</CFIF>>
        Off&nbsp;&nbsp;
        <input type="radio" name="EmailBroadcaster" value="1" <cfif request.siteBean.getemailbroadcaster()  eq 1> CHECKED</CFIF>>
        On
		</dd>
      <dt>Email Broadcaster Limit</dt>
      <dd>
        <input name="EmailBroadcasterLimit" type="text" class="text medium" value="#HTMLEditFormat(request.siteBean.getEmailBroadcasterLimit())#" size="50" maxlength="50">
      </dd>
      <dt>Content Collections Manager</dt>
      <dd>
        <input type="radio" name="hasFeedManager" value="0" <cfif request.siteBean.getHasFeedManager() neq 1> CHECKED</CFIF>>
        Off&nbsp;&nbsp;
        <input type="radio" name="hasFeedManager" value="1" <cfif request.siteBean.getHasFeedManager()  eq 1> CHECKED</CFIF>>
        On</dd>
      <dt>Forms Manager</dt>
      <dd>
        <input type="radio" name="dataCollection" value="0" <cfif request.siteBean.getdataCollection() neq 1> CHECKED</CFIF>>
        Off&nbsp;&nbsp;
        <input type="radio" name="dataCollection" value="1" <cfif request.siteBean.getdataCollection() eq 1> CHECKED</CFIF>>
        On</dd>
      <dt>Advertisement Manager</dt>
      <dd>
		<!--- <p class="notice">NOTE: The Advertisement Manager is not supported within Mura Bundles and Staging to Production configurations.</p> --->
        <input type="radio" name="adManager" value="0" <cfif request.siteBean.getadManager() neq 1> CHECKED</CFIF>>
        Off&nbsp;&nbsp;
        <input type="radio" name="adManager" value="1" <cfif request.siteBean.getadManager() eq 1> CHECKED</CFIF>>
        On</dd>
	  <dt>Change Sets Manager</dt>
      <dd>
        <input type="radio" name="hasChangesets" value="0" <cfif request.siteBean.getHasChangesets() neq 1> CHECKED</CFIF>>
        Off&nbsp;&nbsp;
        <input type="radio" name="hasChangesets" value="1" <cfif request.siteBean.getHasChangesets() eq 1> CHECKED</CFIF>>
        On</dd>
      </dl>
      </div>
      
      <!--- Email --->
      <div id="tabEmail">
      <dl class="oneColumn">
      <dt class="first">Default "From" Email Address</dt>
      <dd>
        <input name="contact" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getcontact())#" size="50" maxlength="50">
      </dd>
      <dt>Mail Server IP/Host Name</dt>
      <dd>
        <input name="MailServerIP" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getMailServerIP())#" size="50" maxlength="50">
      </dd>
	  <dt>Mail Server SMTP Port</dt>
      <dd>
        <input name="MailServerSMTPPort" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getMailServerSMTPPort())#" size="5" maxlength="5">
      </dd>
	  <dt>Mail Server POP Port</dt>
      <dd>
        <input name="MailServerPOPPort" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getMailServerPOPPort())#" size="5" maxlength="5">
      </dd>
      <dt>Mail Server Username (Warning: DO NOT USE PERSONAL ACCOUNT)</dt>
      <dd>
        <input name="MailServerUserName" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getMailServerUserName())#" size="50" maxlength="50">
      </dd>
      <dt>Mail Server Password</dt>
      <dd>
        <input name="MailServerPassword" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getMailServerPassword())#" size="50" maxlength="50">
      </dd>
	<dt>Use TLS</dt>
		<dd>
        <input type="radio" name="mailServerTLS" value="true" <cfif request.siteBean.getmailServerTLS()  eq "true"> CHECKED</CFIF>>
        Yes&nbsp;
        <input type="radio" name="mailServerTLS" value="false" <cfif request.siteBean.getmailServerTLS() eq "false"> CHECKED</CFIF>>
       No
	  </dd>
	  <dt>Use SSL</dt>
		<dd>
        <input type="radio" name="mailServerSSL" value="true" <cfif request.siteBean.getmailServerSSL()  eq "true"> CHECKED</CFIF>>
        Yes&nbsp;
        <input type="radio" name="mailServerSSL" value="false" <cfif request.siteBean.getmailServerSSL() eq "false"> CHECKED</CFIF>>
       No
	  </dd>
	  <dt>Use Default SMTP Server</dt>
		<dd>
        <input type="radio" name="useDefaultSMTPServer" value="1" <cfif request.siteBean.getUseDefaultSMTPServer()  eq 1> CHECKED</CFIF>>
        Yes&nbsp;
        <input type="radio" name="useDefaultSMTPServer" value="0" <cfif request.siteBean.getUseDefaultSMTPServer() neq 1> CHECKED</CFIF>>
       No
	  </dd>
      <dt class="separate">User Login Info Request Script</dt>
      <dd>Available Dynamic Content: ##firstName## ##lastName## ##username## ##password## ##contactEmail## ##contactName## ##returnURL##<br/>
        <textarea name="sendLoginScript">#HTMLEditFormat(request.siteBean.getSendLoginScript())#</textarea>
      </dd>
	    <dt>Mailing List Confirmation Script</dt>
      <dd>Available Dynamic Content: ##listName## ##contactName## ##contactEmail## ##returnURL##<br/>
        <textarea name="mailingListConfirmScript">#HTMLEditFormat(request.siteBean.getMailingListConfirmScript())#</textarea>
      </dd>
        <dt>Account Activation Script</dt>
      <dd>Available Dynamic Content: ##firstName## ##lastName## ##username## ##contactEmail## ##contactName##<br/>
        <textarea name="accountActivationScript">#HTMLEditFormat(request.siteBean.getAccountActivationScript())#</textarea>
      </dd>
	   <dt>Public Submission Approval Script</dt>
      <dd>Available Dynamic Content: ##returnURL## ##contentName## ##parentName## ##contentType##
        <textarea name="publicSubmissionApprovalScript">#HTMLEditFormat(request.siteBean.getPublicSubmissionApprovalScript())#</textarea>
      </dd>
	  <dt>Event Reminder Script</dt>
      <dd>Available Dynamic Content: ##returnURL## ##eventTitle## ##startDate## ##startTime## ##siteName## ##eventContactName## ##eventContactAddress## ##eventContactCity## ##eventContactState## ##eventContactZip## ##eventContactPhone##
        <textarea name="reminderScript">#HTMLEditFormat(request.siteBean.getReminderScript())#</textarea>
      </dd>

      </dl>
      </div>
      
           
      <!--- Galleries --->
      <div id="tabImages">
      <dl class="oneColumn">
	  <dt class="first">Small (Thumbnail) Image Size</dt>
      <dd>
        <input name="gallerySmallScale" type="text" class="text short" value="#request.siteBean.getGallerySmallScale()#" size="5" maxlength="5">px
      </dd>
	    <dt>Constrain Small Images by</dt>
      <dd>
        <input type="radio" name="gallerySmallScaleBy" value="x" <cfif request.siteBean.getgallerySmallScaleBy() eq 'x'> CHECKED</CFIF>>
       Width&nbsp;&nbsp;
        <input type="radio" name="gallerySmallScaleBy" value="y" <cfif request.siteBean.getgallerySmallScaleBy() eq 'y'> CHECKED</CFIF>>
        Height
		 <input type="radio" name="gallerySmallScaleBy" value="s" <cfif request.siteBean.getgallerySmallScaleBy() neq 'x' and request.siteBean.getgallerySmallScaleBy() neq 'y'> CHECKED</CFIF>>
        Square</dd>
<dt>Medium Image Size</dt>
      <dd>
        <input name="galleryMediumScale" type="text" class="text short" value="#request.siteBean.getGalleryMediumScale()#" size="5" maxlength="5">px
      </dd>
	   <dt>Constrain Medium Images by</dt>
      <dd>
        <input type="radio" name="galleryMediumScaleBy" value="x" <cfif request.siteBean.getgalleryMediumScaleBy() eq 'x'> CHECKED</CFIF>>
       Width&nbsp;&nbsp;
        <input type="radio" name="galleryMediumScaleBy" value="y" <cfif request.siteBean.getgalleryMediumScaleBy() neq 's' and request.siteBean.getgalleryMediumScaleBy() neq 'x'> CHECKED</CFIF>>
        Height
		 <input type="radio" name="galleryMediumScaleBy" value="s" <cfif request.siteBean.getgalleryMediumScaleBy() eq 's' > CHECKED</CFIF>>
        Square</dd>
         <dt>Large (Full) Image Size</dt>
      <dd>
        <input name="galleryMainScale" type="text" class="text short" value="#request.siteBean.getgalleryMainScale()#" size="5" maxlength="5">px
      </dd>
	    <dt>Constrain Large Images by</dt>
      <dd>
        <input type="radio" name="galleryMainScaleBy" value="x" <cfif request.siteBean.getgalleryMainScaleBy() eq 'x'> CHECKED</CFIF>>
       Width&nbsp;&nbsp;
        <input type="radio" name="galleryMainScaleBy" value="y" <cfif request.siteBean.getgalleryMainScaleBy() neq 'x'> CHECKED</CFIF>>
        Height</dd>
      </dl>
      </div>
      
      <!--- Extranet --->
      <div id="tabExtranet">
      <dl class="oneColumn">
      <dt class="first">Allow Public Site Registration</dt>
      <dd>
        <input type="radio" name="extranetpublicreg" value="0" <cfif request.siteBean.getextranetpublicreg() neq 1> CHECKED</CFIF>>
        No&nbsp;&nbsp;
        <input type="radio" name="extranetpublicreg" value="1" <cfif request.siteBean.getextranetpublicreg()  eq 1> CHECKED</CFIF>>
        Yes</dd>
	   <dt>Custom Login URL</dt>
      <dd>
        <input name="loginURL" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getLoginURL())#" maxlength="255">
      </dd>
	   <dt>Custom Profile URL</dt>
      <dd>
        <input name="editProfileURL" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getEditProfileURL())#" maxlength="255">
      </dd>
     <!---  <dt>Allow Public Submission In To Portals</dt>
      <dd>
        <input type="radio" name="publicSubmission" value="0" <cfif request.siteBean.getpublicSubmission() neq 1> CHECKED</CFIF>>
        No&nbsp;&nbsp;
        <input type="radio" name="publicSubmission" value="1" <cfif request.siteBean.getpublicSubmission() eq 1> CHECKED</CFIF>>
        Yes</dd>
      <dd> --->
      <dt>Require HTTPS Encryption for Extranet</dt>
      <dd>
        <input type="radio" name="extranetssl" value="0" <cfif request.siteBean.getextranetssl() neq 1> CHECKED</CFIF>>
        No&nbsp;&nbsp;
        <input type="radio" name="extranetssl" value="1" <cfif request.siteBean.getextranetssl()  eq 1> CHECKED</CFIF>>
        Yes</dd>
		<dt>Email Site Registration Notifications to:</dt>
      <dd>
        <input name="ExtranetPublicRegNotify" type="text" class="text" value="#request.siteBean.getExtranetPublicRegNotify()#" size="50" maxlength="50">
      </dd>
      </dl>
      </div>
      
      <div id="tabDisplayregions">
      <dl class="oneColumn">
      <dt class="first">Number of Display Regions</dt>
      <dd>
        <input type="radio" name="columnCount" value="1" <cfif request.siteBean.getcolumnCount() eq 1 or request.siteBean.getcolumnCount() eq 0> CHECKED</CFIF>>
        1&nbsp;&nbsp;
        <input type="radio" name="columnCount" value="2" <cfif request.siteBean.getcolumnCount() eq 2> CHECKED</CFIF>>
        2 &nbsp;&nbsp;
        <input type="radio" name="columnCount" value="3" <cfif request.siteBean.getcolumnCount() eq 3> CHECKED</CFIF>>
        3
        &nbsp;&nbsp;
        <input type="radio" name="columnCount" value="4" <cfif request.siteBean.getcolumnCount() eq 4> CHECKED</CFIF>>
        4
        &nbsp;&nbsp;
        <input type="radio" name="columnCount" value="5" <cfif request.siteBean.getcolumnCount() eq 5> CHECKED</CFIF>>
        5
        &nbsp;&nbsp;
        <input type="radio" name="columnCount" value="6" <cfif request.siteBean.getcolumnCount() eq 6> CHECKED</CFIF>>
        6
        &nbsp;&nbsp;
        <input type="radio" name="columnCount" value="7" <cfif request.siteBean.getcolumnCount() eq 7> CHECKED</CFIF>>
        7
        &nbsp;&nbsp;
        <input type="radio" name="columnCount" value="8" <cfif request.siteBean.getcolumnCount() eq 8> CHECKED</CFIF>>
        8</dd>
      <dt>Primary Display Region <span>(Dynamic System Content such as Login Forms and Search Results get displayed here)</span></dt>
      <dd>
        <input type="radio" name="primaryColumn" value="1" <cfif request.siteBean.getprimaryColumn() eq 1 or request.siteBean.getprimaryColumn() eq 0> CHECKED</CFIF>>
        1&nbsp;&nbsp;
        <input type="radio" name="primaryColumn" value="2" <cfif request.siteBean.getprimaryColumn() eq 2> CHECKED</CFIF>>
        2 &nbsp;&nbsp;
        <input type="radio" name="primaryColumn" value="3" <cfif request.siteBean.getprimaryColumn() eq 3> CHECKED</CFIF>>
        3
        &nbsp;&nbsp;
        <input type="radio" name="primaryColumn" value="4" <cfif request.siteBean.getprimaryColumn() eq 4> CHECKED</CFIF>>
        4
        &nbsp;&nbsp;
        <input type="radio" name="primaryColumn" value="5" <cfif request.siteBean.getprimaryColumn() eq 5> CHECKED</CFIF>>
        5
        &nbsp;&nbsp;
        <input type="radio" name="primaryColumn" value="6" <cfif request.siteBean.getprimaryColumn() eq 6> CHECKED</CFIF>>
        6
        &nbsp;&nbsp;
        <input type="radio" name="primaryColumn" value="7" <cfif request.siteBean.getprimaryColumn() eq 7> CHECKED</CFIF>>
        7
        &nbsp;&nbsp;
        <input type="radio" name="primaryColumn" value="8" <cfif request.siteBean.getprimaryColumn() eq 8> CHECKED</CFIF>>
        8</dd>
      <dt>Display Region Names <span>("^" Delimiter)</span></dt>
      <dd>
        <input name="columnNames" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getcolumnNames())#" maxlength="255">
      </dd>
      </dl>
      </div>
	 
      <div id="tabBundles">
      <dl class="oneColumn">

	<dt class="first"> 
	  	Are you restoring a site from a backup bundle?
	  </dt>
	  <dd>
	  <label for=""><input type="radio" name="bundleImportKeyMode" value="copy" checked="checked">No - <em>Assign New Keys to Imported Items</em></label>
	  <label for=""><input type="radio" name="bundleImportKeyMode" value="publish">Yes - <em>Maintain All Keys from Imported Items</em></label>
	  </dd>
	  <dt> 
	  	Include:
	  </dt>
	  <dd>
		  <ul>
			  <li>
			  	<label for="bundleImportContentMode"><input id="bundleImportContentMode" name="bundleImportContentMode" value="all" type="checkbox" onchange="if(this.checked){jQuery('##contentRemovalNotice').show();}else{jQuery('##contentRemovalNotice').hide();}">Site Architecture &amp; Content</label>
			 </li>
			 <li id="bundleImportUsersModeLI"<cfif not (request.siteBean.getPublicUserPoolID() eq request.siteBean.getSiteID() and request.siteBean.getPrivateUserPoolID() eq request.siteBean.getSiteID())> style="display:none;"</cfif>>
			  	<label for="bundleImportUsersMode"><input id="bundleImportUsersMode" name="bundleImportUsersMode" value="all" type="checkbox"  onchange="if(this.checked){jQuery('##userNotice').show();}else{jQuery('##userNotice').hide();}">Site Members &amp; Administrative Users</label>
			 </li>
			 <li>
			  	<label for="bundleImportMailingListMembersMode"><input id="bundleImportMailingListMembersMode" name="bundleImportMailingListMembersMode" value="all" type="checkbox">Mailing Lists Members</label>
			 </li>
			  <li>
			  	<label for="bundleImportFormDataMode"><input id="bundleImportFormDataMode" name="bundleImportFormDataMode" value="all" type="checkbox">Form Response Data</label>
			 </li>
			 <li>
			  	<label for="bundleImportPluginMode"><input id="bundleImportPluginMode" name="bundleImportPluginMode" value="all" type="checkbox">All Plugins</label>
			 </li>
		 </ul>
		 <p class="notice" style="display:none" id="contentRemovalNotice"><strong>Important:</strong> When importing content from a Mura bundle ALL of the existing content will be deleted.</p>
		 <p class="notice" style="display:none" id="userNotice"><strong>Important:</strong> Importing users will remove all existing user data which may include the account that you are currently logged in as.</p>
	 </dd>
	 <dt> 
	  	Which rendering files would you like to import?
	  </dt>
	  <dd>
	  <label for=""><input type="radio" name="bundleImportRenderingMode" value="all" onchange="if(this.value!='none'){jQuery('##themeNotice').show();}else{jQuery('##themeNotice').hide();}">All</label>
	  <label for=""><input type="radio" name="bundleImportRenderingMode" value="theme" onchange="if(this.value!='none'){jQuery('##themeNotice').show();}else{jQuery('##themeNotice').hide();}">Theme Only</label>
	  <label for=""><input type="radio" name="bundleImportRenderingMode" value="none" checked="checked" onchange="if(this.value!='none'){jQuery('##themeNotice').show();}else{jQuery('##themeNotice').hide();}">None</label>
	  <p class="notice" style="display:none" id="themeNotice"><strong>Important:</strong> Your site's theme assignment and gallery image settings will be updated.</p>
		  <!---
			<select name="bundleImportRenderingMode" onchange="if(this.value!='none'){jQuery('##themeNotice').show();}else{jQuery('##themeNotice').hide();}">
		  	<option>Select Rendering Files</option>
			<option value="none">None</option>
			<option value="all">The entire siteID directory</option>
			<option value="theme">Theme only</option>
		  </select>	
			--->
	 </dd>
	  <!---
<dd>
		  
	  </dd>
--->
	 
	
	  
	  <dt><a class="tooltip">Select Bundle File From Server (Preferred)<span>You can deploy a bundle that exists on the server by entering the complete server path to the Site Bundle here. This eliminates the need to upload the file via your web browser, avoiding some potential timeout issues.</span></a></dt>
      <dd>
        <input class="text" type="text" name="serverBundlePath" id="serverBundlePath" value=""><input type="button" value="Browse Server" id="serverBundleBrowser"/>
		<script>
		jQuery(document).ready( function() {
			var finder = new CKFinder();
				finder.basePath = '#application.configBean.getContext()#/tasks/widgets/ckfinder/';
				finder.selectActionFunction = setServerBundlePath;
				finder.resourceType='Application_Root';
			
				 jQuery("##serverBundleBrowser").bind("click", function(){
					 finder.popup();
				 });		
		});
		
		function setServerBundlePath(fileUrl) {
			var check=fileUrl.split(".");
			if(check[check.length-1].toLowerCase() == 'zip'){
			jQuery('##serverBundlePath').val("#JSStringFormat('#application.configBean.getWebRoot()##application.configBean.getFileDelim()#')#" + fileUrl);
			}
		}
		</script>
      </dd>
	   <dt><a class="tooltip">Upload Bundle File <span>Uploading large files via a web browser can produce inconsistent results.</span></a></dt>
	  <dd><input type="file" name="bundleFile" accept=".zip"/></dd>
	  </dl>
	  </div>
	
    </div>
    <input type="hidden" name="action" value="update">
    <div id="actionButtons">
	<cfif request.siteBean.getsiteid() eq ''> 
      <input type="button" class="submit" onclick="submitForm(document.forms.form1,'add');" value="Add" />
    <cfelse>
		<cfif request.siteBean.getsiteid() neq 'default'>
		<input type="button" class="submit" onclick="return confirmDialog('#JSStringFormat("WARNING: A deleted site and all of it''s files cannot be recovered. Are you sure that you want to continue?")#','index.cfm?fuseaction=cSettings.updateSite&action=delete&siteid=#request.siteBean.getSiteID()#');" value="Delete" />
		</cfif>
      	<input type="button" class="submit" onclick="submitForm(document.forms.form1,'update');" value="Update" />
     </cfif>
	 </div>
	 <div id="actionIndicator" style="display: none;">
		<img class="loadProgress" src="#application.configBean.getContext()#/admin/images/progress_bar.gif">
	</div>
  </form>
</cfoutput>

<cfelse>
<cftry>
<cfset updated=application.autoUpdater.update(attributes.siteid)>
<cfset files=updated.files>
<p>Your site's files have been updated to version <cfoutput>#application.autoUpdater.getCurrentCompleteVersion(attributes.siteid)#</cfoutput>.</p>
<p>
<strong>Updated Files <cfoutput>(#arrayLen(files)#)</cfoutput></strong><br/>
<cfif arrayLen(files)>
<cfoutput>
<cfloop from="1" to="#arrayLen(files)#" index="i">
#files[i]#<br/>
</cfloop>
</cfoutput>
</cfif>
</p>
<cfcatch>
<h3>An Error has occured.</h3>
<cfdump var="#cfcatch.message#"><br/><br/>
<cfdump var="#cfcatch.TagContext#">
</cfcatch>
</cftry>
</cfif>