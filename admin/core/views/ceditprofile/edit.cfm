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
<cfinclude template="../cusers/inc/js.cfm">
<cfhtmlhead text="#session.dateKey#">
<cfparam name="rc.activeTab" default="0" />
<cfset rsSubTypes=application.classExtensionManager.getSubTypesByType(type=2,siteID=rc.userBean.getSiteID(),activeOnly=true) />
<cfquery name="rsNonDefault" dbtype="query">
select * from rsSubTypes where subType <> 'Default'
</cfquery>
<cfset tabLabelList='#application.rbFactory.getKeyValue(session.rb,'user.basic')#,#application.rbFactory.getKeyValue(session.rb,'user.addressinformation')#,#application.rbFactory.getKeyValue(session.rb,'user.interests')#'>
<cfset tablist="tabBasic,tabAddressinformation,tabInterests">
<cfif rsSubTypes.recordcount>
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,'user.extendedattributes'))>
<cfset tabList=listAppend(tabList,"tabExtendedattributes")>
</cfif>
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,'user.advanced'))>
<cfset tabList=listAppend(tabList,"tabAdvanced")>
<form novalidate="novalidate" action="./?muraAction=cEditProfile.update" method="post" enctype="multipart/form-data" name="form1" class="columns" onsubmit="return validate(this);">
<cfoutput><h1>#application.rbFactory.getKeyValue(session.rb,'user.editprofile')#</h1>

	<cfif not structIsEmpty(rc.userBean.getErrors())>
		<div class="alert alert-error">#application.utility.displayErrors(rc.userBean.getErrors())#</div>
	</cfif>
	
	<p>(*Required, **Required to login to Site)<p>

<div class="tabbable tabs-left mura-ui">

	<ul class="nav nav-tabs tabs initActiveTab">
	<cfloop from="1" to="#listlen(tabList)#" index="t">
	<li><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
	</cfloop>
	</ul>

	<div class="tab-content">
	
	<div id="tabBasic" class="tab-pane fade in">
		<div class="fieldset">
		
		<cfif rsNonDefault.recordcount>
		<div class="control-group">
      		<label class="control-label">
      			#application.rbFactory.getKeyValue(session.rb,'user.type')#
			</label>
     	 <div class="controls">
	     	 <select name="subtype"  onchange="resetExtendedAttributes('#rc.userBean.getUserID()#','2',this.value,'#application.settingsManager.getSite(rc.userBean.getSiteID()).getPublicUserPoolID()#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.userBean.getSiteID()).getThemeAssetPath()#');">
			<option value="Default" <cfif  rc.userBean.getSubType() eq "Default">selected</cfif>> #application.rbFactory.getKeyValue(session.rb,'user.default')#</option>
				<cfloop query="rsNonDefault">
					<option value="#rsNonDefault.subtype#" <cfif rc.userBean.getSubType() eq rsNonDefault.subtype>selected</cfif>>#rsNonDefault.subtype#</option>
				</cfloop>
			</select>
		    </div>
    	</div>
    	
		<cfelse>
			<input type="hidden" name="subtype" value="Default"/>
		</cfif>
		
		
			<div class="control-group">
			<div class="span6">
	     		<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.fname')#*</label>
			    <div class="controls">
			    	<input id="fname" name="fname" type="text" class="span12" value="#esapiEncode('html_attr',rc.userBean.getfname())#" required="true" message="#application.rbFactory.getKeyValue(session.rb,'user.fnamerequired')#">
			    </div>
		    </div>
		    
		    <div class="span6">
	      		<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.lname')#*</label>
	      		<div class="controls"><input id="lname" name="lname" type="text" value="#esapiEncode('html_attr',rc.userBean.getlname())#" required="true" message="#application.rbFactory.getKeyValue(session.rb,'user.lnamerequired')#" class="span12">
	        </div>
		</div>
    </div>

   
		
		<div class="control-group">
			<div class="span6">
	      		<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.company')#</label>
	      		<div class="controls"><input id="organization" name="company" type="text" value="#esapiEncode('html_attr',rc.userBean.getcompany())#"  class="span12"></div>
	        </div>
			
			<div class="span6">
	      	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.jobtitle')#</label>
	      	<div class="controls"><input id="jobtitle" name="jobtitle" type="text" value="#esapiEncode('html_attr',rc.userBean.getjobtitle())#"  class="span12"></div>
	      	</div>
		</div>
		
		<div class="control-group">
			<div class="span6">
	      		<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.email')#*</label>
	      		<div class="controls"><input id="email" name="email" type="text" validate="email" message="#application.rbFactory.getKeyValue(session.rb,'user.emailvalidate')#" value="#esapiEncode('html_attr',rc.userBean.getemail())#" class="span12"></div>
	      	</div>
	      	
			<div class="span6">
	      		<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.mobilephone')#</label>
	      		<div class="controls"><input id="mobilePhone" name="mobilePhone" type="text" value="#esapiEncode('html_attr',rc.userBean.getMobilePhone())#" class="span12"></div>
			</div>
		</div>
		
		<div class="control-group">
      		<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.username')#**</label>
      		<div class="controls"><input id="username" name="usernameNoCache" type="text" value="#esapiEncode('html_attr',rc.userBean.getusername())#" class="span6" message="#application.rbFactory.getKeyValue(session.rb,'user.usernamerequired')#" >
          </div>
    </div>
		
		<div class="control-group">
			<div class="span6">
	      		<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.newpassword')#**</label>
	      		<div class="controls"><input name="passwordNoCache"  autocomplete="off" validate="match" matchfield="password2" type="password" value="" class="span12"  message="#application.rbFactory.getKeyValue(session.rb,'user.passwordmatchvalidate')#"></div>
	      	</div>
			
			<div class="span6">
	      		<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.newpasswordconfirm')#**</label>
	      		<div class="controls"><input  name="password2" autocomplete="off" type="password" value="" class="span12" message="#application.rbFactory.getKeyValue(session.rb,'user.passwordconfirmvalidate')#"></div>
	      	</div>
	    </div>
    

    <div class="control-group">
      		<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.image')#</label>
      	<div class="controls">
      		<input type="file" name="newFile" validate="regex" regex="(.+)(\.)(jpg|JPG)" message="Your logo must be a .JPG" value=""/>
        </div>
        <cfif len(rc.userBean.getPhotoFileID())>
	        <div class="controls">
	        	<a href="./index.cfm?muraAction=cArch.imagedetails&userid=#rc.userBean.getUserID()#&siteid=#rc.userBean.getSiteID()#&fileid=#rc.userBean.getPhotoFileID()#"><img id="assocImage" src="#application.configBean.getContext()#/index.cfm/_api/render/file/?fileid=#rc.userBean.getPhotoFileID()#&cacheID=#createUUID()#" /></a>
	        	
	        	<input type="checkbox" name="removePhotoFile" value="true"> #application.rbFactory.getKeyValue(session.rb,'user.delete')# 
	        </div>
        </cfif>
    </div>

	<span id="extendSetsBasic"></span>
</div>
	</div>
	
	<div id="tabAddressinformation" class="tab-pane fade in">
		<div class="fieldset">

			<div class="control-group">
				<ul class="navTask nav nav-pills"><li><a href="./?muraAction=cPrivateUsers.editAddress&userID=#session.mura.userID#&siteid=#rc.userBean.getsiteid()#&routeID=#rc.routeid#&addressID=&returnURL=#esapiEncode('url',cgi.query_string)#">#application.rbFactory.getKeyValue(session.rb,'user.addnewaddress')#</a></li></ul>
				
		      <cfset rsAddresses=rc.userBean.getAddresses()>
				<cfif rsAddresses.recordcount>
				<table class="mura-table-grid">
				<tr><th>#application.rbFactory.getKeyValue(session.rb,'user.primary')#</th><th>#application.rbFactory.getKeyValue(session.rb,'user.address')#</th><th class="adminstration"></th></tr>
				<cfloop query="rsAddresses">
				<tr>
					<td>
					<input type="radio" name="primaryAddressID" value="#rsAddresses.addressID#" <cfif rsAddresses.isPrimary eq 1 or rsAddresses.recordcount eq 1>checked</cfif>>
					</td>
					<td class="var-width">
					<cfif rsAddresses.addressName neq ''><strong>#rsAddresses.addressName#</strong><br/></cfif>
					<cfif rsAddresses.address1 neq ''>#rsAddresses.address1#<br/></cfif>
					<cfif rsAddresses.address2 neq ''>#rsAddresses.address2#<br/></cfif>
					<cfif rsAddresses.city neq ''>#rsAddresses.city# </cfif><cfif rsAddresses.state neq ''><cfif rsaddresses.city neq ''>,</cfif> #rsAddresses.state# </cfif><cfif rsaddresses.zip neq ''> #rsAddresses.zip#</cfif><cfif rsAddresses.city neq '' or rsAddresses.state neq '' or rsAddresses.zip neq ''><br/></cfif>
					<cfif rsAddresses.phone neq ''>#application.rbFactory.getKeyValue(session.rb,'user.phone')#: #rsAddresses.phone#<br/></cfif>
					<cfif rsAddresses.fax neq ''>#application.rbFactory.getKeyValue(session.rb,'user.fax')#: #rsAddresses.fax#<br/></cfif>
					<cfif rsAddresses.addressURL neq ''>#application.rbFactory.getKeyValue(session.rb,'user.website')#: <a href="#rsAddresses.addressURL#" target="_blank">#rsAddresses.addressURL#</a><br/></cfif>
					<cfif rsAddresses.addressEmail neq ''>#application.rbFactory.getKeyValue(session.rb,'user.email')#: <a href="mailto:#rsAddresses.addressEmail#">#rsAddresses.addressEmail#</a></cfif>
					</td>
					<td nowrap class="actions"><ul class="users"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="./?muraAction=cPrivateUsers.editAddress&userID=#session.mura.userID#&siteid=#rc.userBean.getsiteid()#&routeID=#rc.routeid#&addressID=#rsAddresses.addressID#&returnURL=#esapiEncode('url',cgi.query_string)#"><i class="icon-pencil"></i></a></li>
					<cfif rsAddresses.isPrimary neq 1><li class="delete"><a title="Delete" href="./?muraAction=cPrivateUsers.updateAddress&userID=#session.mura.userID#&action=delete&siteid=#rc.userBean.getsiteid()#&routeID=#rc.routeid#&addressID=#rsAddresses.addressID#&returnURL=#esapiEncode('url',cgi.query_string)#" onclick="return confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'user.deleteaddressconfirm'))#',this.href);"><i class="icon-remove-sign"></i></a></li><cfelse><li class="delete disabled">#application.rbFactory.getKeyValue(session.rb,'user.delete')#</li></cfif></ul></td>
				</tr>
				</cfloop>
				</table>
				<cfelse>
				<p class="alert">#application.rbFactory.getKeyValue(session.rb,'user.noaddressinformation')#</p>
				</cfif>
		    </div>
		</div>
	</div>
	
	<div id="tabInterests" class="tab-pane">
		<div class="fieldset">
			<div id="mura-list-tree" class="control-group">
			<cfloop collection="#application.settingsManager.getSites()#" item="site">
				<cfif application.settingsManager.getSite(site).getPrivateUserPoolID() eq application.settingsManager.getSite(rc.siteID).getPrivateUserPoolID()>
						<cfoutput><label class="control-label">#application.settingsManager.getSite(site).getSite()#</label></cfoutput>
						<cf_dsp_categories_nest siteID="#rc.siteID#" parentID="" categoryID="#rc.categoryID#" nestLevel="0"  userBean="#rc.userBean#">
				</cfif>
			</cfloop> 
		</div>
	    </div>
	</div>
	
	<cfif rsSubTypes.recordcount>
	<div id="tabExtendedattributes" class="tab-pane fade in">
		<div class="fieldset">
				<span id="extendSetsDefault"></span>
				<script type="text/javascript">
				userManager.loadExtendedAttributes('#rc.userbean.getUserID()#','#rc.userbean.getType()#','#rc.userBean.getSubType()#','#application.settingsManager.getSite(rc.userBean.getSiteID()).getPrivateUserPoolID()#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.userbean.getSiteID()).getThemeAssetPath()#');
				</script>
		</div>
	</div>
	<cfhtmlhead text='<script type="text/javascript" src="assets/js/user.js"></script>'>
	</cfif>
	
	<div id="tabAdvanced" class="tab-pane fade in">
		<div class="fieldset">
			<div class="control-group">
				<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.emailbroadcaster')#</label>
				<div class="controls">
					<label class="radio inline">
					<input name="subscribe" type="radio" class="radio" value="1"<cfif rc.userBean.getsubscribe() eq 1>Checked</cfif>>
					#application.rbFactory.getKeyValue(session.rb,'user.yes')#
					</label>
					<label class="radio inline">
					<input name="subscribe" type="radio" class="radio" value="0"<cfif rc.userBean.getsubscribe() eq 0>Checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.no')#
					</label>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.tags')#</label>
				<div class="controls">
					<input id="tags" name="tags" type="text" value="#esapiEncode('html_attr',rc.userBean.getTags())#" class="span12">
				</div>
			</div>
		</div>
	</div>
	
	<div class="form-actions">
		<input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'user.update')#" />
	</div>
	
</div>
		<input type="hidden" name="type" value="2">
		<input type="hidden" name="action" value="">
		<input type="hidden" name="contact" value="0">
		<input type="hidden" name="userid" value="#rc.userBean.getuserid()#">
		<input type="hidden" name="siteid" value="#rc.userBean.getsiteid()#">
		#rc.$.renderCSRFTokens(format="form")#
<!---		
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="assets/js/tab-view.js"></script>'>
<script type="text/javascript">
initTabs(Array("#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'user.basic'))#","#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'user.addressinformation'))#","#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'user.interests'))#"<cfif rsSubTypes.recordcount>,"#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'user.extendedattributes'))#"</cfif>,"#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'user.advanced'))#"),#rc.activeTab#,0,0);
</script>	
--->
	</cfoutput>
</form>