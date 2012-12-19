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
<cfsilent>
<cfset event=request.event>
<cfhtmlhead text="#session.dateKey#">
<cfparam name="rc.activeTab" default="0" />
<cfset userPoolID=application.settingsManager.getSite(rc.siteID).getPrivateUserPoolID()>
<cfset rsSubTypes=application.classExtensionManager.getSubTypesByType(type=2,siteID=userPoolID,activeOnly=true) />
<cfquery name="rsNonDefault" dbtype="query">
select * from rsSubTypes where subType <> 'Default'
</cfquery>
<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>
<cfset rsPluginScripts=application.pluginManager.getScripts("onUserEdit",rc.siteID)>
<cfset tabLabelList='#application.rbFactory.getKeyValue(session.rb,'user.basic')#,#application.rbFactory.getKeyValue(session.rb,'user.addressinformation')#,#application.rbFactory.getKeyValue(session.rb,'user.groupmemberships')#,#application.rbFactory.getKeyValue(session.rb,'user.interests')#'>
<cfset tablist="tabBasic,tabAddressinformation,tabGroupmemberships,tabInterests">
<cfif rsSubTypes.recordcount>
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,'user.extendedattributes'))>
<cfset tabList=listAppend(tabList,"tabExtendedattributes")>
</cfif>
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,'user.advanced'))>
<cfset tabList=listAppend(tabList,"tabAdvanced")></cfsilent>
<cfoutput><form novalidate="novalidate" action="index.cfm?muraAction=cPrivateUsers.update&userid=#URLEncodedFormat(rc.userid)#&routeid=#rc.routeid#&siteid=#URLEncodedFormat(rc.siteid)#" method="post" enctype="multipart/form-data" name="form1" onsubmit="return validate(this);"  autocomplete="off" >
	<h1>#application.rbFactory.getKeyValue(session.rb,'user.adminuserform')#</h1>
	
	<div id="nav-module-specific" class="btn-group">
	<a class="btn" href="##" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.back'))#" onclick="window.history.back(); return false;"><i class="icon-circle-arrow-left"></i> #HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.back'))#</a>
	</div>
	
	<cfif len(rc.userBean.getUsername())>
		<cfset strikes=createObject("component","mura.user.userstrikes").init(rc.userBean.getUsername(),application.configBean)>
		<cfif structKeyExists(rc,"removeBlock")>
			<cfset strikes.clear()>
		</cfif>
		<cfif strikes.isBlocked()>
			<p class="alert alert-error">
			#application.rbFactory.getKeyValue(session.rb,'user.blocked')#: #LSTimeFormat(strikes.blockedUntil(),"short")#
			<a href="?muraAction=cPrivateUsers.edituser&userid=#URLEncodedFormat(rc.userid)#&type=2&siteid=#URLEncodedFormat(rc.siteid)#&removeBlock">[#application.rbFactory.getKeyValue(session.rb,'user.remove')#]</a>
			</p>
		</cfif>
	</cfif>
	
	<cfif not structIsEmpty(rc.userBean.getErrors())>
		<p class="alert alert-error">#application.utility.displayErrors(rc.userBean.getErrors())#</p>
	</cfif>
	
	<p>#application.rbFactory.getKeyValue(session.rb,'user.requiredtext')#</p>
</cfoutput>	
<cfsavecontent variable="tabContent">
<cfoutput>	
<div id="tabBasic" class="tab-pane fade">	
	<div class="fieldset">
		<cfif rsNonDefault.recordcount>	
			<div class="control-group">
		      	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.type')#</label>
		     	<div class="controls">
		     		<select name="subtype"  onchange="userManager.resetExtendedAttributes('#rc.userBean.getUserID()#','2',this.value,'#userPoolID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#');">
						<option value="Default" <cfif  rc.userBean.getSubType() eq "Default">selected</cfif>> #application.rbFactory.getKeyValue(session.rb,'user.default')#</option>
						<cfloop query="rsNonDefault">
							<option value="#rsNonDefault.subtype#" <cfif rc.userBean.getSubType() eq rsNonDefault.subtype>selected</cfif>>#rsNonDefault.subtype#</option>
						</cfloop>
					</select>
				</div>
	    	</div>
		</cfif>
			
		<div class="control-group">
			<div class="span6">
		    	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.fname')#*</label>
			    <div class="controls">
			    	<input id="fname" name="fname" type="text" value="#HTMLEditFormat(rc.userBean.getfname())#"  required="true" message="#application.rbFactory.getKeyValue(session.rb,'user.fnamerequired')#" class="span12">
			  	</div>
		    </div>
			
			<div class="span6">
			    <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.lname')#*</label>
			    <div class="controls">
			      	<input id="lname" name="lname" type="text" value="#HTMLEditFormat(rc.userBean.getlname())#"  required="true" message="#application.rbFactory.getKeyValue(session.rb,'user.lnamerequired')#" class="span12">
			  	</div>
		    </div>
	    </div>
			
		<div class="control-group">
			<div class="span6">
		      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.company')#</label>
		      <div class="controls"><input id="organization" name="company" type="text" value="#HTMLEditFormat(rc.userBean.getcompany())#"  class="span12"></div>
		    </div>
				
			<div class="span6">
		      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.jobtitle')#</label>
		      <div class="controls"><input id="jobtitle" name="jobtitle" type="text" value="#HTMLEditFormat(rc.userBean.getjobtitle())#"  class="span12"></div>
		    </div>
		</div>
		
		<div class="control-group">
			<div class="span6">
		      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.email')#*</label>
		      <div class="controls"><input id="email" name="email" type="text" value="#HTMLEditFormat(rc.userBean.getemail())#" class="span12" required="true" validate="email" message="#application.rbFactory.getKeyValue(session.rb,'user.emailvalidate')#"></div>
		    </div>
				
			<div class="span6">
		      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.mobilephone')#</label>
		      <div class="controls"><input id="mobilePhone" name="mobilePhone" type="text" value="#HTMLEditFormat(rc.userBean.getMobilePhone())#" class="span12"></div>
		    </div>
	    </div>
			
		<div class="control-group">
			<div class="span6">
	      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.username')#*</label>
	      <div class="controls"><input id="username"  name="usernameNoCache" type="text" value="#HTMLEditFormat(rc.userBean.getusername())#" class="span12" required="true" message="The 'Username' field is required" autocomplete="off"></div>
	    	</div>
		</div>
			
		<div class="control-group">
			<div class="span6">
		      	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.newpassword')#**</label>
		    	<div class="controls">
		    		<input name="passwordNoCache" autocomplete="off" validate="match" matchfield="password2" type="password" value="" class="span12"  message="#application.rbFactory.getKeyValue(session.rb,'user.passwordmatchvalidate')#">
		    	</div>
		    </div>
			
			<div class="span6">
	      		<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.newpasswordconfirm')#**</label>
	      		<div class="controls">
	      			<input  name="password2" autocomplete="off" type="password" value="" class="span12"  message="#application.rbFactory.getKeyValue(session.rb,'user.passwordconfirm')#">
	      		</div>
	    	</div>
		</div>
		
		<div class="control-group">
      		<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.image')#</label>
	      	<div class="controls">
	      		<input type="file" name="newFile" validate="regex" regex="(.+)(\.)(jpg|JPG)" message="Your logo must be a .JPG" value=""/>
	        </div>
	        <cfif len(rc.userBean.getPhotoFileID())>
		        <div class="controls">
		        	<a href="./index.cfm?muraAction=cArch.imagedetails&userid=#rc.userBean.getUserID()#&siteid=#rc.userBean.getSiteID()#&fileid=#rc.userBean.getPhotoFileID()#"><img id="assocImage" src="#application.configBean.getContext()#/tasks/render/medium/index.cfm?fileid=#rc.userBean.getPhotoFileID()#&cacheID=#createUUID()#" /></a>
		        	<label class="checkbox inline"><input type="checkbox" name="removePhotoFile" value="true"> #application.rbFactory.getKeyValue(session.rb,'user.delete')#</label>
		        </div>
	        </cfif>
		</div>

	</div>

	<span id="extendSetsBasic"></span>
	
</div>

<div id="tabAddressinformation" class="tab-pane fade">
<cfsilent>
	<cfparam name="rc.address1" default=""/>
	<cfparam name="rc.address2" default=""/>
	<cfparam name="rc.city" default=""/>
	<cfparam name="rc.state" default=""/>
	<cfparam name="rc.zip" default=""/>
	<cfparam name="rc.country" default=""/>
	<cfparam name="rc.phone" default=""/>
	<cfparam name="rc.fax" default=""/>
	<cfparam name="rc.addressURL" default=""/>
	<cfparam name="rc.addressEmail" default=""/>
	<cfparam name="rc.hours" default=""/>
</cfsilent>
<div class="fieldset">	

<cfif rc.userid eq ''>
	
	<div class="control-group">
		<div class="span6">
	      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.address1')#</label>
	      <div class="controls"><input id="address1" name="address1" type="text" value="#HTMLEditFormat(rc.address1)#"  class="span12"></div>
	    </div>
			
		<div class="span6">
	      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.address2')#</label>
	      <div class="controls"><input id="address2" name="address2" type="text" value="#HTMLEditFormat(rc.address2)#"  class="span12"></div>
	    </div>
    </div>		

	<div class="control-group">
		<div class="span5">
	      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.city')#</label>
	      <div class="controls"><input id="city" name="city" type="text" value="#HTMLEditFormat(rc.city)#" class="span12"></div>
	    </div>
			
		<div class="span1">
	      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.state')#</label>
	      <div class="controls"><input id="state" name="state" type="text" value="#HTMLEditFormat(rc.state)#" class="span12"></div>
	    </div>
		
		<div class="span2">
	      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.zip')#</label>
	      <div class="controls"><input id="zip" name="zip" type="text" value="#HTMLEditFormat(rc.zip)#" class="span12"></div>
	    </div>
		
		<div class="span4">
	      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.country')#</label>
	      <div class="controls"><input id="country" name="country" type="text" value="#HTMLEditFormat(rc.country)#" class="span12"></div>
	    </div>
    </div>
		
	<div class="control-group">
		<div class="span6">
	      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.phone')#</label>
	      <div class="controls"><input id="phone" name="phone" type="text" value="#HTMLEditFormat(rc.phone)#" class="span12"></div>
	    </div>	
			
		<div class="span6">
	      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.fax')#</label>
	      <div class="controls"><input id="fax" name="fax" type="text" value="#HTMLEditFormat(rc.fax)#" class="span12"></div>
	    </div> 
	</div>		
	
	<div class="control-group">
		<div class="span6">
	      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.website')# (#application.rbFactory.getKeyValue(session.rb,'user.includehttp')#)</label>
	      <div class="controls"><input id="addressURL" name="addressURL" type="text" value="#HTMLEditFormat(rc.addressURL)#" class="span12"></div>
	    </div>
			
		<div class="span6">
	      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.email')#</label>
	      <div class="controls"><input id="addressEmail" name="addressEmail" validate="email" message="#application.rbFactory.getKeyValue(session.rb,'user.emailvalidate')#" type="text" value="#HTMLEditFormat(rc.addressEmail)#" class="span12"></div>
	    </div>
	</div>
		
	<div class="control-group">
      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.hours')#</label>
      <div class="controls"><textarea id="hours" name="hours" rows="6" class="span6" >#HTMLEditFormat(rc.hours)#</textarea></div>
    </div>

	<input type="hidden" name="isPrimary" value="1" />
		
	<cfelse>
		<div class="control-group">
			<ul class="navTask nav nav-pills"><li><a href="index.cfm?muraAction=cPrivateUsers.editAddress&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#&routeID=#rc.routeid#&addressID="><i class="icon-plus-sign"></i> #application.rbFactory.getKeyValue(session.rb,'user.addnewaddress')#</a></li></ul>
			<cfset rsAddresses=rc.userBean.getAddresses()>
		
			<cfif rsAddresses.recordcount>
				<table class="table table-condensed table-stripedtable-bordered mura-table-grid">
				<tr><th>#application.rbFactory.getKeyValue(session.rb,'user.primary')#</th><th>#application.rbFactory.getKeyValue(session.rb,'user.address')#</th><th class="adminstration"></th></tr>
				<cfloop query="rsAddresses">
				<tr>
					<td>
					<input type="radio" name="primaryAddressID" value="#rsAddresses.addressID#" <cfif rsAddresses.isPrimary eq 1 or rsAddresses.recordcount eq 1>checked</cfif>>
					</td>
					<td class="var-width">
					<cfif rsAddresses.addressName neq ''><a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?muraAction=cPrivateUsers.editAddress&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#&routeID=#URLEncodedFormat(rc.routeid)#&addressID=#rsAddresses.addressID#">#rsAddresses.addressName#</a><br /></cfif>
					<cfif rsAddresses.address1 neq ''>#HTMLEditFormat(rsAddresses.address1)#<br /></cfif>
					<cfif rsAddresses.address2 neq ''>#HTMLEditFormat(rsAddresses.address2)#<br /></cfif>
					<cfif rsAddresses.city neq ''>#HTMLEditFormat(rsAddresses.city)# </cfif><cfif rsAddresses.state neq ''><cfif rsaddresses.city neq ''>,</cfif> #HTMLEditFormat(rsAddresses.state)# </cfif><cfif rsaddresses.zip neq ''> #HTMLEditFormat(rsAddresses.zip)#</cfif><cfif rsAddresses.city neq '' or rsAddresses.state neq '' or rsAddresses.zip neq ''><br/></cfif>
					<cfif rsAddresses.phone neq ''>#application.rbFactory.getKeyValue(session.rb,'user.phone')#: #HTMLEditFormat(rsAddresses.phone)#<br/></cfif>
					<cfif rsAddresses.fax neq ''>#application.rbFactory.getKeyValue(session.rb,'user.fax')#: #HTMLEditFormat(rsAddresses.fax)#<br/></cfif>
					<cfif rsAddresses.addressURL neq ''>#application.rbFactory.getKeyValue(session.rb,'user.website')#: <a href="#rsAddresses.addressURL#" target="_blank">#HTMLEditFormat(rsAddresses.addressURL)#</a><br/></cfif>
					<cfif rsAddresses.addressEmail neq ''>#application.rbFactory.getKeyValue(session.rb,'user.email')#: <a href="mailto:#rsAddresses.addressEmail#">#HTMLEditFormat(rsAddresses.addressEmail)#</a></cfif>
					</td>
					<td nowrap class="actions"><ul class="users"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?muraAction=cPrivateUsers.editAddress&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#&routeID=#rc.routeid#&addressID=#rsAddresses.addressID#"><i class="icon-pencil"></i></a></li>
					<cfif rsAddresses.isPrimary neq 1><li class="delete"><a title="Delete" href="index.cfm?muraAction=cPrivateUsers.updateAddress&userid=#URLEncodedFormat(rc.userid)#&action=delete&siteid=#URLEncodedFormat(rc.siteid)#&routeID=#URLEncodedFormat(rc.routeid)#&addressID=#rsAddresses.addressID#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.deleteaddressconfirm'))#',this.href);"><i class="icon-remove-sign"></i></a></li><cfelse><li class="delete disabled">#application.rbFactory.getKeyValue(session.rb,'user.delete')#</li></cfif></ul></td>
				</tr>
				</cfloop>
				</table>
			<cfelse>
				<em>#application.rbFactory.getKeyValue(session.rb,'user.noaddressinformation')#</em>
			</cfif>
		</div>	
	</cfif>
</div>
</div>

<div id="tabGroupmemberships" class="tab-pane fade">
<div class="fieldset">
		
	<div class="control-group">
      <label class="control-label">
      	#application.rbFactory.getKeyValue(session.rb,'user.admingroups')#
      </label>
      <div class="controls">
			<cfloop query="rc.rsPrivateGroups">
				<label class="checkbox inline"><input name="groupid" type="checkbox" class="checkbox" value="#rc.rsPrivateGroups.UserID#" <cfif listfind(rc.userBean.getgroupid(),rc.rsPrivateGroups.UserID) or listfind(rc.groupid,rc.rsPrivateGroups.UserID)>checked</cfif>>#rc.rsPrivateGroups.groupname#</label>
			</cfloop>
		</div>
    	</div>
		
		<cfif rc.rsPublicGroups.recordcount>
		
		<div class="control-group">
     	 	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.membergroups')#</label>
      		<div class="controls">
			<cfloop query="rc.rsPublicGroups">
				<label class="checkbox inline"><input name="groupid" type="checkbox" class="checkbox" value="#rc.rsPublicGroups.UserID#" <cfif listfind(rc.userBean.getgroupid(),rc.rsPublicGroups.UserID) or listfind(rc.groupid,rc.rsPublicGroups.UserID)>checked</cfif>>#rc.rsPublicGroups.site# - #rc.rsPublicGroups.groupname#</label>
			</cfloop>
			</div>
    	</div>
		</cfif>
</div>
</div>	
<div id="tabInterests" class="tab-pane fade">
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
<div id="tabExtendedattributes" class="tab-pane fade">
		<span id="extendSetsDefault"></span>
		<script type="text/javascript">
		userManager.loadExtendedAttributes('#rc.userbean.getUserID()#','#rc.userbean.getType()#','#rc.userBean.getSubType()#','#userPoolID#','#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#');
		</script>	
</div>
<cfhtmlhead text='<script type="text/javascript" src="assets/js/user.js"></script>'>
</cfif>

<div id="tabAdvanced" class="tab-pane fade">
<div class="fieldset">

	<div class="control-group">
		<cfif listFind(session.mura.memberships,'S2')>
		<div class="span6">
     	 <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.superadminaccount')#</label>
     	 <div class="controls">
      	<label class="radio inline"><input name="s2" type="radio" class="radio inline" value="1" <cfif rc.userBean.gets2() eq 1>Checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.yes')#</label>
      	<label class="radio inline"><input name="s2" type="radio" class="radio inline" value="0" <cfif rc.userBean.gets2() eq 0>Checked</cfif>>
      		#application.rbFactory.getKeyValue(session.rb,'user.no')#
      		</label>
      		</div>
      	</div>
		</cfif>
		
		<div class="span6">
     	 <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.emailbroadcaster')#</label>
     	 <div class="controls">
     	 	<label class="radio inline"><input name="subscribe" type="radio" class="radio inline" value="1"<cfif rc.userBean.getsubscribe() eq 1>Checked</cfif>>Yes</label>
     	 	<label class="radio inline"><input name="subscribe" type="radio" class="radio inline" value="0"<cfif rc.userBean.getsubscribe() eq 0>Checked</cfif>>No</label>
     	 </div>
     	 </div>
    	</div>
		
		<div class="control-group">
			<div class="span6">
		     	 <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.inactive')#</label>
		     	 <div class="controls">
		      	<label class="radio inline"><input name="InActive" type="radio" class="radio inline" value="0"<cfif rc.userBean.getInActive() eq 0 >Checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.yes')#</label>
		      	<label class="radio inline"><input name="InActive" type="radio" class="radio inline" value="1"<cfif rc.userBean.getInActive() eq 1 >Checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.no')#</label>
		      	</div>
	      	</div>
		
		<div class="span6">
	     	 <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.usertype')#</label>
	     	 <div class="controls">
	      	<label class="radio inline"><input name="switchToPublic" type="radio" class="radio inline" value="1"> 
	      	#application.rbFactory.getKeyValue(session.rb,'user.sitemember')#</label><label class="radio inline">
	      	<input name="switchToPublic" type="radio" class="radio inline" value="0" Checked> 
	      	#application.rbFactory.getKeyValue(session.rb,'user.administrative')#</label>
	      	</div>
      	</div>
	</div>
		
		<div class="control-group">
		<div class="span6">
     	 <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.tags')#</label>
     	 <div class="controls"><input id="tags" name="tags" type="text" value="#HTMLEditFormat(rc.userBean.getTags())#" class="span12"></div>
     	 </div>
		<div class="span6">
     	 <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'user.remoteid')#</label>
      <div class="controls"><input id="remoteID" name="remoteID" type="text" value="#HTMLEditFormat(rc.userBean.getRemoteID())#"  class="span12"></div>
		</div>
    </div>
</div>		
</div>
	</cfoutput>
		<cfoutput query="rsPluginScripts" group="pluginID">
		<!---<cfset tabLabelList=tabLabelList & ",'#jsStringFormat(rsPluginScripts.name)#'"/>--->
		<cfset tabLabelList=listAppend(tabLabelList,rsPluginScripts.name)/>
		<cfset tabID="tab" & application.contentRenderer.createCSSID(rsPluginScripts.name)>
		<cfset tabList=listAppend(tabList,tabID)>
		<cfset pluginEvent.setValue("tabList",tabLabelList)>
			<div id="#tabID#" class="tab-pane fade">
			<cfoutput>
			<cfset rsPluginScript=application.pluginManager.getScripts("onUserEdit",rc.siteID,rsPluginScripts.moduleID)>
			<cfif rsPluginScript.recordcount>
			#application.pluginManager.renderScripts("onUserEdit",rc.siteid,pluginEvent,rsPluginScript)#
			<cfelse>
			<cfset rsPluginScript=application.pluginManager.getScripts("on#rc.type#Edit",rc.siteID,rsPluginScripts.moduleID)>
			#application.pluginManager.renderScripts("on#rc.type#Edit",rc.siteid,pluginEvent,rsPluginScript)#
			</cfif>
			</cfoutput>
			</div>
		</cfoutput>
</cfsavecontent>	
<cfoutput>	

<div class="tabbable tabs-left">
<ul class="nav nav-tabs tabs initActiveTab">
<cfloop from="1" to="#listlen(tabList)#" index="t">
<li<cfif listGetAt(tabList,t) eq 'tabExtendedattributes'> id="tabExtendedattributesLI" class="hide"</cfif>><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
</cfloop>
</ul>
<div class="tab-content">
#tabContent#
<div class="load-inline tab-preloader"></div>
<div class="form-actions">
	<cfif rc.userid eq ''>
		<input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'user.add')#" />
    <cfelse>
        <input type="button" class="btn" onclick="submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.deleteuserconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'user.delete')#" /> 
		<input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'user.update')#" />
	</cfif>
</div>
</div>
</div>
	
<input type="hidden" name="type" value="2">
<input type="hidden" name="action" value="">
<input type="hidden" name="contact" value="0">
<input type="hidden" name="groupid" value="">
<input type="hidden" name="ContactForm" value="">
<input type="hidden" name="isPublic" value="0">
<input type="hidden" name="returnurl" value="#HTMLEditFormat(rc.returnurl)#">
<cfif not rsNonDefault.recordcount><input type="hidden" name="subtype" value="Default"/></cfif>		
</cfoutput>

</form>