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
<cfhtmlhead text="#session.dateKey#">
<cfparam name="attributes.activeTab" default="0" />
<cfset rsSubTypes=application.classExtensionManager.getSubTypesByType(type=2,siteID=request.userBean.getSiteID(),activeOnly=true) />
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
<form novalidate="novalidate" action="index.cfm?fuseaction=cEditProfile.update" method="post" enctype="multipart/form-data" name="form1" class="columns" onsubmit="return validate(this);">
<cfoutput><h2>#application.rbFactory.getKeyValue(session.rb,'user.editprofile')#</h2>

	#application.utility.displayErrors(request.userBean.getErrors())#
	
	<p>(*Required, **Required to login to Site)<p>

<div class="tabs initActiveTab">
<ul>
<cfloop from="1" to="#listlen(tabList)#" index="t">
<li><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
</cfloop>
</ul>
	
<div id="tabBasic">
<dl class="oneColumn">
		<cfif rsNonDefault.recordcount>
		<dt class="first">#application.rbFactory.getKeyValue(session.rb,'user.type')#</dt>
		<dd><select name="subtype" class="dropdown" onchange="resetExtendedAttributes('#request.userBean.getUserID()#','2',this.value,'#application.settingsManager.getSite(request.userBean.getSiteID()).getPublicUserPoolID()#','#application.configBean.getContext()#','#application.settingsManager.getSite(request.userBean.getSiteID()).getThemeAssetPath()#');">
			<option value="Default" <cfif  request.userBean.getSubType() eq "Default">selected</cfif>> #application.rbFactory.getKeyValue(session.rb,'user.default')#</option>
				<cfloop query="rsNonDefault">
					<option value="#rsNonDefault.subtype#" <cfif request.userBean.getSubType() eq rsNonDefault.subtype>selected</cfif>>#rsNonDefault.subtype#</option>
				</cfloop>
			</select>
		</dd>
		<cfelse>
			<input type="hidden" name="subtype" value="Default"/>
		</cfif>
		
		<dt <cfif not  rsNonDefault.recordcount>class="first"</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.fname')#*</dt>
		<dd><input id="fname" name="fname" type="text" value="#HTMLEditFormat(request.userBean.getfname())#"  required="true" message="#application.rbFactory.getKeyValue(session.rb,'user.fnamerequired')#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.lname')#*</dt>
		<dd><input id="lname" name="lname" type="text" value="#HTMLEditFormat(request.userBean.getlname())#"  required="true" message="#application.rbFactory.getKeyValue(session.rb,'user.lnamerequired')#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.company')#</dt>
		<dd><input id="organization" name="company" type="text" value="#HTMLEditFormat(request.userBean.getcompany())#"  class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.jobtitle')#</dt>
		<dd><input id="jobtitle" name="jobtitle" type="text" value="#HTMLEditFormat(request.userBean.getjobtitle())#"  class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.mobilephone')#</dt>
		<dd><input id="mobilePhone" name="mobilePhone" type="text" value="#HTMLEditFormat(request.userBean.getMobilePhone())#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.email')#*</dt>
		<dd><input id="email" name="email" type="text" validate="email" message="#application.rbFactory.getKeyValue(session.rb,'user.emailvalidate')#" value="#HTMLEditFormat(request.userBean.getemail())#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.username')#**</dt>
		<dd><input id="username" name="usernameNoCache" type="text" value="#HTMLEditFormat(request.userBean.getusername())#" class="text" message="#application.rbFactory.getKeyValue(session.rb,'user.usernamerequired')#" ></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.newpassword')#**</dt>
		<dd><input name="passwordNoCache"  autocomplete="off" validate="match" matchfield="password2" type="password" value="" class="text"  message="#application.rbFactory.getKeyValue(session.rb,'user.passwordmatchvalidate')#"></dd> 
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.newpasswordconfirm')#**</dt>
		<dd><input  name="password2" autocomplete="off" type="password" value="" class="text" message="#application.rbFactory.getKeyValue(session.rb,'user.passwordconfirmvalidate')#"></dd>  
<span id="extendSetsBasic"></span>
</dl>
</div>
<div id="tabAddressinformation">
<dl class="oneColumn">
<dt class="first"><ul id="navTask"><li><a href="index.cfm?fuseaction=cPrivateUsers.editAddress&userID=#session.mura.userID#&siteid=#request.userBean.getsiteid()#&routeID=#attributes.routeid#&addressID=&returnURL=#urlencodedformat(cgi.query_string)#">#application.rbFactory.getKeyValue(session.rb,'user.addnewaddress')#</a></li></ul></dt>
		<cfset rsAddresses=request.userBean.getAddresses()>
		<dd>
		<cfif rsAddresses.recordcount>
		<table id="metadata">
		<tr><th>#application.rbFactory.getKeyValue(session.rb,'user.primary')#</th><th>#application.rbFactory.getKeyValue(session.rb,'user.address')#</th><th class="adminstration"></th></tr>
		<cfloop query="rsAddresses">
		<tr>
			<td>
			<input type="radio" name="primaryAddressID" value="#rsAddresses.addressID#" <cfif rsAddresses.isPrimary eq 1 or rsAddresses.recordcount eq 1>checked</cfif>>
			</td>
			<td>
			<cfif rsAddresses.addressName neq ''><strong>#rsAddresses.addressName#</strong><br/></cfif>
			<cfif rsAddresses.address1 neq ''>#rsAddresses.address1#<br/></cfif>
			<cfif rsAddresses.address2 neq ''>#rsAddresses.address2#<br/></cfif>
			<cfif rsAddresses.city neq ''>#rsAddresses.city# </cfif><cfif rsAddresses.state neq ''><cfif rsaddresses.city neq ''>,</cfif> #rsAddresses.state# </cfif><cfif rsaddresses.zip neq ''> #rsAddresses.zip#</cfif><cfif rsAddresses.city neq '' or rsAddresses.state neq '' or rsAddresses.zip neq ''><br/></cfif>
			<cfif rsAddresses.phone neq ''>#application.rbFactory.getKeyValue(session.rb,'user.phone')#: #rsAddresses.phone#<br/></cfif>
			<cfif rsAddresses.fax neq ''>#application.rbFactory.getKeyValue(session.rb,'user.fax')#: #rsAddresses.fax#<br/></cfif>
			<cfif rsAddresses.addressURL neq ''>#application.rbFactory.getKeyValue(session.rb,'user.website')#: <a href="#rsAddresses.addressURL#" target="_blank">#rsAddresses.addressURL#</a><br/></cfif>
			<cfif rsAddresses.addressEmail neq ''>#application.rbFactory.getKeyValue(session.rb,'user.email')#: <a href="mailto:#rsAddresses.addressEmail#">#rsAddresses.addressEmail#</a></cfif>
			</td>
			<td nowrap class="administration"><ul class="users"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?fuseaction=cPrivateUsers.editAddress&userID=#session.mura.userID#&siteid=#request.userBean.getsiteid()#&routeID=#attributes.routeid#&addressID=#rsAddresses.addressID#&returnURL=#urlencodedformat(cgi.query_string)#">[#application.rbFactory.getKeyValue(session.rb,'user.edit')#]</a></li>
			<cfif rsAddresses.isPrimary neq 1><li class="delete"><a title="Delete" href="index.cfm?fuseaction=cPrivateUsers.updateAddress&userID=#session.mura.userID#&action=delete&siteid=#request.userBean.getsiteid()#&routeID=#attributes.routeid#&addressID=#rsAddresses.addressID#&returnURL=#urlencodedformat(cgi.query_string)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.deleteaddressconfirm'))#',this.href);">[#application.rbFactory.getKeyValue(session.rb,'user.delete')#]</a></li><cfelse><li class="deleteOff">#application.rbFactory.getKeyValue(session.rb,'user.delete')#</li></cfif></ul></td>
		</tr>
		</cfloop>
		</table>
		<cfelse>
		<em>#application.rbFactory.getKeyValue(session.rb,'user.noaddressinformation')#</em>
		</cfif>
		</dd>
	</dl>
</div>

<div id="tabInterests">
		<dl class="oneColumn">
		<dd class="first">
			<cfif application.categoryManager.getCategoryCount( request.userBean.getsiteID())>
			<!---<ul class="interestGroups">--->
				<cfloop collection="#application.settingsManager.getSites()#" item="site">
					<cfif application.settingsManager.getSite(site).getPrivateUserPoolID() eq request.userBean.getsiteID()>
						<!---<li>--->
							<cfoutput><h4>#application.settingsManager.getSite(site).getSite()#</h4>
							<div class="divide"></div>
							</cfoutput>
							<cf_dsp_categories_nest siteID="#request.userBean.getsiteID()#" parentID="" categoryID="#attributes.categoryID#" nestLevel="0" >
						<!---</li>--->
					</cfif>
				</cfloop>
			<!---</ul>--->
			<cfelse>
			<em>#application.rbFactory.getKeyValue(session.rb,'user.nointerestcategories')#</em>
			</cfif> 
		</dd>
		
	</dl>
</div>
<cfif rsSubTypes.recordcount>
<div id="tabExtendedattributes">
			<span id="extendSetsDefault"></span>
			<script type="text/javascript">
			loadExtendedAttributes('#request.userbean.getUserID()#','#request.userbean.getType()#','#request.userBean.getSubType()#','#application.settingsManager.getSite(request.userBean.getSiteID()).getPrivateUserPoolID()#','#application.configBean.getContext()#','#application.settingsManager.getSite(request.userbean.getSiteID()).getThemeAssetPath()#');
			</script>	
</div>
	<cfhtmlhead text='<script type="text/javascript" src="js/user.js"></script>'>
</cfif>
<div id="tabAdvanced">
<dl class="oneColumn">
<dt>#application.rbFactory.getKeyValue(session.rb,'user.emailbroadcaster')#</dt>
<dd><ul class="radioGroup"><li><input name="subscribe" type="radio" class="radio" value="1"<cfif request.userBean.getsubscribe() eq 1>Checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.yes')#</li><li><input name="subscribe" type="radio" class="radio" value="0"<cfif request.userBean.getsubscribe() eq 0>Checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.no')#</li></ul></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'user.tags')#</dt>
<dd><input id="tags" name="tags" type="text" value="#HTMLEditFormat(request.userBean.getTags())#" class="text"></dd> 
</dl>
</div>
</div>
<div id="actionButtons">
<input type="button" class="submit" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'user.update')#" />
</div>
		<input type="hidden" name="type" value="2">
		<input type="hidden" name="action" value="">
		<input type="hidden" name="contact" value="0">
		<input type="hidden" name="userid" value="#request.userBean.getuserid()#">
		<input type="hidden" name="siteid" value="#request.userBean.getsiteid()#">
<!---		
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="js/tab-view.js"></script>'>
<script type="text/javascript">
initTabs(Array("#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.basic'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.addressinformation'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.interests'))#"<cfif rsSubTypes.recordcount>,"#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.extendedattributes'))#"</cfif>,"#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.advanced'))#"),#attributes.activeTab#,0,0);
</script>	
--->
	</cfoutput>
</form>