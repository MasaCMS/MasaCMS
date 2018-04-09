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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfinclude template="../cusers/inc/js.cfm">
<cfhtmlhead text="#session.dateKey#">
<cfhtmlhead text='<script type="text/javascript" src="assets/js/user.js"></script>'>
<cfparam name="rc.activeTab" default="0" />
<cfset rsSubTypes=application.classExtensionManager.getSubTypesByType(type=2,siteID=rc.userBean.getSiteID(),activeOnly=true) />
<cfquery name="rsNonDefault" dbtype="query">
select * from rsSubTypes where subType <> 'Default'
</cfquery>

<cfif not len(rc.routeid)>
	<cfset rc.routeid='editprofile'>
</cfif>
<cfset tabLabelList='#rc.$.rbKey('user.basic')#,#rc.$.rbKey('user.addressinformation')#,#rc.$.rbKey('user.interests')#'>
<cfset tablist="tabBasic,tabAddressinformation,tabInterests">
<cfif rsSubTypes.recordcount>
<cfset tabLabelList=listAppend(tabLabelList,rc.$.rbKey('user.extendedattributes'))>
<cfset tabList=listAppend(tabList,"tabExtendedattributes")>
</cfif>
<cfset tabLabelList=listAppend(tabLabelList,rc.$.rbKey('user.advanced'))>
<cfset tabList=listAppend(tabList,"tabAdvanced")>

<cfoutput>
<div class="mura-header">
	<h1>#rc.$.rbKey('user.editprofile')#</h1>
</div> <!-- /.mura-header -->

<cfif not structIsEmpty(rc.userBean.getErrors())>
	<div class="alert alert-error"><span>#application.utility.displayErrors(rc.userBean.getErrors())#</span></div>
</cfif>

<form novalidate="novalidate" action="./?muraAction=cEditProfile.update" method="post" enctype="multipart/form-data" name="form1" class="columns" onsubmit="return userManager.submitForm(this);">

<div class="block block-constrain">

	<ul class="mura-tabs nav-tabs" data-toggle="tabs">
	<cfloop from="1" to="#listlen(tabList)#" index="t">
	<li<cfif t eq 1> class="active"</cfif>><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
	</cfloop>
	</ul> <!-- /.mura-tabs -->


		  <div class="block-content tab-content">

					<div id="tabBasic" class="tab-pane active">
						<div class="block block-bordered">
							<!-- block header -->
							<div class="block-header">
								<h3 class="block-title">#rc.$.rbKey('user.basic')#</h3>
							</div> <!-- /.block header -->
							<div class="block-content">

								<cfif rsNonDefault.recordcount>
								<div class="help-block-inline">#rbKey('user.requiredtext')#</div>
								<div class="mura-control-group">
				      		<label>#rc.$.rbKey('user.type')#</label>
							     	 <select name="subtype"  onchange="resetExtendedAttributes('#rc.userBean.getUserID()#','2',this.value,'#application.settingsManager.getSite(rc.userBean.getSiteID()).getPublicUserPoolID()#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.userBean.getSiteID()).getThemeAssetPath()#');">
										<option value="Default" <cfif  rc.userBean.getSubType() eq "Default">selected</cfif>> #rc.$.rbKey('user.default')#</option>
										<cfloop query="rsNonDefault">
											<option value="#rsNonDefault.subtype#" <cfif rc.userBean.getSubType() eq rsNonDefault.subtype>selected</cfif>>#rsNonDefault.subtype#</option>
										</cfloop>
									</select>
						    	</div>

								<cfelse>
									<input type="hidden" name="subtype" value="Default"/>
									<div class="help-block-inline">#rbKey('user.requiredtext')#</div>
								</cfif>

								<div class="mura-control-group">
						     		<label>#rc.$.rbKey('user.fname')#*</label>
								    <input id="fname" name="fname" type="text" value="#esapiEncode('html_attr',rc.userBean.getfname())#" required="true" message="#rc.$.rbKey('user.fnamerequired')#"/>
						    </div>

								<div class="mura-control-group">
						      	<label>#rc.$.rbKey('user.lname')#*</label>
						      	<input id="lname" name="lname" type="text" value="#esapiEncode('html_attr',rc.userBean.getlname())#" required="true" message="#rc.$.rbKey('user.lnamerequired')#"/>
						    </div>

								<div class="mura-control-group">
							      	<label>#rc.$.rbKey('user.company')#</label>
							      	<input id="organization" name="company" type="text" value="#esapiEncode('html_attr',rc.userBean.getcompany())#" />
								</div>

								<div class="mura-control-group">
							      <label>#rc.$.rbKey('user.jobtitle')#</label>
							      <input id="jobtitle" name="jobtitle" type="text" value="#esapiEncode('html_attr',rc.userBean.getjobtitle())#" />
								</div>

								<div class="mura-control-group">
							      <label>#rc.$.rbKey('user.email')#*</label>
							      <input id="email" name="email" type="text" validate="email" message="#rc.$.rbKey('user.emailvalidate')#" value="#esapiEncode('html_attr',rc.userBean.getemail())#"/>
								</div>

								<div class="mura-control-group">
							      	<label>#rc.$.rbKey('user.mobilephone')#</label>
							      	<input id="mobilePhone" name="mobilePhone" type="text" value="#esapiEncode('html_attr',rc.userBean.getMobilePhone())#"/>
								</div>

								<div class="mura-control-group">
						      		<label>#rc.$.rbKey('user.username')#**</label>
						      		<input id="username" name="usernameNoCache" type="text" value="#esapiEncode('html_attr',rc.userBean.getusername())#" message="#rc.$.rbKey('user.usernamerequired')#" />
						    </div>

								<cfif isBoolean($.globalConfig('strongpasswords')) and $.globalConfig('strongpasswords')>
									<div class="help-block-inline">#$.rbKey('user.passwordstrengthhelptext')#</div>
								</cfif>

								<div class="mura-control-group">
							      	<label>#rc.$.rbKey('user.newpassword')#**</label>
							      	<input name="passwordNoCache"  autocomplete="off" validate="match" matchfield="password2" type="password" value=""  message="#rc.$.rbKey('user.passwordmatchvalidate')#" autocomplete="off"/>
						    </div>

								<div class="mura-control-group">
							      	<label>#rc.$.rbKey('user.newpasswordconfirm')#**</label>
							      	<input name="password2" autocomplete="off" type="password" value="" message="#rc.$.rbKey('user.passwordconfirmvalidate')#" autocomplete="off"/>
						    </div>


						    <div class="mura-control-group">
						      	<label>#rc.$.rbKey('user.image')#</label>
						      	<input type="file" name="newFile" validate="regex" regex="(.+)(\.)(jpg|JPG|jpeg|JPEG|png|PNG)" message="Your logo must be a .JPG" value=""/>
						        <cfif len(rc.userBean.getPhotoFileID())>
							        	<a href="./index.cfm?muraAction=cArch.imagedetails&userid=#rc.userBean.getUserID()#&siteid=#rc.userBean.getSiteID()#&fileid=#rc.userBean.getPhotoFileID()#"><img id="assocImage" src="#application.configBean.getContext()#/index.cfm/_api/render/medium/?fileid=#rc.userBean.getPhotoFileID()#&cacheID=#createUUID()#" /></a>

							        	<input type="checkbox" name="removePhotoFile" value="true"> #rc.$.rbKey('user.delete')#
						        </cfif>
						    </div>

							<span id="extendSetsBasic"></span>
							</div> <!-- /.block-content -->
						</div> <!-- /.block-bordered -->
					</div> <!-- /.tab-pane -->
					<!-- /end tab -->

					<div id="tabAddressinformation" class="tab-pane">
						<div class="block block-bordered">
							<!-- block header -->
							<div class="block-header">
								<h3 class="block-title">#rc.$.rbKey('user.addressinformation')#</h3>
							</div> <!-- /.block header -->
							<div class="block-content">

								<div class="mura-control-group">
									<ul class="navTask nav nav-pills"><li><a href="./?muraAction=cusers.editAddress&userID=#session.mura.userID#&siteid=#rc.userBean.getsiteid()#&routeID=#rc.routeid#&addressID=&returnURL=#esapiEncode('url',cgi.query_string)#">#rc.$.rbKey('user.addnewaddress')#</a></li></ul>

							      <cfset rsAddresses=rc.userBean.getAddresses()>
									<cfif rsAddresses.recordcount>
									<table class="table table-striped table-condensed table-bordered mura-table-grid">
									<tr><th>#rc.$.rbKey('user.primary')#</th><th>#rc.$.rbKey('user.address')#</th><th class="adminstration"></th></tr>
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
										<cfif rsAddresses.phone neq ''>#rc.$.rbKey('user.phone')#: #rsAddresses.phone#<br/></cfif>
										<cfif rsAddresses.fax neq ''>#rc.$.rbKey('user.fax')#: #rsAddresses.fax#<br/></cfif>
										<cfif rsAddresses.addressURL neq ''>#rc.$.rbKey('user.website')#: <a href="#rsAddresses.addressURL#" target="_blank">#rsAddresses.addressURL#</a><br/></cfif>
										<cfif rsAddresses.addressEmail neq ''>#rc.$.rbKey('user.email')#: <a href="mailto:#rsAddresses.addressEmail#">#rsAddresses.addressEmail#</a></cfif>
										</td>
										<td nowrap class="actions"><ul><li class="edit"><a title="#rc.$.rbKey('user.edit')#" href="./?muraAction=cusers.editAddress&userID=#session.mura.userID#&siteid=#rc.userBean.getsiteid()#&routeID=#rc.routeid#&addressID=#rsAddresses.addressID#&returnURL=#esapiEncode('url',cgi.query_string)#"><i class="mi-pencil"></i></a></li>
										<cfif rsAddresses.isPrimary neq 1><li class="delete"><a title="Delete" href="./?muraAction=cusers.updateAddress&userID=#session.mura.userID#&action=delete&siteid=#rc.userBean.getsiteid()#&routeID=#rc.routeid#&addressID=#rsAddresses.addressID#&returnURL=#esapiEncode('url',cgi.query_string)#" onclick="return confirmDialog('#esapiEncode('javascript',rc.$.rbKey('user.deleteaddressconfirm'))#',this.href);"><i class="mi-trash"></i></a></li><cfelse><i class="mi-trash"></i></cfif></ul></td>
									</tr>
									</cfloop>
									</table>
									<cfelse>
									<div class="help-block-empty">#rc.$.rbKey('user.noaddressinformation')#</div>
									</cfif>
							    </div>

							</div> <!-- /.block-content -->
						</div> <!-- /.block-bordered -->
					</div> <!-- /.tab-pane -->
					<!-- /end tab -->

					<div id="tabInterests" class="tab-pane">

						<div class="block block-bordered">
							<!-- block header -->
							<div class="block-header">
								<h3 class="block-title">#rc.$.rbKey('user.interests')#</h3>
							</div> <!-- /.block header -->
							<div class="block-content">

							<div id="mura-list-tree" class="mura-control-group">
								<cfoutput><label>#application.settingsManager.getSite(rc.userBean.getSiteID()).getSite()#</label></cfoutput>
								<cf_dsp_categories_nest siteID="#rc.userBean.getSiteID()#" parentID="" categoryID="#rc.categoryID#" nestLevel="0"  userBean="#rc.userBean#" rc="#rc#">
								<cfset matchedlist=rc.userBean.getSiteID()>
								<cfloop collection="#application.settingsManager.getSites()#" item="site">
									<cfif not listFindNoCase(matchedlist,application.settingsManager.getSite(site).getPrivateUserPoolID()) and  application.settingsManager.getSite(site).getPrivateUserPoolID() eq application.settingsManager.getSite(rc.siteID).getPrivateUserPoolID()>
										<cfoutput><label>#application.settingsManager.getSite(site).getSite()#</label></cfoutput>
										<cf_dsp_categories_nest siteID="#site#" parentID="" categoryID="#rc.categoryID#" nestLevel="0" userBean="#rc.userBean#" rc="#rc#">
									</cfif>
									<cfset matchedlist=listAppend(matchedlist,application.settingsManager.getSite(site).getPrivateUserPoolID())>
								</cfloop>
					    	</div>

							</div> <!-- /.block-content -->
						</div> <!-- /.block-bordered -->
					</div> <!-- /.tab-pane -->
					<!-- /end tab -->

					<cfif rsSubTypes.recordcount>
					<div id="tabExtendedattributes" class="tab-pane">
						<div class="block block-bordered">
							<!-- block header -->
							<div class="block-header">
								<h3 class="block-title">#rc.$.rbKey('user.extendedattributes')#</h3>
							</div> <!-- /.block header -->
							<div class="block-content">
								<span id="extendSetsDefault"></span>
								<script type="text/javascript">
								userManager.loadExtendedAttributes('#rc.userbean.getUserID()#','#rc.userbean.getType()#','#rc.userBean.getSubType()#','#application.settingsManager.getSite(rc.userBean.getSiteID()).getPrivateUserPoolID()#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.userbean.getSiteID()).getThemeAssetPath()#');
								</script>

							</div> <!-- /.block-content -->
						</div> <!-- /.block-bordered -->
					</div> <!-- /.tab-pane -->
					<!-- /end tab -->
					</cfif>

					<div id="tabAdvanced" class="tab-pane">
						<div class="block block-bordered">
							<!-- block header -->
							<div class="block-header">
								<h3 class="block-title">#rc.$.rbKey('user.advanced')#</h3>
							</div> <!-- /.block header -->
							<div class="block-content">

								<div class="mura-control-group">
									<label>#rc.$.rbKey('user.emailbroadcaster')#</label>
										<label class="radio inline">
										<input name="subscribe" type="radio" class="radio" value="1"<cfif rc.userBean.getsubscribe() eq 1>Checked</cfif>>
										#rc.$.rbKey('user.yes')#
										</label>
										<label class="radio inline">
										<input name="subscribe" type="radio" class="radio" value="0"<cfif rc.userBean.getsubscribe() eq 0>Checked</cfif>>#rc.$.rbKey('user.no')#
										</label>
								</div>
								<div class="mura-control-group">
									<label>#rc.$.rbKey('user.tags')#</label>
										<input id="tags" name="tags" type="text" value="#esapiEncode('html_attr',rc.userBean.getTags())#">
								</div>
							</div> <!-- /.block-content -->
						</div> <!-- /.block-bordered -->
					</div> <!-- /.tab-pane -->
					<!-- /end tab -->

				</div> <!-- /.block-content.tab-content -->

	<div class="mura-actions">
		<div class="form-actions">
			<button type="button" class="btn mura-primary" onclick="userManager.submitForm(document.forms.form1,'update');"><i class="mi-check-circle"></i>#rc.$.rbKey('user.update')#</button>
		</div>
	</div>

</div> <!-- /.block-constrain -->

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
initTabs(Array("#esapiEncode('javascript',rc.$.rbKey('user.basic'))#","#esapiEncode('javascript',rc.$.rbKey('user.addressinformation'))#","#esapiEncode('javascript',rc.$.rbKey('user.interests'))#"<cfif rsSubTypes.recordcount>,"#esapiEncode('javascript',rc.$.rbKey('user.extendedattributes'))#"</cfif>,"#esapiEncode('javascript',rc.$.rbKey('user.advanced'))#"),#rc.activeTab#,0,0);
</script>
--->
	</cfoutput>
</form>
