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

<h2>Site Settings</h2>
<cfoutput>
<cfif len(attributes.siteid)>
<ul id="navTask"
<li><a href="index.cfm?fuseaction=cExtend.listSubTypes&siteid=#attributes.siteid#">Class Extension Manager</a></li>
</ul></cfif>

  <form method ="post" action="index.cfm?fuseaction=cSettings.updateSite" name="form1"  onsubmit="return validate(this);">
  
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="js/ajax.js"></script>'>
<cfhtmlhead text='<script type="text/javascript" src="js/tab-view.js"></script>'>
  
  <div id="page_tabView">
  <!--- Basic --->
  	<div class="page_aTab">
    <dl class="oneColumn">
      <dt class="first">Site ID <span>(Warning: no punctuation, dots or file delimiters)</span></dt>
      <dd>
        <cfif attributes.siteid eq ''><input name="siteid" type="text" class="text forceLC" value="#request.siteBean.getsiteid()#" size="25" required="true"><cfelse>#request.siteBean.getsiteid()#<input name="siteid" type="hidden" value="#request.siteBean.getsiteid()#"></cfif>
      <dd>
      <dt>Site</dt>
      <dd>
        <input name="site" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getsite())#" size="50">
      </dd>
      <dt>Domain <span>(Example: www.google.com)</span></dt>
      <dd>
        <input name="domain" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getdomain('production'))#" size="50">
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
      <dt>Page Limit</dt>
      <dd>
        <input name="pagelimit" type="text" class="text short" value="#HTMLEditFormat(request.siteBean.getpagelimit())#" size="5">
      </dd>
      <dt>Default View Depth <span>(in Site Manager)</span></dt>
      <dd>
        <input name="viewDepth" type="text" class="text short" value="#HTMLEditFormat(request.siteBean.getviewDepth())#" size="5">
      </dd>
      <dt>Default  Rows <span>(in Site Manager)</span></dt>
      <dd>
        <input name="nextN" type="text" class="text short" value="#HTMLEditFormat(request.siteBean.getnextN())#" size="5">
      </dd>
      <dt>Site Caching</dt>
      <dd>
        <input type="radio" name="cache" value="0" <cfif request.siteBean.getcache() neq 1> CHECKED</CFIF>>
        Off&nbsp;&nbsp;
        <input type="radio" name="cache" value="1" <cfif request.siteBean.getcache()  eq 1> CHECKED</CFIF>>
        On</dd>
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
      <!--- <dt>Export Location</dt>
      <dd>
        <input name="exportLocation" type="text" class="text" value="#request.siteBean.getExportLocation()#" size="50">
      </dd> --->
       <dt>Google API Key <a href="http://www.google.com/apis/maps/signup.html" target="_blank">(Required for Google Maps Support)</a></dt>
      <dd>
        <input name="googleAPIKey" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getGoogleAPIKey())#">
      </dd>
      <!--- <dt>Google Analytics Account #</dt>
      <dd>
        <input name="googleAnalyticsAcct" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getGoogleAnalyticsAcct())#">
      </dd> --->
      </dl>
      </div>
      
       <!--- Default Contact Info --->
      <div class="page_aTab">
      <dl class="oneColumn">
      <dt class="first">Contact Name</dt>
      <dd>
        <input name="contactName" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getcontactName())#" size="50" maxlength="100">
      </dd>
      <dt>Contact Address</dt>
      <dd>
        <input name="contactAddress" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getcontactAddress())#" size="50" maxlength="100">
      </dd>
      <dt>Contact City</dt>
      <dd>
        <input name="contactCity" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getcontactCity())#" size="50" maxlength="100">
      </dd>
      <dt>Contact State</dt>
      <dd>
        <input name="contactState" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getcontactState())#" size="50" maxlength="100">
      </dd>
      <dt>Contact Zip</dt>
      <dd>
        <input name="contactZip" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getcontactZip())#" size="50" maxlength="100">
      </dd>
      <dt>Contact Phone</dt>
      <dd>
        <input name="contactPhone" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getcontactPhone())#" size="50" maxlength="100">
      </dd>
      <dt>Contact Email</dt>
      <dd>
        <input name="contactEmail" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getcontactEmail())#" size="50" maxlength="100">
      </dd>
    </dl>
    </div>
      
       <!--- Shared Resources --->
      <div class="page_aTab">
      <dl class="oneColumn">
      <dt class="first">Member Pool</dt>
      <dd>
        <select name="publicUserPoolID">
          <option value="">This site</option>
          <cfloop collection="#application.settingsManager.getSites()#" item="site">
            <cfif site neq request.siteBean.getSiteID()>
              <option value="#site#" <cfif site eq request.siteBean.getPublicUserPoolID()>selected</cfif>>#application.settingsManager.getSite(site).getSite()#</option>
            </cfif>
          </cfloop>
        </select>
      </dd>
      <dt>Administrative User Pool</dt>
      <dd>
        <select name="privateUserPoolID">
          <option value="">This site</option>
          <cfloop collection="#application.settingsManager.getSites()#" item="site">
            <cfif site neq request.siteBean.getSiteID()>
              <option value="#site#" <cfif site eq request.siteBean.getPrivateUserPoolID()>selected</cfif>>#application.settingsManager.getSite(site).getSite()#</option>
            </cfif>
          </cfloop>
        </select>
      </dd>
      <dt>Advertiser User Pool</dt>
      <dd>
        <select name="advertiserUserPoolID">
          <option value="">This site</option>
          <cfloop collection="#application.settingsManager.getSites()#" item="site">
            <cfif site neq request.siteBean.getSiteID()>
              <option value="#site#" <cfif site eq request.siteBean.getAdvertiserUserPoolID()>selected</cfif>>#application.settingsManager.getSite(site).getSite()#</option>
            </cfif>
          </cfloop>
        </select>
      </dd>
	  <dt>Display Object Pool</dt>
      <dd>
        <select name="displayPoolID">
          <option value="">This site</option>
          <cfloop collection="#application.settingsManager.getSites()#" item="site">
            <cfif site neq request.siteBean.getSiteID()>
              <option value="#site#" <cfif site eq request.siteBean.getDisplayPoolID()>selected</cfif>>#application.settingsManager.getSite(site).getSite()#</option>
            </cfif>
          </cfloop>
        </select>
      </dd>
      </dl>
      </div>
      
      <!--- Modules --->
      <div class="page_aTab">
      <dl class="oneColumn">
      <dt class="first">Extranet <span>(Password Protection)</span></dt>
      <dd>
        <input type="radio" name="extranet" value="0" <cfif request.siteBean.getextranet() neq 1> CHECKED</CFIF>>
        Off&nbsp;&nbsp;
        <input type="radio" name="extranet" value="1" <cfif request.siteBean.getextranet()  eq 1> CHECKED</CFIF>>
        On</dd>
      <dt>Email Broadcaster</dt>
      <dd>
        <input type="radio" name="EmailBroadcaster" value="0" <cfif request.siteBean.getemailbroadcaster() neq 1> CHECKED</CFIF>>
        Off&nbsp;&nbsp;
        <input type="radio" name="EmailBroadcaster" value="1" <cfif request.siteBean.getemailbroadcaster()  eq 1> CHECKED</CFIF>>
        On</dd>
      <dt>Email Broadcaster Limit</dt>
      <dd>
        <input name="EmailBroadcasterLimit" type="text" class="text medium" value="#HTMLEditFormat(request.siteBean.getEmailBroadcasterLimit())#" size="50">
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
        <input type="radio" name="adManager" value="0" <cfif request.siteBean.getadManager() neq 1> CHECKED</CFIF>>
        Off&nbsp;&nbsp;
        <input type="radio" name="adManager" value="1" <cfif request.siteBean.getadManager() eq 1> CHECKED</CFIF>>
        On</dd>
      </dl>
      </div>
      
      <!--- Email --->
      <div class="page_aTab">
      <dl class="oneColumn">
      <dt class="first">Default "From" Email Address</dt>
      <dd>
        <input name="contact" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getcontact())#" size="50">
      </dd>
      <dt>Mail Server IP</dt>
      <dd>
        <input name="MailServerIP" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getMailServerIP())#" size="50">
      </dd>
	  <dt>Mail Server SMTP Port</dt>
      <dd>
        <input name="MailServerSMTPPort" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getMailServerSMTPPort())#" size="5">
      </dd>
	  <dt>Mail Server POP Port</dt>
      <dd>
        <input name="MailServerPOPPort" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getMailServerPOPPort())#" size="5">
      </dd>
      <dt>Mail Server Username (Warning: DO NOT USE PERSONAL ACCOUNT)</dt>
      <dd>
        <input name="MailServerUserName" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getMailServerUserName())#" size="50">
      </dd>
      <dt>Mail Server Password</dt>
      <dd>
        <input name="MailServerPassword" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getMailServerPassword())#" size="50">
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
      <dd>Available Dynamic Content: ##firstName## ##lastName## ##username## ##password## ##contactEmail## ##contactName##<br/>
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
      <div class="page_aTab">
      <dl class="oneColumn">
	  <dt class="first">Small (Thumbnail) Image Size</dt>
      <dd>
        <input name="gallerySmallScale" type="text" class="text short" value="#request.siteBean.getGallerySmallScale()#" size="5">px
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
        <input name="galleryMediumScale" type="text" class="text short" value="#request.siteBean.getGalleryMediumScale()#" size="5">px
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
        <input name="galleryMainScale" type="text" class="text short" value="#request.siteBean.getgalleryMainScale()#" size="5">px
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
      <div class="page_aTab">
      <dl class="oneColumn">
      <dt class="first">Allow Public Site Registration</dt>
      <dd>
        <input type="radio" name="extranetpublicreg" value="0" <cfif request.siteBean.getextranetpublicreg() neq 1> CHECKED</CFIF>>
        No&nbsp;&nbsp;
        <input type="radio" name="extranetpublicreg" value="1" <cfif request.siteBean.getextranetpublicreg()  eq 1> CHECKED</CFIF>>
        Yes</dd>
	   <dt>Custom Login URL</dt>
      <dd>
        <input name="loginURL" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getLoginURL())#" size="255">
      </dd>
	   <dt>Custom Profile URL</dt>
      <dd>
        <input name="editProfileURL" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getEditProfileURL())#" size="255">
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
        <input name="ExtranetPublicRegNotify" type="text" class="text" value="#request.siteBean.getExtranetPublicRegNotify()#" size="50">
      </dd>
      </dl>
      </div>
      
      <div class="page_aTab">
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
        <input name="columnNames" type="text" class="text" value="#HTMLEditFormat(request.siteBean.getcolumnNames())#" size="50" maxlength="255">
      </dd>
      </dl>
      </div>
      
    </div>
    <input type="hidden" name="action" value="update">
    <cfif request.siteBean.getsiteid() eq ''>
     
      <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'add');"><span>Add</span></a>
      <cfelse>
		<cfif request.siteBean.getsiteid() neq 'default'>
		<a class="submit" href="javascript:;" onclick="if(confirm('Delete the #jsStringFormat("'#request.siteBean.getSite()#'")# Site?')){if(confirm('WARNING: A deleted site cannot be recovered. Are you sure that you want to continue?')){document.forms.form1.action.value='delete';document.forms.form1.submit();};} else {return false;}"><span>Delete</span></a>
		</cfif>
      <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'update');"><span>Update</span></a>
            </cfif>
  </form>
</cfoutput>
<script type="text/javascript">
initTabs(Array('Basic','Contact Info','Shared Resources','Modules','Email','Images (Galleries)','Extranet','Display Regions'),0,0,0);
</script>